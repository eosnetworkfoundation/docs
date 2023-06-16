---
title: Peering
---

# Peering

In a previous section, you deployed a local single node EOS blockchain. Although it is a fully functional blockchain, it still runs on a single node. To start grasping the full benefits of the EOS blockchain technology, you need to add more nodes. The [Bios Boot Tutorial](https://github.com/AntelopeIO/leap/tree/release/4.0/tutorials/bios-boot-tutorial) showcases how to deploy a multi node blockchain consisting of 21 producing nodes. In this section, you will learn about "peering", the network feature that makes it all possible. This is what allows to grow incrementally from a single node to a truly decentralized, geographically distributed, multi node EOS blockchain.

## What is Peering?

Peering allows EOS nodes to propagate and synchronize the distributed blockchain state by receiving and relaying blocks and/or transactions to other nodes. Any node that is configured to send and receive data in a peer-to-peer fashion is considered a "peer". This adds redundancy and allows for faster response times to client queries and requests. Therefore, peering is key to the decentralized operation and incremental growth of the EOS blockchain.

> ℹ️ Peering is enabled through the EOS peer-to-peer (p2p) network protocol and it is what makes possible the blockchain's decentralized operation.

## Why you need nodes/peers

In the EOS blockchain, nodes can be configured to operate in different ways. It is this flexibility in having nodes serve various roles which allows for a more distributed load and a smoother blockchain experience to the end user. Some of the node types in EOS include, but are not limited to:

* **Producing Nodes**: produce blocks to be added to the chain
* **Relay Nodes**: validate/relay blocks and/or transactions
* **API Nodes**: respond to API queries from clients via HTTP
* **History Nodes**: stores chain data for L2 history solutions
* etc.

Therefore, when set up as peers EOS nodes typically validate the blocks and transactions they receive and relay them to other peers if valid. Nodes can also be set up to respond to API requests from clients, provide historical data about blocks and transactions, etc.

## How to set up peers

Peering can be set up by configuring the `net_plugin` of each `nodeos` instance whose node will act as peer. The most important options are:

* `p2p-listen-endpoint arg`: local `host:port` for incoming p2p connections
* `p2p-server-address arg`: public `host:port` for incoming p2p connections
* `p2p-peer-address arg`: local or remote peer `host:port` to connect to

Other options are available to limit the maximum number of connections, whitelisting specific peers by public key, accept/relay transactions, etc. Check the `net_plugin` options in `nodeos` for more information.

### Peer setup using `config.ini`

> ℹ️ The peer connection process must be performed on the local environment of each peer. Therefore, peering involves planning and agreement among all nodes that will act as peers in the EOS network.

To peer your local node with other nodes, specify the following in your nodeos `config.ini` *before* launching your `nodeos` instance:

```ini
# your listening host:port
p2p-listen-endpoint = <myhost>:<myport>   # e.g. 0.0.0.0:9876
# your public host:port
p2p-server-address = <mypubhost>:<myport> # e.g. p2p.eos99.io:9876

# peers host:port (for each peer to connect to)
p2p-peer-address = <host1>:<port1>  # e.g. peer.leap.sg:9876
p2p-peer-address = <host2>:<port2>  # e.g. p2p.eosphere.io:3571
# etc.
```

### Peer setup using command-line (CLI)

To peer your local node with other nodes, specify the following in your nodeos command-line arguments *when* launching your `nodeos` instance:

```shell
nodeos ... \
  p2p-listen-endpoint = <myhost>:<myport> \
  p2p-server-address = <mypubhost>:<myport> \
  p2p-peer-address = <host1>:<port1> \
  p2p-peer-address = <host2>:<port2> \
  ...
```

Check the previous section [Peer setup using `config.ini`](#peer-setup-using-configini) for examples about potential values for `p2p-listen-endpoint`, `p2p-server-address`, and `p2p-peer-address`.

## How to locate peers

For the EOS Mainnet and various Testnets, some websites publish and maintain lists of P2P, API, and other endpoints for your nodes to connect to. There are various endpoint lists available for the EOS Mainnet and the various EOS Testnets.

> ℹ️ These lists are typically generated, validated, and combined from the standard `bp.json` files provided by Block Producers, including Standby Producers.

For a central portal that keeps track of *all* endpoints (P2P, API, History, etc.) for the EOS Mainnet and various EOS Testnets, you can visit the EOS Nation Validate Portal and select the **endpoints report** for the specific network:

* EOS Mainnet endpoints: https://validate.eosnation.io/eos/reports/endpoints.html
* Jungle Testnet endpoints: https://validate.eosnation.io/jungle4/reports/endpoints.html
* Kylin Testnet: https://validate.eosnation.io/kylin/reports/endpoints.html

Once you visit any of the above **endpoints report**, you can scroll down to the specific endpoints of interest: `api_http` or `api_https2` for API endpoints, `p2p` for P2P endpoints, etc.


### For EOS Mainnet

Besides the **endpoints report** URLs listed in the parent section above [How to locate peers](#how-to-locate-peers), the following endpoints are available to add directly to your `config.ini`:

* P2P Endpoints: https://validate.eosnation.io/eos/reports/config.txt

As of 6/15/2023, the above P2P endpoint list shows as below:

```ini
# Endpoints config.ini
# Network: EOS
# Validator last update: 2023-06-12 19:32 UTC
# For details on how this is generated see https://validate.eosnation.io/about/
# ==== p2p ====
# alohaeosprod: GB, London
p2p-peer-address = peer.main.alohaeos.com:9876
# argentinaeos: AR, argentina
p2p-peer-address = p2p.eosargentina.io:9876
...
# ivote4eosusa: US, Greenville,SC,USA
p2p-peer-address = eos.p2p.eosusa.io:9882
```

* API Endpoints: https://validate.eosnation.io/eos/reports/api_versions.txt

As of 6/15/2023, the above API endpoint list shows as below:

```ini
# API Versions Report
# Network: EOS
# Validator last update: 2023-06-12 20:06 UTC
# For details on how this is generated see https://validate.eosnation.io/about/
==== 4.0.1 (leap) ====
aus1genereos api_https2, v4.0.1, https://eos.genereos.io, ...
eosnationftw  api_http, v4.0.1, http://eos.api.eosnation.io, ...
...
==== 3.1.0 (leap) ====
eosamsterdam api_http, v3.1.0, http://mainnet.eosamsterdam.net, ...
eosamsterdam api_https2, v3.1.0, https://mainnet.eosamsterdam.net, ...
...
teamgreymass api_http, v3.1.0, http://eos.greymass.com, ...
teamgreymass api_https2, v3.1.0, https://eos.greymass.com, ...
```

### For EOS Testnets

Besides the **endpoints report** URLs listed in the parent section [How to locate peers](#how-to-locate-peers), the following endpoints are available to add directly to your `config.ini` for the EOS Testnets below:

#### EOS Kylin Testnet

* P2P Endpoints: https://validate.eosnation.io/jungle4/reports/config.txt
* API Endpoints: https://validate.eosnation.io/jungle4/reports/api_versions.txt

#### EOS Jungle Testnet

* P2P Endpoints: https://validate.eosnation.io/kylin/reports/endpoints.txt
* API Endpoints: https://validate.eosnation.io/kylin/reports/api_versions.txt

## How to check peers health

Some web portals provide periodic reports and/or live reports to check the health of public P2P and API endpoints. Again, EOS Nation provides the various exhaustive reports on the status of various endpoints, including the health of block producing nodes, for both the EOS Mainnet and various EOS Testnets:

* EOS Mainnet reports: https://validate.eosnation.io/eos/reports/
* Jungle Testnet reports: https://validate.eosnation.io/jungle4/reports/
* Kylin Testnet reports: https://validate.eosnation.io/kylin/reports/

Since the endpoints listed on the above reports are validated and refreshed every 30 minutes, the mere presence of an endpoint on a given report indicates that the endpoint is responsive. For more errors detected, you can check the following:

* EOS Mainnet error report: https://validate.eosnation.io/eos/reports/errors.html
* Jungle Testnet error report: https://validate.eosnation.io/jungle4/reports/errors.html
* Kylin Testnet error report: https://validate.eosnation.io/kylin/reports/errors.html

### Third-party Tools

Some tools are available to measure the responsiveness, or lack thereof, a list of P2P and/or API endpoints:

* [get-closer](https://medium.com/hackernoon/find-the-best-api-endpoint-for-your-eos-dapp-7b7489cb6449)  
  receives a list of API endpoints and returns the HTTP request-response time. If an endpoint is unresponsive, it eventually times out and does not show on the list.

## Summary

Peering is crucial for the decentralized operation of any EOS blockchain network. It allows to synchronize and distribute the blockchain state among all nodes and peers for a smoother and faster blockchain experience. Peering is necessary for any EOS blockchain to reach consensus, achieve self-governance, and exploit the many benefits of blockchain technology.
