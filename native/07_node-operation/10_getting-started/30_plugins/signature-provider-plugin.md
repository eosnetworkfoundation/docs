---
title: signature_provider_plugin
dont_translate_title: true
---

## Overview

The `signature_provider_plugin` is currently an internal implementation of the digital signing functionality previously implemented within the `producer_plugin`. Although it is currently only used by the `producer_plugin`, this new design allows a better separation of concerns and will enable other plugins to perform signing operations, if a future use case justifies it.

## Usage

```console
# config.ini
plugin = eosio::signature_provider_plugin
```
```sh
# command-line
nodeos ... --plugin eosio::signature_provider_plugin
```

## Options

These can be specified from either the `nodeos` command-line or the `config.ini` file:

### Config Options for `signature_provider_plugin`

Option (=default) | Description
-|-
`--keosd-provider-timeout arg (=5)` | Limits the maximum time (in milliseconds) that is allowed for sending requests to a keosd provider for signing

## Dependencies

* [`chain_plugin`](./chain-plugin.md)
* [`http_plugin`](./http-plugin.md)

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
