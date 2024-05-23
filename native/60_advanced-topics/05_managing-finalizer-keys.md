---
title: Managing Finalizer Keys
---

The Savanna Consensus algorithm utilized by Spring v1 separates the roles of publishing blocks from signing and finalizing blocks. Finalizer Keys are needed to sign and finalize blocks. In Spring v1, all block producers are expected to be finalizers.

## Recommended Setup
The recommendation is to generate several finalizer keys. Generate one for each primary and backup node producer instance you plan on running. It is recommended to have only one active finalizer key for each producer. When switching over to a backup production node you may switch out your registered finalizer key to match the new instance coming online. When the keys are generated ahead of time, and included in the configuration, only a system action is needed to register a new key.

If the database is dirty or corrupted the fastest way to re-start is from a snapshot with the same finalizer key and the same `finalizers/safety.dat`. This fast restart method is similar to previous versions of Leap software.
- remove state `state/shared_memory.bin` and perhaps `blocks/blocks.log`
- restart from snapshot
- wait for node to catch up

A full recovery is more involved and it included using a different finalizer key.
- remove state `state/shared_memory.bin` and perhaps `blocks/blocks.log`
- remove `finalizers/safety.dat`
- restart from snapshot
- use a new finalizer key, is `actfinkey` to activate a previously registered finalizer key
- wait for node to catch up

## Generating and Registering Finalizer Keys

### Importance of Finalizer Safety
Savanna consensus introduces a new file that captures the history of finalizer voting. By default the file `finalizers/safety.dat` and is found under the data directory. If `finalizers/safety.dat` is corrupted or removed, the voting history for the active key will be lost. Therefore when `finalizers/safety.dat` is un-useable a different BLS finalizer key should be activated.

There is a new configuration option `finalizers-dir` that can change the location of the `safety.dat` file. A node operator may want to change the location of `safety.dat`, if they want to move this important file out of the nodeos default data directory.

### Generate Finalizer Keys
`spring-utils` is the utility designated for node operators. Only node operators need to generate a BLS finalizer key, and for that reason we use `spring-utils` to generate the finalizer keys. Keys may be output to console (`--to-console`) or to file (`--file`).
```
spring-util bls create key --to-console > producer-name.finalizer.key
```
The output will look like this
```
Private key: PVT_BLS_9-9ziZZzZcZZoiz-ZZzUtz9ZZ9u9Zo9aS9BZ-o9iznZfzUZU
Public key: PUB_BLS_SvLa9z9kZoT9bzZZZ-Zezlrst9Zb-Z9zZV9olZazZbZvzZzk9r9ZZZzzarUVzbZZ9Z9ZUzf9iZZ9P_kzZZzGLtezL-Z9zZ9zzZb9ZitZctzvSZ9G9SUszzcZzlZu-GsZnZ9I9Z
Proof of Possession: SIG_BLS_ZPZZbZIZukZksBbZ9Z9Zfysz9zZsy9z9S9V99Z-9rZZe99vZUzZPZZlzZszZiiZVzT9ZZZZBi99Z9kZzZ9zZPzzbZ99ZZzZP9zZrU-ZZuiZZzZUvZ9ZPzZbZ_yZi9ZZZ-yZPcZZe9SZZPz9Tc9ZaZ999voB99L9PzZ99I9Zu9Zo9ZZZzTtVZbcZ-Zck_ZZUZZtfTZGszUzzBTZZGrnIZ9Z9Z9zPznyZLZIavGzZunreVZ9zZZt_ZlZS9ZZIz9yUZa9Z9-Z
```

### Add Finalizer Keys to Config
You may add several finalizer keys to configuration. **NOTE** Instances of nodeos must be restarted to pick up the new configuration options. Keys are added to configuration with the `signature-provided` option. These keys may be added via the command line or placed into a configuration file. Placing the finalizer keys into a configuration file would look like this.
`signature-provider = PUBLIC_KEY=KEY:PRIVATE_KEY`
For example
`signature-provider = PUB_BLS_SvLa9z9kZoT9bzZZZ-Zezlrst9Zb-Z9zZV9olZazZbZvzZzk9r9ZZZzzarUVzbZZ9Z9ZUzf9iZZ9P_kzZZzGLtezL-Z9zZ9zzZb9ZitZctzvSZ9G9SUszzcZzlZu-GsZnZ9I9Z=KEY:PVT_BLS_9-9ziZZzZcZZoiz-ZZzUtz9ZZ9u9Zo9aS9BZ-o9iznZfzUZU`

### Register Finalizer Key
Each producer should register a finalizer key. This is done with the `regfinkey`. No other actions are needed when registering your first key.
-  **Note** the authority used is the block producer's.
- `finalizer_name` must be a registered producer.
- `finalizer_key` must be in base64url format.
- `proof_of_possession` must be a valid of proof of possession signature `finalizer_name` to register.
- `linkauth` may be used to allow a lower authority to execute this action.

Here is an example
```
cleos push action eosio regfinkey '{"finalizer_name":"NewBlockProducer", \
      "finalizer_key":"PUB_BLS_SvLa9z9kZoT9bzZZZ-Zezlrst9Zb-Z9zZV9olZazZbZvzZzk9r9ZZZzzarUVzbZZ9Z9ZUzf9iZZ9P_kzZZzGLtezL-Z9zZ9zzZb9ZitZctzvSZ9G9SUszzcZzlZu-GsZnZ9I9Z", \
      "proof_of_possession":"SIG_BLS_ZPZZbZIZukZksBbZ9Z9Zfysz9zZsy9z9S9V99Z-9rZZe99vZUzZPZZlzZszZiiZVzT9ZZZZBi99Z9kZzZ9zZPzzbZ99ZZzZP9zZrU-ZZuiZZzZUvZ9ZPzZbZ_yZi9ZZZ-yZPcZZe9SZZPz9Tc9ZaZ999voB99L9PzZ99I9Zu9Zo9ZZZzTtVZbcZ-Zck_ZZUZZtfTZGszUzzBTZZGrnIZ9Z9Z9zPznyZLZIavGzZunreVZ9zZZt_ZlZS9ZZIz9yUZa9Z9-Z"}' \
      -p NewBlockProducer
```

### Changing Finalizer Key
To activate a different BLS finalizer key call the `actfinkey` action.
- The provided finalizer_key must be a registered finalizer key in base64url format.
- The authority is the authority of `finalizer_name`.

First register your new key with `cleos push action eosio regfinkey ...`. Then call `actfinkey` with the Public Key of the non-activated, and registered key.

Example
```
cleos push action eosio actfinkey '{"finalizer_name":"NewBlockProducer", \
      "finalizer_key":"PUB_BLS_SvLa9z9kZoT9bzZZZ-Zezlrst9Zb-Z9zZV9olZazZbZvzZzk9r9ZZZzzarUVzbZZ9Z9ZUzf9iZZ9P_kzZZzGLtezL-Z9zZ9zzZb9ZitZctzvSZ9G9SUszzcZzlZu-GsZnZ9I9Z"}' \
      -p NewBlockProducer
```

### Removing Finalizer Key
To remove a registered finalizer key, you no longer plan on using, call the `delfinkey` action.
- `finalizer_key` must be a registered finalizer key in base64url format.
- `finalizer_key` must not be active, unless it is the last registered finalizer key.
- The authority is the authority of `finalizer_name`.

Example
```
cleos push action eosio delfinkey '{"finalizer_name":"NewBlockProducer", \
      "finalizer_key":"PUB_BLS_SvLa9z9kZoT9bzZZZ-Zezlrst9Zb-Z9zZV9olZazZbZvzZzk9r9ZZZzzarUVzbZZ9Z9ZUzf9iZZ9P_kzZZzGLtezL-Z9zZ9zzZb9ZitZctzvSZ9G9SUszzcZzlZu-GsZnZ9I9Z"}' \
      -p NewBlockProducer
```

### Verifying Finalizer Keys
Active finalizer keys are stored in the `finkeys` table. This table can be accessed via cleos. The following request will show the active public BLS key for each producer.
`cleos get table eosio eosio finkeys`

To see all finalizer keys including non-active keys check the `finalizers` table.
`cleos get table eosio eosio finalizers`

## New Configuration Options  
The configuration options specific to managing finality. It is recommended to use the default values and not set custom configurations.

- `finalizers-dir` - Specifies the directory path for storing voting history. Node Operators may want to specify a directory outside of their nodeos' data directory, and manage this as distinct file.
- `finality-data-history` - When running SHiP to support Inter-Blockchain Communication (IBC) set `finality-data-history = true`. This will enable the new field, `get_blocks_request_v1`. The `get_blocks_request_v1` defaults to `null` before Savanna Consensus is activated.
- `vote-threads` - Sets the number of threads to handle voting. The default is sufficient for all know production setups, and the recommendation is to leave this value unchanged.
