# ![image](https://github.com/BenWestgate/Bails/raw/master/docs/banner2.png)

# CipherStick (formerly known as "Bails")

CipherStick is experimental software that automates installation and configuration of Bitcoin Core on Tails. It is intended to make a full-node, Tor-routed Bitcoin setup easier to operate from a dedicated USB stick. It does not guarantee anonymity, protection from confiscation, or that Bitcoin activity leaves no trace.

## Bitcoin Core on Tails

Bitcoin Core and Tails are mature upstream projects with their own security and privacy properties. CipherStick adds automation around installing and configuring them; it does not replace their security models.

Bitcoin Core connects to the Bitcoin network to download and validate blocks and transactions, featuring a user-friendly interface and built-in wallet.
- [Bitcoin Core :: About](https://bitcoincore.org/en/about/)

Tails is a portable operating system that routes supported networking through Tor and is designed to reduce traces left on the computer it runs on.
- [Tails - How Tails works](https://tails.net/about/index.en.html)

## Why use Bitcoin Core?

### Full Validation

Bitcoin Core independently validates blocks and transactions against Bitcoin's consensus rules instead of asking a third-party wallet server to do that validation for you.

[Learn about full validation](https://bitcoin.org/en/bitcoin-core/features/validation)

### Privacy Properties

Running your own Bitcoin Core node avoids disclosing your wallet queries to a third-party wallet server. Tails routes supported network traffic through Tor. These properties reduce some information leaks, but they do not make transactions anonymous or prevent counterparties, exchanges, merchants, compromised hardware, or other endpoints from correlating activity.

[Discover the privacy advantages](https://bitcoin.org/en/bitcoin-core/features/privacy)

# How to Install

## You need
- **1 USB stick** or memory card, 32 GB minimum
    - If you need a USB stick, see our [recommended USB sticks](https://github.com/BenWestgate/Bails/blob/master/docs/FAQ.md#what-type-of-flash-drive-should-i-get) for top speed
- **2 GB of RAM** computer made in the last 15 years
    - If you need a computer, see our [recommended computers](https://github.com/BenWestgate/Bails/blob/master/docs/FAQ.md#i-dont-have-a-computer-what-type-should-i-get) to save money
- **A smartphone** to follow the instructions
- **Pen or pencil**
- **Couple pieces of paper**
- **Hard surface** to write on
- **Time for Tails installation and CipherStick setup, plus Bitcoin Core synchronization.** Total duration varies substantially with hardware and network performance; setup time is not the same as initial block download time.

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
   - The repository contains unfinished cloning code, but cloning is not currently a supported installation path.
1. [Start Tails](https://tails.net/doc/first_steps/start/index.en.html).
   - At the [Welcome Screen](https://tails.net/doc/first_steps/welcome_screen/index.en.html), ignore "Create Persistent Storage" and click "Start Tails".
     - CipherStick will help you set up Persistent Storage later.
1. [Connect to a local network](https://tails.net/doc/anonymous_internet/networkmanager/index.en.html#index1h1).
1. [Connect to Tor](https://tails.net/doc/anonymous_internet/tor/index.en.html) when the _Tor Connection_ window appears.
1. Open a terminal. Choose **Applications** ▸ **Utilities** ▸ **Terminal**.
1. Type or paste the following in Terminal, then press Enter:
    ```bash
    git clone https://github.com/benwestgate/bails&&bails/b
    ```
    ![image](https://github.com/BenWestgate/Bails/assets/73506583/0522b2fe-5f7e-4548-a74e-e78ce6c52c53)
1. Follow the instructions on screen.
1. You're done.
   - [Share your feedback, questions and suggestions](https://github.com/BenWestgate/Bails/issues/new) to make CipherStick better.

### Distribution and cloning status

Hand-to-hand distribution and selective data handoff are design goals, but the current Clone menu path is unfinished and is not a supported feature. Do not rely on cloning as a security or backup property of the current alpha release.

# Support resources

For support and discussion join our [telegram channel](https://t.me/bails_support).

For more reading checkout our [Frequently Asked Questions](docs/FAQ.md).

To contact Ben Westgate by email `benwestgate@protonmail.com`.

## Advantages and Disadvantages

For a discussion of implemented properties, limitations, and planned work, refer to [Advantages and Disadvantages](docs/Advantages_and_Disadvantages.md) and [Design Scope](docs/DESIGN_SCOPE.md).

### Codex32 status

The repository currently contains a legacy experimental Codex32 wallet implementation. That wallet path is being removed because it is not supported on current Tails; replacement restoration with `python-codex32` is tracked separately. Do not treat planned offline, multisig, inheritance, or cloning designs as current capabilities.

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
