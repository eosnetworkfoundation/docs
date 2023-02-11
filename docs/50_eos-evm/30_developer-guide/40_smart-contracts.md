---
title: Smart Contracts
---

## Solidity

Currently the Trust is using a standard EVM implementation. Therefore all existing solidity compilers targeting standard EVM environment should work.

There might be some limitations in the smart contracts. Please check [EVM Compatibility](./20_compatibility/index.md) documentation for more information.

In the future, we might develop add-ons to the VM of the Trust EVM to support more features. In that case, one may need to use our SDK for development. We will update this guild if that happens.

## TruffleSuite

[Truffle](https://www.trufflesuite.com/) is a widely used development environment and testing framework for Ethereum smart contracts. Thanks to the architecture of the Trust EVM, all the existing SDKs for Ethereum will work out of the box and your users will have the same experience as on Ethereum.

Therefore, the official tutorials of Truffle applies to our Trust EVM perfectly:

[https://trufflesuite.com/docs/truffle/quickstart/](https://trufflesuite.com/docs/truffle/quickstart/)

The only difference would be don't forget to modify the config in `truffle-config.js` file:

```javascript
module.exports = {
  networks: {
  // Use the address of your favorite endpoint.
    eosevm: {
      host: "api-testnet.trust.one",
      port: 15556,
      network_id: "*"
    }
  }
};

```

## Remix

Learn how to [Develop EOS EVM Smart Contracts With Remix](./develop-trust-smart-contracts-with-remix.md) tutorial.
