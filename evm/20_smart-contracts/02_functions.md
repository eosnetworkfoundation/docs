---
title: Functions
---

<head>
    <title>Functions (EVM)</title>
</head>

Functions are a way to encapsulate logic in a program, but they also serve as entry-points for your Smart Contracts.

## Function Declaration

Function declarations in Solidity have a few basic requirements:
- Must start with the `function` keyword
- Must have a name
- Must have a parameter list (even if it's empty)
- Must declare a `visibility`
- Can have a body
- Can have a return type
- Can have modifiers
- Can be declared as `payable`
- Should have a mutability modifier (if applicable)

Let's look at a simple function declaration, and then we'll break it down and get into some more advanced topics.

```solidity
// function <name>(<parameters>) <visibility> <modifiers?> <returns?> { <body> }

function myFunction(bool _myParam) public {
    // Function body
}
```

## Function Parameters

Function parameters are declared as a list of comma-separated types and names, enclosed in parentheses.

```solidity
function myFunction(bool _myParam, uint256 _myOtherParam) public {}
```


> 📘 **Parameter naming convention**
>
> In Solidity, it is common to prefix function parameters with an underscore (`_`). This is not required, but it is a convention that is widely used.
> The intention is to differentiate between the parameter and a global variable with the same name.


## Function Visibility

Functions in Solidity can have one of four visibilities.

### Public

Public functions are the catch-all for visibilities. They can be called from within your contract, from inherited contracts,
from other contracts on the blockchain, and from outside the blockchain by users. 

```solidity
function myFunction() public {}
```

### External

External functions can only be called from outside the contract; either by other contracts or by a user outside the blockchain.

```solidity
function myFunction() external {}
```

> 💰 **External is cheaper than Public**
> 
> If you are writing a function that will only be called from outside the contract, you should use `external` instead of `public`.
> This is because `external` functions are cheaper to call than `public` functions, as they do not have to copy the parameters to 
> memory. 

### Internal

Internal functions can only be called from within the contract, or from inherited contracts.

```solidity
function myFunction() internal {}
```

### Private

Private functions can only be called from within the contract.

```solidity
function myFunction() private {}
```

## Function Return Types

Functions can return a single value, or multiple values. The return types are declared after the parameter list, and are separated by a comma.

You can also name the return values, which will create a variable in the function body that you can assign a value to.

```solidity
function myFunction() public returns (uint256) {
    return 1;
}

function myOtherFunction() public returns (uint256 myValue) {
    myValue = 1;
}
```


## Function modifiers

Modifiers are a way to add functionality to a function which will either run before, or after a function. 
They are usually used to add additional checks to a function, or to modify the return value of a function.

Modifiers are declared with the `modifier` keyword, and can be applied to a function by using the `modifier` keyword after the function declaration.

Every modifier must start or end with the `_;` statement. This is where the function body will be executed.

```solidity
// declaration
modifier myModifier() {
    // Modifier body
    _;
}

// usage
function myFunction() public myModifier {}
```

You can also chain multiple modifiers together, by separating them with a space.

```solidity
function myFunction() public myModifier1 myModifier2 {}
```

## Payable functions

Functions can accept the native currency of the blockchain as payment. This is done by declaring the function as `payable`.

In the case of the EOS EVM, this is EOS.

```solidity
function myFunction() public payable {
    uint256 amount = msg.value;
}
```

> 📘 **msg.value**
> 
> `msg.value` is a global variable that is available in every function. It contains the amount of native currency that was sent to the function.

## Function mutability

There are three types of mutability that a function can have, and they mean different things. 

### Default 

If a function does not have a mutability modifier, it is considered a "writable" function. 
This means that the function can modify the state of the contract, and when called from outside the contract, it will cost the user gas.

```solidity
function myFunction() external {}
```

### View

If a function is declared as `view`, it means that the function will not modify the state of the contract, but it will
read state variables from the contract. A user interacting with this function will not be charged gas.

```solidity
function myFunction() external view returns (uint256) {
    return myStateVariable;
}
```

### Pure

If a function is declared as `pure`, it means that the function will not modify the state of the contract, and it will not
read state variables from the contract. A user interacting with this function will not be charged gas.

```solidity
function myFunction(uint256 a, uint256 b) external pure returns (uint256) {
    return a + b;
}
```

> 📘 **Why is Pure useful?**
> 
> Pure functions are generally used to provide utility functions outwards. For instance, if you wanted to provide a function
> that would calculate a number based on logic that the contract uses internally in order to replicate the logic in a web
> application, you could use a `pure` function to do this. 

## Constructors

Constructors are special functions that are called when a contract is deployed. They are declared with the `constructor` keyword,
and are only run once.

```solidity
constructor() public {
    // Constructor body
}
```
