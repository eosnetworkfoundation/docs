---
title: Peering
sidebar_class_name: sidebarhidden
---

# Peering

In a previous section, you deployed a local single node EOS blockchain. Although it is a fully functional blockchain, it still runs on a single node. To start grasping the full benefits of the EOS blockchain technology, you need to add more nodes. The [Bios Boot Tutorial](https://github.com/AntelopeIO/leap/tree/release/4.0/tutorials/bios-boot-tutorial) showcases how to deploy a multi node blockchain consisting of 21 producing nodes. In this section, you will learn about "peering", the network feature that makes it all possible. This is what allows to grow incrementally from a single node to a truly decentralized, geographically distributed, multi node EOS blockchain.

## What is Peering?

Peering allows EOS nodes to propagate and synchronize the distributed blockchain state by receiving and relaying blocks and/or transactions to other nodes. Any node that is configured to send and receive data in a peer-to-peer fashion is considered a "peer". This adds redundancy and allows for faster response times to client queries and requests. Therefore, peering is key to the decentralized operation and incremental growth of the EOS blockchain.

> ℹ️ Peering is enabled through the EOS peer-to-peer (p2p) network protocol and it is what makes possible the blockchain's decentralized operation.
