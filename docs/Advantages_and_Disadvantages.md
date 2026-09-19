# CipherStick: Current Properties and Limitations

CipherStick is an experimental installer that combines Tails, Bitcoin Core, and optional Sparrow setup on a dedicated USB. The security properties below describe implemented behavior only; they are not guarantees against every attacker.

## Current advantages

1. **Independent Bitcoin validation:** Bitcoin Core validates consensus rules locally rather than relying on a third-party wallet server for balances and transaction validity.

1. **Tor-based network path:** Tails routes supported network traffic through Tor, reducing direct exposure of the user's network address. Tor does not prevent transaction-graph analysis, malicious endpoints, or all forms of traffic correlation.

1. **Encrypted persistent storage:** Tails Persistent Storage encrypts selected persistent data at rest. An unlocked session, compromised host, weak passphrase, or captured secret can still expose data.

1. **Verified Bitcoin Core releases:** CipherStick checks Bitcoin Core release checksums and signatures before installing the binary. Separate hardening work tracks exactly which signers and metadata are accepted.

1. **Local pruning:** CipherStick configures Bitcoin Core pruning based on available storage so a full node can run on smaller media while still validating all downloaded blocks.

1. **Open source:** The installation scripts are available for review. Open source availability does not itself constitute an audit or prove absence of vulnerabilities.

1. **Guided setup:** CipherStick automates a number of Tails and Bitcoin Core setup steps. Usability has not been measured well enough to claim a fixed setup time or superiority over other approaches.

## Experimental or legacy behavior

- The bundled Codex32 wallet GUI is legacy and is being replaced rather than extended.
- Spaced repetition is intended to help users practice a Persistent Storage passphrase; it does not replace a recovery backup.

## Planned, not currently supported

The following designs may appear elsewhere in project history but must not be treated as current capabilities:

- automated CipherStick cloning or backup USB creation;
- AssumeUTXO-based fast bootstrap;
- offline or air-gapped signing;
- CipherStick-managed multisignature or inheritance workflows;
- automatic Codex32 share rotation or QR workflows.

See [DESIGN_SCOPE.md](DESIGN_SCOPE.md) for current feature maturity.

## Material limitations

1. **Endpoint and hardware compromise:** Tails cannot protect secrets from compromised firmware, malicious peripherals, hardware keyloggers, or an already-compromised machine below the operating-system boundary.

1. **Unlocked-session exposure:** Anyone controlling an unlocked Tails session can access data and processes available to that session.

1. **Physical access:** Encryption strength depends on the Persistent Storage passphrase and Tails' implementation. CipherStick does not guarantee confiscation or coercion resistance.

1. **Network privacy is not anonymity:** Tor hides the direct network address from ordinary Bitcoin peers, but counterparties, timing analysis, address reuse, transaction graphs, and compromised services can still identify activity.

1. **Initial synchronization cost:** Bitcoin Core initial block download can take hours or days and requires substantial network and storage I/O. Hands-on setup time is not the same as time to a fully synchronized node.

1. **Software maturity:** CipherStick is alpha software and has not completed an independent security audit. Security-sensitive changes require review and testing before claims should be expanded.

1. **Recovery remains the user's responsibility:** Loss of required wallet material, passphrases, or backups can cause permanent loss of funds. CipherStick cannot recover secrets it does not possess.
