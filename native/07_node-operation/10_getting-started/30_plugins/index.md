---
title: Plugins
---

`nodeos` uses plugins to enhance its core capabilities. While certain plugins like `chain_plugin`, `net_plugin`, and `producer_plugin` are essential and integral to the modular operation of `nodeos`, there are other optional plugins that offer additional features that extend the functionality of a given node.

To learn more about specific plugins, please choose from the following list:

* [`chain_api_plugin`](chain_api_plugin/index.md)
* [`chain_plugin`](chain_plugin/index.md)
* [`db_size_api_plugin`](db_size_api_plugin/index.md)
* [`http_plugin`](http_plugin/index.md)
* [`net_api_plugin`](net_api_plugin/index.md)
* [`net_plugin`](net_plugin/index.md)
* [`producer_api_plugin`](producer_api_plugin/index.md)
* [`producer_plugin`](producer_plugin/index.md)
* [`prometheus_plugin`](prometheus_plugin/index.md)
* [`resource_monitor_plugin`](resource_monitor_plugin/index.md)
* [`signature_provider_plugin`](signature_provider_plugin/index.md)
* [`state_history_plugin`](state_history_plugin/index.md)
* [`test_control_api_plugin`](test_control_api_plugin/index.md)
* [`test_control_plugin`](test_control_plugin/index.md)
* [`trace_api_plugin`](trace_api_plugin/index.md)

> ℹ️ `nodeos` plugins provide incremental functionality to the EOS core blockchain. In contrast to runtime plugins, `nodeos` plugins are built and baked into the `nodeos` binary during the compilation process.
