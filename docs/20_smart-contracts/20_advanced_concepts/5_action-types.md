---
title: Action Types
---

An action is an entry point into a smart contract. It is a function that can be called by an account through 
interacting with the blockchain's APIs, or by another smart contract through inline actions.

Transactions that are sent to the EOS Network include one or more actions within them. 

In EOS there are a few different ways you can declare an action, which are used for different purposes.


## Callable Actions

Callable actions are the most common type of action. 
They set up a custom entry point to the contract that can be called by any account.

You can define a callable action in two different ways:


### Using the `[[eosio::action]]` attribute

```cpp
[[eosio::action]] void youraction(){}
```

This is the most versatile way to define an action. It allows you to specify the 
return type of the action so that you can have your action return a value.

> ⚠ **Return values & Composability**
>
> Return values are only usable from outside the blockchain, and cannot currently be used
> in EOS for smart contract composability. 

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

## Inline Actions

Inline actions are a way to call another action from within an action. Let's demonstrate this
below with two simple contracts. 


### Caller Contract

```cpp
// This contract is deployed to the account `contract1`
[[eosio::action]]
void callme(name user) {
    action(
        permission_level{get_self(), name("active")},
        name("contract2"),
        name("inlined"),
        std::make_tuple(user)
    ).send();
}
```

### Callee Contract

```cpp
// This contract is deployed to the account `contract2`
[[eosio::action]]
void inlined(name user) {
    print("I was called by ", user);
}
```

If you were to call the `callme` action on `contract1`, it would send an inline action to `contract2`, which would 
then call the `inlined` action and print out the name of the user that was passed in as a parameter.

Let's look at the structure of the `action` function call:

```cpp
action(permission_level, code, action, data).send();
```

The `action` function takes four arguments:

#### permission_level

The `permission_level` argument is used to specify the permission level that the action will be called with.
The contract **must** have the authority to call the action, otherwise the inline action call will fail.

To construct a `permission_level`:
```cpp
permission_level{name account, name permission}
```

#### code

The `code` argument is used to specify the account that the action will be called on.

#### action

The `action` argument is used to specify the name of the action that will be called.

#### data

The `data` argument is used to specify the data that will be passed to the action.
You should use the `std::make_tuple` function to create a tuple of the arguments that will be passed to the action.

The `tuple` is just a comma separated list of the arguments that will be passed to the action.

> ⚠ **The contract is the new sender**
>
> When you call an inline action, the contract that is calling the action becomes the new sender.
> So if you sent the above action from `someaccount`, then `contract2` would see `contract1` as the sender
> of the inline action, not `someaccount`.
> 
> This is important to note, as it means that the `require_auth` function in something like a token contract
> will not allow you to send tokens on behalf of another account. 

### The Code Permission

The `eosio.code` permission is a special account permission that allows a contract to call inline actions.
Without this permission your contract will not be able to call actions on other contracts.

This permission sits on the `active` permission level, so that other contract's using the `require_auth`
function will be able to verify that your contract has the authority to call the action.

To add the code permission you need to update your account's active permission to be controlled by
`<YOURACCOUNT>@eosio.code` **along with your current active permission**.

> ⚠ **Don't remove your current active permission controllers**
> 
> The `eosio.code` permission is meant to be added to your existing active permission, not replace it.
> If you remove your current active permission controllers, then you will lose access to your account/contract.

An example permission structure with a Code Permission on the account `yourcontract` would look like:
- **owner**: `YOUR_PUBLIC_KEY`
  - **active**: 
      - `YOUR_PUBLIC_KEY`
      - `yourcontract@eosio.code`

