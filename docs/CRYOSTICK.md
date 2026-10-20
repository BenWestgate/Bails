# CryoStick: an offline signing stick

A CryoStick is a copy of your CipherStick that never goes online. You
create your wallet on it and sign with it. Your CipherStick keeps a
watch-only copy of the wallet, so it can show your balance and receive,
but it cannot spend.

This adapts Bitcoin Core's [offline signing
tutorial](https://github.com/bitcoin/bitcoin/blob/master/doc/offline-signing-tutorial.md).
Files cross between the computers as QR codes instead of on a USB stick,
the offline computer runs a copy of your CipherStick, and the signing
wallet is filled from your codex32 backup.

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

Keep Tails in **Offline Mode** and keep the computer's networking disabled
or removed. Once a stick is marked as a CryoStick, it checks Offline Mode at
every login. If networking is enabled, it stops Bitcoin Core and Tor Connection
Assistant and shuts Tails down.

CryoStick also checks at every login that the **Welcome Screen** Persistent
Storage feature is enabled. If it is not, CryoStick opens Persistent Storage
and waits until you enable it, so Offline Mode is saved for future starts.

If Linux exposes a physical network interface while Offline Mode is active,
CryoStick warns you to shut down and disable or remove the hardware, while still
allowing you to continue the current session if you choose.

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

## Move the watch-only wallet to your CipherStick

On the CryoStick:

1. In Bitcoin Core, choose **File** > **Export watch-only wallet** and save
   it as `watch-only.dat` in your Home folder.
2. Open **Console** and show it as a QR code:

   ```bash
   gzip -9 < watch-only.dat | python3-qr --factory=pil --error-correction=L > watch-only.png
   xdg-open watch-only.png
   ```

On the CipherStick:

1. Open **Console** and scan the QR code with the webcam:

   ```bash
   zbarcam --raw -Sbinary --oneshot | gunzip > ~/Persistent/watch-only.dat
   ```

2. In Bitcoin Core, choose **File** > **Restore Wallet** and pick
   `watch-only.dat`.

A new wallet's export is about 12 KB, too big for one QR code. Compressed
it is about 2.4 KB, which fits in one large, dense QR code. Hold the
screens steady and close together when scanning.

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

## Testing without two computers

`tests/cryostick-qr-roundtrip.sh` runs the whole flow on one computer:
both sticks' wallets on one regtest node, and every crossing through a
real QR image read back with `zbarimg` instead of a webcam. Only the
camera itself needs two real computers.

## Still to do

Tracked in #312: the receive-address check, and scripting the
crossings so users don't type commands.

## Advanced: update a CryoStick without going online

Only update a CryoStick for a security fix, or for a new feature you need
on an offline signer. Every update puts new code on the computer that
holds your keys.

Don't use **Update Bitcoin Core** or **Update CipherStick** on the
CryoStick: they need a network connection. Update your CipherStick
first, then carry its updates across, as Bitcoin Core's tutorial does
for PSBTs. You need a spare USB stick named `TRANSFER`.

### Tails

1. Start your up-to-date CipherStick on the offline computer.
2. Plug in the CryoStick and choose **Apps** > **Tails** > **Tails Cloner**.
3. Leave **Clone the current Persistent Storage** unselected, so the
   CryoStick keeps its own, and click **Upgrade**.

Tails explains each step in [Upgrading manually by cloning from another
Tails](https://tails.net/doc/upgrade/clone/).

### CipherStick, codex32 and Bitcoin Core

On the CipherStick:

1. Use **Update CipherStick** and **Update Bitcoin Core**, then open
   **codex32** once so it fetches the version the update pins.
2. Plug in the transfer stick, open **Console** and pack the updates into
   one file. A tar file keeps the scripts executable on any stick. It
   takes the Bitcoin Core download you just installed, and the builder
   keys that signed it, which **Update Bitcoin Core** refreshed:

   ```bash
   T=/media/amnesia/TRANSFER
   cd /live/persistence/TailsData_unlocked/dotfiles/.local/share
   CORE=$(ls -td bitcoin/bitcoin-core-*/ | head -n 1)
   gpg --export $(gpg --status-fd 1 --verify "$CORE/SHA256SUMS.asc" \
       "$CORE/SHA256SUMS" 2>/dev/null | awk '$2 == "VALIDSIG" {print $NF}') \
       > ~/builder-keys.gpg
   git clone --quiet bails ~/bails
   tar -cf "$T/update.tar" -C ~ bails builder-keys.gpg \
       -C "$PWD" python-codex32 "$CORE"
   sha256sum < "$T/update.tar"
   ```

   Keep this checksum on screen, or write it down.

On the CryoStick, plug in the transfer stick and open **Console**:

1. Copy the updates and check them. Nothing on the transfer stick is
   trusted until the whole file matches the CipherStick's checksum.

   ```bash
   T=/media/amnesia/TRANSFER
   D=/live/persistence/TailsData_unlocked/dotfiles
   cp "$T/update.tar" ~
   sha256sum < ~/update.tar
   ```

   Continue only if every character matches the CipherStick's checksum.
   Then Bitcoin Core is checked again on the CryoStick, counting only
   signers whose keys are not expired or revoked:

   ```bash
   tar -xf ~/update.tar -C ~
   gpg --import ~/builder-keys.gpg
   cd ~/bitcoin/bitcoin-core-*/ && VER=${PWD##*bitcoin-core-}
   gpg --status-fd 1 --verify SHA256SUMS.asc SHA256SUMS 2>/dev/null |
       awk '$2 ~ /SIG$/ && $2 != "VALIDSIG" {good = $2 == "GOODSIG"}
           $2 == "VALIDSIG" && good {print $NF}' | sort -u | wc -l
   sha256sum --ignore-missing --check SHA256SUMS
   ```

   Continue only if the count of different signers is 3 or more and the
   tarball shows `OK`.

2. In the same Console, install Bitcoin Core, codex32 and CipherStick,
   then check that CipherStick saved its update:

   ```bash
   stop-btc
   tar -xf "bitcoin-$VER-x86_64-linux-gnu.tar.gz" --strip-components=1 \
       --directory="$D/.local" "bitcoin-$VER"/{bin,libexec,share}
   rsync -a --delete ~/python-codex32/ "$D/.local/share/python-codex32/"
   REV=$(git -C ~/bails rev-parse HEAD)
   cp -rT ~/bails/bails ~/payload
   ~/bails/b --update
   while [ -d ~/bails ]; do sleep 1; done
   cd ~/payload
   [ "$(git -C "$D/.local/share/bails" rev-parse HEAD)" = "$REV" ] &&
       [ -z "$(find . -type f ! -exec cmp -s {} "$D/{}" \; -print)" ] &&
       echo 'CipherStick update saved'
   ```

   If it doesn't print `CipherStick update saved`, don't restart. Free
   space in Persistent Storage, then start again from step 1.

3. Restart Tails.
