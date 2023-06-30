---
title: "Understanding ABI Files"
---

An `ABI` file (or Application Binary Interface) is a JSON file that describes how to integrators or users of your smart
contracts can interact with them. It describes the actions and data structures of your smart contract, and how to convert them
to and from JSON.

ABI files are generated from the smart contract source code, but it is also possible to write them manually (though it's not recommended).

Understanding them will allow you to write better smart contracts, and to debug them more easily.


## Example ABI

```cpp
CONTRACT mycontract : public contract {
   public:
      using contract::contract;
      TABLE user {
         name     eos_account;
         uint8_t  is_admin;

         uint64_t primary_key() const { 
            return eos_account.value; 
         }
      };

      using user_table = eosio::multi_index<"users"_n, user>;

      ACTION newuser( name eos_account ){}
};
```

The code above will produce the following JSON ABI:

```json
{
    "version": "eosio::abi/1.2",
    "types": [],
    "structs": [
        {
            "name": "newuser",
            "base": "",
            "fields": [
                {
                    "name": "eos_account",
                    "type": "name"
                }
            ]
        },
        {
            "name": "user",
            "base": "",
            "fields": [
                {
                    "name": "eos_account",
                    "type": "name"
                },
                {
                    "name": "is_admin",
                    "type": "uint8"
                }
            ]
        }
    ],
    "actions": [
        {
            "name": "newuser",
            "type": "newuser",
            "ricardian_contract": ""
        }
    ],
    "tables": [
        {
            "name": "users",
            "type": "user",
            "index_type": "i64",
            "key_names": [],
            "key_types": []
        }
    ],
    "ricardian_clauses": [],
    "variants": [],
    "action_results": []
}
```

## ABI elements

### Version

The version of the ABI is used to ensure compatibility. It is a string in the format `eosio::abi/X.Y`, where `X` and `Y` are integers.

```json
"version": "eosio::abi/1.2",
```

### Types

Types are custom types defined in the contract. They are often used to make contract development more readable and maintainable.

```json
"types": [{
 "new_type_name": "name",
 "type": "name"
}],
```

### Structs

Structs are custom data structures defined in the contract. They are often used as a model to store within database tables.


#### Base structure

```json
{
  "name": "issue",     // The name
  "base": "",          // Inheritance, parent struct
  "fields": []         // Array of field structures
}
```

#### Field structure

```json
{
  "name":"",  // The field's name
  "type":""   // The field's type
}
```

#### Example struct
```json
{
  "name": "newuser",
  "base": "",
  "fields": [
    {
      "name": "eos_account",
       "type": "name"
    }
  ]
}
```

### Actions

Actions are the callable functions of the contract. They are what users of the contract interact with 
when they want to perform operations on the blockchain.

```json
{
  "name": "newuser",           // The name of the action as defined in the contract
  "type": "newuser",           // The name of the implicit parameter struct as described in the action interface
  "ricardian_contract": ""     // An optional ricardian clause to associate to this action describing its intended functionality.
}
```

### Tables

Tables are the persistent data structures of the contract. They are the location of data stored within the blockchain.

```json
{
  "name": "",       // The name of the table, determined during instantiation.
  "type": "",       // The table's corresponding struct
  "index_type": "", // The type of primary index of this table
  "key_names" : [], // An array of key names, length must equal length of key_types member
  "key_types" : []  // An array of key types that correspond to key names array member, length of array must equal length of key names array.
}
```

An example of a filled out table:

```json
{
  "name": "accounts",
  "type": "account", // Corresponds to previously defined struct
  "index_type": "i64",
  "key_names" : ["primary_key"],
  "key_types" : ["uint64"]
}
```

### Comments

You may add a comment to your ABI file which will be ignored by tooling.

```json
"___comment" : "Your comment here"
```
