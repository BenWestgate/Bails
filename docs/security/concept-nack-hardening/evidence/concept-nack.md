# Concept NACK: CipherStick (formerly Bails)

## Core conceptual problems

### 1. Overclaims relative to reality

The project repeatedly positions itself as “the most private way to transact
and store bitcoin,” “protecting against surveillance, censorship, and
confiscation,” and suitable for high-privacy use while leaving “no trace.” In
practice it is a convenience wrapper that installs Bitcoin Core and a wallet
flow on Tails with Codex32 shares, persistent storage, and cloning.

Tails and Bitcoin Core are already a well-understood combination. Adding
scripts, a GUI flow, cloning, and Codex32 does not automatically create superior
security properties. The documentation acknowledges limitations, including no
complete offline multisig flow, value guidance, and passphrase loss risk.

### 2. Single-developer trust and audit surface

Users are told to clone and run maintainer-authored scripts. Non-technical users
must trust the installer, signature verification, Persistent Storage setup, and
updates. The open-source scripting layer and cloning model add code and state
that must be reviewed in addition to Tails and Bitcoin Core.

### 3. Threat-model mismatches and residual risks

- Physical possession of the USB plus its passphrase exposes the wallet.
- Passphrase memorization creates recovery and loss trade-offs.
- Initial block download, pruning, USB performance, and Tor create operational
  failure modes.
- Planned offline elements still transfer data across an air gap, while the
  spending wallet remains online.
- Exchanges, merchants, and other endpoints can still correlate activity.

### 4. Complexity and user-error surface

The target audience is relatively non-technical, while safe use requires USB,
Persistent Storage, Codex32, multi-location backup, and shutdown discipline.
This sits uneasily beside claims of easy setup in under an hour.

### 5. Maturity and scope

The project is still evolving and includes planned cold-storage and multisig
features. High-assurance framing is premature without broader review, an
independent audit history, and operational maturity.

## Summary and requested direction

The underlying goal of making Tails, Bitcoin Core, and stronger backups more
accessible may be useful. A more supportable design would narrow the claims,
reduce custom scripting where practical, document a reviewed threat model and
residual risks, and stop treating cloning as a primary distribution path unless
clone provenance and state sanitization are cryptographically and operationally
defined.
