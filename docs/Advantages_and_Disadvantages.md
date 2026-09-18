# CipherStick advantages and disadvantages

CipherStick is experimental automation for installing and configuring Bitcoin Core on Tails. This document describes properties of the current implementation separately from planned designs.

## Implemented properties

1. **Full-node validation**: Bitcoin Core validates blocks and transactions locally rather than relying on a third-party wallet server.
2. **Tor-routed operating environment**: CipherStick runs on Tails and configures Bitcoin Core for the local Tor proxy. This reduces some network metadata exposure but does not guarantee anonymity.
3. **Encrypted Persistent Storage**: Tails Persistent Storage protects data at rest when it is locked. An unlocked session, compromised hardware, or a disclosed passphrase remains able to expose data.
4. **Verified Bitcoin Core downloads**: the installer checks Bitcoin Core checksums and release signatures before installation. Open security issues track further hardening of signer identity and release-bound metadata.
5. **Portable setup**: the supported deployment uses a dedicated Tails USB rather than installing CipherStick onto the computer's internal storage.
6. **Open source**: the installer scripts can be inspected and independently reviewed.

## Current limitations

1. **Alpha maturity**: CipherStick has limited independent review and should be treated as experimental software.
2. **Installer trust**: CipherStick scripts execute in the user's Tails session and modify Persistent Storage. Bugs or a compromised project release can therefore affect the installation.
3. **No anonymity guarantee**: exchanges, merchants, counterparties, browser activity, compromised hardware, and other endpoints can still correlate Bitcoin activity with a person.
4. **Physical access remains important**: possession of the USB plus its passphrase, or access to an already-unlocked session, can expose persistent data.
5. **Bitcoin Core synchronization is resource intensive**: initial block download and ongoing storage requirements vary with hardware, pruning settings, and network performance.
6. **User error remains possible**: unsafe shutdown, weak or lost passphrases, copying untrusted blockchain state, and operational mistakes can cause loss of availability or privacy.
7. **Unfinished features are not supported**: Clone and Backup menu workflows are not complete. The legacy Codex32 wallet is being removed from the supported current-Tails path.

## Planned or separately reviewed work

The following designs are not current CipherStick security properties:

- fresh-Tails handoff and selective blockchain-data transfer;
- replacement Codex32 restoration using `python-codex32`;
- AssumeUTXO-assisted startup;
- offline or air-gapped signing;
- multisig and inheritance coordination;
- cold-storage and panic-mode wallet designs.

Setup duration is not stated as a fixed number. Hands-on installation time and Bitcoin Core synchronization time are different measurements and depend strongly on the hardware and network used.
