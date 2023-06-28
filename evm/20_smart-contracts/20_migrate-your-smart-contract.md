---
title: Migrate your Smart Contract
---

This guide will teach you to deploy a smart contract to the EOS EVM using hardhat on both the EOS EVM mainnet and testnet.

## Set up your MetaMask


import ConnectMetaMask from '@site/src/components/ConnectMetaMask/ConnectMetaMask';

Click either of these buttons to instantly add EOS EVM to your MetaMask.

<ConnectMetaMask />


## Getting EOS tokens

import FaucetTokens from '@site/src/components/FaucetTokens/FaucetTokens';

Want some EOS tokens to play with? Click the button below to get some from the testnet faucet.

<FaucetTokens />

If you're on the testnet, you can get some EOS tokens using the [**testnet faucet**](https://faucet.testnet.evm.eosnetwork.com/).

If you're on the EOS Mainnet, ]you can transfer your native EOS using a standard EOS transfer:
- Send tokens to: `eosio.evm`
- Set the `memo` to your EOS EVM address

For more ways to get EOS tokens, check out the [EVM Tokens](/evm/10_quick-start/03_evm-tokens.md) page.

## Hardhat configuration

If you want to set up a new hardhat project, head over to their [quick start](https://hardhat.org/hardhat-runner/docs/getting-started#quick-start)
guide.


Open up your `hardhat.config.js` file and add the following configuration:


```javascript
const config: HardhatUserConfig = {
    // ...

    networks: {
        eosevm: {
            url: "https://api.evm.eosnetwork.com",
            accounts:[process.env.PRIVATE_KEY],
        },
        eosevm_testnet: {
            url: "https://api.testnet.evm.eosnetwork.com",
            accounts:[process.env.PRIVATE_KEY],
        }
    }
};
```

> 🔑 **Private Keys**
> 
> Note that we are using `process.env.PRIVATE_KEY` to make sure that our private key isn't exposed in our code.
> This means you need to be using either something like `dotenv` to inject the key into your environment,
> add it manually to your environment, or you can just replace the environment variable with your private key directly.
> 
> However, be careful putting your actual key into this file, as it may be committed to a public repository,
> and you should NEVER share your private key with anyone.

## Deploying your contract

Now you can deploy your contract to the EOS EVM testnet:

```bash
npx hardhat run scripts/deploy.js --network eosevm

// or for testnet
npx hardhat run scripts/deploy.js --network eosevm_testnet
```

Once deployed, you will see the address of your new contract, and can view it an explorer by pasting it 
into the search field.

- [**Testnet Explorer**](https://explorer.testnet.evm.eosnetwork.com/)
- [**Mainnet Explorer**](https://explorer.evm.eosnetwork.com/)

![deploy hardhat](/images/deploy_hardhat.png)

## Congratulations!

You have successfully deployed your first smart contract to the EOS EVM! 🎉

If you already have a front-end application that interacts with your smart contract, you can now point it at the 
[EOS EVM Endpoints](./10_endpoints.md) and it will work as expected.

Make sure you visit the [**Compatibility**](../30_compatibility/index.md) section to learn about the differences between
the EOS EVM and Ethereum, and how to make sure your web3 application works on the EOS EVM as expected.
