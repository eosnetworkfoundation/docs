---
title: Architecture
---

## Overview

The EVM is implemented as a smart contract on the EOS network, we shall call it form this point forward the EOS EVM contract. Generating transactions in the EOS EVM network is done via calls to the EOS EVM contract. The chain state of the EVM can be derived from the information obtain from the EOS blockchain.

To achieve the full RPC compatibility, a full functioning Ethereum node is utilized. The EOS EVM testnet and mainnet use an Ethereum node built on top of Silkworm node, we shall call it from this point forward the EOS EVM node. All the API *read requests* are serviced through the EOS EVM node while all the *write requests* are forwarded to a small service which packs them into EOS actions sen to the EOS EVM contract.

![Overall Design of the EOS EVM](./20_getting_started/resources/EOS-EVM_design_drawio.svg)

A `Translator` service is configured to read the consensus output from the EOS EVM contract, translates that information into corresponding ETH format blocks, and feeds the blocks to the EOS EVM node. This way it is possible to expose the Ethereum client Web3 JSON RPC APIs and potentially other APIs if necessary.

This architecture allows the possibility for other implementations of Ethereum nodes to be used if it is deemed necessary for some specific scenarios.
