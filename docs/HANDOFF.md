# Fresh-Tails handoff

CipherStick handoff starts from a fresh Tails installation. It is not a full-device clone and does not copy another person's Persistent Storage by default.

## Prerequisite: authenticate CipherStick

Do not execute a CipherStick archive merely because it came from another USB stick or GitHub. The exact archive must be authenticated using the project's release-verification instructions before execution.

Until CipherStick publishes authenticated release artifacts, executable handoff is not a supported installation path. Do not substitute a mutable repository checkout for release authentication.

## Handoff steps

1. Create the destination Tails USB using normal Tails installation procedures.
2. Start the destination Tails system.
3. Create and unlock new Persistent Storage owned by the recipient.
4. Transfer the authenticated CipherStick release archive to the destination.
5. Verify the exact archive before extracting or executing it.
6. Extract CipherStick into the recipient's unlocked Persistent Storage and run the verified installer.
7. Separately decide whether any additional data should be copied.

## Optional data transfer

Additional data is an explicit decision by the person performing the handoff. CipherStick must not silently choose what accompanies the project archive.

Useful Bitcoin Core state may include selected `blocks` and `chainstate` data. Before copying any path, identify its source, destination, and purpose.

Do not copy by default:

- wallet files or wallet ciphertext;
- private keys or seed material;
- application logs;
- browser state;
- configuration containing identifying information;
- arbitrary Persistent Storage directories.

If a selected path may contain wallet material or identifying state, tell the recipient before copying it.

## Why not Tails Cloner for selective handoff?

Tails Cloner is appropriate for making Tails media, but a full Persistent Storage copy transfers the source user's state as a unit. That is not the same operation as giving a friend CipherStick plus selected Bitcoin Core data.

The person performing the handoff decides which optional data the recipient receives. Future automation may make those explicit choices easier to execute, but it must not turn them into an implicit software policy.
