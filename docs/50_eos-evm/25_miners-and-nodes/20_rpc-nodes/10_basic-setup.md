---
title: Basic Setup
--- 

<head>
    <title>EOS EVM - Basic Setup</title>
</head>

Before we can configure and run your EOS EVM node, we need to make sure your system meets the requirements, and has the 
proper software installed.

## Requirements

| Hardware | Minimum | Recommended | Impact                           |
| --- | --- | --- |----------------------------------|
| CPU | 4 cores | 8 cores | Tx throughput                    |
| RAM | 16 GB | 32 GB | Compilation and processing speed |
| SSD | 100 GB | 1 TB | History storage                  |
| Network | 100 Mbps | 1 Gbps | Latency                          |


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


## Install the EOS EVM Node

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
echo 'export PATH=$PATH:$(pwd)' >> ~/.bashrc
source ~/.bashrc
```

You can make sure you have the binaries in your path by running:
```bash
eos-evm-node --version
```

If that command returns a version, you're ready to move on.


