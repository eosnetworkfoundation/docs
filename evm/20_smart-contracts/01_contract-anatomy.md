---
title: Anatomy
---

<head>
    <title>Anatomy (EVM)</title>
</head>

The most used Smart Contract development language for EVMs is `Solidity`. It is a statically typed, object-oriented language.
If you know TypeScript, Java, or C#, you will feel right at home with Solidity.


## Project Structure

With Solidity, you generally have one "entry file" which is your main contract, and then extended functionality in other contracts that your main contract inherits from.

You will also likely have a `test` folder if you are working with a development framework like `Hardhat`.

Your project might look like this:
```text
project/
  contracts/
    MyContract.sol
  test/
    MyContract.ts
```





## Contract structure

Below is an example of a simple Solidity contract, this guide will dig into each part of it in detail.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {

}
```

### License identifier

In order to tell the world which license your contract is released under, you can use the `SPDX-License-Identifier` comment.

```solidity
// SPDX-License-Identifier: MIT
```

There are a variety of licenses you can use. If you'd like to explore them more you should check
out [this wiki](https://en.wikipedia.org/wiki/Software_license).



### Pragma

The `pragma` statement tells the compiler which version(s) of the Solidity compiler you want to enforce.

```solidity
pragma solidity ^0.8.0;
```

This will not change the version of the compiler, but it will make it check that its version matches the one you 
specify in your statement. If it does not match, it will throw an error.

#### Brief overview of Semantic Versioning

Semantic Versioning is how most software manages versions in a way that is easy to understand, parse, and compare. It is made up of three numbers:

```text
<MAJOR>.<MINOR>.<PATCH>
0.1.1
```

- **Major**: Changes when there are breaking changes.
- **Minor**: Changes when there are new features added, but no breaking changes.
- **Patch**: Changes when there are bug fixes, but no new features or breaking changes.

#### Loosely locking versions

```solidity
pragma solidity ^0.8.1;
```

The `^` symbol (`caret`) means that you will allow changes to any non-zero version. So, in the case of `^0.8.1`,
you will allow any version from `0.8.1` to `0.9.0`, but not `0.10.0` or `1.0.0`.

If you had `^1.2.3`, it would allow any version from `1.2.3` to `2.0.0`, but not `0.1.0` or `3.0.0`.

#### Locking to a specific range

You can also lock to a range of versions instead, which gives you more control over what versions you will accept.

```solidity
pragma solidity >=0.8.0 <=0.8.10;
```

Another way to do this is by specifying a wildcard for a given number.

```solidity
pragma solidity 0.8.x;
```

This will allow any version from `0.8.0` to `0.8.9`, but not `0.9.0` or `0.7.0`.

You can also use `*` as your wildcard symbol.

> ❔ **More options**
> 
> Solidity compilers support NodeJS semver configurations. 
> You can find more ways to manage them in the [npmjs semver docs](https://docs.npmjs.com/cli/v6/using-npm/semver).







### Importing contracts and libraries

With Solidity you can import other contracts and libraries into your contract. This is useful for keeping your code dry, 
and for using libraries that other people have written.

#### Importing local files

You can use relative imports to import other files in your project.

```solidity
import "../lib/somefile.sol";
```

#### Importing from a node_module

You can also import from a node_module if you are using a package manager like `npm` or `yarn`.

```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
```

#### Importing from a URL

If you don't want to use a package manager, you can also import directly from a URL.

```solidity
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.2/contracts/token/ERC20/ERC20.sol";
```




### Contract definition

The `contract` keyword is used to define a new contract, it is followed by the name of the contract you are defining.

```solidity
contract MyContract {

}
```


### Primary Elements

Solidity Smart Contracts are made up of a few primary elements:

- **State Variables**: Variables that store persistent data in your contract.
- **Functions**: Wrap functionality to be called internally or externally.
- **Events**: Emitted by your contract to inform the outside world of changes.
- **Modifiers**: Used to change the behavior of your functions.

We will explain both of these in more detail in the next sections.
