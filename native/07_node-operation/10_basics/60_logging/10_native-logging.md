---
title: Native Logging
---

The logging mechanism for `nodeos` is controlled through the `logging.json` file also known as logging configuration file. The logging configuration file can be used to define [appenders](#appenders) and to tie them to [loggers](#loggers) and [logging levels](#logging-levels).

## Configure logging.json File

The path where the `logging.json` is stored can be explicitly defined using the `-l` or `--logconf` options when starting `nodeos`. By default the `logging.json` file is located in the specified `--config-dir`, the same directory as the `config.ini` file.

## Appenders

The EOS logging library supports two `appender` types:

- [GELF](#gelf) (Graylog Extended Log Format)
- [Console](#console)

### GELF

This `appender` sends the log messages to [`Graylog`](https://github.com/Graylog2/graylog2-server) which is a fully integrated platform for collecting, indexing, and analyzing log messages. The supported configuration options are:

- `name` - arbitrary name to identify instance for use in loggers
- `type` - "gelf"
- `endpoint` - ip address and port number
- `host` - Graylog hostname, identifies you to [Graylog](https://github.com/Graylog2/graylog2-server).
- `enabled` - bool value to enable/disable the appender.

Example:

```json
{
    "name": "net",
    "type": "gelf",
    "args": {
        "endpoint": "104.198.210.18:12202”,
        "host": <YOURNAMEHERE IN QUOTES>
    },
    "enabled": true
}
```

### Console

This `appender` will output log messages to the screen. The supported configuration options are:

- `name` - arbitrary name to identify instance for use in loggers
- `type` - "console"
- `stream` - "std_out" or "std_err"
- `level_colors` - maps a log level to a color, see the following two items as its sub-items:
  - `level` - may be one of ("debug", "info", "warn", "error", "all", "off")
  - `color` - may be one of ("red", "green", "brown", "blue", "magenta", "cyan", "white", "console_default")
- `enabled` - bool value to enable/disable the appender

Example:

```json
{
    "name": "consoleout",
    "type": "console",
    "args": {
    "stream": "std_out",

    "level_colors": [{
        "level": "debug",
        "color": "green"
        },{
        "level": "warn",
        "color": "brown"
        },{
        "level": "error",
        "color": "red"
        }
    ]
    },
    "enabled": true
}
```

## Loggers

The EOS logging library supports the following loggers:

- `default` - the default logger, always enabled.
- `producer_plugin` - detailed logging for the producer plugin.
- `http_plugin` - detailed logging for the http plugin.
- `trace_api` - detailed logging for the trace_api plugin.
- `transaction_success_tracing` - detailed log that emits successful verdicts from relay nodes on the P2P network.
- `transaction_failure_tracing` - detailed log that emits failed verdicts from relay nodes on the P2P network.
- `state_history` - detailed logging for state history plugin.
- `net_plugin_impl` - detailed logging for the net plugin.
- `blockvault_client_plugin` - detailed logging for the blockvault client plugin.

The supported configuration options are:

- `name` - must match one of the names described above.
- `level` - see logging levels below.
- `enabled` - bool value to enable/disable the logger.
- `additivity` - true or false
- `appenders` - list of appenders by name (name in the appender configuration)

Example:

```json
{
    "name": "net_plugin_impl",
    "level": "debug",
    "enabled": true,
    "additivity": false,
    "appenders": [
        "net"
    ]
}
```

> ℹ️ Each logger can be configured independently in the `logging.json` file. The default logging level, for all loggers, if no `logging.json` is provided, is `info`.

## Logging Levels

These are the supported logging levels:

- `all`
- `debug`
- `info`
- `warn`
- `error`
- `off`  

Sample `logging.json`:

```json
{
  "includes": [],
  "appenders": [{
      "name": "stderr",
      "type": "console",
      "args": {
        "stream": "std_error",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ],
        "flush": true
      },
      "enabled": true
    },{
      "name": "stdout",
      "type": "console",
      "args": {
        "stream": "std_out",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ],
        "flush": true
      },
      "enabled": true
    },{
      "name": "net",
      "type": "gelf",
      "args": {
        "endpoint": "10.10.10.10:12201",
        "host": "host_name"
      },
      "enabled": true
    }
  ],
  "loggers": [{
      "name": "default",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr",
        "net"
      ]
    },{
      "name": "net_plugin_impl",
      "level": "info",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr",
        "net"
      ]
    },{
      "name": "http_plugin",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr",
        "net"
      ]
    },{
      "name": "producer_plugin",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr",
        "net"
      ]
    },{
      "name": "transaction_success_tracing",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr",
        "net"
      ]
    },{
      "name": "transaction_failure_tracing",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr",
        "net"
      ]
    },{
      "name": "state_history",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr",
        "net"
      ]
    },{
      "name": "trace_api",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr",
        "net"
      ]
    },{
      "name": "blockvault_client_plugin",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr",
        "net"
      ]
    }
  ]
}
```
