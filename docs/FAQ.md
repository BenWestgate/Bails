# Before use
## What is Bails?

It's first and foremost easy to use, free, quick to setup and very private.

Bails grew from the question:
> How could everyone keep using Bitcoin easily and safely were it banned?

Because projects like **Bails** exist and work, the more people who use them, the less likely Bitcoin bans will ever be attempted.

I believe it's extremely secure in relation to the effort it takes to setup and use, you get an isolated security focused free open-source operating system, strong encyption, Tor, verified signatures, a Bitcoin Core full node, and a shamir secret sharing backup in under an hour. And it doesn't need a dedicated PC, just a dedicated USB stick.

Other options with similar privacy and setup time span either: aren't free, are more error prone and/or give weaker security. 

Bails does not make the most secure setup possible yet: offline multi-sig airgapped signing. It is meant for regular or occasional, high privacy transacting not storing National Treasures but a cold storage wallet for savings will come after Beta testers give feedback what they want to see next.

Bails  would be appropriate for up to half a year's expenses. Life savings need multi-signature, offline, airgapped signers.

## How much storage do I need on my test laptop?

You don't need any storage available on your test laptop. You just need a 32+ GB USB stick, the whole thing runs from that USB and leaves your laptop storage untouched.

## How does it run on 32GB USB sticks, I thought the blockchain was 600+ GB?

Bails uses [pruning](https://bitcoin.org/en/release/v0.12.0#wallet-pruning) when the USB stick is less than 1 TB. All block chain data will be downloaded and verified but the oldest blocks will be removed so your USB stick does not run out of space. Unless you wish to restore an old wallet, this doesn't matter.

## What is the difference between Codex32, Shamir Secret Sharing and Multisig?

[Andrew Polestra: What is Shamir Secret Sharing and how does it compare to Multisig?](https://youtu.be/jDjEEX0ASxY?si=vooa8JA858EmRME6&t=1209)

## When I’m installing Tails, I should Create Persistent Storage, right?

**No!** Bails will create the Persistent Storage for you. You will miss important steps if you try to set this up yourself before running the `git clone https://github.com/benwestgate/bails; */b` command. If you do this and did not select a long passphrase consisting of 4-7 random words you MUST restart, delete your persistent storage and start over.

## I don't have a USB stick, what one should I get?

Bails will work well on most USB sticks if your computer has at least 8 GB of memory. Tails will start and Bitcoin Core will sync and shutdown much faster if the drive has high "IOPS". This performance is not commonly advertised on the package so here are some models that are top performers, using one of these will reduce your startup and initial sync time by 50-90%:

USB sticks with SSD-like performance:
- [Kingston DataTraveler Max Type-C USB](https://amzn.to/3OpMELw)
- [Kingston DataTraveler Max Type-A USB](https://amzn.to/3Yie7DL)
- [PNY PRO Elite V2 USB](https://amzn.to/43QbJ8p)
- [Corsair Flash Voyager GTX USB](https://amzn.to/47joyLm)
- [HP x796w USB](https://amzn.to/3Qq7SeU)
- [Lexar JumpDrive P30 USB](https://amzn.to/3KnHNcz)

Portable SSDs aka USB sticks with SSD-like performance:
- [Transcend ESD310C Portable SSD](https://amzn.to/44U2OUv)
- [Netac Portable SSD Dual Interface](https://amzn.to/3DOD4wR)
- [SSK SSD Solid State Flash Drive](https://amzn.to/3Qpgoer)

USB sticks with at least double the typical IOPS performance (may be cheaper)
- [SanDisc Extreme Pro USB](https://amzn.to/3KngiA0)
- [SAMSUNG FIT Plus USB](https://amzn.to/3OjRmdY)
- [SAMSUNG Type-C USB](https://amzn.to/3rTpQfM)
- [SAMSUNG BAR Plus USB](https://amzn.to/45hxyyR)
- [Transcend Jetflash 920 USB](https://amzn.to/3KqNh6z)
- [Transcend Jetflash 930C USB](https://amzn.to/3q8pu4B)

MicroSD memory cards with at least double the typical USB stick's IOPS performance (cheaper)
- [SanDisc Extreme microSD](https://amzn.to/3KraGF7)
- [SAMSUNG PRO Plus microSD](https://amzn.to/3Qn9INK)
- [SAMSUNG EVO Select microSD](https://amzn.to/3Km8sXd)
- [Silicon Power Superior microSD](https://amzn.to/3OHoBZZ)

1 TB of storage is needed to not prune the block chain. This allows your node to fully support the network serving all historical blocks, but it doesn't personally help you unless you have a 10 year old wallet to restore.
8 GB laptops are known to sync on budget 64 GB USB sticks in under 4 days if that helps you choose. While 4 GB Laptops are able to sync in 4 days on SSD-like USB sticks. Once you are synced, every USB stick and computer will perform well.

## I don't have a computer, what type should I get?

In addition to [Tails' recommendations](https://tails.net/doc/about/requirements/index.en.html), here are some Bails specific tips for selecting a computer to buy, buy and return, rent or borrow to complete the initial sync as fast as possible:

1. **New computers may be better if paranoid.** There are more opportunities in the supply chain to compromise a used, renewed, open-box or refurbished computer. But these options are reasonably safe if the seller does not know you intend to use the computer for Bitcoin. Paying with cash is another step to prevent linking your identity to the computer.

2. **Avoid computers with 4 GB of RAM or less**, they will force your USB stick to work much harder, wearing it out prematurely. On 4GB RAM, without one of the "SSD-like" drives above, the initial synchronization could take weeks instead of days. 8 GB RAM is better and 16 GB RAM is best. With 16 GB RAM computers *most* USB sticks can complete initial sync in hours, rather than days with 8 GB RAM.

3. **Choose Windows, MacOS or Linux.** While Chromebooks may work, most have 4 GB of RAM and there are [extra steps](https://www.reddit.com/r/tails/comments/pd56ha/cheap_chromebook_for_tails_setup_guide/) to make them run Tails. It's easier to start Tails from MacOS and Linux and easiest from Windows.

4. **Storage drive type and capacity don't matter.** Tails never uses your computer's storage. You're free to use this computer for other purposes or return it, after removing your Bails USB stick. Bails would even work with a used PC from eBay with no internal disk!

5. **Screen size and resolution don't matter.** With laptops or all-in-one desktops you can save money buying a smaller size and/or lower resolution screen. HD or 720p is plenty of space for Bitcoin Core and Bails. Almost any laptop or monitor will suffice.


**Enough already**, just show me a cheap and fast computer to get:
- [Desktops with 16GB RAM](https://amzn.to/3OkLaSR)
- [Laptops with 16GB RAM](https://amzn.to/3YiM2MB)

Once you are synced, nearly any computer will be fast enough to stay caught up as long as you use Bails regularly, especially if you have a [recommended USB stick](https://github.com/BenWestgate/Bails/blob/master/docs/FAQ.md#i-dont-have-a-USB-stick-what-one-should-i-get)

## What type of backup USB stick should I get?

1. Equal size to your primary Bails USB helps avoid pruning.
2. A fast write speed makes backing up faster.
3. Industrial SD cards and may retain data longer than "MLC" or "TLC" USB sticks.
4. Your backup USBs won't need fast read performance and can be cheaper models.

# During Setup

## What’s the deal with the "Do you trust this individual?"

In short, if you know who they are, know their GPG fingerprint belongs to them and believe they could have reviewed the Bitcoin Core source code and built it, then you can trust their signature. If you don't trust anyone on the list, ask someone trustworthy who they would trust. Or go back and click "Skip" to let the Bails developers choose whose signatures to trust.

## Does it matter what order I enter shares when restoring?
No. But currently, you do have to keep your computer on until you’ve reached a threshold. So if you’d have to fetch some by travel or encrypted video calls it makes sense to enter those first so you’re not waiting around with as many shares stored in the computer's memory. For this reason, the seed backup passphrase is always last.

## How do I make this go faster?
1. Check that your internet bandwidth is not slow. You can't sync faster than you can download and the blockchain is around 600 GB.
2. Check that your USB stick has a sequential write speed > your internet speed. It might be on the box or you can look for benchmarks.
3. If it's neither of those, check if you had bad luck and connected through an unusually slow onion circuit and disconnect that peer.
![image](https://github.com/BenWestgate/Bails/assets/73506583/7d89fbdb-64f6-4d25-93c7-26a900488c5e)
4. USB stick random read speed should be over 10 MB/s (Check [USB Benchmark](http://usb.benchmark.com) 4k random read rankings) if your PC has 8GB of RAM or less.
5. USB capacity should be at least 8 times your system's RAM to make full use of your memory
6. Random write speed should be over 10 MB/s if you have 8 GB of RAM or less or a USB stick capacity that is only 2x or 4x your RAM. Sequential read speed helps for rescanning wallets but not IBD.
7. Avoid restarting Tails and using lots of bandwidth on other devices until it completes.

NOTE: New versions of Bails will sync in minutes instead of hours or days thanks to a beta feature called [AssumeUTXO](https://bitcoinops.org/en/topics/assumeutxo/). For extra high value transactions you should wait for the background initial block download to sync.

## How reliable is my USB stick?
For reliability, it SHOULD be a new USB stick, not a heavily used one, and it SHOULD be kept cool in use and in storage. Having more RAM on the PC and capacity on the USB stick, ideally 16+ GB RAM and 16x more USB stick capacity than RAM helps reduce wear. As well as shutting down the node less often. Further, some "Industrial" SD cards have better temperature and data loss resistance in storage than fast/large consumer USB sticks, these could be better for infrequently updated backups.

# After Setup

## If I wanted to unplug Bails and use the computer for another task will the core download just restart where it left off on the next time I log in?
If you shutdown Bitcoin Core safely, waiting for it to exit before shutting down Tails (from the menu in the upper right) it will resume where you left off the next time you start Tails, unlock its Persistent Storage, and connect to Tor.
If you shutdown Tails without exiting Bitcoin Core safely, or by yanking the USB stick out, it is possible to corrupt the blockchain database and lose your progress. Only remove the USB to shutdown Tails in an emergency.

## How do I update Bails?
Click **Applications > Favorites > Bails > Settings > Update Bails**. Make sure you still Trust this repository and it has retained a good reputation before doing so.

## How can I copy the block chain from a Bitcoin node I already have?
By copying the _blocks_ and _chainstate_ folders from your Bitcoin [data directory](https://github.com/bitcoin/bitcoin/blob/master/doc/files.md#data-directory-location). If you don't trust this node is not compromised, do NOT do this, wait for Bails to synchronize.

**External drive**: Plug it in while Tails is running. Use the _Files_ browser to copy the _chainstate_ and _blocks_ folders to _~/Persistent/.bitcoin_.

**Internal drive**: Read [Accessing the internal hard disk](https://tails.net/doc/advanced_topics/internal_hard_disk/index.en.html) first. You must restart and set an administration password on the Welcome Screen. Then you can access the internal drive in the Files browser to copy the _chainstate_ and _blocks_ folders to _~/Persistent/.bitcoin/_.

## How do I make a backup Bails USB stick?
Get a USB stick at least the same size  as your current Bails then:

1. Close Bitcoin Core (Ctrl+Q)
2. Wait for it to shutdown safely
3. Applications > Tails Cloner
4. Check "Clone the Current Persistent Storage"
5. Select your target USB stick (or SD card)
6. You will be prompted for a passphrase
  - We recommend using the same one as the current Persistent Storage so that it is easier to remember
  - You could use an off-site codex32 share as the passphrase if you're worried about forgetting your passphrase
    - Just don't store that share in the same place as the backup USB stick!! 
7. The device will be turned into an exact copy of your current Bails.
8. Test it if you'd like, then store it some place cool and safe from tampering.

If you want to use a smaller USB stick for the backup you may have to prune your current Bails first so that it will fit. You can find this setting in Bitcoin Core > Options.
![image](https://github.com/BenWestgate/Bails/assets/73506583/0eca8bfb-1ea5-466c-bdb2-929936c7347e)

## How should I handle my backup Bails USB stick?
1. Keep it under lock and key and/or hidden and ideally in a tamper evident way.
   - If someone skilled tampers with your Bails USB stick _**and** you use it without noticing_ they could monitor your activity or steal your bitcoins.
   - This is true of all Bitcoin wallet hardware, I am just honest, unlike some marketers.
2. Keep it cool, high temperatures can cause premature data loss.
3. Make your backup Bails USB stick look different from your current Bails USB stick.
4. We recommend using the same passphrase as your current Tails so it is easier to remember.
5. Update or create a new backup Bails USB stick at least every 6 months, more often without A/C.
6. You can use a third USB stick to create a new backup Bails to quickly replace an off-site backup Bails.
