# Fresh-Tails Handoff

Use a fresh Tails installation when giving CipherStick to another person. A full copy of your Persistent Storage can include encrypted wallet data, configuration, logs, and identifying state that the recipient did not ask for.

## Procedure

1. The recipient installs Tails using the normal Tails procedure.
2. The recipient creates and unlocks their own Persistent Storage.
3. Transfer an authenticated CipherStick release archive and verify it before any CipherStick code runs.
4. Extract CipherStick onto the unlocked destination and complete its normal setup.
5. If you also want to transfer data, choose each path explicitly and confirm the source and destination before copying it.

The person performing the handoff decides what optional data the recipient receives. CipherStick must not silently include wallet files, keys, configuration, logs, or other persistent state.

For Bitcoin Core node data, `blocks/` and `chainstate/` may be copied after Bitcoin Core has shut down cleanly. Do not copy `wallets/` unless transferring wallet data is an explicit, separately reviewed decision.

The signed-release work tracked by #206 is required before a repository archive can be treated as an authenticated CipherStick handoff package. Until then, do not represent an ordinary `.zip` or `.tar` download as authenticated.
