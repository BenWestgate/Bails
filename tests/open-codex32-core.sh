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

assert_status 0
mock_version=310100
assert_status 1
mock_status=1
assert_status 2

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

printf '%s\n' 'open-codex32 Core probe: PASS'
