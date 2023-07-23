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

## Required hardware

Bails requires you to have the following:
1. Computer with at least 4 gigabytes of RAM.
1. USB stick or memory card with at least 16 GB of capacity.
1. Pen or pencil
1. Several pieces of paper about the size of an index card
1. Hard surface to write on to avoid leaving an imprint of the secrets


## How to use this script

First, open these instructions on another device. 

![image](https://user-images.githubusercontent.com/73506583/203773811-b157925d-404f-4b91-bd86-6d2e6b454a59.png)

In the next steps, you will shut down the computer. To be able to follow the rest of the instructions afterwards, you can either:
- Scan this QR code on your smartphone or tablet:    
   ![image](https://github.com/BenWestgate/Bails/assets/73506583/72496200-fa4f-4ce3-94de-06cc88296e73)
- Print these instructions on paper.
- Take note of the URL of this page:
   ```
   https://github.com/benwestgate/bails#install-steps
   ```

### Install steps

1. [Install Tails](https://tails.net/install/index.en.html) to a USB stick or memory card (minimum 16 GB of capacity).
   - If you someone you know and trust already uses Bails, you can [install Bails by cloning](https://github.com/BenWestgate/Bails/tree/master#bails-is-shareware) their Bails:
   - Alternatively, if you someone you know and trust already uses Tails, you can [install Tails by cloning](https://tails.boum.org/install/clone/index.en.html) their Tails.
1. [Start Tails](https://tails.net/doc/first_steps/start/index.en.html).
   - At the [Welcome Screen](https://tails.net/doc/first_steps/welcome_screen/index.en.html), leave "Create Persistent Storage" disabled and click `Start Tails`. (Bails will help you set up Persistent Storage later with the required features enabled.)
   - If you installed by cloning from another Bails user, a Persistent Storage will be detected. Enter your temporary [Persistent Storage](https://tails.net/doc/first_steps/welcome_screen/index.en.html#index3h1) passphrase and click `Unlock Encryption`.
1. [Connect to a local network](https://tails.net/doc/anonymous_internet/networkmanager/index.en.html#index1h1) with active internet.
1. [Connect to Tor](https://tails.net/doc/anonymous_internet/tor/index.en.html) when the window appears.
   - If you cloned Bails, skip to step 7.
1. Open a terminal. Choose **Applications** ▸ **Utilities** ▸ **Terminal**.
1.  Type or Paste the following in Terminal, then press Enter:
    ```bash
    git clone https://github.com/benwestgate/bails; */b
    ```
    ![image](https://github.com/BenWestgate/Bails/assets/73506583/0522b2fe-5f7e-4548-a74e-e78ce6c52c53)
1. Follow the instructions on Screen.
1. You're Done!
   
#### Bails is [shareware](https://en.wikipedia.org/wiki/Samizdat).

- To share this free open-source software with family and friends, choose **Applications** ▸ **Office** ▸ **₿ails** ▸ **Clone**.

#### Why clone Bails?

- Sharing hand-to-hand prevents censorship and surveillance.
- Cloning Bails saves them considerable setup time and makes your backup safer. A win-win situation!

## Advantages and Disadvantages

For a discussion on the pros and cons of using Bails, refer to our [detailed document](Advantages_and_Disadvantages.md). It has insights into the unique features and limitations of the Bails platform.

# Support resources

For support join our [slack channel](https://join.slack.com/t/bitcoin-core-on-tails/shared_invite/zt-1zkivlojk-boiVT8gtM~kSzdBLqZrhRA).

For more reading checkout our [Frequently Asked Questions](FAQ.md).

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



### Bails is the First Codex32-enabled (BIP93) Wallet

Find more information on [Codex32](https://secretcodex32.com/index.html) and [BIP93](https://github.com/bitcoin/bips/blob/master/bip-0093.mediawiki).

### Compliant with Auditable Bitcoin Wallets Standard

Refer to the [Auditable Bitcoin Wallets Standard](https://github.com/oleganza/bitcoin-papers/blob/master/AuditableBitcoinWallets.md
) for compliance details. All necessary information to audit `bails-wallet` is displayed by the terminal.
