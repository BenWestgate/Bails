# CryoStick: an offline signing USB stick

A CryoStick is a copy of your CipherStick that never goes online. You
create your wallet on it and sign with it. Your CipherStick keeps a
watch-only copy of the wallet, so it can show your balance and receive,
but it cannot spend.

| | CipherStick | CryoStick |
|---|---|---|
| Network | Online, over Tor | Never online |
| Desktop | Tails blue | Red |
| Launcher icon | Orange and purple | Ice blue and navy |
| Wallet | Watch-only | Signing wallet, created with codex32 |

## Make a CryoStick

1. Set up a CipherStick as usual, but don't create a wallet yet.
2. Open **CipherStick** > **Backup** and back it up to a second USB stick,
   including the Persistent Storage.
3. Mark the copy and the offline computer, for example with tape, so you
   never mix them up.
4. Disable networking on the offline computer in its BIOS, or remove the
   Wi-Fi card.
5. Start Tails from the copy. In the Welcome Screen, choose **+**
   (Additional Settings) > **Offline Mode**, then unlock your Persistent
   Storage. Do not set an Administration Password.
6. CipherStick sees that Offline Mode was selected and asks
   **Make a CryoStick?** Choose **Make CryoStick**.
7. If the **Welcome Screen** feature of the Persistent Storage is not
   enabled, CryoStick opens Persistent Storage and waits for you to turn it on.
8. If CryoStick finds physical network hardware, shut down and disable or
   remove it. **Continue Anyway** makes the USB stick a CryoStick despite
   the hardware warning.
9. The desktop turns red and the launcher shows the CryoStick icon. Open
   **codex32** and create your signing wallet. To keep it in memory only,
   follow [Keep the signing wallet in memory only](#keep-the-signing-wallet-in-memory-only)
   instead.

Always start Tails in **Offline Mode** and keep networking disabled or removed.
CryoStick checks after login, so it cannot protect you before then.

If CryoStick warns that it must shut down, unplug any network cable and let it
shut down. Closing the warning will not stop this. If the computer stays on,
turn it off. Next time, select **Offline Mode** in the Welcome Screen.

CryoStick also checks at every login that the **Welcome Screen** Persistent
Storage feature is enabled. If it is not, CryoStick opens Persistent Storage
and waits until you enable it, so Offline Mode is saved for future starts.

If Linux exposes a physical network interface while Offline Mode is active,
CryoStick warns you to shut down and disable or remove the hardware, while still
allowing you to continue the current session if you choose.

If physical surveillance is a concern, we recommend using a laptop on
battery power when handling recovery secrets or signing offline.
A connected power cable is a potential side channel, even when the battery
is not charging. Unplugging it removes that connection, not every side
channel. Battery operation is optional.

Every device you plug in is more hardware to trust. Use a wired keyboard
and mouse, never Bluetooth: a compromised keyboard can log the secrets you
type. An old laptop needs neither, and is easier to keep tamper-evident.
Paint its case screws with glitter nail polish, photograph the pattern,
and keep the laptop in a safe or a tamper-evident bag between uses. If the
pattern has changed, someone may have opened it.

## Move the watch-only wallet to your CipherStick

The CipherStick only needs the wallet's public descriptors. Bitcoin Core
lists receive (`/0/*`) and change (`/1/*`) descriptors separately; the
command below folds each pair into one `/<0;1>/*` descriptor to save space.
Anyone who has them can see your balance, so don't share them.

On the CryoStick, open **Console**. Replace `WALLET` with your signing
wallet's name, and on signet use `cli="bitcoin-cli -signet"`:

```bash
cli="bitcoin-cli"
$cli -rpcwallet=WALLET listdescriptors | python3 -c '
import json, subprocess, sys, time
out = []
for d in json.load(sys.stdin)["descriptors"]:
    if d.get("active") and not d["internal"]:
        desc = d["desc"].split("#")[0].replace("/0/*", "/<0;1>/*")
        info = json.loads(subprocess.check_output(sys.argv[1:] + ["getdescriptorinfo", desc]))
        out.append({"desc": desc + "#" + info["checksum"], "timestamp": int(time.time()), "active": True})
print(json.dumps(out, separators=(",", ":")))' $cli > watch-only.json
gzip -9 < watch-only.json | python3-qr --factory=pil --error-correction=L > watch-only.png
xdg-open watch-only.png
```

On the CipherStick, open **Console**, scan the QR code with the webcam
and import it into a new watch-only wallet. On signet, again use
`cli="bitcoin-cli -signet"`:

```bash
cli="bitcoin-cli"
zbarcam --raw -Sbinary --oneshot | gunzip > watch-only.json
$cli -named createwallet wallet_name=watch-only disable_private_keys=true blank=true
$cli -rpcwallet=watch-only importdescriptors "$(cat watch-only.json)"
```

The CipherStick watches from the time of export. Bitcoin Core's own
descriptor timestamps can't be used: on an offline node, "now" means the
time of its last block, which may be the genesis block.

A new wallet's four descriptors are about 800 bytes, or 520 compressed,
so the QR code is small. Labels are not copied.

## Send bitcoin

Every crossing uses the same two commands: show a file as a QR code on
one stick, and scan it on the other.

```bash
gzip -9 < FILE | python3-qr --factory=pil --error-correction=L > FILE.png && xdg-open FILE.png
zbarcam --raw -Sbinary --oneshot | gunzip > FILE
```

1. **CipherStick:** in the **Send** tab, fill in the payment and click
   **Create Unsigned**. Save it as `unsigned.psbt` and show it.
2. **CryoStick:** scan it into `unsigned.psbt`. Choose **File** >
   **Load PSBT from file**, check the amount and address, click
   **Sign Tx**, save it as `signed.psbt` and show it.
3. **CipherStick:** scan it into `signed.psbt`. Choose **File** >
   **Load PSBT from file** and click **Broadcast Tx**.

A one-input payment is about 500 bytes, so its QR code is small.

## Practise on signet

Signet coins are free and worthless, so try the whole flow there first.
Bitcoin Core keeps signet wallets apart from your real ones.

1. On each stick, quit Bitcoin Core (**File** > **Exit**) and start it on
   signet from **Console**. `-server` lets codex32 reach it. On the
   CipherStick, also add the Tor proxy. Both are saved for mainnet only:

   ```bash
   bitcoin-qt -signet -server &                          # CryoStick
   bitcoin-qt -signet -server -proxy=127.0.0.1:9050 &    # CipherStick
   ```

2. On the CryoStick, open **codex32** and create a signing wallet. It
   uses signet when that is the only network running. Then
   [move the watch-only wallet](#move-the-watch-only-wallet-to-your-cipherstick)
   to the CipherStick.
3. In Tor Browser, get coins for a **Receive** address from a signet
   faucet, such as <https://signetfaucet.com>. Then
   [send some](#send-bitcoin).

To return to mainnet, quit Bitcoin Core and start it from the menu.

## Keep the signing wallet in memory only

Bitcoin Core normally saves wallets in your Persistent Storage. If you
would rather keep nothing about the signing wallet on the CryoStick, give
it a name that starts with `/tmp/`. Tails keeps `/tmp` in the computer's
memory and erases it when you shut down. Decide before you create the
wallet: a wallet already saved in Persistent Storage stays there.

1. In Bitcoin Core, choose **File** > **Create Wallet**. Name it, for
   example, `/tmp/signing`. Tick **Encrypt Wallet** and
   **Make Blank Wallet**, click **Create** and choose a passphrase.
2. Open **codex32** and choose the wallet `/tmp/signing` to fill it from
   your codex32 backup.
3. Sign as usual.
4. Before you shut down, choose **File** > **Close Wallet**.

The wallet is gone after every shutdown, so repeat steps 1 and 2 each
time you need to sign. Only the wallet's name is saved in Persistent
Storage, and **Close Wallet** removes it.

If you forget to close the wallet, Bitcoin Core shows
"Skipping -wallet path that doesn't exist" at its next start. Click
**OK**: codex32 can't reach Bitcoin Core until you do. To stop the
message, create a wallet with the same name again and close it.

## Still to do

Tracked in #312: the receive-address check, and scripting the
crossings so users don't type commands.
