---
title: Plugins
sidebar_class_name: sidebarhidden
---

`nodeos` uses plugins to enhance its core capabilities. While certain plugins like `chain_plugin`, `net_plugin`, and `producer_plugin` are essential and integral to the modular structure of `nodeos`, there are other optional plugins that offer additional features that extend the node's operation.

To learn more about specific plugins, please choose from the following list:

* chain_api_plugin
* chain_plugin
* db_size_api_plugin
* http_client_plugin
* http_plugin
* net_api_plugin
* net_plugin
* producer_api_plugin
* producer_plugin
* prometheus_plugin
* resource_monitor_plugin
* signature_provider_plugin
* state_history_plugin
* test_control_api_plugin
* test_control_plugin
* trace_api_plugin

> ℹ️ `nodeos` plugins provide incremental functionality to the EOS core blockchain. In contrast to runtime plugins, `nodeos` plugins are built and baked into the `nodeos` binary during the compilation process.
