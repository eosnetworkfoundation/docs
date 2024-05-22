---
title: Spring 1.0 Upgrade Guide
---

## Summary
This upgrade guide covers the steps for upgrading the Spring binary from a Leap v5 binary. The Node Operator's guide [Switching Over To Savanna Consensus Algorithm](switch-to-savanna.md) covers the steps needed to upgrade the consensus algorithm. Node Producers will be interested in [Guide to Managing Finalizer Keys](/native/advanced-topics/managing-finalizer-keys.md)

## HTTP Changes

### Updated Error Codes
The HTTP error return code for exceeding `http-max-bytes-in-flight-mb` or `http-max-in-flight-requests` is now `503`, whereas in Leap 5.0.2, it was `429`.

### Get Block Header State Changed.
In the past, get_block_header_state returned the pre-Savanna (legacy) block header state. Parts of this response are incompatible with the internals of the new Savanna block state. Originally the plan was to remove the get_block_header_state endpoint, but some versions of eosjs, including the latest one, 22.1.0, require operation of this endpoint given certain values of blocksBehind otherwise eosjs will be unable to push a transaction.

Instead of deprecating the endpoint has been updated with behavioral differences. No matter whether Savanna has been activated or not, get_block_header_state in Spring 1.0 will return a response containing all fields but with only block_num, id, header, and additional_signatures filled out. Other fields will still exist but will be empty or zero. Additionally, the endpoint will consider both reversible and irreversible blocks. This latter tweak helps guard against a race condition in eosjs between calling get_info and then get_block_header_state when blocksBehind is a low number such as 2 or 3.

An example response with the limited filled fields looks something like,
```
{
  "block_num": 40660,
  "dpos_proposed_irreversible_blocknum": 0,
  "dpos_irreversible_blocknum": 0,
  "active_schedule": {
    "version": 0,
    "producers": []
  },
  "blockroot_merkle": {
    "_active_nodes": [],
    "_node_count": 0
  },
  "producer_to_last_produced": [],
  "producer_to_last_implied_irb": [],
  "valid_block_signing_authority": [
    0,
    {
      "threshold": 0,
      "keys": []
    }
  ],
  "confirm_count": [],
  "id": "00009ed4aa662f3d7e96d88061e4741692b433fe783befc6c3cb6c6a40c5955a",
  "header": {
    "timestamp": "2024-03-19T02:39:40.000",
    "producer": "inita",
    "confirmed": 0,
    "previous": "00009ed38d8d4c103ce5ced75558d6ac0f4d2ac4b63cf964feeb6d8bce600ade",
    "transaction_mroot": "0000000000000000000000000000000000000000000000000000000000000000",
    "action_mroot": "b179283d2264aa663cb669924bbff2f33e81a7ed71dcb465342673602605a1f1",
    "schedule_version": 2,
    "header_extensions": [
      [
        2,
        "d39e0000010000"
      ]
    ],
    "producer_signature": "SIG_K1_KgufADyFuHdBwT6VGBVdrnhVs6dakZdXp4qr5NgJFU7orfXbFi9eVc7NvjrjvUyL79SXfMjgyzW7cVGfQW8iy1CbjStENZ"
  },
  "pending_schedule": {
    "schedule_lib_num": 0,
    "schedule_hash": "0000000000000000000000000000000000000000000000000000000000000000",
    "schedule": {
      "version": 0,
      "producers": []
    }
  },
  "activated_protocol_features": null,
  "additional_signatures": []
}
```

## Deprecations & Removals

### Producer Threads Removed
As of Spring v1, node operators MUST ensure the following parameters are NOT set in config.ini to allow nodeos to start:
- `producer-threads`

The configuration option `producer-threads` has been remove to enable greater efficiency and lower latencies. Some of the work has been offloaded to `chain-threads` and block producers may experiment with increasing the later threading configuration.

## Updates and Changes

### Snapshot Format
Spring v1 uses a new v7 snapshot format. The new v7 snapshot format is safe to use before, during, and after the switch to the Savanna Consensus Algorithm. Previous versions of Leap will not be able to use the v7 snapshot format.

### SHiP
State history log file compression has been disabled. Consumers with state history will need to put together their own compression.

## New & Modified Options

### New config options
- `finalizers-dir` - Specifies the directory path for storing voting history. Node Operators may want to specify a directory outside of their nodeos' data directory, and manage this as distinct file. More information in [Guide to Managing Finalizer Keys](/native/advanced-topics/managing-finalizer-keys.md).
- `finality-data-history` - When running SHiP to support Inter-Blockchain Communication (IBC) set `finality-data-history = true`. This will enable the new field, `get_blocks_request_v1`. The `get_blocks_request_v1` defaults to `null` before Savanna Consensus is activated.
- `vote-threads` - Sets the number of threads to handle voting. The default is sufficient for all know production setups, and the recommendation is to leave this value unchanged.

### Finalizer Keys
The Savanna Consensus algorithm utilized by Spring v1 separates the roles of publishing blocks from signing and finalizing blocks. Finalizer Keys are needed to sign and finalize blocks. In Spring v1, all block producers are expected to be finalizers. There are three steps to creating finalizer keys
- generate your key(s) using `spring-utils`
- add `signature-provided` to configuration with the generated key(s)
- register a single key on chain with the `regfinkey` action

Additional Documentation may be found in [Guide to Managing Finalizer Keys](/native/advanced-topics/managing-finalizer-keys.md)
