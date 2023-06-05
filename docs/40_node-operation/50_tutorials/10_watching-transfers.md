---
title: Watching Transfers
---

You might want to watch for all transfers that happen within the EOS Network. This is useful for **exchanges** and 
**wallets** that need to keep track of incoming/outgoing funds.

In EOS, there are multiple ways that a transfer can occur. The most common way is through a `transfer` action on a transaction
directly, but a transfer can also occur as an inline action on triggered by a non-transfer action. If you are only
watching blocks, then you will miss the inline action transfers. This could impact your users' experience.

> ❔ **What is an inline action?**
>
> Inline actions are actions that are triggered by another action. For example, when withdrawing from a decentralized 
> exchange, the exchange will trigger a transfer action to send the tokens to the user. This transfer action is an inline
> action, as it occurred from a `exchange::withdraw` action. It was a non-root-level action.

Though this tutorial centers around watching for transfers, you can use the same method to watch for any action that
occurs on the EOS Network, from any contract.

## Download the token ABI

In order to watch for transfers, you will need to download the ABI for the token contract. You can either compile the 
contract yourself, or you can download the ABI directly.

### Using curl

You can use `curl` to fetch the ABI directly from the EOS Mainnet.

```shell
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{ "account_name":"eosio.token" }' \
  https://eos.greymass.com/v1/chain/get_abi | jq -r '.abi' > ./eosio.token.abi
```

The command above will fetch the ABI for the `eosio.token` contract's ABI and save it to a file called `eosio.token.abi`.

### Copy the ABI from the docs

Below is the ABI for the `eosio.token` contract. You can copy this directly into your application.
This was pulled directly from the mainnet, but there is no guarantee that it will be the same when you
read this.

<details>
    <summary>See JSON ABI</summary>

```json
{
  "version": "eosio::abi/1.1",
  "types": [],
  "structs": [
    {
      "name": "account",
      "base": "",
      "fields": [
        {
          "name": "balance",
          "type": "asset"
        }
      ]
    },
    {
      "name": "close",
      "base": "",
      "fields": [
        {
          "name": "owner",
          "type": "name"
        },
        {
          "name": "symbol",
          "type": "symbol"
        }
      ]
    },
    {
      "name": "create",
      "base": "",
      "fields": [
        {
          "name": "issuer",
          "type": "name"
        },
        {
          "name": "maximum_supply",
          "type": "asset"
        }
      ]
    },
    {
      "name": "currency_stats",
      "base": "",
      "fields": [
        {
          "name": "supply",
          "type": "asset"
        },
        {
          "name": "max_supply",
          "type": "asset"
        },
        {
          "name": "issuer",
          "type": "name"
        }
      ]
    },
    {
      "name": "issue",
      "base": "",
      "fields": [
        {
          "name": "to",
          "type": "name"
        },
        {
          "name": "quantity",
          "type": "asset"
        },
        {
          "name": "memo",
          "type": "string"
        }
      ]
    },
    {
      "name": "open",
      "base": "",
      "fields": [
        {
          "name": "owner",
          "type": "name"
        },
        {
          "name": "symbol",
          "type": "symbol"
        },
        {
          "name": "ram_payer",
          "type": "name"
        }
      ]
    },
    {
      "name": "retire",
      "base": "",
      "fields": [
        {
          "name": "quantity",
          "type": "asset"
        },
        {
          "name": "memo",
          "type": "string"
        }
      ]
    },
    {
      "name": "transfer",
      "base": "",
      "fields": [
        {
          "name": "from",
          "type": "name"
        },
        {
          "name": "to",
          "type": "name"
        },
        {
          "name": "quantity",
          "type": "asset"
        },
        {
          "name": "memo",
          "type": "string"
        }
      ]
    }
  ],
  "actions": [
    {
      "name": "close",
      "type": "close",
      "ricardian_contract": "---\nspec_version: \"0.2.0\"\ntitle: Close Token Balance\nsummary: 'Close {{nowrap owner}}’s zero quantity balance'\nicon: https://raw.githubusercontent.com/cryptokylin/eosio.contracts/v1.7.0/contracts/icons/token.png#207ff68b0406eaa56618b08bda81d6a0954543f36adc328ab3065f31a5c5d654\n---\n\n{{owner}} agrees to close their zero quantity balance for the {{symbol_to_symbol_code symbol}} token.\n\nRAM will be refunded to the RAM payer of the {{symbol_to_symbol_code symbol}} token balance for {{owner}}."
    },
    {
      "name": "create",
      "type": "create",
      "ricardian_contract": "---\nspec_version: \"0.2.0\"\ntitle: Create New Token\nsummary: 'Create a new token'\nicon: https://raw.githubusercontent.com/cryptokylin/eosio.contracts/v1.7.0/contracts/icons/token.png#207ff68b0406eaa56618b08bda81d6a0954543f36adc328ab3065f31a5c5d654\n---\n\n{{$action.account}} agrees to create a new token with symbol {{asset_to_symbol_code maximum_supply}} to be managed by {{issuer}}.\n\nThis action will not result any any tokens being issued into circulation.\n\n{{issuer}} will be allowed to issue tokens into circulation, up to a maximum supply of {{maximum_supply}}.\n\nRAM will deducted from {{$action.account}}’s resources to create the necessary records."
    },
    {
      "name": "issue",
      "type": "issue",
      "ricardian_contract": "---\nspec_version: \"0.2.0\"\ntitle: Issue Tokens into Circulation\nsummary: 'Issue {{nowrap quantity}} into circulation and transfer into {{nowrap to}}’s account'\nicon: https://raw.githubusercontent.com/cryptokylin/eosio.contracts/v1.7.0/contracts/icons/token.png#207ff68b0406eaa56618b08bda81d6a0954543f36adc328ab3065f31a5c5d654\n---\n\nThe token manager agrees to issue {{quantity}} into circulation, and transfer it into {{to}}’s account.\n\n{{#if memo}}There is a memo attached to the transfer stating:\n{{memo}}\n{{/if}}\n\nIf {{to}} does not have a balance for {{asset_to_symbol_code quantity}}, or the token manager does not have a balance for {{asset_to_symbol_code quantity}}, the token manager will be designated as the RAM payer of the {{asset_to_symbol_code quantity}} token balance for {{to}}. As a result, RAM will be deducted from the token manager’s resources to create the necessary records.\n\nThis action does not allow the total quantity to exceed the max allowed supply of the token."
    },
    {
      "name": "open",
      "type": "open",
      "ricardian_contract": "---\nspec_version: \"0.2.0\"\ntitle: Open Token Balance\nsummary: 'Open a zero quantity balance for {{nowrap owner}}'\nicon: https://raw.githubusercontent.com/cryptokylin/eosio.contracts/v1.7.0/contracts/icons/token.png#207ff68b0406eaa56618b08bda81d6a0954543f36adc328ab3065f31a5c5d654\n---\n\n{{ram_payer}} agrees to establish a zero quantity balance for {{owner}} for the {{symbol_to_symbol_code symbol}} token.\n\nIf {{owner}} does not have a balance for {{symbol_to_symbol_code symbol}}, {{ram_payer}} will be designated as the RAM payer of the {{symbol_to_symbol_code symbol}} token balance for {{owner}}. As a result, RAM will be deducted from {{ram_payer}}’s resources to create the necessary records."
    },
    {
      "name": "retire",
      "type": "retire",
      "ricardian_contract": "---\nspec_version: \"0.2.0\"\ntitle: Remove Tokens from Circulation\nsummary: 'Remove {{nowrap quantity}} from circulation'\nicon: https://raw.githubusercontent.com/cryptokylin/eosio.contracts/v1.7.0/contracts/icons/token.png#207ff68b0406eaa56618b08bda81d6a0954543f36adc328ab3065f31a5c5d654\n---\n\nThe token manager agrees to remove {{quantity}} from circulation, taken from their own account.\n\n{{#if memo}} There is a memo attached to the action stating:\n{{memo}}\n{{/if}}"
    },
    {
      "name": "transfer",
      "type": "transfer",
      "ricardian_contract": "---\nspec_version: \"0.2.0\"\ntitle: Transfer Tokens\nsummary: 'Send {{nowrap quantity}} from {{nowrap from}} to {{nowrap to}}'\nicon: https://raw.githubusercontent.com/cryptokylin/eosio.contracts/v1.7.0/contracts/icons/transfer.png#5dfad0df72772ee1ccc155e670c1d124f5c5122f1d5027565df38b418042d1dd\n---\n\n{{from}} agrees to send {{quantity}} to {{to}}.\n\n{{#if memo}}There is a memo attached to the transfer stating:\n{{memo}}\n{{/if}}\n\nIf {{from}} is not already the RAM payer of their {{asset_to_symbol_code quantity}} token balance, {{from}} will be designated as such. As a result, RAM will be deducted from {{from}}’s resources to refund the original RAM payer.\n\nIf {{to}} does not have a balance for {{asset_to_symbol_code quantity}}, {{from}} will be designated as the RAM payer of the {{asset_to_symbol_code quantity}} token balance for {{to}}. As a result, RAM will be deducted from {{from}}’s resources to create the necessary records."
    }
  ],
  "tables": [
    {
      "name": "accounts",
      "index_type": "i64",
      "key_names": [],
      "key_types": [],
      "type": "account"
    },
    {
      "name": "stat",
      "index_type": "i64",
      "key_names": [],
      "key_types": [],
      "type": "currency_stats"
    }
  ],
  "ricardian_clauses": [],
  "error_messages": [],
  "abi_extensions": [],
  "variants": [],
  "action_results": []
}
```

</details>

### Compiling the contract yourself

You can clone the [EOS System Contracts](https://github.com/eosnetworkfoundation/eos-system-contracts/) repository,
and then compile the contracts using the `build.sh` script.

You will then have a `build/contracts` directory that contains the compiled contracts.

## Updating your configuration file

You will need to update your `config.ini` file to include the following options:

```shell
# Plugins required for the Trace API
plugin = eosio::chain_plugin
plugin = eosio::http_plugin
plugin = eosio::trace_api_plugin

# Tell the Trace API where ABIs are for the contracts you care about 
trace-rpc-abi=eosio.token=<YOUR_PATH_to_eosio.token.abi>

# You may also manually specify a traces directory
trace-dir=/path/to/traces
```

## Should you replay?

Once you enable the Trace API, you will only get traces for blocks that are produced after you enable the plugin. 
If you want to get traces for blocks that were produced before you enabled the plugin, you will need to replay the chain
from that block.

> 🕔 **Want to replay from EOS EVM launch?**
> 
> If your aim is to get traces for transfers that happen on the EOS EVM, you can use a snapshot that was taken on or before
> 2023-04-05T02:18:09 UTC. That way you will be able to get traces for transfers that happened on the EOS EVM, but not 
> waste time replaying blocks that were produced before the EOS EVM launch.

## SSD considerations

The Trace API's persisted data grows at a rate similar to the `blocks.log`. You will need more SSD storage to store the
traces which enable you to have a complete 

You can optimize disk usage by removing old traces, and compressing log files.

Add these to your `config.ini` file:
```shell
# Remove old traces
trace-minimum-irreversible-history-blocks=<number of blocks to keep>

# Compress log files
trace-minimum-uncompressed-history-blocks=<number of blocks to keep uncompressed>
```

## Watching blocks using the Trace API

Normally, you would use a `/v1/chain/get_block` request on every block, and then iterate the `actions` array within each
transaction in the `transactions` array to scan for transfers.

<details>
    <summary>See curl command to get chain block</summary>

```shell
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{ "block_num_or_id": 2 }' \
   http://127.0.0.1:8888/v1/chain/get_block | jq
```

</details>

With the Trace API enabled, you will now use the `/v1/trace_api/get_block` instead, which will give you back almost the same result format, 
except that the `actions` array will contain not only the root actions, but also the inline actions that were executed as well. 
This paints a complete picture of what happened during the execution of the transaction, instead of just the root actions that were sent to the chain.

<details>
    <summary>See curl command to get trace block</summary>

```shell
curl -X POST \
   -H "Content-Type: application/json" \
   -d '{ "block_num": 2 }' \
   http://127.0.0.1:8888/v1/trace_api/get_block | jq
```

</details>

There are some other important things to note about the Trace API's `get_block` endpoint:
- An action's `name` property is now called `action`
- An action's `data` property is now called `params`
- The `block_num_or_id` POST data parameter is now just `block_num`

> 📄 **API reference**
>
> For more information about the Trace API, see the [API Reference](https://docs.eosnetwork.com/apis/leap/latest/trace_api.api).


### Examples of both formats

<details>
    <summary>See chain/get_block</summary>

```json
{
  "timestamp": "2023-06-02T15:10:56.500",
  "producer": "eosio",
  "confirmed": 0,
  "previous": "000000140022c6320e45d8d390e686b6ce6148db4d602884be01776ad8d18c46",
  "transaction_mroot": "430716daff9428cf0327dd9fd08478295a4422bf303b13a74d88379a5e89ff5f",
  "action_mroot": "3ee0e97056c1c592ee755d9d26e178d810dba8c0af57410632fc0e7c4ac9f9a0",
  "schedule_version": 0,
  "new_producers": null,
  "producer_signature": "SIG_K1_KiSmFVmh498vHRj5rzWvFKo1zJDV2vUv5hfQVwpyj1GtYF1wSedAkJ2zihMWMjFWxqZmWVJZtW3wCFLBtAEDTSxjK7deQV",
  "transactions": [
    {
      "status": "executed",
      "cpu_usage_us": 192,
      "net_usage_words": 17,
      "trx": {
        "id": "1c073fe57292a253ea18cd7075c5420301038197806eeda51e94a33ce63be935",
        "signatures": [
          "SIG_K1_KVPDUxX5DbokbpYj9VgNZw3AZHu9HCLcH2CJbMhJuY2MfcufaLcaRz3KAwLJd12JkoR6r1EUN2XeTVjrDtorKFMiMwnd4f"
        ],
        "compression": "none",
        "packed_context_free_data": "",
        "context_free_data": [],
        "packed_trx": "9e067a641300ba187bdd00000000010000e82a01ea3055000000dcdcd4b2e3010000000000000e3d00000000a8ed3232270000000000000e3da08601000000000004454f5300000000a0d8340d75a524c50631323334353600",
        "transaction": {
          "expiration": "2023-06-02T15:11:26",
          "ref_block_num": 19,
          "ref_block_prefix": 3715831994,
          "max_net_usage_words": 0,
          "max_cpu_usage_ms": 0,
          "delay_sec": 0,
          "context_free_actions": [],
          "actions": [
            {
              "account": "eosio.dex",
              "name": "withdraw",
              "authorization": [
                {
                  "actor": "bob",
                  "permission": "active"
                }
              ],
              "data": {
                "account": "bob",
                "quantity": "10.0000 EOS",
                "to": "someexchange",
                "memo": "123456"
              },
              "hex_data": "0000000000000e3da08601000000000004454f5300000000a0d8340d75a524c506313233343536"
            }
          ]
        }
      }
    }
  ],
  "id": "000000157b7f9e05cf80f8861df6e6bda357230ed7c8a29409d5c5d823fc0a1f",
  "block_num": 21,
  "ref_block_prefix": 2264432847
}
```
</details>

<details>
    <summary>See trace_api/get_block</summary>

```json
{
  "id": "000000157b7f9e05cf80f8861df6e6bda357230ed7c8a29409d5c5d823fc0a1f",
  "number": 21,
  "previous_id": "000000140022c6320e45d8d390e686b6ce6148db4d602884be01776ad8d18c46",
  "status": "irreversible",
  "timestamp": "2023-06-02T15:10:56.500Z",
  "producer": "eosio",
  "transaction_mroot": "430716daff9428cf0327dd9fd08478295a4422bf303b13a74d88379a5e89ff5f",
  "action_mroot": "3ee0e97056c1c592ee755d9d26e178d810dba8c0af57410632fc0e7c4ac9f9a0",
  "schedule_version": 0,
  "transactions": [
    {
      "id": "2529fa879b6a4d7a75f892ab2ee9ace8c322355c2700c713b38c5b4aba023c2b",
      "block_num": 21,
      "block_time": "2023-06-02T15:10:56.500",
      "producer_block_id": null,
      "actions": [
        {
          "global_sequence": 50,
          "receiver": "eosio",
          "account": "eosio",
          "action": "onblock",
          "authorization": [
            {
              "account": "eosio",
              "permission": "active"
            }
          ],
          "data": "008619580000000000ea3055000000000013ce0c73faba187bdd5bce9432d8a5505b8da7a0a88a89d4c063d27b770000000000000000000000000000000000000000000000000000000000000000ceb2eeb65028c5680dfc06486faad42bfd7ff4c6e3b211058eff625d0d1f212f000000000000",
          "return_value": ""
        }
      ],
      "status": "executed",
      "cpu_usage_us": 100,
      "net_usage_words": 0,
      "signatures": [],
      "transaction_header": {
        "expiration": "2023-06-02T15:10:57",
        "ref_block_num": 20,
        "ref_block_prefix": 3554166030,
        "max_net_usage_words": 0,
        "max_cpu_usage_ms": 0,
        "delay_sec": 0
      }
    },
    {
      "id": "1c073fe57292a253ea18cd7075c5420301038197806eeda51e94a33ce63be935",
      "block_num": 21,
      "block_time": "2023-06-02T15:10:56.500",
      "producer_block_id": null,
      "actions": [
        {
          "global_sequence": 51,
          "receiver": "eosio.dex",
          "account": "eosio.dex",
          "action": "withdraw",
          "authorization": [
            {
              "account": "bob",
              "permission": "active"
            }
          ],
          "data": "0000000000000e3da08601000000000004454f5300000000a0d8340d75a524c506313233343536",
          "return_value": ""
        },
        {
          "global_sequence": 52,
          "receiver": "eosio.token",
          "account": "eosio.token",
          "action": "transfer",
          "authorization": [
            {
              "account": "eosio.dex",
              "permission": "active"
            }
          ],
          "data": "0000e82a01ea3055a0d8340d75a524c5a08601000000000004454f530000000006313233343536",
          "return_value": "",
          "params": {
            "from": "eosio.dex",
            "to": "someexchange",
            "quantity": "10.0000 EOS",
            "memo": "123456"
          }
        },
        {
          "global_sequence": 53,
          "receiver": "eosio.dex",
          "account": "eosio.token",
          "action": "transfer",
          "authorization": [
            {
              "account": "eosio.dex",
              "permission": "active"
            }
          ],
          "data": "0000e82a01ea3055a0d8340d75a524c5a08601000000000004454f530000000006313233343536",
          "return_value": "",
          "params": {
            "from": "eosio.dex",
            "to": "someexchange",
            "quantity": "10.0000 EOS",
            "memo": "123456"
          }
        },
        {
          "global_sequence": 54,
          "receiver": "someexchange",
          "account": "eosio.token",
          "action": "transfer",
          "authorization": [
            {
              "account": "eosio.dex",
              "permission": "active"
            }
          ],
          "data": "0000e82a01ea3055a0d8340d75a524c5a08601000000000004454f530000000006313233343536",
          "return_value": "",
          "params": {
            "from": "eosio.dex",
            "to": "someexchange",
            "quantity": "10.0000 EOS",
            "memo": "123456"
          }
        }
      ],
      "status": "executed",
      "cpu_usage_us": 192,
      "net_usage_words": 17,
      "signatures": [
        "SIG_K1_KVPDUxX5DbokbpYj9VgNZw3AZHu9HCLcH2CJbMhJuY2MfcufaLcaRz3KAwLJd12JkoR6r1EUN2XeTVjrDtorKFMiMwnd4f"
      ],
      "transaction_header": {
        "expiration": "2023-06-02T15:11:26",
        "ref_block_num": 19,
        "ref_block_prefix": 3715831994,
        "max_net_usage_words": 0,
        "max_cpu_usage_ms": 0,
        "delay_sec": 0
      }
    }
  ]
}

```
</details>

As you can see, if you were using the `chain/get_block` endpoint to scan for incoming transfers, you would have missed 
the token transfer action that was executed in the transaction, and potentially lost your user's funds.

### Listening for specific actions

When listening for actions there are three primary fields you want to look for. 

- **account** - tells you which contract is being executed
- **action** - tells you which action was executed on the contract
- **params** - contains the parameters that were passed to the action
- **receiver** - tells you which contract is receiving the action

If you were listening for token transfers of **EOS**, you would want to look for actions where the
**account** field is `eosio.token` and the **action** field is `transfer`.

Then, you'll want to validate the information inside the `params` object.

For example, if you were the `someexchange` account, you would want to make sure that the `to` field matches your account 
name, and possibly that the memo field matches some identifier that you're expecting.

> ⚠ **Warning**
> 
> The `receiver` field is not always the same as the `account` field. If the `receiver` field is different than the 
> `account` field, then this is a notification which allows other contracts to trigger side-effects, and not an action 
> that you should be processing.

<details>
    <summary>JavaScript example of checking for transfers</summary>

```javascript
const CONTRACT = "eosio.token";
const ACTION = "transfer";
const YOUR_ACCOUNT = "someexchange";

const result = await fetch('https://your.node/v1/trace_api/get_block', {
    method: 'POST',
    body: JSON.stringify({
        block_num: NEXT_BLOCK_NUM
    })
}).then(res => res.json())

for(let transaction of result.transactions) {
    for(let action of transaction.actions) {
        if(
            // This is the smart contract that is being executed
            action.account === CONTRACT
            // This is the action that is being executed
            && action.action === ACTION
            // This is the receiver of this action, if it is not the same as 
            // the contract account, then this is just a notification (DO NOT PROCESS)
            && action.receiver === action.account 
        ) {
            // We now know that this is a transfer action, and it is not 
            // a notification, so we can check the params
            if(action.params.to === YOUR_ACCOUNT) {
                
                // This transfer is for us, so we can do something with it
                const { quantity, memo } = action.params;
                const [amount, symbol] = quantity.split(' ');
                // You should also check that the symbol matches
                // the symbol that you're expecting as well
                if(symbol !== 'EOS') {
                    // This is not the token that we're expecting
                    continue;
                }
                
                
                // ... 
            }
        }
    }
}
```

</details>

## Using a transaction ID instead of watching blocks

If you have a transaction ID, you can fetch the transaction directly from the Trace API instead.

```shell
curl -X POST -H "Content-Type: application/json" \
   -d '{ "id": "YOUR_TRANSACTION_ID" }' \
   http://127.0.0.1:8888/v1/trace_api/get_transaction_trace | jq
```

This will give you a single transaction trace in exactly the same format as the `get_block` endpoint.

<details>
    <summary>See example result</summary>

```json
{
  "id": "d11dc29013e40c5f132b1ae507622eaba6ab01e1e3ac1ecc875b7a80fdc72233",
  "block_num": 21,
  "block_time": "2023-06-02T15:15:33.500",
  "producer_block_id": null,
  "actions": [
    {
      "global_sequence": 51,
      "receiver": "eosio.dex",
      "account": "eosio.dex",
      "action": "withdraw",
      "authorization": [
        {
          "account": "bob",
          "permission": "active"
        }
      ],
      "data": "0000000000000e3da08601000000000004454f530000000000a6823403ea305506313233343536",
      "return_value": ""
    },
    {
      "global_sequence": 52,
      "receiver": "eosio.token",
      "account": "eosio.token",
      "action": "transfer",
      "authorization": [
        {
          "account": "eosio.dex",
          "permission": "active"
        }
      ],
      "data": "0000e82a01ea305500a6823403ea3055a08601000000000004454f530000000006313233343536",
      "return_value": "",
      "params": {
        "from": "eosio.dex",
        "to": "eosio.token",
        "quantity": "10.0000 EOS",
        "memo": "123456"
      }
    },
    {
      "global_sequence": 53,
      "receiver": "eosio.dex",
      "account": "eosio.token",
      "action": "transfer",
      "authorization": [
        {
          "account": "eosio.dex",
          "permission": "active"
        }
      ],
      "data": "0000e82a01ea305500a6823403ea3055a08601000000000004454f530000000006313233343536",
      "return_value": "",
      "params": {
        "from": "eosio.dex",
        "to": "eosio.token",
        "quantity": "10.0000 EOS",
        "memo": "123456"
      }
    }
  ],
  "status": "executed",
  "cpu_usage_us": 187,
  "net_usage_words": 17,
  "signatures": [
    "SIG_K1_JwowShN9caNF4PeX3oMN3PCwKqbfLKz3f1noURuftDSvEd9RiMdY4HGk2kbVJjN47QKcFJSFMh1Yf6uZAfYRxay8iWprzF"
  ],
  "transaction_header": {
    "expiration": "2023-06-02T15:16:03",
    "ref_block_num": 19,
    "ref_block_prefix": 3497594715,
    "max_net_usage_words": 0,
    "max_cpu_usage_ms": 0,
    "delay_sec": 0
  }
}
```
</details>

> 📄 **API reference**
>
> For more information about the Trace API, see the [API Reference](https://docs.eosnetwork.com/apis/leap/latest/trace_api.api).

