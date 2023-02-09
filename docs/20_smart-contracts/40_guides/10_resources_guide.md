---
title: Resources Guide
---

The EOS blockchain works with three system resources: CPU, NET and RAM. The EOS accounts need sufficient system resources to interact with the smart contracts deployed on the blockchain.

* [RAM Resource](#ram-resource)
* [CPU Resource](#cpu-resource)
* [NET Resource](#net-resource)

To allocate resources to an account use the `PowerUp Model` to [power up that account](#account-power-up).

## RAM Resource

RAM is the memory, the storage space, where the blockchain stores data. If your contract needs to store data on the blockchain, like in a database, then it can store it in the blockchain's RAM using either a `multi-index table` or a `singleton`.

### RAM High Performance

The EOS blockchain is known for its high performance, which is achieved also because the data stored on the blockchain is using RAM as the storage medium, and thus access to blockchain data is very fast, helping the performance benchmarks to reach levels very few blockchains has been able to.

### RAM Importance

RAM is a very important system resource because of the following reasons:

* RAM is a limited resource, the public EOS blockchain started with 64GB of RAM and after that the block producers decided to increase the memory with 1KB per block, thus increasing constantly the supply of RAM for its price to not grow too high due to the increased demand from blockchain applications.

* RAM is used in executing many actions sent to the blockchain; creating a new account action, for example, it needs to store in the blockchain memory the new account's information; also when an account accepts a new type of token a new record has to be created, somewhere in the blockchain memory, that holds the balance of the new token accepted, and that memory, the storage space on the blockchain, has to be purchased either by the account that transfers the token or by the account that accepts the new token type.

* The smart contract can not store any additional information if it consumes all its allocated RAM. To continue to save data in the blockchain database, one, or both of the following conditions must be met:

  * A portion of the occupied RAM is freed by the smart contract.
  * More RAM is allocated to the smart contract account through the RAM purchase process.

### How To Purchase RAM

The RAM resource must be bought using the system token. The price of RAM is calculated according to the unique Bancor liquidity algorithm which is implemented in the system contract [here](https://docs.eosnetwork.com/system-contracts/latest/reference/Classes/structeosiosystem_1_1exchange__state).

The quickest way to calculate the price of RAM is the following:

1. Run the following cleos command, make sure you run it against the mainnet or the testnet of your choice:

    ```shell
    cleos get table eosio eosio rammarket
    ```

2. Observe the output which should look like the following:  

    ```text
    {
        "supply": "10000000000.0000 RAMCORE",
        "base": {
            "balance": "35044821247 RAM",
            "weight": "0.50000000000000000"
        },
        "quote": {
            "balance": "3158350.8754 EOS",
            "weight": "0.50000000000000000"
        }
    }
    ```

3. Make note of the `base balance`, in this case is 35044821247
4. Make note of the `quote balance`, in this case is 3158350.8754
5. Calculate the price of 1Kib of RAM as `quote balance` * 1024 / `base balance` = 0.0922 EOS

#### Buy RAM With Command Line Interface

You can buy RAM through cleos command line interface tool. And you can buy either an explicit amount of RAM expressed in bytes or an amount of RAM worth of an explicit amount of EOS.

#### Buy RAM In EOS

For example the below command buys for account `bob` 0.1 EOS worth of RAM at the current market RAM price. The cost for the RAM and the execution of this transaction is covered by the `alice` account and the transaction is authorized by the `active` key of the `alice` account.

```shell
cleos system buyram alice bob "0.1 EOS" -p alice@active
```

#### Buy RAM In Bytes

For example the below command buys for account `bob` 1000 RAM bytes at the current market RAM price. The cost for the RAM and the execution of this transaction is covered by the `alice` account and the transaction is authorized by the `active` key of the `alice` account.

```shell
cleos system buyrambytes alice bob "1000" -p alice@active
```

#### Buy RAM With EOS Wallet

Another way to buy RAM is through an EOS wallet that supports this feature.

### How Is RAM Calculated

The necessary RAM needed for a smart contract to store its data is calculated from the used blockchain state.

As a developer, to understand the amount of RAM your smart contract needs, you have to pay attention to the data structure underlying the multi-index tables your smart contract instantiates and uses. The data structure underlying one multi-index table defines a row in the table. And each data member of the data structure corresponds with a row cell of the table. Summing the type size of each data member and adding to it the overheads, defined by EOS code, will give you an approximate amount of RAM one multi-index row needs to be stored on the blockchain. On top of this, you will have to also take in consideration if there are any indexes defined on your multi-index table. The overheads defined by the EOS code for multi-index tables, indexes and data types can be consulted below:

* [Multi-index RAM bytes overhead](https://github.com/AntelopeIO/leap/blob/f6643e434e8dc304bba742422dd036a6fbc1f039/libraries/chain/include/eosio/chain/contract_table_objects.hpp#L240)
* [Overhead per row per index RAM bytes](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L109)
* [Fixed overhead shared vector RAM bytes](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L108)
* [Overhead per account RAM bytes](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L110)
* [Setcode RAM bytes multiplier](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L111)
* [RAM usage update function](https://github.com/AntelopeIO/leap/blob/9f0679bd0a42d6c24a966bb79de6d8c0591872a5/libraries/chain/apply_context.cpp#L725)

### Related documentation articles

* Multi-index table [reference documentation page](http://docs.eosnetwork.com/cdt/latest/reference/Modules/group__multiindex)
* Multi-index table [how to documentation page](https://docs.eosnetwork.com/cdt/latest/how-to-guides/multi-index/how-to-define-a-primary-index/)
* Singleton [reference documentation page](https://docs.eosnetwork.com/cdt/latest/reference/Classes/classeosio_1_1singleton)
* Singleton [how to documentation page](https://docs.eosnetwork.com/cdt/latest/how-to-guides/multi-index/how-to-define-a-singleton)

## CPU Resource

CPU, as NET and RAM, is a very important system resource in the EOS blockchain. The system resource CPU provides processing power to blockchain accounts. When the blockchain executes a transaction it consumes CPU and NET, therefore sufficient CPU must be allocated to the payer account for transactions to complete. The amount of CPU an account has is measured in microseconds and it is referred to as `cpu bandwidth` on the `cleos get account` command output.

### How Is CPU Calculated

When an account uses the rented CPU, the amount that can be used in one transaction is limited by predefine [maximum CPU](https://docs.eosnetwork.com/cdt/latest/reference/Classes/structeosio_1_1blockchain__parameters#variable-max-transaction-cpu-usage) and [minimum CPU](https://docs.eosnetwork.com/cdt/latest/reference/Classes/structeosio_1_1blockchain__parameters#variable-min-transaction-cpu-usage) limits. Transactions executed by the blockchain contain one or more actions, and each transaction must consume an amount of CPU which is in the limits defined by the aforementioned blockchain settings.

The blockchain calculates and updates the remaining resources, for the accounts which execute transactions, with each block, before each transaction is executed. When a transaction is prepared for execution, the blockchain makes sure the payer account has enough CPU to cover for the transaction execution. The necessary CPU is calculated by measuring the time for executing the transaction on the node that is actively building the current block. If the account has enough CPU the transaction can be executed otherwise it is rejected. For technical details please refer to the following pointers:

* [The CPU configuration variables](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L66)
* [The transaction initialization](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1559)
* [The transaction CPU billing](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1577)
* [The check of CPU usage for a transaction](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/transaction_context.cpp#L381)

### Subjective CPU Billing

Subjective billing is an optional feature of the EOS blockchain that lets nodes bill account resources locally in their own node without sharing the billing with the rest of the network. It has, since its introduction, benefited the adopting nodes because it reduced node CPU usage by almost 90%. On the other side, sometimes, it results in failing transactions or lost transactions. As a developer you should be aware that when a smart contract code uses a "check" function, like `assert()` or `check()`, to verify data, it can trigger transaction failure and thus can lead to subjective billing issues. One alternative is to assert or check earlier in a contract’s execution to reduce the billing applied. Or as long as the lack of an error message does not affect user experience, some contracts may also benefit from replacing some asserts and checks with return statements to ensure their transactions succeed and are billed objectively on-chain.

More details about subjective billing can be found in [Introduction to subjective billing and lost transactions](https://eosnetwork.com/blog/api-plus-an-introduction-to-subjective-billing-and-lost-transactions/) article.

### How To Rent CPU

For details on how to rent CPU resources refer to [Account Power Up](#account-power-up) section.

## NET Resource

NET, as CPU and RAM, is a very important system resource in the EOS blockchain. When the blockchain executes a transaction it consumes CPU and NET, therefore sufficient NET must be allocated to the payer account for transactions to complete. NET is referred to as `net bandwidth` on the `cleos get account` command output.

### How Is NET Calculated

When an account uses the allocated NET, the amount that can be used in one transaction is limited by predefine [maximum NET](https://docs.eosnetwork.com/cdt/latest/reference/Classes/structeosio_1_1blockchain__parameters#variable-max-transaction-net-usage) limit. Transactions executed by the blockchain contain one or more actions, and each transaction must consume an amount of NET which is in the limits defined by the aforementioned blockchain settings.

The blockchain calculates and updates the remaining resources, for the accounts which execute transactions, with each block, before each transaction is executed. When a transaction is prepared for execution, the blockchain makes sure the payer account has enough NET to cover for the transaction execution. The necessary NET is calculated based on the transaction size, that is, the size of the packed transaction as it is stored in the blockchain. If the account has enough NET resources the transaction can be executed otherwise it is rejected. For technical details please refer to the following sources:

* [The NET configuration variables](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L57)
* [The transaction initialization](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1559)
* [The transaction NET billing](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1577)
* [The check of NET usage for a transaction](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/transaction_context.cpp#L376)

### How To Rent NET

For details on how to rent NET resources refer to the how to [Account Power Up](#account-power-up) section.

## Resource Cost Estimation

As a developer if you want to estimate how much CPU and NET is required for a transaction to be executed you can use the []()

## Account Power Up

To power up an account means to rent CPU and NET from the PowerUp resource model which is implemented as a smart contract on the blockchain and allocate them to the account of your choice. The action to power up an account is `powerup`. It takes as parameters:

* The `payer` of the fee, must be a valid EOS account.
* The `receiver` of the resources, must be a valid EOS account.
* The `days` which must always match `state.powerup_days` specified in the [PowerUp configuration settings](https://github.com/eosnetworkfoundation/eos-system-contracts/blob/7cec470b17bd53b8c78465d4cbd889dbaf1baffb/contracts/eosio.system/include/eosio.system/eosio.system.hpp#L588).
* The `net_frac`, and the `cpu_frac` are the percentage of the resources that you need. The easiest way to calculate the percentage is to multiple 10^15 (100%) by the desired percentage. For example: 10^15 * 0.01 = 10^13.
* The `max_payment`, must be expressed in EOS and is the maximum amount the `payer` is willing to pay.

```sh
cleos push action eosio powerup '[user, user, 1, 10000000000000, 10000000000000, "1000.0000 EOS"]' -p user
```

You can see how much NET and CPU weight was received as well as the fee by looking at the `eosio.reserv::powupresult` informational action.

```console
executed transaction: 82b7124601612b371b812e3bf65cf63bb44616802d3cd33a2c0422b58399f54f  144 bytes  521 us
#         eosio <= eosio::powerup               {"payer":"user","receiver":"user","days":1,"net_frac":"10000000000000","cpu_frac":"10000000000000","...
#   eosio.token <= eosio.token::transfer        {"from":"user","to":"eosio.rex","quantity":"999.9901 EOS","memo":"transfer from user to eosio.rex"}
#  eosio.reserv <= eosio.reserv::powupresult    {"fee":"999.9901 EOS","powup_net_weight":"16354","powup_cpu_weight":"65416"}
#          user <= eosio.token::transfer        {"from":"user","to":"eosio.rex","quantity":"999.9901 EOS","memo":"transfer from user to eosio.rex"}
#     eosio.rex <= eosio.token::transfer        {"from":"user","to":"eosio.rex","quantity":"999.9901 EOS","memo":"transfer from user to eosio.rex"}
```

The PowerUp resource model on EOS blockchain is initialized with `"powerup_days": 1,` which means the maximum period you can rent CPU and NET is 24 hours. If you do not use them in the 24 hours interval the rented CPU and NET will expire.

### Process Expired Orders

The resources in loans that expire do not automatically get reclaimed by the system. The expired loans sit in a queue that must be processed. Anyone calling the `powerup` action will help with processing this queue (limited to processing at most two expired loans at a time) so that normally the expired loans will be automatically processed in a timely manner. However, in some cases it may be necessary to manual process expired loans in the queue to make resources available to the system again and thus make prices cheaper. In such a scenario, any account may process up to an arbitrary number of expired loans by calling the `powerupexec` action.

The orders table `powup.order` can be viewed by calling:

```sh
cleos get table eosio 0 powup.order
```

```json
{
  "rows": [{
      "version": 0,
      "id": 0,
      "owner": "user",
      "net_weight": 16354,
      "cpu_weight": 65416,
      "expires": "2020-11-18T13:04:33"
    }
  ],
  "more": false,
  "next_key": ""
}
```

Example `powerupexec` call:

```sh
cleos push action eosio powerupexec '[user, 2]' -p user
```

```console
executed transaction: 93ab4ac900a7902e4e59e5e925e8b54622715328965150db10774aa09855dc98  104 bytes  363 us
#         eosio <= eosio::powerupexec           {"user":"user","max":2}
warning: transaction executed locally, but may not be confirmed by the network yet         ]
```

### Alternative Ways To Use The PowerUp Model

You can also use the PowerUp model to power up your account with CPU and NET, using an EOS wallet that supports the PowerUp resource model.
