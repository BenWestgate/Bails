#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
welcome="$repo_root/bails/.local/bin/core-welcome-text"
fixtures="$repo_root/tests/fixtures/core-intro"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

fail() {
    echo "$*" >&2
    exit 1
}

expect_text() {
    local expected=$1
    shift
    local actual
    actual=$("$welcome" "$@") || fail "core-welcome-text failed for: $*"
    [ "$actual" = "$expected" ] || fail "unexpected text for: $*
--- expected
$expected
--- actual
$actual"
}

expect_failure() {
    local out
    if out=$("$welcome" "$@"); then
        fail "expected failure for: $*"
    fi
    [ -z "$out" ] || fail "expected no output on failure, got: $out"
}

begin='Bitcoin Core has begun to download and process the full Bitcoin block chain (897 GB) starting with the earliest transactions in 2009 when Bitcoin initially launched.'
demanding='This initial synchronisation is very demanding, and may expose hardware problems with your computer that had previously gone unnoticed. Each time you run Bitcoin Core, it will continue downloading where it left off.'

expect_text "<i>Welcome to Bitcoin Core.</i>

Bitcoin Core will download and store a copy of the Bitcoin block chain. Approximately 16 GB of data will be stored in your Persistent Storage.

$begin

$demanding

CipherStick has chosen to limit block chain storage (pruning) to 2 GB (sufficient to restore backups 6 days old), the historical data must still be downloaded and processed, but will be deleted afterward to keep your disk usage low." \
    "$fixtures/intro.ui" "$fixtures/intro.cpp" 16 897 2 6

expect_text "<i>Welcome to Bitcoin Core.</i>

Bitcoin Core will download and store a copy of the Bitcoin block chain. At least 909 GB of data will be stored in your Persistent Storage, and it will grow over time.

$begin

$demanding" \
    "$fixtures/intro.ui" "$fixtures/intro.cpp" 909 897 0 0

# A one-day backup window must not read "1 days".
"$welcome" "$fixtures/intro.ui" "$fixtures/intro.cpp" 15 897 1 1 |
    grep -q '(sufficient to restore backups 1 day old)' || fail 'singular day not used'

# Reworded upstream strings must fall back instead of showing odd text.
sed 's/If you have chosen to limit/When you limit/' "$fixtures/intro.ui" >"$work/intro.ui"
expect_failure "$work/intro.ui" "$fixtures/intro.cpp" 16 897 2 6
sed 's/stored in this directory/stored here/' "$fixtures/intro.cpp" >"$work/intro.cpp"
expect_failure "$fixtures/intro.ui" "$work/intro.cpp" 909 897 0 0

# Missing source files and bad numbers also fall back.
expect_failure "$work/missing.ui" "$fixtures/intro.cpp" 16 897 2 6
expect_failure "$fixtures/intro.ui" "$fixtures/intro.cpp" 16 897 x 6

printf '%s\n' 'core-welcome-text: PASS'
