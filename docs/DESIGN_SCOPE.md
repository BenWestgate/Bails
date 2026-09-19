# CipherStick Design Scope

CipherStick is alpha software. This document separates behavior that is currently supported from experimental, planned, and unsupported work. A feature appearing in an issue, old README, discussion, or source file does not make it supported.

## Supported now

The supported runtime is a guided installer on a dedicated Tails USB. Current supported behavior is limited to:

- guiding required Tails Persistent Storage setup;
- downloading, verifying, and installing Bitcoin Core;
- configuring Bitcoin Core for Tails, Tor proxying, and storage-aware pruning;
- installing Sparrow as the supported wallet coordinator;
- helping the user practice the Persistent Storage passphrase with spaced repetition.

These controls do not guarantee anonymity, protection from confiscation, resistance to coercion, or safety on compromised hardware. CipherStick has not completed an independent security audit.

## Experimental / legacy

- The bundled GTK3 Codex32 wallet flow is legacy code and is scheduled for removal rather than extension.
- Existing backup/clone scripts are incomplete and are not supported user workflows.

Experimental code must not be described as a security property users can rely on.

## Planned work

The following work has an issue or design direction but is not currently supported:

- replacement Codex32 recovery using the separately developed `python-codex32` project;
- fresh-Tails handoff using an authenticated CipherStick release and explicit user-selected data transfer;
- authenticated immutable CipherStick releases and updates;
- AssumeUTXO-assisted initial synchronization;
- Codex32 QR import/export and share-management improvements.

Planned features should remain absent from primary setup instructions until they are implemented, tested, and reviewed.

## Future / unsupported designs

The following ideas are not current CipherStick capabilities:

- offline or air-gapped signing;
- automatic cloud backups;
- stateless/amnesic signing devices;
- CipherStick-managed multisignature, inheritance, or timelocked wallet policies;
- PSBT transfer across an air gap;
- automatic backup-USB creation or full persistent-state cloning;
- BIP85-based wallet derivation;
- coercion-resistant or deniable wallets.

These may be explored in separate proposals. They should not appear in current security, privacy, setup-time, or recovery claims until an implementation is merged and covered by the supported threat model.

## Review rule

When documentation and implementation disagree, documentation must be corrected to the implemented and tested behavior. Security and privacy claims should name the control that provides the property and the material residual risks that remain.
