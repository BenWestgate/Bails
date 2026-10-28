# Bitcoin QR

Use **Bitcoin QR** to check receiving addresses, move transactions between your
online CipherStick and offline CryoStick, and set up a watch-only wallet.
With Bitcoin Core open on both computers, choose **CipherStick** > **Bitcoin QR**.

Keep the QR image open until the other computer scans it. QR codes work in any
orientation. Double-click the image window's title bar to maximize it if needed. Close the camera window to
cancel a scan; it also stops after three minutes.

## Set up your watch-only wallet

1. On the CryoStick, open your signing wallet in Bitcoin Core.

2. In Bitcoin QR, choose **Export Watch-Only Wallet**. Select your signing wallet
   in the wallet list that appears. A QR opens containing public wallet
   information and address labels, without private keys.

3. On the CipherStick, choose **Scan QR** and scan the image.

4. If the suggested wallet name already exists, enter a different name.
   Wait for the import to finish. Core may need time to find past payments;
   missing historical blocks can prevent it from completing.

5. Select the imported wallet in Bitcoin Core's wallet selector.
   Find imported receiving addresses and labels under **Window** > **Receiving addresses**.

If import fails, the new wallet may be incomplete; do not use it until the
problem is resolved. Saved payment requests are not copied. Descriptor timestamps
are preserved so Core can search for earlier payments. The next address matches
at export time; later address requests do not synchronize the copies.
Choose the same address type on both computers when comparing addresses.
If Taproot is missing from Core's address-type list, close and reopen the wallet
using **File** > **Close Wallet** and **File** > **Open Wallet**.

## Check a receiving address

1. On the CryoStick, open your signing wallet in Core.

2. Choose **Scan QR** and scan the receiving address from your online wallet.

3. Check the address and wallet names in the results. All loaded wallets are
   checked. A confirmation means the matching wallet holds the signing key;
   it does not prove nobody else has a copy. For an encrypted wallet, make sure
   you have the passphrase and can unlock it.

If a warning says the address is unrecognized, the signing key is missing,
or signing is not confirmed, stop and check with your offline signing wallet.
Do not send funds until you have resolved the warning. Multisig and other complex
wallets need additional verification that this tool does not perform.

## Move a transaction for signing

1. On the CipherStick, prepare your payment in Core and choose **Create Unsigned**,
   then **Copy to Clipboard**. For a transaction already open in Core, use its
   **Copy to Clipboard** button.

2. Choose **Send PSBT**. Check the text filled from the clipboard, or paste it
   if the box is empty. Click **Show QR**.

3. On the CryoStick, choose **Scan QR** and scan the image. All the text starts
   selected. Click the highlighted **Copy** button.

4. In Core, select your signing wallet and choose **File** > **Load PSBT from clipboard**.
   Keep the text window open until Core has loaded the transaction, then choose
   **Go Back**.
   Check the recipient, amount, change, and fee before choosing **Sign Tx**.

5. Copy the signed transaction from Core and repeat the transfer in the other
   direction. On the CipherStick, load it in Core, review it, and choose **Broadcast Tx**.

Use Bitcoin QR on both computers. It never unlocks a wallet, signs, or broadcasts.

## Use an encrypted USB stick or microSD card instead

If there is no webcam or a QR is too large or difficult to scan, transfer a file
using encrypted removable storage. Unlock it on each computer only while needed,
then lock and eject it. Do not plug your CryoStick into the online computer.

For a watch-only wallet, select your signing wallet in Core and choose
**File** > **Export watch-only wallet**. Save only the exported watch-only file
to the encrypted transfer storage; never copy your signing wallet. On the
CipherStick, choose **File** > **Restore Wallet** and select that file.
This uses a different format from the QR tool's descriptor export.

For a transaction, save the PSBT in Core, move the file to the other computer,
and choose **File** > **Load PSBT from file**. After signing, save and return the
signed file to the CipherStick, then load, review, and broadcast it in Core.
