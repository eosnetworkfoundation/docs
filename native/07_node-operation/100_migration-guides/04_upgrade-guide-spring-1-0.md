---
title: Spring 1.0 Upgrade Guide
---

## Purpose
This upgrade guide covers the steps for upgrading a node to Spring v1 from prior Leap versions. The Node Operator's guide [Switching Over To Savanna Consensus Algorithm](switch-to-savanna) covers the steps needed to upgrade the consensus algorithm. Node Producers will be interested in [Guide to Managing Finalizer Keys](../../advanced-topics/managing-finalizer-keys)

### Summary of Changes
- [Exceeding number of in flight requests or Mb in flight now returns HTTP 503](#updated-error-codes)
- [`v1/chain/get_block_header_state` has been updated](#get-block-header-state-changed)
- [`producer-threads` is no longer a supported option](#producer-threads-removed)
- [New v7 snapshot log format](#snapshot-format)
- [State logs no longer compressed](#state-log-history-compression-disabled)
- [Added BLS Finalizer Keys to support new consensus algorithm](#finalizer-keys)
- [New Finalizer Configuration Options](#new-finalizer-configuration-options)
- [New State History Configuration Options](#new-state-history-configuration-options)
- [New Vote-Threads Configuration Option](#new-vote-threads-option)

## Upgrade Steps

### Upgrade Steps for All Nodes
To quickly transition from Leap to Spring v1, nodeos must be restarted from a snapshot due to structural changes to the state memory storage. Snapshots from earlier versions of nodeos (including Leap v3 through v5) may be used to start a Spring node.

Below are example steps for restarting from snapshot on Ubuntu:
- Download latest release
    - Head to the [Spring Releases](https://github.com/AntelopeIO/spring/releases) to download the latest version
- Restart existing nodeos with `producer_api_plugin` enabled if it isn't already enabled
    - Pass `--plugin eosio::producer_api_plugin` on the command line, or `plugin = eosio::producer_api_plugin` in the config file
    - This plugin only needs to be enabled for the following step. Furthermore, unless this plugin is already being used, it's recommended to disable it after the following step.
- Create a new snapshot
    - `curl -X POST http://127.0.0.1:8888/v1/producer/create_snapshot`
      Wait until curl returns with a JSON response containing the filename of the newly created snapshot file. This step requires nodeos to continue receiving blocks from the p2p network, otherwise the `curl` command will never return.
- Stop nodeos
- Remove the `shared_memory.bin` file located in nodeos' data directory. This is the only file that needs to be removed. The data directory will be the path passed to nodeos' `--data-dir` argument, or `$HOME/local/share/eosio/nodeos/data/state` by default.
- Install new package
    - `apt-get install ./antelope-spring_1.0.0_amd64.deb`
- Restart nodeos with the snapshot file returned from the `create_snapshot` request above. Add the `--snapshot` argument along with any other existing arguments.
    - `nodeos --snapshot snapshot-1323.....83c5.bin ...`
      This `--snapshot` argument only needs to be given once on the first launch of nodeos.

### Additional Upgrade Steps for Producer Nodes
For producer nodes, in addition to the [Steps Above](#upgrade-steps-for-non-producer-nodes) there are a few other steps. Additional Documentation on BLS finalizer keys may be found in [Guide to Managing Finalizer Keys](../../advanced-topics/managing-finalizer-keys)

- Remove the unsupported `producer-threads` option from your configuration.
- Generate your key(s) using `spring-util`
   - `spring-util bls create key --file producer-name.finalizer.key`
- Add `signature-provider` to configuration with the generated Public and Private keys.
   - You may configure multiple `signature-provider`, and have multiple name/value pairs for `signature-provider`. Example in your configuration file
   ```
   signature-provider = PUB_BLS_S7aaZZ7ZdvnZ7Z7Za7SV7ZZZ-ZZtaa7ZaiLaaSPp7aZnaa7aZZnZd77BuS7ZZa7Zra7SU7ZZZZnaZaZZreZZZ7rraaZZZs7-i7Z7ive7aZZLZTas77VZtZL7a7aaZZaZL7sauZ=KEY:PVT_BLS_Z7tZLZZaZZ7o7LZ7aaa7uaBe7rLdPVZBpsZLrUaZZBUt-a7Z
   signature-provider = PUB_BLS_7ZLauuZ777ZvSa_Z7ZTrZaZ7_eraa7a7aUanv7aZZ7ZaaZdZaaadaZr-agi7_aoZa77aZZZZZaZU7aB7a7TZ-ZZu777777gaSaarZ7udZs7S-aZ-ZZZ_SBa-iZZPaZZZ7Za7rg=KEY:PVT_BLS_Znsaa7uZ7iZZ7uZ7aZZe7raTaaZaauZZa7aapUtuaZB7saLS
   signature-provider = PUB_BLS_ZZa-PZZZZaZZZZZZ7oae7_Z7a_UZsaZaLaaaSrZ7-Zaa7ada-ZaZZaZvppoSapgZd7aaouaZZZaZZZP7ZaavZdPaeZ7Zio77ZZaZLZZaZa7ZguaZpZ7raaPgZ77ZZUoZZ7Zeva=KEY:PVT_BLS_-oZ_ZZZPaae7TaaaZ7aZ7Zt7aaLZZat_7ZaVaraZLaaaaiga
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

### Snapshot Format
Spring v1 uses a new v7 snapshot format. The new v7 snapshot format is safe to use before, during, and after the switch to the Savanna Consensus Algorithm. Previous versions of Leap will not be able to use the v7 snapshot format.

### State History Changes
State history plugin has undergone many changes for Spring v1. Some of these are non-visible to improve reliability and performance, but there are important user facing changes to be aware of as well.

First, what hasn't changed: all prior state history clients will continue to work with Spring v1 unchanged. All prior state history logs can be used by Spring v1 as well.

Some minor tweaks to the log files are notable. Prior to Spring v1 state history log entries were compressed. This is no longer the case with Spring v1. Users who desire minimal disk usage from state history logs should consider using a filesystem that offers transparent compression, or utilize the existing `state-history-stride`/`max-retained-history-files` or `state-history-log-retain-blocks` options to limit the number of log entries in the state history files. Also notable, in Spring v1 log files created by different nodeos instances may no longer be byte-identical. The data returned to clients will remain identical, but the hash of log files may not be identical.

To accommodate new Savanna consensus information, a new `finality-data-history` option has been added that will create a third state history log which contains detailed Savanna state information that can be useful for some applications. Reading from this new log will require clients to use new `v1` state history messages such as `get_status_request_v1`, `get_blocks_request_v1`, `get_status_result_v1`, and `get_blocks_result_v1`. Clients may use these `v1` messages before Savanna is activated, but there will be no finality data returned until Savanna is activated even with `finality-data-history` enabled.

### New Finalizer Configuration Options
Scripts that move or delete the ‘data’ directory need to protect the finalizer safety file, or utilize this option to set another location for the finalizer safety.dat file.
- `finalizers-dir` - Specifies the directory path for storing voting history. Node Operators may want to specify a directory outside of their nodeos' data directory, and manage this as distinct file. More information in [Guide to Managing Finalizer Keys](../../advanced-topics/managing-finalizer-keys).

### New Vote-Threads Option
Where there is a block producing node that connects to its peers through an intermediate nodeos, the intermediate nodeos will need to have an integer value greater then for `vote-threads`. The default value for `vote-threads` is 4. When `vote-threads` is not an integer greater then zero votes are not propagated.
- `vote-threads` - Sets the number of threads to handle voting. The default is sufficient for all know production setups, and the recommendation is to leave this value unchanged.
