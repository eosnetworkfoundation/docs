---
title: Configure Hardhat
---

[Hardhat](https://hardhat.org/) is a widely used development environment and testing framework for Ethereum smart contracts. Thanks to the architecture of the EOS EVM, all the existing SDKs for Ethereum will work out of the box and your users will have the same experience as on Ethereum.

Therefore, the official Hardhat tutorials apply to EOS EVM perfectly.

Just do not forget to modify the config in `hardhat.config.js` file:

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

[Hardhat quick start tutorial](https://hardhat.org/tutorial).
