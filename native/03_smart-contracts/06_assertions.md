---
title: Assertions
---

Like every program, bugs can occur and user input must be validated. EOS++ provides a clear cut way to do this.

## Reverting state

Assertions are a way to check that a condition is true, and if it is not, the transaction will fail. When a transaction
fails, all state changes that have occurred in the transaction will be rolled back. This means that any changes to 
persisted data / tables will be reverted as if the transaction never happened.

## Check

The `check` function is how you validate conditions in EOS++. 
The function will check that the specified condition is true, and if it is not, the transaction will fail.

```cpp
check(1 == 1, "1 should equal 1");
```

The interface for the `check` function simply takes a condition and a `string` message. If the condition is false, the message
will be thrown as an error and the transaction will revert.

## Logging non-strings

Since the `check` function takes a `string` message, you might be wondering how to log non-strings. 
This depends on the type of data you want to log, but here are some common examples:

#### Logging `name`

```cpp
name thisContract = get_self();
check(false, "This contract is: " + thisContract.to_string());
```

#### Logging `asset`

```cpp
asset myAsset = asset(100, symbol("EOS", 4));
check(false, "My asset is: " + myAsset.to_string());
```

#### Logging integers

```cpp
int myInt = 100;
check(false, "My int is: " + std::to_string(myInt));
```




