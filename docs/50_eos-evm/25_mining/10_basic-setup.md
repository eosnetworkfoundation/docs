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
make -j8 # this wil take around 5 minutes
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

To verify that you have all the tools installed, run this command.

```bash
eos-evm-node --version && eos-evm-rpc --version && silkrpc_toolbox --version && silkrpcdaemon --version
```

If you got back 4 version numbers, you're good to go.

You now have the following binaries available for usage:
```
cmd/eos-evm-node
cmd/eos-evm-rpc
cmd/silkrpc_toolbox
cmd/silkrpcdaemon
```

## Accounts you need

You will need an EOS Network account which will serve as your miner. 

## Registering your miner

