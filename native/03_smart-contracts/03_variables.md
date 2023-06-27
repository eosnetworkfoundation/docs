---
title: Variables
---

Defining variables is a fundamental part of any programming language. In this section, we will look at
the different types of variables you can define in EOS Smart Contracts.

C++ supports a wide range of data types. EOS++ extends the set of types with EOS-specific types.

## Defining variables

Variables are defined in the same way as in C++.

```cpp
function main() {
    // <type> <name> = <value>;
    int a = 5;
}
```


## Basic types

These are the basic types that come built-in with C++. You have likely used some form of these types before
in other programming languages you have used.

Unless otherwise specified, the types below are imported from the `<eosio/eosio.hpp>` header.

```cpp
#include <eosio/eosio.hpp>
```

### Integer types

Integer types are used to represent whole numbers. They can be either signed (positive or negative) or unsigned (positive only).


| Integer Types         | Description |
|------------------------| --- |
| `bool`                 | Boolean (true/false) |
| `int8_t`               | Signed 8-bit integer |
| `int16_t`              | Signed 16-bit integer |
| `int32_t`              | Signed 32-bit integer |
| `int64_t`              | Signed 64-bit integer |
| `int128_t`             | Signed 128-bit integer |
| `uint8_t`              | Unsigned 8-bit integer |
| `uint16_t`             | Unsigned 16-bit integer |
| `uint32_t`             | Unsigned 32-bit integer |
| `uint64_t`             | Unsigned 64-bit integer |
| `uint128_t`            | Unsigned 128-bit integer |

#### Required Header

```cpp
#include <eosio/varint.hpp>
```

| Integer Types         | Description |
|------------------------| --- |
| `signed_int`           | Variable-length signed 32-bit integer |
| `unsigned_int`         | Variable-length unsigned 32-bit integer |


### Floating-Point types

Floating-point types are used to represent decimal numbers.

> ⚠ **Warning**
> 
> Floating-point types are not precise. They are not suitable for storing currency values, and are often
> problematic for storing other types of data as well. Use them with caution, especially when dealing with
> blockchains.

| Float Types | Description |
| --- | --- |
| `float` | 32-bit floating-point number |
| `double` | 64-bit floating-point number |

### Byte types

Byte types are used to represent raw byte sequences, such as binary data / strings.

| Blob Types | Description |
| --- | --- |
| `bytes` | Raw byte sequence |
| `string` | String |

### Time types

Time types are used to represent time, specifically relating to blocks.

| Time Types | Description                   |
| --- |-------------------------------|
| `time_point` | Point in time in microseconds |
| `time_point_sec` | Point in time in seconds      |
| `block_timestamp_type` | Block timestamp               |


### Hash types

Hash types are used to represent cryptographic hashes such as SHA-256.

| Checksum Types | Description |
| --- | --- |
| `checksum160` | 160-bit checksum |
| `checksum256` | 256-bit checksum |
| `checksum512` | 512-bit checksum |

## Custom types

These are the custom types that come built-in with EOS++. You will likely use some of these types often in your EOS Smart Contracts.

### Name type

The `name` type is used to represent account names. It is a 64-bit integer, but is displayed as a string.

A variety of system functions require names as parameters.

You have three ways of turning a string into a name:
- `name{"string"}`
- `name("string")`
- `"string"_n`

If you want to get the `uint64_t` value of a name, you can use the `value` method.

```cpp
name a = name("hello");
uint64_t b = a.value;
```

### Key and Signature types

The `public_key` and `signature` types are used to represent cryptographic keys and signatures, and are
also an EOS++ specific type.

#### Required Header

```cpp
#include <eosio/crypto.hpp>
```

#### Recovering a key from a signature

```cpp
function recover(checksum256 hash, signature sig) {
    public_key recovered_key = recover_key(hash, sig);
}
```

### Asset types

The `asset` type is used to represent a quantity of a digital asset. It is a 64-bit integer with a symbol, but is displayed as a string.

It is resistent to overflow and underflow, and has various methods for performing arithmetic operations easily.

#### Required Header

```cpp
#include <eosio/asset.hpp>
```

| Asset Types | Description |
| --- | --- |
| `symbol` | Asset symbol |
| `symbol_code` | Asset symbol code |
| `asset` | Asset |

#### Creating an asset

There are two parts to an asset: the quantity, and the symbol. The quantity is a 64-bit integer, and the symbol
is a combination of a string and a precision.

```cpp
// symbol(<symbol (string)>, <precision (1-18)>)
symbol mySymbol = symbol("TKN", 4);

// asset(<quantity (int64_t)>, <symbol>)
asset myAsset = asset(1'0000, mySymbol);
```

#### Performing arithmetic operations

You can easily do arithmetic operations on assets.

```cpp
asset a = asset(1'0000, symbol("TKN", 4));
asset b = asset(2'0000, symbol("TKN", 4));

asset c = a + b; // 3'0000 TKN
asset d = a - b; // -1'0000 TKN
asset e = a * 2; // 2'0000 TKN
asset f = a / 2; // 0'5000 TKN
```

> ?? **Symbol matching**
> 
> Doing arithmetic operations on assets with different symbols will throw an error, but only during runtime. Make sure that 
> you are always doing operations on assets with the same symbol.

#### Asset methods

You can convert an asset to a string using the `to_string` method.

```cpp
std::string result = a.to_string(); // "1.0000 TKN"
```

You can also get the quantity and symbol of an asset using the `amount` and `symbol` methods.

```cpp
int64_t quantity = a.amount; // 1'0000
symbol sym = a.symbol; // symbol("TKN", 4)
```

When using an asset, you always want to make sure that it is valid (that the amount is within range).

```cpp
bool valid = a.is_valid();
```


#### Symbol methods

You can convert a symbol to a string using the `to_string` method.

```cpp
std::string result = mySymbol.to_string(); // "4,TKN"
```

You can also get the raw `uint64_t` value of a symbol using the `value` method.

```cpp
uint64_t value = mySymbol.value;
```

When using a symbol by itself, you always want to make sure that it is valid. **However, when using asset, it already checks 
the validity of the symbol within its own `is_valid` method.**

```cpp
bool valid = mySymbol.is_valid();
```


## Structs

Structs are used to represent complex data. They are similar to classes, but are simpler and more lightweight. Think of a
`JSON` object.

You can use these in EOS++, but if you are storing them in a table you should use the `TABLE` keyword which we will discuss in the 
[next section](/docs/03_smart-contracts/04_state-data.md).

```cpp
struct myStruct {
    uint64_t id;
};
```
