## Current supported installer scope

The current alpha is primarily an installer and configuration layer for dedicated Tails USB sticks:

- Download and verify Bitcoin Core.
- Help configure Tails Persistent Storage for Bitcoin Core.
- Install and configure Bitcoin Core on Tails.
- Provide passphrase memorization assistance.
- Install the pinned `python-codex32` graphical application for Codex32 backup and recovery.
- Turn a copied CipherStick into a dedicated CryoStick, visually distinguish it, and require Tails Offline Mode on every login.
- Create a CryoStick signing wallet and use it to sign PSBTs while the online CipherStick remains watch-only.

No general-purpose wallet coordinator is bundled or installed. The supported `python-codex32` application provides Codex32 backup and recovery and is used to create the CryoStick signing wallet.

CryoStick offline signing is supported today, but Bails does not yet provide a bespoke GUI for sending PSBTs across the air gap. Bitcoin Core provides the wallet and PSBT operations, while the current Bails workflow uses terminal commands to move watch-only wallet data and PSBTs between the online CipherStick and offline CryoStick.

The legacy custom wallet and bundled Codex32 implementation have been removed from this repository. Their supported replacement is the pinned `python-codex32` application.

## Current offline signing scope

CryoStick is the supported offline signer:

- A copied CipherStick can be marked as a CryoStick.
- CryoStick distinguishes itself with a red desktop and CryoStick launcher identity so it is not confused with the online CipherStick.
- Once marked as a CryoStick, it requires Tails Offline Mode at every login. If it is started with networking enabled, it stops Bitcoin Core and Tor Connection Assistant and shuts Tails down.
- CryoStick also checks for exposed physical network interfaces and warns the user to disable or remove the hardware.
- A signing wallet can be created on the CryoStick with `codex32`.
- A watch-only copy of the wallet can be moved to the online CipherStick.
- The CipherStick can create an unsigned PSBT, the CryoStick can sign it offline, and the signed PSBT can be returned to the CipherStick for broadcast.
- The current air-gap transport is manual and terminal-driven, using QR-code commands documented in `docs/CRYOSTICK.md`.

The end-to-end wallet export, PSBT signing, QR crossing, and broadcast path is exercised by `tests/cryostick-qr-roundtrip.sh`.

## Legacy MVP scope

The historical MVP included the following goals. Items in this section describe past implementation intent, not current support guarantees:

- Create and restore a Codex32 seed backup.
- Create a standard derivation-path wallet from a Codex32 seed.
- Encrypt wallet material with a memorized passphrase.

## In progress or planned

- Fresh-Tails handoff with explicit, user-selected data transfer.
- Reminders after initial block download to create a backup.
- Use AssumeUTXO to shorten time to usefulness.
- Panic-mode wallet workflows.
- Optional Codex32 QR workflows.
- A Bails-specific user interface or automation for PSBT air-gap crossings so users do not need to type the current terminal commands.
- Receive-address verification for the offline-signing flow.

## Future offline signing enhancements

Potential future work includes:

- an amnesic/stateless signer that recovers a signing wallet from Codex32 shares and forgets private keys on shutdown;
- more automated descriptor and PSBT transfer across the air gap;
- offline read-only signing devices;
- additional watch-only wallet workflows for monitoring savings.

## Future multisig and inheritance scope

No supported multisig or inheritance coordinator exists today. Potential future work includes:

- coordinating multisig with established external software rather than implementing another coordinator in CipherStick;
- multi-party inheritance policies;
- time-based recovery policies;
- additional independently backed signing devices.

These future designs require separate threat models, tests, and review before they are presented as supported security properties.
