---
title: Resources
---

The EOS blockchain relies on three system resources: `CPU`, `NET` and `RAM`. Every EOS account needs system 
resources to interact with smart contracts deployed on the blockchain.

## RAM

RAM, just like in a computer, is a limited resource. It is a fast memory storage space that is used by the blockchain to store data.
Unlike your computer which has eventual persistence to a hard drive, the EOS blockchain stores all of its data in RAM.

Because of this, RAM is a very limited and in-demand resource. Every piece of state data that is stored on the blockchain
must be stored in RAM. This includes account balances, contract code, and contract data.

RAM can be purchased and sold by users on the EOS blockchain. The price of RAM is determined by a Bancor algorithm
that is implemented in the system contract. The price of RAM is determined by the amount of free RAM available. The less
free RAM available, the more expensive it is to buy RAM.

You can also sell RAM you are no longer using back to the system contract, in order to reclaim your EOS and free up RAM for other users.


### Buying RAM

The `eosio` system contracts provides the `buyram` and `buyrambytes` actions to buy RAM. The `buyram` action buys RAM in EOS, while the `buyrambytes` action buys RAM in bytes.

If you want a quick way to buy RAM from any wallet, you can **send any amount of EOS to the `buyramforeos` account**, and it will send you back the equivalent amount of RAM.

<details>
    <summary>Want to know how the RAM price is calculated?</summary>

The necessary RAM needed for a smart contract to store its data is calculated from the used blockchain state.

As a developer, to understand the amount of RAM your smart contract needs, pay attention to the data structure underlying the multi-index tables your smart contract instantiates and uses. The data structure underlying one multi-index table defines a row in the table. Each data member of the data structure corresponds with a row cell of the table.
To approximate the amount of RAM one multi-index row needs to store on the blockchain, you have to add the size of the type of each data member and the memory overheads for each of the defined indexes, if any. Find below the overheads defined by the EOS code for multi-index tables, indexes, and data types:

<br />

* [Multi-index RAM bytes overhead](https://github.com/AntelopeIO/leap/blob/f6643e434e8dc304bba742422dd036a6fbc1f039/libraries/chain/include/eosio/chain/contract_table_objects.hpp#L240)
* [Overhead per row per index RAM bytes](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L109)
* [Fixed overhead shared vector RAM bytes](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L108)
* [Overhead per account RAM bytes](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L110)
* [Setcode RAM bytes multiplier](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L111)
* [RAM usage update function](https://github.com/AntelopeIO/leap/blob/9f0679bd0a42d6c24a966bb79de6d8c0591872a5/libraries/chain/apply_context.cpp#L725)

</details>


## CPU & NET

Both CPU and NET are crucial resources that every EOS account needs in order to interact with the blockchain.

### CPU

CPU is a system resource that provides processing power to blockchain accounts. When a transaction is executed on the 
blockchain, it consumes CPU and NET resources. To ensure transactions are completed successfully, the payer account must 
have enough CPU allocated to it. 

The amount of CPU available to an account is measured in microseconds.


<details>
    <summary>Want to know how CPU is calculated?</summary>

Transactions executed by the blockchain contain one or more actions. Each transaction must consume an amount of CPU
within the limits predefined by the minimum and maximum transaction CPU usage values. For EOS blockchain these limits
are set in the blockchain's configuration. You can find out these limits by running the following command and consult
the `min_transaction_cpu_usage` and the `max_transaction_cpu_usage` which are expressed in microseconds.

<br />

For accounts that execute transactions, the blockchain calculates and updates the remaining resources with each block before each transaction is executed. When a transaction is prepared for execution, the blockchain determines whether the payer account has enough CPU to cover the transaction execution. To calculate the necessary CPU, the node that actively builds the current block measures the time to execute the transaction. If the account has enough CPU, the transaction is executed; otherwise it is rejected. For technical details please refer to the following links:

* [The CPU configuration variables](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L66)
* [The transaction initialization](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1559)
* [The transaction CPU billing](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1577)
* [The check of CPU usage for a transaction](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/transaction_context.cpp#L381)

</details>

### NET

NET is a resource that is consumed based on the network bandwidth used by a transaction.

<details>
    <summary>Want to know how NET is calculated?</summary>

Each transaction must consume an amount of NET which can not exceed the predefined maximum transaction NET usage value. For EOS blockchain this limit is set in the blockchain's configuration. You can find out this limit by running the following command and consult the `max_transaction_net_usage` which is expressed in bytes.

<br />

For the accounts that execute transactions, the blockchain calculates and updates the remaining resources for each block before each transaction is executed. When a transaction is prepared for execution, the blockchain determines whether the payer account has enough NET to cover the transaction execution. The necessary NET is calculated based on the transaction size, which is the size of the packed transaction as it is stored in the blockchain. If the account has enough NET resources, the transaction can be executed; otherwise it is rejected. For technical details please refer to the following sources:

<br />

* [The NET configuration variables](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/include/eosio/chain/config.hpp#L57)
* [The transaction initialization](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1559)
* [The transaction NET billing](https://github.com/AntelopeIO/leap/blob/e55669c42dfe4ac112e3072186f3a449936c0c61/libraries/chain/controller.cpp#L1577)
* [The check of NET usage for a transaction](https://github.com/AntelopeIO/leap/blob/a4c29608472dd195d36d732052784aadc3a779cb/libraries/chain/transaction_context.cpp#L376)

</details>



### Powering up

CPU & NET can be powered up on an EOS account by using the system actions. This costs EOS, and will give you an amount of CPU & NET
that is proportional to the amount of EOS you spend, for a specified period of time.

There are also free services like [EOS PowerUp](https://eospowerup.io) that will allow you to power up CPU & NET for free once 
per day.

<details>
    <summary>See detailed information about how to PowerUp manually</summary>

To power up an account is a technique to rent CPU & NET resources from the PowerUp resource model. A smart contract implements this model on the blockchain and allocates these resources to the account of your choice. The action to power up an account is `powerup`. It takes as parameters:

<br />

* The `payer` of the fee, must be a valid EOS account.
* The `receiver` of the resources, must be a valid EOS account.
* The `days` which must always match `state.powerup_days` specified in the [PowerUp configuration settings](https://github.com/eosnetworkfoundation/eos-system-contracts/blob/7cec470b17bd53b8c78465d4cbd889dbaf1baffb/contracts/eosio.system/include/eosio.system/eosio.system.hpp#L588).
* The `net_frac`, and the `cpu_frac` are the percentage of the resources that you need. The easiest way to calculate the percentage is to multiple 10^15 (100%) by the desired percentage. For example: 10^15 * 0.01 = 10^13.
* The `max_payment`, must be expressed in EOS and is the maximum amount the `payer` is willing to pay.

<br />

```sh
cleos push action eosio powerup '[user, user, 1, 10000000000000, 10000000000000, "1000.0000 EOS"]' -p user
```

<br />

To view the received NET and CPU weight as well as the amount of the fee, check the `eosio.reserv::powupresult` returned by the action, which should look similar to the one below:

<br />

```console
executed transaction: 82b7124601612b371b812e3bf65cf63bb44616802d3cd33a2c0422b58399f54f  144 bytes  521 us
#         eosio <= eosio::powerup               {"payer":"user","receiver":"user","days":1,"net_frac":"10000000000000","cpu_frac":"10000000000000","...
#   eosio.token <= eosio.token::transfer        {"from":"user","to":"eosio.rex","quantity":"999.9901 EOS","memo":"transfer from user to eosio.rex"}
#  eosio.reserv <= eosio.reserv::powupresult    {"fee":"999.9901 EOS","powup_net_weight":"16354","powup_cpu_weight":"65416"}
#          user <= eosio.token::transfer        {"from":"user","to":"eosio.rex","quantity":"999.9901 EOS","memo":"transfer from user to eosio.rex"}
#     eosio.rex <= eosio.token::transfer        {"from":"user","to":"eosio.rex","quantity":"999.9901 EOS","memo":"transfer from user to eosio.rex"}
```

<br />

The PowerUp resource model on the EOS blockchain is initialized with `"powerup_days": 1,`. This setting permits the maximum period to rent CPU and NET for 24 hours. If you do not use the resources within the 24 hour interval, the rented CPU and NET expires.

<br />

#### Process Expired Orders

The resources in loans that expire are not automatically reclaimed by the system. The expired loans remain in a queue that must be processed.

<br />

Any calls to the `powerup` action does process also this queue (limited to two expired loans at a time). Therefore, the expired loans are automatically processed in a timely manner. Sometimes, it may be necessary to manually process expired loans in the queue to release resources back to the system, which reduces prices. Therefore, any account may process up to an arbitrary number of expired loans if it calls the `powerupexec` action.

<br />

To view the orders table `powup.order` execute the following command:

<br />

```sh
cleos get table eosio 0 powup.order
```

<br />

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

<br />

Example `powerupexec` call:

<br />

```sh
cleos push action eosio powerupexec '[user, 2]' -p user
```

<br />

```console
executed transaction: 93ab4ac900a7902e4e59e5e925e8b54622715328965150db10774aa09855dc98  104 bytes  363 us
#         eosio <= eosio::powerupexec           {"user":"user","max":2}
warning: transaction executed locally, but may not be confirmed by the network yet         ]
```

</details>


### Subjective billing

To prevent spamming of the network, block producers can choose to enable subjective CPU & NET billing. This means that if a
transaction fails, the CPU & NET used to execute the transaction will still be billed to the account that sent the transaction.

This prevents accounts from spamming failing transactions to the network. However, this billing will not be 
recorded on the blockchain, and will not actually consume resources that the account paid for. It is only consumed
virtually by the block producer that processed the transaction.

Find more details about subjective billing in the [Introduction to subjective billing and lost transactions](https://eosnetwork.com/blog/api-plus-an-introduction-to-subjective-billing-and-lost-transactions/) article.



