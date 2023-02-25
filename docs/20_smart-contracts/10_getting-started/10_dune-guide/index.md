---
title: DUNE Guide
---

## Overview

[DUNE](https://github.com/AntelopeIO/DUNE) (Docker Utilities for Node Execution) provides developers with a personal container for EOS blockchain management, smart contract development, and testing purposes.

In this guide you will learn to use DUNE for basic smart contract development. You will learn to:
* Launch a local EOS blockchain made of a single node
* Create a test account for smart contract deployment
* Develop and deploy a "Hello World" contract locally
* Test your "Hello World" contract by sending actions
* Check contract state by reading the table contents

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

> ℹ️ Node Bootstrapping  
Bootstrapping a node becomes necessary when either the system contracts must be deployed, or some functionality must be activated by a protocol feature. For simplicity, node bootstrapping will be showcased in another guide when required.

### Create Test Accounts

EOS accounts give ownership to stakeholders in an EOS blockchain. To deploy a smart contract, you need to create an EOS account to host it. Accounts also represent the actors that send actions to a smart contract. For more information about EOS accounts, visit the [Accounts](../20_accounts/index.md) guide.

> ℹ️ DUNE Account Creation  
DUNE simplifies account creation by abstracting key management. When an account gets created, DUNE also creates public/private key pairs for its two default permissions, `owner` and `active`. Therefore, if you use DUNE then key creation is not required during [Wallet Setup](#wallet-setup).

For this guide, you will create one test account, `hello`, which will be used to deploy your "Hello World" smart contract. Before proceeding, make sure you complete the previous section [Set Up EOS Node](#set-up-eos-node) to make sure your `first` node is up and running.

Create your contract account, `hello`, by executing the following command:

```shell
$ dune --create-account hello
```

The result should look similar to the following output, with different public/private key values:

```
Creating account [hello] with key pair [Private: 5KPKVDZyzJyb7hQF9g1y6KpJ8T2mjy8GYzroKpSCo9VMbJYLrZ6, Public: EOS6ye61vW3PgVfPC8L6t1yCe3EVdzGK9HqSs6a7vqasGb93CfvRL]
executed transaction: 5ad9d7db01a7fce7cfbaf8a911ee5b6e6dd2971faf50392e361af07c3954336f  200 bytes  100 us
warning: transaction executed locally, but may not be confirmed by the network yet         ]
```

Now that the account `hello` was created on the blockchain, you can inspect its contents by invoking the following command:

```shell
$ dune -- cleos get account hello
```

The result should be similar to:

```
created: 2023-02-17T22:46:47.000
permissions:
     owner     1:    1 EOS6ye61vW3PgVfPC8L6t1yCe3EVdzGK9HqSs6a7vqasGb93CfvRL
        active     1:    1 EOS6ye61vW3PgVfPC8L6t1yCe3EVdzGK9HqSs6a7vqasGb93CfvRL

permission links:
     eosio.any:

memory:
     quota:       unlimited  used:      2.66 KiB

net bandwidth:
     used:               unlimited
     available:          unlimited
     limit:              unlimited

cpu bandwidth:
     used:               unlimited
     available:          unlimited
     limit:              unlimited

subjective cpu bandwidth:
     used:                 0 us
```

Notice the account's creation date and time, the default permissions `owner` and `active`, their corresponding public keys, and default values for RAM, NET, and CPU resources. For more information about EOS resources, visit the [Resources](../30_resources/index.md) guide.

Now that your contract account has been created, you can build, deploy, and test your smart contract in the next section.

## Smart Contract Development

DUNE provides at least two commands to create smart contract projects:
* `create-bare-app`, for simple projects, using the compiler directly
* `create-cmake-app`, for larger projects, using `cmake` build system

Although a bare smart contract project makes more sense for single contract projects, in this guide you will create a `cmake` project that you will expand later. For larger projects involving multiple contracts and/or web applications, a `cmake` project makes more sense.

## Hello World Contract

These are the steps that you need to follow to create your "Hello World" smart contract:

[Step 1](#step-1---create-project) - Create new cmake smart contract project `hello`  
[Step 2](#step-2---write-contract) - Write the `hello` smart contract  
[Step 3](#step-3---compile-contract) - Compile the `hello` contract  
[Step 4](#step-4---deploy-contract) - Deploy the `hello` contract  

### Step 1 - Create Project

Create the cmake smart contract project `hello` in the current directory by running the following command:

```shell
dune --create-cmake-app hello .
```

The command will create the following file structure:

```shell
ls -l hello
```
```
-rw-r--r-- 1 lupaxel lupaxel  442 Feb 17 10:20 CMakeLists.txt
-rw-r--r-- 1 lupaxel lupaxel  462 Feb 17 10:20 README.txt
drwxr-x--- 1 lupaxel lupaxel 4096 Feb 17 10:20 build
drwxr-x--- 1 lupaxel lupaxel 4096 Feb 17 10:20 include
drwxr-x--- 1 lupaxel lupaxel 4096 Feb 17 10:20 ricardian
drwxr-x--- 1 lupaxel lupaxel 4096 Feb 17 10:20 src
```

```shell
ls -l hello/src
```
```
-rw-r--r-- 1 lupaxel lupaxel 215 Feb 17 10:20 CMakeLists.txt
-rw-r--r-- 1 lupaxel lupaxel 110 Feb 17 10:20 hello.cpp
```

Now you will modify the source file `hello.cpp` to implement your contract.

### Step 2 - Write Contract

Enter the `hello` project main directory:

```shell
cd hello
```

Open the `hello` project directory in your code editor or IDE of choice - in this guide we will use the Visual Studio (VS) Code editor:

```shell
code .
```

Open the `include/hello.cpp` C++ source file, type or copy/paste the following code, replacing its contents, then save the file:

```cpp
#include <eosio/eosio.hpp>

using namespace eosio;

CONTRACT hello : public contract {
   public:
      using contract::contract;

      TABLE user_record {
         name user;
         uint64_t primary_key() const { return user.value; }
      };
      typedef eosio::multi_index< name("users"), user_record> user_index;

      ACTION world( name user ) {
         print_f("Hello World from %!\n", user);
         user_index users( get_self(), get_self().value );
         users.emplace( get_self(), [&]( auto& new_record ) {
            new_record.user = user;
         });
      }
};
```

The code above defines the main class where your contract is implemented and one action which displays a message about the specified user. The contract also defines a table which will be explained later.

Now you will compile the `hello` contract.

### Step 3 - Compile Contract

Compile the `hello` contract by running the following command:

```shell
dune --cmake-build .
```

The result looks similar to:

```
-- Configuring done
-- Generating done
-- Build files have been written to: /host/home/lupaxel/work/contracts/hello/build
[ 11%] Performing build step for 'hello_project'
Scanning dependencies of target hello
[ 50%] Building CXX object CMakeFiles/hello.dir/hello.obj
Warning, empty ricardian clause file
[100%] Linking CXX executable hello.wasm
[100%] Built target hello
[ 22%] No install step for 'hello_project'
[ 33%] No test step for 'hello_project'
[ 44%] Completed 'hello_project'
[100%] Built target hello_project
```

Now you will deploy the contract.

### Step 4 - Deploy Contract

Run the following command to deploy your `hello` contract:

```shell
dune --deploy ./build/hello hello
```

The command will deploy the compiled contract residing at `./build/hello` to account `hello`:

```
#         eosio <= eosio::setcode               {"account":"hello","vmtype":0,"vmversion":0,"code":"0061736d0100000001410d60017e0060017f0060027f7f00...
#         eosio <= eosio::setabi                {"account":"hello","abi":"0e656f73696f3a3a6162692f312e3200010268690001026e6d046e616d6501000000000000...
```

You can check that the contract was indeed deployed by running the following command:

```shell
dune -- cleos get code hello
```

The command sends the account name, `hello`, where the contract was deployed, and returns the hash of the contract if deployed successfully:

```
code hash: ab8455aa1b46e5129b5ff40192de47a5d17587498a452c9c482e39f556270e55
```

The code hash is important as it changes when the contract code changes. The deployment mechanism uses this information to re-deploy the contract if needed. If the compiled contract code does not change, the contract is not re-deployed to save on [resources](../30_resources/index.md).

If the code hash is zero, as below, then there is no contract deployed on that account yet:

```
code hash: 0000000000000000000000000000000000000000000000000000000000000000
```

Once the contract is deployed successfully, you can proceed to test your smart contract.

## Test Your Smart Contract

You can use DUNE to start testing your smart contract locally first. Later on, you should test your contract on an EOS testnet, and eventually on the real EOS mainnet.

To test your smart contract, you typically send actions to it. Then you inspect the node's response to those actions and their effect on the blockchain state, if applicable.

### Send Actions

In the `hello` contract, there is only one `world` action that receives an EOS name as a parameter. To test your contract, you need to send the `world` action to your contract with an EOS name as argument:

```shell
dune --send-action hello world '[bob]' hello@active
```

The node returns the following response:

```
executed transaction: 8594b978e913356d75306ee21c7f319080887c1431cc6efb16740941f434d578  104 bytes  100 us
warning: transaction executed locally, but may not be confirmed by the network yet         ]
#         hello <= hello::world                 {"user":"bob"}
>> Hello World from bob!
```

Note that the response indicates that the `world` action was executed with the `bob` argument passed to the `user` parameter, and the action displayed the message correctly.

You can pass different names to the action - just make sure they are unique:

```shell
dune --send-action hello world '[alice]' hello@active
```
```
executed transaction: c439721576b38f68714a606fbfd150e7a3e870bd71361804b7098a3aabce5eeb  104 bytes  114 us
warning: transaction executed locally, but may not be confirmed by the network yet         ]
#         hello <= hello::world                 {"user":"alice"}
>> Hello World from alice!
```

Note that if you try to add the same `user` twice, the action will fail since it has to be unique.

### Get Table Data

In your `hello` contract above, the `world` action displays a message using a specified `user` name. However, the contract does more under the hood:
* the contract defines a table with one name field.
* the action creates a new user record on that table.

This adds the ability to keep or persist contract state on the blockchain. Now that you have a table and the ability to create new records in it, you just need to read, update, and delete records to have full CRUD functionality. It all depends on the business rules that you need to implement within your contract.

To view the entire table state, invoke the following command:

```shell
dune --get-table hello hello users
```

The result displays the contents of the `users` table within the `hello` contract deployed in the `hello` account:

```
{
  "rows": [{
      "user": "bob"
    },{
      "user": "alice"
    }
  ],
  "more": false,
  "next_key": ""
}
```

If you want to perform more advanced table queries, you can use the `dune -- cleos get table` command which provides more options.

## Summary

In this guide you learned how to use DUNE for basic smart contract development. In particular, you launched a local EOS blockchain consisting of a single node, created a test account for smart contract deployment, developed and deployed a "Hello World" contract locally, tested your contract by sending actions, and finally checked its state by reading the table contents.
