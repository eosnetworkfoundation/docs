---
title: Migrate your Smart Contract
---

This guide will teach you to deploy a smart contract to the Vaulta EVM using hardhat on both the Vaulta EVM mainnet.

## Set up your MetaMask

Click either of these buttons to instantly add Vaulta EVM to your MetaMask.

<!-- translation-ignore -->

import ConnectMetaMask from '@site/src/components/ConnectMetaMask/ConnectMetaMask';

<ConnectMetaMask />

<!-- end-translation-ignore -->


## Getting EOS tokens

If you're on the Vaulta Mainnet, ]you can transfer your native EOS using a standard EOS transfer:
- Send tokens to: `eosio.evm`
- Set the `memo` to your Vaulta EVM address

> ⚠️ **Important**
> If you have only Vaulta, you will need to swap it to EOS. See the EVM tokens page below for more information.

For more ways to get EOS tokens, check out the [EVM Tokens](/evm/10_quick-start/03_evm-tokens.md) page.

## Hardhat configuration

If you want to set up a new hardhat project, head over to their [quick start](https://hardhat.org/hardhat-runner/docs/getting-started#quick-start)
guide.


Open up your `hardhat.config.js` file and add the following configuration:


```javascript
const config: HardhatUserConfig = {
    // ...

    networks: {
        vaulta_evm: {
            url: "https://api.evm.eosnetwork.com",
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

Now you can deploy your contract to the Vaulta EVM:

```bash
npx hardhat run scripts/deploy.js --network vaulta_evm
```

Once deployed, you will see the address of your new contract, and can view it an explorer by pasting it 
into the search field.

- [**Mainnet Explorer**](https://explorer.evm.eosnetwork.com/)

![deploy hardhat](/images/deploy_hardhat.png)

## Congratulations!

You have successfully deployed your first smart contract to the Vaulta EVM! 🎉

If you already have a front-end application that interacts with your smart contract, you can now point it at the 
[Vaulta EVM Endpoints](../quick-start/endpoints), and it will work as expected.

Make sure you visit the [**Compatibility**](/evm/999_miscellaneous/20_evm-compatibility.md) section to learn about the differences between
the Vaulta EVM and Ethereum, and how to make sure your web3 application works on the Vaulta EVM as expected.
