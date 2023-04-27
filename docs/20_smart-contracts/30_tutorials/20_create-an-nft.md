---
title: Create an NFT
---

## Want to just create an NFT easily?

In this tutorial we are going to discuss creating an NFT that follows Ethereum's ERC721
standard so that we can dig into some technicals. 

**However**, if you want to create an NFT that follows the Atomic Assets standard which
is more common on the EOS Network, you can visit the [Atomic Assets NFT Creator](https://eos.atomichub.io/creator)
where you can easily create an NFT that will instantly be listed on the AtomicHub marketplace.

## What is an NFT?

An NFT is a **non-fungible token**. This means that it is a unique token that cannot be
interchanged with another token. 

Let's take a trading card as an example. If you have a trading card of a blue car, 
you can't trade it for a trading card of a red car. They are different cards and 
therefore are not _fungible_.

## What is an NFT Standard?

An NFT standard is a set of rules that all NFTs must follow. This allows for NFTs to be
interoperable with other NFTs and for applications like marketplaces and wallets to
understand how to interact with them.

## What is the ERC721 Standard?

The ERC721 standard is an NFT standard that was created by the Ethereum community. It
is the most common NFT standard and is used by many NFTs on the Ethereum network. If you've
ever seen a Cryptopunk or a Bored Ape, they are ERC721 NFTs.

## Your development environment

Make sure you have [DUNE](/docs/20_smart-contracts/10_getting-started/10_dune-guide/index.md) installed
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
there are a few actions that we need to implement. Some actions do not apply to EOS
smart contracts as the technologies differ, but we will be implementing their logic in a different
way.

The actions we will be implementing are:

```c++
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


## Adding the data structures

Now that we have our actions, we need to add some data structures to store the NFTs.

We will be using a `singleton` to store the NFTs. A `singleton` is a data structure that
stores a single value. In this case, we will be storing a `std::map` that will store the
NFTs.

Add the following code to your contract above the actions:

```cpp
    // Mapping from token ID to owner
    using _owners = singleton<"owners"_n, name>;
    
    // Mapping owner address to token count
    using _balances = singleton<"balances"_n, uint64_t>;
    
    // Mapping from token ID to approved address
    using _approvals = singleton<"approvals"_n, name>;
    
    // Mapping from owner to approvals
    using _approvealls = singleton<"approvealls"_n, name>;
    
    // Registering the token URI
    using _base_uris = singleton<"baseuris"_n, std::string>;
    
    ACTION mint...
```

Now that we've created the tables and structures that will store data about the NFTs,
we can start filling in the logic for each action.


## Adding some helper functions

We will add helper functions to make our code more readable and easier to
use. Add the following code to your contract right below the table definitions:

```cpp
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
```

## Filling in the actions

We will go through each action and implement the logic for it. Pay close attention to
the comments as they will explain what each line of code does.

### Mint

The `mint` action is used to create a new NFT.

```c++
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

Let's briefly go over what the action does. First, we check that the action is called
by the contract owner. Then, we check that the account we are minting to exists. Next,
we get the owner singleton and check if the NFT already exists. If it doesn't, we set
the owner of the NFT to the account that called the action and get the balances
table so that we can set the new balances of the account.

### Transfer

The `transfer` action is used to transfer an NFT from one account to another.

```c++
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

First, we check that the account we are
transferring from has authorized the transfer. Then, we check that the account we are
transferring to exists. Next, we check that the account we are transferring from is
the owner of the NFT or allowed to transfer it through an approval. If it is, we get
the owner singleton and set the owner of the NFT to the "to" account. Then, we set the
new balance for the "from" account and the "to" account. Next, we remove the approval
for the "from" account and send the transfer notification.

### BalanceOf

The `balanceof` action is used to get the balance of an account.

```c++
    [[eosio::action]] uint64_t balanceof(name owner){
        return get_balance(owner);
    }
```

We simply return the balance of the account.

### OwnerOf

The `ownerof` action is used to get the owner of an NFT.

```c++
    [[eosio::action]] name ownerof(uint64_t token_id){
        return get_owner(token_id);
    }
```

We simply return the owner of the NFT.

### Approve

The `approve` action is used to approve an account to transfer an NFT on your behalf.

```c++
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

First, we get the owner of the NFT. Then, we check that the owner of the NFT has
authorized the approval. Next, we check that the account we are approving exists. Then,
we get the approvals table and set the approval for the NFT.

### ApproveAll

The `approveall` action is used to approve an account to transfer all of your
NFTs on your behalf.

```c++
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

First, we check that the owner of the NFTs has authorized the approval. Then, we check
that the account we are approving exists. Next, we get the approvals table and set the
approval for the NFT if the `approved` parameter is `true`. Otherwise, we remove the
approval for the NFT.

### GetApproved

The `getapproved` action is used to get the account that is approved to transfer an
NFT on your behalf.

```c++
    [[eosio::action]] name getapproved(uint64_t token_id){
        return get_approved(token_id);
    }
```

### Approved4All

The `approved4all` action is used to check if an account is approved to transfer
all of your NFTs on your behalf.

```c++
    [[eosio::action]] bool approved4all(name owner, name approved_account){
      return get_approved_all(owner) == approved_account;
   }
```

### TokenURI

The `tokenuri` action is used to get the URI of an NFT.

```c++
    [[eosio::action]] std::string tokenuri(uint64_t token_id){
        return get_token_uri(token_id);
    }
```

### SetBaseURI

The `setbaseuri` action is used to set the base URI of the NFTs.

```c++
    ACTION setbaseuri(std::string base_uri){
        // The account calling this action must be the contract owner
        require_auth(get_self());
        
        // Get the base URI table
        _base_uris base_uris(get_self(), get_self().value);
        
        // Set the base URI
        base_uris.set(base_uri, get_self());
    }
```

First, we check that the account calling this action is the contract owner. Then, we
get the base URI table and set the base URI.



## Putting it all together

Now that we have all of the actions, we can put them all together in the `nft.hpp` file.

<details>
    <summary>Click here to see full contract</summary>

```c++
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

## Challenge

This NFT contract has no way to burn NFTs. Add a `burn` action that allows the token owner to burn their own NFTs.









