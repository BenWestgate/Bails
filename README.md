# ![image](https://github.com/BenWestgate/Bails/raw/master/docs/banner2.png)

# CipherStick (formerly known as "Bails")

CipherStick is experimental software for setting up Bitcoin Core on a dedicated Tails USB. It automates parts of Persistent Storage setup, Bitcoin Core installation and verification, and optional Sparrow installation. It does not make anonymity, confiscation resistance, censorship resistance, or "no trace" guarantees.

> **Alpha software:** CipherStick has not completed an independent security audit. Review the source and the documented limitations before using it with funds. Current bootstrap and update authentication are tracked separately and should be treated as part of the trust boundary.

## Bitcoin Core on Tails

CipherStick builds on Tails and Bitcoin Core rather than replacing their security models. Tails routes supported network traffic through Tor; Bitcoin Core independently validates Bitcoin consensus rules and keeps wallet and node data local to the configured data directory. CipherStick adds setup automation around those upstream projects.

- [Bitcoin Core :: About](https://bitcoincore.org/en/about/)
- [Tails - How Tails works](https://tails.net/about/index.en.html)

### Current support status

- **Implemented:** Tails Persistent Storage setup guidance, Bitcoin Core download/verification/installation, pruning configuration, Sparrow installation, and spaced-repetition passphrase practice.
- **Experimental / legacy:** the bundled Codex32 wallet flow. Replacement restoration work is tracked separately.
- **Planned / unsupported:** CipherStick cloning, backup automation, AssumeUTXO bootstrap, offline signing, and multisignature workflows described in the design scope.

## Why use Bitcoin Core?

### Full validation

Bitcoin Core validates blocks and transactions against Bitcoin's consensus rules instead of asking a third party for a wallet balance. This reduces reliance on remote wallet servers; it does not prevent theft caused by compromised keys, software, hardware, or user mistakes.

[Learn about full validation](https://bitcoin.org/en/bitcoin-core/features/validation)

### Local wallet privacy

Using your own node avoids revealing all wallet queries to a third-party wallet server. Network observers, counterparties, compromised endpoints, and transaction-graph analysis can still reveal information. Tor reduces direct network-location exposure but does not provide perfect transaction privacy.

[Discover Bitcoin Core privacy features](https://bitcoin.org/en/bitcoin-core/features/privacy)

# How to Install

## You need

- **1 USB stick** or memory card, 32 GB minimum
    - See the [FAQ](docs/FAQ.md) for performance considerations.
- **A computer supported by Tails** with at least 2 GB of RAM; more memory materially improves Bitcoin Core initial sync performance.
- **A second device or printed instructions** so you can follow the remaining steps after rebooting into Tails.

Hands-on setup time and Bitcoin Core initial block download are separate. Initial synchronization can take hours or days depending on hardware, storage, network conditions, and the current chain state; CipherStick does not publish a fixed completion-time guarantee.

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

1. [Install Tails](https://tails.net/install/index.en.html) to a dedicated USB stick or memory card (minimum 32 GB of capacity).
1. [Start Tails](https://tails.net/doc/first_steps/start/index.en.html).
   - At the [Welcome Screen](https://tails.net/doc/first_steps/welcome_screen/index.en.html), ignore "Create Persistent Storage" and click "Start Tails". CipherStick will help you set up Persistent Storage later.
1. [Connect to a local network](https://tails.net/doc/anonymous_internet/networkmanager/index.en.html#index1h1).
1. [Connect to Tor](https://tails.net/doc/anonymous_internet/tor/index.en.html) when the _Tor Connection_ window appears.
1. Open a terminal. Choose **Applications** ▸ **Utilities** ▸ **Terminal**.
1. Type or paste the following in Terminal, then press Enter:
    ```bash
    git clone https://github.com/benwestgate/bails&&bails/b
    ```
1. Follow the instructions on screen.

The command above executes code from the current GitHub repository checkout. Authenticated immutable CipherStick releases are tracked separately; until that work lands, repository/delivery compromise is part of the installation trust model.

## Distribution and cloning

CipherStick's automated clone and backup flows are unfinished and are not part of the supported workflow. Do not rely on the menu entries or older documentation as a secure distribution mechanism. A fresh-Tails handoff design is tracked separately.

# Support resources

For support and discussion join the [Telegram channel](https://t.me/bails_support).

For more reading see the [Frequently Asked Questions](docs/FAQ.md) and [Advantages and Disadvantages](docs/Advantages_and_Disadvantages.md).

To contact Ben Westgate by email: `benwestgate@protonmail.com`.

## Codex32 status

CipherStick currently contains a legacy experimental Codex32 wallet implementation. The supported replacement restoration path is being developed separately. Do not infer independent review or compatibility from the presence of Codex32 code in this repository.

## Source Code Headers

Every file containing source code must include copyright and license information. This includes any JS/CSS files that might be served to browsers.

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
