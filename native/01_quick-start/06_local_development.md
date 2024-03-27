---
title: Local Development
---

Developing using the [Web IDE](https://ide.eosnetwork.com) will only take you so far.
Eventually, you will want to develop locally on your machine, so that you can easily use version control, your
favorite editor, and other tools that you are used to.

This guide will walk you through setting up your local development environment using [FuckYea](https://github.com/nsjames/fuckyea).

## Creating a new project

You don't need to install the `fuckyea` CLI locally, you can use `npx` for all commands.

```bash
fuckyea create <project_name> [optional_directory] 
```

This will create a project structure that looks like this:

```bash
📂 contracts
  📄 contract.cpp
📂 deployments
  📄 jungle.ts
📂 tests
  📄 contract.spec.ts
🔐 .env
📄 .gitignore
📄 fuckyea.config.js
📄 package.json
```

## Developing contracts

The `contract.cpp` file inside of `contracts` already has a simple contract that you can use to get started. 

### Creating new contracts

You can either manually create a contract, copy an existing one, or use the scaffold CLI.

```bash
npx fuckyea scaffold contract <name> [optional_directory]
```

### Building contracts

In order to test or deploy your contracts, you will need the `.wasm` and `.abi` files. To get them from your C++ files, you can 
use the CLI build command from your directory root.

```bash
npx fuckyea build
```

All build files will be saved to the `build/` directory.

```bash
📂 build
  📄 contract.abi
  📄 contract.wasm
📂 contracts
  📄 contract.cpp
```

### Testing contracts

Testing using FuckYea uses VeRT, an emulator for EOS. You can head over to the [testing guide](../03_smart-contracts/50_testing.md) if you want to learn about writing tests.

```bash
npx fuckyea test [--build]
```

Using the build option will simply batch both a build and test job together. It is no different than running build before test.

You can also scaffold a new test:

```bash
npx fuckyea scaffold test <name> [optional_directory]
```




## Deploying contracts

FuckYea is able to deploy contracts to any Antelope network. The default that comes with new projects is the `Jungle4` network, a common testnet.

### The config file

A lot of the setup for deployments is done in the `fuckyea.config.js` file at the root of your project.

It exports a `JSON` object that includes `network` property which defines the chain, and accounts you need to deploy contracts.

```json
networks: {
    jungle: {
        // node_url: 'https://eos.greymass.com',
        chain: 'Jungle4',
        accounts: [
            {
                name: 'youraccount',
                permission: 'owner',
                private_key: process.env.PRIVATE_KEY
            }
        ]
    }
}
```

#### The key for the network

The name of your deployment file in the `deployments` directory must always match the name of the key in the `networks` object.
For instance, above we have defined the `jungle` network, and we also have a `deployments/jungle.ts` file.

If you wanted to have a Mainnet file, you would add both the `mainnet` key in `networks` and a `deployments/mainnet.ts` deployment file.

#### Specifying a node

You can either use the `chain` property to specify a chain, or you can use the `node_url` property to specify a specific node endpoint.

If you want to use `chain`, you can refer to the [WharfKit Chains definition](https://github.com/wharfkit/common/blob/b9cfe061b2619e297b2ead8dbe7f543617ebb455/src/common/chains.ts#L168) for a list
of available chains.

Two common ones are:
- `Jungle4`
- `EOS`

#### Registering accounts

In order for the deployment script to know what keys belong to which accounts, you need to specify them here. 
The `accounts` property is an array of account definitions that include the following properties.

| Property | Description                                              |
| --- |----------------------------------------------------------|
| name | The name of the account                                  |
| permission | The permission level of the account (defaults to `active`) |
| private_key | The private key of the account                           |

##### Using environment variables

The project includes a `.env` file that you can use to store your private keys. This file is ignored by git, so you can safely store your keys here.

```bash
PRIVATE_KEY=your_private_key
```

**Please make sure to never commit your `.env` file to a public repository, or use private keys in plain text in the config file.**

### Deployment files

The deployment files are written in JavaScript and are used to deploy contracts to the network.

They are injected with a `deployer` object that has the following properties:

| Property | Description                                                                      |
| --- |----------------------------------------------------------------------------------|
| accounts | An array of account definitions                                                  |
| sessions | An object that holds the current wharfkit session for each account               |
| deploy | A function that you can use to deploy a contract and returns a wharfkit contract |


```javascript
module.exports = async (deployer) => {

    const contract = await deployer.deploy('someaccount', 'build/mycontract', {
        // adds the `eosio.code` permission to the contract account's active permission
        // so that you can send inline actions from the contract in its name
        addCode: true
    }).catch(err => {
        console.error(err)
        process.exit(1);
    })

    // do other stuff here...
}
```

### Creating deployments

You can either manually create a deployment, copy an existing one, or use the scaffold CLI.

```bash
npx fuckyea scaffold deployment <network> [optional_directory]
```

### Deploying contracts

To deploy a contract, you can use the CLI deploy command.

```bash
npx fuckyea deploy <network> [--build]
```










## Troubleshooting

Sometimes you run into problems. If you have anything that isn't on this list, please reach out in the [Developers Telegram](https://t.me/antelopedevs) group.

### Multi-contract support

If you have multiple contracts in your project, then the compiler won't know which `.cpp` file is the entry file into that specific contract.

To fix this, you can change the suffix to `.entry.cpp` for each contract, and you will then get back named builds for each.

```bash
📂 build
  📄 game.abi
  📄 game.wasm
  📄 token.abi
  📄 token.wasm
📂 contracts
  📄 game.entry.cpp
  📄 token.entry.cpp
```
