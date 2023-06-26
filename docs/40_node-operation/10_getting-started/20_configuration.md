---
title: Configuration
sidebar_class_name: sidebarhidden
---

## Config.ini

`config.ini` is the configuration file that governs how a `nodeos` instance will function. Therefore, the `config.ini` file has a direct impact on the operation of the node. Most node operators edit and customize this file to assign specific roles to their nodes.

> i `nodeos` can be configured using either CLI options or the `config.ini` file. Nodeos-specific options, on the other hand, can only be specified through the command line. To view all available CLI options and `config.ini` options, launch "nodeos --help" from a terminal.

Every option in the `config.ini` file can also be specified as a CLI option. For instance, the `plugin = <PLUGIN-NAME>` option in the `config.ini` file can also be configured by passing the `--plugin <PLUGIN-NAME>` CLI option. However, the reverse is not true: not every CLI option has an equivalent entry in the `config.ini` file. For example, specific actions performed by plugin-specific options, like `--delete-state-history` from the `state_history_plugin`, cannot be specified in the `config.ini` file.

> ℹ️ Most node operators prefer to use the `config.ini` file instead of CLI options. This is because the `config.ini` will retain the configuration state in the file, unlike CLI options specified when launching `nodeos`.

To use a custom `config.ini` file, specify its filename by passing the `--config arg` option when launching `nodeos`. The custom filename is relative to the actual path of the `config.ini` file specified in the `--config-dir arg` option.

## Plugins

## CORS
