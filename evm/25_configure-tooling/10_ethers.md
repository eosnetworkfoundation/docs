---
title: Ethers
---



[Ethers](https://github.com/ethers-io/ethers.js) is by far the most used JavaScript SDK for EVM.

Using Ethers with EOS EVM is the same as using it with any other EVM compatible chain.
One thing to note is that as of writing this doc, our RPC endpoint does not support batch requests, so you must disable
batching when creating your provider:

```javascript
import { JsonRpcProvider } from "ethers";

const provider = new JsonRpcProvider("https://api.evm.eosnetwork.com/", undefined, {
    batchMaxCount: 1
});
```
