---
title: DUNE Guide
---

## Overview

Try EOS in [DUNE](https://github.com/AntelopeIO/DUNE) (Docker Utilities for Node Execution) if you do not want to install EOS binaries or have other types of installation restrictions. This approach, powered by Docker, provides developers with a personal container for the EOS blockchain management, smart contract development, and testing purposes.

In this guide you will learn to use DUNE for basic smart contract development. You will learn to:
* Launch a local EOS blockchain consisting of a single node
* Create test accounts for smart contract deployment and use
* Develop and deploy the Hello World contract locally
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

EOS accounts give ownership to stakeholders in an EOS blockchain. To deploy a smart contract, you need to create an EOS account to host it. Accounts also represent the actors that send actions to a smart contract. For more information about EOS accounts, visit the [Accounts](../20_accounts/index.md) guide.

> ℹ️ DUNE Account Creation  
DUNE simplifies account creation by abstracting key management. When an account gets created, DUNE also creates public/private key pairs for its two default permissions, `owner` and `active`. Therefore, if you use DUNE then key creation is not required during [Wallet Setup](#wallet-setup).

For this guide, you will create three accounts: `hello`, then `bob` and `alice`. The first account, `hello`, will be used in this guide to deploy your `Hello World` smart contract. The last two, `bob` and `alice`, are test accounts to be used in later guides.

First, make sure your `first` node is up and running:

```shell
$ dune --list
```

If your node shows an `X` or `N` on the *Running* column, visit the [Node Setup](#node-setup) section again and follow the instructions to start your node:

```
Node Name   | Active? | Running? | HTTP           | P2P          | SHiP
---------------------------------------------------------------------------------
first       |    Y    |    Y     | 127.0.0.1:8888 | 0.0.0.0:9876 | 127.0.0.1:8080
```

Create your contract account, `hello`, by executing the following DUNE command:

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

Notice the account's creation date and time, the default permissions `owner` and `active`, their corresponding public keys, and default values for RAM, NET, and CPU resources. For more information about EOS resources, visit the [Resources guide](../30_resources/index.md) guide.

Finally, create two test accounts, `bob` and `alice` by executing the following DUNE commands:

```shell
$ dune --create-account bob
$ dune --create-account alice
```

Now that your contract account has been created, you can build, deploy, and test your smart contract in the next section.

## Smart Contract Development

DUNE provides at least two commands to create smart contract projects:
* `create-bare-app`, for simple projects, invoking `cdt` directly
* `create-cmake-app`, for larger projects, using `cmake` builds

Although a bare smart contract project makes more sense for single contract projects, for this guide you will create a cmake project that you will expand. For larger projects involving multiple contracts and/or web applications, a cmake project makes more sense.

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

Open the `hello` project folder in your code editor or IDE of choice:

```shell
code .
```

Open the `include/hello.cpp` C++ source file, type the following, then save the file:

```cpp
#include <eosio/eosio.hpp>

using namespace eosio;

CONTRACT hello : public contract {
   public:
      using contract::contract;

      ACTION world( name user ) {
         print_f("Hello World from %!\n", user);
      }
};
```

The code above defines the `hello` contract class derived from the `eosio::contract` parent class. Then it defines the `world` action, which simply displays a message using the EOS name argument passed in the `user` parameter. Note the usage of macros CONTRACT and ACTION to simplify the C++ syntax. Also note that we are not implementing the `hello.hpp` C++ header file nor now.

Now you will compile the `hello` contract.

### Step 3 - Compile Contract

Compile the `hello` contract by running the following command:

```shell
dune --cmake-build .
```

The result looks similar to:

```
-- The C compiler identification is GNU 9.4.0
-- The CXX compiler identification is GNU 9.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /host/home/lupaxel/work/contracts/hello/build
Scanning dependencies of target hello_project
[ 11%] Creating directories for 'hello_project'
[ 22%] No download step for 'hello_project'
[ 33%] No patch step for 'hello_project'
[ 44%] No update step for 'hello_project'
[ 55%] Performing configure step for 'hello_project'
-- Setting up CDT Wasm Toolchain 3.1.0 at /usr
-- Setting up CDT Wasm Toolchain 3.1.0 at /usr
-- The C compiler identification is Clang 9.0.1
-- The CXX compiler identification is Clang 9.0.1
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - failed
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - failed
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /host/home/lupaxel/work/contracts/hello/build/hello
[ 66%] Performing build step for 'hello_project'
Scanning dependencies of target hello
[ 50%] Building CXX object CMakeFiles/hello.dir/hello.obj
Warning, empty ricardian clause file
[100%] Linking CXX executable hello.wasm
[100%] Built target hello
[ 77%] No install step for 'hello_project'
[ 88%] No test step for 'hello_project'
[100%] Completed 'hello_project'
[100%] Built target hello_project
```

Now you will deploy the contract.

### Step 4 - Deploy Contract

Run the following command to deploy your `hello` contract:

```shell
dune --deploy build/hello hello
```

The command will deploy the compiled contract residing at `build/hello` to account `hello`:

```
#         eosio <= eosio::setcode               {"account":"hello","vmtype":0,"vmversion":0,"code":"0061736d0100000001410d60017e0060017f0060027f7f00...
#         eosio <= eosio::setabi                {"account":"hello","abi":"0e656f73696f3a3a6162692f312e3200010268690001026e6d046e616d6501000000000000...
```

You can check that the contract was indeed deployed by running the following command:

```shell
dune -- cleos get code hello
```

The command sends the name of code account, `hello`, where the contract was deployed, to the `get_code` endpoint, which replies with the hash of the deployed contract:

```
code hash: 2737de70263c4ac5ac8e04760e5d7426a8d7c9a1680f2bcc3e44354185badc34
```

If the code hash is non-zero, as above, then the contract was deployed successfully. You can now test your smart contract.

## Smart Contract Testing

You can use DUNE to start testing your smart contract locally first. Later on, you should test your contract on an EOS testnet, and eventually on the real EOS mainnet.

To test your smart contract, you typically send actions to it. Then you inspect the endpoint response to those actions and their effect on the blockchain state, if applicable.

### Send Actions

In the `hello` contract, there is only one `world` action that receives an EOS name as a parameter. To test the contract, you need to send the `world` action to your contract with an appropriate argument.

To that end, specify the `hello` account and send the action `world` with your name ("john" in the example below) as argument - note that you must use lowercase and abide by the EOS account name rules:

```shell
dune --send-action hello world '[john]' hello@active
```

The endpoint returns the following response:

```
executed transaction: 8594b978e913356d75306ee21c7f319080887c1431cc6efb16740941f434d578  104 bytes  100 us
warning: transaction executed locally, but may not be confirmed by the network yet         ]
#         hello <= hello::world                 {"user":"john"}
>> Hello World from john!
```

Note that the response indicates that the `hello::world` action was executed with the `john` argument passed to the `user` parameter, and the action displayed the message correctly.

### Create Table

In your first `hello` contract, you invoked the `world` action and passed a name as argument. However, the contract cannot store any names yet, since it does not have state or persistence.

To add persistence to your contract, you need to create multi-index tables. To create a table, add the following code to the `hello.cpp` file, right after `using contract::contract`:

```cpp
      TABLE user_record {
         name user;
         uint64_t primary_key() const { return user.value; }
      };
      typedef eosio::multi_index< name("users"), user_record> user_index;
```

The table is defined by a struct named `user_record` containing one field `user` of type `name`; in practice, more fields are defined. It also defines the `primary_key()` method which returns the unique identifier associated with `user`. This enforces a unique name in the table.

Now that you have a multi-index table, you can implement full CRUD functionality: create, read, update, and delete records. In this guide, you will create a new record when the `world` action gets invoked. To that end, add the following code at the beginning of your `world` method:

```cpp
         user_index users( get_self(), get_self().value );
         users.emplace( get_self(), [&]( auto& new_record ) {
            new_record.user = user;
         });
```

In the code above, a new record is created and appended to the `users` table. The `user` field in the new record gets populated with the user name passed to the `world` action.

The full modified `hello` contract now looks as follows:

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
         user_index users( get_self(), get_self().value );
         users.emplace( get_self(), [&]( auto& new_record ) {
            new_record.user = user;
         });
         print_f("Hello World from %!\n", user);
      }
};
```

### Recompile, Deploy, Test

Now that you have added state to your `hello` contract by creating a multi-index table, you can compile, deploy, and test your modified contract. To that end, re-execute the following commands:

```shell
dune --cmake-build .
```
```
-- Configuring done
-- Generating done
-- Build files have been written to: /host/Users/lparisc/Documents/eosnf/work/contracts/hello/build
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

```shell
dune --deploy build/hello hello
```
```
#         eosio <= eosio::setcode               {"account":"hello","vmtype":0,"vmversion":0,"code":"0061736d010000000159106000006000017f60027f7f0060...
#         eosio <= eosio::setabi                {"account":"hello","abi":"0e656f73696f3a3a6162692f312e3200020b757365725f7265636f72640001047573657204...
```

If all went well, you can now send new `world` actions to your `hello` contract by passing different names - just make sure they are unique and they abide by the EOS name rules:

```shell
dune --send-action hello world '[bob]' hello@active
```
```
executed transaction: d32628565fee76440da0a8bc8d2f0eacce15dbdd629b3a64e8aad21ae87171eb  104 bytes  100 us
warning: transaction executed locally, but may not be confirmed by the network yet         ]
#         hello <= hello::world                 {"user":"bob"}
>> Hello World from bob!
```

```shell
dune --send-action hello world '[alice]' hello@active
```
```
executed transaction: c439721576b38f68714a606fbfd150e7a3e870bd71361804b7098a3aabce5eeb  104 bytes  114 us
warning: transaction executed locally, but may not be confirmed by the network yet         ]
#         hello <= hello::world                 {"user":"alice"}
>> Hello World from alice!
```

```shell
dune --send-action hello world '[john]' hello@active
```
```
executed transaction: ff05d2842ae5d6def42d96474837ca03d5106f6f94ce62f2a579905143376ab7  104 bytes  103 us
warning: transaction executed locally, but may not be confirmed by the network yet         ]
#         hello <= hello::world                 {"user":"john"}
>> Hello World from john!
```

Note that if you try to re-add the same user name, the transaction will fail as expected:

```shell
dune --send-action hello world '[john]' hello@active
```
```
failed transaction: 70acecf896d92b70bf473beb86b3e04e93e6f21fcb32e6bdeee6ad5f8173fbcc  <unknown> bytes  <unknown> us
error 2023-02-23T09:17:08.670 cleos     main.cpp:700                  print_result         ] soft_except->to_detail_string(): 13 N5boost10wrapexceptISt11logic_errorEE: could not insert object, most likely a uniqueness constraint was violated
could not insert object, most likely a uniqueness constraint was violated: pending console output:
    {"console":"","what":"could not insert object, most likely a uniqueness constraint was violated"}
    nodeos  apply_context.cpp:124 exec_one
```

### Get Table Data

Now that you have implemented your multi-index table and the ability to create new records in it, you can now implement the remaining three CRUD operations: read, update, and delete records, if needed. It all depends on the business rules that you need to implement within your contract.

You can also invoke the `get_table_rows` endpoint to perform basic table queries, or view the entire table state if needed. To view the current table state, invoke the following command:

```shell
dune --get-table hello hello users
```

The result will look similar to:

```
{
  "rows": [{
      "user": "bob"
    },{
      "user": "alice"
    },{
      "user": "john"
    }
  ],
  "more": false,
  "next_key": ""
}
```

## Summary

In this guide you learned how to use DUNE for basic smart contract development. In particular, you launched a local EOS blockchain consisting of a single node, created test accounts for smart contract deployment and testing, developed and deployed the Hello World contract, and finally tested your Hello World contract.
