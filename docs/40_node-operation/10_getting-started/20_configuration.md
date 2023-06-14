---
title: Configuration
sidebar_class_name: sidebarhidden
---

While there are a few steps to installing and configuring a local EOS blockchain node, it is pretty straight forward once you understand the pieces. This guide will walk you through configuring Ubuntu (or other Debian based Linux distributions), installing Antelope Leap, Contract Development Toolkit (CDT), and the EOS Foundation Network's System Contracts, then configuriong everything for a local developmance instance. The process itself only takes a few minutes, but we will explain the parts as we progress through them and point you to additional resources for other options. 

![Local Node Architecture](local_node_architecture.svg)

## The Local Node Stack
Running a local node has the following parts
* **Ubuntu** or other Debian based Linux distribution as the operating system. For development purposes this could be a Virtual Machine or even Windows Subsystem for Linux (WSL). 
* **[Antelope Leap](https://github.com/AntelopeIO/leap)** is the C++ implementation of the Antelope protocol. It includes includes multiple parts. In this guide you will learn about `nodeos`, `cleos`, & `keosd` 
    * `nodeos` is the core service daemon that runs on every Antelope node. It can be configured to process smart contracts, validate transactions, produce blocks containing valid transactions, and confirm blocks to record them on the blockchain.
    * `cleos` is a command line tool that interfaces with the REST API exposed by `nodeos`. Developers can also use `cleos` to deploy and test Antelope smart contracts.
    * `keosd` is a key manager service daemon for storing private keys and signing digital messages. It provides a secure key storage medium for keys to be encrypted at rest in the associated wallet file. `keosd` also defines a secure enclave for signing transaction created by `cleos` or a third part library.
    * Other utilities: `trace_api_util` is a command-line interface (CLI) utility that allows node operators to perform low-level tasks associated with the Trace API Plugin. 
* **[Antelope CDT](https://github.com/AntelopeIO/cdt)** is the Contract Development Toolkit. A suite of tools to facilitate C/C++ development of contracts for Antelope blockchains. 
*  **[EOS Foundation Network's System Contracts](https://github.com/eosnetworkfoundation/eos-system-contracts)** are a collection of contracts specifically designed for the EOS blockchain, which implements a lot of critical functionality that goes beyond what is provided by the base Antelope protocol, the protocol on which EOS blockchain is built on.

Antelope Leap and CDT are released as Debian (.deb) packages, so installing from release is easiest with a Ubuntu or Debian based distribution of Linux. It is also possible to build from source on other platforms, but that is beyond the scope of this guide.

## Config.ini

## Plugins

## CORS
