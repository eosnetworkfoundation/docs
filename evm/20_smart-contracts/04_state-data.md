---
title: State Data
---

There are two types of data in a smart contract: state data and transient data. State data is data that is stored on the
blockchain, and is persistent. Transient data is data that is stored during the execution of a transaction, and is not
persistent. The second the transaction is over, the transient data is gone.

In Solidity, state data is declared at the contract level, and transient data is declared within functions, or modifiers.

```solidity
contract MyContract {
    // State data
    uint256 public myStateData = 1;

    // Transient data
    function myFunction() public {
        uint256 myTransientData = 2;
    }
}
```

You can define any type of data as state data.

## Accessing and modifying state data

You can access and modify state data from within any function in your contract. State data can also be accessed directly
from outside of the blockchain and contract, but it cannot be modified without you explicitly writing a function to do so.

```solidity
contract MyContract {
    uint256 public myStateData = 1;

    function changeState() public {
        myStateData = 2;
    }
    
    function useState() public {
        uint256 myValue = myStateData;
    }
}
```

In the example above, we are modifying the value of `myStateData` from within the `myFunction` function. We have also
declared `myStateData` as `public`, which means that it can be accessed directly from outside the contract.

## Costs

State data is stored on the blockchain, and therefore costs gas to read and write. The cost of reading and writing state
data is one of the highest costs in a smart contract. You should always try to minimize the amount of state data you
store, and the number of times you read and write to it.

If you want to explore the operation costs of EVM code, you should check out [EVM Codes](https://www.evm.codes/?fork=shanghai) which
is a great resource for understanding the gas costs of EVM opcodes.

The codes associated with reading and writing state data are `SLOAD` and `SSTORE` (state). In comparison, the opcodes for transient
data are `MLOAD` and `MSTORE` (memory).

## Best practices

The way that Solidity stores state data is with a concept called `slots`. Each `slot` is 256 bits (32 bytes), and can store
multiple variables. If you have multiple variables that are smaller than 256 bits, they will be stored in the same slot.

For example, if you have two `uint128` variables, they will be stored in the same slot. If you have a `uint128` and a
`uint256`, they will be stored in separate slots.

Because of this, it is a best practice to group variables that together are smaller than 256 bits side by side,
and to keep variables that are larger than 256 bits in their own slot.

```solidity
contract MyContract {
    // slot 1
    uint32 public myStateData1;
    uint32 public myStateData2;
    uint64 public myStateData3;
    uint128 public myStateData4;
    
    // slot 2
    uint256 public myStateData5;
    
    // slot 3
    uint128 public myStateData6;
    uint64 public myStateData7;
    uint32 public myStateData8;
    
    // slot 4
    uint64 public myStateData9;
}
```

Take the code above as an example. Everything in `slot 1` equals to 256 bits, so it will be stored in the same slot.
But, `slot 2` can only hold one variable because the size of that variable is 256 bits.

These rules also apply to structs. A tightly packed struct will be more efficient than a loosely packed struct.

```solidity
// Good
struct MyStruct {
    uint32 a;
    uint32 b;
    uint64 c;
    uint128 d;
    uint256 e;
}

// Bad
struct MyStruct {
    uint32 a;
    uint64 b;
    uint256 c;
    uint32 d;
    uint128 e;
}
```
