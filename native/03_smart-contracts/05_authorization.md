---
title: Authorization
---

Authorization is the process of determining whether or not a user has permission to perform a transaction (through actions). 
In blockchain applications this is a key aspect of ensuring the safety of a Smart Contract, and the digital assets that
it controls.

Checking authorizations with EOS++ can be done in a few ways.

## Getting the sender

The best way to get the sender of a transaction is to pass it in as an argument to the action.

```cpp
ACTION testauth(name user) {
    print("I was called by ", user);
}
```

This is the most explicit way to get the sender of a transaction, and is the recommended way to do it.

## Require auth

The easiest way to check that an account has signed this transaction and given their authority is to use the `require_auth` function.

```cpp
ACTION testauth(name user) {
    require_auth(user);
}
```

## Require auth2

Like the `require_auth` function, the `require_auth2` function will check that the specified account has signed the transaction.
However, it will also check that the specified permission has signed the transaction.

```cpp
ACTION testauth(name user) {
    require_auth2(user, name("owner"));
}
```

This will check that the specified `user` account has signed the transaction, meaning that the transaction which calls 
this action has been authorized by the `user` account.

## Has auth

The above `require_auth` function will check that the specified account has signed the transaction and fail the transaction
if it has not. However, if you want to check that the specified account has signed the transaction, but not fail the transaction
if it has not, you can use the `has_auth` function.

```cpp
ACTION testauth() {
    name thisContract = get_self();
    if (has_auth(thisContract)) {
        // This contract has signed the transaction
    }
}
```

## Is account

You might also want to check if an account even exists. This can be done with the `is_account` function.

```cpp
ACTION testauth(name user) {
    if(!is_account(user)) {
        // The user account does not exist
    }
}
```
