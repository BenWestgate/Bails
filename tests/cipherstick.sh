#!/bin/bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Exercise the login entry point through config preparation with fake Tails
# and Core commands. Leave the user's profile and later desktop work out.
awk '/^\. "\/home\// {next} /^core-dbcache start/ {exit} {print}' \
    "$repo_root/bails/.local/bin/cipherstick" >"$work/login"

run_login() (
    # shellcheck disable=SC2317,SC2329
    cryostick() { echo cryostick >>"$work/calls"; return "$cryo_status"; }
    # shellcheck disable=SC2317,SC2329
    persistent-setup() { echo setup >>"$work/calls"; return "$setup_status"; }
    # shellcheck disable=SC2317,SC2329
    core-dbcache() { echo "$*" >>"$work/calls"; return "$refresh_status"; }
    # shellcheck disable=SC2317,SC2329
    setsid() { echo start >>"$work/calls"; }
    # shellcheck disable=SC1091
    . "$work/login"
    echo "cryo=${cryo:-}" >>"$work/calls"
)
check_calls() {
    [ "$(tr '\n' ' ' <"$work/calls")" = "$1" ] || {
        echo "unexpected login calls: $(cat "$work/calls")" >&2
        exit 1
    }
}
cryo_status=1 setup_status=0 refresh_status=0
: >"$work/calls"
run_login
check_calls 'cryostick setup refresh start cryo= '
# A CryoStick gets the same Core start, and is marked for the offline steps.
cryo_status=0
: >"$work/calls"
run_login
check_calls 'cryostick setup refresh start cryo=1 '
setup_status=1
: >"$work/calls"
if run_login; then echo 'login continued after setup failure' >&2; exit 1; fi
check_calls 'cryostick setup '
setup_status=0 refresh_status=1
: >"$work/calls"
if run_login; then echo 'login started Core after config failure' >&2; exit 1; fi
check_calls 'cryostick setup refresh '
printf '%s\n' 'cipherstick: PASS'
