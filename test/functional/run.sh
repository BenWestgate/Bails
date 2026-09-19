#!/bin/bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

for test_file in "$root"/test/functional/test_*.sh; do
    printf 'Running %s\n' "${test_file##*/}"
    bash "$test_file"
done
