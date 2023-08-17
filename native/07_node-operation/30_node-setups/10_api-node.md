---
title: API Node
---

## What is an API node?

An API node is a critical component of the EOS blockchain network that serves as an interface between users, including dApps, and an EOS blockchain. API nodes serve one of the following roles when handling incoming client requests received through one of the `chain_api_plugin` endpoints:

- **Push API node**: Accepts transactions from HTTP clients and relays them to other peers. Typically does not accept incoming p2p transactions. Upstream traffic only.
- **Chain API node**: Provides access to blockchain data such as accounts, permissions, contract codes/ABIs, contract tables, etc. Takes API transactions too.
- **Pull API node**: Similar to a Chain API node, but does not accept transactions from HTTP clients. This setup is not common but it is technically feasible.

> ℹ️ **Blockchain Primitives**  
A Chain API node also exposes access to read blockchain primitives, such as chain, blocks, transactions, producers, protocol features, etc. However, since these usually have a larger footprint in terms of disk, memory, and bandwidth, especially `get_block`, they are better suited for layer-2 history solutions that use the `state_history` plugin.

Push API nodes usually only listen to HTTP client requests, and do not accept incoming p2p transactions. This frees processing time for push nodes to process client requests quickly. In contrast, Chain API nodes benefit from receiving p2p transactions to sync their local blockchain state, which also speeds up response time back to clients.

> ℹ️ **Chain API endpoints**  
HTTP clients send requests through one of the `chain_api_plugin` endpoints. A push request will typically use the `send_transaction` endpoint or similar to write blockchain data or change the blockchain state. A common pull request will use the `get_table_rows` endpoint or similar to read blockchain data.

## Why would you use an API node?

As a developer, you can deploy your own API node to connect to an EOS blockchain and bring the following functionality to your smart contracts and dApps:

- **Data Access**: API nodes allow users to query the blockchain's state and some of its history, accessing information such as account balances, transaction details, smart contract data, and other blockchain-related data.

- **Transaction Broadcasting**: When users or dApps want to execute a transaction on the EOS blockchain, they submit the transaction to an API node. The node then broadcasts the transaction to the network, ensuring that it reaches all the necessary block producers for inclusion in the blockchain.

> ℹ️ **Public and Private Nodes**  
API nodes can be public or private. Public nodes are open to the public and can be used by anyone, while private nodes are typically operated by developers, applications, or organizations to manage their interactions with the blockchain privately.

- **API Endpoints**: API nodes expose various endpoints that allow clients to interact with the blockchain. These endpoints are typically HTTP/HTTPS-based and follow the EOSIO API specifications, making it easier for developers to integrate EOS into their applications.

- **Load Balancing**: Due to the potential high demand for clients accessing the blockchain, many node operators use a cluster of API nodes for load balancing. This ensures that the network can handle a large number of requests without becoming overwhelmed.

## Hardware requirements

The actual hardware requirements for an API node differ based on the transaction throughput, client requests, available bandwidth, etc. However, the biggest factor depends mainly on whether the API node needs to maintain a blocks log file. For more information on the actual requirements for API nodes, visit the [hardware requirements](../10_getting-started/10_hardware-requirements.md) section, in particular:

* [API node with blocks log](../10_getting-started/10_hardware-requirements#api-node-with-blocks-log)
* [API node without blocks log](../10_getting-started/10_hardware-requirements#api-node-without-blocks-log)

> ℹ️ **Chain API nodes maintain blocks log**  
A Chain API node needs to maintain its own blocks log file to be able to pull data from the blockchain. Maintaining a blocks log file implies that your node replayed the blockchain from a snapshot or from genesis. This allows your API node to sync the blockchain state with other peers and serve client requests quickly by reading the blockchain state locally. A common task performed by a Chain API node is to get table data requested by a dApp or a deployed smart contract.

## Software Requirements

To setup an API node, first install the Antelope [Leap](https://github.com/AntelopeIO/leap) software. The Leap version to install depends on whether you will deploy your node on an EOS testnet or on the EOS mainnet.

> ℹ️ **Leap software on mainnet vs. testnets**  
EOS testnets typically run the most recent Leap versions, usually the latest one shortly after released. The EOS mainnet will typically use a previous stable release version of the Leap software for stability and security.

To locate which version other API nodes are running for the EOS network you want to deploy on, select your EOS network of choice on the EOS Nation Validate site and navigate to the API report for that network:

* https://validate.eosnation.io/

For instance, for the most recent API nodes on EOS mainnet, EOS Jungle testnet, or EOS Kylin testnet, you can visit, respectively:

* https://validate.eosnation.io/eos/reports/api_versions.txt
* https://validate.eosnation.io/jungle4/reports/api_versions.txt
* https://validate.eosnation.io/kylin/reports/api_versions.txt

For your API node, you would want to use the same Leap version most other API nodes are using on the EOS network you want to deploy on. You can select the Leap binaries for a specific version here:

* https://github.com/AntelopeIO/leap/tags

After installing the Leap software, proceed to the Configuration section below.

## Configuration

An API node can be configured as a Push API node, a Chain API node, or a Pull API node. All API nodes must enable the `chain_api_plugin` to expose the API endpoints. The table below highlights the main differences between all API node types:

API node type | Maintains blocks log | Accepts p2p transactions | Accepts API transactions
-|-|-|-
**Push API node** | No | No | Yes
**Chain API node** | Yes | Yes | Yes
**Pull API node** | Yes | Yes | No

> ℹ️ **Plugins under the hood**  
Client requests are received by the RPC API interface managed by the `http_plugin` and ultimately handled by the `chain_api_plugin`, which exposes functionality implemented by the `chain_plugin`. Since the `chain_plugin` is enabled by default, you only need to enable the `chain_api_plugin` explicitly, which will also auto-enable the `http_plugin`. Check the [chain_api_plugin](../10_getting-started/30_plugins/chain-api-plugin.md) documentation for more details.

### Prerequisite Steps

Your API node will run its own `nodeos` instance. If you haven't launched `nodeos` or have `data` and `config` folders yet, follow the instructions in this section:

* Set the main `nodeos` data folder variable according to the EOS network you plan to deploy on:

  For instance, if deploying on the EOS mainnet, you may select:
  ```ini
  EOSDIR=~/eos/mainnet
  ```
  Or, if deploying on the EOS Jungle testnet, you may select:
  ```ini
  EOSDIR=~/eos/jungle_testnet
  ```
  etc.

* Create the default `config.ini` file - you will edit it in the steps below:

  ```sh
  mkdir -p $EOSDIR
  nodeos --print-default-config >$EOSDIR/config.ini
  ```

Follow the instructions below to configure an API node as either a Push API, Chain API, or Pull API node. First start with the [Any API node configuration](#any-api-node-configuration), then continue with your selected API node:

### Any API node configuration

The following configuration settings apply to any API node.

* Open the default `config.ini` with your text editor, for instance:

  ```sh
  vim $EOSDIR/config.ini
  ```

Edit the default `config.ini` and add/uncomment/modify the following fields:

* Set the chain database maximum size in MB - make sure it is below your available RAM (value below is for 16 GB RAM):

  ```ini
  chain-state-db-size-mb = 16384
  ```

> ℹ️ Chain database maximum size  
Be careful not to overestimate your chain database maximum size. The value you specify in `chain-state-db-size-mb` will get pre-allocated on disk as a memory-mapped file in `state/shared_memory.bin`.

* Set the local IP and port to listen for incoming http requests:

  ```ini
  http-server-address = 0.0.0.0:8888
  ```

* Set Cross-Origin Resource Sharing (CORS) values:
  ```ini
  access-control-allow-origin = *
  access-control-allow-headers = Origin, X-Requested-With, Content-Type, Accept
  ```

* Set or uncomment the following fields to the specified values:

  ```ini
  abi-serializer-max-time-ms = 2000
  chain-threads = 8
  contracts-console = true
  eos-vm-oc-compile-threads = 4
  verbose-http-errors = true
  http-validate-host = false
  http-threads = 6
  ```

* Add/update the p2p endpoint list:

  ```ini
  p2p-peer-address = <host1>:<port1>
  p2p-peer-address = <host2>:<port2>
  etc.
  ```

  > ℹ️ **Peering**  
  For information on peering, check the [Peering](../10_getting-started/40_peering.md) guide, especially the [How to locate peers](../10_getting-started/40_peering.md#how-to-locate-peers) section.

  In short, replace the most recent p2p endpont list in the `config.ini` according to the EOS network you are deploying on:

  - https://validate.eosnation.io/

  For instance, for the most recent p2p endpoints on EOS mainnet, EOS Jungle testnet, or EOS Kylin testnet, you can visit, respectively:

  - https://validate.eosnation.io/eos/reports/config.txt
  - https://validate.eosnation.io/jungle4/reports/config.txt
  - https://validate.eosnation.io/kylin/reports/config.txt

* Enable the `chain_api_plugin`:

  ```ini
  plugin = eosio::chain_api_plugin
  ```

### Push API node configuration

Make sure to go over the [Any API node configuration](#any-api-node-configuration) section first. The following configuration settings apply to a Push API node only.

Edit the default `config.ini` and add/uncomment/modify the following fields:

  ```ini
  p2p-accept-transactions = false
  ```

Now that the Push API node has been configured, proceed to the [Deployment](#deployment) section.

### Chain API node configuration

Make sure to go over the [Any API node configuration](#any-api-node-configuration) section first. The following configuration settings apply to any Full Chain API node.

Edit the default `config.ini` and add/uncomment/modify the following fields:

* Select the external IP and port to listen for incoming p2p connections:

  ```ini
  p2p-server-address = YOUR_EXTERNAL_IP_ADDRESS:9876
  ```

* Set or uncomment the following fields to the specified values:

  ```ini
  enable-account-queries = true
  p2p-listen-endpoint = 0.0.0.0:9876
  p2p-max-nodes-per-host = 100
  sync-fetch-span = 2000
  ```

Now that the Chain API node has been configured, proceed to the [Deployment](#deployment) section.

### Pull API node configuration

Make sure to go over the [Any API node configuration](#any-api-node-configuration) section first. The following configuration settings apply to any Pull API node.

Edit the default `config.ini` and add/uncomment/modify the following fields:

* Select the external IP and port to listen for incoming p2p connections:

  ```ini
  p2p-server-address = YOUR_EXTERNAL_IP_ADDRESS:9876
  ```

* Set or uncomment the following fields to the specified values:

  ```ini
  api-accept-transactions = false
  enable-account-queries = true
  p2p-listen-endpoint = 0.0.0.0:9876
  p2p-max-nodes-per-host = 100
  sync-fetch-span = 2000
  ```

Now that the Pull API node has been configured, proceed to the [Deployment](#deployment) section.

## Deployment

After your API node has been configured, you can deploy your node by following the steps below:

### Open TCP ports

If your node will run behind a firewall/router:
1. Open TCP port `8888` only, if setting up a **Push API** node  
  OR
2. Open TCP ports `8888` and `9876`, if setting up a **Chain API** or **Pull API** node

If you are running a Docker container, remember also to open the applicable ports above.

### Download a recent snapshot

Next, you need to sync your node's blockchain state with the specific EOS blockchain you are deploying on. The easiest way to accomplish this is by restoring from a recent snapshot.

> ℹ️ **Snapshots**  
For information about Snapshots, check the [Snapshots](../10_getting-started/50_snapshots.md) guide.

There are various reputable sites to download snapshots. One such good source that maintains recent snapshots for various EOS networks is the **EOS Nation AntelopeIO Snapshots** site:

* https://snapshots.eosnation.io/

Visit the above site and select a recent snapshot for the EOS network you are deploying your node on. For instance, for EOS mainnet, Jungle testnet, or Kylin testnet, you would select snapshots from these sections on the site, respectively:

* EOS Mainnet - v6
* Jungle 4 Testnet - v6
* Kylin Testnet - v6

Follow the instructions below to download the most recent snapshot:

* Install the `zstd` archiver - you will need it to decompress the compressed snapshot:

  ```sh
  sudo apt install zstd
  ```

* Download the latest compressed snapshot:

#### For EOS mainnet

  ```sh
  wget https://snapshots.eosnation.io/eos-v6/latest -O $EOSDIR/snapshots/latest.bin.zst
  ```

#### For Jungle testnet

  ```sh
  wget https://snapshots.eosnation.io/jungle4-v6/latest -O $EOSDIR/snapshots/latest.bin.zst
  ```

#### For Kylin testnet

  ```sh
  wget https://snapshots.eosnation.io/kylin-v6/latest -O $EOSDIR/snapshots/latest.bin.zst
  ```

* Decompress the compressed snapshot:

  ```sh
  zstd -d $EOSDIR/snapshots/latest.bin.zst
  ```

The `snapshots` directory should now contain the uncompressed `latest.bin` snapshot.

### Restore/start from recent snapshot

Follow the instructions below to restore/start your node from the most recent snapshot that you downloaded.

* Restore/start your node from the latest snapshot:

  ```sh
  nodeos --data-dir $EOSDIR --config-dir $EOSDIR --snapshot $EOSDIR/snapshots/latest.bin >> $EOSDIR/nodeos.log 2>&1 &
  ```

The above command will launch `nodeos`, redirecting `stdout` and `stderr` to `nodeos.log`. More importantly, the `--snapshot` option will sync the chain state of your API node to the state of the EOS network you are deploying on, starting from the latest snapshot. This includes accounts, balances, contract code, tables, etc., except past transaction history. After the syncing is done, your API node should continue to receive the latest irreversible blocks produced, which include recent transaction history.

> ℹ️ **Past transaction history**  
If you want your API node to have past blockchain history, you need to replay the blockchain from a blocks log file. This is not common, however. For past blockchain history there are better solutions than API nodes, such as History nodes.

## Testing

First, make sure your API node launched successfully and it is still syncing or receiving blocks:
```sh
tail -f $EOSDIR/nodeos.log
```
```
...
info  2023-08-15T23:16:04.797 nodeos    producer_plugin.cpp:651       on_incoming_block    ] Received block b9dd3609f8194902... #92772000 @ 2023-08-15T23:01:02.000 signed by jumpingfrogs [trxs: 0, lib: 92771671, confirmed: 0, net: 0, cpu: 1, elapsed: 55, time: 98, latency: 902797 ms]
info  2023-08-15T23:16:05.367 nodeos    producer_plugin.cpp:651       on_incoming_block    ] Received block 0966e24d95ef120f... #92773000 @ 2023-08-15T23:09:22.000 signed by ivote4eosusa [trxs: 1, lib: 92772667, confirmed: 0, net: 120, cpu: 1253, elapsed: 175, time: 272, latency: 403367 ms]
...
```

Second, make sure your API node initialized successfully from the snapshot. Search for `snapshot` in the `nodeos` log:

```sh
cat  ~/eos/jungle_testnet/stderr.log | grep -i snapshot
```
```
info  2023-08-15T23:15:55.395 nodeos    controller.cpp:603            startup              ] Starting initialization from snapshot and no block log, this may take a significant amount of time
info  2023-08-15T23:15:55.707 nodeos    controller.cpp:610            startup              ] Snapshot loaded, lib: 92757487
info  2023-08-15T23:15:55.707 nodeos    controller.cpp:613            startup              ] Finished initialization from snapshot
...
```

### Local test

Third, test the local `get_info` endpoint from the `chain_api_plugin` to request information about the blockchain you just deployed your API node on:

```sh
cleos get info
curl -L http://localhost:8888/v1/chain/get_info
```

Or visit the following URL on your browser:

* http://localhost:8888/v1/chain/get_info

Your API node should return the following response:

```
{
  "server_version": "7e1ad13e",
  "chain_id": "73e4385a2708e6d7048834fbc1079f2fabb17b3c125b146af438971e90716c4d",
  ...
  "head_block_producer": "alohaeostest",
  "virtual_block_cpu_limit": 200000000,
  ...
  "earliest_available_block_num": 92757488,
  "last_irreversible_block_time": "2023-08-17T16:02:05.500"
}
```

### Remote test

Lastly, you should also test the public `get_info` endpoint if you intend to use your API node for public consumption:

```sh
cleos -u http://YOUR_EXTERNAL_IP_ADDRESS:8888 get info
curl -L http://YOUR_EXTERNAL_IP_ADDRESS:8888/v1/chain/get_info
```

Or visit the following URL on your browser:

* http://YOUR_EXTERNAL_IP_ADDRESS:8888/v1/chain/get_info

Make sure to type the above commands/URL from outside your network. For instance, you can use your mobile device connection and disconnect temporarily from your Wi-Fi network.

Your API node should return a similar response to the last output above. If you get an error, check your port forwarding settings on your Wi-Fi router and on your Docker container, if any.

## Summary

In this guide, you configured and deployed an API node on a specific EOS network, such as EOS mainnet, EOS Jungle testnet, EOS Kylin testnet, etc. You can now get some native assets for that network, and use your API node to deploy EOS smart contracts and send transactions, get blockchain data, or both.
