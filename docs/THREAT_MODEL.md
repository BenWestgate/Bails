# CipherStick Threat Model

CipherStick's supported runtime is a Tails installer for Bitcoin Core, Persistent Storage setup guidance, and passphrase practice. It does not manage wallet keys or make wallet-security decisions.

## Boundaries CipherStick owns

- **Installer delivery:** downloaded CipherStick code can modify Persistent Storage. Releases and updates must identify and authenticate the exact code before it runs.
- **Bitcoin Core installation:** CipherStick chooses download locations, accepted signers, and release metadata. Its verification must reject an artifact, signer set, or metadata value that does not meet the local policy.
- **Persistent Storage changes:** CipherStick writes software and configuration beneath the unlocked persistence mount. It must use intended paths and permissions and must not silently copy wallet, recovery, log, or identifying data.
- **Handoff guidance:** a recipient should start with their own Tails installation and Persistent Storage. Any transferred data must be selected explicitly by the person performing the handoff.

## Assumptions and non-goals

CipherStick relies on Tails for operating-system isolation, encryption, and Tor routing, and on Bitcoin Core for consensus validation and wallet behavior. It does not claim to protect against compromised hardware or firmware, an attacker controlling an unlocked Tails session, loss of required secrets, coercion, transaction-graph analysis, malicious counterparties, or all traffic correlation.

The installer can reduce the risk introduced by its own automation; it cannot remove risks inherited from Tails, Bitcoin Core, the user's hardware, or the user's operational choices. Planned features are outside this threat model until they are implemented, tested, and reviewed.
