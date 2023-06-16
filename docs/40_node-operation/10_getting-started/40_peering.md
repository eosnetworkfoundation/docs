---
title: Peering
sidebar_class_name: sidebarhidden
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
