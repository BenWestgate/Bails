# CryoStick: an offline signing stick

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

## Current interface

CryoStick can create signing wallets and sign PSBTs today. There is not yet
a Bails-specific GUI for sending PSBTs across the air gap. Bitcoin Core's
existing wallet and PSBT controls provide the create, sign, and broadcast
operations; the Bails-specific crossings between the online CipherStick and
offline CryoStick currently use the terminal QR commands documented below.

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
   **codex32** and create your signing wallet.

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

## Move the watch-only wallet to your CipherStick

On the CryoStick:

1. In Bitcoin Core, choose **File** > **Export watch-only wallet** and save
   it as `watch-only.dat` in your Home folder.
2. Open **Console** and show it as a QR code:

   ```bash
   gzip -9 < watch-only.dat | python3-qr --factory=png --error-correction=L > watch-only.png
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

There is no bespoke Bails PSBT transfer GUI yet. Every crossing uses the
same two terminal commands: show a file as a QR code on one stick, and scan
it on the other.

```bash
gzip -9 < FILE | python3-qr --factory=png --error-correction=L > FILE.png && xdg-open FILE.png
zbarcam --raw -Sbinary --oneshot | gunzip > FILE
```

1. **CipherStick:** in the **Send** tab, fill in the payment and click
   **Create Unsigned**. Save it as `unsigned.psbt` and show it with the
   terminal command above.
2. **CryoStick:** scan it into `unsigned.psbt` with the terminal command.
   Choose **File** > **Load PSBT from file**, check the amount and address,
   click **Sign Tx**, save it as `signed.psbt`, and show it with the
   terminal command.
3. **CipherStick:** scan it into `signed.psbt`. Choose **File** >
   **Load PSBT from file** and click **Broadcast Tx**.

A one-input payment is about 500 bytes, so its QR code is small.

## Testing without two computers

`tests/cryostick-qr-roundtrip.sh` runs the whole flow on one computer:
both sticks' wallets on one regtest node, and every crossing through a
real QR image read back with `zbarimg` instead of a webcam. Only the
camera itself needs two real computers.

## Still to do

Tracked in #312: the receive-address check, and replacing the manual terminal
QR crossings with a Bails-specific scripted or graphical flow so users do not
need to type the commands.
