---
title: DUNE
---

[Docker Utilities for Node Execution (DUNE)](https://github.com/AntelopeIO/DUNE) is a client tool. 
As a blockchain developer or node operator, use DUNE for your common tasks.

Before you begin, learn about DUNE and how to install it on your platform.

### Installation

You can install and run DUNE n the following platforms:
* Linux
* Windows
* MacOS

Each platform has their own installation instructions. Click [DUNE's GitHub project](https://github.com/AntelopeIO/DUNE) to view the instructions.

Run `dune --help` to view a list of all supported commands.

## Wallets

DUNE handles wallet management for you so you don't have to. 

If you need to import a new key into your wallet:

```shell
dune --import-dev-key <PRIVATE_KEY>
```

## Node management

DUNE easily creates a new local EOS blockchain.

The following command creates a new node called `NODE_NAME`.  This node initiates with default settings. These default settings configure the node to serve as an API/producer node. You can deploy smart contracts to it and perform tests on it.

```shell
dune --start <NODE_NAME>
```

> 📝 **In Case of Errors**
>
> You may see errors at the end of the node setup process.
> If you do, refer to this guide to troubleshoot common errors, or reach out to us on our
> [Telegram channel](https://t.me/antelopedevs) for help.

The following command shows you a list of EOS nodes on your system:

```shell
dune --list
```

The following command checks if your active node's RPC API is live:

```shell
dune -- cleos get info
```

The following command shuts down your node:

```shell
dune --stop <NODE_NAME>
```

The following command removes a node:

```shell
dune --remove <NODE_NAME>
```

### Bootstrapping your environment

There are a few system contracts that your development environment may need to rely on, such as:
- `eosio.token` for **EOS** token transfers
- `eosio.msig` for multisig transactions
- `eosio.system` for system level actions such as resource management

Bootstrapping your local node is easy. Once you have an active node running, bootstrap it with:

```shell
dune --bootstrap-system-full
```

## Account management

You deploy contracts on top of accounts. Use accounts to interact with your smart contracts. 

The following command creates a new account:

```shell
dune --create-account <ACCOUNT_NAME>
```

The following command gets account info:

```shell
dune -- cleos get account <ACCOUNT_NAME>
```
## Smart contract development

Create a sample project to learn how to use DUNE to compile, deploy, and interact with smart contracts.

### Create sample project

Navigate to a directory in which you want to create a project, then run the following command:

```shell
dune --create-cmake-app hello .
```
This command creates a `hello` directory with a cmake style EOS smart contract project.

Replace the contents of `src/hello.cpp` with the following code:

```cpp
#include <eosio/eosio.hpp> 
using namespace eosio;

CONTRACT hello : public contract {ompilinc
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
You see your contract compiling. If there are any errors, you see them in the output.

### Deploy your contract

Use the following commands to create an account and deploy the contract to the account.

```shell
dune --create-account hello
dune --deploy ./build/hello hello
```

> 👀 **Code Permission**
> 
> By default, DUNE adds the `eosio.code` permission to an account when you deploy a contract to it. This allows the
> contract to be able to trigger inline actions on other smart contracts.

### Interacting with your contract

Transactions on EOS consist of 
`actions`. To interact with your contract send a single action to your contract.

You also need to create a test account from which to send the action.

Use the following commands to create a test account and send an action:

```shell
dune --create-account testaccount

# format: dune --send-action <CONTRACT> <ACTION> <PARAMETERS> <SENDER>
dune --send-action hello test '[bob]' testaccount
```

You should see a transaction executed successfully. If you try to repeat this command, the command 
fails because the row already exists in the contract's database.

### Get data from your contract

You added a row to the contract's database. 

Use the following command to fetch that data from the chain:

```shell
# format: dune --get-table <CONTRACT> <SCOPE> <TABLE>
dune --get-table hello hello users
```

You should get a table result with one or more rows. If you didn't, make sure your interaction above was successful.

## Using raw programs with DUNE

If you want to tap into the raw EOS stack, you can use the `DUNE -- <COMMAND>` format to access anything within the container.

Examples:
 
```shell
dune -- cleos get info
dune -- nodeos --help
```


