## Bails MVP Scope

- Download Bitcoin Core and Signatures
- Help set up Tails Persistence for Bitcoin
- Help user remember passphrase w/ spaced repetition
- Verify Bitcoin Core download
- Install Bitcoin Core on Tails
- Create a codex32 seed backup
- Restore a codex32 seed backup
- Create a standard derivation path wallet from codex32 seed encrypted by memorized passphrase

### The Bails MVP is COMPLETED.

## Bails L1 Scope ([Manual Backup](https://bitcoin.design/guide/how-it-works/private-key-management/manual-backup/) [Daily](https://bitcoin.design/guide/daily-spending-wallet/) or [Monthly Spending Wallet](https://bitcoin.design/guide/designing-products/personal-finance/#monthly-budgeting))

- Create backups of the Bails USB for recovery without rescanning blockchain
- Create clones of the Bails USB with all private data encrypted to give to friends & family to decentralize distribution, bypass download wait, User gets private data redundancy
- Give periodic reminders to create new USB backups to replace the old ones before they die
- Rotate shares to reset Forgotten passphrases w/o sweeping funds
- Rotate shares to change thresholds w/o sweeping funds
- Generate extra shares w/o rotating or replacing existing shares [function not yet written]
- Automatic Cloud backups aka [Seedless setup](https://bitcoin.design/guide/how-it-works/private-key-management/cloud-backup/)  [function not yet written]

## Bails L2 Scope ([External Signer](https://bitcoin.design/guide/how-it-works/private-key-management/external-signers/) [Savings Wallet](https://bitcoin.design/guide/designing-products/personal-finance/#savings)) 
_No code has been written for any of the following and unclear scope or value-proposition of features. Insufficiently different from L3, suggest to prioritize and combine._

- Restore codex32 seed backups either <i>Persistently</i> creating the encrypted wallet in `$HOME/Persistent/.bitcoin/wallets` or <i>Offline</i> in RAM `/tmp/wallets` RAM (for cold storage)
- Option to store a persistent watch-only wallet when restored to RAM (for a savings account that keeps the seed & private keys offline on paper)
- Display a QR code of the public descriptor to make a watch-only wallet across an airgap
- Scan a descriptor QR code or paste and import the watch-only wallet into Bitcoin Core (yeti cold, hwws, airgapped PCs, etc)
- Display & scan PSBT QRs for crossing the airgap when signing a transaction
- Install option to create always offline Bails signing devices (no Persistent folder needed, welcome screen needed to persist Offline mode)
- Only 1 PC is required. Online & Offline Bails USBs are made.
- The signed PSBT can be saved to the Online Bails persistent storage with both simultaneously inserted. (insufficient space on old laptops)
- Use BIP85 to allow one seed backup to create multiple wallets [possible codex32 extension for this, postpone]
  - BIP85 could allow restoring a hot wallet and offline savings account or a normal and no-KYC wallet from one seed backup. Or make secret wallets you can deny exist until your seed is restored. [unclear feature]
- DVD backups of the Bails USB data (more durable??) [unclear benefits]


## Bails L3 Scope ([Multi-key](https://bitcoin.design/guide/how-it-works/private-key-management/multi-key/) [Investment Wallet](https://bitcoin.design/guide/how-it-works/private-key-management/overview/#picking-a-scheme-for-your-product))
_No code has been written for any of the following, unclear scope and value-proposition of features._

- Coordinate 2-of-2 multi-sig between `Bails/hi` (a checking+savings account) and `Bails/Offline` (an always offline PC)
- `Bails/hi` would gain an additional location and become the 1st key in multi sig
- `Bails/Offline` would be the 2nd key and backed up with a 3-of-3 shares w/ a share derived from the hash of `Bails/hi` seed and another derived from passphrase
- Minimum 7 locations needed, only 1 would store 2 shares giving away the possible 2-of-2, `Bails/hi` would NOT need to be rotated just an extra share generated & stored
- Descriptors do NOT need to be stored in 2-of-2 multi sig, but could be for deposit convenience at expense of privacy
- If a watch-only wallet is stored, recommend to heavily encrypt by seed hash of `Bails/hi` or `Bails/Offline`, as knowing either seed would allow finding the taproot and spent addresses on blockchain.

## Bails L4 Scope ([Multi-party Multi-key](https://bitcoin.design/guide/how-it-works/private-key-management/overview/#shared-schemes) [Life Savings Shared Wallet](https://bitcoin.design/guide/shared-wallet/))
_No code has been written for any of the following, unclear value proposition and/or scope of features._

- Coordinate multi-party multi-sigs between multiple Bails/2-of-2 users for inheritance. Threshold must require at least 1 offline signature
- Option to decay the Bails/2-of-2 to 1-of-2 or the multi-party multi sig to reduce lost risk after LONG time spans (5 years recommended)
