# Migrating from the legacy bails-wallet

CipherStick no longer creates or restores wallets itself. This change removes the legacy wallet code; it does not delete existing Bitcoin Core wallet data or replace your Codex32 backups.

Before updating:

- keep every existing Codex32 paper/QR backup and any passphrase needed to use it;
- keep a backup of your existing Tails Persistent Storage or Bitcoin Core wallet data;
- do not delete or overwrite existing wallet directories merely because `bails-wallet` is no longer installed;
- do not import or expose private keys to Sparrow automatically.

Sparrow is the only temporarily supported wallet coordinator, but migration is intentionally not automatic. Existing wallet recovery should use the wallet's established backup material and be verified before old state is discarded.

Replacement Codex32 restoration is tracked in issue #215 and is reviewed separately from this removal. Until that replacement is available and tested, users who depend on the legacy restore path should retain a known-good copy of the previous CipherStick release for recovery use and should not destroy their existing wallet state.
