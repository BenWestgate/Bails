# BIP138 audit revisions

The 2026-09-22 BIP138 security audit is scoped to these upstream snapshots:

- Specification checkout: `bitcoin/bips` at `848dce9a6dbbf8e9a43a3359ea16567952f8dc5c`. `bip-0138.md` itself last changed at `5af62cba9958a519218bcad8a0aae9e2090bb5bd` in that reviewed content.
- Rust reference implementation: `pythcoiner/bip138` at `8a0dd30dff9956913e60f0193461ccbf2fa7de7c`.
- Bitcoin Core proof of concept: `Sjors/bitcoin` PR #109 at `a39aa1534b54b3912d2daea5e65c3cce1e0782c8`.

The highest-impact Core finding and the retired-finding set were revalidated on
2026-09-22 against PR #109 head
`364939786045f21cc8db592a4f1cbb2312bc3d59`. At that revision,
`ParseDescriptorBackupImports` still marks unarchived ranged descriptors active,
and `ImportEncryptedDescriptorBackup` passes the decrypted requests directly to
the normal descriptor import path. The descriptor-document test also explicitly
asserts that the resulting descriptors are active. The same head now implements
unknown-optional-content skipping, `0x00` padding termination, bounded/deduplicated
derivation paths and individual secrets, and MuSig2 participant-xpub extraction.

These pins matter because the upstream draft and proof-of-concept implementation can change independently. Findings about implementation behavior, especially descriptor activation, apply to the reviewed Core snapshot unless explicitly revalidated against a later head.
