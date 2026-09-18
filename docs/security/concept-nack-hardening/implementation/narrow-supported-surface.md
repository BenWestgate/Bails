# Implementation Plan: Narrow and authenticate the supported runtime

## Selected Design And Constraints

We will retain Bails as a guided installer for a dedicated Tails USB. Bails will
install and configure Bitcoin Core and will temporarily support Sparrow as its
only wallet coordinator. It will stop owning wallet creation and private-key
handling. The Python Codex32 replacement is developed and reviewed separately;
it does not expand the Bails installer boundary merely because it replaces a
feature of the old wallet.

The fresh-Tails handoff replaces full persistent-state cloning. The recipient
uses normal Tails procedures, creates and unlocks new Persistent Storage, and
receives an authenticated Bails archive. The person performing the handoff
explicitly selects any additional data. Bails must not silently decide whether
wallet ciphertext, keys, metadata, or configuration is transferred.

Current `master` is not yet adequately scoped, authenticated, or reviewable as
a high-assurance installer. The path to that state is incremental: scope and
menu fixes are small; Core and Sparrow authentication already have focused
branches; release authentication needs an operating design; reviewability
depends on splitting PR #202 and landing the test harness.

## Source Revision And Drift Check

This plan is anchored to evidence collection
`7d0205c3790ba4294dc078a2bef1c3e00d833fb05ee3f19bca3f22cb7f71be1e`
and Bails `master` revision
`61f7253f4c52fec32f1ac4ec98a302945c524835`. A refresh on 2026-09-18 found no
drift in `origin/master`. Each work package must recheck the target branch before
implementation; material changes to bootstrap, update, persistence, or installer
ownership return to design review.

## Affected Components

- `README.md`, `docs/Advantages_and_Disadvantages.md`, `docs/DESIGN_SCOPE.md`,
  and a new threat-model document.
- `b`, `bails/.local/bin/bails-menu`, and release/update handling.
- `bails/.local/bin/install-core` and `bails/.local/bin/install-sparrow`.
- The custom `bails-wallet` and bundled Python scheduled for removal.
- CI workflows and the functional test harness.
- Fresh-Tails handoff documentation and any later separately reviewed helper.

## Ordered Work Packages

The following is the recommended issue-closing order. We can design later work
in parallel, but should close issues in this dependency order so each merged
state is coherent and reviewable.

| Order | Issue | Reason for position |
| --- | --- | --- |
| 1 | #208 — explicit bootstrap path | One focused, already reviewed boundary fix; prevents executing an unrelated local command. |
| 2 | #42 — hide unfinished Backup/Clone actions | Removes known dead-end behavior before documenting a replacement. |
| 3 | #212 — supported threat model | Defines the project-specific installer and handoff boundary that later code and claims must satisfy. |
| 4 | #211 — bound privacy/security claims | Uses the threat model to replace guarantees and distinguish current from planned features. |
| 5 | #210 — functional test harness | Establishes the place where later installer and authentication regressions are proved. |
| 6 | #201 — remove `bails-wallet` | Rebase and split PR #202; remove wallet/key handling without adding unsupported coordinators. |
| 7 | #204 — distinct Bitcoin Core signers | Protect the surviving Core installer with an explicit deduplicated signer quorum. |
| 8 | #205 — Sparrow publisher key | Bind the sole supported coordinator package to the expected publisher. |
| 9 | #207 — authenticated pruning metadata | Finish Core release binding and fail safely on invalid sizing metadata. |
| 10 | #206 — authenticated Bails releases | Sign the now-narrow release payload and fail closed before bootstrap or update execution. |
| 11 | #213 — fresh-Tails handoff | Depends on #206 for an authenticated archive and replaces the old cloning narrative. |
| 12 | #176 — deterministic update application | Apply authenticated releases with correct permissions and removal semantics. |
| 13 | #22 — Tor connection reminder | Improve supported runtime operation after its installer/update boundaries are stable. |
| 14 | #92 — AssumeUTXO | Performance feature follows authentication, scope reduction, and functional coverage. |
| 15 | #181 — restart spaced repetition | Lowest-risk usability feature; first reassess whether it remains in the installer-only product scope. |

Issues #204, #205, and #207 touch separate or narrowly overlapping installer
controls. After #201 and #210 land, rebase each on `master`, add its regression
case, and preserve a one-purpose commit. Begin #206's signing-key design early,
but close it only after the release contents and supported runtime are stable.

## Compatibility And Migration

PR #202 must be reconstructed as small changes from current `master`; its
27-commit history and added Bisq, Liana, Wasabi, and generic wallet installers do
not match the selected design. Preserve recovery for wallets already created by
the removed code. Do not automatically migrate private keys into Sparrow or the
Python Codex32 replacement.

The Python Codex32 project should define its own package authentication, threat
model, tests, and integration contract. Until that review completes, Bails may
describe it as planned but must not treat it as part of the supported installer.

For handoff, installation of Tails, extraction of Bails, and optional state
transfer remain distinct operations. Documentation should name Bitcoin Core
paths that are useful to transfer, but the user makes the inclusion decision and
receives a warning whenever selected paths may contain wallet or identifying
state.

## Tactical Protections During Migration

- Keep the unfinished Backup and Clone menu entries hidden.
- Keep Sparrow as the only supported coordinator.
- Keep all focused CWE branches based directly on current `master` until merged;
  rebase descendants rather than stacking unrelated changes.
- Do not restore network self-update until #206 authenticates the exact payload.
- Retain existing Core checksum/signature verification while strengthening its
  signer and metadata checks.
- Do not merge `codex/remove-unused-codeql`; CodeQL remains applicable while
  Python exists on `master` and while removal work is under review.

## Tests And Security Validation

- Run shell syntax and ShellCheck on every shell change.
- Add functional cases proving the explicit bootstrap path cannot select a
  sibling executable.
- Prove duplicate Core signatures do not satisfy the signer threshold.
- Prove Sparrow packages signed by a different trusted key are rejected.
- Prove mutable or unauthenticated Bails releases fail closed.
- Prove pruning metadata is tied to the authenticated Core version and invalid
  data cannot disable safe pruning.
- Prove unsupported menu actions are absent.
- Test fresh-Tails archive verification and ensure optional transfer paths match
  the user's explicit selection.
- Manually test clean install, update, restart, Core launch, Sparrow launch, and
  recovery guidance on supported Tails hardware before release.

## Performance And Resource Benchmarks

Measure hands-on setup separately from Bitcoin Core synchronization. Record the
Tails version, Core version, Sparrow version, USB medium, machine, network path,
pruning target, elapsed time, peak storage, and failure/retry behavior. Do not
restore “under an hour” or comparative performance claims from a single device.

For handoff, compare archive verification/extraction and optional blockchain
copy time with a fresh download. Performance does not justify copying wallet or
unknown persistent state by default.

## Rollout And Rollback

Use one issue and one focused branch per work package. Merge the smallest safety
and documentation changes first, then rebase remaining branches on the new
`master`. Publish the first signed release only after a clean installation and
failed-signature exercise. Retain the prior signed release and recovery
instructions for rollback.

Rollback must not re-enable an unauthenticated updater, unfinished clone action,
or removed wallet path. If a new release fails, return to the previous verified
archive and preserve user data rather than restoring broader behavior.

## Acceptance Criteria

- User-facing claims match implemented, tested properties and a linked threat
  model.
- The Bails repository owns installer behavior, not wallet creation or private
  keys.
- Sparrow is the only supported coordinator; the Python Codex32 replacement is
  independently reviewed.
- Core, Sparrow, and Bails payloads are authenticated to expected publishers and
  versions before execution.
- Functional tests cover all security regression cases listed above.
- Fresh-Tails handoff authenticates Bails and leaves every optional data choice
  to the person performing the transfer.
- Every branch is based on current `master`, atomic, and easy to review under
  `CONTRIBUTING.md`.

## Open Decisions

- Define the Bails release signing key, offline custody, rotation, and recovery
  procedure for #206.
- Decide whether the fresh-Tails handoff remains documentation-only or later gets
  an explicit-path transfer helper.
- Define the independent review threshold for the Python Codex32 replacement and
  for leaving Bails alpha status.
- Reassess #181 after wallet removal to confirm spaced repetition still belongs
  in the installer-only product.
