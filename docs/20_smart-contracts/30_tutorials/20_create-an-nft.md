---
title: Create an NFT
---

An NFT is a **non-fungible token**. This means that it is a unique token that cannot be
interchanged with another token. 

Take a collectible item as an example (a pen owned by a celebrity, a game-winning ball, etc). Each of these
items is unique and cannot be interchanged with another item because their value is
in their uniqueness.

> 👀 **Want to just create an NFT?**
> 
> In this tutorial we are going to discuss creating an NFT that follows Ethereum's ERC721
> standard so that we can dig into some EOS development using a clear standard.
> 
> **However**, if you want to create an NFT that follows the [**Atomic Assets**](https://github.com/pinknetworkx/atomicassets-contract) standard which
> is more common on the EOS Network, you can visit the [Atomic Assets NFT Creator](https://eos.atomichub.io/creator)
> where you can easily create an NFT that will instantly be listed on the AtomicHub marketplace without deploying any code.

## What is an NFT Standard?

An NFT standard is a set of rules that all NFTs must follow. This allows for NFTs to be
interoperable with other NFTs and for applications like marketplaces and wallets to
understand how to interact with them.

## What is the ERC721 Standard?

The [ERC721 standard](https://eips.ethereum.org/EIPS/eip-721) is an NFT standard that was created by the Ethereum community. It
is the most common NFT standard and is used by many NFTs on the Ethereum network. If you've
ever seen a Bored Ape, they are ERC721 NFTs.

![Bored Ape Club Examples](./images/boredapeclub.jpg)

## Your development environment

Make sure you have [DUNE](../../20_smart-contracts/10_getting-started/10_dune-guide.md) installed
and understand how to build contracts.

After each step, you should try to compile your contract and check if there are any errors.

## Create a new contract

Create a new `nft.cpp` file and add the following code:

```cpp
#include <eosio/eosio.hpp>
#include <eosio/asset.hpp>
#include <eosio/singleton.hpp>
using namespace eosio;

CONTRACT nft : public contract {

    public:
    using contract::contract;
    
    // TODO: Add actions
};
```

## Creating the actions

If we look at the [ERC721 standard](https://eips.ethereum.org/EIPS/eip-721), we can see that
there are a few actions that we need to implement. Overall the standard is quite simple, but
some concepts are not necessarily EOS-native. For instance, there is no concept 
of `approvals` on EOS since you can send tokens directly to another account (via `on_notify` events), unlike Ethereum.

For the sake of keeping the standard as close to the original as possible, we will implement
those non-native concepts in this tutorial.

The actions we will be implementing are:

```cpp
    ACTION mint(name to, uint64_t token_id){
    
    }
    
    ACTION transfer(name from, name to, uint64_t token_id, std::string memo){
    
    }
    
    [[eosio::action]] uint64_t balanceof(name owner){
    
    }
    
    [[eosio::action]] name ownerof(uint64_t token_id){
    
    }
    
    ACTION approve(name to, uint64_t token_id){
    
    }
    
    ACTION approveall(name from, name to, bool approved){
    
    }
    
    [[eosio::action]] name getapproved(uint64_t token_id){
    
    }
    
    [[eosio::action]] bool approved4all(name owner, name approved_account){
    
    }
    
    [[eosio::action]] std::string gettokenuri(uint64_t token_id){
    
    }
    
    ACTION setbaseuri(std::string base_uri){
    
    }
```

Add them to your contract and then let's dig into each action and see what they do, and what parameters they take.

You'll notice that actions with return values are marked with `[[eosio::action]]` instead
of `ACTION`. 

> ❔ **ACTION Macro**
> 
> `ACTION` is something called a `MACRO`, which is a way to write code that will be replaced
> with other code at compile time. In this case, the `ACTION` macro is replaced with:
> ```cpp
> [[eosio::action]] void
> ```
> The reason we cannot use the `ACTION` macro for actions that return values is because
> it adds the `void` keyword to the function, which means it will not return anything.

## Digging into the action parameters

If you want a deeper explanation of the parameters and a brief explanation of
each action, expand the section below.

<details>
    <summary>Click here to view</summary>

### Mint

The `mint` action is used to create a new NFT.

It takes two parameters:
- **to** - The account that will own the NFT
- **token_id** - The ID of the NFT

### Transfer

The `transfer` action is used to transfer an NFT from one account to another.

It takes four parameters:
- **from** - The account that currently owns the NFT
- **to** - The account that will own the NFT
- **token_id** - The ID of the NFT
- **memo** - A memo that will be included in the transaction

### BalanceOf

The `balanceof` action is used to get the balance of an account.

It takes one parameter:
- **owner** - The account that you want to get the balance of

It returns a `uint64_t` which is the balance of the account.

### OwnerOf

The `ownerof` action is used to get the owner of an NFT.

It takes one parameter:
- **token_id** - The ID of the NFT

It returns a `name` which is the account that owns the NFT.

### Approve

The `approve` action is used to approve an account to transfer an NFT on your behalf.

It takes two parameters:
- **to** - The account that will be approved to transfer the NFT
- **token_id** - The ID of the NFT

### ApproveAll

The `approveall` action is used to approve an account to transfer all of your NFTs on your behalf.

It takes three parameters:
- **from** - The account that currently owns the NFTs
- **to** - The account that will be approved to transfer the NFTs
- **approved** - A boolean that determines if the account is approved or not

### GetApproved

The `getapproved` action is used to get the account that is approved to transfer an NFT on your behalf.

It takes one parameter:
- **token_id** - The ID of the NFT

It returns a `name` which is the account that is approved to transfer the NFT.

### IsApprovedForAll

The `approved4all` action is used to get if an account is approved to transfer all of your NFTs on your behalf.

It takes two parameters:
- **owner** - The account that currently owns the NFTs
- **approved_account** - The account that you want to check if it is approved to transfer the NFTs

It returns a `bool` which is `true` if the account is approved to transfer the NFTs, and `false` if it is not.

### TokenURI

The `gettokenuri` action is used to get the URI of the NFT's metadata.

It takes one parameter:
- **token_id** - The ID of the NFT

It returns a `std::string` which is the URI of the NFT's metadata.

### SetBaseURI

The `setbaseuri` action is used to set the base URI of the NFT's metadata.

It takes one parameter:
- **base_uri** - The base URI of the NFT's metadata
    
</details>


## Adding the data structures

Now that we have our actions, we need to add some data structures to store the NFTs.

We will be using a `singleton` to store the NFTs. 

> ❔ **Singleton**
> 
> A `singleton` is a table that can only have one row per scope, unlike a `multi_index` which 
> can have multiple rows per scope and uses a `primary_key` to identify each row.
> Singletons are a little closer to Ethereum's storage model. 

Add the following code to your contract above the actions:

```cpp
    using _owners = singleton<"owners"_n, name>;
    using _balances = singleton<"balances"_n, uint64_t>;
    using _approvals = singleton<"approvals"_n, name>;
    using _approvealls = singleton<"approvealls"_n, name>;
    using _base_uris = singleton<"baseuris"_n, std::string>;
    
    ACTION mint...
```

We've created singleton tables for the following:
- **_owners** - A mapping from token ID to the owner of the NFT
- **_balances** - A mapping from owner to the amount of NFTs they own
- **_approvals** - A mapping from token ID to an account approved to transfer that NFT
- **_approvealls** - A mapping from owner to an account approved to transfer all their NFTs
- **_base_uris** - A configuration table that stores the base URI of the NFT's metadata

> ❔ **Table Naming**
> 
> `singleton<"<TABLE NAME>"_n, <ROW TYPE>>`
> 
> If we look at the singleton definition, inside the double quotes we have the table name.
> Names in EOS tables must also follow the Account Name rules, which means they must be
> 12 characters or less and can only contain the characters `a-z`, `1-5`, and `.`.

Now that we've created the tables and structures that will store data about the NFTs,
we can start filling in the logic for each action.


## Adding some helper functions

We want some helper functions to make our code more readable and easier to
use. Add the following code to your contract right below the table definitions:

```cpp
    using _base_uris = singleton<"baseuris"_n, std::string>;
    
    // Helper function to get the owner of an NFT
    name get_owner(uint64_t token_id){
        
        // Note that we are using the "token_id" as the "scope" of this table.
        // This lets us use singleton tables like key-value stores, which is similar
        // to how Ethereum contracts store data.
        
        _owners owners(get_self(), token_id);
        return owners.get_or_default(name(""));
    }
    
    // Helper function to get the balance of an account
    uint64_t get_balance(name owner){
        _balances balances(get_self(), owner.value);
        return balances.get_or_default(0);
    }
    
    // Helper function to get the account that is approved to transfer an NFT on your behalf
    name get_approved(uint64_t token_id){
        _approvals approvals(get_self(), token_id);
        return approvals.get_or_default(name(""));
    }
    
    // Helper function to get the account that is approved to transfer all of your NFTs on your behalf
    name get_approved_all(name owner){
      _approvealls approvals(get_self(), owner.value);
      return approvals.get_or_default(name(""));
   }
    
    // Helper function to get the URI of the NFT's metadata
    std::string get_token_uri(uint64_t token_id){
        _base_uris base_uris(get_self(), get_self().value);
        return base_uris.get_or_default("") + "/" + std::to_string(token_id);
    }
```

The helper functions will make it easier to get data from the tables we created earlier.
We will use these functions in the actions we will implement next.

In particular, some functions are used in multiple places so it makes sense to
create a helper function for them. For example, the `get_owner` function is used
in the `mint`, `transfer`, and `approve` actions. If we didn't create a helper function
for it, we would have to write the same code in each action.

## Filling in the actions

We will go through each action and implement the logic for it. Pay close attention to
the comments as they will explain what each line of code does.

### Mint

The `mint` action is used to create a new NFT.

```cpp
    ACTION mint(name to, uint64_t token_id){
        // We only want to mint NFTs if the action is called by the contract owner
        check(has_auth(get_self()), "only contract can mint");
        
        // The account we are minting to must exist
        check(is_account(to), "to account does not exist");
        
        // Get the owner singleton
        _owners owners(get_self(), token_id);
        
        // Check if the NFT already exists
        check(owners.get_or_default().value == 0, "NFT already exists");
        
        // Set the owner of the NFT to the account that called the action
        owners.set(to, get_self());
        
        // Get the balances table
        _balances balances(get_self(), to.value);
        
        // Set the new balances of the account
        balances.set(balances.get_or_default(0) + 1, get_self());
    }    
```


### Transfer

The `transfer` action is used to transfer an NFT from one account to another.

```cpp
    ACTION transfer(name from, name to, uint64_t token_id, std::string memo){
        // The account we are transferring from must authorize this action
        check(has_auth(from), "from account has not authorized the transfer");
        
        // The account we are transferring to must exist
        check(is_account(to), "to account does not exist");
        
        // The account we are transferring from must be the owner of the NFT
        // or allowed to transfer it through an approval
        bool ownerIsFrom = get_owner(token_id) == from;
        bool fromIsApproved = get_approved(token_id) == from;
        check(ownerIsFrom || fromIsApproved, "from account is not the owner of the NFT or approved to transfer the NFT");       
        
        // Get the owner singleton
        _owners owners(get_self(), token_id);
        
        // Set the owner of the NFT to the "to" account
        owners.set(to, get_self());
        
        // Set the new balance for the "from" account
        _balances balances(get_self(), from.value);
        balances.set(balances.get_or_default(0) - 1, get_self());
        
        // Set the new balance for the "to" account
        _balances balances2(get_self(), to.value);
        balances2.set(balances2.get_or_default(0) + 1, get_self());
        
        // Remove the approval for the "from" account
        _approvals approvals(get_self(), token_id);
        approvals.remove();
        
        // Send the transfer notification
        require_recipient(from);
        require_recipient(to);
    }
```

### BalanceOf

The `balanceof` action is used to get the balance of an account.

```cpp
    [[eosio::action]] uint64_t balanceof(name owner){
        return get_balance(owner);
    }
```

> ⚠ **Return values & Composability**
> 
> Return values are only usable from outside the blockchain, and cannot currently be used
> in EOS for smart contract composability. EOS supports [**inline actions**](../10_getting-started/40_smart_contract_basics.md#inline-actions) which can be used
> to call other smart contracts, but they cannot return values.

### OwnerOf

The `ownerof` action is used to get the owner of an NFT.

```cpp
    [[eosio::action]] name ownerof(uint64_t token_id){
        return get_owner(token_id);
    }
```

### Approve

The `approve` action is used to approve an account to transfer an NFT on your behalf.

```cpp
    ACTION approve(name to, uint64_t token_id){
        // get the token owner
        name owner = get_owner(token_id);
        
        // The owner of the NFT must authorize this action
        check(has_auth(owner), "owner has not authorized the approval");
    
        // The account we are approving must exist
        check(is_account(to), "to account does not exist");
        
        // Get the approvals table
        _approvals approvals(get_self(), token_id);
        
        // Set the approval for the NFT
        approvals.set(to, get_self());
    }
```

### ApproveAll

The `approveall` action is used to approve an account to transfer all of your
NFTs on your behalf.

```cpp
    ACTION approveall(name from, name to, bool approved){
        // The owner of the NFTs must authorize this action
        check(has_auth(from), "owner has not authorized the approval");
        
        // The account we are approving must exist
        check(is_account(to), "to account does not exist");
        
        // Get the approvals table
        _approvealls approvals(get_self(), from.value);
        
        if(approved){
            // Set the approval for the NFT
            approvals.set(to, get_self());
        } else {
            // Remove the approval for the NFT
            approvals.remove();
        }
    }
```

### GetApproved

The `getapproved` action is used to get the account that is approved to transfer an
NFT on your behalf.

```cpp
    [[eosio::action]] name getapproved(uint64_t token_id){
        return get_approved(token_id);
    }
```

### Approved4All

The `approved4all` action is used to check if an account is approved to transfer
all of your NFTs on your behalf.

```cpp
    [[eosio::action]] bool approved4all(name owner, name approved_account){
      return get_approved_all(owner) == approved_account;
   }
```

> ⚠ **ACTION name limitations**
> 
> Account names also have the same limitations as table names, so they can only contain
> the characters `a-z`, `1-5`, and `.`. Because of this, we cannot use the standard `isApprovedForAll`
> name for the action, so we are using `approved4all` instead.

### TokenURI

The `tokenuri` action is used to get the URI of an NFT.

```cpp
    [[eosio::action]] std::string tokenuri(uint64_t token_id){
        return get_token_uri(token_id);
    }
```

### SetBaseURI

The `setbaseuri` action is used to set the base URI of the NFTs.

```cpp
    ACTION setbaseuri(std::string base_uri){
        // The account calling this action must be the contract owner
        require_auth(get_self());
        
        // Get the base URI table
        _base_uris base_uris(get_self(), get_self().value);
        
        // Set the base URI
        base_uris.set(base_uri, get_self());
    }
```



## Putting it all together

Now that we have all the actions laid out, we can put them all together in the `nft.cpp` file.

You should try to build, deploy, and interact with the contract on your own before looking at the full contract below.
First you'll need to mint some NFTs to an account you control, then you can try transferring them to another account.

You can also test out the approval mechanisms by approving another account to transfer your NFTs on your behalf, 
and then transferring them to another account using the approved account.

<details>
    <summary>Click here to see full contract</summary>

```cpp
#include <eosio/eosio.hpp>
#include <eosio/asset.hpp>
#include <eosio/singleton.hpp>
using namespace eosio;

CONTRACT nft : public contract {

   public:
   using contract::contract;

   // Mapping from token ID to owner
   using _owners = singleton<"owners"_n, name>;
   
   // Mapping owner address to token count
   using _balances = singleton<"balances"_n, uint64_t>;
   
   // Mapping from token ID to approved address
   using _approvals = singleton<"approvals"_n, name>;
   
   // Mapping from owner to operator approvals
   using _approvealls = singleton<"approvealls"_n, name>;
   
   // Registering the token URI
   using _base_uris = singleton<"baseuris"_n, std::string>;

   // Helper function to get the owner of an NFT
   name get_owner(uint64_t token_id){
      _owners owners(get_self(), token_id);
      return owners.get_or_default(name(""));
   }
   
   // Helper function to get the balance of an account
   uint64_t get_balance(name owner){
      _balances balances(get_self(), owner.value);
      return balances.get_or_default(0);
   }
   
   // Helper function to get the account that is approved to transfer an NFT on your behalf
   name get_approved(uint64_t token_id){
      _approvals approvals(get_self(), token_id);
      return approvals.get_or_default(name(""));
   }
   
   // Helper function to get the account that is approved to transfer all of your NFTs on your behalf
   name get_approved_all(name owner){
      _approvealls approvals(get_self(), owner.value);
      return approvals.get_or_default(name(""));
   }
   
   // Helper function to get the URI of the NFT's metadata
   std::string get_token_uri(uint64_t token_id){
      _base_uris base_uris(get_self(), get_self().value);
      return base_uris.get_or_default("") + "/" + std::to_string(token_id);
   }
   
   ACTION mint(name to, uint64_t token_id){
      // We only want to mint NFTs if the action is called by the contract owner
      check(has_auth(get_self()), "only contract can mint");

      // The account we are minting to must exist
      check(is_account(to), "to account does not exist");

      // Get the owner singleton
      _owners owners(get_self(), token_id);

      // Check if the NFT already exists
      check(owners.get_or_default().value == 0, "NFT already exists");

      // Set the owner of the NFT to the account that called the action
      owners.set(to, get_self());

      // Get the balances table
      _balances balances(get_self(), to.value);

      // Set the new balances of the account
      balances.set(balances.get_or_default(0) + 1, get_self());
   }
   
   ACTION transfer(name from, name to, uint64_t token_id, std::string memo){
      // The account we are transferring from must authorize this action
      check(has_auth(from), "from account has not authorized the transfer");

      // The account we are transferring to must exist
      check(is_account(to), "to account does not exist");

      // The account we are transferring from must be the owner of the NFT
      // or allowed to transfer it through an approval
      bool ownerIsFrom = get_owner(token_id) == from;
      bool fromIsApproved = get_approved(token_id) == from;
      check(ownerIsFrom || fromIsApproved, "from account is not the owner of the NFT or approved to transfer the NFT");       

      // Get the owner singleton
      _owners owners(get_self(), token_id);

      // Set the owner of the NFT to the "to" account
      owners.set(to, get_self());

      // Set the new balance for the "from" account
      _balances balances(get_self(), from.value);
      balances.set(balances.get_or_default(0) - 1, get_self());

      // Set the new balance for the "to" account
      _balances balances2(get_self(), to.value);
      balances2.set(balances2.get_or_default(0) + 1, get_self());

      // Remove the approval for the "from" account
      _approvals approvals(get_self(), token_id);
      approvals.remove();

      // Send the transfer notification
      require_recipient(from);
      require_recipient(to);
   }
   
   [[eosio::action]] uint64_t balanceof(name owner){
      return get_balance(owner);
   }
   
   [[eosio::action]] name ownerof(uint64_t token_id){
      return get_owner(token_id);
   }
   
   ACTION approve(name to, uint64_t token_id){
      // get the token owner
      name owner = get_owner(token_id);
      
      // The owner of the NFT must authorize this action
      check(has_auth(owner), "owner has not authorized the approval");
   
      // The account we are approving must exist
      check(is_account(to), "to account does not exist");
      
      // Get the approvals table
      _approvals approvals(get_self(), token_id);
      
      // Set the approval for the NFT
      approvals.set(to, get_self());
   }
   
   ACTION approveall(name from, name to, bool approved){
      // The owner of the NFTs must authorize this action
      check(has_auth(from), "owner has not authorized the approval");
      
      // The account we are approving must exist
      check(is_account(to), "to account does not exist");
      
      // Get the approvals table
      _approvealls approvals(get_self(), from.value);
      
      if(approved){
         // Set the approval for the NFT
         approvals.set(to, get_self());
      } else {
         // Remove the approval for the NFT
         approvals.remove();
      }
   }
   
   [[eosio::action]] name getapproved(uint64_t token_id){
      return get_approved(token_id);
   }
   
   [[eosio::action]] bool approved4all(name owner, name approved_account){
      return get_approved_all(owner) == approved_account;
   }
   
   [[eosio::action]] std::string gettokenuri(uint64_t token_id){
      return get_token_uri(token_id);
   }
   
   ACTION setbaseuri(std::string base_uri){
      // The account calling this action must be the contract owner
      require_auth(get_self());
      
      // Get the base URI table
      _base_uris base_uris(get_self(), get_self().value);
      
      // Set the base URI
      base_uris.set(base_uri, get_self());
   }
};
```
</details>

## This is for education purposes

Keep in mind, that if you deployed this contract on the EOS Network and minted tokens, there
would be no supported marketplaces to sell them (at the time of writing this guide). This is just for education purposes.

## Challenge

This NFT contract has no way to burn NFTs. Add a `burn` action that allows the token owner to burn their own NFTs.
