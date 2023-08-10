---
title: API Node
---

## What is an API node?

An API node is a critical component of the EOS blockchain network that serves as an interface between users, including dApps, and the EOS blockchain. API nodes serve one of the following roles when handling incoming client requests received through one of the `chain_api_plugin` endpoints:

- **Push API node**: Accepts transactions from HTTP clients and relays them to other peers. Typically does not accept incoming p2p transactions. Upstream traffic only.
- **Chain API node**: Provides access to blockchain data such as accounts, permissions, contract codes/ABIs, contract tables, etc. Takes API transactions too.
- **Pull API node**: Similar to a Chain API node, but does not accept transactions from HTTP clients. This setup is not common but it is technically feasible.

> ℹ️ **Blockchain Primitives**  
A Chain API node also exposes access to read blockchain primitives, such as chain, blocks, transactions, producers, protocol features, etc. However, since these usually have a larger footprint in terms of disk, memory, and bandwidth, especially `get_block`, they are better suited for layer-2 history solutions that use the `state_history` plugin.

Push API nodes usually only listen to HTTP client requests, and do not accept incoming p2p transactions. This frees processing time for push nodes to process client requests quickly. In contrast, Chain API nodes benefit from receiving p2p transactions to sync their local blockchain state, which also speeds up response time back to clients.

> ℹ️ **Chain API endpoints**  
HTTP clients send requests through one of the `chain_api_plugin` endpoints. A push request will typically use the `send_transaction` endpoint or similar to write blockchain data or change the blockchain state. A common pull request will use the `get_table_rows` endpoint or similar to read blockchain data.
