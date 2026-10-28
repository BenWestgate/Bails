# Bitcoin QR

With Bitcoin Core open, choose **CipherStick** > **Bitcoin QR**.
Keep QR images open until scanned. Close the camera window to cancel;
scanning also stops after three minutes.

## Move a transaction for signing

1. In Core, prepare the payment and choose **Create Unsigned**, then
   **Copy to Clipboard**.
2. Choose **Send PSBT**, paste the text, and click **OK** to show its QR.
3. On the other computer, choose **Scan QR**. The received PSBT is copied.
4. In Core, select your wallet and choose **File** >
   **Load PSBT from clipboard**. Keep the **PSBT copied** message open
   until the transaction appears, then click **Done**.
5. Check the recipient, amount, change, and fee before signing.
6. Copy the signed PSBT from Core and repeat the transfer back to the
   CipherStick. Review it in Core before broadcasting.

The tool never unlocks, signs, or broadcasts. QR transfers are unencrypted.
Sending uses explicit paste; unrelated clipboard contents are not read.

## Set up a watch-only wallet

1. On the CryoStick, choose **Export Watch-Only Wallet** and select your
   loaded signing wallet.
2. On the CipherStick, choose **Scan QR** and enter a new wallet name.
3. Select the imported wallet in Core. Find addresses and labels under
   **Window** > **Receiving addresses**.

The export contains public descriptors and labels, without private keys.
It preserves descriptor timestamps, ranges, and next address indexes.
Saved payment requests are not copied; later changes do not synchronize.
If the name already exists, scan again and choose another name.
If import fails, the new wallet may be incomplete. Do not use it until fixed.

## Check a receiving address

On the CryoStick, open your signing wallet and choose **Scan QR**.
Scan the address shown by your online wallet. All open wallets are checked.

An address match only means the wallet recognizes it. It does not prove
that you can spend, or that nobody else has the keys. A watch-only wallet
cannot sign. Verify the spending policy and required keys before sending
funds. For an encrypted wallet, make sure you can unlock it.

## Use encrypted removable storage instead

If there is no webcam or a QR is too large, use a separate encrypted USB
stick or microSD card. Unlock it only while needed, then lock and eject it.
Do not plug the CryoStick into the online computer.

For wallets, use Core's **File** > **Export watch-only wallet** on the
CryoStick, then **File** > **Restore Wallet** on the CipherStick.
Transfer only that export, never the signing wallet.

For transactions, save the PSBT in Core and use **File** >
**Load PSBT from file** on the other computer. After signing, return the
signed file, review it, and broadcast in Core.
