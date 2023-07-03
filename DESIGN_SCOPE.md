***Bails MVP Scope:***

Downloads Bitcoin and Signatures

Helps sets up Tails Persistence for Bitcoin

Helps user remember passphrase w/ spaced repetition

Verifies Bitcoin download

Installs Bitcoin Core on Tails

Creates a codex32 seed backup

Restores a codex32 seed backup

Creates a standard derivation path wallet from codex32 seed encrypted by memorized passphrase


***Bails L1 Scope:***

Create backups of the Bails USB for recovery without rescanning blockchain. 

Create clones of the Bails USB with all private data encrypted to give to friends & family to decentralize distribution, bypass download wait, User gets private data redundancy
	
Rotate shares to reset Forgotten passphrases w/o sweeping funds

Rotate shares to change thresholds w/o sweeping funds

Generate extra shares w/o rotating or replacing existing shares [function not yet written]

Give periodic reminders to create new USB backups to replace the old ones before they die.


***Bails L2 Scope:***		[no code written for any of the following and unclear scope or value-proposition of features ]

Restores codex32 seed backups either creating the encrypted wallet persistently or offline and in RAM (for cold storage)

Option to create a persistent watch only wallet when restored to RAM (for a savings account that keeps the seed & private keys offline on paper)

Display a QR code of the public descriptor for making a watch only across an airgap.

Scan a QR code of a descriptor (or paste) and import the wallet to bitcoin core (yeti cold, airgap)


Display & Scan PSBT QRs for crossing the airgap when signing a transaction.

DVD backups of the Bails USB data (more durable)??

use BIP85 to allow one seed backup to create multiple wallets.

BIP85 could allow restoring a hot wallet and offline savings account or a normal and no-KYC wallet from one seed backup. Or make secret wallets you can deny exist until your seed is restored. [unclear feature]


***Bails L3 Scope:*** [no code written for any of the following, unclear scope and value-proposition of features ]

Coordinate 2-of-2 multi-sig between a Bails/hi checking+savings account and an always offline PC

Bails/hi would gain an additional location and become the 1st key in multi sig

Bails/Offline would be key2 and backed up with a 3-of-3 shares w/ a share derived from the hash of Bails/hi seed and another derived from passphrase

Minimum 7 locations needed, only 1 would store 2 shares giving away the 2-of-2, Bails/hi would NOT need to be rotated just an extra share generated & stored

Descriptors do NOT need to be stored in 2-of-2 multi sig, but could be for deposit convenience at expense of privacy.

If a watch only wallet is stored, Recommend to heavily encrypt by seed of Bails/hi or Bails/Offline. (as knowing either seed would allow finding taproot and spent addresses on blockchain)


***Bails L4 Scope:*** [no code written for any of the following, unclear value proposition and/or scope of features ]

Coordinate multi-party multi-sigs between multiple Bails/2-of-2 users for inheritance. Threshold must require at least 1 offline signature

Option to decay the Bails/2-of-2 to 1-of-2 or the multi-party multi sig to reduce lost risk after LONG time spans (5 years recommended)
