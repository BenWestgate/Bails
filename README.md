# ![image](https://github.com/BenWestgate/Bails/raw/master/docs/banner2.png)

# Bails

Bails is the most private way to transact and store bitcoin. It protects your money from surveillance, censorship and confiscation. And leaves no trace of your Bitcoin use on the computer nor the Internet. Keeping your transactions anonymous and balances a secret with strong encryption.

## Bitcoin Core on Tails

Tails and Bitcoin Core are depended on by millions to maintain their privacy and security online especially in sensitive and high-risk situations.

This repository contains a script that installs Bitcoin Core to Tails and creates a Bails wallet.

<b>Bitcoin Core</b> connects to the Bitcoin peer-to-peer network to download and fully validate blocks and transactions. It also includes a wallet and graphical user interface.

<b>Tails</b> is a portable operating system that protects against surveillance and censorship. It connects to the Internet exclusively through the anonymity network Tor.

[Bitcoin Core :: About](https://bitcoincore.org/en/about/)

[Tails - How Tails works](https://tails.net/about/index.en.html)

## Why use Bitcoin Core?

### Full Validation

Bitcoin Core ensures every block and transaction it accepts is valid, increasing not only your security but also <b>helping prevent miners and banks from taking control of Bitcoin.</b>

[Learn about full validation](https://bitcoin.org/en/bitcoin-core/features/validation)

### Excellent Privacy

Bitcoin Core provides <b>exclusive privacy features</b> to make it hard for anyone to link you to your transactions.

[Discover the privacy advantages](https://bitcoin.org/en/bitcoin-core/features/privacy)

## How to use this script

If you know someone you trust who uses Bails already, you can [install Bails by cloning](https://github.com/BenWestgate/Bails/tree/master#bails-is-shareware) their Bails:

First, open these instructions on another device

![image](https://user-images.githubusercontent.com/73506583/203773811-b157925d-404f-4b91-bd86-6d2e6b454a59.png)

In the next step, you will shut down the computer. To be able to follow the rest of the instructions afterwards, you can either:

* Scan this QR code on your smartphone or tablet:

![image](https://github.com/BenWestgate/Bails/assets/73506583/72496200-fa4f-4ce3-94de-06cc88296e73)
* Print these instructions on paper.

* Take note of the URL of this page:
```
https://github.com/benwestgate/bails#install-steps
```

### Install steps

1. [Install Tails](https://tails.net/install/index.en.html) to a USB stick or Memory Card, minimum 16 GB capacity.
      * If you know someone you trust who uses Tails already, you can [install Tails by cloning](https://tails.boum.org/install/clone/index.en.html) their Tails.
1. [Start Tails](https://tails.net/doc/first_steps/start/index.en.html).
      * If you installed by cloning Bails, enter your temporary [Persistent Storage](https://tails.net/doc/first_steps/welcome_screen/index.en.html#index3h1) passphrase.
1. [Connect to a local network](https://tails.net/doc/anonymous_internet/networkmanager/index.en.html#index1h1).
1. [Connect to Tor](https://tails.net/doc/anonymous_internet/tor/index.en.html).
      * If you cloned Bails, skip to step 7.
1. Open a terminal. Choose <b>Applications ▸ Utilities ▸ Terminal</b>.
1.  Type or Paste the following in Terminal, then press Enter:
``` bash
git clone https://github.com/benwestgate/bails; */b

```
7. Follow the Instructions on Screen.
1. You're Done!
   
#### Bails is [shareware](https://en.wikipedia.org/wiki/Samizdat).

* To share this free open-source software with family and friends: Choose <b>Applications ▸ Office ▸ ₿ails ▸ Clone</b>.

Why clone Bails?

* Sharing hand-to-hand prevents censorship and surveillance.
* Cloning Bails saves them considerable setup time and makes your backup safer. A win-win situation!


## Source Code Headers

Every file containing source code must include copyright and license
information. This includes any JS/CSS files that you might be serving out to
browsers. (This is to help well-intentioned people avoid accidental copying that
doesn't comply with the license.)

MIT header:

    Copyright (c) 2023 Ben Westgate
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

### Bails is the World's First Codex32-enabled (BIP93) Wallet
https://github.com/bitcoin/bips/blob/master/bip-0093.mediawiki

https://secretcodex32.com/index.html

### Compliant with Auditable Bitcoin Wallets Standard
https://github.com/oleganza/bitcoin-papers/blob/master/AuditableBitcoinWallets.md

All information needed to audit `bails-wallet` is displayed by the terminal.
