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
export TEMPLATE="$work/dotfiles/bitcoin.conf" SESSION_CONF="$work/home/bitcoin.conf"
# shellcheck disable=SC1091
. "$repo_root/bails/.local/bin/core-prune"
# shellcheck disable=SC1091
. "$repo_root/bails/.local/bin/core-config"
# shellcheck disable=SC1091
. "$repo_root/bails/.local/bin/core-dbcache"

tip="$STATE_DIR/bitcoin-core-tip"

# Keep calls in this shell so the fakes below are visible to the helpers.
function core-prune {
    case $1 in
        fit) fit_prune ;;
        value) template_prune ;;
    esac
}
function core-config { [ "$1" = refresh ] && refresh_config "${2:-}"; }

refresh_config() {
    adopt_datadir_conf || return 1
    [ -f "$TEMPLATE" ] || return 1
    prepare_template || return 1
    core-prune fit || return 1
    write_session_conf "$1" || return 1
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

# Far behind: the largest whole MiB at or below Core's warning cap,
# max(450 MiB, 3/4 of (RAM - 2 GiB)).
for case in 1024:450 2048:450 2648:450 3072:768 4096:1536 8192:4608 12288:7680 16384:10752 32768:23040; do
    FAKE_RAM_MIB=${case%%:*}
    got=$(wanted_dbcache)
    [ "$got" = "${case##*:}" ] || fail "RAM ${FAKE_RAM_MIB} MiB: dbcache=$got, want ${case##*:}"
done

# Tip within 14 days: let Core choose. Further behind: large again, even
# if the node was fully synced before it went unused.
FAKE_RAM_MIB=8192
touch -d '13 days ago' "$tip"
[ -z "$(wanted_dbcache)" ] || fail 'node 13 days behind should use Core default'
far_behind && fail 'node 13 days behind counted as far behind'
touch -d '15 days ago' "$tip"
[ "$(wanted_dbcache)" = 4608 ] || fail 'node 15 days behind should use large dbcache'
far_behind || fail 'node 15 days behind not counted as far behind'
touch -d '6 months ago' "$tip"
[ "$(wanted_dbcache)" = 4608 ] || fail 'node 6 months behind should use large dbcache'


# Record the block timestamp, not the current clock time.
cli() {
    case $1 in
        getbestblockhash) echo 00ab ;;
        getblockheader) [ "$2" = 00ab ] && echo '{"hash": "00ab", "time": 1700000000}' ;;
    esac
}
record_tip
[ "$(stat -c %Y "$tip")" = 1700000000 ] || fail 'tip marker not set to the tip block time'

# Start one per-user watcher; repeated calls must not duplicate it.
watch_running=0 starts=0
pgrep() { ((watch_running)); }
setsid() { starts=$((starts + 1)); }
start_watch
[ "$starts" = 1 ] || fail 'tip watcher did not start'
watch_running=1
start_watch
[ "$starts" = 1 ] || fail 'tip watcher started twice'

# The session copy in RAM gets dbcache; the persistent template never does.
# Remove CipherStick's obsolete core-started hook without touching a user's
# unrelated startupnotify setting.
printf '%s\n' 'startupnotify=core-started' 'startupnotify=/custom/hook' '#rpcport=<port>' 'datadir=/data' 'dbcache=9999' '[main]' >"$TEMPLATE"
refresh
refresh
grep -q dbcache "$TEMPLATE" && fail 'dbcache left in the persistent template'
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

# Near the tip, the session copy carries no dbcache, so Core picks its default.
touch "$tip"
refresh
grep -q dbcache "$SESSION_CONF" && fail 'node near the tip still given a dbcache'

# A session copy replaces a link to the template without changing the template.
rm -f "$SESSION_CONF"
ln -s "$TEMPLATE" "$SESSION_CONF"
cp "$TEMPLATE" "$work/template-before"
touch -d '15 days ago' "$tip"
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

# settings.json is Core's: CipherStick neither reads nor edits it.
settings="$DATA_DIR/settings.json"
printf '{\n    "dbcache": "6000",\n    "prune": "2000"\n}\n' >"$settings"
cp "$settings" "$work/settings-before"
refresh
cmp -s "$settings" "$work/settings-before" || fail 'settings.json edited'

# Refresh fails before touching configuration when the data directory is absent.
mv "$DATA_DIR" "$work/data-away"
cp "$TEMPLATE" "$work/template-before"
refresh && fail 'refresh succeeded without the data directory'
cmp -s "$TEMPLATE" "$work/template-before" || fail 'template changed without the data directory'
mv "$work/data-away" "$DATA_DIR"

# Without the template, refresh fails instead of leaving Core no config.
mv "$TEMPLATE" "$work/template-away"
rm -f "$DATA_DIR/bitcoin.conf"
refresh && fail 'refresh succeeded without the template'
mv "$work/template-away" "$TEMPLATE"

printf '%s\n' 'core-dbcache: PASS'
