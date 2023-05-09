---
title: Verify A Smart Contract
---

This document shows the steps you need to follow to verify a smart contract through its flattened source code.

## Prerequisites

You should have the following:

1. The smart contract address, let us assume it is `SMART_CONTRACT_ADDRESS`
2. The compiler version used to compile the smart contract, let us assume it is `COMPILER_VERSION`
3. The EVM version the WASM was compiled for, let us assume it is `EVM_VERSION`
4. The solidity flattened source code for your smart contract

## Start

Go to https://explorer.evm.eosnetwork.com/address/SMART_CONTRACT_ADDRESS/verify-via-flattened-code/new

## Fill In The Verification Form

1. Select the compiler version used to compile the smart contract, in this case the `COMPILER_VERSION`
2. Select the EVM version, in this case `EVM_VERSION`
3. Copy & paste the solidity contract flattened source code
4. Click `Verify & Push` button
