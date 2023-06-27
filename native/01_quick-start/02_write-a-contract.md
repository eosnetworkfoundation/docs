---
title: Write a Smart Contract
--- 

In this guide we're going to create a simple smart contract that will allow us to store a string in the blockchain.
We'll be using a **[Web IDE](https://eos-web-ide.netlify.app/)** to write, and deploy our smart contract to the EOS Testnet.

## What is a Smart Contract?

You can think of a Smart Contract like a function that runs on the blockchain. It must be **deterministic**, meaning 
that it will always produce the same output given the same input. This is required so that all nodes on the network
can agree on the output of the function.

## What is a Web IDE?

A Web IDE is an Integrated Development Environment that runs in your browser. It allows you to write, compile, and
deploy your smart contract to the blockchain, without ever leaving your browser or installing any software.

## Enough talk, let's begin!

Open up the [EOS Web IDE](https://eos-web-ide.netlify.app/) in your browser. You will be presented with a
dummy contract which shows you the basic structure of a smart contract.

Go ahead and clear everything out of the editor, and copy and paste the following code:

```cpp
#include <eosio/eosio.hpp>
using namespace eosio;

CONTRACT mycontract : public contract {
  public:
    using contract::contract;

    TABLE StoredData {
      uint64_t id;
      std::string text;
      
      uint64_t primary_key() const { return id; }
    };
    
    using storage_table = eosio::multi_index<"mytable"_n, StoredData>;

    ACTION save( uint64_t id, std::string text ) {
      storage_table _storage( get_self(), get_self().value );
      _storage.emplace( get_self(), [&]( auto& row ) {
        row.id = id;
        row.text = text;
      });
    }
};
```

Take a look at the code and see if you can figure out what it's doing. 

If you're having trouble understanding the code, don't worry, you can head over to the [Smart Contract Basics](/docs/03_smart-contracts/01_-contract-anatomy.md)
section to learn more about the various parts of a smart contract and how they work.

Your screen should look like this now:

![EOS Web IDE](/images/native-web-ide-basics.png)
