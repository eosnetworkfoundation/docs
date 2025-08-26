---
title: Overview
---

The Vaulta EVM implements a smart contract which runs on Vaulta, we shall call it form this point forward the 
`EVM Contract`. To send transactions to the Vaulta EVM network one has to send transactions to the EVM Contract. 
The Vaulta EVM Contract is fully compatible with the Ethereum EVM except for some small differences which can be 
consulted in the [EVM Compatibility](/evm/999_miscellaneous/20_evm-compatibility.md) section.

To achieve the complete RPC compatibility, a full functioning Ethereum node is utilized. The Vaulta EVM mainnet 
uses an Ethereum node built on top of Silkworm node, we shall call it from this point forward the `Vaulta EVM Node`.

All the RPC requests, reads and writes, sent by the Vaulta EVM clients, are first processed by a proxy component, which 
redirects the requests as follows:

- the reads to the Vaulta EVM RPC component, and
- the writes to the Transaction Wrapper service.

### The Read Requests

The JSON-RPC read requests are supported by the Vaulta EVM RPC component which is a fork of 
[SilkRPC](https://github.com/torquem-ch/silkrpc) and implemented as a daemon that supports nearly all of the Ethereum 
JSON-RPC for the virtual EVM blockchain managed by the Vaulta EVM Contract. Two of the RPC methods, `eth_sendRawTransaction` 
and `eth_gasPrice` are intentionally disabled because it is not appropriate for this daemon to handle them. Instead requests 
for the two methods are routed to the  Transaction Wrapper service which is designed specifically to support those two RPC methods.

The Vaulta EVM RPC component relies on the database managed by an execution client for (virtual) EVM blockchain. The execution 
client is the Vaulta EVM Node component, which is a fork of [Silkworm](https://github.com/torquem-ch/silkworm) modified to work 
with the changes to the EVM runtime that are needed to support the Vaulta EVM, e.g. the trustless bridge.

The Vaulta EVM Node needs to reproduce exactly the EVM transaction execution that was first done by the Vaulta EVM Contract. 
It needs to reconstruct the virtual EVM blockchain that is managed by the Vaulta EVM Contract using data extracted from the
Vaulta blockchain. To facilitate this, Vaulta EVM Node connects to a state history plugin (SHiP) endpoint of an Vaulta node which 
is part of the Vaulta blockchain.

This architecture makes possible to expose the Ethereum client Web3 JSON RPC APIs and potentially other APIs if necessary.

### The Write Requests

As mentioned earlier, the two RPC methods, `eth_sendRawTransaction` and `eth_gasPrice`, are not implemented by Vaulta EVM RPC. 
Instead they are implemented by the `Transaction Wrapper` (in the below diagram `Tx Wrapper`) component. Therefore, all 
the *write requests* are forwarded to the Transaction Wrapper, which packs them into Vaulta actions and sends them to the EVM Contract.

The primary purpose of the Transaction Wrapper is to take raw EVM transactions via `eth_sendRawTransaction` and push 
them to the Vaulta EVM Contract. 
It accomplishes this through the following steps:

1. Constructs an Vaulta transaction which contains the `pushtx` action of the Vaulta EVM Contract which includes the rlp-encoded EVM transaction.
2. Sings the Vaulta transaction with the key of an Vaulta account that acts as the miner of the `pushtx` action and pays the CPU/NET costs of the Vaulta transaction.
3. Sends the signed Vaulta transaction to the Vaulta blockchain via the chain API of a Vaulta node connected to the Vaulta network.

Transaction Wrapper also supports the `eth_gasPrice` RPC method, despite the fact that it is a read method, because its 
implementation also depends on access to the chain API of a Vaulta node. In particular, it simply grabs the minimum gas price 
configured in the Vaulta EVM Contract from the appropriate table and returns it to the caller.

![Overall Design of the Vaulta EVM](/images/EOS-EVM_design_drawio.svg)

This architecture allows the possibility for other implementations of Ethereum nodes to be used if it is deemed necessary 
for some specific scenarios.
