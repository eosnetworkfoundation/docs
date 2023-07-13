See [DB Size API Reference](https://docs.eosnetwork.com/apis/leap/latest/db_size.api/).

## Overview

The `db_size_api_plugin` obtains analytics related to the blockchain. It retrieves at the least the following information:
* free_bytes
* used_bytes
* size
* indices

## Usage

```console
# config.ini
plugin = eosio::db_size_api_plugin
```
```sh
# command-line
nodeos ... --plugin eosio::db_size_api_plugin
```

## Options

None

## Dependencies

* [`chain_plugin`](../chain_plugin/index.md)
* [`http_plugin`](../http_plugin/index.md)

### Load Dependency Examples

```console
# config.ini
plugin = eosio::chain_plugin
[options]
plugin = eosio::http_plugin
[options]
```
```sh
# command-line
nodeos ... --plugin eosio::chain_plugin [operations] [options]  \
           --plugin eosio::http_plugin [options]
```
