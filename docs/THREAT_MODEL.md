# CipherStick Threat Model

CipherStick's supported runtime is a Tails installer for Bitcoin Core, Persistent Storage setup guidance, passphrase practice, and the pinned `python-codex32` application for codex32 backup and recovery. CipherStick itself does not manage wallet keys or make wallet-security decisions; `python-codex32` and Bitcoin Core do.

## Boundaries CipherStick owns

- **Installer delivery:** downloaded CipherStick code can modify Persistent Storage. Releases and updates must identify and authenticate the exact code before it runs. Current repository clones do not yet satisfy this boundary; signed-release work is tracked by #206.
- **Bitcoin Core installation:** CipherStick chooses download locations, accepted signers, and release metadata. Its verification must reject an artifact, signer set, or metadata value that does not meet the local policy.
- **Persistent Storage changes:** CipherStick writes software and configuration beneath the unlocked persistence mount. It must use intended paths and permissions and must not silently copy wallet, recovery, log, or identifying data.
- **Pinned codex32 checkout:** CipherStick fetches an exact `python-codex32` revision and repairs a checkout whose files differ from it. This check catches corruption and accidental changes. It does not protect against an attacker who can already write Persistent Storage, since that attacker can also change CipherStick's own scripts.
- **Handoff guidance:** a recipient should start with their own Tails installation and Persistent Storage. Any transferred data must be selected explicitly by the person performing the handoff.

## Assumptions and non-goals

CipherStick relies on Tails for operating-system isolation, encryption, and Tor routing, and on Bitcoin Core for consensus validation and wallet behavior. It does not claim to protect against compromised hardware or firmware, an attacker controlling an unlocked Tails session, loss of required secrets, coercion, transaction-graph analysis, malicious counterparties, or all traffic correlation.

The installer can reduce the risk introduced by its own automation; it cannot remove risks inherited from Tails, Bitcoin Core, the user's hardware, or the user's operational choices. Planned features are outside this threat model until they are implemented, tested, and reviewed.
