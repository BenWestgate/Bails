## Current supported installer scope

The current alpha is primarily an installer and configuration layer for a dedicated Tails USB:

- Download and verify Bitcoin Core.
- Help configure Tails Persistent Storage for Bitcoin Core.
- Install and configure Bitcoin Core on Tails.
- Provide passphrase memorization assistance.

No wallet coordinator is bundled or installed. Choosing and installing wallet software is left to the user.

The legacy custom wallet and bundled Codex32 implementation have been removed from this repository. Replacement Codex32 restoration is tracked separately in issue #215. The current Clone and Backup menu workflows remain separate unfinished work.

## Legacy MVP scope

The historical MVP included the following goals. Items in this section describe past implementation intent, not current support guarantees:

- Create and restore a Codex32 seed backup.
- Create a standard derivation-path wallet from a Codex32 seed.
- Encrypt wallet material with a memorized passphrase.

## In progress or planned

- Fresh-Tails handoff with explicit, user-selected data transfer.
- Reminders after initial block download to create a backup.
- Use AssumeUTXO to shorten time to usefulness.
- Replacement Codex32 restore flow using `python-codex32`.
- Watch-only and panic-mode wallet workflows.
- Optional Codex32 QR workflows.

## Future offline signing scope

No supported offline-signing implementation exists today. Potential future work includes:

- an amnesic/stateless signer that recovers a signing wallet from Codex32 shares and forgets private keys on shutdown;
- descriptor and PSBT transfer across an air gap;
- offline read-only signing devices;
- watch-only wallets for monitoring savings.

## Future multisig and inheritance scope

No supported multisig or inheritance coordinator exists today. Potential future work includes:

- coordinating multisig with established external software rather than implementing another coordinator in CipherStick;
- multi-party inheritance policies;
- time-based recovery policies;
- additional independently backed signing devices.

These future designs require separate threat models, tests, and review before they are presented as supported security properties.
