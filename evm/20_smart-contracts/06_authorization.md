---
title: Authorization
---

Authorization is the process of determining whether a user has permission to perform a transaction.
In blockchain applications this is a key aspect of ensuring the safety of a Smart Contract, and the digital assets that
it controls.

In Solidity you get a special variable called `msg.sender` that represents the address of the user that is calling the function.
This is the address that you will use to determine whether the user is authorized to perform the action.

## Authorization Patterns

There are two common patterns for authorization in Solidity.

### Require

The `require` pattern is the simplest way to implement authorization. It is a single line of code that will throw an error if the condition is not met.

```solidity
function withdraw(uint256 amount) public {
    require(msg.sender == someExpectedAddress, "only the owner can withdraw");
    // withdraw funds
}
```

### Modifier

The modifier pattern is a way to reuse authorization logic across multiple functions. It is a function that is called before the function that it is applied to.

```solidity
contract MyContract {
    address public owner = <some address>;

    modifier onlyOwner() {
        require(msg.sender == owner, "only the owner can call this function");
        _;
    }

    function withdraw(uint256 amount) public onlyOwner {
        // withdraw funds
    }
}
```

## Best practices

OpenZeppelin is a company that provides the building blocks that are used in most Solidity projects. They have an
"Access Control" library that provides a set of contracts that can be used to implement authorization in your project.

It is preferable to use these libraries than rolling your own as they have been tested and audited by the community
in thousands of projects.

You should read OpenZeppelin's [Access Control Docs](https://docs.openzeppelin.com/contracts/4.x/access-control) to
get a better understanding of how to use their contracts.


