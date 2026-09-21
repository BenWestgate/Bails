# CipherStick: Current Properties and Limits

CipherStick is experimental setup automation for Bitcoin Core on Tails. Its security properties come from the specific Tails and Bitcoin Core behavior it configures, not from a general guarantee.

## What it does

- Installs Bitcoin Core and configures it to use Tails Persistent Storage.
- Uses Tails' Tor-based network configuration for supported network traffic.
- Checks downloaded Bitcoin Core release artifacts before installation.
- Configures local block pruning when storage is limited.
- Provides spaced-repetition prompts for the Persistent Storage passphrase.

## What it does not do

- Create, restore, back up, or otherwise manage wallet private keys.
- Guarantee anonymity, censorship resistance, confiscation resistance, or recovery of lost secrets.
- Eliminate risks from compromised hardware, firmware, an unlocked Tails session, malicious peripherals, or user error.
- Make initial Bitcoin Core synchronization fast; it can take hours or days.
- Support automatic cloning, backup USB creation, offline signing, multisignature coordination, or Codex32 wallet restoration.

## Practical limits

Tails encrypts selected persistent data at rest, but an unlocked session can expose its data. Tor reduces direct network-location exposure, but transaction analysis, counterparties, and compromised services can still reveal information. Bitcoin Core validates the rules of the network locally, but cannot prevent loss or theft caused by compromised keys or endpoints.

CipherStick is alpha software and has not received an independent security audit. Read the upstream Tails and Bitcoin Core documentation before using it with funds.
