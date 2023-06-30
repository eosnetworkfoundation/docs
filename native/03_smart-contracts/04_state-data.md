---
title: State Data
---

There are two types of data in a smart contract: state data and transient data. State data is data that is stored on the
blockchain, and is persistent. Transient data is data that is stored during the execution of a transaction, and is not
persistent. The second the transaction is over, the transient data is gone.

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
decision. For now, you will just use the contract itself as the RAM payer.

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

As you can see above, you can have the same primary key in different scopes without there being a conflict. This is useful in a variety of different cases:
- If you want to store data per-user
- If you want to store data per-game-instance
- If you want to store data per-user-inventory
- etc


## Multi-Index Table

The multi-index table is the most common way to store data on the EOS blockchain. It is a persistent key-value store that
can be indexed in multiple ways, but always has a primary key. Going back to the NoSQL database analogy, you can think
of the multi-index table as a collection of documents, and each index as a different way to query or fetch data from the collection.

### Defining a table

To create a multi-index table you must have a model defined with at least a primary key. You can then create a multi-index
table by using the `multi_index` template, and passing in the name of the table/collection and the model you want to use.

```cpp
TABLE UserModel ...

using users_table = multi_index<"users"_n, UserModel>;
```

This will create a table called `users` that uses the `UserModel` model. You can then use this table to store and retrieve
data from the blockchain.


### Instantiating a table

To do anything with a table, you must first instantiate it. To do this, you must pass in the contract that owns the table,
and the scope that you want to use.

```cpp
ACTION test() {
    name thisContract = get_self();
    users_table users(thisContract, thisContract.value);
```


### Inserting data

Now that you have a reference to an instantiated table, you can insert data into it. To do this, you can use the `emplace`
function, which takes a lambda/anonymous function that accepts a reference to the model that you want to insert.

```cpp
...

name ramPayer = thisContract;
users.emplace(ramPayer, [&](auto& row) {
    row.id = 1;
    row.eos_account = name("eosio");
});
```

You can also define a model first, and insert it into the entire row.

```cpp
UserModel user = {
    .id = 1,
    .eos_account = name("eosio")
};

users.emplace(ramPayer, [&](auto& row) {
    row = user;
});
```

### Retrieving data

To retrieve data from a table, you will use the `find` method on the table, which takes the primary key of the row that
you want to retrieve. This will return an iterator (reference) to the row.

```cpp
auto iterator = users.find(1);
```

You need to check if you actually found the row, because if you didn't, then the iterator will be equal to the `end` iterator,
which is a special iterator that represents the end of the table.

```cpp
if (iterator != users.end()) {
    // You found the row
}
```

You then have two ways of accessing the data in the row. The first way is to use the `->` operator, which will give you
a pointer to the row's data, and the second way is to use the `*` operator, which will give you the row's raw data.

```cpp
UserModel user = *iterator;
uint64_t idFromRaw = user.id;
uint64_t idFromRef = iterator->id;
```


### Modifying data

If you tried to call `emplace` twice you would get an error because the primary key already exists. To modify data
in a table, you must use the `modify` method, which takes a reference to the iterator you want to modify, a RAM payer,
and a lambda/anonymous function that allows us to modify the data.

```cpp
users.modify(iterator, same_payer, [&](auto& row) {
    row.eos_account = name("foobar");
});
```

> ❔ **What is same_payer**
> 
> The `same_payer` variable is a special variable that is used to indicate that the RAM payer should be the same as the
> original RAM payer. This is useful when you want to modify data in a table, but you don't have the original RAM payer's
> authorization. This is often the case when you want to modify data in a table on your own contract that was inserted 
> using another user's RAM. You will not be able to add any fields to the data, but if you are only modifying existing fields
> then there is no delta in RAM usage, and therefore no need to pay for any additional RAM or refund any surplus RAM.


### Removing data

To remove data from a table, you must use the `erase` method, which takes a reference to the iterator you want to remove.

```cpp
users.erase(iterator);
```


### Using a secondary index

Using a secondary index will allow you to query your table in a different way. For example, if you wanted to query your
table by the `eos_account` field, you will need to create a secondary index on that field.

#### Redefining our model and table

To use a secondary index, you must first define it in your model. You do this by using the `indexed_by` template, and passing
in the name of the index, and the type of the index.

```cpp
TABLE UserModel {
    uint64_t id;
    name eos_account;

    uint64_t primary_key() const { return id; }
    uint64_t account_index() const { return eos_account.value; }
};

using users_table = multi_index<"users"_n, UserModel,
    indexed_by<"byaccount"_n, const_mem_fun<UserModel, uint64_t, &UserModel::account_index>>
>;
```

The `indexed_by` template can be a bit confusing, so let's break it down.

```cpp
indexed_by<
    <name_of_index>,
    const_mem_fun<
        <model_to_use>, 
        <index_type>,
        <pointer_to_index_function>
    >
>
```

The `name_of_index` is the name of the index that you want to use. This can be anything, but it's best to use something
that describes what the index is for.

The `model_to_use` is the model that you want to use for the index. This is usually the same model that you are using for
the table, but it doesn't have to be. This is useful if you want to use a different model for the index, but still want
to be able to access the data in the table.

The `index_type` is the type of the index, and is limited to the types we discussed earlier.

The `pointer_to_index_function` is a pointer to a function that returns the value that you want to use for the index. This
function must be a `const_mem_fun` function, and must be a member function of the model that you are using for the index.

#### Using the secondary index

Now that you have a secondary index, you can use it to query your table. To do this, first get the index from the table, and
then use the `find` method on the index, instead of using it directly on the table.

```cpp
auto index = users.get_index<"byaccount"_n>();
auto iterator = index.find(name("eosio").value);
```

To modify data in the table using the secondary index, you use the `modify` method on the index, instead of using it
directly on the table.

```cpp
index.modify(iterator, same_payer, [&](auto& row) {
    row.eos_account = name("foobar");
});
```

## Singleton Table

A `singleton` table is a special type of table that can only have one row per scope. This is useful for storing data that
you only want to have one instance of, such as a configuration, or a player's inventory.

The primary differences between a `singleton` table and a multi-index table are:
- Singletons do not need a primary key on the model
- Singletons can store any type of data, not just predefined models

### Defining a table

To define a singleton table, you use the `singleton` template, and pass in the name of the table, and the type of the
data that you want to store.

You also must import the `singleton.hpp` header file.

```cpp
#include <eosio/singleton.hpp>

TABLE ConfigModel {
    bool is_active;
};

using config_table = singleton<"config"_n, ConfigModel>;

using is_active_table = singleton<"isactive"_n, bool>;
```

The `singleton` template is identical to the `multi_index` template, except that it does not support secondary indices.

You've defined one table that stores a `ConfigModel`, and another table that stores a `bool`. Both tables hold the 
exact same data, but the `bool` table is more efficient because it does not need to store the added overhead that is
caused by the `ConfigModel` struct.

### Instantiating a table

Just like the `multi_index` table, you must first instantiate the table, and then you can use it.

```cpp
name thisContract = get_self();
config_table configs(thisContract, thisContract.value);
```

The `singleton` table takes two parameters in its constructor. The first parameter is the contract that the table is
owned by, and the second parameter is the `scope`.

### Getting data

There are a few ways to get data from a `singleton`. 

#### Get or fail

This will error out at runtime if there is no existing data.
To prevent this, you can use the `exists` method to check if there is existing data.

```cpp
if (!configs.exists()) {
    // handle error
}
ConfigModel config = configs.get();
bool isActive = config.is_active;
```

#### Get or default

This will return a default value, but **will not** persist the value.

```cpp
ConfigModel config = configs.get_or_default(ConfigModel{
  .is_active = true
});
```

#### Get or create

This will return a default value, and **will** persist the value.

```cpp
ConfigModel config = configs.get_or_create(ConfigModel{
  .is_active = true
});
```

### Setting data

To persist data in a `singleton`, you can use the `set` method, which takes a reference to the data that you want to set.

```cpp
configs.set(ConfigModel{
    .is_active = true
}, ramPayer);
```

### Removing data

Once you've instantiated a `singleton`, it's easy to remove it. Just called the `remove` method on the instance itself.

```cpp
configs.remove();
```


