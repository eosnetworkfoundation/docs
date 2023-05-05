---
title: Smart Contracts
---

A smart contract is simply an application that lives on the blockchain. It includes access to the blockchain's
state and all the other smart contracts that are deployed on the blockchain. It can read and write data to the blockchain, 
and it can call other smart contracts to perform the actions that they expose.

Each contract is deployed to a specific `account` on the blockchain. When you interact
with that contract you do so by calling actions on that account.

## What can I do with a smart contract?

Smart contracts can be used for a variety of purposes, such as creating and executing financial transactions, 
verifying the authenticity or owner of a piece of data, or enforcing the terms of an agreement between two parties.

For example, a smart contract could be used to automatically execute the transfer of a house from one person to another
once the terms of the sale have been met. The smart contract would hold the funds from the buyer, and the title to the house
from the seller. Once both the funds and the title have been transferred to the smart contract, the smart contract would
automatically transfer the title to the buyer and the funds to the seller.

What a smart contract can do, is entirely up to your imagination.

## Are smart contracts immutable?

In EOS, smart contracts have the _possibility_ of being immutable, but it is not the default.

As long as you retain control of the account that the smart contract is deployed to, you may update the smart contract
at any time. This is useful for fixing bugs, or adding new features to your smart contract.

If you want to make your smart contract immutable, you can give up ownership of that account. Once you do that, you will
no longer be able to update the smart contract. This is useful for smart contracts that you want to ensure will never change,
which provides extra security and peace of mind for your users.

## What is a dApp?

A dApp is a decentralized application that runs on a blockchain. It is similar to a traditional application,
but instead of running on a single server it runs on a distributed network of nodes that work together to maintain
the application and ensure its security.




