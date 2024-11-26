---
title: EOS EVM Node Setup
---

Now that you have the EOS EVM software built, you can start running it to serve read requests from the EVM.

> ❕ **Go through the basic setup first**
>
> If you haven't already, go through the [basic setup](./10_basic-setup.md) first. You will need to get and build the
> EOS EVM software and set up your miner accounts before you can go through this guide.

## Brief architecture overview

We will be setting up the two primary components that make up the  EOS EVM Node software:
#### eos-evm-node
This process takes blocks from the EOS Network nodes and converts them into EVM compatible blocks in a deterministic way.
It also serves read requests to the `eos-evm-rpc` process.

#### eos-evm-rpc
This process provides Ethereum compatible RPC endpoints. It queries state (including blocks, 
accounts, and storage) from the `eos-evm-node` process, and it can also run view actions requested by clients.

## The EVM requires an EOS Native node

The EOS EVM software is designed to connect to an EOS Native node.

This guide will not show you how to run an EOS Native node, but there are public nodes that you can connect to. 
You can find a list of public nodes [on EOS Nation's website](https://validate.eosnation.io/eos/reports/endpoints.html).


> ⚠ **SHiP Node Required**
>
> The `eos-evm-node` requires that you specify a `SHiP` node with the following plugins:
> - `trace_history`
> - `state_history_plugin`
> 
> _Most public nodes do not have these plugins enabled on their primary infrastructure, so you may need
> to reach out to the node operator to request that they enable these plugins for you, or give you access to their 
> nodes which have these plugins enabled._


## Getting ready

> ⚠ **Paths in this guide** 
> 
> The guide assumes your EOS EVM directory is located at `~/eos-evm`.
> 
> If you have it located somewhere else, you will need to adjust the commands accordingly.

### Set up your genesis file

The `genesis.json` is a file that is used to initialize the state of the EVM when you start your node, and contains important information about the
EVM on the network you are trying to sync up with (or create). 

#### This is the `genesis.json` for the EOS EVM on Mainnet:
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

Save this file to `~/eos-evm/genesis.json`

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
If the `eosio.evm` account name is used, then set the nonce to `0x5530ea015b900000`. 
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
        "nonce": "0x5530ea015b900000",
        "timestamp": "0x63773b2a"
    }

```
    

The function `convert_name_to_value` from https://github.com/eosnetworkfoundation/eos-evm/blob/main/tests/leap/antelope_name.py can be used to get the appropriate nonce value using Python:

```shell
>>> from antelope_name import convert_name_to_value
>>> print(f'0x{convert_name_to_value("evmevmevmevm"):x}')
0x56e4adc95b92b720
>>> print(f'0x{convert_name_to_value("eosio.evm"):x}')
0x5530ea015b900000
```
    
    
</details>


### Create a place to store chain data

```bash
mkdir ~/eos-evm/chain-data
```

### Create your configuration files


Create a file at `~/eos-evm/config-dir/config.ini`, paste in the config below, and change the `ship-endpoint` to your own.

```ini
# Change this SHiP endpoint to your own:
ship-endpoint = YOUR_EOS_NATIVE_API_NODE

# ------------------------------------ #
# The rest of this file can stay as-is #
# ------------------------------------ #

# chain data path as a string (engine_plugin)
chain-data = chain-data

# engine address of the form <address>:<port> (engine_plugin)
# engine-port = 127.0.0.1:8080

# number of worker threads (engine_plugin)
# threads = 16

# file to read EVM genesis state from (engine_plugin)
genesis-json = genesis.json

# maximum number of database readers (engine_plugin)
# max-readers = 1024

# Account on the core blockchain that hosts the EOS EVM Contract (ship_receiver_plugin)
ship-core-account = eosio.evm

# Override Antelope block id to start syncing from (ship_receiver_plugin)
# ship-start-from-block-id = 

# Timestamp for the provided ship-start-from-block-id, required if block-id provided (ship_receiver_plugin)
# ship-start-from-block-timestamp = 

# verbosity level (sys_plugin)
verbosity = 5

# output to stdout instead of stderr (sys_plugin)
# stdout = false

# disable logging color (sys_plugin)
# nocolor = false

# optionally tee logging into specified file (sys_plugin)
# log-file = ar

# Plugin(s) to enable, may be specified multiple times
plugin = block_conversion_plugin
plugin = blockchain_plugin
```

Now create another file at `~/eos-evm/config-dir/rpc.ini` and paste in the following:
    
```ini
# http port for JSON RPC of the form <address>:<port> (rpc_plugin)
# http-port = 127.0.0.1:8881

# engine port for JSON RPC of the form <address>:<port> (rpc_plugin)
# rpc-engine-port = 127.0.0.1:8882

# address to eos-evm-node of the form <address>:<port> (rpc_plugin)
# eos-evm-node = 127.0.0.1:8001

# number of threads for use with rpc (rpc_plugin)
# rpc-threads = 16

# directory of chaindata (rpc_plugin)
chaindata = chain-data

# maximum number of rpc readers (rpc_plugin)
# rpc-max-readers = 16

# comma separated api spec, possible values: debug,engine,eth,net,parity,erigon,txpool,trace,web3 (rpc_plugin)
api-spec = eth,net

# override chain-id (rpc_plugin)
chain-id = 17777
```

### Start the EVM chain

```bash
cd ~/eos-evm

# start the eos-evm-node
eos-evm-node 

# start the eos-evm-rpc
eos-evm-rpc --config rpc.ini
```











