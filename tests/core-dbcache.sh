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
export AUTOSTART="$work/home/bitcoin.desktop"
# shellcheck disable=SC1091
. "$repo_root/bails/.local/bin/core-dbcache"

# Fakes for the system and Bitcoin Core, called from the sourced functions.
# shellcheck disable=SC2329
getconf() { [ "$1" = PAGE_SIZE ] && echo 4096 || echo $((FAKE_RAM_MIB * 256)); }
# shellcheck disable=SC2317,SC2329
core_pid() { ((core_running)) && echo 4242; }
core_running=0
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

tip="$STATE_DIR/bitcoin-core-tip"
settings="$DATA_DIR/settings.json"

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
[ "$(effective_prune)" = 0 ] || fail 'unpruned node not reported as unpruned'
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

# settings.json is Core's: CipherStick never edits it, and a prune target set
# in Core's options wins.
printf '{\n    "dbcache": "6000",\n    "prune": "2000"\n}\n' >"$settings"
cp "$settings" "$work/settings-before"
core_running=0
refresh
cmp -s "$settings" "$work/settings-before" || fail 'settings.json edited'
[ "$(effective_prune)" = 2000 ] || fail "user's prune target not reported"

# At login, Core started by its own autostart keeps running on its default
# dbcache, unless the template's prune target could fill the USB stick.
# shellcheck disable=SC2329
stop-btc() { core_running=0; echo stop >>"$work/calls"; }
# shellcheck disable=SC2329
setsid() { echo start >>"$work/calls"; }
login_with() { # $1: settings.json, $2: Core running, $3: MiB for blocks, $4: optional login mode
    : >"$work/calls"
    printf '%s\n' "$1" >"$settings"
    cp "$settings" "$work/settings-before"
    core_running=$2 FAKE_ROOM_MIB=$3
    login "${4:-}"
    calls=$(tr '\n' ' ' <"$work/calls")
    cmp -s "$settings" "$work/settings-before" || fail 'settings.json edited at login'
}
sed -i 's/^prune=.*/prune=4000/' "$TEMPLATE"
login_with '{"dbcache": "6000"}' 1 100000
[ -z "$calls" ] || fail "a dbcache in settings.json restarted Core: $calls"
login_with '{}' 1 100000
[ -z "$calls" ] || fail "Core restarted only for starting before CipherStick: $calls"
login_with '{}' 1 4500
[ "$calls" = 'stop start ' ] || fail "template prune target too big for the stick did not restart Core: $calls"
grep -qx 'prune=1907' "$TEMPLATE" || fail 'prune target not lowered on restart'
grep -qx 'prune=1907' "$SESSION_CONF" || fail 'session copy lacks the lowered prune target'
sed -i 's/^prune=.*/prune=4000/' "$TEMPLATE"
login_with '{"prune": "9000"}' 1 4500
[ -z "$calls" ] || fail "a prune target in settings.json restarted Core: $calls"
sed -i 's/^prune=.*/prune=4000/' "$TEMPLATE"
login_with '{}' 0 4500
[ -z "$calls" ] || fail "Core started at login although it was not running: $calls"
# A dbcache an older CipherStick left in the template, sized for another
# computer, restarts Core so it drops that value.
sed -i '1i dbcache=9999' "$TEMPLATE"
login_with '{}' 1 100000
[ "$calls" = 'stop start ' ] || fail "Core kept a dbcache left in the template: $calls"
grep -q '^dbcache=' "$TEMPLATE" && fail 'dbcache left in the template at login'
# Core started while the user's own config was still in the data directory
# hit Core's config error, so it is restarted; once adopted, it is left alone.
cp "$TEMPLATE" "$work/template-saved"
rm -f "$DATA_DIR/bitcoin.conf"
echo 'user=1' >"$DATA_DIR/bitcoin.conf"
login_with '{}' 1 100000 2>/dev/null
[ "$calls" = 'stop start ' ] || fail "Core started before the user's config was adopted kept running: $calls"
login_with '{}' 1 100000
[ -z "$calls" ] || fail "Core restarted with the user's config already adopted: $calls"
cp "$work/template-saved" "$TEMPLATE"
# Core's autostart starting Core after the first check, while refresh runs,
# still gets a restart.
core_checks=0
# shellcheck disable=SC2317,SC2329
core_pid() { ((core_checks++)) && echo 4242; }
sed -i 's/^prune=.*/prune=4000/' "$TEMPLATE"
login_with '{}' 0 4500
[ "$calls" = 'stop start ' ] || fail "Core started during refresh kept a prune target too big for the stick: $calls"
# shellcheck disable=SC2317,SC2329
core_pid() { ((core_running)) && echo 4242; }
# Core's autostart may already have stopped on the user's config error before
# login looked. With the autostart on, login waits briefly, then starts Core.
# shellcheck disable=SC2329
sleep() { :; }
printf '%s\n' '[Desktop Entry]' 'Exec=bitcoin-qt -min' >"$AUTOSTART"
rm -f "$DATA_DIR/bitcoin.conf"
echo 'user=1' >"$DATA_DIR/bitcoin.conf"
login_with '{}' 0 100000 2>/dev/null
[ "$calls" = 'start ' ] || fail "Core stopped by the user's config error was not started again: $calls"
cp "$work/template-saved" "$TEMPLATE"
# If Core's autostart starts it during that wait, it read the fixed config.
core_checks=0
# shellcheck disable=SC2317,SC2329
core_pid() { ((core_checks++ > 2)) && echo 4242; }
rm -f "$DATA_DIR/bitcoin.conf"
echo 'user=1' >"$DATA_DIR/bitcoin.conf"
login_with '{}' 0 100000 2>/dev/null
[ -z "$calls" ] || fail "Core started twice after the user's config was adopted: $calls"
cp "$work/template-saved" "$TEMPLATE"
# shellcheck disable=SC2317,SC2329
core_pid() { ((core_running)) && echo 4242; }
# If Persistent Folder was off, replay Core's missed desktop autostart only
# after setup restored it. Do not duplicate a Core that is already running.
login_with '{}' 0 100000 missed-autostart
[ "$calls" = 'start ' ] || fail "missed Core autostart was not replayed: $calls"
login_with '{}' 1 100000 missed-autostart
[ -z "$calls" ] || fail "missed-autostart mode duplicated a running Core: $calls"
# With its autostart off, Core is left for the user to start.
echo 'Hidden=true' >>"$AUTOSTART"
rm -f "$DATA_DIR/bitcoin.conf"
echo 'user=1' >"$DATA_DIR/bitcoin.conf"
login_with '{}' 0 100000 2>/dev/null
[ -z "$calls" ] || fail "Core started at login with its autostart off: $calls"
cp "$work/template-saved" "$TEMPLATE"
rm -f "$AUTOSTART"
# The Persistent Folder is mandatory and persistent-setup runs before login.
# Still fail safely if the data directory is unexpectedly unavailable.
mv "$DATA_DIR" "$work/data-away"
sed -i 's/^prune=.*/prune=4000/' "$TEMPLATE"
: >"$work/calls"
core_running=1 FAKE_ROOM_MIB=0
login && fail 'login succeeded without the data directory'
grep -qx 'prune=4000' "$TEMPLATE" || fail 'prune target changed without the data directory'
[ ! -s "$work/calls" ] || fail "Core restarted without the data directory: $(cat "$work/calls")"
mv "$work/data-away" "$DATA_DIR"

# The watcher stamps the marker with the tip block's time, not the clock's.
# shellcheck disable=SC2329
cli() {
    case $1 in
        getbestblockhash) echo 00ab ;;
        getblockheader) [ "$2" = 00ab ] && echo '{"hash": "00ab", "time": 1700000000}' ;;
    esac
}
# shellcheck disable=SC2329
sleep() { ((++sleeps < 2)); }
core_running=1 sleeps=0
watch
[ "$(stat -c %Y "$tip")" = 1700000000 ] || fail 'tip marker not set to the tip block time'

printf '%s\n' 'core-dbcache: PASS'
