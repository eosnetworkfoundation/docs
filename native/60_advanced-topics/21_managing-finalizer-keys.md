---
title: Managing Finalizer Keys
---

Review [Introduction to Finalizers and Voting](../introduction-finalizers-voting) for additional background. See How To [Rotate BLS Finalizer Keys](../../node-operation/tutorials/Rotate-BLS-Finalizer-Keys) for specific instructions on moving to new finalizer keys. The Savanna Consensus algorithm utilized by Spring v1 separates the roles of publishing blocks from signing and finalizing blocks. Finalizer Keys are needed to sign and finalize blocks. In Spring v1, all block producers are expected to be finalizers.

## Recommended Setup
The recommendation is to generate, and register several finalizer keys. It is recommended to have one finalizer key for each instance of a producer node. A producer may have only one active finalizer key. When the keys are generated ahead of time, and included in the configuration, only an on-chain action is needed to use a new finalizer key.

### Takeaways
- It is always safe to activate a new BLS finalizer key.
- Do not reuse BLS finalizer keys between hosts.
- Generate unique BLS finalizer keys for each nodeos instance.
- Keys are activated with an on-chain action, *keys must be pre-generated and registered*.
- `safety.dat` must contain the full voting history for the BLS finalizer key in use.  

### Multiple Instances of Nodeos
Consider the scenario where there are two hosts running nodeos. One host contains the primary block producer, the other host has the backup block producer. The recommendation is each instance of nodeos (primary producer and backup-producer) have distinct BLS finalizer keys. This requires creating and registering two BLS finalizer key pairs. The signature provider for each nodeos will reference one and only one BLS key. It is recommended that the signature provider in the primary producer node reference a different BLS finalizer key from the signature provider on the backup producer node.

When switching to the backup node, run the usual scripts, and in addition activate the BLS finalizer key referenced in the signature provider configuration for the backup producer node. When switching back from the backup producer node to the primary producer node, in addition to running the usual scripts, you must active the BLS finalizer key associated with the primary block producer.

If the same BLS finalizer key is used when switching between producers the voting history will not be complete. As a result the associated producer will vote for a different branch of the blockchain, out of sync with the correct state of the blockchain.

### Multiple Producers on a Single Instance
Consider the scenario when there are multiple producers on a single instance of nodeos. The recommendation is to create, register, and activate a single finalizer keys for the nodeos instance. Only one producer needs to register the finalizer key.

### Intermediate Relay Nodes
Setting `vote-threads` on a nodeos instance is expensive, consuming CPU and adding to network traffic. For this reason, `vote-threads` is set to a non-zero on node producer instances, but set to zero on all other instances.

Block Producers may have an intermediate nodeos instance sitting in between their block producing nodeos and peer finalizers. In this setup each nodeos, local finalizer, intermediate node, and peer finalizer, must be able to send and forward votes. With this setup there would be a BLS finalizer key for the block producing nodes. The intermediate node would not need a BLS finalizer key. The intermediate node must set their `vote-threads` > 0 *default in Spring v1 is 4 threads*.

### Rotating Keys
The EOS blockchain, allows producers to activate new BLS finalizer keys at anytime with an on-chain action `actfinkey`. Before called the `actfinkey` action, the key must already exist in the `signature-provider` configuration when the instance of nodeos is started, and the key must be registered using the `regfinkey` action. Activating a new BLS finalizer key is always safe, and may be performed at anytime.

See How To [Rotate BLS Finalizer Keys](../../node-operation/tutorials/Rotate-BLS-Finalizer-Keys) for specific instructions on moving to new finalizer keys

## Recovery
If the database is dirty or corrupted the fastest way to re-start is from a snapshot with the same finalizer key and the same `finalizers/safety.dat`. This fast restart method is similar to previous versions of Leap software.
- remove state `state/shared_memory.bin` and perhaps `blocks/blocks.log`
- restart from snapshot
- wait for node to catch up

A full recovery is more involved and it included using a different finalizer key. Use these steps when the `finalizers/safety.dat` is corrupted or missing.
- remove state `state/shared_memory.bin` and perhaps `blocks/blocks.log`
- remove `finalizers/safety.dat`
- restart from snapshot
- use a new finalizer key, `actfinkey` to activate a previously registered finalizer key
- wait for node to catch up

## Generating and Registering Finalizer Keys

### Importance of Finalizer Safety
Savanna consensus introduces a new file that captures the history of finalizer voting. See [Introduction to Finalizers and Voting](../introduction-finalizers-voting) for more background on voting history and the role of the `finalizers/safety.dat` file. By default the file `finalizers/safety.dat` is found under the data directory. `finalizers/safety.dat` must have the full voting history for the BLS finalizer key that is in use. If `finalizers/safety.dat` is corrupted, removed, or lacks the full voting history for the BLS finalizer key in use, a new BLS finalizer key must be used.

Spring v1 introduces a new configuration option `finalizers-dir` that can change the location of the `safety.dat` file. A node operator may want to change the location of `safety.dat`, if they want to move this important file out of the nodeos default data directory.

### Pre-Generating Finalizer Keys
It is safe to generate many BLS finalizer keys and register them ahead of their use and activation. Registration includes:
- Creating the BLS key pair
- Adding the key pair to configuration via `signature-provider`, this requires a restart of nodeos
- Calling on-chain `regfinkey` action

### Generate Finalizer Keys
`spring-utils` is the utility designated for node operators. Only node operators need to generate a BLS finalizer key, and for that reason we use `spring-utils` to generate the finalizer keys. Keys may be output to console (`--to-console`) or to file (`--file`).
```
spring-util bls create key --to-console > producer-name.finalizer.key
```
The output will look like this
```
Private key: PVT_BLS_9-9ziZZzZcZZoiz-ZZzUtz9ZZ9u9Zo9aS9BZ-o9iznZfzUZU
Public key: PUB_BLS_Se0dH9PzeGQaYHJ1F44qVNcGR2XXTiF5HcAO5rXjYxDutIckoWjRPoY2gBTFfvAA7g8H0Ce7__7yQ0BUFMQUBBWX6Y4ERasyhh8QHxCVXK9JZOw0ICNWPxXIJD_UDmILQ0kouA
Proof of Possession: SIG_BLS_yenZIv6kbim2W1zntl73wxcSNWHFJS1DuMH7qAUFyCKOGBYWZXZYJb7MCr7503ULWiJTAwLUyjmSbXPw38BW9n6UE8r6MpjYKgxlSI2Ezuwzp-18sy_6StHbisSNLl0GtxmJ987ouO8gMvUDUO68cHhMbjRh9j2L790k4gCQS8gPON9OJgiIY9JgYraTB04FyAdpmc_3JCauU4nSwo3xYjS9NUVqgbuJR2lbQDjTPp5VR3z5OrOrNhaw2tewIkEJyxeZmg
```

### Add Finalizer Keys to Config
You may add several finalizer keys to configuration. **NOTE** Instances of nodeos must be restarted to pick up the new configuration options. Keys are added to configuration with the `signature-provider` option. These keys may be added via the command line or placed into a configuration file. Placing the finalizer keys into a configuration file would look like this.
`signature-provider = PUBLIC_KEY=KEY:PRIVATE_KEY`
For example
`signature-provider = PUB_BLS_Se0dH9PzeGQaYHJ1F44qVNcGR2XXTiF5HcAO5rXjYxDutIckoWjRPoY2gBTFfvAA7g8H0Ce7__7yQ0BUFMQUBBWX6Y4ERasyhh8QHxCVXK9JZOw0ICNWPxXIJD_UDmILQ0kouA`

### Register Finalizer Key
Each producer should register a finalizer key. This is done with the `regfinkey`. No other actions are needed when registering your first key.
-  **Note** the authority used is the block producer's.
- `finalizer_name` must be a registered producer.
- `finalizer_key` must be in base64url format.
- `proof_of_possession` must be a valid of proof of possession signature `finalizer_name` to register.
- `linkauth` may be used to allow a lower authority to execute this action.

Here is an example
```
cleos push action eosio regfinkey '{"finalizer_name":"NewBlockProducer",
      "finalizer_key":"PUB_BLS_Se0dH9PzeGQaYHJ1F44qVNcGR2XXTiF5HcAO5rXjYxDutIckoWjRPoY2gBTFfvAA7g8H0Ce7__7yQ0BUFMQUBBWX6Y4ERasyhh8QHxCVXK9JZOw0ICNWPxXIJD_UDmILQ0kouA",
      "proof_of_possession":"SIG_BLS_yenZIv6kbim2W1zntl73wxcSNWHFJS1DuMH7qAUFyCKOGBYWZXZYJb7MCr7503ULWiJTAwLUyjmSbXPw38BW9n6UE8r6MpjYKgxlSI2Ezuwzp-18sy_6StHbisSNLl0GtxmJ987ouO8gMvUDUO68cHhMbjRh9j2L790k4gCQS8gPON9OJgiIY9JgYraTB04FyAdpmc_3JCauU4nSwo3xYjS9NUVqgbuJR2lbQDjTPp5VR3z5OrOrNhaw2tewIkEJyxeZmg"}'
      -p NewBlockProducer
```

### Changing Finalizer Key
To activate a different BLS finalizer key call the `actfinkey` action.
- The provided finalizer_key must be a registered finalizer key in base64url format.
- The authority is the authority of `finalizer_name`.

First register your new key with `cleos push action eosio regfinkey ...`. Then call `actfinkey` with the Public Key of the non-activated, and registered key.

Example
```
cleos push action eosio actfinkey '{"finalizer_name":"NewBlockProducer",
      "finalizer_key":"PUB_BLS_Se0dH9PzeGQaYHJ1F44qVNcGR2XXTiF5HcAO5rXjYxDutIckoWjRPoY2gBTFfvAA7g8H0Ce7__7yQ0BUFMQUBBWX6Y4ERasyhh8QHxCVXK9JZOw0ICNWPxXIJD_UDmILQ0kouA"}'
      -p NewBlockProducer
```

### Removing Finalizer Key
To remove a registered finalizer key, you no longer plan on using, call the `delfinkey` action.
- `finalizer_key` must be a registered finalizer key in base64url format.
- `finalizer_key` must not be active, unless it is the last registered finalizer key.
- The authority is the authority of `finalizer_name`.

Example
```
cleos push action eosio delfinkey '{"finalizer_name":"NewBlockProducer",
      "finalizer_key":"PUB_BLS_Se0dH9PzeGQaYHJ1F44qVNcGR2XXTiF5HcAO5rXjYxDutIckoWjRPoY2gBTFfvAA7g8H0Ce7__7yQ0BUFMQUBBWX6Y4ERasyhh8QHxCVXK9JZOw0ICNWPxXIJD_UDmILQ0kouA"}'
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
- `vote-threads` - Sets the number of threads to handle voting. It is recommended to set to `vote-threads = 4` for all block producer and relay nodes. Pure API nodes or SHiP only nodes can remain with the default of 0 `vote-threads`

## Avoid
Review [Introduction to Finalizers and Voting](../introduction-finalizers-voting) for additional background. Each of the following is likely to lead to voting on a different branch of the blockchain, and therefore votes will not contribute to finality. For best results do **NOT** the following:
- share `safety.dat` between hosts or producers
- reuse BLS finalizer keys between hosts
- backup and restore `safety.dat`

## FAQ
- Q: Should I backup and restore `safety.dat`?
- A: No you should switch to a new BLS finalizer key, that is a much easier and safer way to continue voting. Otherwise you run the risk of restoring a partial voting history, and voting on the incorrect branch of the chain.

- Q: When I want to switch producer hosts, can I keep using the same BLS Finalizer Key, and copy over my `safety.dat` to the new host?
- A: Yes this would work, but it is not recommended. Voting is continuous, and using a new BLS key takes an on-chain action. Therefore, it is best to switch over to a new BLS key assuming that results in less voting downtime.

- Q: Why use BLS keys, why not re-use the existing producer keys?
- A: BLS signatures are very cheap to aggregate together into a single message, and this property makes them a good choice for aggregating together votes from many different finalizers.
