## Current supported installer scope

The current alpha installs and configures Bitcoin Core on dedicated Tails USB
sticks:

- Download and verify Bitcoin Core.

- Help configure Tails **Persistent Storage** for Bitcoin Core.

- Install and configure Bitcoin Core on Tails.

- Provide passphrase memorization assistance.

- Install the pinned `python-codex32` graphical application for Codex32 backup
  and recovery.

- Turn a copied CipherStick into a CryoStick and give it a distinct desktop and
  launcher icon.

- Check Tails **Offline Mode** at every CryoStick login.

- Create a CryoStick signing wallet while the online CipherStick remains
  watch-only.

No general-purpose wallet coordinator is bundled or installed. Bitcoin Core
provides wallet creation, watch-only export, and PSBT signing and broadcast.
The pinned `python-codex32` application provides Codex32 backup and recovery,
including filling the CryoStick signing wallet from a Codex32 backup.

The legacy custom wallet and bundled Codex32 implementation have been removed
from this repository. Their replacement is the pinned `python-codex32`
application.

## Current offline signing scope

[CryoStick](CRYOSTICK.md) is the offline signer:

- A copied CipherStick can be marked as a CryoStick. Its red desktop and
  CryoStick launcher icon distinguish it from the online CipherStick.

- CryoStick checks **Offline Mode** at every login. If Tails was started with
  networking enabled, CryoStick stops Tor Connection Assistant, requests Bitcoin
  Core to stop, displays a warning, and shuts Tails down.

- CryoStick checks that the **Welcome Screen** feature of **Persistent Storage**
  is enabled so Tails remembers Offline Mode.

- CryoStick checks for exposed physical network interfaces and warns you to
  disable or remove the hardware. You can choose to continue the session.

- The signing wallet can stay in **Persistent Storage**, or you can
  [keep it in memory only](CRYOSTICK.md#keep-the-signing-wallet-in-memory-only).
  The memory-only wallet is recovered from Codex32 shares and lost on shutdown.
  An existing persistent wallet is not removed by choosing a memory-only path.

- Bitcoin Core exports a watch-only wallet for the online CipherStick. The
  CipherStick creates an unsigned PSBT, CryoStick signs it offline, and the
  CipherStick broadcasts the signed transaction.

- The [QR transfer instructions](CRYOSTICK.md#send-bitcoin) use terminal commands
  to move wallet data and PSBTs between the sticks.

The [QR round-trip test](../tests/cryostick-qr-roundtrip.sh) exercises wallet
export, watch-only restoration, PSBT signing, QR transfer, and broadcast on a
single regtest node. It does not test the Tails desktop or webcam transfer
between two computers.

## MVP requirement for sharing clones

A clone given to another person must not disclose private wallet material.
Tails Cloner copies Persistent Storage, including wallets stored there. The
recipient can unlock the cloned Persistent Storage, so its encryption does not
isolate those wallets from the recipient.

The MVP offers **Backup** when wallets are saved in Persistent Storage and
**Clone** only when no wallets are saved there. A stateless signer can remain
cloneable by keeping its wallet in memory only. Wallet detection must cover the
supported persistent wallet locations; an empty default wallet directory alone
is not sufficient. Do not present the unfinished Clone and Backup actions as
available until their Tails-native implementation and checks are complete.

Encrypted wallet containers and panic-mode workflows are later enhancements,
not prerequisites for this MVP policy. Until a separate isolation design is
implemented and reviewed, a full copy containing persistent wallets is a
private backup, not a clone to give another person.

## Legacy MVP scope

The historical MVP included these goals. They describe past implementation
intent, not current support guarantees:

- Create and restore a Codex32 seed backup.

- Create a standard derivation-path wallet from a Codex32 seed.

- Encrypt wallet material with a memorized passphrase.

## In progress or planned

- Fresh-Tails handoff with explicit, user-selected data transfer.

- Reminders after initial block download to create a backup.

- Use AssumeUTXO to shorten time to usefulness.

- Optional Codex32 QR workflows.

## Future offline signing enhancements

- Transfer wallet data and PSBTs without typing terminal commands.

- Verify receive addresses in the offline-signing flow.

- Support offline read-only signing devices.

## Future multisig and inheritance scope

No supported multisig or inheritance coordinator exists today. Potential future
work includes:

- Coordinate multisig with established external software instead of implementing
  another coordinator in CipherStick.

- Support multi-party inheritance policies.

- Support time-based recovery policies.

- Add independently backed signing devices.

These future designs require separate threat models, tests, and review before
they are presented as supported security properties.
