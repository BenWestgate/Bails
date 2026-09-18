#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$repo_root/b"
for script in "$repo_root"/bails/.local/bin/*; do
    [ -f "$script" ] || continue
    head -n 1 "$script" | grep -qE '^#!.*/(ba)?sh' || continue
    bash -n "$script"
done

version_output="$(bash "$repo_root/b" --version)"
grep -q '^CipherStick version ' <<< "$version_output"

for test_case in "$repo_root"/test/cases/*.sh; do
    [ -e "$test_case" ] || continue
    bash "$test_case"
done
