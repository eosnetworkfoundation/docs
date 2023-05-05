---
title: Protocol Guides
---

## Core

The `EOS Core` provides the basic building blocks for the `system` layer. However, since they are not implemented as smart contracts, they do not provide the same level of flexibility. Nevertheless, the `core` implementation is also open source, and thus it can be modified to suit custom business requirements.

The core protocols are:

1. [Consensus Protocol](01_consensus_protocol.md)
2. [Transactions Protocol](02_transactions_protocol.md)
3. [Network or Peer to Peer Protocol](03_network_peer_protocol.md)

## System

The EOS blockchain is unique in that the features and characteristics of the blockchain built on it are flexible, that is, they can be changed or be modified completely to suit each business case requirement. Core blockchain features such as consensus, fee schedules, account creation and modification, token economics, block producer registration, voting, multi-sig, etc., are implemented inside smart contracts which are deployed on the blockchain built on the EOS blockchain. These smart contracts are referred to as `system contracts` and the layer as the `EOS system` layer, or simply the `system` layer.

The EOS Network Foundation implements and maintains these `system contracts` as reference implementations only, encapsulating the base functionality for an EOS-based blockchain. The `system contracts` are listed below:

1. [eosio.bios](https://docs.eosnetwork.com/system-contracts/latest/reference/Classes/classeosiobios_1_1bios)
2. [eosio.system](https://docs.eosnetwork.com/system-contracts/latest/reference/Classes/classeosiosystem_1_1system__contract)
3. [eosio.msig](https://docs.eosnetwork.com/system-contracts/latest/reference/Classes/classeosio_1_1multisig)
4. [eosio.token](https://docs.eosnetwork.com/system-contracts/latest/reference/Classes/classeosio_1_1token)
5. [eosio.wrap](https://docs.eosnetwork.com/system-contracts/latest/reference/Classes/classeosio_1_1wrap)
