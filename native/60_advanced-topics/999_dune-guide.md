---
title: Local Development
---

[Docker Utilities for Node Execution (DUNE)](https://github.com/AntelopeIO/DUNE) is a client tool that allows blockchain developers and node operators to perform boilerplate tasks related to smart contract development and node management functions.

Before getting started with smart contract development, you need to learn about DUNE and how to install it on your platform.

### Installation

DUNE supports the following platforms:
* Linux
* Windows
* MacOS

Installation instructions for each supported platform are available on the [DUNE's github project](https://github.com/AntelopeIO/DUNE) page.

 Run `dune --help` to see a list of all supported commands.

## Wallets

DUNE handles wallet management for you. 

If you need to import a new key into your wallet:

```shell
dune --import-dev-key <PRIVATE_KEY>
```

## Node management

Use DUNE to easily create a new local EOS blockchain.

```shell
dune --start <NODE_NAME>
```

The command above creates a new node called `NODE_NAME` with default settings. The default settings configure the new node to serve as an API/producer node. You can deploy smart contracts to this node and perform tests on it.

> ❔ **Errors**
>
> You may see errors at the end of the node setup process.
> If you do, you can refer to this guide to troubleshoot common errors, or reach out to us on our
> [Telegram channel](https://t.me/antelopedevs) for help.

You can see a list of EOS nodes on your system:

```shell
dune --list
```

You can check if your active node's RPC API is live:

```shell
dune -- cleos get info
```

To shut down your node:

```shell
dune --stop <NODE_NAME>
```

To remove a node entirely:

```shell
dune --remove <NODE_NAME>
```


### Bootstrapping your environment

Your development environment may need to rely on a few system contracts, such as:

- `eosio.token` for **EOS** token transfers
- `eosio.msig` for multisig transactions
- `eosio.system` for system level actions such as resource management

Bootstrapping your local node is easy. Once you have an active node running, you can bootstrap it with:

```shell
dune --bootstrap-system-full
```


## Account management

You use accounts to interact with smart contracts, and also deploy contracts on top of accounts.

To create a new account:

```shell
dune --create-account <ACCOUNT_NAME>
```

To get account info:

```shell
dune -- cleos get account <ACCOUNT_NAME>
```

## Smart contract development

Create a sample project so you can learn how to compile, deploy, and interact with smart contracts using DUNE.

Navigate to a directory in which you create a project, and then run the following command:

```shell
dune --create-cmake-app hello .
```

This will create a `hello` directory with a cmake style EOS smart contract project.

Replace the contents of `src/hello.cpp` with the following code:

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

      ACTION test( name user ) {
         print_f("Hello World from %!\n", user);
         user_index users( get_self(), get_self().value );
         users.emplace( get_self(), [&]( auto& new_record ) {
            new_record.user = user;
         });
      }
};
```

### Compile your contract

From the root of your project, run the following command to compile your contract:

```shell
dune --cmake-build .
```
Your contract compiles. Any errors display in the output. 

### Deploy your contract

Create an account for your contract and then deploy it.

```shell
dune --create-account hello
dune --deploy ./build/hello hello
```

> 👀 **Code Permission**
> 
> By default, DUNE adds the `eosio.code` permission to an account when you deploy a contract to it. This allows the contract to trigger inline actions on other smart contracts.

### Interacting with your contract

Send a transaction on your local EOS. node to the blockchain to interact with your smart contract. A transaction contains multiple actions. You can send a transaction with a single action using the --send-action command.

You must also create a test account from which to send the action.

```shell
dune --create-account testaccount

# format: dune --send-action <CONTRACT> <ACTION> <PARAMETERS> <SENDER>
dune --send-action hello test '[bob]' testaccount
```

You should see a transaction executed successfully with a row added to the contract's database. If you repeat this command it will fail because that row already exists in the contract's database.

### Get data from your contract

You just added a row to the contract's database. You can fetch that data from the chain:

```shell
# format: dune --get-table <CONTRACT> <SCOPE> <TABLE>
dune --get-table hello hello users
```

You get a table result with one or more rows. If you did not receive a table with one or more rows, make sure the interaction above was successful.

## Using raw programs with DUNE

If you want to tap into the raw EOS stack, you can use the `DUNE -- <COMMAND>` format to access data, applications, and everything else within the container.

Examples:
    
```shell
dune -- cleos get info
dune -- nodeos --help
```
