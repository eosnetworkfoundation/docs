---
title: producer_api_plugin
dont_translate_title: true
---

See [Producer API Reference](https://docs.eosnetwork.com/apis/leap/latest/producer.api/).

## Overview

The `producer_api_plugin` exposes various endpoints for the [`producer_plugin`](./producer-plugin.md) to the RPC API interface managed by the [`http_plugin`](../http_plugin/index.md).

## Usage

```console
# config.ini
plugin = eosio::producer_api_plugin
```
```sh
# nodeos startup params
nodeos ... --plugin eosio::producer_api_plugin
```

## Options

None

## Dependencies

* [`producer_plugin`](./producer-plugin.md)
* [`chain_plugin`](./chain-plugin.md)
* [`http_plugin`](./http-plugin.md)

### Load Dependency Examples

```console
# config.ini
plugin = eosio::producer_plugin
[options]
plugin = eosio::chain_plugin
[options]
plugin = eosio::http_plugin
[options]
```
```sh
# command-line
nodeos ... --plugin eosio::producer_plugin [options]  \
           --plugin eosio::chain_plugin [operations] [options]  \
           --plugin eosio::http_plugin [options]
```
