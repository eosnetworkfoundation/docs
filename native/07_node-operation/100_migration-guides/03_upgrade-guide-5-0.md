---
title: Leap 5.0 Upgrade Guide
---

To see the 5.0 release notes, click [here](https://github.com/AntelopeIO/leap/releases/tag/v5.0.0-rc2).

## Deprecations & Removals

### Deferred Transactions Removed
Deferred Transactions were previously deprecated and have been removed. No new deferred transactions may be created. Existing deferred transactions, will be blocked from executing.

### Get Block Header State Deprecated
As of Leap v5.0.0 `v1/chain/get_block_header_state` is deprecated. It will be removed in Leap v6.0.0.

## Restart from Snapshot Required
nodeos 5.0 must be restarted from a snapshot, or recovered from a full transaction sync due to structural changes to the state memory storage. Snapshots from any version of nodeos may be used to start a 5.0 node.

Below are example steps for restarting from snapshot on ubuntu:
- Download latest release
    - Head to the [Leap Releases](https://github.com/AntelopeIO/leap/releases) to download the latest version
- Create a new snapshot
    - `curl -X POST http://127.0.0.1:8888/v1/producer/create_snapshot`
      Wait until curl returns with a JSON response containing the filename of the newly created snapshot file.
- Stop nodeos
- Remove old package
    - `sudo apt-get remove -y leap`
- Remove the `shared_memory.bin` file located in nodeos' data directory. This is the only file that needs to be removed. The data directory will be the path passed to nodeos' `--data-dir` argument, or `$HOME/local/share/eosio/nodeos/data/state` by default.
- Install new package
    - `apt-get install -y ./leap_5.0.0_amd64.deb`
- Restart nodeos with the snapshot file returned from the `create_snapshot` request above. Add the `--snapshot` argument along with any other existing arguments.
    - `nodeos --snapshot snapshot-1323.....83c5.bin ...`
      This `--snapshot` argument only needs to be given once on the first launch of a 5.x nodeos.

## Required Configuration Changes
The following changes to configuration are required for nodes running Leap 5+ to function correctly.

### Unsupported Configuration Parameters
As of Leap v5.0.0, node operators MUST ensure the following parameters are NOT set in config.ini to allow nodeos to start:
- `cpu-effort-percent`
- `last-block-cpu-effort-percent`
- `last-block-time-offset-us`
- `produce-time-offset-us`
- `max-nonprivileged-inline-action-size`
- `max-scheduled-transaction-time-per-block-ms`
- `disable-subjective-billing` (see "Enabling subjective billing for APIs and Block Relays" below)

### Enabling subjective billing for APIs and Block Relays
APIs and Block Relays will need to enable subjective billing. Previously `disable-subjective-billing` could be set to false, but this option has been removed in Leap v5.0.0, because it was redundant with the more specific options. To enable Subjective Billing on a node running Leap v5.0.0, ensure that the following configuration values are set in config.ini:

```
disable-subjective-api-billing=false
disable-subjective-p2p-billing=false
```

## Recommended Configuration Changes
The following changes to configuration are recommended for nodes running Leap 5+

### Modify Transaction Time Windows
- Comment out / Remove `max-transaction-time`, or set to a value above the on-chain limit (eg more than 150ms on EOS)
- Set `read-only-read-window-time-us` to 165,000 (165ms)

These updates are based on performance testing along with empirical data. In production environments, we have noticed cases of transactions exceeding the 30ms limit, and we recommend increasing the time window. `max-transaction-time` should be removed to allow enforcement of the transaction wall-clock deadline to be driven by the objective on-chain limit.

All read actions are performed in parrellel. For example`get_table_rows` rpc is run in parrallel inside the read window. For this reason the read-only time window needs to be bigger. Transactions are either read only or not read only. Transactions do not have read-only components.

> Note:the read-only configuration changes apply only to Leap Versions 4.x and later.

### Remove Prometheus Exporter Address
- remove `prometheus-exporter-address` from config.ini

This has been replaced with the new `prometheus` api endpoint category implemented as part of https://github.com/antelopeIO/leap/pull/1137

## New & Modified Options
### New commmand line options
- `sync-peer-limit` can limit the number of peers to sync from. The Default value is 3.
- `eos-vm-oc-enable` has a new mode `auto` which automatically uses OC when building blocks, applying blocks, executing transactions from HTTP or P2P, and executing contracts on eosio.* accounts (eosio, eosio.token, eosio.ibc, and eosio.evm). `eos-vm-oc-enable=auto` is the new default.

### New config options
- `http-category-address` can be used to configure all addresses in command line and ini file. The option can be used multiple times as needed.

### Modified option behavior
- Specify `--p2p-listen-endpoint` and `--p2p-server-address` multiple times
- `sync-fetch-span` default changed from 100 to 1000
- `disable-replay-opts` is automatically set to true if state history plugin is enabled. This option may be specified in a configuration file
- `read-only-threads` can now be set to a max of 128
- `abi-serializer-max-time-ms` has been updated to limit time spent serializaing object on the main thread, and deserializing single objects on the HTTP threads.
- The default value of `http-max-response-time-ms` has been changed from 30ms to 15ms
