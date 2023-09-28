---
title: Events
---

Events are a way for smart contracts to communicate with each other as side-effects of actions.

The most common in-use usage of events is tracking `eosio.token` (`EOS`) transfers, but they can be used for
any type of communication between contracts.

We will use that exact example below, but first we will cover the basics of events.

## Two sides of an event

Of course, there are two sides to every event: the sender and the receiver.

On one side, you have a `contract::action` that is emitting an event, and on the other side you have a contract that is
listening for that event.

## Event Receiver

Event Receivers are not actions, but rather functions that will be called when another action tags your contract
as a recipient. 

```cpp
#include <eosio/eosio.hpp>
using namespace eosio;

CONTRACT receiver : public contract {
public:
    using contract::contract;

    [[eosio::on_notify("*::transfer")]] 
    void watchtransfer(name from, name to, asset quantity, std::string memo) {
        // Your logic here
    }
};
```

The `on_notify` attribute takes a string as an argument. This string is a filter that will be used to determine
which actions will trigger the `watchtransfer` function. The filter is in the form of `contract::action`, where `contract`
is the name of the contract that is sending the event, and `action` is the name of the action within that contract that
triggered the event.

The `*` character is a wildcard that will match any contract or action. So in the example above, the `watchtransfer` function
will be called whenever any contract sends a `transfer` action to the `receiver` contract. 
The wildcard is supported only on the contract and NOT on the action side of the filter.

Examples:
- `*::transfer` - Match any `transfer` action on any contract
- `*::refund` - Match any `refund` action on any contract
- `yourcontract::transfer` - Match **only** the `transfer` action on `yourcontract`

> ❔ **Who can send events?**
> 
> Any contract can send an event, but only the contract that is specified in the `on_notify` attribute
> will be notified. However, each notification adds a small amount of CPU usage to the transaction even if
> no recipient is listening for the event.


## Event Sender

Event Senders are actions that emit an event to any contract that has been specified in a special 
`require_recipient` function.

```cpp
#include <eosio/eosio.hpp>
using namespace eosio;

CONTRACT token : public contract {
public:
    using contract::contract;

    ACTION transfer(name from, name to, asset quantity, std::string memo) {
        require_recipient(from);
        require_recipient(to);
    }
};
```

The `transfer` action above will emit an event to both the `from` and `to` accounts (this is actually how the `eosio.token` contract works).
So if your contract is either the `from` or `to` account, then you can listen for the `transfer` event. If your account is **not**
either of those accounts, you have no way of listening for the `transfer` event from within the blockchain.


> ❔ **Who can receive the event?**
>
> Any account can receive an event, but only the account specified in the `require_recipient` function
> will be notified. However, if the account receiving the event does not have a smart contract deployed on it, 
> then the event will be ignored as it cannot possibly have any logic to handle the event.

## Resource usage

Events are a powerful tool, but great power often comes at a cost.
The receiver of an event has the power to take up CPU and NET resources of the original sender of the event.

This is because the sender of the event is the one paying for the CPU and NET resources of the receiver, but often 
they have no control over, or even knowledge of, how much CPU and NET resources the receiver will use.



