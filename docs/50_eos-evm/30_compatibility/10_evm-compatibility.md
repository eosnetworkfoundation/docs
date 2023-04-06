---
title: EVM Compatibility
---

## Precompiles

| Address | ID          | Name                                 | Spec                                                             | Status         |
| ------- | ----------- | ------------------------------------ | ---------------------------------------------------------------- | -------------- |
| 0x01    | `ECRecover` | ECDSA public key recovery            | [Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf) | in development |
| 0x02    | `SHA256`    | SHA-2 256-bit hash function          | [Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf) | in development |
| 0x03    | `RIPEMD160` | RIPEMD 160-bit hash function         | [Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf) | in development |
| 0x04    | `Identity`  | Identity function                    | [Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf) | in development |
| 0x05    | `ModExp`    | Big integer modular exponentiation   | [EIP-198](https://eips.ethereum.org/EIPS/eip-198)                | in development |
| 0x06    | `BN128Add`  | Elliptic curve addition              | [EIP-196](https://eips.ethereum.org/EIPS/eip-196)                | in development |
| 0x07    | `BN128Mul`  | Elliptic curve scalar multiplication | [EIP-196](https://eips.ethereum.org/EIPS/eip-196)                | in development |
| 0x08    | `BN128Pair` | Elliptic curve pairing check         | [EIP-197](https://eips.ethereum.org/EIPS/eip-197)                | in development |
| 0x09    | `Blake2F`   | BLAKE2b `F` compression function     | [EIP-152](https://eips.ethereum.org/EIPS/eip-152)                | in development |

## Opcodes[​](https://doc.aurora.dev/compat/evm#opcodes) <a href="#opcodes" id="opcodes"></a>

### `BLOCKHASH`[​](https://doc.aurora.dev/compat/evm#blockhash) <a href="#blockhash" id="blockhash"></a>

In the **developer preview testnet** this opcode will not be available and calling it will make the EOS EVM contract to raise and exception stopping contract execution at EOS level.

### `COINBASE`[​](https://doc.aurora.dev/compat/evm#coinbase) <a href="#coinbase" id="coinbase"></a>

In the **developer preview testnet** this will be _0x0000000000000000000000000000000000000000_

### `DIFFICULTY`[​](https://doc.aurora.dev/compat/evm#difficulty) <a href="#difficulty" id="difficulty"></a>

In the **developer preview testnet** this will be 0

### `GASLIMIT`[​](https://doc.aurora.dev/compat/evm#gaslimit) <a href="#gaslimit" id="gaslimit"></a>

In the **developer preview testnet** this will be INT64\_MAX
