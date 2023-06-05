---
title: Snapshots
---

A snapshot is a capture of the blockchain state at a specific point in time. It includes the sum of all changes that 
have occurred up until that point from transaction executions. This means that it includes all created accounts, contract code,
contract data, and anything else that was created or modified on the blockchain.

It does not however include the blockchain history. This means that it does not include the transactions themselves. These
are stored in the `blocks.log` file. 

## Syncing a fresh node

To speed up the syncing process, you can download a snapshot and import it into your node. This will allow you to skip
parts of the process that would otherwise take longer.

### Required configuration

You should have the following plugins enabled in your `config.ini` file:

```ini
plugin = eosio::chain_plugin
plugin = eosio::chain_api_plugin
plugin = eosio::net_plugin
plugin = eosio::net_api_plugin
plugin = eosio::producer_plugin
plugin = eosio::producer_api_plugin
plugin = eosio::state_history_plugin
```

### Getting a snapshot

Below are some sites where you can download a recent snapshot:

- [EOS Nation](https://snapshots.eosnation.io/)
- [EOS Sweden](https://snapshots-main.eossweden.org/)

### Before you start

You should clear out your node's `data/state` directory. 

### Importing the snapshot

Now you can import the snapshot into your node:

```shell
nodeos --snapshot /path/to/snapshot.bin
```

> ⚠ **Warning**
> 
> Do not stop the node until it has received at least 1 block from the network, or it won't be able to restart.

### If your node fails to receive blocks

If nodeos fails to receive blocks from the network, then try using `cleos net disconnect` 
and `cleos net connect` to reconnect nodes which timed out.

> ⚠ **Warning**
> 
> Caution when using `net_api_plugin`. Either use a firewall to block access to your `http-server-address`, or change 
> it to `localhost:8888` to disable remote access.

### Using a database filler

If you are using a database filler, you need to look for `Placing initial state in block <block_num>` in the log. 

Then you can start a filler with the following arguments:
```shell
... --fpg-create --fill-skip-to <block_num> --fill-trim
```

**On subsequent runs, you should not use the `--fpg-create` and `--fill-skip-to` arguments.**


## Creating a snapshot with full state history

Creating snapshots allows you to create a backup of your node's state. This can be useful if you want to create periodic 
backups of your node, or if you want to create a snapshot to share with others.

### Creating the snapshot

```shell
curl http://127.0.0.1:8888/v1/producer/create_snapshot
```

The command above taps into your `producer_api_plugin` and creates a snapshot. The snapshot will be saved in the
`data/snapshots` directory.

Wait for `nodeos` to process several blocks after the snapshot completed. The goal is for the state-history files to 
contain at least 1 more block than the portable snapshot has, and for the `blocks.log` file to contain the block after 
it has become irreversible.

> ⚠ **Warning**
> 
> If the block included in the portable snapshot is forked out, then the snapshot will be invalid. Repeat this process if this happens.

### Collecting the other files

The snapshot created above only contains the state at the time of capture. It does not include the blockchain history.

To create a full package that you can use to quickly sync a node, you need to collect the following files:
- The contents of `data/state-history`
  - `chain_state_history.log`
  - `trace_history.log`
  - `chain_state_history.index` - optional: Restoring will take longer without this file.
  - `trace_history.index` - optional: Restoring will take longer without this file.
- Optional: `data/blocks`, but excluding `data/blocks/reversible`


## Restoring a snapshot with full state history

The process is almost identical to the process for syncing a fresh node. The only difference is that you need to copy
the files from the previous section into the `data` directory before starting the node.

The more of the **optional** files you include, the faster the node will sync.

## Replay / Resync with full state history

Replaying or resyncing a node will ensure that the node is in sync with the network. This is useful if you want to 
resync your node after a crash.

You can either delete the `data/state` directory, or use the `--replay-blockchain` argument.

```shell
nodeos --replay-blockchain --snapshot /path/to/snapshot.bin
```
