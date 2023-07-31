---
title: List tokens & history
---

Sometimes you need to get a list of token balances and transaction history for an account. This is a common use case 
for a variety of blockchain applications. 

We use [`Blockscout`](https://docs.blockscout.com/) as our explorer which has a variety of APIs that can be used to
get various information about the blockchain.

## Our hosted servers

You can use our hosted servers for any of these APIs. 

```
MAINNET:
https://explorer.evm.eosnetwork.com/

TESTNET:
https://explorer.testnet.evm.eosnetwork.com/
```

## Get token balances

To get a list of token balances for an account, we can use the account module API's `tokenlist` endpoint.


```
/api?module=account&action=tokenlist&address={address}
```

If you want more information about this endpoint, you can read the [Blockscout docs](https://docs.blockscout.com/for-users/api/rpc-endpoints/account#get-list-of-tokens-owned-by-address).

## Get transaction history

To get a list of transactions for an account, we can use the account module API's `txlist` endpoint.

```
/api?module=account&action=txlist&address={address}&startblock=555555&endblock=666666&page=1&offset=5&sort=asc
```

If you want more information about this endpoint, you can read the [Blockscout docs](https://docs.blockscout.com/for-users/api/rpc-endpoints/account#get-transactions-by-address).
