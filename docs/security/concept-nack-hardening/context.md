# Context: Bails Concept NACK review

Analysis date: 2026-09-18

Target: public repository `BenWestgate/Bails`, current `origin/master`
revision `61f7253f4c52fec32f1ac4ec98a302945c524835` after a successful fetch.

## Evidence inventory

| ID | Evidence | Integrity identity |
| --- | --- | --- |
| E001 | User-supplied Concept NACK, normalized only for formatting | `evidence/concept-nack.md`; SHA-256 `9487d585d453801fdf5d4fa7e86d3ac4e93f129e14c8817ff3a7dfaff8f1357a` |
| E002 | Current Bails source and documentation | Git revision `61f7253f4c52fec32f1ac4ec98a302945c524835` |

Collection SHA-256: `7d0205c3790ba4294dc078a2bef1c3e00d833fb05ee3f19bca3f22cb7f71be1e`

## Inspected repository evidence

- `README.md`: absolute privacy/confiscation/no-trace claims; cloning as an
  installation path; one-hour setup language.
- `docs/Advantages_and_Disadvantages.md`: “perfect” and “best” claims; planned
  multisig and offline features described as current; some residual risks are
  acknowledged.
- `docs/DESIGN_SCOPE.md`: distinguishes implemented MVP, partially implemented
  cloning, and unimplemented offline/multisig levels.
- `b`, `bails/.local/bin/*`, and vendored Python: 1,747 shell lines and 1,070
  Python lines across 21 source files on `master`; `bails-wallet` alone is 573
  shell lines.
- `bails/.local/bin/bails-cloner`: exits with “Coming soon”; the menu exposes a
  `bails-clone` command that is absent from the tree.
- `bails/.local/bin/install-core`: executes download, key handling, signature
  verification, installation, persistence configuration, and pruning logic in
  one 251-line script.
- Existing work: PR #202 removes `bails-wallet` but remains a 27-commit branch
  and introduces wallet installers outside the later Sparrow-only direction;
  issue #42 and its one-commit local branch hide unfinished Backup and Clone
  menu actions; issues #206 and #210 cover authenticated project releases and a
  functional test harness.
- The Python Codex32 replacement is being developed in the separate
  `bails-wallet` repository. It is not part of the narrowed Bails installer and
  needs its own review before integration.

## External primary-source checks

- Tails documents that a compromised installation source, hardware keylogger,
  BIOS, or firmware can defeat operating-system protections.
- Bitcoin Core documents the initial full-node download and its signed checksum
  verification process.

These inherited risks provide context. The hardening recommendation focuses on
where Bails adds, changes, amplifies, or claims to mitigate risk: project
bootstrap and updates, Core and Sparrow verification, Persistent Storage
changes, and user-controlled data handoff.

No runtime behavior, performance, or user-success rate was measured in this
review. Claims about likely user error or maintenance cost are therefore
inferences, not measurements.
