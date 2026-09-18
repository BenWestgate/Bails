# Security Hardening Review: CipherStick (formerly Bails)

## Evidence Basis

I reviewed the supplied Concept NACK against Bails `master` at
`61f7253f4c52fec32f1ac4ec98a302945c524835`, relevant open issues and branches,
and official Tails and Bitcoin Core operational guidance. The critique is
substantially supported where it identifies promises broader than the current
implementation, unfinished cloning presented as a feature, residual risks that
are not prominent, and a security-sensitive local code surface without adequate
functional testing. The evidence does not establish that automation, Bash, or a
guided Tails setup is intrinsically worse than manual integration.

## Constraints

The project intends to preserve a guided experience on a dedicated Tails USB,
remove its custom wallet layer, and temporarily support Sparrow as its only
wallet coordinator. A separately developed Python Codex32 tool may replace the
old wallet's Codex32 function after its own review; it is not part of the narrow
installer boundary. No measured usability results, completed independent audit,
or mature release-signing operation was supplied. We should therefore avoid
comparative security and time-to-completion claims until evidence supports them.

## Opportunity Portfolio

| Opportunity | Evidence | Options | Recommendation | Proposal |
| --- | --- | --- | --- | --- |
| Align claims with the supported trust boundary | Concept NACK, current claims and source, existing mitigation work, upstream limitations | Calibrate documentation; narrow and authenticate runtime; upstream-only guide | Narrow and authenticate the runtime, beginning with small documentation changes | [Review the proposal](proposals/align-supported-boundary.md) |

## Recommendation Summary

I recommend retaining the guided product only with a narrower, testable support
boundary. The first changes can be reviewed independently: replace absolute
claims with bounded properties, publish a Bails-specific threat model, and
distinguish implemented from planned features. The current full-state cloning
concept should become a fresh-Tails handoff: install Tails normally, create new
Persistent Storage, transfer an authenticated Bails archive, and leave every
optional data choice to the person performing the handoff. The next slices
should remove custom wallet/key-handling code without adding unsupported
coordinators, authenticate project updates, hide unfinished actions, and add
tests.

An upstream-only guide becomes preferable if the project cannot maintain
release signing, regression coverage, and review of the remaining scripts. I do
not recommend a wholesale rewrite merely because the current implementation is
mostly Bash; language choice is secondary to scope, ownership, authentication,
and testability.

The selected option now has an [ordered implementation
plan](implementation/narrow-supported-surface.md).

## Next Decisions

- Record the dedicated-Tails, Sparrow-only, and installer-only support
  constraints in project documentation.
- Select the maturity and independent-review threshold required before leaving
  alpha status.
- Define the release-signing and key-rotation operating model.
- Define the authenticated archive and explicit path-selection rules for the
  fresh-Tails handoff without silently including or excluding wallet state.
