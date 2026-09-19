#!/bin/bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
output="$(bash "$root/b" --version)"

case "$output" in
    "CipherStick version "*) ;;
    *)
        printf 'unexpected version output: %s\n' "$output" >&2
        exit 1
        ;;
esac
