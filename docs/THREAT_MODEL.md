# CipherStick threat model

CipherStick is an experimental installer and configuration layer for Bitcoin Core on a dedicated Tails USB. This document describes the security properties CipherStick itself adds or changes. It does not duplicate the complete threat models of Tails, Bitcoin Core, or Sparrow.

## Supported deployment

The supported deployment assumes:

- current stable Tails on a dedicated USB device;
- Tails Persistent Storage created and unlocked by the user;
- Bitcoin Core installed and configured by CipherStick;
- Sparrow as the only temporarily supported wallet coordinator;
- no trust in an unauthenticated project download merely because it came from the project repository.

The legacy `bails-wallet`/GTK3 Codex32 wallet is outside the target supported runtime and is being removed. Replacement Codex32 restoration is reviewed separately.

## Assets

CipherStick must protect the integrity of:

- the installer and update code it executes;
- Bitcoin Core and Sparrow packages selected for installation;
- Bitcoin Core configuration and pruning settings;
- files CipherStick writes into Tails Persistent Storage;
- user choices about which state is copied during any handoff workflow.

Wallet secrets, Persistent Storage passphrases, and recovered master seeds are especially sensitive whenever a supported flow handles them.

## Trust boundaries

### Bootstrap and CipherStick updates

Code fetched from the network is untrusted until an authenticated release mechanism verifies the exact payload to be executed. A mutable Git branch is not an authentication boundary. Until release authentication is implemented, network self-update must fail closed.

### Bitcoin Core releases

CipherStick downloads Bitcoin Core and verifies the release checksum manifest and signatures. The accepted signer set and any release metadata used for configuration must be tied to the authenticated release. Open hardening work tracks distinct signer enforcement and authenticated pruning metadata.

### Sparrow releases

CipherStick may install Sparrow as the supported coordinator. The downloaded package must be accepted only when its manifest signature matches the configured Sparrow publisher fingerprint and its checksum matches the authenticated manifest.

### Tails Persistent Storage

CipherStick configures files under unlocked Persistent Storage. It therefore has authority to damage availability, permissions, or persisted configuration if the installer is buggy or compromised. The installer should change only paths it owns and should preserve intended permissions when updating them.

### Fresh-Tails handoff

A recipient should start from a normal Tails installation and create their own Persistent Storage. The CipherStick release archive is authenticated separately. Additional data, such as Bitcoin Core block or chainstate data, is optional and explicitly selected by the person performing the handoff. CipherStick must not silently include wallet ciphertext, keys, logs, or identifying state.

## Adversaries and failure modes CipherStick addresses

CipherStick should fail safely against:

- a compromised or unexpected download that is not authenticated to the expected publisher;
- a repository or delivery-path compromise that substitutes mutable project code;
- an unrelated GPG key already present in the user's keyring;
- duplicate Bitcoin Core signature records that would otherwise weaken a signer threshold;
- unauthenticated or malformed release metadata used to size pruning;
- stale or incorrect file permissions that survive an update;
- unsupported menu actions that lead users into unfinished workflows;
- accidental transfer of persistent state the user did not select.

## Inherited risks

Some important risks apply even without CipherStick. CipherStick documents them when they affect a claim or supported workflow, but does not claim to eliminate them.

- Tails documents limits from compromised hardware, firmware, installation media, and other host-level attacks: <https://tails.net/doc/about/warnings/computer/>.
- Bitcoin Core documents its own release, validation, storage, and synchronization behavior: <https://bitcoincore.org/en/download/>.
- Sparrow is an independently maintained application with its own release and operational assumptions: <https://sparrowwallet.com/>.

## Residual risks and non-goals

CipherStick does not guarantee:

- anonymity or absence of network traces;
- protection against coercion or confiscation;
- safety on compromised hardware or firmware;
- privacy from exchanges, merchants, counterparties, browser activity, or other endpoints that can identify the user;
- recovery from a lost Persistent Storage or wallet secret without a valid backup;
- safety of arbitrary blockchain or wallet data copied from an untrusted machine;
- protection of secrets after the relevant encrypted storage is unlocked on a compromised or observed session.

Physical possession of the USB plus the passphrase, or access to an already-unlocked session, can expose persistent data. Unsafe shutdown can also damage Bitcoin Core state.

## Security invariants

The supported runtime should maintain these invariants:

1. No newly downloaded CipherStick code executes before the exact release payload is authenticated.
2. Bitcoin Core acceptance requires the configured threshold of distinct approved signers and a matching archive checksum.
3. Sparrow acceptance requires the configured publisher fingerprint and a matching archive checksum.
4. Release-derived configuration metadata is authenticated to the same release it configures.
5. CipherStick updates apply intended permissions to project-managed files.
6. Unsupported or unfinished actions are absent from the normal user interface.
7. Handoff never silently decides which optional persistent paths accompany the authenticated project archive.
8. Implemented, experimental, planned, and unsupported properties are distinguished in user-facing documentation.

## Review status

CipherStick is alpha software with limited independent review. A property should not be promoted as a security guarantee until its implementation and regression coverage have been reviewed. Planned Codex32 restoration, AssumeUTXO, offline signing, multisig, inheritance, and cloning/handoff helpers require their own review before becoming supported security properties.
