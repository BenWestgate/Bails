# Security Hardening Proposal: Align claims with the supported trust boundary

## Decision

We need to decide whether CipherStick remains a security-sensitive automation
layer with narrower, testable promises, or retreats to documentation that asks
users to assemble Tails and Bitcoin Core manually.

## Executive Recommendation

The serious choices are **Option 1: Calibrate documentation around the current
implementation**, **Option 2: Narrow and authenticate the supported runtime**,
and **Option 3: Replace the runtime with an upstream-only guide**.

I recommend Option 2, delivered incrementally. Option 1 is the immediate,
easy-to-review first slice: remove absolute claims, distinguish implemented from
planned features, publish a Bails-specific threat model, and replace the
unfinished full-state cloning promise with a fresh-Tails handoff design. We
should then complete the already identified runtime work: remove the custom
wallet from this repository, support Sparrow only, authenticate project updates,
hide unfinished actions, and add tests. The Python Codex32 replacement remains a
separately reviewed component rather than part of this installer boundary.
Option 3 becomes preferable
only if the project cannot sustain review and maintenance of even that narrowed
automation layer.

## Evidence

I inspected the supplied review and current `master` at
`61f7253f4c52fec32f1ac4ec98a302945c524835`. The source supports the central
criticism that user-facing promises are broader than implemented controls, but
it does not establish that all automation is intrinsically less safe than a
manual guide.

| Evidence | Finding or document | What it establishes |
| --- | --- | --- |
| `E001` | Supplied Concept NACK | Identifies overclaiming, trust, cloning, operational, audience, and maturity concerns. |
| `E002` | Bails `master` source and docs | Confirms absolute claims, unfinished cloning, a broad scripting surface, and planned features described as current. |
| `E003` | Existing issues and branches | Shows focused mitigations already exist for releases, tests, unfinished menu actions, and removal of `bails-wallet`. |
| `E004` | Official Tails and Bitcoin Core guidance | Confirms residual host risks, substantial IBD requirements, and upstream binary-verification responsibilities. |

Observed: `README.md` says CipherStick is “the most private,” protects against
confiscation, and leaves “no trace.” `docs/Advantages_and_Disadvantages.md`
describes perfect privacy, unimplemented offline and multisig designs as current,
and setup in under an hour. `docs/DESIGN_SCOPE.md` separately marks those designs
as future work. The clone script exits immediately, while the main menu and
README expose cloning as ready.

Observed: the project refuses to run as root and builds on upstream Tails and
Bitcoin Core rather than replacing their security mechanisms. It also performs
Bitcoin Core checksum and signature verification. These controls matter when we
assess the review fairly.

Inferred: the mismatch between claims and implementation encourages users to
apply the system outside its demonstrated envelope. The broad script surface
increases review cost and makes control drift more likely. Neither fact proves
that careful automation is worse than manual instructions for every user.

## Current Design And Failure Mode

The current design combines product documentation, bootstrap, project updates,
Bitcoin Core verification and installation, Tails persistence configuration,
wallet creation, backup guidance, and planned clone flows. Security claims are
not derived from a single threat model or support matrix, so documentation can
describe future capabilities as present and can omit relevant residual risks.

The dangerous boundary is not merely “Bash.” It is that the same small project
owns broad claims and many security-sensitive transitions without sufficient
tests or independent review. Upstream Tails, Bitcoin Core, and Sparrow risks
remain relevant context, but the Bails threat model should concentrate on what
this project changes: a mutable project checkout currently executes as an
update, the installer modifies Persistent Storage, and the project mediates
Core/Sparrow verification and data handoff.

## Desired Invariants

- Every privacy or security claim maps to an implemented control and names its
  residual risks.
- Planned features are never presented as current supported behavior.
- Unsupported or untested actions are absent from primary installation and menu
  paths.
- Every executed CipherStick update is authenticated before execution.
- The supported wallet coordinator set is explicit and currently limited to
  Sparrow.
- Optional handoff data is selected explicitly by the person performing the
  transfer; Bails never silently includes or excludes wallet state.
- The project states its maturity, review status, user assumptions, and non-goals
  before users follow the bootstrap command.

## Constraints And Non-Goals

We assume the project still values a guided experience for less technical Tails
users on a dedicated Tails USB. The supported Bails runtime is the custom
installer; the custom wallet is scheduled for removal, Sparrow is its only
coordinator, and the Python Codex32 replacement is reviewed separately. We do
not assume measured user-success data, a formal external audit, or a mature
release-signing process. This proposal does not claim that documentation changes
remediate runtime vulnerabilities. It also does not require replacing Bash
solely because some scripts are long.

## Before Architecture

[Before architecture](../diagrams/align-supported-boundary-before.mmd)

The before view shows claims leading users into a mutable bootstrap and a broad
runtime. The unfinished clone path is a particularly clear example: it is
promoted as a security and distribution benefit while the implementation is not
available.

## Options

### Option 1: Calibrate documentation around the current implementation

This option preserves the runtime and limits the immediate work to documentation
and exposure. We remove superlatives and guarantees, put alpha/experimental
status next to the installation instructions, separate current and planned
features, link a security model, distinguish setup time from IBD, and replace
the unfinished clone instructions with a clearly proposed fresh-Tails handoff.

The attractive part is speed and reversibility: reviewers can verify every
sentence against current source. The principal weakness is that the runtime
trust surface remains unchanged, including mutable project updates until issue
#206 is resolved. This option reduces unsafe expectations but does not reduce
the chance of implementation defects.

[Option 1 architecture](../diagrams/align-supported-boundary-calibrate-docs-after.mmd)

| Change | Before | After | Security consequence | Cost |
| --- | --- | --- | --- | --- |
| Claims | Absolute and comparative | Specific and bounded | Reduces misuse outside the supported envelope | Small documentation review |
| Feature status | Planned and current mixed | Explicit support matrix | Users do not rely on absent controls | Ongoing documentation discipline |
| Handoff | Unfinished full-state clone | Fresh Tails, authenticated Bails archive, explicit optional paths | Avoids silently transferring another user's persistent state | Requires clear manual choices |

Rollback is a documentation revert, though restoring unsupported claims would
not be advisable without evidence.

### Option 2: Narrow and authenticate the supported runtime

This option includes Option 1 and reduces what CipherStick asks users and
reviewers to trust. We rework PR #202 into small commits that remove the custom
`bails-wallet` and bundled Codex32 implementation without introducing extra
wallet coordinators; Sparrow remains the only supported coordinator. The Python
Codex32 replacement lives outside this installer scope and receives its own
review. We merge the focused #42 fix to hide unfinished Backup and Clone actions,
complete #206 for authenticated project releases, and use #210 as the
test-harness foundation.

For handoff, the recipient first gets a fresh Tails installation through normal
Tails procedures and creates and unlocks new Persistent Storage. An authenticated
Bails archive can then be extracted. The person performing the transfer—not an
implicit software policy—chooses whether to copy any additional paths, such as
Bitcoin Core blockchain data. Any later helper must present source, destination,
selected paths, and warnings before copying; it must not silently decide whether
wallet ciphertext or identifying state accompanies the archive.

What makes this option compelling is control ownership. Tails owns the operating
system and persistence substrate, Bitcoin Core owns node and wallet consensus
behavior, Sparrow owns the coordinator, and CipherStick owns a narrower setup
and verification workflow. We still trust CipherStick scripts with the user's
session and Persistent Storage, so review and tests remain necessary. The
runtime is not sandboxed, and host hardware, firmware, endpoint correlation, and
physical compromise remain out of scope.

[Option 2 architecture](../diagrams/align-supported-boundary-narrow-surface-after.mmd)

| Change | Before | After | Security consequence | Cost |
| --- | --- | --- | --- | --- |
| Wallet logic | Custom Bash and vendored Python | Sparrow only | Removes a large local key-handling surface | Migration and compatibility review |
| Project updates | Mutable checkout executes | Authenticated release executes | Narrows repository/delivery compromise risk | Release-key operations |
| Clone/backup actions | Exposed but unfinished | Hidden; fresh-Tails handoff documented separately | Avoids indiscriminate persistent-state transfer | More explicit user choices |
| CI | Lint and static analysis | Functional and security regression tests | Detects control regressions | Test maintenance |

Rollback can restore an individual focused feature branch. We should avoid a
single large rewrite because that would make both review and rollback harder.

### Option 3: Replace the runtime with an upstream-only guide

This option removes CipherStick executable code and documents how experienced
users can combine official Tails and Bitcoin Core tooling. It minimizes the
project-specific executable trust base and avoids maintaining installers and
release keys.

Its strongest case is organizational: if no maintainer group can review and test
the automation, not shipping it is safer than presenting it as high assurance.
Its weakness is that the integration decisions do not disappear; they move to
each user and to documentation that must track both upstream projects. Manual
signature verification, persistence layout, pruning, shutdown, and backup steps
can be performed incorrectly. This option also abandons the project's core value
proposition rather than hardening it.

[Option 3 architecture](../diagrams/align-supported-boundary-upstream-guide-after.mmd)

| Change | Before | After | Security consequence | Cost |
| --- | --- | --- | --- | --- |
| Automation | Project scripts execute | User follows upstream docs | Removes project runtime compromise paths | More user-managed integration |
| Review target | Code and docs | Docs only | Smaller executable TCB | Documentation drift remains |
| Audience | Guided non-technical flow | Experienced manual setup | Better fit for experts | Excludes intended audience |

Rollback requires restoring an executable product, so this is the least
reversible option in product terms even though deleting code is mechanically
simple.

## Comparison

| Dimension | Option 1: Calibrate docs | Option 2: Narrow runtime | Option 3: Upstream guide |
| --- | --- | --- | --- |
| Security | Better expectation setting; runtime unchanged | Best balance: smaller and authenticated local surface | Smallest local runtime; user error shifts outward |
| Performance | Neutral | Neutral to improved; fewer local components | Unknown; manual choices vary |
| Memory | Neutral | Neutral to improved | Neutral for resulting upstream software |
| Reliability | Docs improve decisions only | Tests and fewer paths improve containment | Depends heavily on user execution |
| Operability | Low cost | Release and test maintenance required | Low code operations, higher support variability |
| Migration | Very low | Moderate, naturally separable | High product and audience change |

These effects are source-derived or hypothetical, not measured. Validation
should track installation completion, IBD duration separately from setup,
failure recovery, update verification failures, and support incidents before we
make comparative usability claims.

## Recommendation

I recommend Option 2 under the current goal of retaining a guided product. We
can begin with Option 1 because it is independently useful and easy to review,
then land the existing narrow code changes one at a time. Option 3 should win if
the project cannot recruit review or maintain a test and release process; until
then, the review's assertion that manual steps are categorically safer is too
strong.

The selected option's issue dependencies, acceptance criteria, rollout, and
rollback are recorded in the [implementation
plan](../implementation/narrow-supported-surface.md).

## Evidence Coverage And Residual Risk

| Evidence | Option 1 | Option 2 | Option 3 |
| --- | --- | --- | --- |
| `E001` — Supplied Concept NACK | Addresses claims; documents other concerns | Mitigates claims, trust surface, handoff, and maturity | Addresses local runtime concern but not manual error |
| `E002` — Current source mismatch | Documents mismatch | Removes unsupported paths and narrows code | Removes runtime entirely |
| `E003` — Existing mitigation work | Coordinates existing issues | Completes and integrates it | Makes much of it obsolete |
| `E004` — Upstream residual risks | Documents them | Documents them; they remain | They remain for manual users |

No option prevents compromised hardware or firmware, endpoint identity
correlation, coercion, loss of secrets, or mistakes outside the supported flow.
No option makes “no trace” or confiscation-proof operation a defensible
guarantee. Those inherited risks should be linked to upstream guidance and
discussed here only where Bails changes them or makes a claim about them.

## Migration And Rollout

Land documentation calibration first. Next, hide unfinished actions. Rebase and
split PR #202 so removal of `bails-wallet` is reviewable and does not add Bisq,
Liana, Wasabi, or other unsupported coordinators. Review the Python Codex32
replacement separately. Complete authenticated release updates before restoring
network self-update or distributing Bails archives for handoff. Add the test
harness before expanding features again.

Each phase can be reverted independently. Do not re-enable the unfinished clone
command or broaden wallet support merely because later design documents mention
them.

## Validation Plan

- Search user-facing text for absolute and comparative claims and manually map
  each surviving statement to an implemented control.
- Verify current and planned support tables against the repository tree.
- Confirm Clone and Backup cannot be selected from supported menus or install
  instructions.
- Verify a fresh destination uses normal Tails installation, new Persistent
  Storage, an authenticated Bails archive, and explicit optional transfer paths.
- Exercise authenticated update failure paths once #206 is implemented.
- Add security regression and installer integration cases after #210 provides a
  harness.
- Collect measured setup and IBD timings before publishing time claims.

## Implementation Work Packages

- Bound claims and publish visible maturity/review status.
- Add a linked threat model and operational limitations document.
- Hide the unfinished clone command and document the fresh-Tails,
  user-controlled handoff.
- Split and narrow PR #202 to remove custom wallet code and retain Sparrow only.
- Complete issues #206 and #210 and the existing focused security branches.

## Open Questions

- What exact release-signing and key-rotation process will maintainers operate?
- What interface, if any, should present optional handoff paths without making
  the user's inclusion decision?
- Which measured user outcomes would justify “easy” or time-bound setup claims?
- What independent review threshold is required before leaving alpha status?
