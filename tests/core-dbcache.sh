#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/bin" "$work/data"

fail() {
    echo "$*" >&2
    exit 1
}

# Fake total RAM for core-dbcache.
cat >"$work/bin/getconf" <<'SH'
#!/bin/bash
case $1 in
    PAGE_SIZE) echo 4096 ;;
    _PHYS_PAGES) echo $((FAKE_RAM_MIB * 256)) ;;
esac
SH
chmod +x "$work/bin/getconf"

run() {
    PATH="$work/bin:$PATH" "$repo_root/bails/.local/bin/core-dbcache" "$work/data"
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

# Leave Bitcoin Core's settings.json under Bitcoin Core's control.
printf '{\n    "dbcache": "6000",\n    "prune": "1907"\n}\n' >"$settings"
cp "$settings" "$work/settings.before"
run
cmp -s "$work/settings.before" "$settings" || fail 'settings.json changed'

printf '%s\n' 'core-dbcache: PASS'
