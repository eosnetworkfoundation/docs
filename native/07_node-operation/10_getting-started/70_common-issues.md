---
title: Common Issues
---

## 1. Database Dirty Flag Set Error

The `Database dirty flag set (likely due to unclean shutdown): replay required` error occurs when you do not stop `nodeos` gracefully. If you get this error, your only recourse is to replay by starting `nodeos` with `--replay-blockchain`.
To stop `nodeos` gracefully, send a `SIGTERM`, `SIGQUIT` or `SIGINT` then wait for the process to shutdown.

## 2. Memory Does Not Match Data Error

If you get an error such as `St9exception: content of memory does not match data expected by executable` when `nodeos` starts, try to restart `nodeos` with one of the following options (you can use `nodeos --help` to get the full list of options).

Command Line Options for eosio::chain_plugin:

| Option                     | Description                                                    |
|----------------------------|----------------------------------------------------------------|
| `--force-all-checks`       | do not skip any checks that can be skipped while replaying irreversible blocks |
| `--replay-blockchain`      | clear chain state database and replay all blocks               |
| `--hard-replay-blockchain` | clear chain state database, recover as many blocks as possible from the blocks log, and then replay those blocks |
| `--delete-all-blocks`      | clear chain state database and blocks log                      |

## 3. Could Not Grow Database Error

To solve the `Could not grow database file to requested size` error, start `nodeos` with `--shared-memory-size-mb 1024` option. A 1 GB shared memory file allows approximately half a million transactions.

## 4. 3070000: WASM Exception Error

If you get an error such as `Publishing contract... Error 3070000: WASM Exception Error Details: env.set_proposed_producers_ex unresolveable` when you try to deploy `eosio.bios` contract or `eosio.system` contract in an attempt to boot an EOS blockchain (locally or testnet), you must activate the `PREACTIVATE_FEATURE` protocol first.
