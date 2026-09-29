#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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

assert_status 0
mock_version=310100
assert_status 1
mock_status=1
assert_status 2

printf '%s\n' 'open-codex32 Core probe: PASS'
