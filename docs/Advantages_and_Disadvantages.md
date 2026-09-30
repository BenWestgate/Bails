# CipherStick Bitcoin Wallet and Cold Storage

CipherStick is a script that installs Bitcoin Core on Tails. The legacy in-tree wallet implementation has been removed; replacement Codex32 tooling is maintained separately.

## Advantages

1. **Privacy and Safety Priority**: CipherStick prioritizes privacy and safety over ease of use, requiring users to take necessary steps for secure bitcoin storage and private usage. The first step is installing a trustworthy operating system, Tails to a USB.

1. **Encrypted Persistent Storage**: Tails Persistent Storage protects persistent application and Bitcoin data while the storage is locked.

1. **Codex32 Seed Backups**: CipherStick uses easy-to-write Codex32 seed backups, providing privacy and redundancy and tolerating loss or breach of 1-2 locations.

1. **Planned Multi-sig for High-Value Bitcoin Savings**: The planned savings design uses 2-of-2 multi-sig between online and offline Codex32-backed signers, so compromising one signing device is insufficient to spend.

1. **Planned Multi-party Multi-sig for Inheritance Protection**: The planned inheritance design uses multi-party multi-sig so spending requires collaboration between independent parties.

1. **Planned Offline Private Keys**: The planned savings design keeps private keys off Internet-connected devices and moves signing data by QR code.

1. **Minimal Software Beyond Bitcoin Core**: CipherStick minimizes code, primarily using python and bash scripts making it easily auditable.

1. **Open Source and Auditable**: CipherStick is open-source and auditable, minimizing code review efforts.

1. **Usable for Non-Technical Users**: CipherStick provides simple instructions and an intuitive interface for users with minimal computer literacy.

1. **Planned Private Key Storage**: The planned savings design stores recovery material in non-descript, tamper-evident packaging held in separate trusted locations.

1. **Privacy Focus**: CipherStick uses a full node, giving perfect receiving privacy, while using the Tor-network hides and encrypts the source of any transaction you broadcast. Most other wallets ask a trusted third party to show your balance and broadcast your transactions who can sell your data.

1. **Counterfeit Prevention**: CipherStick ensures your bitcoin balance is genuine by using a full node. Most wallets ask a trusted a third party who can lie to you. 

1. **Minimal Hardware**: CipherStick requires access to one or two cheap computers, making it cost-effective. The computer does not need to be erased to use CipherStick as it runs from the USB stick.

1. **Fast Setup**: CipherStick can be completed by non-technologists with minimal effort in under an hour.

1. **CipherStick Cloning**: CipherStick installations can be cloned for friends and family, saving time required to sync the blockchain for the recipient and providing an additional encrypted wallet backup for the CipherStick cloned.

1. **CipherStick Backup USBs**: CipherStick creates backup USB sticks of itself, saving time in case of USB loss or damage.

## Disadvantages

While CipherStick provides the best balance of privacy, security, ease of use, and cost when storing privacy-critical sums of bitcoin, it has the following disadvantages that might not be expected:

1. **Setup Time**: Completing the setup requires investing approximately 45 minutes spread over a couple of days.

1. **Persistent Storage Passphrase Loss**: Losing the Tails Persistent Storage passphrase can make its encrypted contents inaccessible, so wallet recovery material must be backed up separately.

1. **Wallet Privacy**: CipherSticks will unlock with just the passphrase alone, potentially revealing transactions and balances if both the passphrase and USB are compromised.
