# Legacy CipherStick Wallet Recovery

The custom `bails-wallet` application and bundled Codex32 implementation are no longer part of the supported CipherStick runtime. Existing users should preserve recovery material and standard Bitcoin Core wallet data before updating or changing media.

## Do not destroy existing state

Before changing an existing CipherStick:

1. shut Bitcoin Core down cleanly;
2. keep the original CipherStick USB unchanged until recovery has been tested;
3. preserve every Codex32 share and any passphrase needed to reach its threshold;
4. make a separate backup of any Bitcoin Core wallet directory you intend to keep.

Updating removes the old wallet scripts; it does not touch Bitcoin Core wallet data or Codex32 shares.

## Existing Bitcoin Core wallets

The legacy flow created Bitcoin Core wallets through Bitcoin Core RPC and imported descriptors into those wallets. Wallet directories already present under the Bitcoin Core data directory remain Bitcoin Core wallet data; they do not require `bails-wallet` merely to exist.

Use the Bitcoin Core version appropriate for the wallet data, keep an untouched backup, and use Bitcoin Core's documented wallet loading and migration procedures. Do not automatically copy private keys into another coordinator as part of this removal.

## codex32 backups

codex32 shares remain recovery material even though the bundled implementation is removed. The replacement restoration path uses the pinned `python-codex32` graphical application installed by CipherStick.

To restore with the replacement flow:

1. keep the original shares unchanged and do not send them to an online service;
2. start Bitcoin Core 32 or newer with local RPC enabled;
3. open **codex32**, choose **Restore my wallet**, and enter the required shares;
4. type the master fingerprint from the separately stored wallet record before import; if that record is unavailable, verify the recovered fingerprint independently before accepting the explicit warning;
5. let Bitcoin Core finish scanning, then verify the expected wallet history before relying on the restored wallet.

Do not assume a third-party codex32 tool has the same correction or derivation behavior as CipherStick's pinned `python-codex32` revision. Keep the original CipherStick unchanged until recovery has been tested.

## Migration boundary

This removal deliberately does not migrate private keys automatically. The replacement keeps recovery logic in `python-codex32`, avoids persisting the recovered master seed in Bails, and restores through Bitcoin Core without reintroducing the old `bails-wallet` codebase.
