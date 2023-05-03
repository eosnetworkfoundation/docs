---
title: Configure Truffle
---

[Truffle](https://www.trufflesuite.com/) is a widely used development environment and testing framework for Ethereum smart contracts. Thanks to the architecture of the EOS EVM, all the existing SDKs for Ethereum will work out of the box and your users will have the same experience as on Ethereum.

Therefore, the official Truffle tutorials apply to EOS EVM perfectly.
Just do not forget to modify the config in `truffle-config.js` file:

**To connect to EOS EVM mainnet**

```javascript
module.exports = {
  networks: {
  // Use the address of your favorite endpoint.
    eosevm: {
      host: "api.evm.eosnetwork.com",
      port: 17777,
      network_id: "*"
    }
  }
};
```

**To connect to EOS EVM testnet**

```javascript
module.exports = {
  networks: {
  // Use the address of your favorite endpoint.
    eosevm: {
      host: "api.testnet.evm.eosnetwork.com",
      port: 15557,
      network_id: "*"
    }
  }
};
```

[Truffle quick start guide](https://trufflesuite.com/docs/truffle/quickstart/).
