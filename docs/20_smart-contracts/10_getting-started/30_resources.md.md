---
title: Resources
---

The EOS blockchain works with three system resources: CPU, NET and RAM. The EOS accounts need sufficient system resources to interact with the smart contracts deployed on the blockchain.

* [RAM Resource](#ram-resource)
* [CPU Resource](#cpu-resource)
* [NET Resource](#net-resource)

To allocate RAM resources to an account you have to [purchase RAM](#how-to-purchase-ram).
To allocate CPU and NET resources to an account you have to [power up the account](#account-power-up).

## RAM Resource

The RAM resource is the memory, the storage space, where the blockchain stores data. If your contract needs to store data on the blockchain, it can store it in the blockchain's RAM as a `multi-index table` or a `singleton`.

### RAM High Performance

Data stored on the EOS blockchain uses RAM as its storage medium. Therefore, access to the blockchain data is highly performant and fast. Its performance benchmarks can reach levels rarely achieved by other blockchains. This ability elevates the EOS blockchain to be a contender for the fastest blockchain worldwide.

### RAM Importance

RAM is an important system resource because of the following reasons:

* Ram is a limited resource. The public EOS blockchain started with 64GB of total RAM. After a brief period the block producers decided to increase the memory with 1KB per block. In this way the supply of RAM constantly increases, yet its price accelerates at a slower pace.

* The execution of many actions by the blockchain uses RAM. For example, when you create a new account, the new account information is stored in the blockchain's RAM. Also, when an account accepts a token which it did not hold before, a new record has to be created, that holds the balance of the newly accepted token. The blockchain memory has to be purchased either by the account that transfers the tokens or by the account that accepts the new token type.

* If a smart contract consumes all of its allocated RAM, it cannot store any additional information. To continue to save data in the blockchain database, one or both of the following conditions must be met:

  * A portion of the occupied RAM is freed by the smart contract.
  * More RAM is allocated to the smart contract account through the RAM purchase process.

### How To Purchase RAM

The RAM resource must be bought with the `EOS` system token. The price of RAM is calculated according to the unique Bancor liquidity algorithm that is implemented in the system contract.

The quickest way to calculate the price of RAM:

1. Run the following dune command: (**Note:** Make sure you run it against the mainnet or the testnet of your choice.)

    ```shell
    dune -- cleos get table eosio eosio rammarket
    ```

2. Observe the output which should look like the sample below:  

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

3. Make note of the `base balance`, in this case it is 35044821247.
4. Make note of the `quote balance`, in this case it is 3158350.8754.
5. Calculate the price of 1Kib of RAM as `quote balance` * 1024 / `base balance` = 0.0922 EOS.

#### Buy RAM With Command Line Interface

You can buy RAM through the dune command line interface tool. You can buy either an explicit amount of RAM expressed in bytes or an amount of RAM worth an explicit amount of EOS.

#### Buy RAM In EOS

For example, the command below buys for account `bob` 0.1 EOS worth of RAM at the current market RAM price. The cost for the RAM and the execution of this transaction is covered by the `alice` account and the transaction is authorized by the `active` key of the `alice` account.

```shell
dune -- cleos system buyram alice bob "0.1 EOS" -p alice@active
```

#### Buy RAM In Bytes

For example, the command below buys for account `bob` 1000 RAM bytes at the current market RAM price. The cost for the RAM and the execution of this transaction is covered by the `alice` account and the transaction is authorized by the `active` key of the `alice` account.

```shell
dune -- cleos system buyrambytes alice bob "1000" -p alice@active
```

### How Is RAM Calculated

The necessary RAM needed for a smart contract to store its data is calculated from the used blockchain state.

As a developer, to understand the amount of RAM your smart contract needs, pay attention to the data structure underlying the multi-index tables your smart contract instantiates and uses. The data structure underlying one multi-index table defines a row in the table. Each data member of the data structure corresponds with a row cell of the table.
To approximate the amount of RAM one multi-index row needs to store on the blockchain, you have to add the size of the type of each data member and the memory overheads for each of the defined indexes, if any. Find below the overheads defined by the EOS code for multi-index tables, indexes, and data types:

* [Multi-index RAM bytes overhead](https://github.com/AntelopeIO/leap/blob/f6643e434e8dc304bba742422dd036a6fbc1f039/libraries/chain/include/eosio/chain/contract_table_objects.hpp#L240)
* [Overhead per row per index RAM bytes](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L109)
* [Fixed overhead shared vector RAM bytes](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L108)
* [Overhead per account RAM bytes](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L110)
* [Setcode RAM bytes multiplier](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L111)
* [RAM usage update function](https://github.com/AntelopeIO/leap/blob/9f0679bd0a42d6c24a966bb79de6d8c0591872a5/libraries/chain/apply_context.cpp#L725)

## CPU Resource

As NET and RAM, the CPU resource is a very important system resource in the EOS blockchain. The CPU system resource provides processing power to blockchain accounts. When the blockchain executes a transaction, it consumes CPU and NET. For transactions to complete, sufficient CPU must be allocated to the payer account. The amount of CPU an account has is measured in microseconds and it is referred to as `cpu bandwidth` on the `dune -- cleos get account` command output.

### How Is CPU Calculated

Transactions executed by the blockchain contain one or more actions. Each transaction must consume an amount of CPU within the limits predefined by the minimum and maximum transaction CPU usage values. For EOS blockchain these limits are set in the blockchain's configuration. You can find out these limits by running the following command and consult the `min_transaction_cpu_usage` and the `max_transaction_cpu_usage` which are expressed in microseconds:

```shell
dune -- cleos get consensus_parameters
```

For accounts that execute transactions, the blockchain calculates and updates the remaining resources with each block before each transaction is executed. When a transaction is prepared for execution, the blockchain determines whether the payer account has enough CPU to cover the transaction execution. To calculate the necessary CPU, the node that actively builds the current block measures the time to execute the transaction. If the account has enough CPU, the transaction is executed; otherwise it is rejected. For technical details please refer to the following links:

* [The CPU configuration variables](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L66)
* [The transaction initialization](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1559)
* [The transaction CPU billing](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1577)
* [The check of CPU usage for a transaction](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/transaction_context.cpp#L381)

### Subjective CPU Billing

Subjective billing is an optional feature of the EOS blockchain. It allows nodes to bill account resources locally in their own node without sharing the billing with the rest of the network. Since its introduction, subjective billing benefited the nodes that adopted it because it reduced the node CPU usage by almost 90%. But it can result in failed transactions or lost transactions. Subjective billing can trigger transaction failure when a smart contract code uses a "check" function, like `assert()` or `check()` command to verify data. When this situation occurs, assert or check earlier in the system contract execution to reduce the applied billing. If the lack of an error message does not affect the user experience, a system contract may benefit by replacing some asserts and checks with a return statement. This replacement ensures their transactions succeed and are billed objectively on-chain.

Find more details about subjective billing in the [Introduction to subjective billing and lost transactions](https://eosnetwork.com/blog/api-plus-an-introduction-to-subjective-billing-and-lost-transactions/) article.

### How To Rent CPU

For details on how to rent CPU resources refer to the [Account Power Up](#account-power-up) section.

## NET Resource

As CPU and RAM, the NET resource is an important system resource in the EOS blockchain. When the blockchain executes a transaction, it consumes CPU and NET. Sufficient NET must be allocated to the payer account for transactions to complete. NET is referred to as `net bandwidth` on the `dune -- cleos get account` command output.

### How Is NET Calculated

Each transaction must consume an amount of NET which can not exceed the predefined maximum transaction NET usage value. For EOS blockchain this limit is set in the blockchain's configuration. You can find out this limit by running the following command and consult the `max_transaction_net_usage` which is expressed in bytes.

```shell
dune -- cleos get consensus_parameters
```

For the accounts that execute transactions, the blockchain calculates and updates the remaining resources for each block before each transaction is executed. When a transaction is prepared for execution, the blockchain determines whether the payer account has enough NET to cover the transaction execution. The necessary NET is calculated based on the transaction size, which is the size of the packed transaction as it is stored in the blockchain. If the account has enough NET resources, the transaction can be executed; otherwise it is rejected. For technical details please refer to the following sources:

* [The NET configuration variables](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L57)
* [The transaction initialization](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1559)
* [The transaction NET billing](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1577)
* [The check of NET usage for a transaction](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/transaction_context.cpp#L376)

### How To Rent NET

For details on how to rent NET resources refer to the [Account Power Up](#account-power-up) section.

## Resource Cost Estimation

As a developer if you want to estimate how much CPU and NET a transaction requires for execution, you can employ one of the following methods:

* Use the `--dry-run` option for the `dune -- cleos push transaction` command.
* Use any tool that can pack a transaction and send it to the blockchain and specify the `--dry-run` option.
* Use the chain API endpoint [`compute_transaction`](https://github.com/AntelopeIO/leap/blob/51c11175e54831474a89a449beea1fb067e3d1e9/plugins/chain_plugin/include/eosio/chain_plugin/chain_plugin.hpp#L489).

In all cases, when the transaction is processed, the blockchain node simulates the execution of the transaction and, as a consequence, the state of the blockchain is changed speculatively, which allows for the CPU and NET measurements to be done. However, the transaction is not sent to the blockchain and the caller receives the estimated CPU and NET costs in return.

## Account Power Up

To power up an account is a technique to rent CPU and NET resources from the PowerUp resource model. A smart contract implements this model on the blockchain and allocates these resources to the account of your choice. The action to power up an account is `powerup`. It takes as parameters:

* The `payer` of the fee, must be a valid EOS account.
* The `receiver` of the resources, must be a valid EOS account.
* The `days` which must always match `state.powerup_days` specified in the [PowerUp configuration settings](https://github.com/eosnetworkfoundation/eos-system-contracts/blob/7cec470b17bd53b8c78465d4cbd889dbaf1baffb/contracts/eosio.system/include/eosio.system/eosio.system.hpp#L588).
* The `net_frac`, and the `cpu_frac` are the percentage of the resources that you need. The easiest way to calculate the percentage is to multiple 10^15 (100%) by the desired percentage. For example: 10^15 * 0.01 = 10^13.
* The `max_payment`, must be expressed in EOS and is the maximum amount the `payer` is willing to pay.

```sh
dune -- cleos push action eosio powerup '[user, user, 1, 10000000000000, 10000000000000, "1000.0000 EOS"]' -p user
```

To view the received NET and CPU weight as well as the amount of the fee, check the `eosio.reserv::powupresult` returned by the action, which should look similar to the one below:

```console
executed transaction: 82b7124601612b371b812e3bf65cf63bb44616802d3cd33a2c0422b58399f54f  144 bytes  521 us
#         eosio <= eosio::powerup               {"payer":"user","receiver":"user","days":1,"net_frac":"10000000000000","cpu_frac":"10000000000000","...
#   eosio.token <= eosio.token::transfer        {"from":"user","to":"eosio.rex","quantity":"999.9901 EOS","memo":"transfer from user to eosio.rex"}
#  eosio.reserv <= eosio.reserv::powupresult    {"fee":"999.9901 EOS","powup_net_weight":"16354","powup_cpu_weight":"65416"}
#          user <= eosio.token::transfer        {"from":"user","to":"eosio.rex","quantity":"999.9901 EOS","memo":"transfer from user to eosio.rex"}
#     eosio.rex <= eosio.token::transfer        {"from":"user","to":"eosio.rex","quantity":"999.9901 EOS","memo":"transfer from user to eosio.rex"}
```

The PowerUp resource model on the EOS blockchain is initialized with `"powerup_days": 1,`. This setting permits the maximum period to rent CPU and NET for 24 hours. If you do not use the resources within the 24 hour interval, the rented CPU and NET expires.

### Process Expired Orders

The resources in loans that expire are not automatically reclaimed by the system. The expired loans remain in a queue that must be processed.

Any calls to the `powerup` action does process also this queue (limited to two expired loans at a time). Therefore, the expired loans are automatically processed in a timely manner. Sometimes, it may be necessary to manually process expired loans in the queue to release resources back to the system, which reduces prices. Therefore, any account may process up to an arbitrary number of expired loans if it calls the `powerupexec` action.

To view the orders table `powup.order` execute the following command:

```sh
dune -- cleos get table eosio 0 powup.order
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
dune -- cleos push action eosio powerupexec '[user, 2]' -p user
```

```console
executed transaction: 93ab4ac900a7902e4e59e5e925e8b54622715328965150db10774aa09855dc98  104 bytes  363 us
#         eosio <= eosio::powerupexec           {"user":"user","max":2}
warning: transaction executed locally, but may not be confirmed by the network yet         ]
```
