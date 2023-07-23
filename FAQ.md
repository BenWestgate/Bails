# Before use
## What is Bails?

It's first and foremost easy to use, free, easy to setup and very private.

I believe it's extremely secure in relation to the effort it takes to setup and use. 
Nothing comes close since you get: isolated security focused free open-source OS, Strong encyption, Tor, verify signatures, Bitcoin Core full node, and a secret sharing style paper backup done all in under an hour. And it doesn't need a dedicated PC, just a dedicated USB stick.

The only options that match or come close in backup privacy in similar time span, don't even scratch the surface for anything else security critical and are more error prone. 

But it doesn't make the most secure setup possible yet, but that will come in the next version or two after testers give me feedback and tell me what they want to see next.

This would be appropriate for up to half a year's expenses. Life savings need multi-signature and offline signers.

## How much storage do I need on my test laptop?

You don't need any storage free on your test laptop. You just need a 16+GB USB stick, the whole thing runs from that USB and leaves your laptop storage untouched.

## When I’m installing Tails, I should Create Persistent Storage, right?

No, Bails will Create the Persistent Storage for you. You will miss important steps if you try to set this up yourself before running the `git clone https://github.com/benwestgate/bails; */b` command.

# During Setup

## What’s the deal with the "Do you trust this individual?"

In short if you know who they are and believe they could have reviewed the bitcoin source code and built it then you can trust their signature. If you don't trust anyone on the list, ask someone trustworthy who they would trust. Or start over and click "Skip" and I’ll pick 2 randomly from a list of who I think are good.

## Does it matter what order I enter shares when restoring?
No. But right now, you do have to keep your laptop on until you’ve reached a threshold. So if you’d have to fetch some of those by travel or video calls it makes sense to enter those first so you’re not waiting around with as many shares stored in the computers memory. For this reason the seed backup passphrase is always last.

## How do I make this go faster?
First check that your internet bandwidth is not slow. You can't sync faster than you can download.
Then check that your USB has a sequential write speed > your internet speed
random read speed SHOULD be as High as possible (link to http://usb.benchmark.com random read rankings) if your PC has less available RAM than the chainstate, <=8GB RAM
USB capacity should be >X,Y,Z GB for 4,8,16GB RAM (TODO test this) to make full use of your system's memory
random write speed should be as high as possible if the USB stick capacity is below that OR the available memory < chainstate
sequential read speed helps for rescanning wallets but not IBD.
Two settings will be added to the menu to increase the speed of sync and reduce the wear on the USB

## How reliable is my USB?
For reliability, it SHOULD be a new USB, not a heavily used one, and it SHOULD be kept cool in use and in storage. And having more RAM on the PC and capacity on the USB (especially the XYZ amount above) stick helps reduce wear. As well as shutting down the node less often. And using either "sync faster" option.

# After Setup

## If I wanted to unplug Bails and use the computer for another task will the core download just restart where it left off on the next time I log in?
If you shutdown bitcoin core safely, waiting for it to exit before shutting down Tails (from the menu in the upper right) it will resume where you left off the next time you Start on Tails, unlock its Persistent Storage, and connect to Tor.
If you shutdown Tails without exiting Bitcoin core safely, or by yanking the USB stick out, it is possible to corrupt the blockchain database eventually and lose your progress. Only remove the USB to shutdown Tails in an Emergency.

