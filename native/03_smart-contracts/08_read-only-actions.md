---
title: Read-only Actions
---

Though you have direct access to the table data through `get_table_rows` (as discussed in the 
[reading state section](../04_web-applications/05_reading-state.md) of the web applications chapter),
the preferred way to read data from a smart contract is through read-only actions.

## What is a read-only action?

A read-only action is an action that does not modify the state of the blockchain.

It is a way to query data from a smart contract without changing its state, while also allowing the 
contract developer to define alternative structures for the data returned that isn't just the raw table data.

## Creating a read-only action

You create these in a similar way to regular actions, but you need to specify that the action is read-only.

```cpp
[[eosio::action, eosio::read_only]]
bool isactive(name user) {
    // Your logic here
    return true;
}
```

## Sending a read-only action

You shouldn't use the normal `push_transaction` or `send_transaction` API methods to call a read-only action.
Read-only actions do not need authorization arrays, or signatures, so to take advantage of this you can 
use the [`send_read_only_transaction` API method](https://docs.vaulta.com/apis/spring/latest/chain.api#operation/send_read_only_transaction) instead.

### Using Wharfkit

If you are using [Wharfkit](https://wharfkit.com) (and you should be), you can call a read-only action like this:

```javascript
import { APIClient, Chains } from "@wharfkit/antelope"
import { ContractKit } from "@wharfkit/contract"

const contractKit = new ContractKit({
  client: new APIClient(Chains.Vaulta.url),
})

const contract = await contractKit.load("some.contract")

// .readonly(action, data?)
const result = await contract.readonly('isactive', {
    user: 'some.user'
});
```

## Returning complex data

Read-only actions can return complex data structures, not just simple types like `bool` or `uint64_t`.

```cpp
struct Result {
    name user;
    uint64_t balance;
    std::string status;
};

[[eosio::action, eosio::read_only]]
Result getuser(name user) {
    return Result{user, 1000, "active"};
}
```

## Limitations & Benefits

Read-only actions have some limitations:
- They cannot modify the state of the blockchain
- They cannot call other actions that modify state
- They cannot return data to another action, only to external callers (like web applications)

However, they also have benefits:
- They are not billed for CPU or NET usage
- They do not require authorization or signatures 
- You can combine data from multiple tables, saving HTTP requests
- You can return data in a format that is more convenient for your application