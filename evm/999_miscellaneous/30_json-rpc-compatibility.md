---
title: JSON RPC Compatibility
---

All the JSON-RPC calls are inherently supported thanks to the full functioning EOS EVM node which is built based on Silkworm node. However, some methods are blocked in the current phase for the following reasons:

* Some methods are deprecated or discontinued.
* Some methods are designed for the local node scenario. They are not exposed to the public API, however you can access them when you deploy your own EOS EVM node.
* Some methods involve complex logic, therefore more tests need to be performed before they will be exposed.

## RPC List

Notes:
* The JSON-RPC calls listed below do NOT include methods that are blocked in the current phase.
* "EOS EVM Node-SlowQuery" is designated for nodes dedicated to handle slow or heavy queries. This is done so that those slow queries do not stop or degrade the performance of regular nodes serving other method requests.

| RPC Method                                  | Destination  |
| ------------------------------------------- | ------------ |
| net\_version                                | EOS EVM node |
| eth\_blockNumber                            | EOS EVM node |
| eth\_chainId                                | EOS EVM node |
| eth\_protocolVersion                        | EOS EVM node |
| eth\_gasPrice                               | Tx Wrapper   |
| eth\_getBlockByHash                         | EOS EVM node |
| eth\_getBlockByNumber                       | EOS EVM node |
| eth\_getBlockTransactionCountByHash         | EOS EVM node |
| eth\_getBlockTransactionCountByNumber       | EOS EVM node |
| eth\_getUncleByBlockHashAndIndex            | EOS EVM node |
| eth\_getUncleByBlockNumberAndIndex          | EOS EVM node |
| eth\_getUncleCountByBlockHash               | EOS EVM node |
| eth\_getUncleCountByBlockNumber             | EOS EVM node |
| eth\_getTransactionByHash                   | EOS EVM node |
| eth\_getRawTransactionByHash                | EOS EVM node |
| eth\_getTransactionByBlockHashAndIndex      | EOS EVM node |
| eth\_getRawTransactionByBlockHashAndIndex   | EOS EVM node |
| eth\_getTransactionByBlockNumberAndIndex    | EOS EVM node |
| eth\_getRawTransactionByBlockNumberAndIndex | EOS EVM node |
| eth\_getTransactionReceipt                  | EOS EVM node |
| eth\_getBlockReceipts                       | EOS EVM node |
| eth\_estimateGas                            | EOS EVM node |
| eth\_getBalance                             | EOS EVM node |
| eth\_getCode                                | EOS EVM node |
| eth\_getTransactionCount                    | EOS EVM node |
| eth\_getStorageAt                           | EOS EVM node |
| eth\_call                                   | EOS EVM node |
| eth\_callBundle                             | EOS EVM node |
| eth\_createAccessList                       | EOS EVM node |
| eth\_getLogs                                | EOS EVM Node-SlowQuery |
| eth\_sendRawTransaction                     | Tx Wrapper   |
| debug\_traceBlockByHash                     | EOS EVM Node-SlowQuery |
| debug\_traceBlockByNumber                   | EOS EVM Node-SlowQuery |
| debug\_traceTransaction                     | EOS EVM Node-SlowQuery |
| debug\_traceCall                            | EOS EVM Node-SlowQuery |
| trace\_call                                 | EOS EVM Node-SlowQuery |
| trace\_callMany                             | EOS EVM Node-SlowQuery |
| trace\_rawTransaction                       | EOS EVM Node-SlowQuery |
| trace\_replayBlockTransactions              | EOS EVM Node-SlowQuery |
| trace\_replayTransaction                    | EOS EVM Node-SlowQuery |
| trace\_block                                | EOS EVM Node-SlowQuery |
| trace\_filter                               | EOS EVM Node-SlowQuery |
| trace\_get                                  | EOS EVM Node-SlowQuery |
| trace\_transaction                          | EOS EVM Node-SlowQuery |

## Batched Requests

Sending an array of request objects as the body to the JSON-RPC API is not currently supported. The server will return a 400 error in this case. If this is impacting you, try a workaround until this is supported.

Example failing request body:
```json
[{"method":"eth_chainId","params":[],"id":1,"jsonrpc":"2.0"},{"method":"eth_blockNumber","params":[],"id":2,"jsonrpc":"2.0"}]
```
