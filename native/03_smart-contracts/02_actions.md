---
title: Actions
---

An action is a function that can be called on the Smart Contract. It is the entry point into some piece of functionality
that you want to expose to the outside world.

Actions can be called by any account, even other smart contracts.

## Defining an Action

There are two ways to define an action, one is more verbose, but allows you to specify the return type of the action,
and the other is a shorthand that will always return `void`.

### Simple action

When you don't need to specify the return type of the action, you can use the `ACTION` keyword which 
is a shorthand for `[[eosio::action]] void`.

```cpp
ACTION youraction(){
    // Your logic here
}
```

### Specifying the return type

If you want to specify the return type of the action, you must use the `[[eosio::action]]` attribute followed by the
return type.

```cpp
[[eosio::action]] uint64_t youraction(){
    // Your logic here
    return 1337;
}
```

> ⚠ **Return values & Composability**
>
> Return values are only usable from outside the blockchain, and cannot currently be used
> in EOS for smart contract composability. 


## Inline Actions

Inline actions are a way to call another contract's action from within your contract. 
This is useful when you want to build functionality on top of other contracts.

Let's demonstrate this below with two simple contracts.

```cpp title="sender.cpp"
#include <eosio/eosio.hpp>
using namespace eosio;

CONTRACT sender : public contract {
public:
    using contract::contract;

    ACTION sendinline(name user) {
        action(
            permission_level{get_self(), name("active")},
            name("contract2"),
            name("receiver"),
            std::make_tuple(user)
        ).send();
    }
};
```

> ❔ **Your contract's account**
> 
> The `get_self()` function returns the name of the account that the contract is deployed to. It is useful
> when you don't know where this contract will be deployed to until you deploy it, or if the contract might
> be on multiple accounts.

```cpp title="receiver.cpp"
#include <eosio/eosio.hpp>
using namespace eosio;

CONTRACT receiver : public contract {
public:
    using contract::contract;

    ACTION received(name user) {
        print("I was called by ", user);
    }
};
```

| Contract | Account deployed to |
| -------- |---------------------|
| `sender`   | `contract1`         |
| `receiver` | `contract2`         |

If you had these two contracts deployed, you could call the `contract1::sendinline` action, which would then call the
`contract2::receiver` action.

It would also pass the parameter `user` to the `contract2::receiver` action. 

### Interface of the inline action sender

The `action` constructor takes four arguments:

```cpp
action(
    <permission_level>, 
    <contract>, 
    <action>, 
    <data>
).send();
```

- `permission_level` - The permission level that the action will be called with
- `contract (name type)` - The account that the action is deployed to
- `action (name type)` - The name of the action that will be called
- `data` - The data that will be passed to the action, as a tuple

> ❔ **name function**
> 
> The `name()` function is used to convert a `string` into a `name` type. This is useful when you want to pass
> the name of an account or action as a string, but the function you are calling requires a `name` type.

### Creating the permission level

The `permission_level` argument is used to specify the permission level that the action will be called with.
This will either be the contract that the action is deployed to, or a permission that the account that the 
contract is deployed to has.

The `permission_level` constructor takes two arguments:

```cpp
permission_level(
    <account (name type)>, 
    <permission (name type)>
)
```

> ⚠ **The contract is the new sender**
>
> When you call an inline action, the contract that is calling the action becomes the new sender.
> For security reasons, the original authorization is not passed to the new contract, as it would mean
> that the new contract could call actions on behalf of the original sender (like sending tokens).

### Creating the tuple

The `data` argument is used to specify the parameters of the action that you are calling.

A tuple is just a way to group multiple arguments together. You can create a tuple using the `std::make_tuple` function.

```cpp
std::make_tuple(<arg1>, <arg2>, <arg3>, ...);
```

### Code Permission

There is a special account permission called `eosio.code` that allows a contract to call inline actions.
Without this permission your contract will not be able to call actions on other contracts.

This permission sits on the `active` permission level, so that other contract's using the `require_auth`
function will be able to verify that your contract has the authority to call the action.

To add the code permission you need to update your account's active permission to be controlled by
`<YOURACCOUNT>@eosio.code` **along with your current active permission**.

> ⚠ **Don't lose access!**
>
> The `eosio.code` permission is meant to be **added** to your existing active permission, not replace it.
> If you remove your current active permission controllers (accounts or keys), then you will lose access to 
> your account/contract.

An example permission structure with a Code Permission on the account `yourcontract` would look like:
```text
owner 
  • YOUR_PUBLIC_KEY
↳ active -> 
  • YOUR_PUBLIC_KEY
  • yourcontract@eosio.code
```

