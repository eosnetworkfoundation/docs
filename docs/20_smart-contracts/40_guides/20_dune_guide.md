---
title: DUNE Guide
---

## Overview

In this guide you will learn to use DUNE for basic smart contract development. You will learn to:
* Launch a local EOS blockchain consisting of a single node
* Create test accounts for smart contract deployment and use
* Develop and deploy the Hello World contract (singleton version)
* Test your Hello World contract and get table information

Before getting started with smart contract development, you need to learn about DUNE and how to install it on your platform.

## DUNE

Docker Utilities for Node Execution (DUNE) is a client tool that allows blockchain developers and node operators to perform boilerplate tasks related to smart contract development and node management functions. In particular, DUNE allows to:
* Start, initialize, and stop EOS nodes
* Build, deploy, and test smart contracts
* Send actions to smart contracts
* Retrieve data from smart contracts
* Perform other node management operations

> ℹ️ DUNE concept  
DUNE simplifies blockchain software setup by isolating the EOS software and its dependencies from the host system. This allows developers and operators to experiment with the EOS blockchain, try proof-of-concepts, and perform scaffolding in a safe sandbox using a Docker container.

### Installation

DUNE can be installed and run on the following platforms:
* Linux
* Windows
* MacOS

Installation instructions for each supported plaftorm are available on the [DUNE's github project](https://github.com/AntelopeIO/DUNE) page.

## Wallet Setup

An EOS wallet stores development and account keys that are required to sign messages and also transactions sent to the blockchain. Your EOS wallet works independently from the blockchain, so you can create and interact with your wallet before or after launching your EOS blockchain, if needed.

> ℹ️ DUNE wallet management  
DUNE creates a default wallet when first installed. This simplifies wallet setup or eliminates it altogether, unless you want to name your wallet explicitly. To take advantage of DUNE's automatic wallet management, it is recommended that you use the default wallet.

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

If DUNE requires to access the wallet for some reason, e.g. to sign a transaction, it will unlock the wallet automatically for you as long as you are using the default wallet. Therefore, there is no further wallet setup required in DUNE.

## Node Setup

An EOS blockchain operates through a network of interconnected nodes. EOS nodes can be set up to serve one or more roles, such as a validating transactions, producing blocks, serving RPC API requests, etc.

In this section, you will set up your own EOS blockchain consisting of a single API/producer node. This will allow you to deploy a smart contract to your EOS blockchain later on, and perform tests on it.

### Set Up EOS Node

DUNE simplifies node creation and setup. To start a node called `first` execute the following command:

```shell
$ dune --start first
```

The command launches the node with default settings, initializes it as an API/producer node, and begins to produce blocks:

```
Creating node [first]
Using Configuration [/app/config.ini]

Active [first]
...
info  nodeos    chain_plugin.cpp:657          plugin_initialize    ] initializing chain plugin
info  nodeos    chain_plugin.cpp:466          operator()           ] Support for builtin protocol feature 'GET_BLOCK_NUM' (with digest of '35c2186cc36f7bb4aeaf4487b36e57039ccf45a9136aa856a5d569ecca55ef2b') is enabled with preactivation required
info  nodeos    chain_plugin.cpp:574          operator()           ] Saved default specification for builtin protocol feature 'GET_BLOCK_NUM' (with digest of '35c2186cc36f7bb4aeaf4487b36e57039ccf45a9136aa856a5d569ecca55ef2b') to: /app/nodes/first/protocol_features/BUILTIN-GET_BLOCK_NUM.json
info  nodeos    chain_plugin.cpp:466          operator()           ] Support for builtin protocol feature 'CRYPTO_PRIMITIVES' (with digest of '6bcb40a24e49c26d0a60513b6aeb8551d264e4717f306b81a37a5afb3b47cedc') is enabled with preactivation required
info  nodeos    chain_plugin.cpp:574          operator()           ] Saved default specification for builtin protocol feature 'CRYPTO_PRIMITIVES' (with digest of '6bcb40a24e49c26d0a60513b6aeb8551d264e4717f306b81a37a5afb3b47cedc') to: /app/nodes/first/protocol_features/BUILTIN-CRYPTO_PRIMITIVES.json
...
info  nodeos    main.cpp:142                  main                 ] nodeos version v3.2.1 v3.2.1-3f9cb99e068da8581036d212d74fb56144ef0fc4
info  nodeos    main.cpp:143                  main                 ] nodeos using configuration file /app/nodes/first/config.ini
info  nodeos    main.cpp:144                  main                 ] nodeos data directory is /app/nodes/first
warn  nodeos    controller.cpp:605            startup              ] No existing chain state or fork database. Initializing fresh blockchain state and resetting fork database.
warn  nodeos    controller.cpp:457            initialize_blockchai ] Initializing new blockchain with genesis state
info  nodeos    controller.cpp:530            replay               ] no irreversible blocks need to be replayed
info  nodeos    controller.cpp:543            replay               ] 0 reversible blocks replayed
info  nodeos    controller.cpp:553            replay               ] replayed 0 blocks in 0 seconds, 0.00000000000488944 ms/block
info  nodeos    chain_plugin.cpp:1285         plugin_startup       ] starting chain in read/write mode
info  nodeos    chain_plugin.cpp:1290         plugin_startup       ] Blockchain started; head block is #1, genesis timestamp is 2018-06-01T12:00:00.000
info  nodeos    chain_api_plugin.cpp:98       plugin_startup       ] starting chain_api_plugin
info  nodeos    http_plugin.cpp:483           add_handler          ] add api url: /v1/chain/get_info
...
info  nodeos    http_plugin.cpp:483           add_handler          ] add api url: /v1/chain/send_transaction2
info  nodeos    producer_plugin.cpp:1001      plugin_startup       ] producer plugin:  plugin_startup() begin
info  nodeos    producer_plugin.cpp:1029      plugin_startup       ] Launching block production for 1 producers at 2023-02-17T00:16:44.428.
info  nodeos    producer_plugin.cpp:1040      plugin_startup       ] producer plugin:  plugin_startup() end
info  nodeos    producer_api_plugin.cp:92     plugin_startup       ] starting producer_api_plugin
info  nodeos    http_plugin.cpp:483           add_handler          ] add api url: /v1/producer/add_greylist_accounts
...
info  nodeos    http_plugin.cpp:483           add_handler          ] add api url: /v1/producer/update_runtime_options
info  nodeos    net_plugin.cpp:3704           plugin_startup       ] my node_id is 2a6f1f2f2e27be40667a38a10cf572568b2b73e1514e122ec92a5b49368a5231
info  nodeos    resource_monitor_plugi:94     plugin_startup       ] Creating and starting monitor thread
info  nodeos    file_space_handler.hpp:113    add_file_system      ] /app/nodes/first/blocks's file system monitored. shutdown_available: 108110117680, capacity: 1081101176832, threshold: 90
info  nodeos    net_plugin.cpp:3782           operator()           ] starting listener, max clients is 25
info  nodeos    http_plugin.cpp:178           create_beast_server  ] created beast HTTP listener
info  nodeos    http_plugin.cpp:381           operator()           ] start listening for http requests (boost::beast)
info  nodeos    beast_http_listener.hp:79     listen               ] acceptor_.listen()
info  nodeos    http_plugin.cpp:483           add_handler          ] add api url: /v1/node/get_supported_apis
info  nodeos    producer_plugin.cpp:2534      produce_block        ] Produced block 014cab9772843d57... #2 @ 2023-02-17T00:16:44.500 signed by eosio [trxs: 0, lib: 1, confirmed: 0, net: 0, cpu: 100, elapsed: 20, time: 253]
info  nodeos    producer_plugin.cpp:2534      produce_block        ] Produced block 1acdb1044c3362cd... #3 @ 2023-02-17T00:16:45.000 signed by eosio [trxs: 0, lib: 2, confirmed: 0, net: 0, cpu: 100, elapsed: 12, time: 311]
info  nodeos    producer_plugin.cpp:2534      produce_block        ] Produced block 834ad8dc1f031c7c... #4 @ 2023-02-17T00:16:45.500 signed by eosio [trxs: 0, lib: 3, confirmed: 0, net: 0, cpu: 100, elapsed: 11, time: 365]
info  nodeos    producer_plugin.cpp:2534      produce_block        ] Produced block 0639c4bbfb3b05a4... #5 @ 2023-02-17T00:16:46.000 signed by eosio [trxs: 0, lib: 4, confirmed: 0, net: 0, cpu: 100, elapsed: 15, time: 336]
...
```

You can check that indeed the node is active and running by invoking the following command:

```shell
$ dune --list
```

The result lists all nodes created on the container, whether active or running, and their assigned ports:

```
Node Name   | Active? | Running? | HTTP           | P2P          | SHiP
---------------------------------------------------------------------------------
first       |    Y    |    Y     | 127.0.0.1:8888 | 0.0.0.0:9876 | 127.0.0.1:8080
```

You can also check that the node is listening to RPC API requests by running the following command:

```shell
$ dune -- cleos get info
```

The command returns information about the local EOS blockchain just launched:

```json
{
  "server_version": "3f9cb99e",
  "chain_id": "8a34ec7df1b8cd06ff4a8abbaa7cc50300823350cadc59ab296cb00d104d2b8f",
  "head_block_num": 42987,
  "last_irreversible_block_num": 42986,
  "last_irreversible_block_id": "0000a7eac208ba842a890f28f8afa26a692760f1d824f618168f0bafa54ed28f",
  "head_block_id": "0000a7ebb0dd4e78c5283ec67eb01a803673e23f77c57dee2733e1a170418dd9",
  "head_block_time": "2023-02-17T06:14:57.000",
  "head_block_producer": "eosio",
  "virtual_block_cpu_limit": 200000000,
  "virtual_block_net_limit": 1048576000,
  "block_cpu_limit": 199900,
  "block_net_limit": 1048576,
  "server_version_string": "v3.2.1",
  "fork_db_head_block_num": 42987,
  "fork_db_head_block_id": "0000a7ebb0dd4e78c5283ec67eb01a803673e23f77c57dee2733e1a170418dd9",
  "server_full_version_string": "v3.2.1-3f9cb99e068da8581036d212d74fb56144ef0fc4",
  "total_cpu_weight": 0,
  "total_net_weight": 0,
  "earliest_available_block_num": 1,
  "last_irreversible_block_time": "2023-02-17T06:14:56.500"
}
```

You can also check the `get_info` endpoint directly exposed by the `chain_api_plugin` in your browser:

```shell
http://localhost:8888/v1/chain/get_info
```

Or you can use `curl` or `wget` to send an HTTP GET request directly:

```shell
curl http://localhost:8888/v1/chain/get_info
```

In both cases, the result is similar to the JSON output above.

> ℹ️ Node Bootstrapping  
Bootstrapping a node becomes necessary when either the system contracts must be deployed, or some functionality must be activated by a protocol feature. For simplicitly, node bootstrapping will be showcased in another guide when required.

### Create Test Accounts

## Smart Contract Development

## Hello World Contract - Singleton version

### Compile Contract

### Deploy Contract

## Smart Contract Testing

### Send Actions

### Get Table Data

## Summary
