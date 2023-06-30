---
title: Transactions and Blocks
---

Transactions and blocks are fundamental pieces of a blockchain. Understanding how they work is essential to
understanding how a blockchain functions.

## What are transactions?

When you want to interact with a blockchain you submit a transaction to the network, which is then processed by the network
and added to the blockchain via blocks. Transactions are made up of **actions**.

## What are actions?

Actions are the smallest unit of work in EOS. Each transaction include one or more actions within it. The ability to include
multiple actions within a transactions allows you to perform atomic operations across multiple smart contracts. 
Actions are executed in the order they are included in the transaction, and if any action fails the entire transaction is rolled back.

## What are blocks?

Blocks are a collection of transactions that are grouped together and added to the blockchain. Each block contains a 
unique fingerprint, or hash, which is created using the transactions contained within the block, as well other information
that links the current block and the previous blocks together. 

This creates a chain of blocks, or a blockchain, that cannot be altered or tampered with. Any change to a block would change
its hash, which would break the chain of blocks and make it clear that the data has been tampered with.
