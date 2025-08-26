---
title: Truffle
---

Modify your `truffle-config.js` to add the Vaulta EVM to [Truffle](https://www.trufflesuite.com/):

```javascript
require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
    networks: {
        vaulta_evm: {
            provider: new HDWalletProvider([process.env.PRIVATE_KEY], "https://api.evm.eosnetwork.com"),
            network_id: 17777,
        },
        // ... other networks
    },
    // ... other config
```

### Installing dependencies

You may need to install `@truffle/hdwallet-provider` and `dotenv`:

```bash
npm install @truffle/hdwallet-provider dotenv
// or
yarn add @truffle/hdwallet-provider dotenv
```

