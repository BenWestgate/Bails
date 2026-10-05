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

# Retargeting a default-section prune value must leave network-specific
# overrides intact.
printf '%s\n' '#prune=123' 'prune=4000' '[main]' 'prune=7000' '[test]' 'prune=8000' >"$TEMPLATE"
set_template prune 5000
[ "$(awk '/^\[/{exit} /^prune=/{print}' "$TEMPLATE")" = 'prune=5000' ] ||
    fail 'default prune target not replaced'
[ "$(awk '$0=="[main]"{section=1; next} /^\[/{section=0} section && /^prune=/{print; exit}' "$TEMPLATE")" = 'prune=7000' ] ||
    fail '[main] prune override changed'
[ "$(awk '$0=="[test]"{section=1; next} /^\[/{section=0} section && /^prune=/{print; exit}' "$TEMPLATE")" = 'prune=8000' ] ||
    fail '[test] prune override changed'

# prune=1 is Bitcoin Core's manual RPC-controlled pruning mode. Even under
# severe space pressure it must not be converted into an automatic target or
# trigger a restart intended to apply a retargeted value.
printf '%s\n' 'prune=1' >"$TEMPLATE"
# shellcheck disable=SC2329
block_room() { echo 500; }
fit_prune
grep -qx 'prune=1' "$TEMPLATE" || fail 'manual prune mode was converted to automatic pruning'
prune_too_big && fail 'manual prune mode treated as an oversized automatic target'

# If the persistent template cannot be written, adopting a real data-directory
# config must fail before link_datadir_conf can replace the user's only copy.
rm -f "$DATA_DIR/bitcoin.conf" "$SESSION_CONF"
printf '%s\n' 'user-setting=keep-me' >"$DATA_DIR/bitcoin.conf"
not_a_dir="$work/not-a-directory"
: >"$not_a_dir"
TEMPLATE="$not_a_dir/bitcoin.conf"
refresh 2>/dev/null && fail 'refresh succeeded although custom-config adoption failed'
[ -f "$DATA_DIR/bitcoin.conf" ] && [ ! -L "$DATA_DIR/bitcoin.conf" ] ||
    fail "user's data-directory config was replaced after adoption failure"
grep -qx 'user-setting=keep-me' "$DATA_DIR/bitcoin.conf" ||
    fail "user's data-directory config changed after adoption failure"
[ ! -e "$SESSION_CONF" ] || fail 'session config was written after adoption failure'

printf '%s\n' 'core-dbcache review regressions: PASS'
