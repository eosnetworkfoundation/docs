---
title: Architecture
---

## Overview

The EVM is implemented as a smart contract which runs on the EOS network, we shall call it form this point forward the `EVM contract`. To send transactions to the EOS EVM network one has send transactions to the EVM contract. The chain state of the EVM can be derived from the information obtained from the EOS blockchain.

To achieve the complete RPC compatibility, a full functioning Ethereum node is utilized. The EOS EVM testnet and mainnet use an Ethereum node built on top of Silkworm node, we shall call it from this point forward the `EOS EVM node`.

All the RPS requests, reads and writes, are first processed by a proxy component, which redirects the requests to the corresponding processing components.

### The Read Requests

All the API *read requests* are serviced through the EOS EVM node which then sends them to a `Translator` service, which is configured to read the consensus output from the EVM contract, translates that information into corresponding ETH format blocks, and feeds the blocks to the EOS EVM node. This way it is possible to expose the Ethereum client Web3 JSON RPC APIs and potentially other APIs if necessary.

### The Write Requests

All the *write requests* are forwarded to a small service, named `Transaction Wrapper` (in the below diagram `Tx Wrapper`), which packs them into EOS actions and sends them to the EVM contract.

![Overall Design of the EOS EVM](./20_getting_started/resources/EOS-EVM_design_drawio.svg)

This architecture allows the possibility for other implementations of Ethereum nodes to be used if it is deemed necessary for some specific scenarios.
