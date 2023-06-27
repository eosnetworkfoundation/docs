---
title: Reading State
---

Storing data on the blockchain is one of the most important features of a smart contract.

There are two parts to storing data on the blockchain: the model and the table. The model is the data structure that you
will be storing, and the table is the container that holds the data. There are a few different types of tables, and each
one has its own use case.

## Data Models

A model is a data structure that you will be storing in an EOS++ table. It is a serializable C++ struct, and can contain 
any data type that is also serializable. All common data types are serializable, and you can also create your own
serializable data types, such as other models that start with the `TABLE` keyword.

```cpp
TABLE UserModel {
    uint64_t id;
    name eos_account;
    
    uint64_t primary_key() const { return id; }
};
```

Defining a model is very similar to defining a C++ struct, but with a few differences. The first difference is that you
must use the `TABLE` keyword instead of the `struct` keyword. The second difference is that you must define a `primary_key`
function that returns a `uint64_t`. This function is used to determine the primary key of the table, which is used to
index the table.

Think of this like a NoSQL database, where the primary key is the index of the table. The primary key is used to
determine the location of the data in the table, and is used to retrieve the data from the table easily and efficiently.

### Primary key data types

The primary key **must** be a `uint64_t` (you can also use `name.value`), and it must be unique for each row in the table. This means that you cannot
have two rows with the same primary key. If you need to have multiple rows with the same primary key, you can use a
secondary index.

### Secondary key data types

A secondary index is more flexible than a primary key, and can be any of the following data types:

- `uint64_t`
- `uint128_t`
- `double`
- `long double`
- `checksum256`

They can also include duplicate values, which means that you can have multiple rows with the same secondary key.

> 💰 **Cost considerations**
> 
> Each index costs RAM per row, so you should only use secondary indices when you need to. If you don't need to query the table
> by a certain field, then you should not create an index for that field.

## Payer & Scope

Before we dig into how to store data in tables, we need to talk about `scope` and `payer`.

### RAM Payer

The RAM payer is the account that will pay for the RAM that is used to store the data. This is either the account that
is calling the contract, or the contract itself. This sometimes relies heavily on game-theory, and can be a complex
decision. For now, we will just use the contract itself as the RAM payer.

You also cannot have an account that isn't part of the transaction's authorizations pay for RAM.

> 💰 **Beware of RAM**
>
> RAM is a limited resource on the EOS blockchain, and you should be careful about how much RAM you allow others to use on
> your contracts. It's often better to make the user pay for the RAM, but this requires that you create incentives for them
> to spend their own RAM in return for something of perceived equal or greater value.


### Scope

The scope of a table is a way to further segregate the data in the table. It is a `uint64_t` that is used to determine
what _bucket_ the data is stored in.

If we were to imagine the database as a `JSON` object, it might look like this:

```json title="tables.json"
{
    "users": {
        1: [
            {
                "id": 1,
                "eos_account": "bob"
            },
            {
                "id": 2,
                "eos_account": "sally"
            }
        ],
        2: [
            {
                "id": 1,
                "eos_account": "joe"
            }
        ]
    }
}
```

As you can see above, we can have the same primary key in different scopes without there being a conflict. This is useful in a variety of different cases:
- If you want to store data per-user
- If you want to store data per-game-instance
- If you want to store data per-user-inventory
- etc


## Multi-Index Table

The multi-index table is the most common way to store data on the EOS blockchain. It is a persistent key-value store that
can be indexed in multiple ways, but always has a primary key. Going back to our NoSQL database analogy, you can think
of the multi-index table as a collection of documents, and each index as a different way to query or fetch data from the collection.

### Defining a table

To create a multi-index table you must have a model defined with at least a primary key. You can then create a multi-index
table by using the `multi_index` template, and passing in the name of the table/collection and the model we want to use.

```cpp
using users_table = multi_index<"users"_n, UserModel>;
```

This will create a table called `users` that uses the `UserModel` model. You can then use this table to store and retrieve
data from the blockchain.



### Insert Data

To store data in the table, you must first create an instance of the model, and then call the `emplace` function on the table.

```cpp
name thisContract = get_self();
users_table users(thisContract, thisContract.value);

name ramPayer = thisContract;
users.emplace(ramPayer, [&](auto& row) {
    row.id = 1;
    row.eos_account = name("eosio");
});
```

The first argument to the `emplace` function is the payer of the data, which is the account that will pay for the RAM



