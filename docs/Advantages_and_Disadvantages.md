# Bails Bitcoin Wallet and Cold Storage

Bails is a script that installs Bitcoin Core on Tails. It then walks the user though setup of an anonymous transaction and cold storage solution offering several advantages:

## Advantages

1. **Privacy and Safety Priority**: Bails prioritizes privacy and safety over ease of use, requiring users to take necessary steps for secure bitcoin storage and private usage. The first step is installing a trustworthy operating system, Tails to a USB.

1. **Encrypted Wallet and Private Keys**: Bails encrypts both the wallet and private keys to prevent snooping on your Bitcoin use in case of compromised backups.

1. **Persistent Wallet**: Bails is persistent, your wallet is saved and will load whenever you start Tails and unlock your Persistent Storage, saving time in the long run.

1. **Codex32 Seed Backups**: Bails uses easy-to-write Codex32 seed backups, providing privacy and redundancy, tolerating loss or breach of 1-2 locations as well as loss of the passphrase.

1. **Memorized Passphrase for Seed Backup**: A codex32 share to your backup is derived from a memorized passphrase, reducing the number of backup locations needed.

1. **Multi-sig for High-Value Bitcoin Savings**: A 2-of-2 multi-sig is used between the online seed backup (3 of 5 Codex-32) and an offline seed backup (3-of-3 Codex-32) stored across 7 locations, ensuring redundancy. This protects against one of the 2 signing devices being compromised.

1. **Multi-party Multi-sig for Inheritance Protection**: Bails uses a 4-of-6 multi-party multi-sig for bitcoin inheritances, requiring collaboration of at least 2+ parties to spend, ensuring long-term savings are inaccessible without high-quality verification.

1. **Offline Private Keys**: Private keys to Savings wallets are never on an internet-connected device with data movement limited to QR codes, enhancing security. Spending wallets are online with keys protected only by encryption for more convenient spending.

1. **HD Wallets**: Bails uses HD wallets to send funds to thousands of addresses and recover funds from the original paper seed backup, improving privacy and loss resistance.

1. **Minimal Software Beyond Bitcoin Core**: Bails minimizes code, primarily using python and bash scripts making it easily auditable.

1. **Open Source and Auditable**: Bails is open-source and auditable, minimizing code review efforts.

1. **Usable for Non-Technical Users**: Bails provides simple instructions and an intuitive interface for users with minimal computer literacy.

1. **Private Keys Protection**: Private keys are stored in non-descript, tamper-evident packaging and held by trusted individuals such as heirs and professionals.

1. **Privacy Focus**: Bails uses a full node, giving perfect receiving privacy, while using the Tor-network hides and encrypts the source of any transaction you broadcast. Most other wallets ask a trusted third party to show your balance and broadcast your transactions who can sell your data.

1. **Counterfeit Prevention**: Bails ensures your bitcoin balance is genuine by using a full node. Most wallets ask a trusted a third party who can lie to you. 

1. **Minimal Hardware**: Bails requires access to one or two cheap computers, making it cost-effective. The computer does not need to be erased to use Bails as it runs from the USB stick.

1. **Fast Setup**: Bails can be completed by non-technologists with minimal effort in under an hour.

1. **Bails Cloning**: Bails installations can be cloned for friends and family, saving time required to sync the blockchain for the recipient and providing an additional encrypted wallet backup for the Bails cloned.

1. **Bails Backup USBs**: Bails creates backup USB sticks of itself, saving time in case of USB loss or damage.

## Disadvantages

While Bails provides the best balance of privacy, security, ease of use, and cost when storing privacy-critical sums of bitcoin, it has the following disadvantages that might not be expected:

1. **Setup Time**: Completing the setup requires investing approximately 45 minutes spread over a couple of days.

1. **Reduced Redundancy if Passphrase Lost**: Privacy and fast setup conflict with redundancy. Forgetting the memorized passphrase increases the risk of loss.

1. **Wallet Privacy**: Bails USBs will unlock with just the passphrase alone, potentially revealing transactions and balances if both the passphrase and USB are compromised.
