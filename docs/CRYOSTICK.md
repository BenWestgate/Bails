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
   Storage.
6. In the Persistent Storage settings, turn on **Welcome Screen**, so
   Offline Mode is saved for every start.
7. CipherStick sees that the computer has no network and asks
   **Make a CryoStick?** Choose **Make CryoStick**. The desktop turns red
   and the launcher shows the CryoStick icon.
8. Open **codex32** and create your signing wallet.

From then on, if the CryoStick ever finds a network device, it tells you
and shuts Tails down.

## Move the watch-only wallet to your CipherStick

On the CryoStick:

1. In Bitcoin Core, choose **File** > **Export watch-only wallet** and save
   it as `watch-only.dat` in your Home folder.
2. Open **Console** and show it as a QR code:

   ```bash
   gzip -9 < watch-only.dat | qr --error-correction=L > watch-only.png
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

## Still to do

Tracked in #312: scripting the QR crossings for addresses and PSBTs, and
the receive-address check.
