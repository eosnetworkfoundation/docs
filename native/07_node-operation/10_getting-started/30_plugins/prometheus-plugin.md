---
title: prometheus_plugin
dont_translate_title: true
---

## Overview

The `prometheus_plugin` provides data collection of various internal `nodeos` metrics. Clients can access the `/v1/prometheus/metrics` endpoint to retrieve the following metrics:

- number of clients
- number of peers
- number of dropped blocks
- unapplied transaction queue sizes (number of transactions)
- blacklisted transactions count (total)
- blocks produced
- transactions produced
- last irreversible
- current head block num
- subjective billing number of accounts
- subjective billing number of blocks
- scheduled transactions
- number of API calls per API endpoint

## Format

The `prometheus_plugin` endpoint returns a string consisting of metric names and their corresponding key/value pairs, also known as labels, collected in chronological order.

Given a metric name and a set of labels, data is collected chronologically and formatted using this notation:

```
<metric name> { <label name>= <label value>, ... }
```

Currently, two metric types are collected within `nodeos`:

- **Counter**: a cumulative metric that increases over time, like the number of requests to an endpoint.
- **Gauge**: an instantaneous measurement of a value. They can be arbitrary values which will be recorded.

## Usage

```console
# config.ini
plugin = eosio::prometheus_plugin
```
```sh
# command-line
nodeos ... --plugin eosio::prometheus_plugin
```

## Options

These can be specified from either the `nodeos` command-line or the `config.ini` file:

### Config Options for `prometheus_plugin`

Option (=default) | Description
-|-
`--prometheus-exporter-address arg (=127.0.0.1:9101)` | The local IP and port to listen for incoming prometheus metrics http request.

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
