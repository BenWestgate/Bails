#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/bin" "$work/data" "$work/state"

fail() {
    echo "$*" >&2
    exit 1
}

# Fake total RAM and running processes for core-dbcache.
cat >"$work/bin/getconf" <<'SH'
#!/bin/bash
case $1 in
    PAGE_SIZE) echo 4096 ;;
    _PHYS_PAGES) echo $((FAKE_RAM_MIB * 256)) ;;
esac
SH
cat >"$work/bin/pgrep" <<'SH'
#!/bin/bash
[ "${FAKE_CORE_RUNNING:-0}" = 1 ]
SH
chmod +x "$work/bin/getconf" "$work/bin/pgrep"

run() {
    PATH="$work/bin:$PATH" "$repo_root/bails/.local/bin/core-dbcache" "$work/data" "$work/state"
}

conf="$work/data/bitcoin.conf"
settings="$work/data/settings.json"

# Bitcoin Core warns when dbcache > max(450 MiB, 3/4 of (RAM - 2 GiB)).
# Expect the largest whole MiB at or below that cap.
for case in 1024:450 2048:450 2648:450 4096:1536 8192:4608 16384:10752 32768:23040; do
    export FAKE_RAM_MIB=${case%%:*}
    printf '%s\n' '#rpcport=<port>' '[main]' >"$conf"
    run
    got=$(sed -n 's/^dbcache=//p' "$conf")
    [ "$got" = "${case##*:}" ] || fail "RAM ${FAKE_RAM_MIB} MiB: dbcache=$got, want ${case##*:}"
done

# The setting stays first, before any network section, and is not duplicated.
export FAKE_RAM_MIB=8192
run
run
[ "$(grep -c '^dbcache=' "$conf")" = 1 ] || fail 'dbcache duplicated'
sed -n 2p "$conf" | grep -qx 'dbcache=4608' || fail 'dbcache is not before network sections'
grep -qx '\[main\]' "$conf" || fail 'existing config lost'

# Old CipherStick dbcache in settings.json is removed once, keeping other keys.
rm -f "$work/state/dbcache-in-bitcoin-conf"
printf '{\n    "dbcache": "6000",\n    "prune": "1907"\n}\n' >"$settings"
FAKE_CORE_RUNNING=1 run
grep -q dbcache "$settings" || fail 'migrated while Bitcoin Core was running'
run
python3 -c 'import json, sys; s = json.load(open(sys.argv[1])); assert s == {"prune": "1907"}, s' "$settings" ||
    fail 'old dbcache not removed cleanly'

# After that one migration, a dbcache the user sets in Core's options is kept.
printf '{\n    "dbcache": "3000"\n}\n' >"$settings"
run
grep -q '"dbcache": "3000"' "$settings" || fail 'user dbcache removed after migration'

printf '%s\n' 'core-dbcache: PASS'
