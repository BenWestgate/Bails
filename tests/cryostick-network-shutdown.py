#!/usr/bin/env python3
"""Exercise the unsafe-login shutdown path without touching host networking."""

import os
from pathlib import Path
import signal
import subprocess
import tempfile
import time
import unittest


SOURCE = Path(__file__).resolve().parents[1] / 'bails/.local/bin/cryostick'
SCRIPT = SOURCE.read_text()
FUNCTION = ''
for name in ('cut_networking', 'shutdown_without_offline_mode'):
    body = SCRIPT.split(name + '() {', 1)[1].split('\n}\n', 1)[0]
    FUNCTION += name + '() {' + body + '\n}\n'
start = SCRIPT.index('if [ -e "$CRYOSTICK" ]; then\n    cut_networking')
BOOTSTRAP = SCRIPT[start:SCRIPT.index('make_cryostick=\n', start)]
BOOTSTRAP = BOOTSTRAP.replace('/usr/local/lib/tails-shell-library/tails-greeter.sh', '$TEST_GREETER')
BOOTSTRAP = BOOTSTRAP.replace('. ~/.profile', 'echo profile-loaded >> "$EVENTS"')



class ShutdownTest(unittest.TestCase):
    def run_shutdown(self, mode):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            events = root / 'events'
            marker = root / '.local/state/cryostick'
            marker.parent.mkdir(parents=True)
            if mode != 'unmarked':
                marker.touch()
            greeter = root / 'greeter.sh'
            greeter.write_text('echo greeter-loaded >> "$EVENTS"\n'
                               '[ "$MODE" != greeter-failed ] || return 1\n'
                               'tails_network_enabled() { [ "$MODE" != safe ]; }\n')
            # Every command that could affect the host is replaced. The real
            # timeout bounds hung controls; only the ten-second grace is sped up.
            stub = '''#!/bin/bash
name=${0##*/}
printf '%s %s\\n' "$name" "$*" >> "$EVENTS"
case "$name" in
    nmcli)
        case "$MODE" in
            denied) echo 'permission denied' >&2; exit 1 ;;
            stalled) trap '' TERM; /bin/sleep 30 ;;
        esac
        ;;
    zenity)
        case "$MODE" in
            dialog-failed) exit 1 ;;
            dialog-hung) /bin/sleep 30 ;;
        esac
        ;;
    pkill|stop-btc)
        if [ "$MODE" = cleanup-hung ]; then /bin/sleep 30; fi
        ;;
    sleep)
        [ "$1" = 10 ] || exit 99
        /bin/sleep 0.2
        echo grace-ended >> "$EVENTS"
        ;;
    systemctl)
        if [ "$MODE" = poweroff-failed ]; then exit 1; fi
        ;;
esac
'''
            for name in ('nmcli', 'zenity', 'pkill', 'stop-btc', 'sleep', 'systemctl'):
                path = root / name
                path.write_text(stub)
                path.chmod(0o755)
            cleanup = root / '.local/bin'
            cleanup.mkdir(parents=True)
            (cleanup / 'stop-btc').write_text(stub)
            (cleanup / 'stop-btc').chmod(0o755)
            env = dict(os.environ, TEST_GREETER=str(greeter), TEST_DOTFILES=str(root), PATH=f'{root}:/usr/bin:/bin', EVENTS=str(events), MODE=mode)
            process = subprocess.Popen(
                ['/bin/bash', '-c', 'DOTFILES="$TEST_DOTFILES"; CRYOSTICK="$DOTFILES/.local/state/cryostick"\n' + FUNCTION + BOOTSTRAP + '\nexit 77'],
                env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                start_new_session=True,
            )
            try:
                self.assertEqual(process.wait(timeout=5), 77 if mode in ('safe', 'unmarked') else 1)
                # A failed poweroff launches a final asynchronous warning.
                if mode == 'poweroff-failed':
                    deadline = time.monotonic() + 1
                    while 'CryoStick could not shut down' not in events.read_text():
                        self.assertLess(time.monotonic(), deadline)
                        time.sleep(0.01)
                lines = events.read_text().splitlines()
            finally:
                # Reap only our isolated group, including intentionally hung stubs.
                try:
                    os.killpg(process.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
                process.wait()
            return lines

    def test_shutdown_survives_failed_or_stalled_components(self):
        for mode in ('success', 'denied', 'stalled', 'dialog-failed', 'dialog-hung', 'cleanup-hung', 'greeter-failed'):
            with self.subTest(mode=mode):
                lines = self.run_shutdown(mode)
                first = '\n'.join(lines)
                for request in ('nmcli networking off', 'nmcli radio all off'):
                    self.assertIn(request, lines)
                    self.assertLess(lines.index(request), lines.index('greeter-loaded'))
                    self.assertNotIn('profile-loaded', lines)
                    self.assertLess(lines.index(request), next(i for i, line in enumerate(lines) if line.startswith('zenity ')))
                for request in ('pkill -x tca', 'stop-btc '):
                    self.assertIn(request, lines)
                    self.assertLess(lines.index(request), lines.index('grace-ended'))
                self.assertIn('sleep 10', lines)
                self.assertIn('systemctl --no-ask-password --no-block poweroff', lines)
                self.assertLess(lines.index('grace-ended'), lines.index('systemctl --no-ask-password --no-block poweroff'))
                self.assertIn('Disconnect network cables now.', first)
                if mode in ('denied', 'stalled'):
                    self.assertIn('Some network controls failed.', first)
                self.assertNotIn('sudo', first)

    def test_offline_and_unmarked_startup(self):
        safe = self.run_shutdown('safe')
        self.assertIn('nmcli networking off', safe)
        self.assertIn('profile-loaded', safe)
        unmarked = self.run_shutdown('unmarked')
        self.assertEqual(unmarked, ['greeter-loaded', 'profile-loaded'])
        self.assertFalse(any(line.startswith('systemctl ') for line in safe))

    def test_failed_poweroff_warns_user(self):
        self.assertIn('Keep network cables disconnected and turn off this computer now.', '\n'.join(self.run_shutdown('poweroff-failed')))


if __name__ == '__main__':
    unittest.main()
