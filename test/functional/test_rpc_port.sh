#!/bin/bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
installer="$root/bails/.local/bin/install-core"
wrapped="$root/bails/.local/bin/wrapped"
launcher="$root/bails/.local/share/applications/bitcoin-qt-signet.desktop"

# New installs must not activate a fixed RPC port.
if grep -Eq '(main\.)?rpcport=[0-9]+' "$installer"; then
    echo 'install-core must not set a custom RPC port' >&2
    exit 1
fi
grep -Fq -- '-chain=signet -server -proxy=127.0.0.1:9050' "$launcher"

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
printf 'persistent-setup() { :; }\n' > "$tmp/profile"
cat > "$tmp/bitcoin-qt" <<'SH'
#!/bin/sh
printf '%s\n' "$@" > "$TEST_ARGS"
SH
chmod +x "$tmp/bitcoin-qt"

# Replace only fixed integration paths; execute wrapped's real migration and
# the signet-style (absolute-path) early-exit launch in an isolated fixture.
# shellcheck disable=SC2016
sed -e 's|^\. "/home/$USER/.profile"$|. "$TEST_PROFILE"|' \
    -e 's|^conf=/live/persistence/TailsData_unlocked/dotfiles/.bitcoin/bitcoin.conf$|conf=$TEST_CONF|' \
    "$wrapped" > "$tmp/wrapped"

launch() {
    rm -f -- "$tmp/args"
    TEST_PROFILE="$tmp/profile" TEST_CONF="$tmp/bitcoin.conf" TEST_ARGS="$tmp/args" \
        bash "$tmp/wrapped" "$tmp/bitcoin-qt" -chain=signet -server -proxy=127.0.0.1:9050
    # wrapped starts the requested program in the background.
    for ((i=0; i<100; i++)); do
        [ ! -f "$tmp/args" ] || break
        sleep 0.01
    done
    [ -f "$tmp/args" ] || { echo 'signet command did not launch' >&2; exit 1; }
    diff -u <(printf '%s\n' -chain=signet -server -proxy=127.0.0.1:9050) "$tmp/args"
}

check_case() {
    printf '%s' "$1" > "$tmp/bitcoin.conf"
    launch
    diff -u <(printf '%s' "$2") "$tmp/bitcoin.conf"
    before=$(stat -c %i "$tmp/bitcoin.conf")
    launch
    [ "$before" = "$(stat -c %i "$tmp/bitcoin.conf")" ] || {
        echo 'unchanged configuration was rewritten' >&2
        exit 1
    }
}

check_case $'rpcport=17600\nserver=1\n' $'server=1\n'
check_case $'main.rpcport=17600\nproxy=127.0.0.1:9050\n' $'proxy=127.0.0.1:9050\n'
check_case $'rpcport=17600\nmain.rpcport=17600\n[signet]\nrpcport=17600\n' \
    $'[signet]\nrpcport=17600\n'
check_case $'main.rpcport=18400\n[main]\nrpcport=17600\n' \
    $'main.rpcport=18400\n[main]\nrpcport=17600\n'
check_case $'server=1\n' $'server=1\n'

printf '%s\n' 'RPC port migration and signet launcher: PASS'
