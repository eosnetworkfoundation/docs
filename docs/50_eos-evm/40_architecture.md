---
title: Architecture
---

## Overview

The EOS EVM implements as a smart contract which runs on the EOS network, we shall call it form this point forward the `EVM contract`. To send transactions to the EOS EVM network one has to send transactions to the EVM contract.

To achieve the complete RPC compatibility, a full functioning Ethereum node is utilized. The EOS EVM testnet and mainnet use an Ethereum node built on top of Silkworm node, we shall call it from this point forward the `EOS EVM node`.

The EOS EVM node builds its chain state from the information gathered from the EOS blockchain using the SHIP protocol, for example, the transactions sent to the EVM contract and processed by the EOS blockchain.

All the RPC requests, reads and writes, sent by the EOS EVM clients, are first processed by a proxy component, which redirects the requests to the corresponding processing components: the reads to the transaction wrapper service and the writes to the EOS EVM node.

### The Read Requests

All the API *read requests* are serviced through the EOS EVM node which uses a `Translator` service. The Translator service reads the consensus output from the EVM contract, translates that information into corresponding ETH format blocks, and feeds the blocks to the EOS EVM node. This way it is possible to expose the Ethereum client Web3 JSON RPC APIs and potentially other APIs if necessary.

### The Write Requests

All the *write requests* are forwarded to a service, named `Transaction Wrapper` (in the below diagram `Tx Wrapper`), which packs them into EOS actions and sends them to the EVM contract.

![Overall Design of the EOS EVM](./20_getting_started/resources/EOS-EVM_design_drawio.svg)

This architecture allows the possibility for other implementations of Ethereum nodes to be used if it is deemed necessary for some specific scenarios.
