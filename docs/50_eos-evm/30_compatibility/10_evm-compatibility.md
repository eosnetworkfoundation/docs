---
title: EVM Compatibility
---

EOS EVM is fully compatible with the Ethereum EVM specification, including all precompiles and opcodes. However, there are some EOS EVM differences:

## Precompiles

EOS EVM supports all precompiles supported by Ethereum, with the following distinctions:

### `modexp (0x05)`

The exponent bit size cannot exceed either the base bit size or the modulus bit size.

> ℹ️ Info  
If the above limits are not met, the precompile will throw an exception and the transaction will be halted.

## Opcodes

### `BLOCKHASH (0x40)`

This opcode currently does not return the hash of the specified block contents, but the hash of the specified block height and the chain ID instead:

`block_hash = sha256( msg(block_height, chain_id) )`

where:
* `block_height`: specified 64-bit block height
* `chain_id`: used as a 64-bit salt value
* `msg`: concatenation of a leading zero byte constant, the `block_height`, and the `chain_id`, in big endian format.

> ℹ️ Info  
The leading zero byte in the hash is a version byte which may change if a new blockhash scheme is introduced in the future.

### `COINBASE (0x41)`

This opcode always returns 0 (zero).

> ℹ️ Info  
This value might change in the future to return the address of the EOS EVM engine deployment, or the address of the account receiving the block rewards.

### `DIFFICULTY (0x44)`

This opcode always returns 1 (one) as the default difficulty since there is no hash difficulty in the underlying EOS consensus protocol.

> ℹ️ Info  
This value might change in the future to return the EOS EVM's perceived randomness value - see [EIP-4399](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-4399.md#abstract).

### `GASLIMIT (0x45)`

This opcode always returns `INT64_MAX` or `0x7FFFFF..FF` (2^63-1).
