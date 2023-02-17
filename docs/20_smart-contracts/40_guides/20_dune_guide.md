---
title: DUNE Guide
---

## Overview

Docker Utilities for Node Execution (DUNE) is a client tool for blockchain developers and node operators to perform tasks related to smart contract development and node management functions. In particular, DUNE allows to:
* Build, deploy, and test smart contracts
* Start, initialize, and stop EOS nodes
* Send actions to smart contracts
* Retrieve data from smart contracts
* Perform other node management operations

DUNE simplifies blockchain software setup by isolating the EOS software and its dependencies from the host system. It allows developers and operators to experiment with the EOS blockchain and perform boilerplate operations in a safe sandbox using a Docker container.

## Installation

DUNE can be installed and run on the following platforms:
* Linux
* Windows
* MacOS

Installation instructions for each supported plaftorm are available below.

### Dependencies

DUNE requires the following software dependencies to be installed on all supported plaftorms:
* Python 3: https://www.python.org/downloads/
* Docker: https://docs.docker.com/get-docker/

Follow the instructions provided on the above links to install these software dependencies.

### Linux

### Windows

## Wallet Setup

An EOS wallet stores development and account keys that are required to sign messages and transactions sent to the blockchain. Your EOS wallet usually resides near your local system, so you can create and interact with your wallet before launching your EOS blockchain, if needed.

> ℹ️ DUNE wallet management ℹ️  
DUNE creates a default wallet when first installed. This simplifies wallet setup or eliminates it altogether, unless you name your wallet explicitly. To take advantage of DUNE's automatic wallet management, it is recommended that you use the default wallet.

To view all wallets, execute this command:

```shell
$ dune -- cleos wallet list
```

The command displays a wallet named `default` in a locked (*) state:

```
Wallets:
[
  "default *"
]
```

During node setup, DUNE will create an EOS development key to bootstrap your EOS blockchain. Later on, to create your test account on the blockchain, you will create a key pair in your wallet and associate the public key with your account.

## Node Setup

### Set Up EOS Node

### Create Test Accounts

## Smart Contract Development

## Hello World Contract - Singleton version

### Compile Contract

### Deploy Contract

## Smart Contract Testing

### Send Actions

### Get Table Data

## Summary
