# Legacy CipherStick Wallet Recovery

The custom `bails-wallet` application and bundled Codex32 implementation are no longer part of the supported CipherStick runtime. Existing users should preserve recovery material and standard Bitcoin Core wallet data before updating or changing media.

## Do not destroy existing state

Before changing an existing CipherStick:

1. shut Bitcoin Core down cleanly;
2. keep the original CipherStick USB unchanged until recovery has been tested;
3. preserve every Codex32 share and any passphrase needed to reach its threshold;
4. make a separate backup of any Bitcoin Core wallet directory you intend to keep.

Removal of wallet code from this repository does not intentionally delete Bitcoin Core wallet data. Until deterministic stale-file removal is implemented, an update may also leave old CipherStick scripts on disk; their presence does not make those scripts supported.

## Existing Bitcoin Core wallets

The legacy flow created Bitcoin Core wallets through Bitcoin Core RPC and imported descriptors into those wallets. Wallet directories already present under the Bitcoin Core data directory remain Bitcoin Core wallet data; they do not require `bails-wallet` merely to exist.

Use the Bitcoin Core version appropriate for the wallet data, keep an untouched backup, and use Bitcoin Core's documented wallet loading and migration procedures. Do not automatically copy private keys into Sparrow or another coordinator as part of this removal.

## Codex32 backups

Codex32 shares remain recovery material even though the bundled implementation is removed. The replacement restoration path is tracked in issue #215 and uses the separately reviewed `python-codex32` project to recover a master seed for Bitcoin Core.

Until that replacement is reviewed and merged:

- keep the original shares unchanged;
- do not discard the original CipherStick based on an untested conversion;
- do not send shares to an online service for decoding;
- do not assume a third-party Codex32 tool has the same error-correction or derivation behavior as the removed implementation.

## Migration boundary

This removal deliberately does not migrate private keys automatically. A future recovery tool must make secret lifetime explicit, avoid unintended persistence of the recovered master seed, and restore into Bitcoin Core without reintroducing the old `bails-wallet` codebase.
