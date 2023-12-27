# ![image](https://github.com/BenWestgate/Bails/raw/master/docs/banner2.png)

# Bails

BAILS is the most private way to transact and store bitcoin. It ensures your money is protected from surveillance, censorship, and confiscation, leaving no trace of your Bitcoin use on the computer or the Internet. Combining Bitcoin Core and Tails, Bails offers strong anonymity for transactions and secure encrypted storage.

## Bitcoin Core on Tails

Bitcoin Core and Tails are relied upon by millions to safeguard their online privacy and security, particularly in sensitive and high-risk situations. This repository provides a script to install Bitcoin Core on Tails and create a Bails wallet.

Bitcoin Core connects to the Bitcoin network to download and validate blocks and transactions, featuring a user-friendly interface and built-in wallet.
- [Bitcoin Core :: About](https://bitcoincore.org/en/about/)


Tails is a portable operating system that defends against surveillance and censorship, exclusively utilizing the Tor anonymity network.
- [Tails - How Tails works](https://tails.net/about/index.en.html)


## Why use Bitcoin Core?

### Full Validation

Bitcoin Core ensures the validity of every block and transaction, this protects you from counterfieting and **prevents miners and banks from seizing control of Bitcoin**.

[Learn about full validation](https://bitcoin.org/en/bitcoin-core/features/validation)

### Excellent Privacy

Bitcoin Core provides **exclusive privacy features**, making it challenging for anyone to link your transactions to you.

[Discover the privacy advantages](https://bitcoin.org/en/bitcoin-core/features/privacy)

# How to Install

## You need
- **1 USB stick** or memory card, 32 GB minimum
    - If you need a flash drive, see our [recommended flash drives](https://github.com/BenWestgate/Bails/blob/master/FAQ.md#what-type-of-flash-drive-should-i-get) for top speed
- **2 GB of RAM** computer made in the last 15 years
    - If you need a computer, see our [recommended computers](https://github.com/BenWestgate/Bails/blob/master/FAQ.md#i-dont-have-a-computer-what-type-should-i-get) to save time
- **A smartphone** to follow the instructions
- **Pen or pencil**
- **Couple pieces of paper**
- **Hard surface** to write on
- **1 hour in total** 1.3 GB to download, ½ hour to install Tails, ¼ hour to setup Bails

## Your steps

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

1. [Install Tails](https://tails.net/install/index.en.html) to a USB stick or memory card (minimum 32 GB of capacity).
   - If you know someone you trust who uses Bails already, you can [install Bails by cloning](https://github.com/BenWestgate/Bails/tree/master#bails-is-shareware) their Bails:
1. [Start Tails](https://tails.net/doc/first_steps/start/index.en.html).
   - At the [Welcome Screen](https://tails.net/doc/first_steps/welcome_screen/index.en.html), ignore "Create Persistent Storage" and click "Start Tails".
     - Bails will help you set up Persistent Storage later.
   - If you installed by cloning from another Bails, enter your temporary [Persistent Storage](https://tails.net/doc/first_steps/welcome_screen/index.en.html#index3h1) passphrase, click "Unlock Encryption", and then click "Start Tails".
1. [Connect to a local network](https://tails.net/doc/anonymous_internet/networkmanager/index.en.html#index1h1).
1. [Connect to Tor](https://tails.net/doc/anonymous_internet/tor/index.en.html) when the _Tor Connection_ window appears.
   - If you cloned Bails, skip to step 7.
1. Open a terminal. Choose **Applications** ▸ **Utilities** ▸ **Terminal**.
1.  Type or Paste the following in Terminal, then press Enter:
    ```bash
    git clone https://github.com/benwestgate/bails; */b
    ```
    ![image](https://github.com/BenWestgate/Bails/assets/73506583/0522b2fe-5f7e-4548-a74e-e78ce6c52c53)
1. Follow the instructions on Screen.
1. You're Done!
   - [Share your feedback, questions and suggestions](https://github.com/BenWestgate/Bails/issues/new) to make Bails even better!
   
### Bails is [shareware](https://en.wikipedia.org/wiki/Samizdat).

- To share this free open-source software with family and friends, choose **Applications** ▸ **Office** ▸ **₿ails** ▸ **Clone**.

#### Why clone Bails?

- Sharing hand-to-hand prevents censorship and surveillance.
- Cloning Bails saves them considerable setup time and makes your backup safer. A win-win situation!

# Support resources

For support and discussion join our [slack channel](https://join.slack.com/t/bitcoin-core-on-tails/shared_invite/zt-1zkivlojk-boiVT8gtM~kSzdBLqZrhRA) or [telegram channel](https://t.me/bails_support).

To contact Ben Westgate by email `benwestgate@protonmail.com`.

For more reading checkout our [Frequently Asked Questions](FAQ.md).

## Advantages and Disadvantages

For a discussion on the pros and cons of using Bails, refer to the [detailed document](Advantages_and_Disadvantages.md). It describes the unique features and limitations of the Bails platform.

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

Refer to the [Auditable Bitcoin Wallets Standard](https://github.com/oleganza/bitcoin-papers/blob/master/AuditableBitcoinWallets.md) for compliance details. All necessary information to audit `bails-wallet` is displayed by the terminal.
