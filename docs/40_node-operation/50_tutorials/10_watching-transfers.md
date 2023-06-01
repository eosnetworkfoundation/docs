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
  https://eos.greymass.com/v1/chain/get_abi
```

### Copy the ABI from the docs

Below is the ABI for the `eosio.token` contract. You can copy this directly into your application.
This was pulled directly from the mainnet, but there is no guarantee that it will be the same when you
read this.

<details>
    <summary>See JSON ABI</summary>

```json
{
  "account_name": "eosio.token",
  "abi": {
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
}
```

</details>

### Compiling the contract yourself

You will need to clone the [EOS System Contracts](https://github.com/eosnetworkfoundation/eos-system-contracts/) repository,
and then compile the `eosio.token` contract.

For information about how to compile contracts, see our [DUNE guide](/docs/20_smart-contracts/10_getting-started/10_dune-guide.md).

## Updating your configuration file

You will need to update your `config.ini` file to include the following options:

```ini
# Plugins required for the Trace API
plugin = eosio::chain_plugin
plugin = eosio::http_plugin
plugin = eosio::trace_api_plugin

# Tell the where ABIs are for the contracts you care about 
trace-rpc-abi=eosio.token=<YOUR_PATH_to_eosio.token.abi>

# You may also manually specify a traces directory
trace-dir=/path/to/traces
```

## Should you replay?

Once you enable the Trace API, you will only get traces for blocks that are produced after you enable the plugin. 
If you want to get traces for blocks that were produced before you enabled the plugin, you will need to replay the chain. 

> 🕔 **Want to replay from EOS EVM launch?**
> 
> If your aim is to get traces for transfers that happen on the EOS EVM, you can use a snapshot that was taken on or before
> 2023-04-05T02:18:09 UTC. That way you will be able to get traces for transfers that happened on the EOS EVM, but not 
> waste time replaying blocks that were produced before the EOS EVM launch.

## SSD considerations

The Trace API's persisted data grows at a rate similar to the `blocks.log`. You will need more SSD storage to store the
traces which enable you to have a complete 

You can optimize disk usage by removing old traces, and compressing log files.

```ini
# config.ini

# Remove old traces
trace-minimum-irreversible-history-blocks=<number of blocks to keep>

# Compress log files
trace-minimum-uncompressed-history-blocks=<number of blocks to keep uncompressed>
```

## Watching for transfers

Once you have set up, enabled, and gotten some traces, you can start watching for transfers.

Normally, you would use a `/v1/chain/get_block` request on every block, and then iterate the `actions` array within each
transaction in the `transactions` array to scan for transfers.

With the Trace API, you will now use the `/v1/trace_api/get_block` instead, which will give you back the same result format, 
except that the `actions` array will contain not only the root actions, but also the inline actions which were called
during execution. This paints a complete picture of what happened during the execution of the transaction, instead of 
just the root actions that were sent to the chain.

## Security considerations

If security is a concern, you should run your own node, and not rely on a public node. 

However, there is no difference between the security of the Trace API's `get_block` endpoint and the security of 
the `get_block` RPC endpoint.

