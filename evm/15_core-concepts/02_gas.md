---
title: Gas
---

In an EVM, **gas** is the unit of measurement for the amount of work that a transaction or contract execution requires.
Every transaction that modifies the state of the blockchain must pay a fee in gas.

Each operation (or `opcode`) has a fixed gas cost. You can see a list of all of the `opcodes` and their gas costs
on [EVM Codes](https://www.evm.codes/).

- The gas **required** is the sum of the gas costs of all `opcodes` that it performs.
- The gas **fee** is calculated by multiplying the amount of gas required by the current gas price.

If the transaction runs out of gas before it completes, then the transaction will fail and all changes will be reverted,
but the gas spent will not be refunded.

