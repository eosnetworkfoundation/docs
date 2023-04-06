---
title: Architecture
---

## Overview

The EVM is implemented as a smart contract on the EOS network. Generating transactions in the EVM network is done via calls to the EVM contract on the EOS network. Chain state of the EVM can be derived from the information on EOS.

To achieve the goal of full RPC compatibility, a full functioning Ethereum node is utilized. This allows to provide all the read APIs while all write requests are forwarded to a small service which packs them into EOS calls to the EVM contract.

![Overall Design of the EOS EVM](./20_getting_started/resources/EOS-EVM_design_drawio.svg)

A "Translator" service is configured to read the consensus output from the EVM smart contract running on EOS, translates that information into corresponding ETH format blocks, and feeds the blocks to the Silkworm node. This way it is possible to expose the Ethereum client Web3 JSON RPC APIs and potentially other APIs if necessary.

This architecture allows the possibility for other implementations of Ethereum nodes to be used if it is deemed necessary for some specific scenarios.
