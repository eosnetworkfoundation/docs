---
title: Smart Contracts
---

## Solidity

Currently the EOS EVM is using a standard EVM implementation. Therefore all existing solidity compilers targeting standard EVM environment should work.

There might be some limitations in the smart contracts. Please check [EVM Compatibility](./20_compatibility/index.md) documentation for more information.

## TruffleSuite

[Truffle](https://www.trufflesuite.com/) is a widely used development environment and testing framework for Ethereum smart contracts. Thanks to the architecture of the EOS EVM, all the existing SDKs for Ethereum will work out of the box and your users will have the same experience as on Ethereum.

Therefore, the official Truffle tutorials apply to EOS EVM perfectly.
Just do not forget to modify the config in `truffle-config.js` file:

```javascript
module.exports = {
  networks: {
  // Use the address of your favorite endpoint.
    eosevm: {
      host: "http://3.129.163.107:80",
      port: 15557,
      network_id: "*"
    }
  }
};

```

[Truffle quick start guide](https://trufflesuite.com/docs/truffle/quickstart/).

## Remix

Learn how to [Develop EOS EVM Smart Contracts With Remix](./50_develop-eos-evm-smart-contracts-with-remix.md) tutorial.
