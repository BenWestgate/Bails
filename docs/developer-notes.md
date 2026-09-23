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
