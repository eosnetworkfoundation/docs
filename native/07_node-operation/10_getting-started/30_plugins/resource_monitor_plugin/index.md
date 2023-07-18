---
title: resource_monitor_plugin
---

## Overview

The `resource_monitor_plugin` is responsible for monitoring the usage of storage space in the computing system where `nodeos` is active. Specifically, at regular intervals of `resource-monitor-interval-seconds`, it calculates the amount of space utilized by each of the file systems connected to `data-dir`, `state-dir`, `blocks-log-dir`, `snapshots-dir`, `state-history-dir`, and `trace-dir`. If the space usage in any of the monitored file systems is within `5%` of the threshold specified by `resource-monitor-space-threshold`, a warning message is displayed, indicating the file system path and the percentage of space used. If the space usage surpasses this threshold, the behavior depends on whether `resource-monitor-not-shutdown-on-threshold-exceeded` is enabled or not. If it is disabled, `nodeos` will gracefully shut down; if it is enabled, `nodeos` will periodically issue warnings until the space usage drops below the threshold.

The `resource_monitor_plugin` is loaded automatically when the corresponding `nodeos` instance starts.

## Usage

```console
# config.ini
plugin = eosio::resource_monitor_plugin
[options]
```
```sh
# command-line
nodeos ... --plugin eosio::resource_monitor_plugin [options]
```

## Configuration Options

These can be specified from both the `nodeos` command-line or the `config.ini` file:

```console
Config Options for eosio::resource_monitor_plugin:
  --resource-monitor-interval-seconds arg (=2)
                                        Time in seconds between two consecutive
                                        checks of resource usage. Should be
                                        between 1 and 300
  --resource-monitor-space-threshold arg (=90)
                                        Threshold in terms of percentage of
                                        used space vs total space. If used
                                        space is above (threshold - 5%), a
                                        warning is generated. Unless
                                        resource-monitor-not-shutdown-on-thresh
                                        old-exceeded is enabled, a graceful
                                        shutdown is initiated if used space is
                                        above the threshold. The value should
                                        be between 6 and 99
  --resource-monitor-space-absolute-gb arg
                                        Absolute threshold in gibibytes of
                                        remaining space; applied to each
                                        monitored directory. If remaining space
                                        is less than value for any monitored
                                        directories then threshold is
                                        considered exceeded.Overrides
                                        resource-monitor-space-threshold value.
  --resource-monitor-not-shutdown-on-threshold-exceeded
                                        Used to indicate nodeos will not
                                        shutdown when threshold is exceeded.
  --resource-monitor-warning-interval arg (=30)
                                        Number of resource monitor intervals
                                        between two consecutive warnings when
                                        the threshold is hit. Should be between
                                        1 and 450
```

## Plugin Dependencies

* None
