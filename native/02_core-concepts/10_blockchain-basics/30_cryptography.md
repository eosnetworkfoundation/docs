---
title: Cryptography
---

Cryptography is the practice of using mathematical algorithms to secure information and communications. 
It is a fundamental part of modern technology and plays an integral role in blockchain technology.

## How is cryptography used in a blockchain?

All interactions with a blockchain are secured using cryptography. This prevents the interactions from being tampered with or altered.
Blocks that make up the blockchain are also signed by the nodes that produce them, which allows other nodes to verify
that they came from a valid source.

## What are hashes?

Hashes are unique digital fingerprints generated from input data using complex mathematical algorithms. 
Hashes are one-way functions, which means that it's practically impossible to reverse-engineer the input data from the hash output.

## What are keys?

There are two types of keys used in blockchain technology: public keys and private keys.

The two keys are directly linked to each other, but you can only derive the public key from the private key, not the other way around.
This means that you can share your public key with others safely, but should **never** share your private key with anyone.

### Public Keys

Public keys are like your digital address. They are used to identify you on a blockchain, and can be shared with others safely.

### Private Keys

Private keys are like your digital pen. They can sign information to prove that it came from you, and the signature can be 
traced back to your public key. Private keys should be kept secret at all times, as anyone who has access to your private key
can sign transactions on your behalf, effectively stealing your identity (and everything you own on the blockchain).


## What are signatures?

Signatures are the backbone of blockchain security. They are used to prove that a transaction came from a specific account,
and that the transaction has not been tampered with. If someone tried to alter the data of a transaction, the signature would
become invalid and the transaction would be rejected by the network.

## What is encryption?

Encryption is the process of encoding information so that only authorized parties can access it. It is used to protect sensitive
data which is stored on private networks. You use encryption every day without noticing it every time you visit a website. 
Even this website uses encryption to protect your connection so that no one can intercept the data as it comes from the server to 
your browser and vice versa.

> ⚠ **Warning:**
> 
> Never store encrypted data on a blockchain if it contains sensitive information. Blockchains are public by nature, and anyone
> can view the contents of a transaction. This means that any encrypted data stored on a blockchain can be viewed by anyone.
> Encryption algorithms become obsolete over time as computers become more powerful, so it is innevitable that the data will
> eventually be decrypted and exposed to the public.
