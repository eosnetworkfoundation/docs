# Smart Contracts Basics

A smart contract is a program that runs on the blockchain. It allows you to add functionality to an account ranging from simple ones like a todo application to a fully-fledged RPG game which runs entirely on the blockchain.

This guide will show you how to develop a basic EOS smart contract with **DUNE** and with the C++ programming language.

## Preparation Steps

### Create the Contract Account

To deploy a smart contract you need an account to deploy it to. Create an account `hello` with the following command:

```shell
dune --create-account hello
```

### Create the Test Account

Create a second account, `ama`, for test purposes.

```shell
dune --create-account ama
```

### DUNE

To develop the smart contract you will use the Docker Utilities for Node Execution (DUNE) which is a tool that allows you to perform the functions of node management, compile smart contracts, and several other common tasks required to develop smart contracts on EOS blockchains.

Make sure you have DUNE installed. Otherwise follow the [DUNE development setup](../10_getting-started/10_dune-guide.md#installation) documentation.

## Create the Smart Contract

To create the smart contract you need to:

1. Create a DUNE basic application.
2. Extend the application to perform the custom actions you want to.
3. Build the DUNE application which outputs the smart contract.
4. Deploy the smart contract resulted from building the application.

### Create the DUNE Application

```shell
dune --create-cmake-app hello .
cd hello
ls
```

The result of this command is a `hello` directory with the following structure:

- CMakeLists.txt, cmake configuration file.
- README.txt, a text file which contains information about how to build this application with cmake.
- build, the output build folder, at the beginning is empty.
- include, the C++ include files folder, at the beginning it contains just hello.hpp file.
- ricardian, the folder contains the smart contract ricardian definition, hello.contracts.md file.
- src, the C++ implementation files folder, at the beginning it contains just hello.cpp file.

### Build the DUNE Application

To build the DUNE cmake application run the following command:

```shell
dune --cmake-build <PATH_TO_CMakeLists.txt_PARENT_DIR>
ls <PATH_TO_CMakeLists.txt_PARENT_DIR>/build/hello
```

The result of the above build command are two files located in the `./build/hello/` folder:

- hello.wasm, the WebAssembly binary file for the smart contract.
- hello.abi, the application binary interface (ABI) file for the smart contract.

### Deploy the Smart Contract

Execute the following command to deploy the `hello` smart contract to the `hello` account:

```shell
dune --deploy <PATH_TO_CMakeLists.txt_PARENT_DIR>/build/hello
```

## Smart Contract Source Files

The smart contract C++ source files are:

- hello.hpp
- hello.cpp

### The hpp File

In C++ programming, a `.hpp` file is a header file that contains declarations of classes, functions, variables, and other entities that are intended to be used in other parts of the program. The `.hpp` file is typically included in a source code file (`.cpp`) using the #include preprocessor directive.

The `hello.hpp` contains the `hello` smart contract C++ class declaration.

```cpp
#include <eosio/eosio.hpp>
using namespace eosio;

CONTRACT hello : public contract {
   public:
      using contract::contract;

      ACTION hi( name nm );
};
```

A smart contract class declaration must:

- Be annotated by the [[eosio::contract]] attribute which tells the compiler it is a smart contract class; in the `hello.hpp` generated code the `CONTRACT` `macro` is used, which expands to `class [[eosio::contract]]` C++ code at compilation time.
- Be derived from the `contract` class which provides basic smart contract functionality.
- Define at least a public action function.

> ℹ️ **C++ Macro** ℹ️  
In C++, a `macro` is a way to define a shorthand for a piece of code or a value. When the `macro` is used in the code, the preprocessor automatically replaces it with its corresponding definition before the code is compiled. This can help to make the code more readable and maintainable by reducing repetition and increasing abstraction.

You will learn more about actions later.

### The cpp File

In C++ programming, a `.cpp` file is a source code file that contains C++ code. The `.cpp` file is one of the most important files in a C++ project, as it contains the actual implementation of the code that performs the desired functionality.

The `hello.cpp` file contains the `hello` smart contract C++ class implementation for every member function of the class.

## Actions

An action is a method, defined and implemented by a smart contract class. Actions can have parameters and return values and their responsibility is to execute the business logic of the contract. They can be called by other contracts or by external accounts with the EOS Chain API. Each action may require a specific level of authorization, which can be specified in the action's code.

The `hello` smart contract class has only one action implemented by its `hi` public member function.

```cpp
#include <hello.hpp>

ACTION hello::hi( name nm ) {
   /* fill in action body */
   print_f("Name : %\n",nm);
}
```

The function that implements a smart contract action must be annotated by the `[[eosio::action("action.name")]]` attribute. The `action.name` is optional and if not specified then the action is named by the function name that implements it.
In the `hello.cpp` generated code the `ACTION` macro is used which expands to `[[eosio::action]] void` C++ code at compilation time.

The name of the action must:

- Be no longer than 13 characters.
- Contain only `.`, `a`-`z`, or `1`-`5` characters.
- Not end with `.`.

Note that when you use the `ACTION` macro the action name is the same as the function name that implements it. Because of that the action name inherits the limitations of the C++ function names as well, which means it can not have `.` in it.
If you use the `[[eosio::action("action.name")]]` attribute you can name the action differently than the function name that implements it.

### Send Action

Send the `hi` action to the local node and set as input parameter the `ama` test account name:

```shell
dune --send-action hello hi '[ama]' hello@active
```

The output of the command above shows on one line that `hello::hi` action was executed with the input parameter `{"nm":"ama"}` and on the second line the output of the action itself `Name: ama`.

```txt
#         hello <= hello::hi   {"nm":"ama"}
>> Name : ama
```

## Inline Actions

An inline action is initiated by a smart contract action and is executed within the same transaction as the parent action. Inline actions are useful in situations where a smart contract action needs to interact with another smart contract. Instead of making an external call to the other contract, which could potentially result in a new transaction, the action can be executed inline within the same transaction. If any part of the transaction fails, the inline action will unwind with the rest of the transaction.

The easiest way to execute an inline action is to use `SEND_INLINE_ACTION` macro.

### Send Inline Action

Let's extend the hello smart contract to:

- Implement a new action called `inlineaction` which prints a message at the console.
- Modify the `hi` action to send an inline `inlineaction` action to the blockchain.

```hpp
#include <eosio/eosio.hpp>
using namespace eosio;

CONTRACT hello : public contract {
   public:
      using contract::contract;

      ACTION hi( name nm );
      ACTION inlineaction();
};
```

```cpp
#include <hello.hpp>

ACTION hello::hi( name nm ) {
   print_f("Name : %\n",nm);

   SEND_INLINE_ACTION(*this, inlineaction, {get_self(), "active"_n}, {});
}

ACTION hello::inlineaction() {
   printf("Inline action message.\n");
}
```

The `SEND_INLINE_ACTION` macro third parameter uses the `_n()` string operator to convert `"active"` string into a `name` object. `"active"_n` is a shortcut for `name("active")`. And `name` is an EOS built-in type. You will learn more about built-in types later in this guide.

> ℹ️ **C++ Operator** ℹ️  
In C++ programming, an operator is a symbol or keyword used to perform operations on variables or values. Examples of operators in C++ include arithmetic operators (+, -, *, /), assignment operators (=, +=, -=, *=, /=), comparison operators (==, !=, <, >, <=, >=), logical operators (&&, ||, !), and many others.

Build the smart contract again and deploy it to the local node as you did previously.

Send a `hi` action to the local node and observe that both `hi` and `inlineactions` actions are executed.

```shell
dune --send-action hello hi '[ama]' hello@active
```

```txt
#         hello <= hello::hi                    {"nm":"ama"}
>> Name : ama
#         hello <= hello::inlineaction          ""
>> Inline action message.
```

## Built-in Types

EOS supports several C++ data types for developing smart contracts. Developers can use these types to define data structures and write functions that interact with the EOS blockchain and smart contract system.

This is the full list of built-in types:

| Integral Types | Description |
| --- | --- |
| Header file to include | `<eosio/eosio.hpp>` |
| `bool` | Boolean (true/false) |
| `int8_t` | Signed 8-bit integer |
| `uint8_t` | Unsigned 8-bit integer |
| `int16_t` | Signed 16-bit integer |
| `uint16_t` | Unsigned 16-bit integer |
| `int32_t` | Signed 32-bit integer |
| `uint32_t` | Unsigned 32-bit integer |
| `int64_t` | Signed 64-bit integer |
| `uint64_t` | Unsigned 64-bit integer |
| `int128_t` | Signed 128-bit integer |
| `uint128_t` | Unsigned 128-bit integer |
| Header file to include | `<eosio/varint.hpp>` |
| `signed_int` | Variable-length signed 32-bit integer |
| `unsigned_int` | Variable-length unsigned 32-bit integer |

| Float Types | Description |
| --- | --- |
| Header file to include | `<eosio/eosio.hpp>` |
| `float` | 32-bit floating-point number |
| `double` | 64-bit floating-point number |

| Time Types | Description |
| --- | --- |
| Header file to include | `<eosio/eosio.hpp>` |
| `time_point` | Point in time |
| `time_point_sec` | Point in time with second precision |
| `block_timestamp_type` | Block timestamp |

| Name Type | Description |
| --- | --- |
| Header file to include | `<eosio/eosio.hpp>` |
| `name` | Account name |

| Blob Types | Description |
| --- | --- |
| Header file to include | `<eosio/eosio.hpp>` |
| `bytes` | Raw byte sequence |
| `string` | String |

| Checksum Types | Description |
| --- | --- |
| Header file to include | `<eosio/eosio.hpp>` |
| `checksum160` | 160-bit checksum |
| `checksum256` | 256-bit checksum |
| `checksum512` | 512-bit checksum |

| Cryptography Types | Description |
| --- | --- |
| Header file to include | `<eosio/crypto.hpp>` |
| `public_key` | Public key |
| `signature` | Signature |

| Asset Types | Description |
| --- | --- |
| Header file to include | `<eosio/asset.hpp>` |
| `symbol` | Asset symbol |
| `symbol_code` | Asset symbol code |
| `asset` | Asset |
| `extended_asset` | Asset with extended precision |

## Multi-index Tables

A multi-index table is a database-like data structure that allows developers to store and manage data in a persistent and efficient manner. Multi-index tables are defined using the `TABLE` macro, and can store any number of rows, each of which contains a set of related data elements.

Extend the `hello` contract:

- Add the `userdata` table declaration.
- Add `createrow` action which creates a new non-admin user.
- Add `readrow` action which reads a user's data.
- Add `updaterow` action which updates an existing user's data.
- Add `deleterow` action which deletes an existing user's data.

The hello.hpp file can look like this:

```cpp
#include <eosio/eosio.hpp>
using namespace eosio;

CONTRACT hello : public contract {
   public:
      using contract::contract;

      ACTION hi(name nm);

      ACTION inlineaction();

      // Table actions
      ACTION createrow(name nm);
      ACTION readrow(name nm);
      ACTION updaterow(name nm, bool is_admin);
      ACTION deleterow(name nm);

   private:

   TABLE user_data {
      name user;
      bool is_admin;

      uint64_t primary_key() const { return user.value; }
   };
   using user_data_table = eosio::multi_index<"userdata"_n, user_data>;
};
```

The code above defines a `user_data_table` type, which is a type of a table with name `userdata`, that stores rows defined by the `user_data` structure. The structure contains two fields: the account `name`, and a boolean which says if a user is admin. The `primary_key()` inline method defines the primary key for the table, which in this case is the user's account name represented as a 64-bit unsigned integer value.

The name of a multi-index table has the same restrictions as the name of an action.

### Multi-index: Instantiate with Code and Scope

Developers can use the `user_data_table` type to instantiate a reference **within** the table and perform various operations on that table, such as:

- query the table for specific data,
- insert new rows,
- modify existing rows,
- delete existing rows.

This is how you define a reference within the table with name `userdata`:

```cpp
user_data_table users(get_self(), get_self().value);
```

The first parameter is the `code` parameter, and the second one is the `scope`.

- The `code` (`name`) is the account that owns the smart contract (and the table).

- The `scope` (`integer`) is used to group related data within the multi-index table. To group all related data within the same contract, the scope is often set as the contract account itself.

In the code above, the `code`, is initialized with the `get_self()`, which returns the account the contract is deployed on. The `scope`, is initialized with the `get_self().value`, which returns the numerical representation of the account name.

Note that these two parameters allow you to access different table `instances` of the same table `type`. For example, for the same `code` parameter you can access different tables of the same type by using different values for the second parameter `scope`. All these tables belong to the account set for the same `code` parameter.

Another way to see it is that the `users` object is a reference within the table with name `userdata` (which is of type `user_data_table`). This reference is an address within the RAM storage space, allocated for this table, where the table rows are saved for the `code` and `scope` defined (the `get_self()` and `get_self().value`). The number of tables within the `userdata` table is equal to the number of (`code`, `scope`) pairs used to instantiate table references.

Next implement each action declared in the `hello.hpp` file. Open the `hello.cpp` file and copy and paste the following functions implementations.

### Multi-index: Create Row

This is how to create a row in the `user_data_table`:

```cpp
ACTION hello::createrow(name nm) {
   user_data_table users(get_self(), get_self().value);

   auto itr = users.find(name.value);

   if ( itr == users.end() ) {
      users.emplace(get_self(), [&](auto& row) {
         row.user = nm;
         row.is_admin = false;
      });
      printf("User % added as non-admin.\n", nm);
   }
   else {
      printf("User % already exists.\n", nm);
   }
}
```

The code above uses the `emplace` method to insert a new user into the table.

### Multi-index: Read Row

This is how to query the `user_data_table` based on its primary key:

```cpp
ACTION hello::readrow(name nm) {
   user_data_table users(get_self(), get_self().value);

   auto itr = users.find(nm.value);
   if ( itr != users.end() ) {
      if (itr->is_admin) {
         print_f("User admin % found.\n", itr->user);
      }
      else {
         print_f("User non-admin % found.\n", itr->user);
      }
   }
   else {
      printf("User % not found.\n", nm);
   }
}
```

### Multi-index: Modify Row

This is how to modify an existing row in the `user_data_table`:

```cpp
ACTION hello::updaterow(name nm, bool is_admin) {
   user_data_table users(get_self(), get_self().value);

   auto itr = users.find(nm.value);
   if ( itr != users.end() ) {
      users.modify(itr, get_self(), [&](auto& row) {
         row.is_admin = is_admin;
      });
      print_f("User % is_admin was set to %.\n", itr->user, itr->is_admin);
   }
   else{
      printf("User % not found.\n", nm);
   } 
}
```

### Multi-index: Delete Row

This is how to delete an entity from the `user_data_table`:

```cpp
ACTION hello::deleterow(name nm) {
   user_data_table users(get_self(), get_self().value);

   auto itr = users.find(nm.value);
   if ( itr != users.end() ) {
      users.erase(itr);
      printf("User % erased.\n", nm);
   }
   else{
      printf("User % not found.\n", nm);
   }
}
```

### Multi-index: Test

Build and deploy again the smart contract, send the `createrow` action a couple of times and observe the results:

```shell
dune --send-action hello createrow '[ama]' hello@active
```

```txt
#         hello <= hello::createrow             {"nm":"ama"}
>> User added as non-admin.
```

```shell
dune --send-action hello createrow '[ama]' hello@active
```

```txt
#         hello <= hello::createrow             {"nm":"ama"}
>> User already exists.
```

Note how the first action created the a non-admin user `ama` and the second one did not because the user already existed.

Read the `ama` user data:

```shell
dune --send-action hello readrow '[ama]' hello@active
```

```txt
#         hello <= hello::readrow               {"nm":"ama"}
>> User non-admin ama found.
```

Make the user `ama` admin:

```shell
dune --send-action hello updaterow '[ama, 1]' hello@active
```

```txt
#         hello <= hello::updaterow             {"nm":"ama","is_admin":1}
>> User ama is_admin was set to true.
```

Delete the user `ama`:

```shell
dune --send-action hello deleterow '[ama]' hello@active
```

```txt
#         hello <= hello::deleterow             {"nm":"ama"}
>> User erased.
```

## Singleton

A singleton is a special multi-index table that is designed to store a single row of data for each instance of the singleton type. Singletons are often used to store global state variables or configuration parameters in a contract.

It is important to remember the explanation of code and scope. When you instantiate a singleton, you can keep the code parameter fixed, and vary the scope parameter. This way you save one item per scope, and thus for example, you can store per-account configs.

Here's an example of a singleton declaration:

```cpp
TABLE statsdata {
    int count;
};
using stats_singleton = eosio::singleton<"stats"_n, statsdata>;
```

The code above defines a singleton type `stats_singleton`. This singleton stores statistical data defined by `statsdata` structure. The structure contains the `count` data member which can hold an arbitrary integer value.

Developers can use the `stats_singleton` template type, to instantiate a reference of the singleton table and to perform various operations, such as:

- read the singleton data,
- modify existing singleton data,
- delete existing singleton data.

### Singleton: Instantiate with Code and Scope

The code and scope have the same meaning as for the [multi-index table](#multi-index-code-and-scope).
This is how you instantiate a reference within the singleton with name `stats`. The `code` and `scope` are set as the contract owner account:

```cpp
   stats_singleton stats(get_self(), get_self().value);
```

Extend the `hello` contract to:

- Add the singleton `stats`.
- Add `updatestats` action which updates the stats with a given value.
- Add `readstats` action which reads the stats stored in the singleton.
- Add `deletestats` action which deletes the stats stored in the singleton.

Add the following line at the top of the `hello.hpp` file:

```cpp
#include <eosio/singleton.hpp>
```

Add the singleton related actions:

```cpp
   ACTION updatestats(int value);
   ACTION readstats();
   ACTION deletestats();
```

Add the singleton definition:

```cpp
   TABLE statsdata {
      int count;
   };
   using stats_singleton = eosio::singleton<"stats"_n, statsdata>;
```

### Singleton: Modify Data

This is how you modify the singleton data:

```cpp
ACTION hello::updatestats(int value) {
   stats_singleton stats(get_self(), get_self().value);

   auto current_stats = stats.get_or_create(get_self(), {0});
   current_stats.count = value;
   stats.set(current_stats, get_self());

   print_f("Stats updated with value %.\n", value);
}
```

### Singleton: Read Data

This is how you get the singleton data:

```cpp
ACTION hello::readstats() {
   stats_singleton stats(get_self(), get_self().value);
   
   if (stats.exists()) {
      auto current_stats = stats.get();   
      print_f("Stats value: %\n", current_stats.count);
   }
   else {
      print_f("Stats not initialized.");
   }
}
```

### Singleton: Delete Data

This is how you delete the singleton data:

```cpp
ACTION hello::deletestats() {
   stats_singleton stats(get_self(), get_self().value);
   
   if (stats.exists()) {
      stats.remove();
      print_f("Stats have been removed.");
   }
   else {
      print_f("Stats not initialized.");
   }
}
```

### Singleton: Test

Build and deploy again the smart contract, and send the three new actions which you just added:

```shell
dune --send-action hello readstats '[]' hello@active
```

```txt
#         hello <= hello::readstats             ""
>> Stats not initialized.
```

```shell
dune --send-action hello updatestats '[999]' hello@active
```

```txt
#         hello <= hello::updatestats           {"value":999}
>> Stats updated with value 999.
```

```shell
dune --send-action hello readstats '[]' hello@active
```

```txt
#         hello <= hello::readstats             ""
>> Stats value: 999
```

```shell
dune --send-action hello deletestats '[]' hello@active
```

```txt
#         hello <= hello::deletestats           ""
>> Stats have been removed.
```

```shell
dune --send-action hello readstats '[]' hello@active
```

Note that now stats are not initialized anymore:

```txt
#         hello <= hello::getstats              ""
>> Stats not initialized.
```

## Indexes

Indexes provide efficient and flexible access to data stored in the multi-index tables. An index is a specialized data structure that allows you to look up data in the table based on a certain field, or a combination of fields. Indexes can be used to optimize the performance of queries that retrieve data from the table, and can also enforce uniqueness constraints on the data (only the primary index).

EOS supports two types of indexes:

- primary indexes
- secondary indexes

### Primary Indexes

A primary index is a unique identifier for each row in the multi-index table. It is defined explicitly using the `primary_key()` member function. This function must be defined within the `struct` that represents the table, and must return a value that uniquely identifies each row. In the `hello` smart contract we already have a primary index defined for the `user_balance` table structure definition.

```cpp
uint64_t primary_key() const { return user.value; }
```

### Secondary Indexes

A secondary index is any additional field in the table's structure that can be used to efficiently search and filter the data.
Secondary indexes may be defined on data members which are not unique as well as unique ones. There can be up to 16 secondary indexes. Secondary indices support the following types:

- `uint64_t`
- `uint128_t`
- `uint256_t`
- `double`
- `long double`

If you add a new secondary index to an existing multi-index table it will have an unpredictable outcome since indexes are applied at row insertion or update.

**Advance topic**: Consult the [Data design and migration](https://docs.eosnetwork.com/cdt/latest/best-practices/data-design-and-migration) documentation for more details on how to extended existing, already deployed, multi-index tables.

### Add a Secondary Index

You know now what secondary indexes are and how to define them.
Extend the `hello` smart contract with two new actions:

- `addmsg`, which allows an account to send a message which is saved in a table and indexed by the message content.
- `searchmsg`, which can look up a message using the secondary index defined.

#### Add the Data Structure

At the top of the `hello.hpp` file add the following line:

```cpp
#include <eosio/crypto.hpp>
```

And then, after the previous table definition, add the data structure underlying the `user_messages` table:

```cpp
TABLE user_messages {
    name user;
    std::string message;
    checksum256 messagecks;
    uint64_t time;

    uint64_t primary_key() const { return time; }
    checksum256 message_idx() const { return messagecks; }
};
```

Note in the code above:

- The `primary_key()` method returns the `time` data member. The primary index is unique therefor must be defined over a data member which holds unique values.
- The `message_idx()` method returns the `messagecks` data member which holds the SHA-256 hash of the `message` data.

#### Define the Table with the Secondary Index

In the `hello.hpp` file define the `messages_table` table type with the secondary index:

```cpp
using messages_table = eosio::multi_index<
    "messages"_n,
    user_messages,
    indexed_by<"messageidx"_n, const_mem_fun<user_messages, checksum256, &user_messages::message_idx>>
    >;
```

Note in the code above the `messages_table` is defined almost the same way as you defined earlier the `user_data_table`. What is different this time is the definition of the `"messageidx"` secondary index which is done with the `indexed_by` and `const_mem_fun` templates. The `const_mem_fun` receives three parameters:

- `user_messages`: the multi-index table structure name,
- `checksum256`: the type of the data the index is defined for,
- `&user_messages::message_idx`: a reference to the secondary index function defined in the struct.

The name of a secondary index has the same restrictions as the name of an action.

#### Define and Implement the Actions

In the `hello.hpp` file define the two actions which will make use of the `messages_table` and its `messageidx` secondary index.

```cpp
ACTION searchmsg(std::string message);
ACTION addmsg(name nm, std::string message);
```

In the `hello.cpp` implement the two actions by adding the following code:

```cpp
ACTION hello::addmsg(name nm, std::string message) {
   messages_table messages(get_self(), get_self().value);

   messages.emplace(get_self(), [&](auto& row) {
      row.user = nm;
      row.message = message;
      row.messagecks = eosio::sha256(message.data(), message.size());
      row.time = current_time_point().time_since_epoch().count();
   });
}

ACTION hello::searchmsg(std::string message) {
   messages_table messages(get_self(), get_self().value);
   auto message_idx = messages.get_index<"messageidx"_n>();

   auto messagecks = eosio::sha256(message.data(), message.size());
   auto itr = message_idx.find(messagecks);
   if (itr != message_idx.end()) {
      print_f("First message found. User: %, Message: %\n", itr->user, itr->message);
      for ( auto itr_idx = ++itr; itr_idx->messagecks == messagecks; itr_idx++ ){
         print_f("Other message: User: %, Message: %\n", itr_idx->user, itr_idx->message);
      }
   } else {
      print_f("Message not found.");
   }
}
```

Note in the code above the `eosio::sha256` function returns a fixed-length 256-bit (32-byte) hash value as a checksum256 object. The hash value is computed using the SHA-256 algorithm, which is a widely-used cryptographic hash function. The checksum256 type is a typedef for a fixed-length array of 32 bytes, and is used throughout EOS codebase to represent hash values.

The second action makes use of the secondary index to search for a message by its hash. Please be aware, because it is not a unique index, the first value that matches the search is found, however, multiple rows with the same searched value can exist after it. That's why the `searchmsg` function prints the first message found and all the subsequent ones.

### Indexes: Test

Build and deploy again the smart contract, send the `addmsg` action a couple of times with two different accounts as first parameter and the same message as the second, and then search for the added message to see if it is found:

```shell
dune --send-action hello addmsg '[ama, "good morning sunshine"]' hello@active
dune --send-action hello addmsg '[hello, "good morning sunshine"]' hello@active
```

Find the `good morning sunshine` messages:

```shell
dune --send-action hello searchmsg '["good morning sunshine"]' hello@active
```

```txt
#         hello <= hello::searchmsg             {"message":"good morning sunshine"}
>> First message found. User: ama, Message: good morning sunshine
>> Other message: User: hello, Message: good morning sunshine
```

## Assertions

An assertion is a mechanism that checks whether a certain condition is true during the execution of a contract. If the condition is not true, the assertion will cause the contract to terminate with an error message.

### Use assert()

Implement an assertion check with standard error message like this:

```cpp
assert(message.size() <= 10);
```

### Use check()

Implement an assertion check with a custom error message like this:

```cpp
check(message.size() <= 10, "Message can not be bigger than 10 characters.");
```

### Extend Smart Contract with Asserts

Add the above checks to the `addmsg` implementation, compile and deploy the contract again each time and then execute the command to sign and send the action to the blockchain:

```shell
dune --send-action hello addmsg '[ama, "01234567891"]' ama@active
```

This is the standard error message you see when you use the `assert()` function:

```txt
failed transaction: 50c7566e784a34509e02e4775e6b63b5978d3ddf5ab02618bee8c8a68ff5ce8d  <unknown> bytes  <unknown> us
error 2023-03-01T16:49:50.792 cleos     main.cpp:700                  print_result         ] soft_except->to_detail_string(): 3050008 abort_called: Abort Called
abort() called
    {}
    nodeos  cf_system.cpp:7 abort
pending console output: Assertion failed: message.size() <= 10 (hello.cpp: addmsg: 94)

    {"console":"Assertion failed: message.size() <= 10 (hello.cpp: addmsg: 94)\n"}
    nodeos  apply_context.cpp:124 exec_one
```

This is the custom error message you see when you use the `check()` function:

```txt
failed transaction: 6d18bc090aa65880b28a4f697e8bf08999e68d209c2a1367f16d596e11bbed02  <unknown> bytes  <unknown> us
error 2023-03-01T16:54:04.555 cleos     main.cpp:700                  print_result         ] soft_except->to_detail_string(): 3050003 eosio_assert_message_exception: eosio_assert_message assertion failure
assertion failure with message: Message can not be bigger than 10 characters.
    {"s":"Message can not be bigger than 10 characters."}
    nodeos  cf_system.cpp:14 eosio_assert
pending console output: 
    {"console":""}
    nodeos  apply_context.cpp:124 exec_one
```

## Authorization

When a user or contract attempts to send an action, the action can be validated by the EOS blockchain software. This validation process includes checking that the user or contract has the authorization to perform the action.

The `hello` contract does not perform any authorization checks. Any account could send any of the 'hello' contract's actions to the blockchain and they would be executed.

Send `hi` action and sign it with the `hello@active` private key succeeds:

```shell
dune --send-action hello addmsg '[ama, "hi again"]' hello@active
```

```txt
#         hello <= hello::addmsg                {"nm":"ama","message":"hi again"}
```

Send `hi` action and sign it with the `ama@active` private key succeeds as well:

```shell
dune --send-action hello addmsg '[ama, "hi again"]' ama@active
```

```txt
#         hello <= hello::addmsg                {"nm":"ama","message":"hi again"}
```

You can implement an authorization check to allow only certain accounts or just one account to execute the `hello` contract's actions.

### Use check() with has_auth()

To perform an authorization check use the `check()` function in combination with the `has_auth` function. This combination enforces the action `addmsg` to be executed only by the account that is sent as first parameter, no matter what permission the account uses to sign the transaction (e.g. owner, active, code). If the check fails it raises an error with a custom message.

```cpp
ACTION hello::addmsg(name nm, std::string message) {

    check(has_auth(user), "User is not authorized to perform this action.");

    messages_table messages(get_self(), get_self().value);

    messages.emplace(get_self(), [&](auto& row) {
        row.user = nm;
        row.message = message;
        row.messagecks = eosio::sha256(message.data(), message.size());
        row.time = current_time_point().time_since_epoch().count();
    });
}
```

Compile and deploy the smart contract, send the `addmsg` action with first parameter `ama` and sign it with `hello@active` key and then observe how it fails with the custom error message:

```cpp
dune --send-action hello addmsg '[ama, "hi again"]' hello@active
```

```txt
failed transaction: 6d2e11e24d9adc066136f94bc66c13df2dfce952f1a5a0fa7a0286043a67f0c6  <unknown> bytes  <unknown> us
error 2023-03-01T15:44:02.588 cleos     main.cpp:700                  print_result         ] soft_except->to_detail_string(): 3050003 eosio_assert_message_exception: eosio_assert_message assertion failure
assertion failure with message: User is not authorized to perform this action.
    {"s":"User is not authorized to perform this action."}
    nodeos  cf_system.cpp:14 eosio_assert
pending console output: 
    {"console":""}
    nodeos  apply_context.cpp:124 exec_one
```

### Use require_auth()

It does the same thing as the previous combination only that you can not customize the error message raised in case of failure.

```cpp
ACTION hello::addmsg(name nm, std::string message) {

    require_auth( nm );

    messages_table messages(get_self(), get_self().value);

    messages.emplace(get_self(), [&](auto& row) {
        row.user = nm;
        row.message = message;
        row.messagecks = eosio::sha256(message.data(), message.size());
        row.time = current_time_point().time_since_epoch().count();
    });
}
```

Compile and deploy the smart contract, send the `addmsg` action with first parameter `ama` and sign it with `hello@active` key, and then observe how it fails with a standard error message:

```cpp
dune --send-action hello addmsg '[ama, "hi again"]' hello@active
```

```txt
failed transaction: 8887cca7fababeb883aa6806c220eece3d5f3c618824b2378ac25a67c09a063a  <unknown> bytes  <unknown> us
error 2023-03-01T15:53:35.033 cleos     main.cpp:700                  print_result         ] soft_except->to_detail_string(): 3090004 missing_auth_exception: Missing required authority
missing authority of ama
    {"account":"ama"}
    nodeos  apply_context.cpp:256 require_authorization
pending console output: 
    {"console":""}
    nodeos  apply_context.cpp:124 exec_one
```

### Use require_auth2()

The `require_auth2()` enforces the execution only by the account that is set as the first parameter and only if the permission used to sign the transaction is the one specified as the second parameter. If the check fails it raises a standard error message which can not be customized.

```cpp
ACTION hello::addmsg(name nm, std::string message) {

   require_auth2(nm.value, "active"_n.value);

   messages_table messages(get_self(), get_self().value);

   messages.emplace(get_self(), [&](auto& row) {
      row.user = nm;
      row.message = message;
      row.messagecks = eosio::sha256(message.data(), message.size());
      row.time = current_time_point().time_since_epoch().count();
   });
}
```

Compile and deploy the smart contract, send the `addmsg` action with first parameter `ama`, sign it with `ama@owner` private key, and then observe how it fails with a standard error message:

```shell
dune --send-action hello addmsg '[ama, "hi again"]' ama@owner
```

Even if the `ama@owner` private key was used to sign the above transaction, the execution fails because the required signature is the `ama@active`.

```txt
failed transaction: 7dcb10621e4102ec933cdbaf544f0204446cc96bc20b76242391b17286f1408e  <unknown> bytes  <unknown> us
error 2023-03-01T16:00:02.853 cleos     main.cpp:700                  print_result         ] soft_except->to_detail_string(): 3090004 missing_auth_exception: Missing required authority
missing authority of ama/active
    {"account":"ama","permission":"active"}
    nodeos  apply_context.cpp:275 require_authorization
pending console output: 
    {"console":""}
    nodeos  apply_context.cpp:124 exec_one
```

## Events

EOS smart contract developers can use an eventing mechanism which allows them to implement a smart contract that listens to notifications sent by another smart contract action. The EOS eventing mechanism is defined by two actors:

- The smart contract that raises an event from one of its action.
- The smart contract that listens to the event raised by the first smart contract's action.

### require_recipient()

To raise an event from a smart contract action use the `require_recipient()` function which adds the specified recipient account to the set of accounts to be notified. After the current action is executed a notification is sent to each recipient account from the list. And if those accounts have a smart contract deployed which implements the `on_notify()` method with the sending contract account and action registered then they will be able to receive the notification and act accordingly.

### on_notify()

To listen to the event raised by a smart contract's action implement the `on_notify()` function and register it for that particular smart contract and its action.

Implement a second smart contract that listens to `hello::addmsg` action notifications.

```shell
dune --create-cmake-app hellolisten ./
```

Open the `hellolisten.hpp` and implement the `on_notify()` method as shown below:

```cpp
#include <eosio/eosio.hpp>

using namespace eosio;

CONTRACT hellolisten : public contract {
   public:
      using contract::contract;

      ACTION hi( name nm );

      [[eosio::on_notify("hello::addmsg")]]
      void handle_addmsg(name nm, std::string message) {
         // take action based on this notification
         print_f("Notification received. From: %, message: %\n", nm, message);
      }

   private:
};
```

Change the `hello::addmsg` action to raise the event for the `hellolisten` contract account whenever a new message is added.

```cpp
ACTION hello::addmsg(name nm, std::string message) {

   check(has_auth(nm), "User is not authorized to perform this action.");
   check(message.size() <= 10, "Message can not be bigger than 10 characters.");

   require_recipient("hellolisten"_n);

   messages_table messages(get_self(), get_self().value);

   messages.emplace(get_self(), [&](auto& row) {
      row.user = nm;
      row.message = message;
      row.messagecks = eosio::sha256(message.data(), message.size());
      row.time = current_time_point().time_since_epoch().count();
   });
}
```

Create an account `hellolisten`, and then build and deploy the new smart contract to the newly created account.

```shell
dune --create-account hellolisten
dune --cmake-build ./hellolisten/
dune --deploy ./hellolisten/build/hellolisten hellolisten
```

Send an `addmsg` to the `hello` contract and observe its output:

```shell
dune --send-action hello addmsg '[ama, "hi notify"]' ama@active
```

```txt
#         hello <= hello::addmsg                {"nm":"ama","message":"hi notify"}
#   hellolisten <= hello::addmsg                {"nm":"ama","message":"hi notify"}
>> Notification received. From: ama, message: hi notify
```

Note in the output, the last two lines show that:

- the `hello::addmsg` action with its params were sent to `hellolisten` account and
- the `hellolisten::on_notify` method was executed; as a result the two input parameters were printed at the console.
