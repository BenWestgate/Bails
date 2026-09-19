# Fresh-Tails CipherStick Handoff

CipherStick distribution should start from a fresh Tails installation owned by the recipient. Do not treat a full Persistent Storage clone as a selective backup or distribution mechanism.

This document defines the supported handoff boundary. It does not implement a transfer helper.

## Preconditions

- The recipient installs or clones **Tails itself** using normal Tails procedures.
- The recipient creates and unlocks their own Persistent Storage.
- CipherStick is transferred as an immutable release archive whose authenticity can be checked before any code from that archive is executed.
- If authenticated CipherStick releases are not available yet, stop. Do not substitute a mutable Git checkout and do not execute an unauthenticated archive.
- Bitcoin Core must be shut down cleanly before any optional node-data copy.

## 1. Install fresh Tails

Follow the official [Tails installation documentation](https://tails.net/install/index.en.html). The destination should not inherit another person's Persistent Storage as part of the CipherStick workflow.

After booting the destination, create and unlock Persistent Storage for the recipient. The recipient chooses and controls that passphrase.

## 2. Transfer CipherStick software

Copy the versioned CipherStick release archive and its authentication material to the destination. Before extraction or execution:

1. identify the exact release version;
2. verify the archive using the project authentication method shipped by the trusted release process;
3. fail closed if the signature, digest, expected signing key, or version does not match;
4. only then extract the archive into the unlocked destination and run the documented installer entry point.

Issue #206 tracks the release-signing trust root and exact verification mechanism. Until that mechanism exists, this handoff workflow is not complete enough for production use.

## 3. Choose optional data explicitly

Software transfer and data transfer are separate decisions. CipherStick must not silently decide what additional state follows the software.

The person performing the handoff selects every optional path. For each selected path, show or document:

- source device and source path;
- destination device and destination path;
- estimated data size;
- whether the data may contain wallet material, identifying metadata, logs, or configuration;
- whether the producing application must be stopped before copying;
- whether version compatibility matters.

### Bitcoin Core data

Copying selected Bitcoin Core node data can avoid some redownload work, but it is optional. Prefer copying only data the user intends to transfer. Bitcoin Core should be shut down cleanly first, and the destination should use a compatible Bitcoin Core version.

Do **not** implicitly include `wallets/`, configuration, debug logs, cookie files, or unrelated Persistent Storage merely because `blocks/` or `chainstate/` was selected.

### Wallet or identifying state

Wallet files, Sparrow state, keys, recovery data, logs, configuration, and other identifying state require an explicit user decision. They must never be bundled automatically with the CipherStick release or an optional blockchain-data transfer.

## 4. Confirm before copying

Any future transfer helper must present a final summary before writing:

- exact source;
- exact destination;
- every selected path;
- every path that may contain wallet or identifying state;
- total expected transfer size;
- confirmation that required applications are stopped.

Cancellation must leave the destination usable and must not erase source data.

## What this replaces

The supported CipherStick workflow does not ask users to:

- use Tails Cloner as a selective CipherStick backup tool;
- copy another user's entire encrypted Persistent Storage by default;
- reuse another user's Persistent Storage passphrase;
- rely on an unfinished `Clone` or `Backup` menu action;
- assume that cloning itself provides censorship resistance, privacy, or backup safety.

Tails may still provide its own cloning tools for Tails-specific purposes. Those tools are not a CipherStick policy for deciding which Bitcoin or wallet state another person should receive.
