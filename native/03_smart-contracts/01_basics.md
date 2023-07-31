---
title: Contract Basics
---

The most used Smart Contract development language for EOS is C++, sometimes referred to as `EOS++`. 
The C++ knowledge required for writing smart contracts is very minimal. If you have ever written C, C++, Java, C#, or
TypeScript, you should be able to pick up `EOS++` easily.

There are also community efforts to support other languages such as Rust, Python, Go, and AssemblyScript.
However, these docs will focus on C++ for writing smart contracts. 
If you are interested in learning about the other community-led initiatives for extending language support, 
check out the [Language Support](/docs/03_smart-contracts/999_language-support.md) page.


## Project Structure

You have a lot of freedom when it comes to structuring your project. You can use one monolithic `.cpp` file for your
entire project, or you can split it up into multiple files. You can even use a build system like CMake to manage your
project.

In most of the guides here we will be using a single `.cpp` file.
This is the simplest way to get started, and it is the most common way to write smart contracts.

### Single File

Below is an example of a single file smart contract. You don't need anything else in your project to compile this,
and you don't need to include any other files.

```cpp title="project/singlefile.cpp"
#include <eosio/eosio.hpp>

CONTRACT singlefile : public eosio::contract {
  public:
    using contract::contract;

    ACTION test() {
      // ...
    }
};
```

### Multiple Files

If you want to split your project up into multiple files, you can do that as well.

```cpp title="project/src/library.hpp"
class library {
    struct data {
      uint64_t id;
      std::string value;
    };
};
```

```cpp title="include/multiplefiles.cpp"
#include <eosio/eosio.hpp>
#include "library.hpp"

CONTRACT multiplefiles : public eosio::contract {
  public:
    using contract::contract;

    ACTION test() {
      // ...
    }
};
```


#### Header vs Source

In C++ you have two types of files: header files (`.hpp/.h`) and source files (`.cpp`).

- Header files are used to declare functions, classes, structs, and other types.
- Source files are used for the implementation of functions declared in header files.

#### Include directories

When you compile your project, you will need to tell the compiler where to find your header files.

Generally, you will want to put your header files in a directory called `include`, and your source files in a directory
called `src`.

```text
project/
  include/
    library.hpp
  src/
    multiplefiles.cpp
```

### When to use a multi-file project

If you are writing a large project, you will probably want to split it up into multiple files.

Keeping your project tidy means splitting it up into logical components. For example, you might have a file for your
database, a file for your business logic, and a file for some helper functions.

This also helps larger teams not stumble over each-other when working with version control systems like `git`.

## Contract Structure

Contracts are object-oriented. You define a contract the same way you would define a `class`.

```cpp title="project/mycontract.cpp"
#include <eosio/eosio.hpp>

CONTRACT mycontract : public eosio::contract {
    public:
    using contract::contract;
};
```

There are a few key components here. 

### CONTRACT definition

The `CONTRACT` keyword is how we tell the compiler that we are writing an EOS++ Smart Contract.

It must be followed by the name of the contract, and the base class which this contract inherits from.

```cpp
CONTRACT mycontract : public eosio::contract {
```

> ❕ **Good to know**
>
> You should typically keep your contract name the same as your `.cpp` file name. Some build systems will enforce this
> for you, and the errors they return are not always clear.

### Access Modifiers

Access modifiers are used to define the visibility of certain elements of your contract.
There are three access modifiers in C++: 
- `public`: The element is visible to everything.
- `private`: The element is only visible to the contract itself.
- `protected`: The element is visible to the contract itself, and any contracts that inherit from it.

When you declare a visibility modifier, everything below it will have that visibility.

```cpp
public:
  // Everything below this is public
private:
  // Everything below this is private
```


> ⚠ **Warning**
> 
> You are not defining the visibility of your contract to the outside world. You are defining the visibility of your
> contract to other elements of your contract. Things like actions and tables will ALWAYS be publicly accessible
> outside your contract.


### Using Contract

A required line for EOS++ Smart Contracts to compile is the `using contract::contract;` line.


### Primary Elements

EOS++ Smart Contracts are made up of two primary elements:

- **Actions**: The entry points to your contract. 
- **Tables**: The way you store data in your contract.

We will explain both of these in more detail in the next sections.
