# Before use

## What is CipherStick?

CipherStick is experimental software that guides setup of Bitcoin Core on a dedicated Tails USB. It combines Tails Persistent Storage, Tor, Bitcoin Core release verification, pruning, and optional Sparrow installation in one setup flow.

CipherStick is intended to reduce reliance on third-party wallet servers and keep Bitcoin node data on encrypted Persistent Storage. It does not guarantee anonymity, protection from confiscation, resistance to coercion, or safety on compromised hardware. The project has not completed an independent security audit.

The current supported scope is documented in [DESIGN_SCOPE.md](DESIGN_SCOPE.md). Features described as planned or experimental there should not be relied on as current security controls.

CipherStick does not assign a recommended monetary value to the setup. Decide whether it fits your threat model only after reviewing its limitations, Tails guidance, Bitcoin Core guidance, and the source code.

## How much storage do I need on my test laptop?

You don't need storage available on the computer's internal drive for normal CipherStick use. The supported setup runs from a dedicated Tails USB and stores persistent data there.

## How does it run on 32GB USB sticks, I thought the blockchain was much larger?

CipherStick uses Bitcoin Core pruning when available storage is limited. Bitcoin Core still downloads and validates historical blocks but removes older block files after validation. A pruned node cannot serve all historical blocks and may need to redownload data when restoring an old wallet.

## What is the difference between Codex32, Shamir Secret Sharing and Multisig?

[Andrew Poelstra: What is Shamir Secret Sharing and how does it compare to Multisig?](https://youtu.be/jDjEEX0ASxY?si=vooa8JA858EmRME6&t=1209)

## When I’m installing Tails, I should Create Persistent Storage, right?

**No.** The current CipherStick setup flow expects to guide Persistent Storage creation itself. Creating it first can skip CipherStick-specific setup checks. Follow the current installation instructions for the exact supported sequence.

## I don't have a USB stick, what one should I get?

CipherStick will run on many USB sticks, but Bitcoin Core initial synchronization is very sensitive to random I/O performance. More RAM and faster storage generally improve initial sync and reduce write pressure. Exact synchronization time varies with hardware, storage, Bitcoin Core version, network conditions, pruning settings, and chain state; CipherStick does not publish a fixed completion-time guarantee.

USB sticks with SSD-like performance:
- [Kingston DataTraveler Max Type-C USB](https://amzn.to/3OpMELw)
- [Kingston DataTraveler Max Type-A USB](https://amzn.to/3Yie7DL)
- [PNY PRO Elite V2 USB](https://amzn.to/43QbJ8p)
- [Corsair Flash Voyager GTX USB](https://amzn.to/47joyLm)
- [HP x796w USB](https://amzn.to/3Qq7SeU)
- [Lexar JumpDrive P30 USB](https://amzn.to/3KnHNcz)

Portable SSDs:
- [Transcend ESD310C Portable SSD](https://amzn.to/44U2OUv)
- [Netac Portable SSD Dual Interface](https://amzn.to/3DOD4wR)
- [SSK SSD Solid State Flash Drive](https://amzn.to/3Qpgoer)

Higher-performance USB options:
- [SanDisk Extreme Pro USB](https://amzn.to/3KngiA0)
- [SAMSUNG FIT Plus USB](https://amzn.to/3OjRmdY)
- [SAMSUNG Type-C USB](https://amzn.to/3rTpQfM)
- [SAMSUNG BAR Plus USB](https://amzn.to/45hxyyR)
- [Transcend Jetflash 920 USB](https://amzn.to/3KqNh6z)
- [Transcend Jetflash 930C USB](https://amzn.to/3q8pu4B)

MicroSD options:
- [SanDisk Extreme microSD](https://amzn.to/3KraGF7)
- [SAMSUNG PRO Plus microSD](https://amzn.to/3Qn9INK)
- [SAMSUNG EVO Select microSD](https://amzn.to/3Km8sXd)
- [Silicon Power Superior microSD](https://amzn.to/3OHoBZZ)

A non-pruned archival node requires substantially more storage than the minimum supported CipherStick USB. Check current Bitcoin Core storage requirements before choosing media for an archival node.

## I don't have a computer, what type should I get?

Start with [Tails' hardware requirements](https://tails.net/doc/about/requirements/index.en.html). For CipherStick, additional RAM and fast USB storage generally improve Bitcoin Core initial synchronization. Internal-disk capacity is not normally used by the supported setup.

New hardware is not automatically trustworthy, and used hardware is not automatically compromised. Your hardware sourcing decision belongs in your own threat model.

## What type of backup USB stick should I get?

Automated CipherStick backup/cloning is not currently a supported workflow. If you manually maintain backup media, choose capacity for the data you explicitly intend to copy and follow Tails and Bitcoin Core backup guidance. Do not assume a full Persistent Storage copy excludes wallet or identifying state.

# During Setup

## What’s the deal with the "Do you trust this individual?"

Bitcoin Core releases are signed by multiple contributors. A signature only establishes that the holder of a particular signing key signed the release data; you still need a policy for which keys you trust. CipherStick has separate hardening work to bind accepted signatures to explicit signer fingerprints and thresholds.

## Does it matter what order I enter shares when restoring?

The bundled Codex32 wallet flow is legacy and is being replaced. Do not rely on this FAQ as current recovery documentation. Replacement restoration is tracked separately and should define its own share-entry and secret-lifetime behavior.

## How do I make this go faster?

1. Check network bandwidth and Tor connectivity.
2. Use storage with good random read/write performance.
3. More RAM can reduce storage pressure during initial synchronization.
4. Avoid unnecessary restarts during initial sync.

AssumeUTXO support is planned but is not currently part of the supported CipherStick workflow. Do not rely on a future fixed-time claim such as "minutes" until the implementation is merged and reproducibly benchmarked.

## How reliable is my USB stick?

USB flash media can fail or lose data. New media, lower temperatures, sufficient free space, safe shutdown, and independent backups can reduce risk, but CipherStick does not guarantee media longevity. Keep recovery material independent of a single USB device.

# After Setup

## If I unplug CipherStick and use the computer for another task, will Bitcoin Core resume later?

If Bitcoin Core shuts down cleanly before Tails shuts down, it should resume synchronization from its existing data the next time you start Tails, unlock Persistent Storage, and connect to Tor. Interrupting writes or removing the USB while Bitcoin Core is active can corrupt data and lose synchronization progress.

## How do I update CipherStick?

The current master branch still contains a mutable-repository update path. Authenticated immutable release updates are tracked separately. Treat the repository and delivery path as trusted code until that work lands; do not describe the current updater as independently authenticated.

## How can I copy the block chain from a Bitcoin node I already have?

Bitcoin Core data can be copied manually, but the source, destination, shutdown state, version compatibility, and selected paths matter. Follow current Bitcoin Core data-directory guidance. Do not copy wallet files, configuration, logs, or other state unintentionally.

## How do I make a backup or clone CipherStick?

Automated backup and clone flows are unfinished and are not supported. Older instructions that recommend copying an entire Persistent Storage should not be treated as current guidance. A fresh-Tails handoff with authenticated CipherStick software and explicit user-selected data transfer is tracked separately.

## How should I handle backup media?

Keep independent recovery material protected from physical access, tampering, heat, and single-device failure. Test recovery procedures without exposing secrets, and do not assume that an encrypted copy is safe to distribute merely because it is encrypted.
