---
title: Basic Setup
--- 

<head>
    <title>EOS EVM - Basic Setup</title>
</head>

No matter if you want to run locally, on the testnet or on the mainnet, there are a few things you need to know, get, and do.

## Hardware Requirements

| Hardware | Minimum | Recommended | Impact                           |
| --- | --- | --- |----------------------------------|
| CPU | 4 cores | 8 cores | Tx throughput                    |
| RAM | 16 GB | 32 GB | Compilation and processing speed |
| SSD | 100 GB | 1 TB | History storage                  |
| Network | 100 Mbps | 1 Gbps | Latency                          |

## Software Requirements

### Supported Operating Systems

- [Ubuntu 20.04 (Focal Fossa)](https://releases.ubuntu.com/20.04/)
- [Ubuntu 22.04 (Jammy Jellyfish)](https://releases.ubuntu.com/22.04/)

### Required Software

<details>
    <summary>gcc 10+</summary>

```bash
gcc --version

# If gcc is not installed or your gcc is not version 10+:

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential
sudo apt install -y gcc-10 g++-10 cpp-10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10

# Make sure your version is now 10+:
gcc --version
```
</details>

<details>
    <summary>cmake & makeinfo</summary>

```bash
cmake --version

# If cmake is not installed or your cmake is not version 3.16+:
sudo apt install -y cmake

# You also need makeinfo
sudo apt-get install -y texinfo

```
</details>


## Install EOS EVM

### Grab the code
```bash
git clone https://github.com/eosnetworkfoundation/eos-evm.git
cd eos-evm
git submodule update --init --recursive
```

### Build the code
```bash
mkdir build
cd build
cmake .. # this will take around 40 minutes
make -j8 # this wil take around 20 minutes
```


<details>
    <summary>If you'd like to build with another compiler:</summary>

```
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ ..
make -j8
```
</details>

Once done, let's add the binaries to your path.
```bash
cd cmd
# this will add the binaries to your path, and persist after reboot
echo 'export PATH=$PATH:$(pwd)' | tee -a ~/.bashrc
```

You can make sure you have the binaries in your path by running:
```bash
eos-evm-node --version
```

If you see the version, you're good to go!


## Your miner account

You will need an EOS Network account which will serve as your **miner**. This account will take the EVM transactions that your node converts into 
EOS transactions and send them to the `eosio.evm` contract on the native EOS Network. 

It is your responsibility to secure this account and manage its resources (which will be depleted by the transactions it sends).

## Registering your miner

Once you have your miner account, you will need to register it with the `eosio.evm` contract. 

This is done by sending a transaction to the `eosio.evm` contract with the following action:

```bash
cleos -u https://eos.greymass.com/ push action eosio.evm open '["<your-miner-account>"]' -p <your-miner-account>
```

If you'd like to register using a web interface you can visit [bloks.io](https://bloks.io/account/eosio.evm?loadContract=true&tab=Actions&account=eosio.evm&scope=eosio.evm&limit=100&action=open)
and sign the transaction using a wallet like [Anchor](https://www.greymass.com/anchor).

## Viewing your mining rewards

The `eosio.evm` contract will store the rewards you earn from mining in a table. You can view these rewards at any time by
getting the table rows from the contract's `balances` table with the upper and lower bound set to your miner account:

```bash
cleos -u https://eos.greymass.com/ get table eosio.evm eosio.evm balances -U <your-miner-account> -L <your-miner-account>
```


## Withdrawing your mining rewards

The `eosio.evm` contract will store the rewards you earn from mining in a table. You can withdraw these rewards at any 
time by sending a transaction to the `eosio.evm` contract with the following action:

```bash
cleos -u https://eos.greymass.com/ push action eosio.evm withdraw '["<your-miner-account>", "1.0000 EOS"]' -p <your-miner-account>
```



