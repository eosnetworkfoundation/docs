---
title: Transaction Miner
--- 

The EOS EVM transaction miner is a simple transaction relay that allows you to take Ethereum formatted transactions and 
push them to the EOS EVM contract on an EOS Native node. 


## Your miner account

You will need an EOS Network account which will serve as your **miner account**. 

The EOS EVM Miner software takes the EVM transactions that it receives and converts them into EOS transactions which it then sends 
to the `eosio.evm` contract on the native EOS Network. 

As a relay of these transactions you have the opportunity to earn rewards for the service you provide.

### Miners and resources

As your miner account relays transactions it will slowly be depleting its CPU and NET resources. You will need to manage these
resources to ensure your miner can continue to operate.

Services like PowerUp should be automated to ensure that your miner account has enough resources to continue operating 
without interruption.

> ❔ **RAM is not required**
> 
> Your miner account does not deplete RAM resources as it relays transactions. It only consumes CPU and NET resources.
> The `eosio.evm` contract pays for the RAM that the EOS EVM uses through the fees it collects from the EVM transactions.

### Registering your miner

Once you have your miner account, you will need to register it with the `eosio.evm` contract.

```bash
cleos -u https://eos.greymass.com/ push action eosio.evm open '["<your-miner-account>"]' -p <your-miner-account>
```

If you'd like to register using a web interface you can visit [bloks.io](https://bloks.io/account/eosio.evm?loadContract=true&tab=Actions&account=eosio.evm&scope=eosio.evm&limit=100&action=open)
and sign the transaction using a wallet like [Anchor](https://www.greymass.com/anchor).

### Viewing your mining rewards

The `eosio.evm` contract will store the rewards you earn from mining in a table. You can view these rewards at any time by
getting the table rows from the contract's `balances` table with the upper and lower bound set to your miner account:

```bash
cleos -u https://eos.greymass.com/ get table eosio.evm eosio.evm balances -U <your-miner-account> -L <your-miner-account>
```

You can also view the same data on [bloks.io](https://bloks.io/account/eosio.evm?loadContract=true&tab=Tables&account=eosio.evm&scope=eosio.evm&limit=100&table=balances)


### Withdrawing your mining rewards

The `eosio.evm` contract will store the rewards you earn from mining in a table. You can withdraw these rewards at any
time by sending a transaction to the `eosio.evm` contract with the following action:

```bash
cleos -u https://eos.greymass.com/ push action eosio.evm withdraw '["<your-miner-account>", "1.0000 EOS"]' -p <your-miner-account>
```

If you'd like to claim using a web interface you can visit [bloks.io](https://bloks.io/account/eosio.evm?loadContract=true&tab=Actions&account=eosio.evm&scope=eosio.evm&limit=100&table=balances&action=withdraw)
and sign the transaction using a wallet like [Anchor](https://www.greymass.com/anchor).


## Setting up the miner

### Installation

Make sure you have `node` installed on your machine. 

The recommended version is [`18.16.0`](https://nodejs.org/en/download), and the minimum version is `16.16.0`.

#### Get the miner from GitHub and inst all dependencies

```bash
git clone https://github.com/eosnetworkfoundation/eos-evm-miner.git
cd eos-evm-miner
yarn
```

#### You also need to set up you Environment Variables
Copy the `.env.example` file to `.env` and fill in the environment variables.

| Name | Description                                                                                                       | Default |
| --- |-------------------------------------------------------------------------------------------------------------------|---------|
| `PRIVATE_KEY` | The private key of the miner account                                                                              |         |
| `MINER_ACCOUNT` | The name of the miner account on the EOS Network                                                                  |         |
| `RPC_ENDPOINTS` | A list of EOS RPC endpoints to connect to, comma-delimited                                                        |         |
| `PORT` | The port to listen on for incoming Ethereum transactions                                                          | `50305` |
| `LOCK_GAS_PRICE` | If set to `true`, one a gas price is set, this miner will not hit the EOS API node again to fetch a new gas price | `true`  |




### Start mining

```bash
yarn mine
```

> 📄 **Logs**:
> 
> A `logs` directory is created in the project root with two log files:
> - **error.log**: Only error logs
> - **combined.log**: Everything else





