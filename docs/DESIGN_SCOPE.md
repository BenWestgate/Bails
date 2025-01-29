## CipherStick MVP Scope

- Download Bitcoin Core and Signatures
- Help set up Tails Persistence for Bitcoin
- Help user remember passphrase w/ spaced repetition
- Verify Bitcoin Core download
- Install Bitcoin Core on Tails
- Create a codex32 seed backup
- Restore a codex32 seed backup
- Create a standard derivation path wallet from codex32 seed encrypted by memorized passphrase

### The CipherStick MVP is COMPLETED.

## In-Progress: CipherStick L1 Scope ([Manual Backup](https://bitcoin.design/guide/how-it-works/private-key-management/manual-backup/) [Daily](https://bitcoin.design/guide/daily-spending-wallet/) or [Monthly Spending Wallet](https://bitcoin.design/guide/designing-products/personal-finance/#monthly-budgeting))

- Scan Codex32 25x25 QR codes that encode the codex32 string, these directly encode the codex32 string alphanumerically
- Create backups of the CipherStick for recovery without rescanning blockchain or downloading CipherStick
- Create clones of the CipherStick with all private data encrypted to give to friends & family to decentralize distribution, bypass download wait, improve user private data redundancy [mostly written]
- Give reminders at 100% IBD to create a backup CipherStick to avoid repeating IBD [mostly written]
- Use AssumeUTXO to drastically shorten time to usefulness [partly written]
- Create DEMO and Promo videos [partly written]
- Rotate shares to reset Forgotten passphrases w/o sweeping funds [partly written]
- Rotate shares to change thresholds w/o sweeping funds [partly written]
- Watch encrypted wallets and panic mode wallets [partly written]
- Draw Codex32 QR codes optionally instead of writing strings during codex32 backup creation [not yet written]
- Add extra shares w/o rotating or replacing existing shares [not yet written]

## CipherStick L2 Scope ([External Signer](https://bitcoin.design/guide/how-it-works/private-key-management/external-signers/) [Savings Wallet](https://bitcoin.design/guide/designing-products/personal-finance/#savings)) 
- Will feature [Offline Signing](https://github.com/bitcoin/bitcoin/blame/master/doc/offline-signing-tutorial.md) for higher security
- Offline CipherStick will be an amnesic / stateless signer that recovers the signing wallet from Codex32 shares and forgets the private key on shutdown.
- Drawable compact 21x21 QR Codes of threshold 2 and 3 codex32 shares, uses base45, drops ID, truncates checksum, 1-bit for threshold

_No code has been written for any of the following and unclear scope or value-proposition of features. Insufficiently different from L3, suggest to prioritize and combine._
- Automatic Cloud backups aka [Seedless setup](https://bitcoin.design/guide/how-it-works/private-key-management/cloud-backup/)  [function not yet written]
- Restore codex32 seed backups either <i>Persistently</i> creating the encrypted wallet in `$HOME/Persistent/.bitcoin/wallets` or <i>Offline</i> in RAM `/tmp/wallets` RAM (for cold storage)
  - This is also known as a Stateless signer or Amnesic Wallet, CodexQR strongly reccomended for fast spending recovery
- Option to store a persistent watch-only wallet when restored to RAM (for a savings account that keeps the seed & private keys offline on paper)
- Display a QR code of the public descriptor to make a watch-only wallet across an airgap
- Scan a descriptor QR code or paste and import the watch-only wallet into Bitcoin Core (yeti cold, hwws, airgapped PCs, etc)
- Display & scan PSBT QRs for crossing the airgap when signing a transaction
- Install option to create always offline read-only CipherStick signing devices (no Persistent folder needed, welcome screen needed to persist Offline mode)
- Only 1 PC is required. Online & Offline CipherSticks are made
- The signed PSBT can be saved to the Online CipherStick persistent storage with both simultaneously inserted. (insufficient physical space between USB ports on old laptops MacBook)
- Use BIP85 to allow one seed backup to create multiple wallets [possible codex32 extension for this]
  - BIP85 could allow restoring a hot wallet and offline savings account or a normal and no-KYC wallet from one seed backup. Or make secret wallets you can deny exist until your seed is restored. Or make panic mode wallets to reveal under duress.
- DVD backups of the CipherStick data (more durable??)


## CipherStick L3 Scope ([Multi-key](https://bitcoin.design/guide/how-it-works/private-key-management/multi-key/) [Investment Wallet](https://bitcoin.design/guide/how-it-works/private-key-management/overview/#picking-a-scheme-for-your-product))
_No code has been written for any of the following, unclear scope and value-proposition of features._

- Coordinate 2-of-2 multi-sig between `CipherStick/hi` (a checking+savings account) and `CipherStick/Offline` (an always offline PC)
- `CipherStick/hi` would add an additional share and become the 1st key in multisig
- `CipherStick/Offline` would be the 2nd key and backed up with a 3-of-3 shares w/ a share derived from the hash of `CipherStick/hi` seed and another derived from passphrase
- Minimum 7 locations needed, only 1 would store 2 shares giving away the possible 2-of-2, `CipherStick/hi` would NOT need to be rotated just an extra share generated & stored
- Descriptors do NOT need to be stored in 2-of-2 multi sig, but could be for deposit convenience at expense of privacy
- If a watch-only wallet is stored, recommend to heavily encrypt by gpg key derived from masterkey of `CipherStick/hi` or `CipherStick/Offline, as knowing either seed would allow finding the taproot and spent addresses on blockchain.

## CipherStick L4 Scope ([Multi-party Multi-key](https://bitcoin.design/guide/how-it-works/private-key-management/overview/#shared-schemes) [Life Savings Shared Wallet](https://bitcoin.design/guide/shared-wallet/))
_No code has been written for any of the following, unclear value proposition and/or scope of features._

- Coordinate multi-party multi-sigs between multiple CipherStick/2-of-2 users for inheritance. Threshold must require at least 1 offline signature
  - Almost certainly going to use an existing GUI coordinator for this than write new code. Open an issue with recommended multisig coordinators.
- Option to decay the CipherStick/2-of-2 to 1-of-2 or the multi-party multi sig to reduce lost risk after LONG time spans (5 years recommended)
  - Almost certainly going to use an existing GUI coordinator for this than write new code. Such as Liana or maybe Arctica.
- This will also be the way to include even more signing devices in a multisig than CipherStick/2-of-2, it's recommended the other keys in the multisig are backed up with codex32 and managed with Bitcoin Core but not enforced.
