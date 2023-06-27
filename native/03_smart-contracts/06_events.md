---
title: Events
---


### Using the `ACTION` macro

```cpp
ACTION youraction(){}
```

This is a shorthand for the `[[eosio::action]]` attribute. However,
it does not allow you to specify the return type of the action as it includes the `void`
return type by default.


## Event Receivers

Event Receivers are not actions, but rather functions that will be called when another action tags your contract
as a recipient. This is useful for tracking other smart contracts, such as token transfers.

Below are two contracts, one which is sending an event, and one which is catching it.

### Sender Contract

```cpp
[[eosio::action]] 
void transfer(name from, name to, asset quantity, std::string memo) {
    require_recipient(to);
}
```

The `require_recipient` function will send an event to the `to` account. If the `to` account has
a smart contract on it that listens to events, then it will be able to act upon the event.

> ❔ **Who can receive the event?**
>
> Any account can receive an event, but only the account specified in the `require_recipient` function
> will be notified. You cannot listen to events on contracts that have not required you as a recipient.


### Receiver Contract

```cpp
[[eosio::on_notify("*::transfer")]] 
void catchevent(name from, name to, asset quantity, std::string memo) {
    print("Received ", quantity, " from ", from);
}
```

### Understanding the on_notify syntax

The `on_notify` attribute takes a string as an argument. This string is a filter that will be used to determine
which actions will trigger the `catchevent` action. The filter is in the form of `contract::action`, where `contract`
is the name of the contract that is sending the event, and `action` is the name of the action within that contract that
triggered the event.

The `*` character is a wildcard that will match any contract or action. So in the example above, the `catchevent` action
will be called whenever any contract sends a `transfer` action to the `receiver` contract.

The wildcard is supported on both the contract and action side of the filter, so you can use it to match any contract, any action, or both.

Examples:
- `*::*` - Match any contract and any action
- `yourcontract::*` - Match any action on `yourcontract`
- `*::transfer` - Match any `transfer` action on any contract
- `yourcontract::transfer` - Match the `transfer` action on `yourcontract`
