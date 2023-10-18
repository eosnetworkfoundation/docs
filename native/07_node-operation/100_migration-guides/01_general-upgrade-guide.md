---
title: General Upgrade Guide
---

This guide will walk you through the steps you need to take to upgrade your node.
Keep in mind that this is a general guide, and some releases might require additional steps that need
to be taken. If there is a specific upgrade guide for a release you should follow that guide instead (though it might 
refer to this guide for general steps).

## Planning for the upgrade

- **Do not** test upgrades on your production node, use a test node first
- The supported operating systems are:
  - **Ubuntu 20.04 Focal**
  - **Ubuntu 22.04 Jammy**
- **Do not** use deprecated plugins
- **Enable all** new required plugins
- **Make a backup** of your node


## Upgrading your node

Follow these steps in order. If you have any questions, please ask in the [Telegram group](https://t.me/AntelopeIO).

### 1. Download / build binaries

If you want to build and install from source, you can follow the instructions in the [README](https://github.com/AntelopeIO/leap#build-and-install-from-source).

If you want to use the binaries, you can download them from the [releases page](https://github.com/AntelopeIO/leap/releases).

### 2. Make a snapshot

Before you install new binaries or stop your nodes, you should make a snapshot. 
This will allow you to quickly recover in case something goes wrong, and use it to replay your node.

To make a snapshot, run the following command **on your producer node**:

```bash
curl -X POST http://127.0.0.1:8888/v1/producer/create_snapshot
```

Wait until curl returns with a `JSON` response containing the filename of the newly created snapshot file.

You can also grab a snapshot from trusted sources like [EOS Nation](https://snapshots.eosnation.io/), but make
sure you have a snapshot for the right network, and snapshot version.


### 3. Stop your node

Now that you have created a snapshot, you can stop your node.

### 4. Remove old files

Remove the `data/state/shared_memory.bin` file.

> ❔ **Where is my `data` directory?**
>
> The `data` directory will be the path passed to `nodeos --data-dir` argument, or `$HOME/local/share/eosio/nodeos/data/state` by default

<details>
  <summary>If you need history (SHiP)</summary>

**Warning**: Replaying can take weeks.

You may also need to remove the `data/blocks` directory
if the release you are upgrading to has a different block log format.
If a block log is incompatible you will need to sync from the network or download a
compatible block log from a trusted source.

Each individual upgrade guide will tell you if the block log format is
incompatible.

Additionally, you will need to delete `SHiP`.
If you have a block log compatible with the release you are upgrading to,
you can simply replay locally from that block log instead of syncing from the network.

Here are some tips for speeding up replays:
- Raise `-–sync-fetch-span` while replaying (revert back to default after replay for stability!)
- Use peers with a full `blocks.log` only
- Keep your `p2p-peer-address` list short, only with the closest nodes
- You can quickly sync from a single peer located in the same datacenter, even if it is not on the same version
  - You can do the same on the same machine, but you will need new `/blocks` and `/state` directories + more NVMe space
- You can copy the `blocks.log` from another machine if it is compatible

#### List of peer nodes with blocks.log files extending to genesis:
```bash
EOS:
eos.seed.eosnation.io:9876
peer1.eosphere.io:9876
peer2.eosphere.io:9876
p2p.genereos.io:9876

EOS Jungle4 Testnet:
peer1-jungle4.eosphere.io:9876
jungle4.seed.eosnation.io:9876
jungle4.genereos.io:9876
jungle.p2p.eosusa.io:9883
```

</details>

### 5. Remove old configuration options and plugins and add any new ones

Each release could have deprecated, end-of-lifed, or new plugins.
With these changes you might need to remove old configuration options and plugins, or add new plugins which
generally include new configuration options.

If the release you are upgrading to has any of these changes, you will find them in the release notes or
in a guide specific to that release from the list on the left (or hamburger menu on mobile).

### 6. Update your binaries

First, remove your old binary:

```bash
sudo apt-get remove -y leap
# or 
sudo dpkg --remove <old-pkg-name>
```

Then, install the new binaries:

```bash 
sudo apt-get install -y ./leap[-_][0-9]*.deb
# or
sudo dpkg -i <filename>.deb
```

### 7. Start your node

Start your node with the snapshot you created/downloaded in step 2.

To learn how to start snapshots and more information about them read the [snapshots guide](../10_getting-started/50_snapshots.md).





