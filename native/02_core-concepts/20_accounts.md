---
title: Accounts
---

An EOS account is a digital container for holding EOS tokens, resources, permissions, and more. 

Smart Contracts are also deployed on top of accounts, and the account owner can control the smart contract unless
control is relinquished.

## Account names

EOS accounts have human-readable names. 

However, in order to keep account names efficient on the blockchain, a few restrictions apply: 

* All characters must be lowercase
* Every name must be 12 characters long (or less with a suffix/premium name)
* Only letters `a-z`, numbers `1-5`, and period (`.`) are supported characters. 
* Names cannot start with a number or a period. 
* Names cannot end with a period.

Periods have a special meaning for EOS accounts. They specify that an account has a **suffix** (similar to a top-level domain like .com), also known as a **premium name**. Accounts with a suffix can only be created by the **suffix owner**. 

For instance, if someone owns the suffix `.bar` then only that person can create `foo.bar`. 
 
### Regex Validation

The following regex can be used to validate an EOS account name: 

```regex
(^[a-z1-5.]{1,11}[a-z1-5]$)|(^[a-z1-5.]{12}[a-j1-5]$)
```

## Public/private keys

Every EOS account is ultimately controlled by a key pair (public and corresponding private key).
While the public key is used to identify the account on the blockchain and can be publicly known, the private key which is used 
to sign each transaction must be kept secret at all times.

If you lose your private key, you will lose access to your account and all of its assets, smart contracts, and any other
data associated with it.

Examples of private and public keys:

| Type              | Key |
|-------------------| --- |
| Private Key       | `5KSdyAiFzYQAtBKDBKCCF28KMMhZ4EmXUxSg8B3nSkHKutT15rY` |
| Public Key        | `PUB_K1_5d7eRKgCCiEdsbBdxxnZdFWnGYS64uWZPZgTcTU1xnB2aESxqR` |
| Legacy Public Key | `EOS5d7eRKgCCiEdsbBdxxnZdFWnGYS64uWZPZgTcTU1xnB2cq4JMD` |


## Permissions system

EOS offers extra security mechanisms for accounts out of the box, using what we call the *permissions system*.

Each account has a set of hierarchical permissions that control what that account can do, and comes with two base permissions by default. These two permissions cannot be removed as they are required for your account to function properly. 

The mandatory permissions are `owner` and `active`.

A permission can only ever change what controls it (keys or accounts) or what controls its children. It can never change what controls its parent.

![Who can change permissions?](/images/accts_who_can_change_permissions.png)


What controls a permission is either a **public key** or another **account**. 
This allows for the creation of complex account control structures, where multiple parties may control a single account 
while still having full autonomy over their own account's security. 

Take the following diagram as an example, where the account `alice` is controlled by both `bob` and `charlie`, 
while `charlie` is _also_ controlled by `tom`. 

But remember, all accounts are eventually controlled by keys. 


![Delegated account ownership](/images/accts_delegated_account_ownership.png)


You can add custom permissions underneath the `active` permission which allows you to limit that permission's access to 
only a specific contract's action (callable function). That permission will then only ever be able to interact with the 
contract action you specified. 

This means you are able to create granular access permissions across accounts and have hierarchical ownership and 
usage of them. 


![Custom permissions](/images/accts_custom_permissions.png)


Most importantly, the permission system has built-in support for multi-signature transactions (transactions that require 
multiple parties to sign them). Every linked account or key associated with a permission has a **weight** assigned to it, 
and the permission itself has a **threshold**. 

As you can see in the example below, `bob` alone does not have enough power to sign using the `active` permission. 
He needs either `charlie` or `jenny` to co-sign with him for any transaction that `alice@active` makes. On the other 
hand, `charlie` and `jenny` cannot sign a transaction alone, they need `bob`. 


![Weights and thresholds](/images/accts_weights_and_thresholds.png)


## Smart contracts

Smart Contracts allow you to add functionality to an account. They can be anything 
from simple things like a todo application to a fully-fledged RPG game running entirely on the blockchain. 

Every account has the ability to have one single smart contract deployed to it, however, that smart contract can be 
updated and replaced at will. 


## Creating accounts costs EOS

Because RAM is a limited resource, creating an account requires you to spend EOS to buy the RAM needed to store the
account's data. This means that in order to create an account, someone else who already has an account must
create it for you.

Most EOS wallets will allow you to create an account for yourself, but will require you to pay for the RAM needed to
store your account. Some wallets will pay for the RAM for you, but will require you to pay them back at a later date.

> 💰 **Current costs**
> 
> The cost of opening an account is based on the RAM required for opening it, which as of writing this document (20/02/2023) is `2996 bytes`.

## Relinquishing ownership of an account

Upgrade-ability has significant benefits for smart contract development, but isn't always wanted. 
At some point, the community you are building for might request that you relinquish control of the smart contract, and make 
it immutable, or semi-immutable.

You have a few options to achieve that goal.

> 💀 **Don't forget the code permission!**
>
> If you relinquish the account's ownership, do not forget to keep the `eosio.code` permission
> on the account's `active` permission. Otherwise, the account will be unable to execute any inline actions on the blockchain, 
> which might **kill your contract**.

### NULL account

You may set the contract account's owner and active permissions to `eosio.null@active`. This is a `NULL` account that is specifically designed for these purposes. It has no private key or owner. 

This is a good option if you want to **burn** control of this account **forever**.


### Producer controlled

Alternatively, you may set the contract account's `owner` and `active` permissions to three different types of producer-controlled (network consensus-controlled) accounts, so that if there is ever an issue with this contract you can request the help of the producers to upgrade the contract. 

This is a good option if you are dealing with intricate and complex contracts that might have bugs that could impact the users negatively. 

#### eosio.prods

The `eosio.prods` account is controlled by ⅔+1 of the actively producing producers on the network. This means that if there are 21 active producers then you would need 15 of them to sign off on all upgrades.

#### prod.major

The `prod.major` account is controlled by ½+1, meaning that if there are 30 active producers then you would need 16 of them to sign off on all upgrades.

#### prod.minor

The `prod.minor` account is controlled by ⅓+1, meaning that if there are 30 active producers, then you would need 11 of them to sign off on all upgrades.

