# Developer notes

These notes describe the repository conventions that matter when changing
CipherStick. Keep changes small enough to review and test directly on current
stable Tails.

## Scope

CipherStick is primarily shell code that installs and configures Bitcoin Core on
Tails. Avoid adding another implementation or dependency when the operating
system, Bitcoin Core, or a separately reviewed project already provides the
needed behavior.

Keep private-key and recovery logic out of the installer when possible. Changes
that cross a security boundary should make that boundary explicit in code,
documentation, and tests.

## Maintainability and design policy

CipherStick is intended to remain sustainable for a small maintainer base while
tracking fast-moving upstream projects. Maintenance cost is therefore a design
constraint, not an afterthought.

Two Tails documents are required background for changes that affect the system
design or dependency integration:

- [Tails: Improve Tails source code](https://tails.net/contribute/how/code/),
  especially **Focus on low-effort maintainability**.
- [Tails: Design: specification and implementation](https://tails.net/contribute/design/),
  especially the **Privacy Enhancing Live Distribution (PELD)** specification.

CipherStick is not a replacement for Tails. Its design is PELD-inspired and
should preserve the privacy, amnesia, portability, usability, transparency, and
maintainability properties provided by Tails rather than reimplementing them.

### Low-effort maintainability

Prefer the smallest practical delta from upstream software and the base Tails /
Debian system. CipherStick should mostly compose and configure well-maintained
components. When functionality belongs naturally in Bitcoin Core, Tails,
Debian, GNOME, python-codex32, JoinMarket, or another upstream, prefer fixing or
using it there instead of maintaining a CipherStick-specific replacement.

Changes should depend on stable interfaces and capabilities rather than details
of one currently installed version. In particular:

- Do not hard-code Python minor-version paths such as `python3.11`.
- Do not assume a particular terminal application, GTK generation, dialog size,
  executable location, package version, or desktop implementation when a stable
  interface or runtime capability check is available.
- Avoid duplicating validation or policy already enforced by Tails or another
  upstream component. Duplicate checks drift and become contradictory.
- Centralize unavoidable compatibility logic so an upstream change is fixed in
  one place instead of in every caller.
- Prefer feature/capability detection to version checks. When a version check is
  unavoidable, document the contract it protects and make unsupported states
  fail with an actionable error.
- Keep custom UI and glue code small. Remove obsolete compatibility code once
  the supported upstreams no longer need it.

Before adding a workaround, search existing issues, pull requests, upstream bug
trackers, and documentation. A workaround should have a clear removal condition
or a reason it is expected to remain stable.

### PELD-inspired design policy

Changes must preserve the security and privacy model inherited from Tails:

- Persistence is explicit and opt-in. Do not write sensitive state outside the
  intended encrypted Persistent Storage locations.
- Network access must continue to use the isolation and Tor-routing guarantees
  provided by Tails. Any exception needs a documented security rationale and a
  user-visible indication where appropriate.
- Safe behavior should require little or no advanced configuration. Avoid flows
  where an average user can silently disable a privacy or security property.
- Prefer Free Software and reproducible, reviewable inputs. Pin external source
  when review requires an exact revision, and make the pin easy to update and
  verify.
- Security-relevant design decisions and exceptions belong in public project
  documentation or issue history so another reviewer can reconstruct why they
  exist.
- Updating CipherStick for a new upstream release should be routine. Build,
  install, migration, and compatibility steps should be scripted where
  practical instead of relying on maintainer memory.

### Dependency updates and compatibility

Treat Bitcoin Core, Tails, GNOME, Debian, Python, python-codex32, and JoinMarket
as independently evolving upstreams. A change involving one of them should
consider what happens when that component advances without coordinated changes
to CipherStick.

For dependency-sensitive changes:

1. Test the affected flow on the currently supported Tails release, not only on
   the maintainer's development host.
2. Exercise the user-visible path end to end when practical. Import success or
   shell syntax alone is not enough for GUI and integration changes.
3. Verify failure paths are visible. Do not discard stderr from a dependency
   boundary unless the failure is intentionally handled and surfaced elsewhere.
4. Record any newly introduced upper/lower version bound and why it exists.
5. Prefer a small compatibility adapter or capability probe over scattered
   conditionals throughout the codebase.

When a release exposes several regressions with the same root cause, fix the
shared abstraction or dependency boundary rather than patching each symptom.

### Review expectations

Keep commits focused and explain the reason for the change. Review should ask:

- Does this increase the long-term maintenance burden?
- Does it duplicate something an upstream already provides?
- Is it coupled to an incidental detail of today's Tails, Debian, GNOME,
  Python, Bitcoin Core, python-codex32, or JoinMarket release?
- Does it preserve Tails' privacy and amnesia guarantees?
- Can the next upstream release be accommodated by changing one well-defined
  integration point?

Prefer deleting brittle custom code over extending it when a maintained
upstream component can own the behavior.

## Shell code

- Use Bash for existing shell entry points and match the surrounding style.
- Quote path and user-controlled expansions unless word splitting is deliberate.
- Prefer existing Tails and GNU utilities over new dependencies.
- Preserve failure status instead of hiding errors that affect installation,
  verification, persistence, or recovery.
- Keep persistent state under Tails Persistent Storage; temporary secrets and
  logs should remain in memory-backed locations where practical.

## Repository layout

- `b` is the main bootstrap/install entry point.
- `bails/.local/bin/` contains installed helper commands.
- `bails/.local/share/` contains desktop integration and application data.
- `docs/` contains design, user, and contributor documentation.
- `.github/workflows/` contains automated checks.

## Testing

Run the checks that cover the files you changed. At minimum for shell changes:

```sh
git diff --check
bash -n path/to/changed-script
shellcheck path/to/changed-script
```

For behavior that depends on Tails, Persistent Storage, Tor, Bitcoin Core, or
desktop integration, also test the affected path on current stable Tails and
describe the manual steps in the pull request.

## Review

Prefer one focused change per pull request. Do not mix formatting or unrelated
cleanup with behavioral changes. Update documentation in the same pull request
when user-visible behavior changes, and explain any security or persistence
trade-offs that a reviewer cannot infer directly from the diff.
