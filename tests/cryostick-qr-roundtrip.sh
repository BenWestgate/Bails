#!/bin/bash
# Crosses the CryoStick air gap on one machine, with both sticks as wallets
# on one regtest node. Every crossing goes through a real QR image, made
# with qr and read back with zbarimg, using the commands in
# docs/CRYOSTICK.md (zbarimg stands in for zbarcam and a webcam).
#
# Needs bitcoind and bitcoin-cli (Core 32 or later), qr (python3-qrcode
# with PNG support) and zbarimg (zbar-tools).
set -euo pipefail

for tool in bitcoind bitcoin-cli qr zbarimg gzip python3; do
    command -v "$tool" >/dev/null || { echo "missing $tool" >&2; exit 1; }
done

dir="$(mktemp -d)"
cli() { bitcoin-cli -regtest -datadir="$dir" "$@"; }
cleanup() {
    cli stop >/dev/null 2>&1 && while [ -e "$dir/regtest/bitcoind.pid" ]; do sleep 0.2; done
    rm -rf "$dir"
}
trap cleanup EXIT

field() { python3 -c 'import json, sys; print(json.load(sys.stdin)[sys.argv[1]])' "$1"; }

# Shows stdin as a QR code on one stick and reads it on the other.
cross() {
    gzip -9 | qr --error-correction=L --factory=png >"$dir/qr.png"
    echo "QR: $(stat -c %s "$dir/qr.png") byte PNG" >&2
    zbarimg --raw -q -Sbinary "$dir/qr.png" 2>/dev/null | gunzip
}

bitcoind -regtest -datadir="$dir" -daemonwait -fallbackfee=0.0001 >/dev/null

echo "CryoStick: create the signing wallet and export it watch-only"
cli createwallet cryostick >/dev/null
cli -rpcwallet=cryostick exportwatchonlywallet "$dir/export.dat" >/dev/null
echo "watch-only export: $(stat -c %s "$dir/export.dat") bytes, $(gzip -9 <"$dir/export.dat" | wc -c) compressed"

echo "CipherStick: scan it and restore the watch-only wallet"
cross <"$dir/export.dat" >"$dir/watch-only.dat"
cmp "$dir/export.dat" "$dir/watch-only.dat"
cli restorewallet cipherstick "$dir/watch-only.dat" >/dev/null
[ "$(cli -rpcwallet=cipherstick getwalletinfo | field private_keys_enabled)" = False ]

echo "CipherStick: receive coins, then make an unsigned PSBT"
cli generatetoaddress 101 "$(cli -rpcwallet=cipherstick getnewaddress)" >/dev/null
dest="$(cli -rpcwallet=cipherstick getnewaddress)"
unsigned="$(cli -rpcwallet=cipherstick -named walletcreatefundedpsbt outputs="{\"$dest\": 1}" | field psbt)"
[ "$(cli -rpcwallet=cipherstick walletprocesspsbt "$unsigned" | field complete)" = False ]
echo "unsigned PSBT: $(base64 -d <<<"$unsigned" | wc -c) bytes"

echo "CryoStick: scan the PSBT and sign it"
scanned="$(printf %s "$unsigned" | cross)"
[ "$scanned" = "$unsigned" ]
signed_json="$(cli -rpcwallet=cryostick walletprocesspsbt "$scanned")"
[ "$(field complete <<<"$signed_json")" = True ]
signed="$(field psbt <<<"$signed_json")"

echo "CipherStick: scan the signed PSBT and broadcast it"
txhex="$(printf %s "$signed" | cross | cli -stdin finalizepsbt | field hex)"
txid="$(cli sendrawtransaction "$txhex")"
cli getmempoolentry "$txid" >/dev/null
echo "PASS: $txid is in the mempool"
