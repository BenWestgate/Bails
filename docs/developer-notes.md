# Developer notes

This guide covers the practical choices to make when changing Bails. Start with
[CONTRIBUTING.md](../CONTRIBUTING.md) for the contribution and review process.
Keep each change small enough to understand and test on the supported Tails
release.

## Scope

Bails (CipherStick) installs and configures Bitcoin Core on Tails. It should
remain a thin layer over the operating system and other maintained projects.
Avoid adding another implementation when Bitcoin Core, Tails, Debian, GNOME,
python-codex32, JoinMarket, or another upstream already provides the behavior.

Keep private-key and recovery logic out of the installer where possible. Make
security boundaries clear in the code, documentation, and tests.

## Maintainability and design policy

We have a small maintainer base, and our dependencies change independently.
Every local workaround becomes something we must update and test. These two
Tails documents explain the design principles behind this policy:

- [Improve Tails source code](https://tails.net/contribute/how/code/), especially
  its guidance on low-effort maintainability.

- [Design: specification and implementation](https://tails.net/contribute/design/),
  including the Privacy Enhancing Live Distribution (PELD) specification.

### Use upstream behavior

Prefer stable interfaces and capability checks over details of a specific
release. For example, a path containing `python3.11` can break when Debian
updates Python. Ask Python for the module location instead of assuming where
it is installed. Apply the same principle to terminal applications, executable
paths, GTK versions, dialog sizes, and desktop integration.

- Let Tails and other upstreams enforce their own validation and policy. Local
  copies can drift or disagree.

- Put necessary compatibility handling in one adapter or feature check, not in
  every caller. If a version check or dependency bound is unavoidable, explain
  the constraint and the supported versions.

- Report missing capabilities and dependency failures clearly. Do not discard
  errors from commands that users need for installation or recovery.

- Before adding a workaround, check existing issues, upstream fixes, and
  documentation. Describe when the workaround can be removed.

Keep custom UI and integration code small. Prefer removing obsolete code to
carrying compatibility logic for releases we no longer support.

### Preserve Tails' privacy model

Tails provides the amnesia, Tor routing, and safe defaults on which Bails
depends. Its PELD principles also include portability, usability, transparency,
and maintainability. Preserve these properties instead of rebuilding Tails.

- Store sensitive data only in memory unless the user explicitly chooses to
  save it in Tails **Persistent Storage**. Do not silently enable persistence.

- Use Tails' network isolation and Tor routing. Any exception needs a clear
  security rationale and, where relevant, a visible explanation for the user.

- Keep safe behavior the default. A routine action should not silently weaken
  privacy or security.

- Prefer Free Software and verifiable inputs. When a specific upstream revision
  must be pinned, make the pin easy to inspect and update.

Record security exceptions and design decisions in the repository or issue
history so later contributors can understand them.

### Prepare for dependency changes

Treat Tails, Debian, GNOME, Python, Bitcoin Core, python-codex32, and JoinMarket
as independent upstreams. When an integration changes, consider what happens
when just one of them updates.

If a release causes several failures, look for their shared dependency boundary
before patching each symptom. Script repeatable installation, migration, and
compatibility steps where practical.

## Shell code

- Keep existing shell entry points in Bash and follow the nearby style.

- Quote paths and user-controlled values unless splitting is intentional.

- Prefer tools already present in Tails or Debian over new dependencies.

- Preserve failure status for installation, verification, persistence, and
  recovery; show errors where users can act on them.

- Keep temporary secrets and logs in memory-backed locations where possible.
  Only explicitly selected data belongs in Persistent Storage.

## Repository layout

- `b` is the main installer and bootstrap entry point.

- `bails/.local/bin/` contains installed helper commands.

- `bails/.local/share/` contains desktop integration and application data.

- `docs/` contains design, user, and contributor documentation.

- `.github/workflows/` contains automated checks.

## Testing changes

Run checks relevant to what you changed. For a shell script, start with:

```sh
git diff --check
bash -n path/to/changed-script
shellcheck path/to/changed-script
```

For changes involving Tails, Tor, Persistent Storage, Bitcoin Core, or the
desktop, test the user-visible path on the supported Tails release. Exercise
failure behavior too: a successful shell syntax check or import is not a test
of a graphical workflow. Record the steps and results in the pull request.

## Writing documentation

Follow [Tails' documentation style guide](https://tails.net/contribute/how/documentation/style_guide/)
so instructions feel familiar to Tails users. In particular:

- Use short, direct sentences, US spelling, and sentence-case headings.

- Name Tails features consistently, such as **Persistent Storage**. Write
  interface labels in **bold**, command names in `code`, and file names in
  *italics* when writing for Tails users.

- Give actions in the order readers perform them. Use descriptive link text and
  leave a blank line between list items.

Keep explanations close to the task they help with. For changes to behavior,
update the relevant user documentation in the same pull request.

## Before requesting review

Keep changes focused. Explain why the change is needed, whether an upstream
could own it, what you tested, and any privacy or persistence trade-offs. See
the [merge policy](../CONTRIBUTING.md#merge-policy) for review expectations.
