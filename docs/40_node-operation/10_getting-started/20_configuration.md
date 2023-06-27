---
title: Configuration
sidebar_class_name: sidebarhidden
---

## Config.ini

`config.ini` is the configuration file that controls how a `nodeos` instance will function. For instance, within the `config.ini` you can specify:

* which nodes your node will peer with
* the actual plugins your node will use
* plugin-specific options to customize your node

Therefore, the `config.ini` file has a direct impact on the operation of the node. Most node operators edit and customize this file to assign specific roles to their nodes.

> ℹ️ `nodeos` can be configured using either command-line interface (CLI) options, the `config.ini` file, or both. Nodeos-specific options, on the other hand, can only be specified through the command line. To view all available CLI options and `config.ini` options, launch "nodeos --help" from a terminal.

### CLI options vs. `config.ini`

Every option from the `config.ini` file can also be specified as a CLI option. For instance, the `plugin = arg` option in `config.ini` can also be passed via the `--plugin arg` CLI option. However, the reverse is not always true: not every CLI option has an equivalent entry in the `config.ini` file. For instance, plugin-specific options that perform an immediate operation, like `--delete-state-history` from the `state_history_plugin`, cannot be specified in the `config.ini` file.

> ℹ️ Most node operators prefer `config.ini` options over CLI options. This is because the `config.ini` will preserve the configuration state, unlike CLI options specified when launching `nodeos`.

### Custom `config.ini`

To use a custom `config.ini` file, specify its filename by passing the `--config arg` option when launching `nodeos`. The custom filename is relative to the actual path of the `config.ini` file specified in the `--config-dir arg` option.

### Sample `config.ini`

<details>
<summary>Here is a simple example with common values provided:</summary>

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

</details>

## Plugins

This section covers the most common plugin options that affect node behavior. These options are always plugin-specific. This is true for a node configured to operate as a producing node, relay node, API node, etc.

> ℹ️ The following plugins are enabled by default when `nodeos` is launched: `chain_plugin`, `net_plugin`, `producer_plugin`, `resource_monitor_plugin`. Therefore, it is not necessary to load them again 

### `plugin` option

Plugins are essential for extending and modifying the functionality of a node. You use the `plugin` option to enable a given plugin within the running `nodeos` instance.

Option type | Config method | Syntax | Example
-|-|-|-
Nodeos-specific | CLI option | `--plugin arg` | `--plugin eosio::chain_plugin`
`nodeos` | `config.ini` | `plugin = arg` | `plugin = eosio::chain_plugin`

> ℹ️ `nodeos` plugins are not dynamically loaded. They are enabled when `nodeos` is launched and cannot be unloaded or reloaded while the `nodeos` instance is running. Plugins are baked into the `nodeos` binary.

### `enable-stale-production` option

You use the `enable-stale-production` option to enable block production, even if the chain is stale. Otherwise, if the chain were paused for an extended period of time, block production would fail.

Option type | Config method | Syntax | Example
-|-|-|-
Plugin-specific | CLI option | `-e` or `--enable-stale-production`
`producer_plugin` | `config.ini` | `enable-stale-production = true`

### `signature-provider` option

You use the `signature-provider` option to allow your node to sign blocks and transactions. The signature provider must be specified as a key pair.

Option type | Config method | Syntax | Example
-|-|-|-
Plugin-specific | CLI option | `-e` or `--enable-stale-production`
`producer_plugin` | `config.ini` | `enable-stale-production = true`

### `trace-no-abis` option

You use the `trace-no-abis` option to indicate that the RPC responses will not use ABIs. This option must be specified when the `trace-rpc-abi` option is not used to specify an ABI.

Option type | Config method | Syntax | Example
-|-|-|-
Plugin-specific | CLI option | `--trace-no-abis`
`trace_api_plugin` | `config.ini` | `trace-no-abis =`

### `access-control-allow-origin` option

Similar to Cross-Origin Resource Sharing (CORS) for the web, the `access-control-allow-origin` option allows you to control access from other origins (domain, scheme, or port). For a development instance, you will most likely find it useful to allow all origins with the asterisk `*`, but then change it to specific origins for production.

Option type | Config method | Syntax | Example
-|-|-|-
Plugin-specific | CLI option | `--access-control-allow-origin arg`
`http_plugin` | `config.ini` | `access-control-allow-origin = arg`
