---
title: Beginner Concepts
---

<head>
  <title>EOS dApps - Beginner Concepts</title>
</head>

A lot of tutorials for building decentralized web applications dive straight into the code but do not explain 
the core conceptual differences between web2 development and web3 development. 

This guide will help you wrap your head around how decentralized applications work, what parts of the stack are
different, and how to think about the architecture of your decentralized applications.

## The blockchain comes packed with features

In traditional web2 development you need to roll your entire stack alone. Even if you use cloud providers like AWS, 
you still need to pick and choose which services you want to use and how to integrate them together.

In web3 development, the blockchain comes packed with every feature you need to build most applications.

| Feature | Description                                                                                                                                       |
| --- |---------------------------------------------------------------------------------------------------------------------------------------------------|
| **Database** | The blockchain itself is just a massive database. **You** can also store data on the blockchain and query it.                                     |
| **Data replication** | Because of how a blockchain works, you get data replication across the entire network for **free**.                                               |
| **Authentication** | All blockchains come with built-in authentication and user management.                                                                            |
| **Payments** | One of the core functionalities of a blockchain is decentralized finance, and payments are made very easy.                                        |
| **Serverless Functions** | The blockchain has built-in serverless functions in the form of Smart Contracts.                                                                  |
| **Event Notifications** | You can subscribe to events that happen on the blockchain, similar to a message-queue or pub-sub. |

## You don't need a backend

In web2 development, you need to build a backend to store data and perform business logic. This might be a REST API or serverless functions.

In web3 development, can interact directly with the blockchain. You don't need to run your own backend infrastructure, kube clusters, or serverless functions.
It is very similar to serverless functions, except that the functions are run on a decentralized blockchain instead of a centralized cloud provider.

> ❔ **You might still want to run infrastructure**
> 
> Using publicly available nodes or API services is great, but you might want to run your own infrastructure for security or performance reasons.
> Take an exchange as an example. They generally run their own infrastructure to ensure that they can handle the load and that their data is secure.
> Though transactions **sent** to the chain are always backed by cryptography, the results you get from node APIs can be tampered with.

### In some cases a backend helps

There are some cases where you might want to run your own backend. For example, if you want to store data that is not on the blockchain, or if you want to
perform business logic that is either too expensive to run on the blockchain, or takes too long and exceeds the maximum time allowed for smart contract execution.

You might also want to provide your applications with different ways to access the data stored on the blockchain that is easier for you 
to work with, like GraphQL or SQL queries. In that case you might want to build a backend that listens to the blockchain and stores the data you care about in a way that suits your needs. 

## Get comfortable with wallets

A blockchain wallet is a piece of software that manages private keys.
Wallets do not store any blockchain data within them, instead they use the private keys they manage to sign transactions that manipulate the blockchain.

In web2 development, you need to build your own authentication system. You might use a third-party service like Auth0, or you might roll your own.
Once your user logs in, you rely on their session to prove that they are who they say they are. 

You might add in additional security measures like 2FA, IP-user pairing, and a variety of other techniques. 

In web3 development life is simpler, your users will log in with a wallet instead. There are no passwords you need to authenticate yourself. 
You also don't need to rely on a session to prove that their interactions are coming from them, because every interaction (transaction) 
they make will be signed with the private key that their wallet controls.

> ❕ **Proving logins**
> 
> Some applications want to prove that a user is who they say they are without requiring them to sign a transaction that gets
> sent to the blockchain. In that case you can use a technique called **message signing**, where you ask the user to sign a message
> with their private key, and then use that signature to prove their identity. 

## Big data doesn't belong on the blockchain

The blockchain is a database, but it is not a database that is meant to store large amounts of data. You can store that data on 
services specifically designed for that purpose, and then store the hash of that data on the blockchain. You will see this pattern
repeated over and over again in decentralized applications.

| Name                                    | Description                                                                                                                                     |
|-----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| [**IPFS**](https://ipfs.tech/)          | A peer-to-peer hypermedia protocol designed to preserve and grow humanity's knowledge by making the web upgradeable, resilient, and more open.  |
| [**Arweave**](https://www.arweave.org/) | The Arweave network is like Bitcoin, but for data: A permanent and decentralized web inside an open ledger.                                     |


## Your frontend is just an experience

Unlike web2 development, where your frontend is tightly coupled to your backend, in web3 development your frontend is just an experience layer.

Your frontend will interact with the blockchain directly, which means 100% of the security for your applications lives on the blockchain. It's 
important to remember that, because it means that users have the ability to interact with your contracts directly, and 
no matter what controls you build into the frontend, they can always bypass them.

> ❔ **Co-signing**
> 
> You can actually prevent people from interacting with your contracts directly by creating a backend that co-signs transactions
> for every interaction the user takes. This is non-standard and usually indicative of a game theory design flaw, but it 
> is used in some cases to prevent botting and other forms of cheating/abuse.

