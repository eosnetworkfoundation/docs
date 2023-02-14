---
title: Architecture
---

## Overview

The EVM is implemented as a smart contract in the EOS network. Generating transaction in the EVM network is done via calling into the EVM contract on EOS network and the states of the EVM can be derived from the information on EOS.

To achieve our goal of full RPC compatibility, we utilize a full functioning ethereum node (Geth in current design) to provide all the read APIs while all write access will be forwarded to a small service to pack them into EOS calls to the EVM contract.

![Overall Design of the Trust EVM](./resources/EOS-EVM_design_drawio.svg)

What we do is setting up a "Translator" service that reads the consensus output from the EVM smart contract running on EOS, translate that information into corresponding ETH format blocks and feed the blocks to the Geth node. Then we can expose the Ethereum client Web3 JSON RPC APIs (and potentially other APIs if necessary).

We may also use other implementations of Ethereum nodes in different scenarios if we found them better fit the case.

## Future Improvement

The current design is working and providing anticipated compatibility level. There's still some potential ways to improve the whole system:

* Merging the Translator service and Geth node to remove the relatively unreliable p2p eth/66 channel.
* Merging everything into an EOS plugin for easy deployments.
