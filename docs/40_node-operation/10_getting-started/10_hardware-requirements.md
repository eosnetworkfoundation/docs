---
title: Hardware Requirements
sidebar_class_name: sidebarhidden
---

The hardware requirements for each type of EOS node can vary depending on factors such as network size, transaction volume, and the number of concurrent users. However, here are some general guidelines for the hardware requirements of different EOS node types:

## API Node without Block Log

The minimum, starting point, for an API node, without maintaining block logs, is the following:

- CPU: 2 cores >= 3.7 Ghz
- RAM: 16 GB RAM and 16 GB swap
- HDD: 1024 GB
- Internet network link: 100Mb/s

> ⚠ Be aware, the above configuration will face problems if suddenly RAM usage on the network increased over that 32GB mark. Also this setup is 50/50 RAM/swap and occasionally will respond slow on some requests due to swapping.

The optimal configuration at the time of writing this document, June the 12th 2023, for an API node without block logs is:

- CPU: 4 cores >= 3.8 Ghz
- RAM: 64 GB
- HDD: 1024 GB
- Internet network link: >= 100Mb/s

> ℹ️ For API nodes, in general you do not want too high CPU speeds (>= 5 Ghz), since it will skew subjective billing lower and run into edge cases where the API thinks a transaction is fine, accepts it, tells the user success, and then the transaction ends up getting rejected upstream by a slower CPU.

## API Node with Blocks Log

- CPU: 4 cores >= 3.8 Ghz
- RAM: 64 GB
- HDD: 4096 GB
- Internet network link: >= 100Mb/s

## State History Node

For state history node you need even more HDD space than the API node with blocks log:

- CPU: 4 cores >= 3.8 Ghz
- RAM: 64 GB
- HDD: 5120 GB
- Internet network link: >= 100Mb/s

## Use `tmpfs` File System

One common, and most efficient strategy that applies to all nodes, is the use of the `tmpfs` files system. This strategy says to mount the node state folder into a `tmpfs` partition. This normally requires a large swap partition in addition to at least 32GB RAM.

> ℹ️ The `tmpfs` file system keeps all of its files in virtual memory. Everything in `tmpfs` is temporary in the sense that no files will be created on your hard drive. If you unmount a `tmpfs` instance, everything stored therein is lost.
