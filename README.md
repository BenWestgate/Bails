# ![image](https://github.com/BenWestgate/Bails/raw/master/docs/banner2.png)

# Bails

Bails is the most private way to transact and store bitcoin. It ensures your money is protected from surveillance, censorship, and confiscation, leaving no trace of your Bitcoin use on the computer or the Internet. Combining Bitcoin Core and Tails, Bails offers strong anonymity for transactions and secure encrypted storage.

## Bitcoin Core on Tails

Bitcoin Core and Tails are relied upon by millions to safeguard their online privacy and security, particularly in sensitive and high-risk situations. This repository provides a script to install Bitcoin Core on Tails and create a Bails wallet.

Bitcoin Core connects to the Bitcoin network to download and validate blocks and transactions, featuring a user-friendly interface and built-in wallet. Tails is a portable operating system that defends against surveillance and censorship, exclusively utilizing the Tor anonymity network.

See Also:
- [Bitcoin Core :: About](https://bitcoincore.org/en/about/)
- [Tails - How Tails works](https://tails.net/about/index.en.html)

## Why use Bitcoin Core?

### Full Validation

Bitcoin Core ensures the validity of every block and transaction, enhancing your security and preventing miners and banks from seizing control of Bitcoin.

[Learn about full validation](https://bitcoin.org/en/bitcoin-core/features/validation)

### Excellent Privacy

Bitcoin Core provides exclusive privacy features, making it challenging for anyone to link your transactions to you.

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

1. [Install Tails](https://tails.net/install/index.en.html) to a USB stick or Memory Card (minimum 16 GB capacity).
   - If you know someone you trust already uses Tails, you can [install Tails by cloning](https://tails.boum.org/install/clone/index.en.html) their Tails.
1. [Start Tails](https://tails.net/doc/first_steps/start/index.en.html).
   - If you installed by cloning Bails, enter your temporary [Persistent Storage](https://tails.net/doc/first_steps/welcome_screen/index.en.html#index3h1) passphrase.
1. [Connect to a local network](https://tails.net/doc/anonymous_internet/networkmanager/index.en.html#index1h1).
1. [Connect to Tor](https://tails.net/doc/anonymous_internet/tor/index.en.html).
   - If you cloned Bails, skip to step 7.
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

## Advantages and Disadvantages

For a comprehensive discussion on the advantages and disadvantages of using Bails as a Bitcoin solution, please refer to our [detailed document](Advantages_and_Disadvantages.md). It provides valuable insights into the unique features and potential limitations of the Bails platform.

# Support resources

For support join our [slack channel](https://join.slack.com/t/bitcoin-core-on-tails/shared_invite/zt-1zkivlojk-boiVT8gtM~kSzdBLqZrhRA).

For more reading checkout our [FAQ](FAQ.md).

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

Find more information on [Codex32](https://secretcodex32.com/index.html) and [BIP93](https://github.com/bitcoin/bips/blob/master/bip-0093.mediawiki).

### Compliant with Auditable Bitcoin Wallets Standard

Refer to the [Auditable Bitcoin Wallets Standard](https://github.com/oleganza/bitcoin-papers/blob/master/AuditableBitcoinWallets.md
) for compliance details. All necessary information to audit `bails-wallet` is displayed by the terminal.
