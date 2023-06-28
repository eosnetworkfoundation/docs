---
title: Consensus
---

Consensus is the fundamental process in blockchain technology by which a distributed network of 
nodes reaches agreement on the state of the ledger. Every time a new block is added to the chain,
the nodes must agree on the contents of the block. This is done by a consensus algorithm.

## What is a consensus algorithm?

A consensus algorithm is a rigid set of rules that are used to ensure that all nodes on the 
network agree on the current state of the ledger. These rules must be deterministic, meaning
that they will always produce the same result given the same input. This is important because
it ensures that all nodes on the network will reach the same conclusion about the state of the
blocks being applied to the blockchain.

There are different types of consensus algorithms used in blockchain networks, such as proof-of-work (PoW), 
proof-of-stake (PoS), delegated proof-of-stake (DPoS), and more. Each algorithm has its own unique set of 
rules and incentives for how nodes on the network participate in reaching consensus.


## What consensus algorithms are used in EOS?

EOS uses a delegated proof-of-stake (DPoS) consensus algorithm. 

Token holders elect a group of block producers who are responsible for maintaining the network and reaching consensus 
on new blocks. These block producers are incentivized to act honestly, as they can be voted out if they don't perform 
their duties properly. This system is designed to be more efficient than PoW, as it doesn't require as much computational 
power to maintain the network.

This allows EOS to be more efficient and greener than other blockchains that use consensus algorithms like proof-of-work.

### Block producers

Block producers in EOS are the nodes on the network that are responsible for maintaining the network and reaching consensus
on new blocks. There are 21 active block producers at any given time, and a long list of standby block producers who are
ready to step in if one of the active block producers goes offline or is voted out.

### Voting

EOS token holders can vote for block producers using their EOS tokens. Every token holder can vote for up to 30 block producers,
and the votes are weighted based on the number of tokens staked to voting. This means that the more tokens you have staked to voting,
the more weight your vote has.



