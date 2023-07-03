---
title: Variables
---

Defining variables is a fundamental part of any programming language. In this section, we will look at
the different types of variables you can define in Solidity.

## Defining variables

Variables are defined using the following syntax:

```solidity
// <type> <name> = <value?>;
uint256 myVariable = 123;
uint256 myOtherVariable;
```

> 📘 **Variable default values**
>
> If you do not assign a value to a variable, it will be assigned a default value. The default value depends on the type of the variable.
> You can generally infer the default value from the type name. For example, `uint256` will default to `0`, and `bool` will default to `false`.
> Keep this in mind when writing your smart contracts, as you might not expect an integer to have a value of `0` when you first define it.

## Integers & boolean

Integer types are used to represent whole numbers. They can be either signed (positive or negative) or unsigned (positive only).


| Integer Types         | Description |
|------------------------| --- |
| `bool`                 | Boolean (true/false) |
| `int8`               | Signed 8-bit integer |
| `int16`              | Signed 16-bit integer |
| `int32`              | Signed 32-bit integer |
| `int64`              | Signed 64-bit integer |
| `int128`             | Signed 128-bit integer |
| `int256`             | Signed 256-bit integer |
| `uint8`              | Unsigned 8-bit integer |
| `uint16`             | Unsigned 16-bit integer |
| `uint32`             | Unsigned 32-bit integer |
| `uint64`             | Unsigned 64-bit integer |
| `uint128`            | Unsigned 128-bit integer |
| `uint256`            | Unsigned 256-bit integer |

## Address

Address types are used to represent Ethereum addresses. They can be either `address` or `address payable`.

| Address Types         | Description |
|------------------------| --- |
| `address`              | Ethereum address |
| `address payable`      | Ethereum address that can send and receive Ether |

## Fixed-size byte arrays

Fixed-size byte arrays are used to represent a sequence of bytes. They can be either `bytes` or `bytes32`.

| Fixed-size byte arrays | Description |
|------------------------| --- |
| `bytes`                | Dynamic sequence of bytes |
| `bytes1` to `bytes32`  | Fixed-size sequence of bytes |
| `string`               | Dynamic sequence of UTF-8 bytes |

> 📘 **Enum underlying values**
>
> Each value in an enum has an underlying value. By default, the first value has an underlying value of `0`,
> and each subsequent value has an underlying value that is one greater than the previous value.

## Structs

Struct types are used to represent a custom data container. They can be defined using the following syntax:

```solidity
struct MyStruct {
    uint256 myUint;
    bool myBool;
}
```


## Arrays

Arrays are used to represent a collection of values. They can be either fixed-size or dynamic.

| Arrays                 | Description |
|------------------------| --- |
| `uint256[]`            | Dynamic array of unsigned 256-bit integers |
| `uint256[5]`           | Fixed-size array of unsigned 256-bit integers with a length of 5 |

Though the list above only shows arrays of integers, you can define arrays of any type.

```solidity
bool[] myBoolArray;
address payable[] myAddressArray;
```

You may also define multi-dimensional arrays.

```solidity
uint256[][] myMultiDimensionalArray;
```

Accessing/assigning arrays is done using the following syntax:

```solidity
myArray[index] = 123;
myOtherArray[indexA][indexB] = 456;
```

## Mappings

Mappings are used to represent a key-value store. They can be defined using the following syntax:

```solidity
// mapping(<key type> => <value type>) <name>;
mapping(address => uint256) myMapping;
```

You can also define multi-dimensional mappings.

```solidity
mapping(address => mapping(address => uint256)) myMultiDimensionalMapping;
```

Accessing/assigning mappings is done in the same way as accessing arrays.

```solidity
myMapping[myAddress] = 123;
myOtherMapping[myAddress][myOtherAddress] = 456;
```

## Enums

Enum types are used to represent a fixed set of values. They can be defined using the following syntax:

```solidity
enum MyEnum {
    Value1,
    Value2,
    Value3
}
```
