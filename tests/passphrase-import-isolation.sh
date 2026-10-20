#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

# Load only the helper, without running Persistent Storage setup.
helper="$(sed -n '/^passphrase_bits() {$/,/^}$/p' "$repo_root/bails/.local/bin/persistent-setup")"
[ -n "$helper" ]
mkdir "$test_dir/modules" "$test_dir/empty"
for module in zxcvbn_rs_py zxcvbn sitecustomize; do
    cat > "$test_dir/modules/$module.py" <<'PY'
raise RuntimeError("attacker-controlled import")
PY
done

check_imports() {
    local result status=0
    result="$(printf '%s' 'test passphrase' | bash -c "$helper; passphrase_bits" 2>&1)" || status=$?
    if [[ "$result" == *'attacker-controlled import'* ]]; then
        echo 'FAIL: loaded an attacker-controlled module' >&2
        exit 1
    fi
    # A real estimator returns bits; a missing estimator must remain visible.
    if ((status == 0)); then
        [[ "$result" =~ ^[0-9]+$ ]]
    else
        [[ "$result" == *ModuleNotFoundError* ]]
    fi
}

# Check each import source independently.
(cd "$test_dir/modules"; unset PYTHONPATH; check_imports)
(cd "$test_dir/empty"; export PYTHONPATH="$test_dir/modules"; check_imports)
echo 'PASS: working directory and PYTHONPATH imports are isolated'
