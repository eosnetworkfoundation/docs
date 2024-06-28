---
title: Spring 1.0 Upgrade Guide
---

## Purpose
This upgrade guide covers the steps for upgrading a node to the Spring binary from a Leap v5 binary. The Node Operator's guide [Switching Over To Savanna Consensus Algorithm](switch-to-savanna) covers the steps needed to upgrade the consensus algorithm. Node Producers will be interested in [Guide to Managing Finalizer Keys](../../advanced-topics/managing-finalizer-keys)

### Summary of Changes
- [Exceeding number of in flight requests or Mb in flight now returns HTTP 503](#updated-error-codes)
- [`v1/chain/get_block_header_state` has been updated](#get-block-header-state-changed)
- [`producer-threads` is no longer a supported option](#producer-threads-removed)
- [New v7 snapshot log format](#snapshot-format)
- [State logs no longer compressed](#state-log-history-compression-disabled)
- [Added BLS Finalizer Keys to support new consensus algorithm](#finalizer-keys)
- [New Finalizer Configuration Options](#new-finalizer-configuration-options)
- [New Vote-Threads Configuration Option](#new-vote-threads-option)

## Upgrade Steps

### Upgrade Steps for Non-Producer Nodes
Spring v1 must restart from a snapshot or recovered from a full transaction sync due to structural changes to the state memory storage. Snapshots from version 3.1 and higher of nodeos may be used to start a Spring node.

Below are example steps for restarting from snapshot on ubuntu:
- Download latest release
    - Head to the [Spring Releases](https://github.com/AntelopeIO/spring/releases) to download the latest version
- Create a new snapshot
    - `curl -X POST http://127.0.0.1:8888/v1/producer/create_snapshot`
      Wait until curl returns with a JSON response containing the filename of the newly created snapshot file.
- Stop nodeos
- Remove old package
    - `sudo apt-get remove -y leap`
- Remove the `shared_memory.bin` file located in nodeos' data directory. This is the only file that needs to be removed. The data directory will be the path passed to nodeos' `--data-dir` argument, or `$HOME/local/share/eosio/nodeos/data/state` by default.
- Install new package
    - `apt-get install -y ./antelope-spring_1.0.0_amd64.deb`
- Restart nodeos with the snapshot file returned from the `create_snapshot` request above. Add the `--snapshot` argument along with any other existing arguments.
    - `nodeos --snapshot snapshot-1323.....83c5.bin ...`
      This `--snapshot` argument only needs to be given once on the first launch of a 5.x nodeos.

### Upgrade Steps for Producer Nodes
For producer nodes, in addition to the [Steps Above](#upgrade-steps-for-non-producer-nodes) there are a few other steps. Additional Documentation on BLS finalizer keys may be found in [Guide to Managing Finalizer Keys](../../advanced-topics/managing-finalizer-keys)

- Remove the unsupported `producer-threads` option from your configuration.
- Generate your key(s) using `spring-utils`
   - `spring-util bls create key --to-console > producer-name.finalizer.key`
- Add `signature-provider` to configuration with the generated Public and Private keys.
   - You may configure multiple `signature-provider`, and have multiple name/value pairs for `signature-provider`. Example in your configuration file
   ```
   signature-provider = PUB_BLS_S7aaZZ7ZdvnZ7Z7Za7SV7ZZZ-ZZtaa7ZaiLaaSPp7aZnaa7aZZnZd77BuS7ZZa7Zra7SU7ZZZZnaZaZZreZZZ7rraaZZZs7-i7Z7ive7aZZLZTas77VZtZL7a7aaZZaZL7sauZ=ZZZ:PVT_BLS_Z7tZLZZaZZ7o7LZ7aaa7uaBe7rLdPVZBpsZLrUaZZBUt-a7Z
   signature-provider = PUB_BLS_7ZLauuZ777ZvSa_Z7ZTrZaZ7_eraa7a7aUanv7aZZ7ZaaZdZaaadaZr-agi7_aoZa77aZZZZZaZU7aB7a7TZ-ZZu777777gaSaarZ7udZs7S-aZ-ZZZ_SBa-iZZPaZZZ7Za7rg=ZZZ:PVT_BLS_Znsaa7uZ7iZZ7uZ7aZZe7raTaaZaauZZa7aapUtuaZB7saLS
   signature-provider = PUB_BLS_ZZa-PZZZZaZZZZZZ7oae7_Z7a_UZsaZaLaaaSrZ7-Zaa7ada-ZaZZaZvppoSapgZd7aaouaZZZaZZZP7ZaavZdPaeZ7Zio77ZZaZLZZaZa7ZguaZpZ7raaPgZ77ZZUoZZ7Zeva=ZZZ:PVT_BLS_-oZ_ZZZPaae7TaaaZ7aZ7Zt7aaLZZat_7ZaVaraZLaaaaiga
   ```
- For your producer account register at least one key on chain with the `regfinkey` action. When there are no registered BLS keys calling `regfinkey` will activate the provided key.
  - Here is an example for the producer account `NewBlockProducer`
  ```
  cleos push action eosio regfinkey '{"finalizer_name":"NewBlockProducer", \
        "finalizer_key":"PUB_BLS_SvLa9z9kZoT9bzZZZ-Zezlrst9Zb-Z9zZV9olZazZbZvzZzk9r9ZZZzzarUVzbZZ9Z9ZUzf9iZZ9P_kzZZzGLtezL-Z9zZ9zzZb9ZitZctzvSZ9G9SUszzcZzlZu-GsZnZ9I9Z", \
        "proof_of_possession":"SIG_BLS_ZPZZbZIZukZksBbZ9Z9Zfysz9zZsy9z9S9V99Z-9rZZe99vZUzZPZZlzZszZiiZVzT9ZZZZBi99Z9kZzZ9zZPzzbZ99ZZzZP9zZrU-ZZuiZZzZUvZ9ZPzZbZ_yZi9ZZZ-yZPcZZe9SZZPz9Tc9ZaZ999voB99L9PzZ99I9Zu9Zo9ZZZzTtVZbcZ-Zck_ZZUZZtfTZGszUzzBTZZGrnIZ9Z9Z9zPznyZLZIavGzZunreVZ9zZZt_ZlZS9ZZIz9yUZa9Z9-Z"}' \
        -p NewBlockProducer
  ```

## HTTP Protocol Changes

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

### State Log History Compression Disabled
State history log file compression has been disabled. Consumers with state history will need to put together their own compression.

## New & Modified Options

### New Finalizer Configuration Options
- `finalizers-dir` - Specifies the directory path for storing voting history. Node Operators may want to specify a directory outside of their nodeos' data directory, and manage this as distinct file. More information in [Guide to Managing Finalizer Keys](../../advanced-topics/managing-finalizer-keys).
- `finality-data-history` - When running SHiP to support Inter-Blockchain Communication (IBC) set `finality-data-history = true`. This will enable the new field, `get_blocks_request_v1`. The `get_blocks_request_v1` defaults to `null` before Savanna Consensus is activated.
- `vote-threads` - Sets the number of threads to handle voting. The default is sufficient for all know production setups, and the recommendation is to leave this value unchanged.

### New Vote-Threads Option
Where there is a block producing node that connects to its peers through an intermediate nodeos, the intermediate nodeos will need to have an integer value greater then for `vote-threads`. The default value for `vote-threads` is 4. When `vote-threads` is not an integer greater then zero votes are not propagated.
