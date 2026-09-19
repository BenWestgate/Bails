# CipherStick Threat Model

This document describes the security boundary of the supported CipherStick installer and handoff workflow. It does not replace the threat models or security guidance of Tails, Bitcoin Core, or Sparrow.

## Supported deployment

CipherStick is intended for a dedicated USB running the current stable Tails release. The supported runtime installs and configures Bitcoin Core and Sparrow. Sparrow is the supported wallet coordinator. The legacy custom wallet is being removed from the target runtime; replacement Codex32 recovery is reviewed separately.

## Assets

CipherStick must avoid exposing or corrupting:

- Tails Persistent Storage and its passphrase;
- Bitcoin Core wallet data, node data, and configuration;
- Sparrow wallet metadata and configuration;
- downloaded Bitcoin Core, Sparrow, and CipherStick software;
- any recovery material transiently handled by a supported restore flow;
- user-selected data transferred during a future fresh-Tails handoff.

## Trust boundaries

### CipherStick bootstrap and updates

Code obtained from the network crosses into the user's Tails session and can modify Persistent Storage. Current mutable-repository bootstrap/update behavior is not an authenticated immutable release boundary. Issue #206 tracks replacing or disabling that path until a project signing key authenticates the exact release payload before execution.

### Bitcoin Core releases

CipherStick downloads Bitcoin Core release artifacts and verifies their checksums and OpenPGP signatures. The accepted signer set and pruning metadata are part of CipherStick's boundary because local installer policy decides what is trusted. Issues #204 and #207 track distinct approved signers and release-bound pruning metadata.

### Sparrow releases

CipherStick downloads Sparrow packages and verifies the signed manifest. Acceptance must be bound to Sparrow's expected publisher fingerprint rather than any unrelated key in the user's persistent keyring. Issue #205 tracks that binding.

### Persistent Storage

CipherStick guides Persistent Storage setup and writes configuration, binaries, and state beneath the unlocked Tails persistence mount. Tails owns encryption and unlock behavior; CipherStick owns the paths it writes, permissions it sets, and any secrets it transiently captures.

### Fresh-Tails handoff

The supported distribution direction is a fresh Tails installation with new Persistent Storage, an authenticated CipherStick archive, and optional data selected explicitly by the person performing the transfer. CipherStick must not silently decide whether wallet ciphertext, keys, logs, configuration, or identifying state is copied. Issue #213 tracks the handoff documentation.

## Adversaries and failure modes

CipherStick considers the following risks where its installer or claims change the user's exposure:

- compromise of the project repository, release account, mirror, or download path;
- a valid signature from an unrelated key being accepted for a package;
- one approved signer being counted more than once toward a release threshold;
- mutable upstream source metadata being trusted independently of an authenticated release;
- accidental transfer of wallet or identifying state during device handoff;
- incorrect permissions, stale files, or partially applied updates in Persistent Storage;
- an unlocked Tails session being observed or controlled by another person or process;
- a network observer, peer, counterparty, or service correlating Bitcoin activity despite Tor;
- interrupted Bitcoin Core writes, exhausted storage, or unsafe shutdown causing loss of node progress;
- loss of passphrases or recovery material.

## Inherited upstream risks

CipherStick does not claim to eliminate risks that remain in the projects it builds on. In particular:

- Tails cannot protect a user from compromised hardware, firmware, hardware keyloggers, or every form of physical attack. See the [Tails warnings](https://tails.net/doc/about/warnings/index.en.html).
- Tor reduces direct network-location exposure but does not guarantee protection from all traffic-correlation or endpoint attacks. See the [Tails Tor documentation](https://tails.net/doc/anonymous_internet/tor/index.en.html).
- Bitcoin Core initial block download is resource intensive, and pruning trades historical block retention for lower storage use. See [Bitcoin Core documentation](https://bitcoincore.org/en/doc/).
- Sparrow has its own wallet, signing, and application security model. CipherStick's responsibility is limited to the installation and configuration choices it makes around Sparrow. See [Sparrow documentation](https://sparrowwallet.com/docs/).

An upstream risk should be duplicated here only when CipherStick depends on it, changes it, amplifies it, or makes a related security claim.

## Residual risks

Even if every planned hardening issue is complete:

- control of an unlocked session can expose data available to that session;
- compromised firmware or hardware can observe secrets below the operating-system boundary;
- counterparties and blockchain analysis can correlate transactions;
- a strong encryption passphrase does not provide coercion resistance;
- losing required secrets or recovery material can permanently lose funds;
- malformed or malicious inputs can still expose implementation bugs in Bitcoin Core, Sparrow, Tails, or CipherStick;
- pruning and initial synchronization still depend on adequate storage, memory, network access, and safe shutdown.

## Non-goals

CipherStick does not guarantee:

- that Bitcoin activity leaves no network trace;
- protection from confiscation or coercion;
- anonymity against a global passive adversary;
- safety on compromised hardware or firmware;
- recovery of lost secrets;
- that planned or experimental features provide security before they are merged, tested, and reviewed.

## Claim rule

Every CipherStick security or privacy claim should map to an implemented installer or handoff property and state the material residual risk. Planned, experimental, and unsupported controls must be labeled as such.
