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

## nodeos

`nodeos` is the core service daemon that runs every EOS and Antelope node. It can be configured to process smart contracts, validate transactions, produce blocks containing valid transactions, and confirm blocks to record them on the blockchain. It is installed with the [Antelope Leap package](https://github.com/AntelopeIO/leap). You can configure it either via parameters or by customizing the `config.ini` file. Your settings will depend on usecase.

### Command Line Options

Nodeos includes a listing of all command line applications options and their usage with the `-h` or `--help` paremter. Here is the help from version 4.0.1:

```
Application Options:

Config Options for eosio::chain_plugin:
  --blocks-dir arg (="blocks")          the location of the blocks directory 
                                        (absolute path or relative to 
                                        application data dir)
  --blocks-log-stride arg               split the block log file when the head 
                                        block number is the multiple of the 
                                        stride
                                        When the stride is reached, the current
                                        block log and index will be renamed 
                                        '<blocks-retained-dir>/blocks-<start 
                                        num>-<end num>.log/index'
                                        and a new current block log and index 
                                        will be created with the most recent 
                                        block. All files following
                                        this format will be used to construct 
                                        an extended block log.
  --max-retained-block-files arg        the maximum number of blocks files to 
                                        retain so that the blocks in those 
                                        files can be queried.
                                        When the number is reached, the oldest 
                                        block file would be moved to archive 
                                        dir or deleted if the archive dir is 
                                        empty.
                                        The retained block log files should not
                                        be manipulated by users.
  --blocks-retained-dir arg             the location of the blocks retained 
                                        directory (absolute path or relative to
                                        blocks dir).
                                        If the value is empty, it is set to the
                                        value of blocks dir.
  --blocks-archive-dir arg              the location of the blocks archive 
                                        directory (absolute path or relative to
                                        blocks dir).
                                        If the value is empty, blocks files 
                                        beyond the retained limit will be 
                                        deleted.
                                        All files in the archive directory are 
                                        completely under user's control, i.e. 
                                        they won't be accessed by nodeos 
                                        anymore.
  --state-dir arg (="state")            the location of the state directory 
                                        (absolute path or relative to 
                                        application data dir)
  --protocol-features-dir arg (="protocol_features")
                                        the location of the protocol_features 
                                        directory (absolute path or relative to
                                        application config dir)
  --checkpoint arg                      Pairs of [BLOCK_NUM,BLOCK_ID] that 
                                        should be enforced as checkpoints.
  --wasm-runtime runtime (=eos-vm-jit)  Override default WASM runtime ( 
                                        "eos-vm-jit", "eos-vm")
                                        "eos-vm-jit" : A WebAssembly runtime 
                                        that compiles WebAssembly code to 
                                        native x86 code prior to execution.
                                        "eos-vm" : A WebAssembly interpreter.
                                        
  --profile-account arg                 The name of an account whose code will 
                                        be profiled
  --abi-serializer-max-time-ms arg (=15)
                                        Override default maximum ABI 
                                        serialization time allowed in ms
  --chain-state-db-size-mb arg (=1024)  Maximum size (in MiB) of the chain 
                                        state database
  --chain-state-db-guard-size-mb arg (=128)
                                        Safely shut down node when free space 
                                        remaining in the chain state database 
                                        drops below this size (in MiB).
  --signature-cpu-billable-pct arg (=50)
                                        Percentage of actual signature recovery
                                        cpu to bill. Whole number percentages, 
                                        e.g. 50 for 50%
  --chain-threads arg (=2)              Number of worker threads in controller 
                                        thread pool
  --contracts-console                   print contract's output to console
  --deep-mind                           print deeper information about chain 
                                        operations
  --actor-whitelist arg                 Account added to actor whitelist (may 
                                        specify multiple times)
  --actor-blacklist arg                 Account added to actor blacklist (may 
                                        specify multiple times)
  --contract-whitelist arg              Contract account added to contract 
                                        whitelist (may specify multiple times)
  --contract-blacklist arg              Contract account added to contract 
                                        blacklist (may specify multiple times)
  --action-blacklist arg                Action (in the form code::action) added
                                        to action blacklist (may specify 
                                        multiple times)
  --key-blacklist arg                   Public key added to blacklist of keys 
                                        that should not be included in 
                                        authorities (may specify multiple 
                                        times)
  --sender-bypass-whiteblacklist arg    Deferred transactions sent by accounts 
                                        in this list do not have any of the 
                                        subjective whitelist/blacklist checks 
                                        applied to them (may specify multiple 
                                        times)
  --read-mode arg (=head)               Database read mode ("head", 
                                        "irreversible", "speculative").
                                        In "head" mode: database contains state
                                        changes up to the head block; 
                                        transactions received by the node are 
                                        relayed if valid.
                                        In "irreversible" mode: database 
                                        contains state changes up to the last 
                                        irreversible block; transactions 
                                        received via the P2P network are not 
                                        relayed and transactions cannot be 
                                        pushed via the chain API.
                                        In "speculative" mode: (DEPRECATED: 
                                        head mode recommended) database 
                                        contains state changes by transactions 
                                        in the blockchain up to the head block 
                                        as well as some transactions not yet 
                                        included in the blockchain; 
                                        transactions received by the node are 
                                        relayed if valid.
                                        
  --api-accept-transactions arg (=1)    Allow API transactions to be evaluated 
                                        and relayed if valid.
  --validation-mode arg (=full)         Chain validation mode ("full" or 
                                        "light").
                                        In "full" mode all incoming blocks will
                                        be fully validated.
                                        In "light" mode all incoming blocks 
                                        headers will be fully validated; 
                                        transactions in those validated blocks 
                                        will be trusted 
                                        
  --disable-ram-billing-notify-checks   Disable the check which subjectively 
                                        fails a transaction if a contract bills
                                        more RAM to another account within the 
                                        context of a notification handler (i.e.
                                        when the receiver is not the code of 
                                        the action).
  --maximum-variable-signature-length arg (=16384)
                                        Subjectively limit the maximum length 
                                        of variable components in a variable 
                                        legnth signature to this size in bytes
  --trusted-producer arg                Indicate a producer whose blocks 
                                        headers signed by it will be fully 
                                        validated, but transactions in those 
                                        validated blocks will be trusted.
  --database-map-mode arg (=mapped)     Database map mode ("mapped", "heap", or
                                        "locked").
                                        In "mapped" mode database is memory 
                                        mapped as a file.
                                        In "heap" mode database is preloaded in
                                        to swappable memory and will use huge 
                                        pages if available.
                                        In "locked" mode database is preloaded,
                                        locked in to memory, and will use huge 
                                        pages if available.
                                        
  --eos-vm-oc-cache-size-mb arg (=1024) Maximum size (in MiB) of the EOS VM OC 
                                        code cache
  --eos-vm-oc-compile-threads arg (=1)  Number of threads to use for EOS VM OC 
                                        tier-up
  --eos-vm-oc-enable                    Enable EOS VM OC tier-up runtime
  --enable-account-queries arg (=0)     enable queries to find accounts by 
                                        various metadata.
  --max-nonprivileged-inline-action-size arg (=4096)
                                        maximum allowed size (in bytes) of an 
                                        inline action for a nonprivileged 
                                        account
  --transaction-retry-max-storage-size-gb arg
                                        Maximum size (in GiB) allowed to be 
                                        allocated for the Transaction Retry 
                                        feature. Setting above 0 enables this 
                                        feature.
  --transaction-retry-interval-sec arg (=20)
                                        How often, in seconds, to resend an 
                                        incoming transaction to network if not 
                                        seen in a block.
  --transaction-retry-max-expiration-sec arg (=120)
                                        Maximum allowed transaction expiration 
                                        for retry transactions, will retry 
                                        transactions up to this value.
  --transaction-finality-status-max-storage-size-gb arg
                                        Maximum size (in GiB) allowed to be 
                                        allocated for the Transaction Finality 
                                        Status feature. Setting above 0 enables
                                        this feature.
  --transaction-finality-status-success-duration-sec arg (=180)
                                        Duration (in seconds) a successful 
                                        transaction's Finality Status will 
                                        remain available from being first 
                                        identified.
  --transaction-finality-status-failure-duration-sec arg (=180)
                                        Duration (in seconds) a failed 
                                        transaction's Finality Status will 
                                        remain available from being first 
                                        identified.
  --integrity-hash-on-start             Log the state integrity hash on startup
  --integrity-hash-on-stop              Log the state integrity hash on 
                                        shutdown
  --block-log-retain-blocks arg         If set to greater than 0, periodically 
                                        prune the block log to store only 
                                        configured number of most recent 
                                        blocks.
                                        If set to 0, no blocks are be written 
                                        to the block log; block log file is 
                                        removed after startup.

Command Line Options for eosio::chain_plugin:
  --genesis-json arg                    File to read Genesis State from
  --genesis-timestamp arg               override the initial timestamp in the 
                                        Genesis State file
  --print-genesis-json                  extract genesis_state from blocks.log 
                                        as JSON, print to console, and exit
  --extract-genesis-json arg            extract genesis_state from blocks.log 
                                        as JSON, write into specified file, and
                                        exit
  --print-build-info                    print build environment information to 
                                        console as JSON and exit
  --extract-build-info arg              extract build environment information 
                                        as JSON, write into specified file, and
                                        exit
  --force-all-checks                    do not skip any validation checks while
                                        replaying blocks (useful for replaying 
                                        blocks from untrusted source)
  --disable-replay-opts                 disable optimizations that specifically
                                        target replay
  --replay-blockchain                   clear chain state database and replay 
                                        all blocks
  --hard-replay-blockchain              clear chain state database, recover as 
                                        many blocks as possible from the block 
                                        log, and then replay those blocks
  --delete-all-blocks                   clear chain state database and block 
                                        log
  --truncate-at-block arg (=0)          stop hard replay / block log recovery 
                                        at this block number (if set to 
                                        non-zero number)
  --terminate-at-block arg (=0)         terminate after reaching this block 
                                        number (if set to a non-zero number)
  --snapshot arg                        File to read Snapshot State from

Config Options for eosio::http_plugin:
  --unix-socket-path arg                The filename (relative to data-dir) to 
                                        create a unix socket for HTTP RPC; set 
                                        blank to disable.
  --http-server-address arg (=127.0.0.1:8888)
                                        The local IP and port to listen for 
                                        incoming http connections; set blank to
                                        disable.
  --access-control-allow-origin arg     Specify the Access-Control-Allow-Origin
                                        to be returned on each request
  --access-control-allow-headers arg    Specify the Access-Control-Allow-Header
                                        s to be returned on each request
  --access-control-max-age arg          Specify the Access-Control-Max-Age to 
                                        be returned on each request.
  --access-control-allow-credentials    Specify if Access-Control-Allow-Credent
                                        ials: true should be returned on each 
                                        request.
  --max-body-size arg (=2097152)        The maximum body size in bytes allowed 
                                        for incoming RPC requests
  --http-max-bytes-in-flight-mb arg (=500)
                                        Maximum size in megabytes http_plugin 
                                        should use for processing http 
                                        requests. -1 for unlimited. 429 error 
                                        response when exceeded.
  --http-max-in-flight-requests arg (=-1)
                                        Maximum number of requests http_plugin 
                                        should use for processing http 
                                        requests. 429 error response when 
                                        exceeded.
  --http-max-response-time-ms arg (=30) Maximum time for processing a request, 
                                        -1 for unlimited
  --verbose-http-errors                 Append the error log to HTTP responses
  --http-validate-host arg (=1)         If set to false, then any incoming 
                                        "Host" header is considered valid
  --http-alias arg                      Additionaly acceptable values for the 
                                        "Host" header of incoming HTTP 
                                        requests, can be specified multiple 
                                        times.  Includes http/s_server_address 
                                        by default.
  --http-threads arg (=2)               Number of worker threads in http thread
                                        pool
  --http-keep-alive arg (=1)            If set to false, do not keep HTTP 
                                        connections alive, even if client 
                                        requests.

Config Options for eosio::net_plugin:
  --p2p-listen-endpoint arg (=0.0.0.0:9876)
                                        The actual host:port used to listen for
                                        incoming p2p connections.
  --p2p-server-address arg              An externally accessible host:port for 
                                        identifying this node. Defaults to 
                                        p2p-listen-endpoint.
  --p2p-peer-address arg                The public endpoint of a peer node to 
                                        connect to. Use multiple 
                                        p2p-peer-address options as needed to 
                                        compose a network.
                                          Syntax: host:port[:<trx>|<blk>]
                                          The optional 'trx' and 'blk' 
                                        indicates to node that only 
                                        transactions 'trx' or blocks 'blk' 
                                        should be sent.  Examples:
                                            p2p.eos.io:9876
                                            p2p.trx.eos.io:9876:trx
                                            p2p.blk.eos.io:9876:blk
                                        
  --p2p-max-nodes-per-host arg (=1)     Maximum number of client nodes from any
                                        single IP address
  --p2p-accept-transactions arg (=1)    Allow transactions received over p2p 
                                        network to be evaluated and relayed if 
                                        valid.
  --p2p-auto-bp-peer arg                The account and public p2p endpoint of 
                                        a block producer node to automatically 
                                        connect to when the it is in producer 
                                        schedule proximity
                                        .   Syntax: account,host:port
                                           Example,
                                             eosproducer1,p2p.eos.io:9876
                                             eosproducer2,p2p.trx.eos.io:9876:t
                                        rx
                                             eosproducer3,p2p.blk.eos.io:9876:b
                                        lk
                                        
  --agent-name arg (=EOS Test Agent)    The name supplied to identify this node
                                        amongst the peers.
  --allowed-connection arg (=any)       Can be 'any' or 'producers' or 
                                        'specified' or 'none'. If 'specified', 
                                        peer-key must be specified at least 
                                        once. If only 'producers', peer-key is 
                                        not required. 'producers' and 
                                        'specified' may be combined.
  --peer-key arg                        Optional public key of peer allowed to 
                                        connect.  May be used multiple times.
  --peer-private-key arg                Tuple of [PublicKey, WIF private key] 
                                        (may specify multiple times)
  --max-clients arg (=25)               Maximum number of clients from which 
                                        connections are accepted, use 0 for no 
                                        limit
  --connection-cleanup-period arg (=30) number of seconds to wait before 
                                        cleaning up dead connections
  --max-cleanup-time-msec arg (=10)     max connection cleanup time per cleanup
                                        call in milliseconds
  --p2p-dedup-cache-expire-time-sec arg (=10)
                                        Maximum time to track transaction for 
                                        duplicate optimization
  --net-threads arg (=4)                Number of worker threads in net_plugin 
                                        thread pool
  --sync-fetch-span arg (=100)          number of blocks to retrieve in a chunk
                                        from any individual peer during 
                                        synchronization
  --use-socket-read-watermark arg (=0)  Enable experimental socket read 
                                        watermark optimization
  --peer-log-format arg (=["${_name}" - ${_cid} ${_ip}:${_port}] )
                                        The string used to format peers when 
                                        logging messages about them.  Variables
                                        are escaped with ${<variable name>}.
                                        Available Variables:
                                           _name  self-reported name
                                        
                                           _cid   assigned connection id
                                        
                                           _id    self-reported ID (64 hex 
                                                  characters)
                                        
                                           _sid   first 8 characters of 
                                                  _peer.id
                                        
                                           _ip    remote IP address of peer
                                        
                                           _port  remote port number of peer
                                        
                                           _lip   local IP address connected to
                                                  peer
                                        
                                           _lport local port number connected 
                                                  to peer
                                        
                                        
  --p2p-keepalive-interval-ms arg (=10000)
                                        peer heartbeat keepalive message 
                                        interval in milliseconds

Config Options for eosio::producer_plugin:

  -e [ --enable-stale-production ]      Enable block production, even if the 
                                        chain is stale.
  -x [ --pause-on-startup ]             Start this node in a state where 
                                        production is paused
  --max-transaction-time arg (=30)      Limits the maximum time (in 
                                        milliseconds) that is allowed a pushed 
                                        transaction's code to execute before 
                                        being considered invalid
  --max-irreversible-block-age arg (=-1)
                                        Limits the maximum age (in seconds) of 
                                        the DPOS Irreversible Block for a chain
                                        this node will produce blocks on (use 
                                        negative value to indicate unlimited)
  -p [ --producer-name ] arg            ID of producer controlled by this node 
                                        (e.g. inita; may specify multiple 
                                        times)
  --signature-provider arg (=EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3)
                                        Key=Value pairs in the form 
                                        <public-key>=<provider-spec>
                                        Where:
                                           <public-key>    is a string form of 
                                                           a vaild EOSIO public
                                                           key
                                        
                                           <provider-spec> is a string in the 
                                                           form <provider-type>
                                                           :<data>
                                        
                                           <provider-type> is KEY, KEOSD, or SE
                                        
                                           KEY:<data>      is a string form of 
                                                           a valid EOSIO 
                                                           private key which 
                                                           maps to the provided
                                                           public key
                                        
                                           KEOSD:<data>    is the URL where 
                                                           keosd is available 
                                                           and the approptiate 
                                                           wallet(s) are 
                                                           unlocked
                                        
                                        
  --greylist-account arg                account that can not access to extended
                                        CPU/NET virtual resources
  --greylist-limit arg (=1000)          Limit (between 1 and 1000) on the 
                                        multiple that CPU/NET virtual resources
                                        can extend during low usage (only 
                                        enforced subjectively; use 1000 to not 
                                        enforce any limit)
  --produce-time-offset-us arg (=0)     Offset of non last block producing time
                                        in microseconds. Valid range 0 .. 
                                        -block_time_interval.
  --last-block-time-offset-us arg (=-200000)
                                        Offset of last block producing time in 
                                        microseconds. Valid range 0 .. 
                                        -block_time_interval.
  --cpu-effort-percent arg (=80)        Percentage of cpu block production time
                                        used to produce block. Whole number 
                                        percentages, e.g. 80 for 80%
  --last-block-cpu-effort-percent arg (=80)
                                        Percentage of cpu block production time
                                        used to produce last block. Whole 
                                        number percentages, e.g. 80 for 80%
  --max-block-cpu-usage-threshold-us arg (=5000)
                                        Threshold of CPU block production to 
                                        consider block full; when within 
                                        threshold of max-block-cpu-usage block 
                                        can be produced immediately
  --max-block-net-usage-threshold-bytes arg (=1024)
                                        Threshold of NET block production to 
                                        consider block full; when within 
                                        threshold of max-block-net-usage block 
                                        can be produced immediately
  --max-scheduled-transaction-time-per-block-ms arg (=100)
                                        Maximum wall-clock time, in 
                                        milliseconds, spent retiring scheduled 
                                        transactions (and incoming transactions
                                        according to incoming-defer-ratio) in 
                                        any block before returning to normal 
                                        transaction processing.
  --subjective-cpu-leeway-us arg (=31000)
                                        Time in microseconds allowed for a 
                                        transaction that starts with 
                                        insufficient CPU quota to complete and 
                                        cover its CPU usage.
  --subjective-account-max-failures arg (=3)
                                        Sets the maximum amount of failures 
                                        that are allowed for a given account 
                                        per window size.
  --subjective-account-max-failures-window-size arg (=1)
                                        Sets the window size in number of 
                                        blocks for subjective-account-max-failu
                                        res.
  --subjective-account-decay-time-minutes arg (=1440)
                                        Sets the time to return full subjective
                                        cpu for accounts
  --incoming-defer-ratio arg (=1)       ratio between incoming transactions and
                                        deferred transactions when both are 
                                        queued for execution
  --incoming-transaction-queue-size-mb arg (=1024)
                                        Maximum size (in MiB) of the incoming 
                                        transaction queue. Exceeding this value
                                        will subjectively drop transaction with
                                        resource exhaustion.
  --disable-subjective-billing arg (=1) Disable subjective CPU billing for 
                                        API/P2P transactions
  --disable-subjective-account-billing arg
                                        Account which is excluded from 
                                        subjective CPU billing
  --disable-subjective-p2p-billing arg (=1)
                                        Disable subjective CPU billing for P2P 
                                        transactions
  --disable-subjective-api-billing arg (=1)
                                        Disable subjective CPU billing for API 
                                        transactions
  --producer-threads arg (=2)           Number of worker threads in producer 
                                        thread pool
  --snapshots-dir arg (="snapshots")    the location of the snapshots directory
                                        (absolute path or relative to 
                                        application data dir)
  --read-only-threads arg               Number of worker threads in read-only 
                                        execution thread pool. Max 8.
  --read-only-write-window-time-us arg (=200000)
                                        Time in microseconds the write window 
                                        lasts.
  --read-only-read-window-time-us arg (=60000)
                                        Time in microseconds the read window 
                                        lasts.

Config Options for eosio::prometheus_plugin:
  --prometheus-exporter-address arg (=127.0.0.1:9101)
                                        The local IP and port to listen for 
                                        incoming prometheus metrics http 
                                        request.

Config Options for eosio::resource_monitor_plugin:
  --resource-monitor-interval-seconds arg (=2)
                                        Time in seconds between two consecutive
                                        checks of resource usage. Should be 
                                        between 1 and 300
  --resource-monitor-space-threshold arg (=90)
                                        Threshold in terms of percentage of 
                                        used space vs total space. If used 
                                        space is above (threshold - 5%), a 
                                        warning is generated. Unless 
                                        resource-monitor-not-shutdown-on-thresh
                                        old-exceeded is enabled, a graceful 
                                        shutdown is initiated if used space is 
                                        above the threshold. The value should 
                                        be between 6 and 99
  --resource-monitor-space-absolute-gb arg
                                        Absolute threshold in gibibytes of 
                                        remaining space; applied to each 
                                        monitored directory. If remaining space
                                        is less than value for any monitored 
                                        directories then threshold is 
                                        considered exceeded.Overrides 
                                        resource-monitor-space-threshold value.
  --resource-monitor-not-shutdown-on-threshold-exceeded 
                                        Used to indicate nodeos will not 
                                        shutdown when threshold is exceeded.
  --resource-monitor-warning-interval arg (=30)
                                        Number of resource monitor intervals 
                                        between two consecutive warnings when 
                                        the threshold is hit. Should be between
                                        1 and 450

Config Options for eosio::signature_provider_plugin:
  --keosd-provider-timeout arg (=5)     Limits the maximum time (in 
                                        milliseconds) that is allowed for 
                                        sending requests to a keosd provider 
                                        for signing

Config Options for eosio::state_history_plugin:
  --state-history-dir arg (="state-history")
                                        the location of the state-history 
                                        directory (absolute path or relative to
                                        application data dir)
  --state-history-retained-dir arg      the location of the state history 
                                        retained directory (absolute path or 
                                        relative to state-history dir).
  --state-history-archive-dir arg       the location of the state history 
                                        archive directory (absolute path or 
                                        relative to state-history dir).
                                        If the value is empty string, blocks 
                                        files beyond the retained limit will be
                                        deleted.
                                        All files in the archive directory are 
                                        completely under user's control, i.e. 
                                        they won't be accessed by nodeos 
                                        anymore.
  --state-history-stride arg            split the state history log files when 
                                        the block number is the multiple of the
                                        stride
                                        When the stride is reached, the current
                                        history log and index will be renamed 
                                        '*-history-<start num>-<end 
                                        num>.log/index'
                                        and a new current history log and index
                                        will be created with the most recent 
                                        blocks. All files following
                                        this format will be used to construct 
                                        an extended history log.
  --max-retained-history-files arg      the maximum number of history file 
                                        groups to retain so that the blocks in 
                                        those files can be queried.
                                        When the number is reached, the oldest 
                                        history file would be moved to archive 
                                        dir or deleted if the archive dir is 
                                        empty.
                                        The retained history log files should 
                                        not be manipulated by users.
  --trace-history                       enable trace history
  --chain-state-history                 enable chain state history
  --state-history-endpoint arg (=127.0.0.1:8080)
                                        the endpoint upon which to listen for 
                                        incoming connections. Caution: only 
                                        expose this port to your internal 
                                        network.
  --state-history-unix-socket-path arg  the path (relative to data-dir) to 
                                        create a unix socket upon which to 
                                        listen for incoming connections.
  --trace-history-debug-mode            enable debug mode for trace history
  --state-history-log-retain-blocks arg if set, periodically prune the state 
                                        history files to store only configured 
                                        number of most recent blocks

Command Line Options for eosio::state_history_plugin:
  --delete-state-history                clear state history files

Config Options for eosio::trace_api_plugin:
  --trace-dir arg (="traces")           the location of the trace directory 
                                        (absolute path or relative to 
                                        application data dir)
  --trace-slice-stride arg (=10000)     the number of blocks each "slice" of 
                                        trace data will contain on the 
                                        filesystem
  --trace-minimum-irreversible-history-blocks arg (=-1)
                                        Number of blocks to ensure are kept 
                                        past LIB for retrieval before "slice" 
                                        files can be automatically removed.
                                        A value of -1 indicates that automatic 
                                        removal of "slice" files will be turned
                                        off.
  --trace-minimum-uncompressed-irreversible-history-blocks arg (=-1)
                                        Number of blocks to ensure are 
                                        uncompressed past LIB. Compressed 
                                        "slice" files are still accessible but 
                                        may carry a performance loss on 
                                        retrieval
                                        A value of -1 indicates that automatic 
                                        compression of "slice" files will be 
                                        turned off.
  --trace-rpc-abi arg                   ABIs used when decoding trace RPC 
                                        responses.
                                        There must be at least one ABI 
                                        specified OR the flag trace-no-abis 
                                        must be used.
                                        ABIs are specified as "Key=Value" pairs
                                        in the form <account-name>=<abi-def>
                                        Where <abi-def> can be:
                                           an absolute path to a file 
                                        containing a valid JSON-encoded ABI
                                           a relative path from `data-dir` to a
                                        file containing a valid JSON-encoded 
                                        ABI
                                        
  --trace-no-abis                       Use to indicate that the RPC responses 
                                        will not use ABIs.
                                        Failure to specify this option when 
                                        there are no trace-rpc-abi 
                                        configuations will result in an Error.
                                        This option is mutually exclusive with 
                                        trace-rpc-api

Application Config Options:
  --plugin arg                          Plugin(s) to enable, may be specified 
                                        multiple times

Application Command Line Options:
  -h [ --help ]                         Print this help message and exit.
  -v [ --version ]                      Print version information.
  --full-version                        Print full version information.
  --print-default-config                Print default configuration template
  -d [ --data-dir ] arg                 Directory containing program runtime 
                                        data
  --config-dir arg                      Directory containing configuration 
                                        files such as config.ini
  -c [ --config ] arg (=config.ini)     Configuration file name relative to 
                                        config-dir
  -l [ --logconf ] arg (=logging.json)  Logging configuration file name/path 
                                        for library users
```

### config.ini
Nodeos looks for the `config.ini` in the default data directory of `~/.local/share/eosio/nodeos/config/`, unless you specify a custom data directory via the `--data-dir=` parameter, or use `--config-dir=` / `--config=` to further customize the path. If the `config.ini` doesn't exist, then nodeos will create a new default one containing a list of options with short descriptions of each. Here is the default config.ini from version 4.0.1:

```
# the location of the blocks directory (absolute path or relative to application data dir) (eosio::chain_plugin)
# blocks-dir = "blocks"

# split the block log file when the head block number is the multiple of the stride
# When the stride is reached, the current block log and index will be renamed '<blocks-retained-dir>/blocks-<start num>-<end num>.log/index'
# and a new current block log and index will be created with the most recent block. All files following
# this format will be used to construct an extended block log. (eosio::chain_plugin)
# blocks-log-stride = 

# the maximum number of blocks files to retain so that the blocks in those files can be queried.
# When the number is reached, the oldest block file would be moved to archive dir or deleted if the archive dir is empty.
# The retained block log files should not be manipulated by users. (eosio::chain_plugin)
# max-retained-block-files = 

# the location of the blocks retained directory (absolute path or relative to blocks dir).
# If the value is empty, it is set to the value of blocks dir. (eosio::chain_plugin)
# blocks-retained-dir = 

# the location of the blocks archive directory (absolute path or relative to blocks dir).
# If the value is empty, blocks files beyond the retained limit will be deleted.
# All files in the archive directory are completely under user's control, i.e. they won't be accessed by nodeos anymore. (eosio::chain_plugin)
# blocks-archive-dir = 

# the location of the state directory (absolute path or relative to application data dir) (eosio::chain_plugin)
# state-dir = "state"

# the location of the protocol_features directory (absolute path or relative to application config dir) (eosio::chain_plugin)
# protocol-features-dir = "protocol_features"

# Pairs of [BLOCK_NUM,BLOCK_ID] that should be enforced as checkpoints. (eosio::chain_plugin)
# checkpoint = 

# Override default WASM runtime ( "eos-vm-jit", "eos-vm")
# "eos-vm-jit" : A WebAssembly runtime that compiles WebAssembly code to native x86 code prior to execution.
# "eos-vm" : A WebAssembly interpreter.
#  (eosio::chain_plugin)
# wasm-runtime = eos-vm-jit

# The name of an account whose code will be profiled (eosio::chain_plugin)
# profile-account = 

# Override default maximum ABI serialization time allowed in ms (eosio::chain_plugin)
# abi-serializer-max-time-ms = 15

# Maximum size (in MiB) of the chain state database (eosio::chain_plugin)
# chain-state-db-size-mb = 1024

# Safely shut down node when free space remaining in the chain state database drops below this size (in MiB). (eosio::chain_plugin)
# chain-state-db-guard-size-mb = 128

# Percentage of actual signature recovery cpu to bill. Whole number percentages, e.g. 50 for 50% (eosio::chain_plugin)
# signature-cpu-billable-pct = 50

# Number of worker threads in controller thread pool (eosio::chain_plugin)
# chain-threads = 2

# print contract's output to console (eosio::chain_plugin)
# contracts-console = false

# print deeper information about chain operations (eosio::chain_plugin)
# deep-mind = false

# Account added to actor whitelist (may specify multiple times) (eosio::chain_plugin)
# actor-whitelist = 

# Account added to actor blacklist (may specify multiple times) (eosio::chain_plugin)
# actor-blacklist = 

# Contract account added to contract whitelist (may specify multiple times) (eosio::chain_plugin)
# contract-whitelist = 

# Contract account added to contract blacklist (may specify multiple times) (eosio::chain_plugin)
# contract-blacklist = 

# Action (in the form code::action) added to action blacklist (may specify multiple times) (eosio::chain_plugin)
# action-blacklist = 

# Public key added to blacklist of keys that should not be included in authorities (may specify multiple times) (eosio::chain_plugin)
# key-blacklist = 

# Deferred transactions sent by accounts in this list do not have any of the subjective whitelist/blacklist checks applied to them (may specify multiple times) (eosio::chain_plugin)
# sender-bypass-whiteblacklist = 

# Database read mode ("head", "irreversible", "speculative").
# In "head" mode: database contains state changes up to the head block; transactions received by the node are relayed if valid.
# In "irreversible" mode: database contains state changes up to the last irreversible block; transactions received via the P2P network are not relayed and transactions cannot be pushed via the chain API.
# In "speculative" mode: (DEPRECATED: head mode recommended) database contains state changes by transactions in the blockchain up to the head block as well as some transactions not yet included in the blockchain; transactions received by the node are relayed if valid.
#  (eosio::chain_plugin)
# read-mode = head

# Allow API transactions to be evaluated and relayed if valid. (eosio::chain_plugin)
# api-accept-transactions = true

# Chain validation mode ("full" or "light").
# In "full" mode all incoming blocks will be fully validated.
# In "light" mode all incoming blocks headers will be fully validated; transactions in those validated blocks will be trusted 
#  (eosio::chain_plugin)
# validation-mode = full

# Disable the check which subjectively fails a transaction if a contract bills more RAM to another account within the context of a notification handler (i.e. when the receiver is not the code of the action). (eosio::chain_plugin)
# disable-ram-billing-notify-checks = false

# Subjectively limit the maximum length of variable components in a variable legnth signature to this size in bytes (eosio::chain_plugin)
# maximum-variable-signature-length = 16384

# Indicate a producer whose blocks headers signed by it will be fully validated, but transactions in those validated blocks will be trusted. (eosio::chain_plugin)
# trusted-producer = 

# Database map mode ("mapped", "heap", or "locked").
# In "mapped" mode database is memory mapped as a file.
# In "heap" mode database is preloaded in to swappable memory and will use huge pages if available.
# In "locked" mode database is preloaded, locked in to memory, and will use huge pages if available.
#  (eosio::chain_plugin)
# database-map-mode = mapped

# Maximum size (in MiB) of the EOS VM OC code cache (eosio::chain_plugin)
# eos-vm-oc-cache-size-mb = 1024

# Number of threads to use for EOS VM OC tier-up (eosio::chain_plugin)
# eos-vm-oc-compile-threads = 1

# Enable EOS VM OC tier-up runtime (eosio::chain_plugin)
# eos-vm-oc-enable = false

# enable queries to find accounts by various metadata. (eosio::chain_plugin)
# enable-account-queries = false

# maximum allowed size (in bytes) of an inline action for a nonprivileged account (eosio::chain_plugin)
# max-nonprivileged-inline-action-size = 4096

# Maximum size (in GiB) allowed to be allocated for the Transaction Retry feature. Setting above 0 enables this feature. (eosio::chain_plugin)
# transaction-retry-max-storage-size-gb = 

# How often, in seconds, to resend an incoming transaction to network if not seen in a block. (eosio::chain_plugin)
# transaction-retry-interval-sec = 20

# Maximum allowed transaction expiration for retry transactions, will retry transactions up to this value. (eosio::chain_plugin)
# transaction-retry-max-expiration-sec = 120

# Maximum size (in GiB) allowed to be allocated for the Transaction Finality Status feature. Setting above 0 enables this feature. (eosio::chain_plugin)
# transaction-finality-status-max-storage-size-gb = 

# Duration (in seconds) a successful transaction's Finality Status will remain available from being first identified. (eosio::chain_plugin)
# transaction-finality-status-success-duration-sec = 180

# Duration (in seconds) a failed transaction's Finality Status will remain available from being first identified. (eosio::chain_plugin)
# transaction-finality-status-failure-duration-sec = 180

# Log the state integrity hash on startup (eosio::chain_plugin)
# integrity-hash-on-start = false

# Log the state integrity hash on shutdown (eosio::chain_plugin)
# integrity-hash-on-stop = false

# If set to greater than 0, periodically prune the block log to store only configured number of most recent blocks.
# If set to 0, no blocks are be written to the block log; block log file is removed after startup. (eosio::chain_plugin)
# block-log-retain-blocks = 

# The filename (relative to data-dir) to create a unix socket for HTTP RPC; set blank to disable. (eosio::http_plugin)
# unix-socket-path = 

# The local IP and port to listen for incoming http connections; set blank to disable. (eosio::http_plugin)
# http-server-address = 127.0.0.1:8888

# Specify the Access-Control-Allow-Origin to be returned on each request (eosio::http_plugin)
# access-control-allow-origin = 

# Specify the Access-Control-Allow-Headers to be returned on each request (eosio::http_plugin)
# access-control-allow-headers = 

# Specify the Access-Control-Max-Age to be returned on each request. (eosio::http_plugin)
# access-control-max-age = 

# Specify if Access-Control-Allow-Credentials: true should be returned on each request. (eosio::http_plugin)
# access-control-allow-credentials = false

# The maximum body size in bytes allowed for incoming RPC requests (eosio::http_plugin)
# max-body-size = 2097152

# Maximum size in megabytes http_plugin should use for processing http requests. -1 for unlimited. 429 error response when exceeded. (eosio::http_plugin)
# http-max-bytes-in-flight-mb = 500

# Maximum number of requests http_plugin should use for processing http requests. 429 error response when exceeded. (eosio::http_plugin)
# http-max-in-flight-requests = -1

# Maximum time for processing a request, -1 for unlimited (eosio::http_plugin)
# http-max-response-time-ms = 30

# Append the error log to HTTP responses (eosio::http_plugin)
# verbose-http-errors = false

# If set to false, then any incoming "Host" header is considered valid (eosio::http_plugin)
# http-validate-host = true

# Additionaly acceptable values for the "Host" header of incoming HTTP requests, can be specified multiple times.  Includes http/s_server_address by default. (eosio::http_plugin)
# http-alias = 

# Number of worker threads in http thread pool (eosio::http_plugin)
# http-threads = 2

# If set to false, do not keep HTTP connections alive, even if client requests. (eosio::http_plugin)
# http-keep-alive = true

# The actual host:port used to listen for incoming p2p connections. (eosio::net_plugin)
# p2p-listen-endpoint = 0.0.0.0:9876

# An externally accessible host:port for identifying this node. Defaults to p2p-listen-endpoint. (eosio::net_plugin)
# p2p-server-address = 

# The public endpoint of a peer node to connect to. Use multiple p2p-peer-address options as needed to compose a network.
#   Syntax: host:port[:<trx>|<blk>]
#   The optional 'trx' and 'blk' indicates to node that only transactions 'trx' or blocks 'blk' should be sent.  Examples:
#     p2p.eos.io:9876
#     p2p.trx.eos.io:9876:trx
#     p2p.blk.eos.io:9876:blk
#  (eosio::net_plugin)
# p2p-peer-address = 

# Maximum number of client nodes from any single IP address (eosio::net_plugin)
# p2p-max-nodes-per-host = 1

# Allow transactions received over p2p network to be evaluated and relayed if valid. (eosio::net_plugin)
# p2p-accept-transactions = true

# The account and public p2p endpoint of a block producer node to automatically connect to when the it is in producer schedule proximity
# .   Syntax: account,host:port
#    Example,
#      eosproducer1,p2p.eos.io:9876
#      eosproducer2,p2p.trx.eos.io:9876:trx
#      eosproducer3,p2p.blk.eos.io:9876:blk
#  (eosio::net_plugin)
# p2p-auto-bp-peer = 

# The name supplied to identify this node amongst the peers. (eosio::net_plugin)
# agent-name = EOS Test Agent

# Can be 'any' or 'producers' or 'specified' or 'none'. If 'specified', peer-key must be specified at least once. If only 'producers', peer-key is not required. 'producers' and 'specified' may be combined. (eosio::net_plugin)
# allowed-connection = any

# Optional public key of peer allowed to connect.  May be used multiple times. (eosio::net_plugin)
# peer-key = 

# Tuple of [PublicKey, WIF private key] (may specify multiple times) (eosio::net_plugin)
# peer-private-key = 

# Maximum number of clients from which connections are accepted, use 0 for no limit (eosio::net_plugin)
# max-clients = 25

# number of seconds to wait before cleaning up dead connections (eosio::net_plugin)
# connection-cleanup-period = 30

# max connection cleanup time per cleanup call in milliseconds (eosio::net_plugin)
# max-cleanup-time-msec = 10

# Maximum time to track transaction for duplicate optimization (eosio::net_plugin)
# p2p-dedup-cache-expire-time-sec = 10

# Number of worker threads in net_plugin thread pool (eosio::net_plugin)
# net-threads = 4

# number of blocks to retrieve in a chunk from any individual peer during synchronization (eosio::net_plugin)
# sync-fetch-span = 100

# Enable experimental socket read watermark optimization (eosio::net_plugin)
# use-socket-read-watermark = false

# The string used to format peers when logging messages about them.  Variables are escaped with ${<variable name>}.
# Available Variables:
#    _name  	self-reported name
# 
#    _cid   	assigned connection id
# 
#    _id    	self-reported ID (64 hex characters)
# 
#    _sid   	first 8 characters of _peer.id
# 
#    _ip    	remote IP address of peer
# 
#    _port  	remote port number of peer
# 
#    _lip   	local IP address connected to peer
# 
#    _lport 	local port number connected to peer
# 
#  (eosio::net_plugin)
# peer-log-format = ["${_name}" - ${_cid} ${_ip}:${_port}] 

# peer heartbeat keepalive message interval in milliseconds (eosio::net_plugin)
# p2p-keepalive-interval-ms = 10000

# Enable block production, even if the chain is stale. (eosio::producer_plugin)
# enable-stale-production = false

# Start this node in a state where production is paused (eosio::producer_plugin)
# pause-on-startup = false

# Limits the maximum time (in milliseconds) that is allowed a pushed transaction's code to execute before being considered invalid (eosio::producer_plugin)
# max-transaction-time = 30

# Limits the maximum age (in seconds) of the DPOS Irreversible Block for a chain this node will produce blocks on (use negative value to indicate unlimited) (eosio::producer_plugin)
# max-irreversible-block-age = -1

# ID of producer controlled by this node (e.g. inita; may specify multiple times) (eosio::producer_plugin)
# producer-name = 

# Key=Value pairs in the form <public-key>=<provider-spec>
# Where:
#    <public-key>    	is a string form of a vaild EOSIO public key
# 
#    <provider-spec> 	is a string in the form <provider-type>:<data>
# 
#    <provider-type> 	is KEY, KEOSD, or SE
# 
#    KEY:<data>      	is a string form of a valid EOSIO private key which maps to the provided public key
# 
#    KEOSD:<data>    	is the URL where keosd is available and the approptiate wallet(s) are unlocked
# 
#  (eosio::producer_plugin)
# signature-provider = EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

# account that can not access to extended CPU/NET virtual resources (eosio::producer_plugin)
# greylist-account = 

# Limit (between 1 and 1000) on the multiple that CPU/NET virtual resources can extend during low usage (only enforced subjectively; use 1000 to not enforce any limit) (eosio::producer_plugin)
# greylist-limit = 1000

# Offset of non last block producing time in microseconds. Valid range 0 .. -block_time_interval. (eosio::producer_plugin)
# produce-time-offset-us = 0

# Offset of last block producing time in microseconds. Valid range 0 .. -block_time_interval. (eosio::producer_plugin)
# last-block-time-offset-us = -200000

# Percentage of cpu block production time used to produce block. Whole number percentages, e.g. 80 for 80% (eosio::producer_plugin)
# cpu-effort-percent = 80

# Percentage of cpu block production time used to produce last block. Whole number percentages, e.g. 80 for 80% (eosio::producer_plugin)
# last-block-cpu-effort-percent = 80

# Threshold of CPU block production to consider block full; when within threshold of max-block-cpu-usage block can be produced immediately (eosio::producer_plugin)
# max-block-cpu-usage-threshold-us = 5000

# Threshold of NET block production to consider block full; when within threshold of max-block-net-usage block can be produced immediately (eosio::producer_plugin)
# max-block-net-usage-threshold-bytes = 1024

# Maximum wall-clock time, in milliseconds, spent retiring scheduled transactions (and incoming transactions according to incoming-defer-ratio) in any block before returning to normal transaction processing. (eosio::producer_plugin)
# max-scheduled-transaction-time-per-block-ms = 100

# Time in microseconds allowed for a transaction that starts with insufficient CPU quota to complete and cover its CPU usage. (eosio::producer_plugin)
# subjective-cpu-leeway-us = 31000

# Sets the maximum amount of failures that are allowed for a given account per window size. (eosio::producer_plugin)
# subjective-account-max-failures = 3

# Sets the window size in number of blocks for subjective-account-max-failures. (eosio::producer_plugin)
# subjective-account-max-failures-window-size = 1

# Sets the time to return full subjective cpu for accounts (eosio::producer_plugin)
# subjective-account-decay-time-minutes = 1440

# ratio between incoming transactions and deferred transactions when both are queued for execution (eosio::producer_plugin)
# incoming-defer-ratio = 1

# Maximum size (in MiB) of the incoming transaction queue. Exceeding this value will subjectively drop transaction with resource exhaustion. (eosio::producer_plugin)
# incoming-transaction-queue-size-mb = 1024

# Disable subjective CPU billing for API/P2P transactions (eosio::producer_plugin)
# disable-subjective-billing = true

# Account which is excluded from subjective CPU billing (eosio::producer_plugin)
# disable-subjective-account-billing = 

# Disable subjective CPU billing for P2P transactions (eosio::producer_plugin)
# disable-subjective-p2p-billing = true

# Disable subjective CPU billing for API transactions (eosio::producer_plugin)
# disable-subjective-api-billing = true

# Number of worker threads in producer thread pool (eosio::producer_plugin)
# producer-threads = 2

# the location of the snapshots directory (absolute path or relative to application data dir) (eosio::producer_plugin)
# snapshots-dir = "snapshots"

# Number of worker threads in read-only execution thread pool. Max 8. (eosio::producer_plugin)
# read-only-threads = 

# Time in microseconds the write window lasts. (eosio::producer_plugin)
# read-only-write-window-time-us = 200000

# Time in microseconds the read window lasts. (eosio::producer_plugin)
# read-only-read-window-time-us = 60000

# The local IP and port to listen for incoming prometheus metrics http request. (eosio::prometheus_plugin)
# prometheus-exporter-address = 127.0.0.1:9101

# Time in seconds between two consecutive checks of resource usage. Should be between 1 and 300 (eosio::resource_monitor_plugin)
# resource-monitor-interval-seconds = 2

# Threshold in terms of percentage of used space vs total space. If used space is above (threshold - 5%), a warning is generated. Unless resource-monitor-not-shutdown-on-threshold-exceeded is enabled, a graceful shutdown is initiated if used space is above the threshold. The value should be between 6 and 99 (eosio::resource_monitor_plugin)
# resource-monitor-space-threshold = 90

# Absolute threshold in gibibytes of remaining space; applied to each monitored directory. If remaining space is less than value for any monitored directories then threshold is considered exceeded.Overrides resource-monitor-space-threshold value. (eosio::resource_monitor_plugin)
# resource-monitor-space-absolute-gb = 

# Used to indicate nodeos will not shutdown when threshold is exceeded. (eosio::resource_monitor_plugin)
# resource-monitor-not-shutdown-on-threshold-exceeded = 

# Number of resource monitor intervals between two consecutive warnings when the threshold is hit. Should be between 1 and 450 (eosio::resource_monitor_plugin)
# resource-monitor-warning-interval = 30

# Limits the maximum time (in milliseconds) that is allowed for sending requests to a keosd provider for signing (eosio::signature_provider_plugin)
# keosd-provider-timeout = 5

# the location of the state-history directory (absolute path or relative to application data dir) (eosio::state_history_plugin)
# state-history-dir = "state-history"

# the location of the state history retained directory (absolute path or relative to state-history dir). (eosio::state_history_plugin)
# state-history-retained-dir = 

# the location of the state history archive directory (absolute path or relative to state-history dir).
# If the value is empty string, blocks files beyond the retained limit will be deleted.
# All files in the archive directory are completely under user's control, i.e. they won't be accessed by nodeos anymore. (eosio::state_history_plugin)
# state-history-archive-dir = 

# split the state history log files when the block number is the multiple of the stride
# When the stride is reached, the current history log and index will be renamed '*-history-<start num>-<end num>.log/index'
# and a new current history log and index will be created with the most recent blocks. All files following
# this format will be used to construct an extended history log. (eosio::state_history_plugin)
# state-history-stride = 

# the maximum number of history file groups to retain so that the blocks in those files can be queried.
# When the number is reached, the oldest history file would be moved to archive dir or deleted if the archive dir is empty.
# The retained history log files should not be manipulated by users. (eosio::state_history_plugin)
# max-retained-history-files = 

# enable trace history (eosio::state_history_plugin)
# trace-history = false

# enable chain state history (eosio::state_history_plugin)
# chain-state-history = false

# the endpoint upon which to listen for incoming connections. Caution: only expose this port to your internal network. (eosio::state_history_plugin)
# state-history-endpoint = 127.0.0.1:8080

# the path (relative to data-dir) to create a unix socket upon which to listen for incoming connections. (eosio::state_history_plugin)
# state-history-unix-socket-path = 

# enable debug mode for trace history (eosio::state_history_plugin)
# trace-history-debug-mode = false

# if set, periodically prune the state history files to store only configured number of most recent blocks (eosio::state_history_plugin)
# state-history-log-retain-blocks = 

# the location of the trace directory (absolute path or relative to application data dir) (eosio::trace_api_plugin)
# trace-dir = "traces"

# the number of blocks each "slice" of trace data will contain on the filesystem (eosio::trace_api_plugin)
# trace-slice-stride = 10000

# Number of blocks to ensure are kept past LIB for retrieval before "slice" files can be automatically removed.
# A value of -1 indicates that automatic removal of "slice" files will be turned off. (eosio::trace_api_plugin)
# trace-minimum-irreversible-history-blocks = -1

# Number of blocks to ensure are uncompressed past LIB. Compressed "slice" files are still accessible but may carry a performance loss on retrieval
# A value of -1 indicates that automatic compression of "slice" files will be turned off. (eosio::trace_api_plugin)
# trace-minimum-uncompressed-irreversible-history-blocks = -1

# ABIs used when decoding trace RPC responses.
# There must be at least one ABI specified OR the flag trace-no-abis must be used.
# ABIs are specified as "Key=Value" pairs in the form <account-name>=<abi-def>
# Where <abi-def> can be:
#    an absolute path to a file containing a valid JSON-encoded ABI
#    a relative path from `data-dir` to a file containing a valid JSON-encoded ABI
#  (eosio::trace_api_plugin)
# trace-rpc-abi = 

# Use to indicate that the RPC responses will not use ABIs.
# Failure to specify this option when there are no trace-rpc-abi configuations will result in an Error.
# This option is mutually exclusive with trace-rpc-api (eosio::trace_api_plugin)
# trace-no-abis = 

# Plugin(s) to enable, may be specified multiple times
# plugin = 
```
## Configuration
The following are a few useful configuration options you will most likely need to work with.

### Plugins
| Method       | Syntax         | Example                           |
|--------------|----------------|-----------------------------------|
| Command line | `--plugin arg` | `--plugin eosio::producer_plugin` |
| Paragraph    | `plugin = arg` | `plugin = eosio::producer_plugin` |
Plugins extend and modify the functionality of nodeos and a number of the configuration options depend their presence.

Plugins list for `config.ini`:
```
# Plugin(s) to enable, may be specified multiple times
plugin = eosio::producer_plugin
plugin = eosio::producer_api_plugin
plugin = eosio::chain_plugin
plugin = eosio::chain_api_plugin
plugin = eosio::http_plugin
plugin = eosio::state_history_plugin
plugin = eosio::net_plugin
plugin = eosio::net_api_plugin
plugin = eosio::trace_api_plugin
```
There are additional plugins, but these are the ones you most need to include.

### Enable Stale Production
| Usage Method | Syntax                               |
|--------------|--------------------------------------|
| Command line | `-e` or ` --enable-stale-production` |
| Paragraph    | `enable-stale-production = true`     |
Enables block production, even if the chain is stale. Otherwise, if your chain was paused for an extended period of time then block production will fail.

### Signature Provider
| Method       | Syntax                                                                                                                                      |
|--------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| Command line | `--signature-provider arg (=EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3)` |
| Paragraph    | `signature-provider = EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
`       |
The signature provider is provided in the form of a key pair. The default one is shown above, but an alternative one could be used depending on your usecase.

### Trace No ABIs
| Method       | Syntax                               |
|--------------|--------------------------------------|
| Command line | `-e` or ` --enable-stale-production` |
| Paragraph    | `enable-stale-production = true`     |
Use to indicate that the RPC responses will not use ABIs. Failure to specify this option when there are no trace-rpc-abi configuations will result in an Error. This option is mutually exclusive with trace-rpc-api.

### Access Control Allow Origin
| Method       | Syntax                               |
|--------------|--------------------------------------|
| Command line | `-e` or ` --enable-stale-production` |
| Paragraph    | `enable-stale-production = true`     |
Similar to Cross-Origin Resource Sharing (CORS) for the web, *Access Control Allow Origin* allows you to control access from other origins (domain, scheme, or port). For a development instance you will most likely find it useful to allow all with the asterisk `*`, but then change it to specific origins on release.

## Example Config.ini
Here is a simple example `config.ini` with common values provided.
```
# Specify the Access-Control-Allow-Origin to be returned on each request (eosio::http_plugin)
access-control-allow-origin = *

# The name supplied to identify this node amongst the peers. (eosio::net_plugin)
agent-name = "EOS Test Agent"

# Enable block production, even if the chain is stale. (eosio::producer_plugin)
enable-stale-production = true

# ID of producer controlled by this node (e.g. inita; may specify multiple times) (eosio::producer_plugin)
producer-name = eosio

# Key=Value pairs in the form <public-key>=<provider-spec>
# Where:
#    <public-key>    	is a string form of a vaild EOSIO public key
# 
#    <provider-spec> 	is a string in the form <provider-type>:<data>
# 
#    <provider-type> 	is KEY, KEOSD, or SE
# 
#    KEY:<data>      	is a string form of a valid EOSIO private key which maps to the provided public key
# 
#    KEOSD:<data>    	is the URL where keosd is available and the approptiate wallet(s) are unlocked
# 
#  (eosio::producer_plugin)
signature-provider = EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

# Use to indicate that the RPC responses will not use ABIs.
# Failure to specify this option when there are no trace-rpc-abi configuations will result in an Error.
# This option is mutually exclusive with trace-rpc-api (eosio::trace_api_plugin)
trace-no-abis = true

# Plugin(s) to enable, may be specified multiple times
plugin = eosio::producer_plugin
plugin = eosio::producer_api_plugin
plugin = eosio::chain_plugin
plugin = eosio::chain_api_plugin
plugin = eosio::http_plugin
plugin = eosio::state_history_plugin
plugin = eosio::net_plugin
plugin = eosio::net_api_plugin
plugin = eosio::trace_api_plugin

```