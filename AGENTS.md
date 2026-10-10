# Agent guidance

Read [CONTRIBUTING.md](CONTRIBUTING.md), the [AI policy](docs/AI_POLICY.md),
and the [developer notes](docs/developer-notes.md) before changing this
repository. Follow the [merge policy](CONTRIBUTING.md#merge-policy) when
preparing changes for review. Low-effort maintainability and PELD-inspired
design are core requirements.

Required background:

- [Tails: Improve Tails source code](https://tails.net/contribute/how/code/)
- [Tails: Design: specification and implementation](https://tails.net/contribute/design/)
- For documentation changes: [Tails' documentation style guide](https://tails.net/contribute/how/documentation/style_guide/)

Keep CipherStick a thin integration layer over Tails, Debian, GNOME, Bitcoin
Core, Python, python-codex32, JoinMarket, and other upstreams. Prefer upstream
functionality and stable interfaces over local reimplementations.

When modifying dependency-sensitive code:

- Avoid hard-coded Python minor-version paths, desktop application names, GTK
  generations, executable locations, dialog geometry, and other incidental
  properties of one release.
- Prefer runtime capability checks and centralized compatibility adapters.
- Do not duplicate validation or policy already owned by an upstream component.
- Preserve Tails' Tor routing, amnesia, explicit-persistence, and safe-default
  properties. Security-sensitive exceptions must be explicit and documented.
- Keep errors at integration boundaries visible and actionable; do not silently
  swallow dependency failures.
- Search existing issues and upstream history before adding a workaround.
- Test user-visible integration flows on the supported Tails release when the
  change depends on Tails, GNOME, Debian, Python, or desktop behavior.
- When several regressions share a cause, repair the shared boundary rather than
  applying independent symptom fixes.

Bias toward less project-specific code. A change that removes a brittle local
implementation in favor of a maintained upstream is usually easier to sustain.
