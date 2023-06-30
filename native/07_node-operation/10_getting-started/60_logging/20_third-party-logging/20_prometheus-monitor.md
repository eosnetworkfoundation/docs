---
title: Prometheus Integration
---

## Overview

EOS supports the prometheus plugin which allows data tracing and collection by Prometheus (https://prometheus.io/) of various internal nodeos metrics.

Supported metrics are :

| Metric Type | Metric Description |
--------------|---------------------
| `Gauge` | Number of clients |
| `Gauge` | Number of peers |
| `Gauge` | Number of dropped blocks |
| `Gauge` | Unapplied transaction queue sizes (number of transactions) |
| `Counter` | Blacklisted transactions count (total) |
| `Counter` | Blocks produced |
| `Counter` | Transactions produced |
| `Gauge` | Last irreversible |
| `Gauge` | Current head block num |
| `Gauge` | Subjective billing number of accounts |
| `Gauge` | Subjective billing number of blocks |
| `Gauge` | Scheduled transactions |
| `Gauge` | Number of api calls per api endpoint |

You can enable the plugin via: `--plugin eosio::prometheus_plugin`.
When enabled the plugin adds http endpoint: /v1/prometheus/metrics which returns prometheus formatted text strings.
