#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_data_home="$(mktemp -d)"
trap 'rm -rf -- "$test_data_home"' EXIT
export XDG_DATA_HOME="$test_data_home"
mkdir -p "$XDG_DATA_HOME/applications"
touch "$XDG_DATA_HOME/applications/bitcoin-qt.desktop"
# shellcheck disable=SC1091
. "$repo_root/bails/.local/bin/open-codex32"

assert_status() {
    local expected=$1
    local actual

    if core_is_compatible; then
        actual=0
    else
        actual=$?
    fi
    [ "$actual" -eq "$expected" ] || {
        echo "expected status $expected, got $actual" >&2
        exit 1
    }
}

assert_wait_status() {
    local expected=$1
    local attempts=$2
    local actual

    if wait_for_core "$attempts"; then
        actual=0
    else
        actual=$?
    fi
    [ "$actual" -eq "$expected" ] || {
        echo "expected wait status $expected, got $actual" >&2
        exit 1
    }
}

mock_status=0
mock_version=320000
# Called indirectly by core_is_compatible from the sourced launcher.
# shellcheck disable=SC2329
bitcoin-cli() {
    [ "$#" -eq 2 ] || return 1
    [ "$1" = "-datadir=/live/persistence/TailsData_unlocked/Persistent/.bitcoin" ] || return 1
    [ "$2" = "getnetworkinfo" ] || return 1
    ((mock_status == 0)) || return "$mock_status"
    printf '{"version": %s}\n' "$mock_version"
}

# Avoid delaying this unit test while exercising the retry loop.
# shellcheck disable=SC2329
sleep() { :; }

gio_calls=0
# Called indirectly by start_core from the sourced launcher.
# shellcheck disable=SC2329
gio() {
    [ "$#" -eq 2 ] || return 1
    [ "$1" = "launch" ] || return 1
    [ "$2" = "$BITCOIN_DESKTOP" ] || return 1
    gio_calls=$((gio_calls + 1))
}

start_core
[ "$gio_calls" -eq 1 ] || {
    echo "expected one Core desktop launch, got $gio_calls" >&2
    exit 1
}

rm -f -- "$BITCOIN_DESKTOP"
if start_core; then
    echo 'expected Core launch to fail without its desktop entry' >&2
    exit 1
fi

assert_status 0
mock_version=310100
assert_status 1
mock_status=1
assert_status 2

# Process detection must cover bitcoin-qt however it was launched, directly
# or through the old wrapper, without depending on a -datadir argument.
pgrep_args=()
pgrep_status=0
# Called indirectly by core_process_running from the sourced launcher.
# shellcheck disable=SC2329
pgrep() {
    pgrep_args=("$@")
    return "$pgrep_status"
}
core_process_running
[ "${#pgrep_args[@]}" -eq 5 ] &&
    [ "${pgrep_args[0]}" = '-u' ] &&
    [ "${pgrep_args[2]}" = '-f' ] &&
    [ "${pgrep_args[3]}" = '--' ] || {
    echo "unexpected managed-Core pgrep arguments: ${pgrep_args[*]}" >&2
    exit 1
}
for cmdline in '/live/persistence/TailsData_unlocked/dotfiles/.local/bin/bitcoin-qt -min -chain=main' \
    'bitcoin-qt %u' '/bin/bash /home/amnesia/.local/bin/wrapped bitcoin-qt -datadir=/x'; do
    grep -Eq -- "${pgrep_args[4]}" <<<"$cmdline" || {
        echo "managed-Core process match misses: $cmdline" >&2
        exit 1
    }
done
for cmdline in 'bitcoin-qt-helper' 'bitcoind -daemon'; do
    if grep -Eq -- "${pgrep_args[4]}" <<<"$cmdline"; then
        echo "managed-Core process match wrongly includes: $cmdline" >&2
        exit 1
    fi
done
pgrep_status=1
if core_process_running; then
    echo 'expected managed-Core process detection to propagate no-match status' >&2
    exit 1
fi

wait_calls=0
# Called indirectly by wait_for_core.
# shellcheck disable=SC2329
core_is_compatible() {
    wait_calls=$((wait_calls + 1))
    if ((wait_calls < 3)); then
        return 2
    fi
    return 0
}
assert_wait_status 0 3
[ "$wait_calls" -eq 3 ] || {
    echo "expected 3 Core probes, got $wait_calls" >&2
    exit 1
}

# Called indirectly by wait_for_core.
# shellcheck disable=SC2329
core_is_compatible() { return 2; }
assert_wait_status 2 2

# Called indirectly by wait_for_core.
# shellcheck disable=SC2329
core_is_compatible() { return 1; }
assert_wait_status 1 3

# The running-Core wait stops as soon as the observed process exits.
running_checks=0
# shellcheck disable=SC2329
core_is_compatible() { return 2; }
# shellcheck disable=SC2329
core_process_running() {
    running_checks=$((running_checks + 1))
    ((running_checks < 2))
}
if wait_for_running_core 3; then
    running_status=0
else
    running_status=$?
fi
[ "$running_status" -eq 3 ] || {
    echo "expected running-Core wait status 3 after process exit, got $running_status" >&2
    exit 1
}
[ "$running_checks" -eq 2 ] || {
    echo "expected two process checks before exit, got $running_checks" >&2
    exit 1
}

start_calls=0
wait_attempts=()

# Exercise the normal-launch grace period without starting a duplicate Core.
# shellcheck disable=SC2329
core_is_compatible() { return 2; }
# shellcheck disable=SC2329
wait_for_core() {
    wait_attempts+=("${1:-120}")
    return 0
}
# shellcheck disable=SC2329
start_core() {
    start_calls=$((start_calls + 1))
}
# shellcheck disable=SC2329
core_process_running() { return 1; }
ensure_core_ready false
[ "$start_calls" -eq 0 ] || {
    echo "expected no Core launch during RPC startup grace, got $start_calls" >&2
    exit 1
}
[ "${wait_attempts[*]}" = "5" ] || {
    echo "expected a 5-attempt startup grace, got: ${wait_attempts[*]}" >&2
    exit 1
}

# If the grace expires while Core is already running, wait for that process.
wait_attempts=()
# shellcheck disable=SC2329
wait_for_core() {
    wait_attempts+=("${1:-120}")
    if [ "${1:-120}" -eq 120 ]; then
        return 0
    fi
    return 2
}
# shellcheck disable=SC2329
core_process_running() { return 0; }
# shellcheck disable=SC2329
wait_for_running_core() {
    wait_attempts+=("running:${1:-120}")
    return 0
}
ensure_core_ready false
[ "$start_calls" -eq 0 ] || {
    echo "expected running Core not to be launched again, got $start_calls launches" >&2
    exit 1
}
[ "${wait_attempts[*]}" = "5 running:120" ] || {
    echo "expected grace then full wait for running Core, got: ${wait_attempts[*]}" >&2
    exit 1
}

# If that Core exits while RPC is still unavailable, start the managed Core.
wait_attempts=()
# shellcheck disable=SC2329
wait_for_running_core() {
    wait_attempts+=("running:${1:-120}")
    return 3
}
ensure_core_ready false
[ "$start_calls" -eq 1 ] || {
    echo "expected one Core launch after the running Core exited, got $start_calls" >&2
    exit 1
}
[ "${wait_attempts[*]}" = "5 running:120 120" ] || {
    echo "expected grace, running-Core wait, then launch wait, got: ${wait_attempts[*]}" >&2
    exit 1
}

# If no Core process exists after the grace period, launch it once and wait.
wait_attempts=()
# shellcheck disable=SC2329
core_process_running() { return 1; }
ensure_core_ready false
[ "$start_calls" -eq 2 ] || {
    echo "expected one Core launch after grace timeout, got $start_calls" >&2
    exit 1
}
[ "${wait_attempts[*]}" = "5 120" ] || {
    echo "expected grace then full wait after launch, got: ${wait_attempts[*]}" >&2
    exit 1
}

# The first-install handoff already owns Core startup, so never launch another.
wait_attempts=()
ensure_core_ready true
[ "$start_calls" -eq 2 ] || {
    echo "expected handoff not to launch another Core, got $start_calls" >&2
    exit 1
}
[ "${wait_attempts[*]}" = "120" ] || {
    echo "expected handoff to use the full wait, got: ${wait_attempts[*]}" >&2
    exit 1
}

printf '%s\n' 'open-codex32 Core probe: PASS'
