## Current supported installer scope

The current alpha installs and configures Bitcoin Core on Tails. CryoStick adds an offline signing device:

- Download and verify Bitcoin Core.
- Help configure Tails Persistent Storage for Bitcoin Core.
- Install and configure Bitcoin Core on Tails.
- Provide passphrase memorization assistance.
- Install the pinned `python-codex32` graphical application for Codex32 backup and recovery.
- Mark a copied CipherStick as a CryoStick, with a distinct desktop and launcher icon.
- Check Tails **Offline Mode** on every CryoStick login.
- Transfer watch-only wallet data and PSBTs using **Bitcoin QR**.

No general-purpose wallet coordinator is bundled or installed. Bitcoin Core owns wallet creation, watch-only descriptors, PSBT signing and broadcast; `python-codex32` handles Codex32 backup and recovery through Core.

The legacy custom wallet and bundled Codex32 implementation have been removed. The pinned `python-codex32` application replaces their backup and recovery functions. The current Clone and Backup menu actions remain unfinished work.

## Current CryoStick offline-signing scope

[CryoStick](CRYOSTICK.md) is the offline signer. Its red desktop and launcher distinguish it from the online CipherStick.

- Tails must be started in **Offline Mode** before using a signing wallet. On a marked CryoStick, the startup check requests networking and radios off with `nmcli`; if Offline Mode was not selected, it warns, stops Tor Connection Assistant and Bitcoin Core, and requests shutdown. The check runs after Tails login, not before it.
- CryoStick checks that the **Welcome Screen** Persistent Storage feature is enabled so Offline Mode settings can be saved, and warns when physical network hardware remains exposed.
- The signing wallet can stay in Persistent Storage or be created in memory under `/tmp/`. Memory-only wallets disappear at shutdown; choosing that path does not delete a wallet already stored persistently.
- Use [Bitcoin QR](BITCOIN_QR.md) to move public watch-only wallet data and PSBTs between devices, verify receiving addresses, and review transactions in Bitcoin Core before signing and broadcasting. The QR helper does not handle private keys or sign or broadcast. Encrypted removable storage is the documented alternative if QR transfer is unsuitable.

The Tails desktop, camera, and two-computer signing handoff still require validation on the supported Tails release before claiming that the complete hardware workflow has passed.

## Clone and backup privacy boundary

A copy shared with another person must not contain private wallets or recovery secrets. Tails Cloner copies Persistent Storage **only when** **Clone the current Persistent Storage** is selected; choosing that option can copy stored wallets. Encryption does not isolate them from a recipient who is given the unlocking passphrase.

The CipherStick **Clone** and **Backup** menu actions are unfinished (tracked in #358). Before enabling them, a private backup may include Persistent Storage, but a shared clone must omit wallet secrets throughout the supported persistent wallet locations. Keeping a signing wallet only in memory does not erase any already-persistent wallet. Encrypted wallet containers and panic-mode features are later enhancements, not prerequisites for safe clone sharing.

## Legacy MVP scope

The historical MVP included the following goals. Items in this section describe past implementation intent, not current support guarantees:

- Create and restore a Codex32 seed backup.
- Create a standard derivation-path wallet from a Codex32 seed.
- Encrypt wallet material with a memorized passphrase.

## In progress or planned

- Fresh-Tails handoff with explicit, user-selected data transfer.
- Reminders after initial block download to create a backup.
- Use AssumeUTXO to shorten time to usefulness.
- Review and implement safe shared-clone and private-backup handling.
- Consider panic-mode wallet enhancements.

## Future offline signing enhancements

- Support offline read-only signing devices.
- Review additional device types and transfer sizes separately before promising support.

## Future multisig and inheritance scope

No supported multisig or inheritance coordinator exists today. Potential future work includes:

- coordinating multisig with established external software rather than implementing another coordinator in CipherStick;
- multi-party inheritance policies;
- time-based recovery policies;
- additional independently backed signing devices.

These future designs require separate threat models, tests, and review before they are presented as supported security properties.
