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

The dock and app grid omit Network applications. The applications remain
installed.

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

With Bitcoin Core open, choose **CipherStick** > **Bitcoin QR**.
See [Bitcoin QR](BITCOIN_QR.md) to transfer a watch-only wallet, check receiving
addresses, and move transactions for signing. The guide also explains file
transfer using encrypted removable storage when a webcam is unavailable or a
QR is too large.

## Practise on signet

Signet coins are free and worthless, so try the whole flow there first.
Bitcoin Core keeps signet wallets apart from your real ones.

1. On each stick open **Bitcoin Core (signet)** from the **Applications** menu.
   Mainnet can keep synchronizing while you practise.
2. On the CryoStick, open **codex32** and create a signing wallet. Choose
   signet if codex32 asks which network to use. Then
   [move the watch-only wallet](#move-the-watch-only-wallet-to-your-cipherstick)
   to the CipherStick.
3. In Tor Browser, get coins for a **Receive** address from a signet
   faucet, such as <https://signetfaucet.com>. Then
   [send some](BITCOIN_QR.md#move-a-transaction-for-signing).

Close **Bitcoin Core (signet)** when you are done practising. Mainnet can continue running.

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
