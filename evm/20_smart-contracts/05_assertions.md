---
title: Assertions
---

Like every program, bugs can occur and user input must be validated. Solidity provides a few ways to validate user input,
and to ensure that the state of the contract is as expected.

## Reverting state

Assertions are a way to check that a condition is true, and if it is not, the transaction will fail. When a transaction
fails, all state changes that have occurred in the transaction will be rolled back. This means that any changes to
persisted data / tables will be reverted as if the transaction never happened.

In Solidity, you can cause a contract to fail, and revert state by using the `revert` function.

```solidity
if(1 != 1) revert();
```

The `revert` function will cause the transaction to fail, and revert state. It can also take a `string` message as an argument,
which will be thrown as an error.

```solidity
if(1 != 1) revert("1 should equal 1");
```

## Validating conditions

It is common to want to validate user inputs, or that a Smart Contract's internal state is as expected.

```solidity
function addId(uint32 id) public {
    require(id > 0, "id must be greater than 0");
}
```

The `require` function will check that the first argument is true, and if it is not, it will revert state and throw the
message provided in the second argument.

You should be using `require` as early as possible in your functions. If it fails it will send back all unused gas to the
user.

## Preventing catastrophic failures

Often you want to ensure that a contract is working as intended and that no situation has been reached that is unexpected.
This could be based on user-input, or a variety of calls that culminate in a contract being used in a way it was not
designed to be used.

For these situations, it's best to use an `assert` function. The reason for this is that the `assert` function will
consume all gas that was allocated to the transaction.

Generally, if your contract reaches a state it was not designed to reach, there is a bug in the contract or a malicious
actor is trying to exploit the contract. Because the latter case is a possibility, we want to take as much gas as possible
from the attacker to make their attack as expensive as possible.

```solidity
assert(funds > 0, "you shouldn't be doing this Bob");
```





