# Before use
## What is Bails?

It's first and foremost easy to use, free, easy to setup and very private.

I believe it's extremely secure in relation to the effort it takes to setup and use. 
Nothing comes close since you get: isolated security focused free open-source OS, Strong encyption, Tor, verify signatures, Bitcoin Core full node, and a secret sharing style paper backup done all in under an hour. And it doesn't need a dedicated PC, just a dedicated USB stick.

The only options that match or come close in backup privacy in similar time span, don't even scratch the surface for anything else security critical and are more error prone. 

But it doesn't make the most secure setup possible yet, but that will come in the next version or two after testers give me feedback and tell me what they want to see next.

This would be appropriate for up to half a year's expenses. Life savings need multi-signature and offline signers.

## How much storage do I need on my test laptop?

You don't need any storage free on your test laptop. You just need a 32+ GB USB stick, the whole thing runs from that USB and leaves your laptop storage untouched.

## What type of USB stick should I get?

Bails should work ok with any USB stick if your computer has 8+ GB of memory, however Tails will start up and Bitcoin Core will sync much faster if the drive has high random read performance. And Bitcoin Core can flush and shutdown much faster if the drive has high random write performance. This performance is not commonly advertised on the package so here are some models that are top performers, using one of these could easily reduce your startup and initial sync time by 50-90%:

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

USB sticks with at least double the typical random read & write performance (may be cheaper)
- [SanDisc Extreme Pro USB](https://amzn.to/3KngiA0)
- [SAMSUNG FIT Plus USB](https://amzn.to/3OjRmdY)
- [SAMSUNG Type-C USB](https://amzn.to/3rTpQfM)
- [SAMSUNG BAR Plus USB](https://amzn.to/45hxyyR)
- [Transcend Jetflash 920 USB](https://amzn.to/3KqNh6z)
- [Transcend Jetflash 930C USB](https://amzn.to/3q8pu4B)

MicroSD memory cards with at least double the typical USB stick's random read performance (cheaper)
- [SanDisc Extreme microSD](https://amzn.to/3KraGF7)
- [SAMSUNG PRO Plus microSD](https://amzn.to/3Qn9INK)
- [SAMSUNG EVO Select microSD](https://amzn.to/3Km8sXd)
- [Silicon Power Superior microSD](https://amzn.to/3OHoBZZ)

1 TB of storage is needed to not prune the block chain. This allows your node to fully support the network serving all historical blocks, but it doesn't personally help you unless you have a 10 year old wallet to restore.
Choosing 32 GB capacity may reduce performance on 8+ GB RAM machines. What USB stick capacity optimizes performance for a given computer memory size is an open issue, bigger capacity equals faster if your machine has high RAM. 512GB will prune once, but should cause no significant slowdown as the blockchain is 540GB currently. 256GB will prune a couple times which will Not hurt performance at all on 4GB and 8GB laptops, but may slow down 16GB RAM. 128GB will probably not hurt performance any on 4GB laptops. 8GB laptops are known to sync on budget 64 GB USB sticks in under half a week if that helps you choose. Once you are synced, every size will perform equally well.

The links above are Amazon Affiliate links so purchasing through one helps fund Bails development.

## What type of backup USB stick should I get?

2. Equal size to your primary Bails USB helps avoid pruning.
3. A fast write speed makes backup go faster.
4. Industrial SD cards and may retain data longer than "MLC" or "TLC" USB sticks.
6. Your backup USBs won't need fast read performance and can be cheaper models.

## How should I handle my backup Bails USB stick?
4. Keep it under lock and key or hidden and ideally in a tamper evident manner.
5. If someone skilled tampers with your Bails USB stick and you use it without noticing they could steal your bitcoins or monitor your activity.
6. Keep it cool, high temperatures can cause premature data loss.
7. Make your backup Bails USB stick look different from your current Bails USB stick.
8. We recommend using the same passphrase as your current Tails so it is easier to remember
9. Update or create a new backup Bails USB stick at least every 6 months, more often without A/C.
10. You can use a third USB stick to create a new backup Bails to quickly replace an off-site backup.



## I don't have a computer, what type should I get?

In addition to [Tails' recommendations](https://tails.net/doc/about/requirements/index.en.html), here are some Bails specific tips for selecting a computer to buy, buy and return, rent or borrow to complete the initial sync as fast as possible:

1. **Avoid computers with 4 GB of RAM or less**, they will force your USB stick to work much harder, wearing it out prematurely. On 4 GB RAM, without one of the "SSD-like" drives above, the initial synchronization could take weeks instead of days. 8 GB RAM is better and 16 GB RAM is best. In 16GB RAM computers *most* USB sticks will complete initial sync in hours, rather than days in 8 GB RAM computers.

2. **Storage drive type and capacity don't matter.** Tails never uses your computer's storage. You're free to use this computer for other purposes or return it, after removing your Bails USB stick. Bails would even work with a used PC that has no internal disk.

3. **Choose Windows, MacOS or Linux.** While Chromebooks may work, most have 4 GB of RAM and there are [extra steps](https://www.reddit.com/r/tails/comments/pd56ha/cheap_chromebook_for_tails_setup_guide/) to make them run Tails. It is easier to start Tails from MacOS and Linux and easiest from Windows.

4. **Screen size and resolution don't matter.** With laptops or all-in-one desktops you can save money buying a smaller size or lower resolution screen. HD or 720p is plenty of space for Bitcoin Core and Bails windows. Almost any laptop or monitor will suffice.

5. **New computers could be better if paranoid.** There are more opportunities in the supply chain to compromise a used, renewed, open-box or refurbished computer. But these options are still reasonably safe if the seller does not know you intend to use the computer for Bitcoin. Paying with cash is another step to prevent linking your identity to this computer.

**Enough already**, just show me a cheap and fast computer to get:
- [Desktops with 16GB of RAM](https://amzn.to/3OkLaSR)
- [Laptops with 16GB of RAM](https://amzn.to/3YiM2MB)

Once you are synced, nearly any computer will be fast enough to stay caught up as long as you use Bails regularly and have a [recommended USB stick](https://github.com/BenWestgate/Bails/blob/master/FAQ.md#what-type-of-USB-stick-should-i-get)

## When I’m installing Tails, I should Create Persistent Storage, right?

No, Bails will Create the Persistent Storage for you. You will miss important steps if you try to set this up yourself before running the `git clone https://github.com/benwestgate/bails; */b` command. If you do this and did not select a long passphrase consisting of 4-7 random words you MUST restart, delete your persistent storage and start over.

# During Setup

## What’s the deal with the "Do you trust this individual?"

In short if you know who they are and believe they could have reviewed the bitcoin source code and built it then you can trust their signature. If you don't trust anyone on the list, ask someone trustworthy who they would trust. Or start over and click "Skip" and I’ll pick 2 randomly from a list of who I think are good.

## Does it matter what order I enter shares when restoring?
No. But right now, you do have to keep your laptop on until you’ve reached a threshold. So if you’d have to fetch some of those by travel or video calls it makes sense to enter those first so you’re not waiting around with as many shares stored in the computers memory. For this reason the seed backup passphrase is always last.

## How do I make this go faster?
First check that your internet bandwidth is not slow. You can't sync faster than you can download.
Then check that your USB stick has a sequential write speed > your internet speed.
random read speed SHOULD be as High as possible (link to http://usb.benchmark.com random read rankings) if your PC has less available RAM than the chainstate, <=8GB RAM
USB capacity should be >X,Y,Z GB for 4,8,16GB RAM (TODO test this) to make full use of your system's memory
random write speed should be as high as possible if the USB stick capacity is below that OR the available memory < chainstate
sequential read speed helps for rescanning wallets but not IBD.

## How reliable is my USB stick?
For reliability, it SHOULD be a new USB stick, not a heavily used one, and it SHOULD be kept cool in use and in storage. And having more RAM on the PC and capacity on the USB (especially the XYZ amount above) stick helps reduce wear. As well as shutting down the node less often.

# After Setup

## If I wanted to unplug Bails and use the computer for another task will the core download just restart where it left off on the next time I log in?
If you shutdown bitcoin core safely, waiting for it to exit before shutting down Tails (from the menu in the upper right) it will resume where you left off the next time you Start on Tails, unlock its Persistent Storage, and connect to Tor.
If you shutdown Tails without exiting Bitcoin core safely, or by yanking the USB stick out, it is possible to corrupt the blockchain database eventually and lose your progress. Only remove the USB to shutdown Tails in an Emergency.

## How can I copy the blockchain from a Bitcoin node I already have?
By copying the _blocks_ and _chainstate_ folders from your Bitcoin [data directory](https://github.com/bitcoin/bitcoin/blob/master/doc/files.md#data-directory-location). If you don't trust this node is not compromised, do not do this, wait for Bails to synchronize.

**External drive**: Plug it in while Tails is running. Use the _Files_ browser to copy the _chainstate_ and _blocks_ folders to _~/Persistent/.bitcoin_.

**Internal drive**: Read [Accessing the internal hard disk](https://tails.net/doc/advanced_topics/internal_hard_disk/index.en.html). You must restart and set an administration password on the Welcome Screen. Then you can access the internal drive in the Files browser to copy the _chainstate_ and _blocks_ folders to _~/Persistent/.bitcoin/_.

