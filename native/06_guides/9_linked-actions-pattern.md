---
title: Linked-Actions Pattern 
---

Sometimes you want to make sure that a user interacting with your contract has used another
contract before they can use yours. For instance, you might want to make sure that they have
transferred tokens to your contract's account before they can use your contract.

When related to tokens this is often referred to as a "Deposit Pattern", but depositing tokens
isn't the only time you might want to use this pattern, hence the term "Linked-Actions Pattern".

Taking deposit pattern as our example, let's look at what this transaction might look like:
```
- Transaction
    1. eosio.token::transfer (Token Transfer) 
        -[inline] mycontract::on_transfer (Notifiable Action Receiver) 
    2. mycontract::record (Regular Action)
```

The table above shows the execution order of the actions in the transaction.

The transaction only has a token transfer and a "record" action in it, but there is
also an event receiver function that is triggered by the token transfer which your
contract will catch and put between the token transfer and the record action.

The common problem that this pattern solves is that you want to make sure that the
token transfer has happened before you allow the record action to happen. 

Let's take a look at some code for this without the pattern:


#### The token transfer action
```cpp
ACTION transfer(name from, name to, asset quantity, string memo){
    // ...
    require_recipient( from );
    require_recipient( to );
    // ...
}
```

#### The event receiver and record action
```cpp
#include <eosio/asset.hpp>

[[eosio::on_notify("eosio.token::transfer")]]
void on_transfer(name from, name to, asset quantity, string memo){
    // ...
}

ACTION record(name from, uint64_t internal_id, uint8_t status){
    // ...
}
```

You can see above that we want to add some additional information about the user transferring funds
to our contract, but we can't do that in the token transfer action because all we have available is 
the `memo` field, which is a string.

> ⚠ **Performance considerations**
> 
> You might have guessed that you could do some string manipulation and conversions to get the data
> you need into the `memo` field, but this is not recommended. The `memo` field is not only limited to 256
> characters on most token contracts, but string manipulation from within a smart contract is one of 
> the most expensive operations you can do.

Instead, we can use the linked-actions pattern to make sure that the token transfer has happened
before we allow the `record` action to happen, and we can also pass the additional information we need
to the `record` action.

Let's update the `on_transfer` event receiver and the `record` action to make a connection between them
using the linked-actions pattern.


First we're going to add a `multi_index` table to our contract to store the information we need to pass
between the two actions.

```cpp
TABLE transfer_info {
    name from;
    asset quantity;
    
    uint64_t primary_key() const { return from.value; }
};

using _transfers = multi_index<"transfers"_n, transfer_info>;

[[eosio::on_notify("eosio.token::transfer")]]
void on_transfer(name from, name to, asset quantity, string memo){
    _transfers transfers( get_self(), get_self().value );
    transfers.emplace( get_self(), [&]( auto& row ) {
        row.from = from;
        row.quantity = quantity;
    });
}
```

> ⚠ **Warning**
>
> You should have more checks on the `on_transfer` than we have here in this example. This guide is not
> about security, so we are omitting those checks for clarity, but you should not deploy a token event receiver
> this way in production.

Then, in our `record` action we can check if the transfer exists and if it does, we can
delete it from the table to free up RAM and do our logic.

If it not does, we can simply error out and tell the user that they need to transfer tokens
to the contract before they can use it.


```cpp

ACTION record(name from, uint64_t internal_id, uint8_t status){
    // ...
    _transfers transfers( get_self(), get_self().value );
    auto transfer = transfers.find( from.value );
    check( transfer != transfers.end(), "Must transfer tokens to contract before using it" );
    transfers.erase( transfer );
    
    // Do your logic here
}
```

## Problems with RAM abuse

The above pattern works well, but it does have a problem. If a user transfers tokens to your contract
but never calls the `record` action, the RAM that was used to store the transfer information will never
be freed.

Since your contract is the one paying for the RAM, this means accounts could send small amounts of tokens
to your contract to consume your RAM and make your contract overly expensive.

We can combat this by adding a `check` to the `on_transfer` event receiver to make sure that the quantity
is over some threshold before we store the transfer information.

```cpp
[[eosio::on_notify("eosio.token::transfer")]]
void on_transfer(name from, name to, asset quantity, string memo){
    check(quantity.amount > 100, "Must transfer more than 100 tokens");
    
    ...    
}
```

Alternatively, we can consume those costs and just run a periodic cleanup of the table to free up RAM
that is no longer needed.

```cpp
ACTION cleanup(){
    _transfers transfers( get_self(), get_self().value );
    auto transfer = transfers.begin();
    
    uint8_t count = 0;
    while( transfer != transfers.end() && count < 100 ) {
        transfer = transfers.erase( transfer );
        count++;
    }
}
```

Note that you will have to call this action yourself periodically to keep your RAM usage down,
however for linked-action patterns that aren't related to monetary values, this is a good
way to keep your RAM usage down.

## Challenge

How could you change the code above to capture an NFT transfer and link the action so that
only the owner and the correct NFT can trigger the `record` action?


