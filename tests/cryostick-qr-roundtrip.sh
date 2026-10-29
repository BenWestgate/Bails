#!/bin/bash
# Crosses the CryoStick air gap on one machine, with both sticks as wallets
# on one regtest node. Every crossing goes through a real QR image, made
# with python3-qr and read back with zbarimg, using the commands in
# docs/CRYOSTICK.md (zbarimg stands in for zbarcam and a webcam).
#
# Needs bitcoind and bitcoin-cli (Core 32 or later), python3-qr
# (python3-qrcode with Pillow support) and zbarimg (zbar-tools).
set -euo pipefail

for tool in bitcoind bitcoin-cli python3-qr zbarimg gzip python3; do
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
    gzip -9 | python3-qr --error-correction=L --factory=pil >"$dir/qr.png"
    echo "QR: $(stat -c %s "$dir/qr.png") byte PNG" >&2
    zbarimg --raw -q -Sbinary "$dir/qr.png" 2>/dev/null | gunzip
}

bitcoind -regtest -datadir="$dir" -daemonwait -fallbackfee=0.0001 >/dev/null

echo "CryoStick: create the signing wallet and fold its public descriptors"
cli createwallet cryostick >/dev/null
cli -rpcwallet=cryostick listdescriptors | python3 -c '
import json, subprocess, sys, time
out = []
for d in json.load(sys.stdin)["descriptors"]:
    if d.get("active") and not d["internal"]:
        desc = d["desc"].split("#")[0].replace("/0/*", "/<0;1>/*")
        info = json.loads(subprocess.check_output(sys.argv[1:] + ["getdescriptorinfo", desc]))
        out.append({"desc": desc + "#" + info["checksum"], "timestamp": int(time.time()), "active": True})
print(json.dumps(out, separators=(",", ":")))' bitcoin-cli -regtest -datadir="$dir" >"$dir/export.json"
echo "watch-only descriptors: $(stat -c %s "$dir/export.json") bytes, $(gzip -9 <"$dir/export.json" | wc -c) compressed"

echo "CipherStick: scan them into a new watch-only wallet"
cross <"$dir/export.json" >"$dir/watch-only.json"
cmp "$dir/export.json" "$dir/watch-only.json"
cli -named createwallet wallet_name=cipherstick disable_private_keys=true blank=true >/dev/null
cli -rpcwallet=cipherstick importdescriptors "$(cat "$dir/watch-only.json")" | grep -q '"success": false' && exit 1
[ "$(cli -rpcwallet=cipherstick getwalletinfo | field private_keys_enabled)" = False ]
[ "$(cli -rpcwallet=cipherstick getrawchangeaddress)" = "$(cli -rpcwallet=cryostick getrawchangeaddress)" ]

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
