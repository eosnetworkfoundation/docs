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

