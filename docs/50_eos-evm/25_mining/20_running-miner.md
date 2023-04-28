---
title: Running an EVM Miner
---

You are going to run an EOS EVM Miner connected to the EOS mainnet. This miner will take EVM transactions and convert them into EOS transactions
which it will then send to the `eosio.evm` contract on the EOS mainnet.

You will also run an RPC node which will allow you to interact with the data in a way that is standard for Ethereum developers and tooling.

> ❕ **Go through the basic setup first**
> 
> If you haven't already, go through the [basic setup](./10_basic-setup.md) first. You will need to get and build the 
> EOS EVM software and set up your miner accounts before you can go through this guide.

## You must connect with an EOS native node

The EOS EVM software is designed to connect to an EOS node that is running the `state_history_plugin`. This plugin is required to get the data
needed to run the EVM. 

This guide will not show you how to run an EOS node, but there are many public nodes that you can connect to. You can find a list of public nodes
[on EOS Nation's website](https://validate.eosnation.io/eos/reports/endpoints.html).

## Setting up your environment

The guide assumes your EVM directory is located at `~/eos-evm`. If you have it located somewhere else, you will need to adjust the commands accordingly.

### Set up your genesis file

The genesis file is a file that is used to initialize the state of the EVM when you start your node, and contains important information about the
EVM on the network you are trying to sync up with (or create). 

```bash
{
    "alloc": {
        "0000000000000000000000000000000000000000": {
            "balance": "0x0000000000000000000000000000000000000000000000000000000000000000" 
        }
    },
    "coinbase": "0x0000000000000000000000000000000000000000",
    "config": {
        "chainId": 17777,
        "homesteadBlock": 0,
        "eip150Block": 0,
        "eip155Block": 0,
        "byzantiumBlock": 0,
        "constantinopleBlock": 0,
        "petersburgBlock": 0,
        "istanbulBlock": 0,
        "trust": {}
    },
    "difficulty": "0x01",
    "extraData": "EOSEVM",
    "gasLimit": "0x7ffffffffff",
    "mixHash": "0x120eb7a4e6a75f1ae89e9da3bd979c263b14b8b2ccdf1892962cbad6bc650c93",
    "nonce": "0x5530ea015b900000",
    "timestamp": "0x642cda61"
}
```

Save this file to `genesis.json` (`~/eos-evm/genesis.json`)

_If you are connecting to a different network, you will need to build this file yourself._
<details>
    <summary>You can find more information about that process here</summary>

check the current config table:
```
./cleos -u <API_URL> get table eosio.evm eosio.evm config
{
  "rows": [{
      "version": 0,
      "chainid": 15555,
      "genesis_time": "2022-11-18T07:58:34",
      "ingress_bridge_fee": "0.0100 EOS",
      "gas_price": "150000000000",
      "miner_cut": 10000,
      "status": 0
    }
  ],
  "more": false,
  "next_key": ""
}
```

take the above example, we need to find out the block number `x` (`2022-11-18T07:58:34` in our case).
Once we have decided the starting block number `x`, the next step is to build up the correct genesis for the virtual Ethereum chain.

Block 2:

```json
{
  "timestamp": "2022-11-18T07:58:34.000",
  "producer": "eosio",
  "confirmed": 0,
  "previous": "0000000177f4004274497e5d085281578f907ebaa10f00d94b9aa3a9f39e3393",
  "transaction_mroot": "0000000000000000000000000000000000000000000000000000000000000000",
  "action_mroot": "e8fd9bd7b16564c9133c1da207a557554b0f74cb96034c3ed43af295d20d9d13",
  "schedule_version": 0,
  "new_producers": null,
  "producer_signature": "SIG_K1_K6MSRQA3aJ9nRWMGG9vLMJWgvDGPvUNq3QWKkNCPmvTCGMg6vsoHeyFL384t8dMDhSA46YS5vqtvTGF8hezcBRpypWk1eX",
  "transactions": [],
  "id": "000000026d392f1bfeddb000555bcb03ca6e31a54c0cf9edc23cede42bda17e6",
  "block_num": 2,
  "ref_block_prefix": 11591166
}
```

Using the following JavaScript to get the time difference in second between `1970-01-01` and `2022-11-18T07:58:34.000` in hex form:

```javascript
console.log('0x'+(new Date("2022-11-18T07:58:34.000").getTime()/1000|0).toString(16))
// or using python
python3 -c 'from datetime import datetime; print(hex(int((datetime.strptime("2022-11-18T07:58:34.000","%Y-%m-%dT%H:%M:%S.%f")-datetime(1970,1,1)).total_seconds())))'
```

Result:

```txt
0x63773b2a
```

This determines the value of the "timestamp" field in EVM genesis.

Set the `mixHash` field to be "0x + <starting block id>", e.g.  "0x000000026d392f1bfeddb000555bcb03ca6e31a54c0cf9edc23cede42bda17e6"

Set the `nonce` field to be the hex encoding of the value of the EOS account name of the EVM contract. 
If the `eosio.evm` account name is used, then set the nonce to `0x56e4adc95b92b720`. 
This is re-purposed to be the block time (in mill-second) of the EVM chain.

Final EVM genesis example:

```json
{
        "alloc": {
            "0x0000000000000000000000000000000000000000": {
                "balance": "0x0000000000000000000000000000000000000000000000000000000000000000"
            }
        },
        "coinbase": "0x0000000000000000000000000000000000000000",
        "config": {
            "chainId": 15556,
            "homesteadBlock": 0,
            "eip150Block": 0,
            "eip155Block": 0,
            "byzantiumBlock": 0,
            "constantinopleBlock": 0,
            "petersburgBlock": 0,
            "istanbulBlock": 0,
            "trust": {}
        },
        "difficulty": "0x01",
        "extraData": "EOSEVM",
        "gasLimit": "0x7ffffffffff",
        "mixHash": "0x000000026d392f1bfeddb000555bcb03ca6e31a54c0cf9edc23cede42bda17e6",
        "nonce": "0x56e4adc95b92b720",
        "timestamp": "0x63773b2a"
    }

```
</details>


### Create a place to store chain data 

```bash
mkdir ~/eos-evm/chain-data
```

### Start the EVM chain

```bash
cd ~/eos-evm

eos-evm-node --chain-data ./chain-data --plugin block_conversion_plugin --plugin blockchain_plugin --nocolor 1 --verbosity=5 --genesis-json=./genesis.json
```











