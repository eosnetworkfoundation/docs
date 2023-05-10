---
title: "Create a Token"
---


A token is an own-able digital asset such as a virtual collectible or in-game currency. It is nothing more than a data structure
that is stored on the blockchain.

A token contract defines the data structures that make up a token, the storage of those structures, 
and the actions that can be taken to manipulate the tokens.

There are two widely used types of blockchain tokens: 
- **Fungible tokens** are interchangeable and every token is equal to every other, like gold in a game 
- **Non-fungible tokens** are unique, like a collectible card or a piece of land

In this tutorial you will create an in-game currency called **GOLD**, which is a *fungible token*. 

## Your development environment

Make sure you have [DUNE](../10_getting-started/10_dune-guide.md) installed
and understand how to build contracts.

After each step, you should try to compile your contract and check if there are any errors.

## Create a new contract

To get started, let's set up a basic contract scaffold.

Create a `token.cpp` file and add the following code:

```cpp
#include <eosio/eosio.hpp>
#include <eosio/asset.hpp>
#include <eosio/singleton.hpp>
using namespace eosio;

CONTRACT token : public contract {

    public:
    using contract::contract;

    // TODO: Add actions
};
```

## Creating the actions

Our token contract will have three actions: 

```cpp
    ACTION issue(name to, asset quantity){
        
    }
    
    ACTION burn(name owner, asset quantity){
        
    }
    
    ACTION transfer(name from, name to, asset quantity, std::string memo){
        
    }
```

Add them to your contract and then let's dig into each action and see what they do, and what parameters they take.

### Issue

The `issue` action creates new tokens and adds them to an account's balance and to the total supply. 

It takes two parameters:
- **to**: The account to which the tokens will be issued
- **quantity**: The amount of tokens to issue

### Burn

The `burn` action removes tokens from an account's balance and the total supply. 

It takes two parameters:
- **owner**: The account that will be burning the tokens
- **quantity**: The amount of tokens to burn

### Transfer

The `transfer` action transfers tokens from one account to another. 

It takes four parameters:
- **from**: The account sending the tokens
- **to**: The account receiving the tokens
- **quantity**: The amount of tokens to transfer
- **memo**: A memo to include with the transfer

## Setting the symbol and precision

Every fungible token has a **symbol** and a **precision**.

The **symbol** is an identifier for the token (like EOS, BTC, or in our case GOLD), and the **precision** is the number of decimal places that the token supports.
We are going to add a constant variable to our contract to define the `symbol` and `precision` of our token.

Add this above the `issue` action:

```cpp
    const symbol TOKEN_SYMBOL = symbol(symbol_code("GOLD"), 4);
    
    ACTION issue ...
```

The above lines means that we are going to create a token with the symbol `GOLD` and a precision of `4`.

It will look like `100.0000 GOLD` or `0.0001 GOLD`.

## Adding the data structures

Now that you have your actions defined, let's add the data structures that will be used to store the token's data.

Put this below the `TOKEN_SYMBOL` you just added.

```cpp
    const symbol TOKEN_SYMBOL = symbol(symbol_code("GOLD"), 4);

    TABLE balance {
        name     owner;
        asset    balance;

        uint64_t primary_key()const { 
            return owner.value; 
        }
    };
    
    using balances_table = multi_index<"balances"_n, balance>;
    
```

You just created a `balance` structure which defines the data that will be stored in the `balances` table.
Then, you defined the `balances_table` type which is the definition of a table that will store rows of the `balance` model.

Later you will use the `balances_table` type to instantiate a reference to the `balances` table, and use that reference to 
store and retrieve data to/from the blockchain.

The `owner` property is of type `name` (EOS account name) and will be used to identify the account that owns the tokens.
The `name` type is a way to pack a string into a 64-bit integer efficiently. It is limited to a-z, 1-5, and a period, and can 
be up to 12 characters long.

The `balance` property is of type `asset` and will be used to store the amount of tokens that the account owns.
The `asset` type is a special type that includes a symbol, a precision, and an amount. It has the `asset.symbol` property
and the `asset.amount` property (which is of type `int64_t`).

The `primary_key` function in the structure is used to uniquely identify each row for indexing purposes. In this case, 
we are using the `owner` field as the primary key, but using the `uint64_t` representation instead for efficiency.

Next, you need another table to store the total supply of the token. Add this below the `balances_table` you just added:

```cpp
    using supply_table = singleton<"supply"_n, asset>;
```

We're using a different type of table here, a `singleton`. A `singleton` is a table that only has one row per-scope. 
This is perfect for storing things like configurations. We will use it to store the total supply of the token as you 
only have the one token in your contract.

You can see that we also didn't define a custom structure to store as we only needed the `asset` type to store 
the total supply.

## Filling in the actions

Now that you have your data structures defined, let's fill in the actions.

### Issue

First we'll start with the `issue` action, which will create new tokens and add them to an account's balance.

We want only the account that the contract is deployed on to be able to call the `issue` action, so we will add 
an assertion to make sure that the account calling the action is the same as the account that the contract is deployed on.

```cpp
    ACTION issue(name to, asset quantity){
        check(has_auth(get_self()), "only contract owner can issue new GOLD");
    }
```

Next, we want to make sure that the account we will issue the tokens to exists on the blockchain. We don't want that
sweet in-game GOLD to go to waste!

```cpp
    ...
    check(is_account(to), "the account you are trying to issue GOLD to does not exist");
```

Next, we want to make sure that the `quantity` parameter is a positive number, and has the correct 
`symbol` and `precision`.

```cpp
    ...
    check(quantity.is_valid(), "invalid quantity");
    check(quantity.amount > 0, "must issue a positive quantity");
    check(quantity.symbol == TOKEN_SYMBOL, "symbol precision and/or ticker mismatch");
```

Shwew! That's a lot of checks, but it's important to make sure that we are protecting our in-game GOLD!

Now let's start dealing with the balances table.

```cpp
    ...
    balances_table balances(get_self(), get_self().value);
```

We took the `balances_table` type we defined earlier and instantiated a new `balances_table` object. We passed in the 
`get_self()` function as the first parameter (the `code` parameter), which returns the contract account's name. We passed in the `get_self().value`
as the second parameter (the `scope` parameter), which returns the `uint64_t` representation of the contract account's name.

> ❔ **Scopes**: Scopes are a way to group rows in a table together. You can think of it as a folder that
> contains all the rows in the table. In this case, we are using the contract account's name as the scope, so all the
> rows in the `balances` table will be grouped together under the contract account's name. If you'd
> like to learn more about scopes, check out the [Getting Started with Smart Contracts Guide](../10_getting-started/40_smart_contract_basics.md#multi-index-instantiate-with-code-and-scope).

Next, we need to check if the `to` account already has a balance. We can do this by using the `find` function on the
`balances` table.

```cpp
    ...
    auto to_balance = balances.find(to.value);
```

The `find` function returns an iterator to the row in the table that matches the primary key. If the `to` account does
not have a balance, then the `find` function will return an iterator to the end of the table. Remember that the primary key
for the table is a `uint64_t`, so we need to use the `to.value` to get the `uint64_t` representation of the `to` account.

If there is already a balance, then we need to add the new tokens to the existing balance. We can do this by using the
`modify` function on the `balances` table. We will check to see if the `to_balance` iterator is not equal to the end of
the table, and if it is not, then we will modify the row.

```cpp
    ...
    if(to_balance != balances.end()){
        balances.modify(to_balance, get_self(), [&](auto& row){
            row.balance += quantity;
        });
    }
```

The `modify` function takes three parameters:
- **iterator**: The iterator to the row that you want to modify
- **payer**: The account that will pay for the RAM to store the modified row
- **lambda**: A lambda function that gives a reference to the row that you want to modify

The lambda function is where you actually modify the row. In this case, we are adding the new tokens to the existing
balance.

If there is not already a balance, then we need to create a new balance for the `to` account. We can do this by using
the `emplace` function on the `balances` table.

```cpp
    ...
    else{
        balances.emplace(get_self(), [&](auto& row){
            row.owner = to;
            row.balance = quantity;
        });
    }
```

The `emplace` function takes two parameters:
- **payer**: The account that will pay for the RAM to store the new row
- **lambda**: A lambda function that gives a reference to the new row

The lambda function is where you actually initialize the new row. In this case, we are setting the `owner` to the `to`
account, and the `balance` to the `quantity`.

Finally, we need to update the total supply of the token. We can do this by getting the `supply` table.

```cpp
    ...
    supply_table supply(get_self(), get_self().value);
    auto current_supply = supply.get_or_default(asset(0, TOKEN_SYMBOL));
``` 

We took the `supply_table` we defined earlier and instantiated a new `supply_table` object. Just like before, we passed
in the `get_self()` function for both the first and second parameters (respectively: `code`, and `scope`). 

Next, we used the `get_or_default` function on the singleton to get the current supply of the token, or create a new one 
if this is the first tokens that are being issued in this contract. The `get_or_default` function takes one parameter, 
which is the value to create if no value already exists. In our case, that default value is a new `asset` that we 
initialized with a value of `0` and the `TOKEN_SYMBOL` constant we defined earlier. This would look like `0.0000 GOLD`.

Now that we have the current supply, we can add the new tokens to the current supply and save the value to the blockchain.
Since both the `current_supply` and `quantity` are of type `asset`, we can use the `+` operator to add them together.

> ✔ **Automatic overflow protection**
> 
> The `asset` class handles overflows/underflows automatically. If there is an overflow
> it will throw an error and abort the transaction automatically. You do not have to do any 
> special checks when using `asset`. You do however if using `uint64_t` or any other base type. 

```cpp
    ...
    auto new_supply = current_supply + quantity;
    supply.set(new_supply, get_self());
```

We used the `set` function on the singleton to save the new supply to the blockchain. 

The `set` function takes two parameters:
- **value**: The new value to save to the blockchain
- **payer**: The account that will pay for the RAM to store the new value

### Burn

The `burn` action is very similar to the `issue` action. The only difference is that we are subtracting the tokens from
the `owner` account and the supply instead of increasing them.

Let's start with the checks like before, and then get into the logic.

```cpp
    ACTION burn(name owner, asset quantity){
        check(has_auth(owner), "only the owner of these tokens can burn them");
        check(quantity.is_valid(), "invalid quantity");
        check(quantity.amount > 0, "must burn a positive quantity");
        check(quantity.symbol == TOKEN_SYMBOL, "symbol precision and/or ticker mismatch");
    }
```

We're doing the same checks we did in the `issue` action, except for the `is_account` check because we will already be 
testing to see if the `owner` has a balance in the `balances` table.

```cpp
    ...
    balances_table balances(get_self(), get_self().value);
    auto owner_balance = balances.find(owner.value);
    check(owner_balance != balances.end(), "account does not have any GOLD");
```

Now let's check if the `owner` account has enough tokens to burn.

```cpp
    ...
    check(owner_balance->balance.amount >= quantity.amount, "owner doesn't have enough GOLD to burn");
```

Let's calculate a new balance for the `owner` account.

```cpp
    ...
    auto new_balance = owner_balance->balance - quantity;
```

We don't need to check if the `new_balance` is below zero because we already checked if the `owner` account has enough tokens
to burn.

Let's subtract the tokens from the `owner` account. If the `new_balance` is zero, then we can just erase the
row from the `balances` table to save **RAM**.

```cpp
    ...
    if(new_balance.amount == 0){
        balances.erase(owner_balance);
    }
```

If the `new_balance` is not zero, then we need to modify the row in the `balances` table.

```cpp
    ...
    else {
        balances.modify(owner_balance, get_self(), [&](auto& row){
           row.balance -= quantity;
        });
    }
```

We also need to remove the tokens from the total supply.

```cpp
    ...
    supply_table supply(get_self(), get_self().value);
    supply.set(supply.get() - quantity, get_self());
```

Voilà, now we can burn virtual GOLD.

### Transfer

The `transfer` action is a little more complicated than the `issue` and `burn` actions. We need to transfer tokens from
one account to another account and make sure that the `from` account has enough tokens to transfer.

On top of that, we want to make it so that other contracts can interact with our token so that they can 
build things on top of it. 

Again let's start with the checks and then get into the logic.

```cpp
    ACTION transfer(name from, name to, asset quantity, string memo){
        check(has_auth(from), "only the owner of these tokens can transfer them");
        check(is_account(to), "to account does not exist");
        check(quantity.is_valid(), "invalid quantity");
        check(quantity.amount > 0, "must transfer a positive quantity");
        check(quantity.symbol == TOKEN_SYMBOL, "symbol precision and/or ticker mismatch");
    }
```

We're doing mostly the same checks as before but this time we're making sure the `from` account (the sender) is the one 
that is authorizing the transfer, and we're making sure that the `to` account exists.

Next, we need to get the `balances` table and check if the `from` account has a balance.

```cpp
    ...
    balances_table balances(get_self(), get_self().value);
    auto from_balance = balances.find(from.value);
    check(from_balance != balances.end(), "account does not have any GOLD");
```

Let's check if the `from` account has enough tokens to transfer.

```cpp
    ...
    check(from_balance->balance.amount >= quantity.amount, "owner doesn't have enough GOLD to transfer");
```

We need to check if the `to` account has a balance in the `balances` table.

```cpp
    ...
    auto to_balance = balances.find(to.value);
```

If the `to` account does not have a balance, then we need to create a new row in the `balances` table.

```cpp
    ...
    if(to_balance == balances.end()){
        balances.emplace(get_self(), [&](auto& row){
            row.owner = to;
            row.balance = quantity;
        });
    }
```

If the `to` account _does_ have a balance, then we need to modify the row in the `balances` table.

```cpp
    ...
    else {
        balances.modify(to_balance, get_self(), [&](auto& row){
            row.balance += quantity;
        });
    }
```

Now we need to check if the `from` account has a balance of the same amount as the `quantity` we are transferring. If
it does, then we can just erase the row from the `balances` table, and once again, save **RAM**.

```cpp
    ...
    if(from_balance->balance.amount == quantity.amount){
        balances.erase(from_balance);
    }
```

If the `from` account has a balance that is greater than the `quantity` we are transferring, then we need to
modify the row in the `balances` table.

```cpp
    ...
    else {
        balances.modify(from_balance, get_self(), [&](auto& row){
            row.balance -= quantity;
        });
    }
```

Finally, we need to emit an event that other contracts can listen to. We will emit two events, one which has the `from` 
account as the recipient, and another which has the `to` account as the recipient. This allows either party to listen
to the event and do something with it if they have a contract deployed to that account.

```cpp
    ...
    require_recipient(from);
    require_recipient(to);
```


## The full contract

If you want to copy the full contract, and match it against yours, you can find it below.

<details>
    <summary>Click here to view full code</summary>

```cpp
#include <eosio/eosio.hpp>
#include <eosio/asset.hpp>
#include <eosio/singleton.hpp>
using namespace eosio;

CONTRACT token : public contract {
   public:
      using contract::contract;

   const symbol TOKEN_SYMBOL = symbol(symbol_code("GOLD"), 4);

   TABLE balance {
      name     owner;
      asset    balance;

      uint64_t primary_key()const { 
         return owner.value; 
      }
   };

   using balances_table = multi_index<"balances"_n, balance>;

   using supply_table = singleton<"supply"_n, asset>;




   ACTION issue(name to, asset quantity){
      check(has_auth(get_self()), "only contract owner can issue new GOLD");
      check(is_account(to), "the account you are trying to issue GOLD to does not exist");
      check(quantity.is_valid(), "invalid quantity");
      check(quantity.amount > 0, "must issue a positive quantity");
      check(quantity.symbol == TOKEN_SYMBOL, "symbol precision and/or ticker mismatch");

      balances_table balances(get_self(), get_self().value);

      auto to_balance = balances.find(to.value);

      if(to_balance != balances.end()){
            balances.modify(to_balance, get_self(), [&](auto& row){
               row.balance += quantity;
            });
      }
      else{
            balances.emplace(get_self(), [&](auto& row){
               row.owner = to;
               row.balance = quantity;
            });
      }

      supply_table supply(get_self(), get_self().value);

      auto current_supply = supply.get_or_default(asset(0, TOKEN_SYMBOL));

      supply.set(current_supply + quantity, get_self());
   }

   ACTION burn(name owner, asset quantity){
      check(has_auth(owner), "only the owner of these tokens can burn them");
      check(quantity.is_valid(), "invalid quantity");
      check(quantity.amount > 0, "must burn a positive quantity");
      check(quantity.symbol == TOKEN_SYMBOL, "symbol precision and/or ticker mismatch");

      balances_table balances(get_self(), get_self().value);
      auto owner_balance = balances.find(owner.value);
      check(owner_balance != balances.end(), "account does not have any GOLD");
      check(owner_balance->balance.amount >= quantity.amount, "owner doesn't have enough GOLD to burn");

      auto new_balance = owner_balance->balance - quantity;
      check(new_balance.amount >= 0, "quantity exceeds available supply");

      if(new_balance.amount == 0){
         balances.erase(owner_balance);
      }
      else {
         balances.modify(owner_balance, get_self(), [&](auto& row){
               row.balance -= quantity;
         });
      }

      supply_table supply(get_self(), get_self().value);
      supply.set(supply.get() - quantity, get_self());
   }

   ACTION transfer(name from, name to, asset quantity, std::string memo){
      check(has_auth(from), "only the owner of these tokens can transfer them");
      check(is_account(to), "to account does not exist");
      check(quantity.is_valid(), "invalid quantity");
      check(quantity.amount > 0, "must transfer a positive quantity");
      check(quantity.symbol == TOKEN_SYMBOL, "symbol precision and/or ticker mismatch");

      balances_table balances(get_self(), get_self().value);
      auto from_balance = balances.find(from.value);
      check(from_balance != balances.end(), "from account does not have any GOLD");
      check(from_balance->balance.amount >= quantity.amount, "from account doesn't have enough GOLD to transfer");

      auto to_balance = balances.find(to.value);
      if(to_balance == balances.end()){
         balances.emplace(get_self(), [&](auto& row){
               row.owner = to;
               row.balance = quantity;
         });
      }
      else {
         balances.modify(to_balance, get_self(), [&](auto& row){
               row.balance += quantity;
         });
      }

      if(from_balance->balance.amount == quantity.amount){
         balances.erase(from_balance);
      }
      else {
         balances.modify(from_balance, get_self(), [&](auto& row){
               row.balance -= quantity;
         });
      }

      require_recipient(from);
      require_recipient(to);
   }
};
```
</details>


## Grab battle tested source code

If you'd like to simply use the source code which is used in most fungible tokens on the EOS Network, you can head over to the
[eosio.token](https://github.com/eosnetworkfoundation/eos-system-contracts/tree/4702c8f2d95dd06f0924688560b8457962522216/contracts/eosio.token)
repository to grab it. Not only is this code battle tested, but it powers the underlying EOS token.

Please note that the standard `eosio.token` contract differs considerably from this tutorial. It is a more complex
contract which allows for more advanced features such as allowing users interacting with the contract to pay for their own RAM, 
or creating multiple tokens within a single contract. 

You will need to `create` a new token with it, and then `issue` those tokens to an account before they can be transferred. 
You will also need to `open` a balance for an account before you can transfer tokens over to it.


## Challenge

This token has no `MAXIMUM_SUPPLY`. How can you add a constant to the contract which defines the maximum supply of the
token and make sure that the `issue` action does not exceed this maximum supply?
