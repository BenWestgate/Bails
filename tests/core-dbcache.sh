#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/data" "$work/state" "$work/dotfiles" "$work/home"

fail() {
    echo "$*" >&2
    exit 1
}

export DATA_DIR="$work/data" STATE_DIR="$work/state"
export TEMPLATE="$work/dotfiles/bitcoin.conf" SESSION_CONF="$work/home/bitcoin.conf" CORE_DOWNLOADS="$work/downloads"
# shellcheck disable=SC1091
. "$repo_root/bails/.local/bin/core-prune"
# shellcheck disable=SC1091
. "$repo_root/bails/.local/bin/core-config"
# shellcheck disable=SC1091
. "$repo_root/bails/.local/bin/core-dbcache"

behind="$STATE_DIR/bitcoin-core-behind"
mkdir -p "$DATA_DIR/blocks"

# Keep calls in this shell so the fakes below are visible to the helpers.
function core-prune {
    case $1 in
        fit) fit_prune ;;
        low-space) low_space ;;
        new) new_prune ;;
    esac
}
function core-config { [ "$1" = refresh ] && shift && refresh_config "$@"; }

refresh_config() {
    adopt_datadir_conf || return 1
    [ -f "$TEMPLATE" ] || restore_template || return 1
    prepare_template || return 1
    core-prune fit || return 1
    write_session_conf "$@" || return 1
    link_datadir_conf
}

# Fakes for the system and Bitcoin Core, called from the sourced functions.
# shellcheck disable=SC2329
getconf() { [ "$1" = PAGE_SIZE ] && echo 4096 || echo $((FAKE_RAM_MIB * 256)); }
# MiB the block files and chainstate could use: what the block files use
# now plus the free space.
# shellcheck disable=SC2329
disk_room() { echo "$FAKE_ROOM_MIB"; }
FAKE_ROOM_MIB=100000
# Before Core creates the chainstate, it counts as empty.
[ "$(chainstate_mib)" = 0 ] || fail 'missing chainstate not counted as 0 MiB'
# shellcheck disable=SC2329
chainstate_mib() { echo "$FAKE_CHAINSTATE_MIB"; }
FAKE_CHAINSTATE_MIB=0
# Core's chainstate estimate, as install-core records it. 0 GB reserves
# nothing, so most tests below see all the room as block room.
printf 'chain_state_gb=0\nblockchain_gb=0\n' >"$STATE_DIR/core-assumed-sizes"

# The largest whole MiB at or below Core's warning cap,
# max(450 MiB, 3/4 of (RAM - 2 GiB)).
for case in 1024:450 2048:450 2648:450 3072:768 4096:1536 8192:4608 12288:7680 16384:10752 32768:23040; do
    FAKE_RAM_MIB=${case%%:*}
    got=$(warning_cap)
    [ "$got" = "${case##*:}" ] || fail "RAM ${FAKE_RAM_MIB} MiB: dbcache=$got, want ${case##*:}"
done
FAKE_RAM_MIB=8192

# Behind: no blocks yet, still marked, or the blocks folder unused for over
# 14 days, even if the node was fully synced before it went unused.
far_behind || fail 'node without blocks not counted as behind'
touch "$DATA_DIR/blocks/blk00001.dat"
far_behind && fail 'node with recent blocks counted as behind'
touch "$behind"
far_behind || fail 'marked node not counted as behind'
rm "$behind"
touch -d '13 days ago' "$DATA_DIR/blocks"
far_behind && fail 'node used 13 days ago counted as behind'
touch -d '15 days ago' "$DATA_DIR/blocks"
far_behind || fail 'node unused for 15 days not counted as behind'

# The session copy in RAM gets dbcache and the marker; the persistent
# template gets neither. Core clears the marker after initial block
# download. Remove CipherStick's obsolete core-started hook without touching
# a user's unrelated startupnotify setting.
printf '%s\n' 'startupnotify=core-started' 'startupnotify=/custom/hook' '#rpcport=<port>' 'datadir=/data' '[main]' >"$TEMPLATE"
refresh
refresh
[ -e "$behind" ] || fail 'behind node not marked'
grep -q 'dbcache\|blocknotify' "$TEMPLATE" && fail 'session settings left in the persistent template'
grep -q 'core-started' "$TEMPLATE" && fail 'legacy core-started hook left in template'
[ "$(grep -c '^startupnotify=/custom/hook$' "$TEMPLATE")" = 1 ] || fail "user's startupnotify setting changed"
grep -qx 'datadir=/data' "$TEMPLATE" || fail 'template setting lost'
grep -qx '\[main\]' "$TEMPLATE" || fail 'template network section lost'
[ ! -L "$SESSION_CONF" ] || fail 'session config is still a link to the template'
[ "$(grep -c '^dbcache=' "$SESSION_CONF")" = 1 ] || fail 'session dbcache missing or duplicated'
sed -n 1p "$SESSION_CONF" | grep -qx 'dbcache=4608' || fail 'dbcache not before network sections'
[ "$(readlink "$DATA_DIR/bitcoin.conf")" = "$SESSION_CONF" ] || fail 'data directory config not linked to the session copy'
grep -qx 'datadir=/data' "$SESSION_CONF" || fail 'session config lacks template settings'
[ "$(grep -c '^startupnotify=/custom/hook$' "$SESSION_CONF")" = 1 ] || fail "session copy lost user's startupnotify"
sh -c "$(sed -n 's/^blocknotify=//p' "$SESSION_CONF")"
[ ! -e "$behind" ] || fail "Core's block notification left the marker"

# Caught up, the session copy carries no dbcache, so Core picks its default.
touch "$DATA_DIR/blocks"
refresh
grep -q 'dbcache\|blocknotify' "$SESSION_CONF" && fail 'caught-up node still given session settings'

# A dbcache the user set in the template wins over CipherStick's.
rm -f "$DATA_DIR/blocks/blk00001.dat"
echo 'dbcache=300' >>"$TEMPLATE"
refresh
[ "$(grep -c '^dbcache=' "$SESSION_CONF")" = 1 ] || fail "dbcache added despite the user's own"
grep -qx 'dbcache=300' "$SESSION_CONF" || fail "user's dbcache lost"
sed -i '/^dbcache=/d' "$TEMPLATE"

# A session copy replaces a link to the template without changing the template.
rm -f "$SESSION_CONF"
ln -s "$TEMPLATE" "$SESSION_CONF"
cp "$TEMPLATE" "$work/template-before"
refresh
[ ! -L "$SESSION_CONF" ] || fail 'link to the template not replaced'
cmp -s "$TEMPLATE" "$work/template-before" || fail 'writing the session copy changed the template'

# A real bitcoin.conf in the data directory is the user's own: it becomes the
# template, with the datadir line launchers no longer pass, and the old
# template is kept.
cp "$TEMPLATE" "$work/template-saved"
rm -f "$DATA_DIR/bitcoin.conf"
printf '%s\n' 'startupnotify=/user/hook' 'user=1' '[main]' >"$DATA_DIR/bitcoin.conf"
refresh 2>/dev/null
grep -qx 'user=1' "$TEMPLATE" || fail "user's own config not made the template"
[ "$(grep -n '^datadir=' "$TEMPLATE" | cut -d: -f1)" -lt "$(grep -n '^\[main\]' "$TEMPLATE" | cut -d: -f1)" ] ||
    fail 'datadir not added before network sections'
grep -qx "datadir=$DATA_DIR" "$TEMPLATE" || fail 'datadir missing from adopted config'
cmp -s "$TEMPLATE.before-datadir-conf" "$work/template-saved" || fail 'old template not kept'
[ "$(readlink "$DATA_DIR/bitcoin.conf")" = "$SESSION_CONF" ] || fail "data directory config not linked after adopting the user's"
grep -qx 'user=1' "$SESSION_CONF" || fail "session copy lacks the user's settings"
grep -qx 'startupnotify=/user/hook' "$SESSION_CONF" || fail "session copy changed the user's startupnotify"
printf 'datadir=%s\nuser=2\n' /elsewhere >"$work/conf"
rm -f "$DATA_DIR/bitcoin.conf"
cp "$work/conf" "$DATA_DIR/bitcoin.conf"
refresh 2>/dev/null
[ "$(grep -c '^datadir=' "$TEMPLATE")" = 1 ] || fail "datadir added although the user's config sets one"
cp "$work/template-saved" "$TEMPLATE"
refresh

# Each start retargets the persisted prune target to leave 10 GiB free when
# it would leave more than 11 GiB or less than 1 GiB free, never below
# 1907 MiB. Unpruned stays unpruned.
prune_after() { # $1: template target, $2: MiB for blocks; prints new target
    sed -i '/^prune=/d' "$TEMPLATE"
    sed -i "1i prune=$1" "$TEMPLATE"
    FAKE_ROOM_MIB=$2
    refresh
    [ "$(grep -c '^prune=' "$TEMPLATE")" = 1 ] || fail 'prune target duplicated in template'
    template_prune
}
[ "$(prune_after 20000 30000)" = 20000 ] || fail 'prune target changed with 10 GiB free'
[ "$(prune_after 20000 31000)" = 20000 ] || fail 'prune target raised with under 11 GiB free'
[ "$(prune_after 20000 32000)" = 21760 ] || fail 'prune target not raised with over 11 GiB free'
[ "$(prune_after 20000 21500)" = 20000 ] || fail 'prune target lowered with over 1 GiB free'
[ "$(prune_after 20000 20500)" = 10260 ] || fail 'prune target not lowered with under 1 GiB free'
grep -qx 'prune=10260' "$SESSION_CONF" || fail 'session copy lacks the new prune target'
[ "$(prune_after 4000 4500)" = 1907 ] || fail 'prune target lowered below 1907 MiB'
[ "$(prune_after 0 500000)" = 0 ] || fail 'unpruned node given a prune target'
[ "$(template_prune)" = 0 ] || fail 'unpruned node not reported as unpruned'
# During initial sync, the chainstate's remaining growth to Core's estimate
# (14 GB = 13351 MiB, 12351 MiB to go here) is not block room.
printf 'chain_state_gb=14\nblockchain_gb=0\n' >"$STATE_DIR/core-assumed-sizes"
FAKE_CHAINSTATE_MIB=1000
[ "$(prune_after 20000 43000)" = 20000 ] || fail 'prune target raised into the chainstate reserve'
[ "$(prune_after 20000 45000)" = 22409 ] || fail 'prune target not raised past the chainstate reserve'
[ "$(prune_after 20000 32000)" = 9409 ] || fail 'prune target not lowered for the chainstate reserve'
FAKE_CHAINSTATE_MIB=20000
[ "$(prune_after 20000 32000)" = 21760 ] || fail 'full chainstate still reserved'
# Without the estimate, the target is only lowered.
mv "$STATE_DIR/core-assumed-sizes" "$work/sizes"
[ "$(prune_after 20000 40000)" = 20000 ] || fail 'prune target raised without the chainstate estimate'
[ "$(prune_after 20000 20500)" = 10260 ] || fail 'prune target not lowered without the chainstate estimate'
mv "$work/sizes" "$STATE_DIR/core-assumed-sizes"
printf 'chain_state_gb=0\nblockchain_gb=0\n' >"$STATE_DIR/core-assumed-sizes"
FAKE_CHAINSTATE_MIB=0
FAKE_ROOM_MIB=100000

# settings.json is Core's: CipherStick never edits it.
settings="$DATA_DIR/settings.json"
printf '{\n    "dbcache": "6000",\n    "prune": "2000"\n}\n' >"$settings"
cp "$settings" "$work/settings-before"
refresh
cmp -s "$settings" "$work/settings-before" || fail 'settings.json edited'
# The low-space warning follows Core's Options window over the template.
[ "$(effective_prune)" = 2000 ] || fail "settings.json prune not used"
printf '{\n    "prune": 0\n}\n' >"$settings"
[ "$(effective_prune)" = 0 ] || fail "pruning turned off in Core's options not seen"
rm "$settings"
[ "$(effective_prune)" = "$(template_prune)" ] || fail 'template prune not used without settings.json'
# Warn under 10 GB free when pruning is off, manual, or too high to keep
# 10 GiB free, whether the template or settings.json sets it.
# shellcheck disable=SC2317,SC2329
df() { printf 'Avail\n%s\n' "$FAKE_FREE_KB"; }
FAKE_FREE_KB=20000000 FAKE_ROOM_MIB=30000
printf '{"prune": 0}\n' >"$settings"
low_space && fail 'warned with over 10 GB free'
FAKE_FREE_KB=9000000
low_space || fail 'no warning with pruning off in settings.json'
printf '{"prune": 1}\n' >"$settings"
low_space || fail 'no warning with manual pruning'
printf '{"prune": 25000}\n' >"$settings"
low_space || fail 'no warning with a prune target too high for the stick'
printf '{"prune": 19000}\n' >"$settings"
low_space && fail 'warned with a prune target that keeps 10 GiB free'
rm "$settings"
sed -i '/^prune=/d' "$TEMPLATE"
low_space || fail 'no warning with pruning off in the template'
unset -f df
FAKE_ROOM_MIB=100000

# Refresh fails before touching configuration when the data directory is absent.
mv "$DATA_DIR" "$work/data-away"
cp "$TEMPLATE" "$work/template-before"
refresh && fail 'refresh succeeded without the data directory'
cmp -s "$TEMPLATE" "$work/template-before" || fail 'template changed without the data directory'
mv "$work/data-away" "$DATA_DIR"

# A missing template is rebuilt from the newest Core download with
# CipherStick's settings, so Core never falls back to ~/.bitcoin. Without a
# download, refresh fails instead.
mv "$TEMPLATE" "$work/template-away"
rm -f "$DATA_DIR/bitcoin.conf"
refresh 2>/dev/null && fail 'refresh succeeded without the template or a Core download'
mkdir -p "$work/tar/bitcoin-29.0" "$CORE_DOWNLOADS/bitcoin-core-29.0"
printf '%s\n' '# Example' '#prune=<n>' >"$work/tar/bitcoin-29.0/bitcoin.conf"
tar -czf "$CORE_DOWNLOADS/bitcoin-core-29.0/bitcoin-29.0-x86_64-linux-gnu.tar.gz" -C "$work/tar" bitcoin-29.0
refresh 2>/dev/null || fail 'missing template not rebuilt'
grep -qx "datadir=$DATA_DIR" "$TEMPLATE" || fail 'rebuilt template lacks the datadir'
grep -qx 'proxy=127.0.0.1:9050' "$TEMPLATE" || fail 'rebuilt template lacks the Tor proxy'
grep -qx '# Example' "$TEMPLATE" || fail "rebuilt template lacks Core's example"
grep -qx 'prune=0' "$TEMPLATE" || fail 'unpruned node rebuilt as pruned'
grep -qx "datadir=$DATA_DIR" "$SESSION_CONF" || fail 'session copy lacks the rebuilt datadir'
# A stick too small for the whole block chain is rebuilt pruned.
rm -f "$TEMPLATE" "$DATA_DIR/bitcoin.conf"
printf 'chain_state_gb=0\nblockchain_gb=600\n' >"$STATE_DIR/core-assumed-sizes"
refresh 2>/dev/null || fail 'missing template not rebuilt for a small stick'
[ "$(template_prune)" -gt 1 ] || fail 'small stick rebuilt as unpruned'
printf 'chain_state_gb=0\nblockchain_gb=0\n' >"$STATE_DIR/core-assumed-sizes"
mv "$work/template-away" "$TEMPLATE"

printf '%s\n' 'core-dbcache: PASS'
