# Before use
## What is CipherStick?

CipherStick is experimental setup automation for running Bitcoin Core on Tails from a dedicated USB stick. It configures Tails Persistent Storage, verifies and installs Bitcoin Core, and provides setup guidance. Its privacy and security properties depend on Tails, Bitcoin Core, the computer and USB media, user behavior, and the integrity of the software supply chain. CipherStick has not received an independent security audit and does not define a safe amount of bitcoin to store.

## How much storage do I need on my test laptop?

You don't need storage available on the test laptop for the supported setup. Tails and CipherStick run from the USB stick; follow Tails' documentation before accessing internal disks.

## How does it run on 32GB USB sticks, I thought the blockchain was 600+ GB?

CipherStick can configure Bitcoin Core pruning when storage is limited. Bitcoin Core still downloads and validates historical blocks, then discards older block files according to the prune target. Pruning affects availability of historical block data: rescanning or restoring an old wallet can require additional downloads or a reindex. See Bitcoin Core's pruning documentation before relying on a pruned node for recovery.

## What is the difference between Codex32, Shamir Secret Sharing and Multisig?

[Andrew Poelstra: What is Shamir Secret Sharing and how does it compare to Multisig?](https://youtu.be/jDjEEX0ASxY?si=vooa8JA858EmRME6&t=1209)

CipherStick's legacy bundled Codex32 wallet flow has been removed. Preserve existing recovery material and restore it with the **codex32** application; see [LEGACY_WALLET_RECOVERY.md](LEGACY_WALLET_RECOVERY.md).

## When I’m installing Tails, I should Create Persistent Storage, right?

**No.** For the documented CipherStick installation flow, start Tails without creating Persistent Storage first. CipherStick guides the Persistent Storage setup later. Follow Tails' own passphrase guidance when choosing the Persistent Storage passphrase.

## I don't have a USB stick, what one should I get?

CipherStick can run on ordinary USB media, but initial synchronization is sensitive to storage latency and endurance. Tails' hardware requirements remain authoritative. Faster USB media can substantially reduce Bitcoin Core synchronization time.

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

USB sticks with higher random-I/O performance:
- [SanDisc Extreme Pro USB](https://amzn.to/3KngiA0)
- [SAMSUNG FIT Plus USB](https://amzn.to/3OjRmdY)
- [SAMSUNG Type-C USB](https://amzn.to/3rTpQfM)
- [SAMSUNG BAR Plus USB](https://amzn.to/45hxyyR)
- [Transcend Jetflash 920 USB](https://amzn.to/3KqNh6z)
- [Transcend Jetflash 930C USB](https://amzn.to/3q8pu4B)

MicroSD memory cards with higher random-I/O performance:
- [SanDisc Extreme microSD](https://amzn.to/3KraGF7)
- [SAMSUNG PRO Plus microSD](https://amzn.to/3Qn9INK)
- [SAMSUNG EVO Select microSD](https://amzn.to/3Km8sXd)
- [Silicon Power Superior microSD](https://amzn.to/3OHoBZZ)

A full, unpruned node needs substantially more storage than the minimum USB size and that requirement grows over time. Check current Bitcoin Core storage requirements rather than relying on a fixed capacity estimate here.

## I don't have a computer, what type should I get?

Start with [Tails' requirements](https://tails.net/doc/about/requirements/index.en.html). For Bitcoin Core initial synchronization, more RAM and faster USB storage generally reduce time and flash wear. Hardware compatibility with Tails is a prerequisite; CipherStick does not broaden Tails' supported hardware.

Storage on the computer itself is not required for the normal USB-based flow. Screen size is less important than Tails compatibility, but dialogs should still be checked on the supported Tails desktop resolution.

# During Setup

## What’s the deal with the "Do you trust this individual?"

Bitcoin Core releases are signed by individual builders. A signature is useful only if you have a reason to trust that the displayed fingerprint belongs to the person and that their release-signing process is trustworthy. CipherStick's verification flow does not turn an unknown signer into a trusted one automatically.

## Does it matter what order I enter Codex32 shares when restoring?

Codex32 shares can be entered in any order until the recovery threshold is reached. The removed legacy CipherStick wallet flow is not the supported restoration interface; use the **codex32** application instead.

## How do I make initial synchronization faster?

1. Check network bandwidth and Tor connectivity.
2. Use USB storage with good sustained and random-I/O performance.
3. Avoid unnecessary restarts during initial synchronization.
4. Give Bitcoin Core enough RAM for the computer you are using, while leaving memory policy to the supported CipherStick/Bitcoin Core configuration.

AssumeUTXO support is tracked separately in #92/#220. Do not assume it is part of the current supported installation until that work is merged and documented.

## How reliable is my USB stick?

Flash media can fail or lose data. Prefer new, reputable media, keep it cool, shut Bitcoin Core down cleanly, and maintain independently tested backups of data you cannot reproduce. CipherStick does not guarantee USB durability.

# After Setup

## If I unplug CipherStick and use the computer for another task, will Bitcoin Core resume later?

If you shut Bitcoin Core down cleanly and then shut down Tails, Bitcoin Core normally resumes from its previous chain state the next time Tails starts, Persistent Storage is unlocked, and networking is available. Abrupt power loss or removal can corrupt data, so do not treat forced removal as a normal shutdown method.

## How do I update CipherStick?

Use the CipherStick Settings update action provided by the installed version. Review the release/source you are about to run and retain recovery material before changing a security-sensitive installation.

## How can I copy the block chain from a Bitcoin node I already have?

Bitcoin Core can reuse `blocks` and `chainstate` from another compatible node, but copying state from an untrusted or inconsistent source can cause failures or force revalidation. Follow Bitcoin Core's data-directory documentation and Tails' guidance for accessing external or internal drives.

## What type of backup USB stick should I get?

CipherStick does not currently provide a supported managed backup-USB workflow. Do not treat a full Persistent Storage clone as a wallet backup merely because it boots. Back up Bitcoin Core wallet data and recovery material explicitly using the upstream procedures appropriate to that data, and test recovery independently.

## How do I make a backup CipherStick?

Automatic CipherStick cloning/backup is unfinished and unsupported. Use a fresh Tails installation for another CipherStick and deliberately copy only the data you intend to transfer. A full Persistent Storage copy can carry wallet ciphertext, configuration, logs, and other identifying state.

If you are preserving an older CipherStick because you depend on the removed legacy wallet recovery path, keep the original media unchanged until the replacement recovery flow has been tested with your recovery material.

## How should I handle independently created backup media?

Keep backup media physically secure, cool, and clearly distinguishable from the active device. Test recovery before relying on it. Do not store a backup beside all of the secrets needed to decrypt or spend from it, and do not assume CipherStick can recover data that Tails, Bitcoin Core, or the media itself can no longer read.
