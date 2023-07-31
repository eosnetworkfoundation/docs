---
title: Software
---

Each node on the EOS network runs the same software called `nodeos`. The software can be configured for each node to serve a different role on the EOS network. Some nodes produce blocks, others relay blocks and transactions, others respond to API requests, others provide historical chain data, etc.

> i `nodeos` is part of the Leap software suite. It is the software that fuels every node of the EOS network. `nodeos` functions as a command line interface (CLI) application, allowing users to start it either manually through the command line or automatically using a script.

The behavior of `nodeos` primarily depends on the active plugins and the options associated with those plugins. `nodeos` provides two distinct sets of options:

* nodeos-specific options
* plugin-specific options

### Nodeos-specific options

Nodeos-specific options exist primarily for administrative tasks, such as specifying the chain data directory, indicating the `config.ini` file, setting the logging configuration file's name and path, and so on. For the actual list of nodeos-specific options, run `nodeos --help` from the terminal and find the *Application Command Line Options* section at the end.

### Plugin-specific options

Plugin-specific options and the applicable plugins govern the actual behavior of the node. Each plugin-specific option has a distinct name, enabling it to be specified in any order within the command line or the `config.ini` file. When providing plugin-specific options, it is necessary to enable the corresponding plugin using the `--plugin option`, or else the related options will be discarded.

> i To install the EOS node software, visit the *Binary Installation* section or the *Build and Install from Source* section within the [Leap](https://github.com/AntelopeIO/leap/blob/release/4.0/README.md) github project.
