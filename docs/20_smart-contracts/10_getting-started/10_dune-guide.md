---
title: DUNE
---

[Docker Utilities for Node Execution (DUNE)](https://github.com/AntelopeIO/DUNE) is a client tool that allows blockchain developers and node operators to perform boilerplate tasks related to smart contract development and node management functions.

Before getting started with smart contract development, you need to learn about DUNE and how to install it on your platform.

### Installation

DUNE can be installed and run on the following platforms:
* Linux
* Windows
* MacOS

Installation instructions for each supported platform are available on the [DUNE's github project](https://github.com/AntelopeIO/DUNE) page.

Once you're done, you can run `dune --help` to see a list of all supported commands.

## Wallets

DUNE handles wallet management for you so that you don't have to. 

If you need to import a new key into your wallet:

```shell
dune --import-dev-key <PRIVATE_KEY>
```

## Node Management

Creating a new local EOS blockchain is easy with DUNE.

```shell
dune --start <NODE_NAME>
```

The command above creates a new node called `NODE_NAME` and starts it with default settings. 
The node is configured to serve as an API/producer node that you can deploy smart contracts to, and perform tests on.

> ❔ **Errors**
>
> You may see errors at the end of the node setup process.
> If you do you can refer to this guide to troubleshoot common errors, or reach out to us on our
> [Telegram channel](https://t.me/antelopedevs) for help.

You can see a list of EOS nodes on your system:

```shell
dune --list
```

You can also check if your active node's RPC API is live:

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

There are a few system contracts that your development environment might need to rely on such as:
- `eosio.token` for **EOS** token transfers
- `eosio.msig` for multisig transactions
- `eosio.system` for system level actions such as resource management

Bootstrapping your local node is easy, once you have an active node running, you can bootstrap it with:

```shell
dune --bootstrap-system-full
```


## Account management

You deploy contracts on top of accounts, and also use them to interact with your smart contracts. 

To create a new account:

```shell
dune --create-account <ACCOUNT_NAME>
```

To get account info:

```shell
dune -- cleos get account <ACCOUNT_NAME>
```

## Smart Contract Development

Let's create a sample project so that we can learn how to compile, deploy, and interact with smart contracts using DUNE.

Navigate to a directory you want to create a project in, and then run the following command:

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

### Compile the contract

From the root of your project, run the following command to compile your contract:

```shell
dune --cmake-build .
```
You will see your contract being compiled. If there are any errors you will see them in the output.

### Deploy your contract

We need to create an account for your contract, and then we can deploy it.

```shell
dune --create-account hello
dune --deploy ./build/hello hello
```

> 👀 **Code Permission**
> 
> By default, DUNE adds the `eosio.code` permission to an account when you deploy a contract to it. This allows the
> contract to be able to trigger inline actions on other smart contracts.

### Interacting with your contract

To interact with your contract you will send a transaction on your local EOS node. Transactions on EOS are made up of 
`actions`, so we will send a single action to your contract.

We will also create a test account to send the action from.

```shell
dune --create-account testaccount

# format: dune --send-action <CONTRACT> <ACTION> <PARAMETERS> <SENDER>
dune --send-action hello test '[bob]' testaccount
```

You should see a transaction executed successfully on the first time, and if you try to repeat this command it will 
fail because that row already exists in the contract's database.

### Get data from your contract

You just added a row to the contract's database, let's fetch that data from the chain:

```shell
# format: dune --get-table <CONTRACT> <SCOPE> <TABLE>
dune --get-table hello hello users
```

You should get a table result with one or more row. If you didn't make sure your interaction above was successful.

## Using raw programs with DUNE

If you want to tap into the raw EOS stack you can use the `DUNE -- <COMMAND>` format to access anything within the container.

Examples:
    
```shell
dune -- cleos get info
dune -- nodeos --help
```
