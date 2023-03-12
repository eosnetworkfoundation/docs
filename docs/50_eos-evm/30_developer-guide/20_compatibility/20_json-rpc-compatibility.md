---
title: JSON RPC Compatibility
---

As we described in previous sections, the requests will be forwarded to the Geth Node in our system or a Wrapper service the repacking the transaction into an EOS smart contract call.

According to our design, all the JSON-RPC calls should be inherently supported thanks to the full functioning Geth Node. However, we are still blocking some methods in current phase for different reasons:

* Some methods are simply deprecated or discontinued. We'd better refrain from supporting them.
* Some methods are designed for the local node scenario. We will not expose them in the public API but will give ways to access them when one deploy his own EOS EVM node.
* Some methods involve complex logic: We need to do more tests before exposing them.

## RPC List

| RPC Method                               | Destination |
| ---------------------------------------- | ----------- |
| web3\_clientVersio                       | Geth        |
| web3\_sha3                               | Block       |
| net\_version                             | Geth        |
| net\_peerCount                           | Block       |
| net\_listening                           | Block       |
| eth\_protocolVersion                     | Block       |
| eth\_syncing                             | Block       |
| eth\_coinbase                            | Block       |
| eth\_mining                              | Block       |
| eth\_hashrate                            | Block       |
| eth\_gasPrice                            | Wrapper     |
| eth\_accounts                            | Block       |
| eth\_blockNumber                         | Geth        |
| eth\_getBalance                          | Geth        |
| eth\_getStorageAt                        | Geth        |
| eth\_getTransactionCount                 | Geth        |
| eth\_getBlockTransactionCountByHash      | Geth        |
| eth\_getBlockTransactionCountByNumber    | Geth        |
| eth\_getUncleCountByBlockHash            | Block       |
| eth\_getUncleCountByBlockNumber          | Block       |
| eth\_getCode                             | Geth        |
| eth\_sign                                | Block       |
| eth\_signTransaction                     | Block       |
| eth\_sendTransaction                     | Block       |
| eth\_sendRawTransaction                  | Wrapper     |
| eth\_call                                | Geth        |
| eth\_estimateGas                         | Wrapper     |
| eth\_getBlockByHash                      | Geth        |
| eth\_getBlockByNumber                    | Geth        |
| eth\_getTransactionByHash                | Geth        |
| eth\_getTransactionByBlockHashAndIndex   | Geth        |
| eth\_getTransactionByBlockNumberAndIndex | Geth        |
| eth\_getTransactionReceipt               | Geth        |
| eth\_getUncleByBlockHashAndIndex         | Block       |
| eth\_getUncleByBlockNumberAndIndex       | Block       |
| eth\_getCompilers                        | Block       |
| eth\_compileLLL                          | Block       |
| eth\_compileSolidity                     | Block       |
| eth\_compileSerpent                      | Block       |
| eth\_newFilter                           | Block       |
| eth\_newBlockFilter                      | Block       |
| eth\_newPendingTransactionFilter         | Block       |
| eth\_uninstallFilter                     | Block       |
| eth\_getFilterChanges                    | Block       |
| eth\_getFilterLogs                       | Block       |
| eth\_getLogs                             | Block       |
| eth\_getWork                             | Block       |
| eth\_submitWork                          | Block       |
| eth\_submitHashrate                      | Block       |
| db\_putString                            | Block       |
| db\_getString                            | Block       |
| db\_putHex                               | Block       |
| db\_getHex                               | Block       |
| shh\_post                                | Block       |
| shh\_version                             | Block       |
| shh\_newIdentity                         | Block       |
| shh\_hasIdentity                         | Block       |
| shh\_newGroup                            | Block       |
| shh\_addToGroup                          | Block       |
| shh\_newFilter                           | Block       |
| shh\_uninstallFilter                     | Block       |
| shh\_getFilterChanges                    | Block       |
| shh\_getMessages                         | Block       |
