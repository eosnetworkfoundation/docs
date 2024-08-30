---
title: Rotate BLS Finalizer Keys
---

This document is a step by step guide to switching out your active on-chain finalizer keys. You may register as many finalizer keys as you would like.

### Create and Configure Additional Key
Next we will create a new finalizer key, add it to nodoes' configuration, and register the key. In this example we are creating one key, you may create many keys.

Keys may be output to console (`--to-console`) or to file (`--file`).
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
Create an **additional** configuration. You should have multiple `signature-provider` configurations with different BLS keys. One entry will match your currently used BLS key.

Formate
`signature-provider = PUBLIC_KEY=KEY:PRIVATE_KEY`
For example
`signature-provider = PUB_BLS_Se0dH9PzeGQaYHJ1F44qVNcGR2XXTiF5HcAO5rXjYxDutIckoWjRPoY2gBTFfvAA7g8H0Ce7__7yQ0BUFMQUBBWX6Y4ERasyhh8QHxCVXK9JZOw0ICNWPxXIJD_UDmILQ0kouA`
`signature-provider = PUB_BLS_vRf3BzXJ64F4hV_XrfC0ooIehDUFVnobOUxEgb1JUai_tVfgp4tM0DnDNqza2kYKgrSJgXr1xWgt3dzn7VrzzwGH9QJYbvTWvcpDZ-sNpXVYhFUA6o3apUD3oRGRmwAZjIhxLg`

### Restart Nodeos
Retart nodeos instance to load the key.

### Register On-Chain Actions
Check your existing finalizer keys
```
cleos get table --limit 100 eosio eosio finkeys | jq .rows[] | jq  'select (.finalizer_name=="producert-name")'
```

You should **not** see your newly created key. Lets register the new key.

```
cleos push action eosio regfinkey '{"finalizer_name":"producer-name",
      "finalizer_key":"PUB_BLS_Se0dH9PzeGQaYHJ1F44qVNcGR2XXTiF5HcAO5rXjYxDutIckoWjRPoY2gBTFfvAA7g8H0Ce7__7yQ0BUFMQUBBWX6Y4ERasyhh8QHxCVXK9JZOw0ICNWPxXIJD_UDmILQ0kouA",
      "proof_of_possession":"SIG_BLS_yenZIv6kbim2W1zntl73wxcSNWHFJS1DuMH7qAUFyCKOGBYWZXZYJb7MCr7503ULWiJTAwLUyjmSbXPw38BW9n6UE8r6MpjYKgxlSI2Ezuwzp-18sy_6StHbisSNLl0GtxmJ987ouO8gMvUDUO68cHhMbjRh9j2L790k4gCQS8gPON9OJgiIY9JgYraTB04FyAdpmc_3JCauU4nSwo3xYjS9NUVqgbuJR2lbQDjTPp5VR3z5OrOrNhaw2tewIkEJyxeZmg"}'
      -p producer-name
```

Recheck your existing finalizer keys , now the key should be listed
```
cleos get table --limit 100 eosio eosio finkeys | jq .rows[] | jq  'select (.finalizer_name=="producert-name")'
```

### Activate On-Chain Action
Use cleos to find your current finalizer key. Make a note of the key, so we can verify it changes at the end of this key rotation.
```
cleos get table --limit 100 eosio eosio finalizers | jq .rows[] | jq  'select (.finalizer_name=="producer_name")'.active_key_binary
```

Rotate to the new key with the `actfinkey` action.
```
cleos push action eosio actfinkey '{"finalizer_name":"producer-name",
      "finalizer_key":"PUB_BLS_Se0dH9PzeGQaYHJ1F44qVNcGR2XXTiF5HcAO5rXjYxDutIckoWjRPoY2gBTFfvAA7g8H0Ce7__7yQ0BUFMQUBBWX6Y4ERasyhh8QHxCVXK9JZOw0ICNWPxXIJD_UDmILQ0kouA"}'
      -p producer-name
```

The key has been rotated and the value should change.
```
cleos get table --limit 100 eosio eosio finalizers | jq .rows[] | jq  'select (.finalizer_name=="producer_name")'.active_key_binary
```

### Finalizer Policy Change
Check your nodeos logs for a message indicating the Finalizer Policy has changed.
```
grep -i "finalizer policy" my.log
```
Should see two log lines like this
```
info  2024-06-04T18:17:04.133 nodeos    block_header_state.cpp:185    finish_next          ] Finalizer policy generation change: 1 -> 2
info  2024-06-04T18:17:04.133 nodeos    block_header_state.cpp:187    finish_next          ] New finalizer policy becoming active in block 00002e8d6c84a48932f1b99930c3d3074c7891a6d3fa176959c4b40f5969ba6f: {"generation":2,"threshold":3,"finalizers":[{"description":"producer1","weight":1,"public_key":"PUB_BLS_..."},{"description":"producer2","weight":1,"public_key":"PUB_BLS_..."},{"description":"producer3","weight":1,"public_key":"PUB_BLS_..."}]}
```
