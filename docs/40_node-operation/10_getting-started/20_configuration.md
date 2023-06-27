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
