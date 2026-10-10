#!/bin/bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_root=$(mktemp -d)
trap 'rm -rf -- "$test_root"' EXIT
mkdir -p "$test_root/data/python-codex32/src/codex32_gui/forms"
printf 'card version 1\n' > "$test_root/data/python-codex32/src/codex32_gui/forms/recovery-card.html"
printf 'record\n' > "$test_root/data/python-codex32/src/codex32_gui/forms/wallet-verification-record.html"
env HOME="$test_root/home" XDG_DATA_HOME="$test_root/data" bash -s -- "$repo_root" <<'TEST'
set -euo pipefail
# shellcheck disable=SC1091
. "$1/bails/.local/bin/open-codex32"
prepare_forms
[ "$CODEX32_FORMS_DIR" = "$HOME/Tor Browser/codex32-forms" ]
cmp "$SOURCE_DIR/src/codex32_gui/forms/recovery-card.html" "$CODEX32_FORMS_DIR/recovery-card.html"
cmp "$SOURCE_DIR/src/codex32_gui/forms/wallet-verification-record.html" "$CODEX32_FORMS_DIR/wallet-verification-record.html"
printf 'keep this file\n' > "$HOME/sentinel"
rm "$CODEX32_FORMS_DIR/recovery-card.html"
ln -s "$HOME/sentinel" "$CODEX32_FORMS_DIR/recovery-card.html"
printf 'card version 2\n' > "$SOURCE_DIR/src/codex32_gui/forms/recovery-card.html"
prepare_forms
cmp "$SOURCE_DIR/src/codex32_gui/forms/recovery-card.html" "$CODEX32_FORMS_DIR/recovery-card.html"
[ ! -L "$CODEX32_FORMS_DIR/recovery-card.html" ]
[ "$(cat "$HOME/sentinel")" = 'keep this file' ]
rm -r -- "$CODEX32_FORMS_DIR"
mkdir "$HOME/elsewhere"
ln -s "$HOME/elsewhere" "$CODEX32_FORMS_DIR"
if prepare_forms 2>/dev/null; then
    echo 'symlinked forms folder was silently accepted' >&2
    exit 1
fi
[ -z "$(ls -A "$HOME/elsewhere")" ]
rm -- "$CODEX32_FORMS_DIR"
rm "$SOURCE_DIR/src/codex32_gui/forms/wallet-verification-record.html"
if prepare_forms 2>/dev/null; then
    echo 'missing form was silently accepted' >&2
    exit 1
fi
TEST
printf '%s\n' 'codex32 confined-browser forms: PASS'
