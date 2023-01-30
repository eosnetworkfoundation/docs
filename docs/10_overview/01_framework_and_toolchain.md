---
title: EOS Toolchain
---

The EOS blockchain is made up of the following components and toolchain:

1. `nodeos`:  the core EOS node daemon that can be configured with plugins to run a node. Example uses are block production, dedicated API endpoints, and local development.
2. `cleos`: the command line interface to interact with the blockchain and to manage wallets.
3. `keosd`: the component that securely stores EOS keys in wallets.
4. `CDT`: the Contract Development Toolkit is a C/C++ toolchain targeting WebAssembly (WASM) and a set of tools to facilitate development of smart contracts written in C/C++ that are meant to be deployed to the EOS blockchain..

The basic relationship between these components is illustrated in the following diagram:

![EOS Development Lifecycle](/docs/images/overview-EOS-Overview-dev.png)

[[info | Note]]
| EOS also provides a frontend library for javascript development called EOSJS along with Swift and Java SDKs for native mobile applications development.

## Nodeos

Nodeos is the core EOS node daemon. Nodeos handles the blockchain data persistence layer, peer-to-peer networking, and contract code scheduling. For development environments, nodeos enables you to set up a single node blockchain network. Nodeos offers a wide range of features through plugins which can be enabled or disabled at start time via the command line parameters or configuration files.

You can read detailed documentation about `nodeos` [here](http://docs.eosnetwork.com/eosdocs/developer-tools/nodeos/).
<!-- The link will be updated once the initial site is live -->

## Cleos

`cleos` is a command line tool that interfaces with the REST APIs exposed by `nodeos`. You can also use `cleos` to deploy and test EOS smart contracts.

You can read detailed documentation about `cleos` [here](http://docs.eosnetwork.com/eosdocs/developer-tools/cleos/).
<!-- The link will be updated once the initial site is live -->

## Keosd

`keosd` is a key manager daemon for storing private keys and signing digital messages. `keosd` provides a secure key storage medium for keys to be encrypted in the associated wallet file. The `keosd` daemon also defines a secure enclave for signing transaction created by `cleos` or a third party library.


[[info | Note]]
| `keosd` can be accessed using the wallet API, but it is important to note that the intended usage is for local light client applications. `keosd` is not for cross network access by web applications trying to access users' wallets.

You can read detailed documentation about `keosd` [here](http://docs.eosnetwork.com/eosdocs/developer-tools/keosd/).
<!-- The link will be updated once the initial site is live -->

## CDT

CDT is a toolchain for WebAssembly (Wasm) and a set of tools to facilitate contract writing for the EOS blockchain. In addition to being a general-purpose WebAssembly toolchain, EOS-specific optimizations are available to support building EOS smart contracts. This new toolchain is built around Clang 7, which means that CDT has most of the current optimizations and analyses from LLVM.

You can read more about `CDT` [here](https://github.com/AntelopeIO/cdt).

## EOSJS

A Javascript API SDK for integration with the EOS blockchain using the EOS RPC API.

## What's Next?

- [Core Concepts](02_core_concepts.md): Learn about EOS' core concepts
