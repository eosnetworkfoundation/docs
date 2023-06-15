---
title: Configuration
sidebar_class_name: sidebarhidden
---

While there are a few steps to installing and configuring a local EOS blockchain node, it is pretty straight forward once you understand the pieces. This guide will walk you through configuring _Ubuntu_, installing _Antelope Leap_, the _Contract Development Toolkit (CDT)_, and the _EOS Foundation Network's System Contracts_, then configuriong everything for a local developmance instance. The process itself only takes a few minutes, but we will explain the parts as we progress through them and point you to additional resources for other options. 
![Local Node Architecture](local_node_architecture.svg)
## The Local Node Stack
Running a local node has the following parts
* **Ubuntu** distribution of Linux as the operating system. For development purposes this could be a Virtual Machine or even Windows Subsystem for Linux (WSL). 
* **[Antelope Leap](https://github.com/AntelopeIO/leap)** is the C++ implementation of the Antelope protocol. It includes includes multiple parts. In this guide you will learn about `nodeos`, `cleos`, & `keosd` 
    * `nodeos` is the core service daemon that runs on every Antelope node. It can be configured to process smart contracts, validate transactions, produce blocks containing valid transactions, and confirm blocks to record them on the blockchain.
    * `cleos` is a command line tool that interfaces with the REST API exposed by `nodeos`. Developers can also use `cleos` to deploy and test Antelope smart contracts.
    * `keosd` is a key manager service daemon for storing private keys and signing digital messages. It provides a secure key storage medium for keys to be encrypted at rest in the associated wallet file. `keosd` also defines a secure enclave for signing transaction created by `cleos` or a third part library.
    * Other utilities: `trace_api_util` is a command-line interface (CLI) utility that allows node operators to perform low-level tasks associated with the Trace API Plugin. 
* **[Antelope CDT](https://github.com/AntelopeIO/cdt)** is the Contract Development Toolkit. A suite of tools to facilitate C/C++ development of contracts for Antelope blockchains. 
*  **[EOS Foundation Network's System Contracts](https://github.com/eosnetworkfoundation/eos-system-contracts)** are a collection of contracts specifically designed for the EOS blockchain, which implements a lot of critical functionality that goes beyond what is provided by the base Antelope protocol, the protocol on which EOS blockchain is built on.

Antelope Leap and CDT are released as Debian (.deb) packages, so installing from release is easiest with a Ubuntu or Debian based distribution of Linux. It is also possible to build from source on other platforms, but that is beyond the scope of this guide.

## Operating System
Antelope currently supports the following operating systems:

1.  [Ubuntu 22.04 Jammy Jellyfish](https://releases.ubuntu.com/jammy/)
2.  [Ubuntu 20.04 Focal Fossa](https://www.releases.ubuntu.com/focal/)
3.  [Ubuntu 18.04 Bionic Beaver](https://www.releases.ubuntu.com/bionic/)

As a Long Term Support (LTS) version of Ubuntu, these versions and their included packages receive security updates and support for 5 years, as opposed to the 9 months with other versions. You may be able to install on a different version of Ubuntu, or a Ubuntu based distribution (like Mint), but that is beyond the scope of this guide.

## Installation
We will create an `eos` folder in your home directory, and all of our configuration assumes that path is used. We will download the installation files into a `temp` folder which you can remove later if you like.

We are installing [Leap 4.0.1](https://github.com/AntelopeIO/leap/releases/tag/v4.0.1) and [CDT 3.1.0](https://github.com/AntelopeIO/cdt/releases/tag/v3.1.0) for AMD 64 (x86-64). There is a newer version of CDT, but it isn't compatible with the current [3.1.1 version of the EOS System Contracts](https://github.com/eosnetworkfoundation/eos-system-contracts/releases/tag/v3.1.1). CDT comes with ARM64 and AMD64 versions of the package, while Leap has three different packages depending on the target versions of Ubuntu: 18.04, 20.04, or 22.04, all on AMD64. Part of the difference between the Leap packages is that Ubuntu 22.04 stopped using libssl v1.1, which is build into 20.04.

Download [CDT 3.1.0](https://github.com/AntelopeIO/cdt/releases/download/v3.1.0/cdt_3.1.0_amd64.deb) and the Leap package based on your Ubuntu version [18.04](https://github.com/AntelopeIO/leap/releases/download/v4.0.1/leap_4.0.1-ubuntu18.04_amd64.deb), [20.04](https://github.com/AntelopeIO/leap/releases/download/v4.0.1/leap_4.0.1-ubuntu20.04_amd64.deb), or [22.04](https://github.com/AntelopeIO/leap/releases/download/v4.0.1/leap_4.0.1-ubuntu22.04_amd64.deb), and then install them with apt-get. For example if you were installing on 22.04 Jammy Jellyfish, then you could use the following commands:

```bash
mkdir ~/eos
mkdir ~/eos/temp
cd ~/eos/temp

wget https://github.com/AntelopeIO/leap/releases/download/v4.0.1/leap_4.0.1-ubuntu22.04_amd64.deb
wget https://github.com/AntelopeIO/cdt/releases/download/v3.1.0/cdt_3.1.0_amd64.deb

sudo apt-get install -y ./cdt_*.deb ./leap_*.deb
```

To verifiy the installation completed correctly use the following commands:

```bash
nodeos --version
cdt-cpp --version
```

and you should see output indicating Leap version 4.0.1 and CDT version 3.10 were installed:

```
 --versionv4.0.1
 cdt-cpp version 3.1.0
```

Alternatively you can use the following script to evaluate the Ubuntu Codename to determine the correct package version to download and install. This _may_ work with Ubuntu based distributions like Mint as long as `/etc/os-release` reports one of the LTS Ubuntu codenames: `jammy`, `focal`, or `bionic`.) 

```bash
#!/bin/bash

# Only supports Ubuntu 22.04, 20.04, and 18.04
case $(grep -E '^(UBUNTU_CODENAME)=' /etc/os-release) in
    UBUNTU_CODENAME=jammy)
        VERSION_ID=22.04
        ;; 
    UBUNTU_CODENAME=focal)
        VERSION_ID=20.04
        ;;
    UBUNTU_CODENAME=bionic)
        VERSION_ID=18.04
        ;;
    *)
        echo "Unsupported operating system"
        exit
        ;;
esac

echo "Installing as Ubuntu $VERSION_ID"

mkdir ~/eos
mkdir ~/eos/temp

wget https://github.com/AntelopeIO/leap/releases/download/v4.0.1/leap_4.0.1-ubuntu${VERSION_ID}_amd64.deb \
    -O ~/eos/temp/leap_4.0.1-ubuntu${VERSION_ID}_amd64.deb
wget https://github.com/AntelopeIO/cdt/releases/download/v3.1.0/cdt_3.1.0_amd64.deb \
    -O ~/eos/temp/cdt_3.1.0_amd64.deb
sudo apt-get install -y ~/eos/temp/cdt_*.deb ~/eos/temp/leap_*.deb

echo nodeos
nodeos --version
echo cdt
cdt-cpp --version
```

## System Contracts
There currently isn't a released build of the [EOS Foundation Network System Contracts](https://github.com/eosnetworkfoundation/eos-system-contracts), but building them from code is easy enough since we already have Leap and CDT installed. You can either use the git command to make a clone of the latest version of the contracts, or download the 3.1.1 release. Either way you need the prerequisites to build the contracts, which are installed with the following commands:

```bash
sudo apt-get update
sudo apt-get install -y build-essential clang clang-tidy cmake \
                        git libxml2-dev opam ocaml-interp \
                        python3 python3-pip time curl
```

Then download and extract the [3.1.1 release](https://github.com/eosnetworkfoundation/eos-system-contracts/releases/tag/v3.1.1) into our `temp` folder and run the `build.sh` script:

```bash
wget https://github.com/eosnetworkfoundation/eos-system-contracts/archive/refs/tags/v3.1.1.tar.gz \
    -O ~/eos/temp/eos-system-contracts_v3.1.1.tar.gz
rm -fdr ~/eos/temp/eos-system-contracts-3.1.1
tar xf ~/eos/temp/eos-system-contracts_v3.1.1.tar.gz --directory ~/eos/temp/
cd ~/eos/temp/eos-system-contracts-3.1.1/ 
./build.sh
```

You can validate that the build was successful by looking for the compiled contracts (`*.wasm`) in the `~/eos/temp/eos-system-contracts-3.1.1/build/` folder

```bash
cd ~/eos/temp/eos-system-contracts-3.1.1/build/
find . -type f -name eosio.*.wasm
```

and you should receive the following output:

```
./contracts/eosio.bios/eosio.bios.wasm
./contracts/eosio.boot/eosio.boot.wasm
./contracts/eosio.token/eosio.token.wasm
./contracts/eosio.system/eosio.system.wasm
./contracts/eosio.wrap/eosio.wrap.wasm
./contracts/eosio.msig/eosio.msig.wasm
```

We will deploy the following system contracts later: `eosio.bios.wasm`, `eosio.msig.wasm`, `eosio.token.wasm`, and `eosio.system`

## Config.ini

## Plugins

## CORS
