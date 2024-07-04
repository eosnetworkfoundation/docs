---
title: Introduction to Finalizers and Voting
---

## Takeaways
- Finality is a separate role tied to the authority of the top 21 block producers.
- Voting is continuous, try to keep your producer active between rounds.
- There is a voting history file.
- It is always safe to activate new, never used BLS keys.
- Be aware of vote routing topology and activate vote threads to relay votes.

## Introduction to Finalizers and Voting
The EOS blockchain bundles together transactions into blocks, and working across 21 producers comes to a consensus on those blocks before marking them as irreversible. EOS continues to advance its blockchain technology, has added Finalizers in Spring v1.0. Finalizers enable the blockchain to mark blocks as irreversible seconds after they are published. This improvement in time to finality does not come at the cost of safety. Marking a block as irreversible continues to require agreement from 15 out of the top 21 producers.

## Finalizer
In Spring v1.0, Finalizers are tightly coupled to the role of the block producer and publisher. Only the top 21 block producers may vote to advance finality. The top block producers are determined by the votes they receive from community members who stake their EOS. This distributed proof of stake remains unchanged and continues the distributed governance model that has worked so well for EOS. Starting with Spring v1.0, block producers have the authority to run two separate functions.
- Block Publish: Bundles together transactions into a block, and links that block and transaction to previous blocks and transactions.
- Finalizer: Cryptographic verification of the on-chain transactions

To lower the time to irreversible blocks, also know as time to finality, producers must exchange information about the state of the chain more frequently. Starting in Spring v1.0 the top 21 producers vote and successful votes are included with every block that is produced. In Spring v1.0 blocks are produced every 500ms. These votes are later aggregated and verified. If there is agreement about the state of the block chain finality is advanced. The Finalizer is the software responsible for aggregating votes, performing cryptographically verification, and determining if finality may be advanced.

### Block Publisher Rounds
The top block producers alternate publishing blocks on a schedule determined by their accumulated votes. This publishing period is called a round. If a publisher is unavailable during its round, that publisher is skipped over and another publisher takes their place.

### Voting Overview
Unlike the Block Publishing process, voting does not have a schedule. There are no rounds. The top 21 block producers submit votes on every block. Agreement on the state of the chain from 15 of the top 21 is required before a block may be marked as irreversible. Currently there is no penalty if a block producer's vote is not included as part of the finality calculation. If the EOS blockchain fails to get votes, or those votes disagree on the state of the chain, finality will not advance, and the last irreversible block will remain unchanged.

Votes include a cryptographically signed digest for the Merkle tree representing the current state of the blockchain. As the chain adds transactions and changes those digest will change. To quickly and efficiently vote each Finalizer has a `safety.dat` file which stores this history of votes, and the digest that have been voted on. The digest stored in the history file is used as a reference point for calculating future digests from incoming blocks and transactions.

### BLS Keys and Signature
Voting creates signed digests using BLS Keys. BLS signatures are very cheap to aggregate together into a single message, and this property makes them a good choice for aggregating together votes from many different finalizers. The property also makes it cheap to support a large set of BLS signatures.

### Keys and Voting History
There is an implicit link between the BLS Key used to sign votes, and the voting history stored in `safety.dat`.

The voting history stored in `safety.dat` includes signed digests using the BLS key registered during voting. As we mentioned previously, this history is used to generate new votes. If the `safety.dat` does not contain the full voting history for a BLS Key, the votes will not be correct. When a partial voting history is included in the `safety.dat` that block producer will vote for a different branch of the blockchain. This will create a vote that does not contribute to finality.

Activating a new, never used, BLS Key is always safe. There is no voting history for a new, never used key.

Please take care when managing the `safety.dat` file. Please do not share BLS keys across hosts, or reuse the same BLS key when moving from host to host. Sharing and reuse of BLS Keys may result in a corrupted or partial voting history.

### Continuous Voting
Unlike block publishing, for the top 21 block producers, voting is continuous. Taking a producer offline would prevent that producer from voting to advance finality. To support continuous voting and manage various support scenarios the EOS blockchain provides on chain actions to register, activate, and delete BLS Keys. Using these actions, a producer can quickly rotate to a new BLS Key.

For this reason it is recommended that each producer instance uses its own unique BLS Key, and activates the BLS Key when going online. There are many strategies for [managing BLS Keys](../managing-finalizer-keys).

### Voting and Peering
All the nodeos instance from the source of the votes, to the receiver of the votes, along with any intermediate nodes must be configured to send, receive, and propagate votes. This is accomplished by enabling the vote-threading pools, configuring `vote-threads` to a value greater than zero. By default `vote-threads` is greater than zero on all block production nodes. Therefore, when two finalizers are directly peered, votes are sent and received with no additional configuration changes needed.

When nodeos instances are not directly connected, and an intermediate nodeos instance is present, the intermediate nodes must update their configuration to enable vote-threading. Failure to enable vote-threading on intermediate nodes will prevent the finalizer votes associated your producer from reaching peers.
