---
title: EVM Compatibility
---

EOS EVM is fully compatible with the Ethereum EVM specification, including all precompiles and opcodes. However, there are some key EOS EVM differences:

## Nested Call Limit

Due to a limitation in the EOS EVM Contract, EOS EVM currently supports a maximum of five (5) nested calls. The EOS EVM team will keep optimizing designs to increase this number.

## Reserved Addresses

EVM addresses that begin with twelve `0xbb` bytes, e.g. `0xbbbbbbbbbbbbbbbbbbbbbbbb5530ea015b900000`, are reserved for bridging EOS between native EOS and EOS within EVM. Sending messages to these addresses with a value may initiate a bridge transaction or abort the transaction depending on various bridge rules.

Also, while unlikely, any contract creation which results in a reserved address will also abort the transaction.

## Precompiles

EOS EVM supports all precompiles supported by Ethereum, with the following provisions:

### `modexp (0x05)`

The `exponent` bit size cannot exceed either the `base` bit size or the `modulus` bit size.

> ℹ️ Unmet limits  
If the above limits are not met, the precompile will throw an exception and the transaction will be halted.

## Opcodes

### `BLOCKHASH (0x40)`

This opcode currently does not return the hash of the specified block contents, but the hash of the specified block height and the chain ID instead:

`block_hash = sha256( msg(block_height, chain_id) )`

where:
* `block_height`: specified 64-bit block height
* `chain_id`: used as a 64-bit salt value
* `msg`: concatenation of a leading zero byte (0x00) constant, the `block_height`, and the `chain_id`, in big endian format.

> ℹ️ Version byte  
The leading zero byte in the hash is a version byte which may change if a new blockhash scheme is introduced in the future.

### `COINBASE (0x41)`

This opcode returns the address of the EOS EVM contract account, `eosio.evm`. The current address is `0xbbbbbbbbbbbbbbbbbbbbbbbb5530ea015b900000`.

### `DIFFICULTY (0x44)`

This opcode currently returns 1 (one) by default since there is no hash difficulty in the underlying EOS consensus protocol.

### `GASLIMIT (0x45)`

This opcode currently returns `0x7FFFFFFFFFF` (2^43-1) as the maximum gas limit in EOS EVM.
