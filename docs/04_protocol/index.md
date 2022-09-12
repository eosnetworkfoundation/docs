# Antelope Protocol

## Core

`Antelope Core` provides the basic building blocks for the `system` layer and because they are not implemented as smart contracts they do not provide the same level of flexibility. Nevertheless, the `core` implementation is also open source and thus it can be modified as well to suit custom business requirements.

The core protocols are:

1. [Consensus Protocol](01_consensus_protocol.md)
2. [Transactions Protocol](02_transactions_protocol.md)
3. [Network or Peer to Peer Protocol](03_network_peer_protocol.md)
4. [Accounts and Permissions](04_accounts_and_permissions.md)

## System

The Antelope blockchain platform is unique in that the features and characteristics of the blockchain built on it are flexible, that is, they can be changed, or be modified completely to suit each business case requirement. Core blockchain features such as consensus, fee schedules, account creation and modification, token economics, block producer registration, voting, multi-sig, etc., are implemented inside smart contracts which are deployed on the blockchain built on the Antelope platform. These smart contracts are referred to as `system contracts` and the layer as the `Antelope system` layer, or simply `system` layer.

EOS Network Foundation implements and maintains these `system contracts`, as samples only, encapsulating the base functionality for an Antelope based blockchain and they are listed below:

1. [eosio.bios](action-reference/eosio.bios)
2. [eosio.system](action-reference/eosio.system)
3. [eosio.msig](action-reference/eosio.msig)
4. [eosio.token](action-reference/eosio.token)
5. [eosio.wrap](action-reference/eosio.wrap)

Also part of the `system` layer are the following concepts:

1. [Account](/glossary.md#account)
2. [RAM](/glossary.md#ram)
3. [CPU](/glossary.md#cpu)
4. [NET](/glossary.md#net)
