---
title: Security
---

<head>
    <title>Staking Security</title>
</head>

To understand the security that underpins the EOS network's staking protocol, we need to look at the 
various layers of security that are in place to protect the network and its users and how they impact staking, as well 
as the additional security measures that apply only to staking.

## System Level Security

The staking actions and logic exist within the core system contract on EOS, `eosio.system`. 
This contract is responsible for managing the entire EOS network, including account creation, chain governance, and resource management.

The system contract is designed to be secure and robust, with extensive testing and auditing to ensure that it is free 
from vulnerabilities and exploits as it controls the most critical functions of the network. There isn't a single 
contract on the EOS network that undergoes more scrutiny or has more eyes on it than the system contract, both 
internally and externally.

The contract account is a "privileged" account, meaning that it has special permissions and access to system-level
capabilities that regular accounts do not have. This is to ensure that the contract can perform its functions without
being hindered by the same restrictions that apply to regular accounts, and also simplifies the general development and 
flow of actions that the contract needs to perform, reducing the complexity and potential for errors.

## Multisig Contract Control

The system contract is controlled by 15 of the 21 block producers on the network, who must sign off on any changes to 
the contract. This is the highest level of security that can be achieved on the EOS network, as it requires a supermajority
of the most trusted and reputable entities on the network.

This multisig control ensures that no single entity or group can make changes to the system contract without the
on-chain and very public approval of the majority of the block producers, who are elected by the token holders and
have a vested interest in maintaining the security and integrity of the network.

## Token Ownership

All funds that are staked into the staking protocol are deposited into the [`eosio.rex` account](https://eosauthority.com/account/eosio.rex)
which is also controlled by the system contract. When a user first deposits their funds into the staking protocol,
they are effectively transferring ownership of those funds to the system contract in return for the REX token that
represents their staked value.

In the same way that all tokens work on all blockchains, the contract is the ultimate authority over who owns what, 
and the user's ownership of tokens is represented as a row in the on-chain state database that records the user's
balance and other relevant information.

## Lockup periods

When a user stakes EOS into the staking protocol, they are subject to a lockup period that prevents them from
unstaking their tokens for a certain amount of time. This lockup period is infinite as long as a user is not 
unstaking their tokens, and once they decide to begin the unstaking period the lockup period is 21 days.

This provides not only a buffer for the network to react to any malicious or fraudulent activity but also a
mechanism for users to protect their funds from being stolen or misused by bad actors as well as a stable and
predictable environment for the staking protocol to operate in.

## Comprehensive Testing

The system contract as a whole has over 10,000 lines of tests, which are run on every PR and release to ensure that
the contract is functioning as expected and that no new vulnerabilities or exploits have been introduced. This
testing is done by both the core development team and external parties who ensure that the contract is secure and
robust.

Tests relevant to the staking protocol can be found at the following locations:

- [Core staking tests](https://github.com/eosnetworkfoundation/eos-system-contracts/blob/8ecd1ac6d312085279cafc9c1a5ade6affc886da/tests/eosio.system_tests.cpp#L3948)
- [Maturity tests](https://github.com/eosnetworkfoundation/eos-system-contracts/blob/8ecd1ac6d312085279cafc9c1a5ade6affc886da/tests/eosio.system_rex_matured_tests.cpp#L1)
- [Fees tests](https://github.com/eosnetworkfoundation/eos-system-contracts/blob/8ecd1ac6d312085279cafc9c1a5ade6affc886da/tests/eosio.fees_tests.cpp#L1)
- [Reward contract tests](https://github.com/eosnetworkfoundation/eosio.reward/blob/4a2f3cb9ffcbabb5f1682540636aae02d5d8480c/eosio.reward.spec.ts#L1)
 

## Audits

We have also conducted an audit with [BlockSec](https://blocksec.com/) to ensure that the staking protocol is secure and
functioning as expected. The audit report can be found [here](/docs/latest/miscellaneous/audits).


