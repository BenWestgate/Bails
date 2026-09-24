# ![image](https://github.com/BenWestgate/Bails/raw/master/docs/banner2.png)

# CipherStick (formerly known as "Bails")

CipherStick is experimental setup automation for Bitcoin Core on a dedicated Tails USB. It helps configure Persistent Storage and install Bitcoin Core; it does not create, restore, or manage wallet private keys.

CipherStick does not guarantee anonymity, censorship resistance, confiscation resistance, or that Bitcoin activity leaves no trace. It has not received an independent security audit.

## Bitcoin Core on Tails

CipherStick builds on Tails and Bitcoin Core; it does not replace either project's security model. This repository provides a script to install Bitcoin Core on Tails.

Bitcoin Core connects to the Bitcoin network to download and validate blocks and transactions, featuring a user-friendly interface and built-in wallet.
- [Bitcoin Core :: About](https://bitcoincore.org/en/about/)


Tails is a portable operating system that defends against surveillance and censorship, exclusively utilizing the Tor anonymity network.
- [Tails - How Tails works](https://tails.net/about/index.en.html)


## Why use Bitcoin Core?

### Full Validation

Bitcoin Core validates blocks and transactions against Bitcoin's consensus rules instead of relying on a remote wallet service for that validation. It cannot protect funds from compromised keys, software, hardware, or user mistakes.

[Learn about full validation](https://bitcoin.org/en/bitcoin-core/features/validation)

### Excellent Privacy

Using a personal node avoids disclosing every wallet query to a third-party wallet server. Tor reduces direct network-location exposure, but counterparties, transaction analysis, timing, and compromised endpoints can still reveal information.

[Discover the privacy advantages](https://bitcoin.org/en/bitcoin-core/features/privacy)

# How to Install

## You need
- **1 USB stick** or memory card, 32 GB minimum
    - If you need a USB stick, see our [recommended USB sticks](https://github.com/BenWestgate/Bails/blob/master/docs/FAQ.md#what-type-of-flash-drive-should-i-get) for top speed
- **2 GB of RAM** computer supported by Tails
    - If you need a computer, see our [recommended computers](https://github.com/BenWestgate/Bails/blob/master/docs/FAQ.md#i-dont-have-a-computer-what-type-should-i-get) to save money
- **A smartphone** to follow the instructions
- **Time for initial synchronization**: Bitcoin Core initial block download can take hours or days, depending on hardware, storage, network conditions, and chain state.

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
1. [Start Tails](https://tails.net/doc/first_steps/start/index.en.html).
   - At the [Welcome Screen](https://tails.net/doc/first_steps/welcome_screen/index.en.html), ignore "Create Persistent Storage" and click "Start Tails".
     - CipherStick will help you set up Persistent Storage later.
1. [Connect to a local network](https://tails.net/doc/anonymous_internet/networkmanager/index.en.html#index1h1).
1. [Connect to Tor](https://tails.net/doc/anonymous_internet/tor/index.en.html) when the _Tor Connection_ window appears.
1. Open a terminal. Choose **Applications** ▸ **Utilities** ▸ **Terminal**.
1.  Type or Paste the following in Terminal, then press Enter:
    ```bash
    git clone https://github.com/benwestgate/bails&&bails/b
    ```
    ![image](https://github.com/BenWestgate/Bails/assets/73506583/0522b2fe-5f7e-4548-a74e-e78ce6c52c53)
1. Follow the instructions on Screen.
1. CipherStick's clone and backup actions are unfinished and unsupported. Use a fresh Tails installation with new Persistent Storage; do not distribute a full Persistent Storage copy by default.

# Support resources

For support and discussion join our [telegram channel](https://t.me/bails_support).

For more reading checkout our [Frequently Asked Questions](docs/FAQ.md).

To contact Ben Westgate by email `benwestgate@protonmail.com`.

## Advantages and Disadvantages

For a discussion on the pros and cons of using CipherStick, refer to the [detailed document](docs/Advantages_and_Disadvantages.md). It describes the unique features and limitations of the CipherStick platform.

### Current scope

CipherStick installs and configures Bitcoin Core, guides Persistent Storage setup, and provides passphrase practice. Automated cloning, backup creation, offline signing, multisignature coordination, and Codex32 wallet restoration are not currently supported.

See the [CipherStick threat model](docs/THREAT_MODEL.md) for the installer-specific trust boundaries and non-goals.

## Source Code Headers

Every file containing source code must include copyright and license
information. This includes any JS/CSS files that you might be serving out to
browsers. (This is to help well-intentioned people avoid accidental copying that
doesn't comply with the license.)

MIT header:

    Copyright (c) 2025 Ben Westgate
    
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
