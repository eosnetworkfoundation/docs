#!/bin/bash

echo "+=============================================+"
echo "| Booting and configuring a Local EOS Network |"
echo "+=============================================+"

# key for the default wallet
PUBLIC_KEY=EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
PRIVATE_KEY=5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

DATA_DIR=${1:-"$HOME/eos/data-dir"}
CONTRACTS_DIR=${2:-"$HOME/eos/contracts"}
WALLET_DIR=${2:-"$HOME/eosio-wallet"}
SHORT_SLEEP=0.5

create_account () {
  # cleos is a command line eos tool that interfaces with the REST api exposed by nodeos
  cleos create account eosio $1 $PUBLIC_KEY
  sleep $SHORT_SLEEP
}

pre_activate_feature () {
  # http://127.0.0.1:8888 is the default address for nodeos 
  curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["'$1'"]}'
  sleep $SHORT_SLEEP
}

activate_feature () {
  cleos push action eosio activate '["'$1'"]' -p eosio@active
  sleep $SHORT_SLEEP
} 

deploy_contract () {
  cleos set account permission $1 active --add-code
  sleep $SHORT_SLEEP
  cleos set contract $1 $2
  sleep $SHORT_SLEEP
}

# Cleaning up previous instance data

pkill -f nodeos # try it nicely first
sleep 1
pkill -f -9 nodeos # once more with feeling
rm -rf -r $WALLET_DIR
rm -rf -r $DATA_DIR/blocks
rm -rf -r $DATA_DIR/snapshots
rm -rf -r $DATA_DIR/state
rm -rf -r $DATA_DIR/state-history
rm -rf -r $DATA_DIR/traces

echo
echo "----------------------------------------------"
echo " Launching Nodeos in background with 'screen'"
echo "----------------------------------------------"
echo
echo "View nodeos with the command:"
echo "  screen -r nodeos -p 0"
echo

# nodeos is the core node daemon that is configured with plugins to run a node.
NODEOSCMD="nodeos --delete-all-block --config=$DATA_DIR/config.ini --data-dir=$DATA_DIR --disable-replay-opts\r" 
screen -dmS nodeos                          # create named session in background
screen -S nodeos -p 0 -X stuff "$NODEOSCMD" # run nodeos in background session

echo
echo "Waiting 5 seconds for Nodeos to fully start up"
printf "5..";sleep 1;printf "4..";sleep 1;printf "3..";sleep 1;printf "2..";sleep 1;printf "1..";sleep 1;printf "0\n"

# Wallet setup
echo
echo "---------------------------------------------------"
echo " Using cleos aka 'Command-Line EOS' to communicate"
echo "   with nodeos and create the default wallet"
echo "   (Ignore the 'already unlocked' error)"
echo "---------------------------------------------------"
echo

cleos wallet create --file .wallet.pw
cat .wallet.pw | cleos wallet unlock --password
cleos wallet import --private-key $PRIVATE_KEY

echo
echo "Waiting 5 more seconds"
printf "5..";sleep 1;printf "4..";sleep 1;printf "3..";sleep 1;printf "2..";sleep 1;printf "1..";sleep 1;printf "0\n"
echo

echo "--------------------"
echo " Creating accounts "
echo "--------------------"
create_account "eosio.msig"
create_account "eosio.token"
create_account "eosio.bpay"
create_account "eosio.names"
create_account "eosio.ram"
create_account "eosio.ramfee"
create_account "eosio.saving"
create_account "eosio.stake"
create_account "eosio.vpay"
create_account "eosio.rex"

# PREACTIVATE_FEATURE
pre_activate_feature "0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"
sleep 2

echo "Deploying boot contract"
deploy_contract "eosio" "contracts/eosio.boot"

echo
echo "---------------------"
echo " Activating features"
echo "---------------------"
# ACTION_RETURN_VALUE
activate_feature "c3a6138c5061cf291310887c0b5c71fcaffeab90d5deb50d3b9e687cead45071"
# GET_CODE_HASH
activate_feature "bcd2a26394b36614fd4894241d3c451ab0f6fd110958c3423073621a70826e99"
# GET_BLOCK_NUM
activate_feature "35c2186cc36f7bb4aeaf4487b36e57039ccf45a9136aa856a5d569ecca55ef2b"
# CRYPTO_PRIMITIVES	
activate_feature "6bcb40a24e49c26d0a60513b6aeb8551d264e4717f306b81a37a5afb3b47cedc"
# CONFIGURABLE_WASM_LIMITS2
activate_feature "d528b9f6e9693f45ed277af93474fd473ce7d831dae2180cca35d907bd10cb40"
# BLOCKCHAIN_PARAMETERS
activate_feature "5443fcf88330c586bc0e5f3dee10e7f63c76c00249c87fe4fbf7f38c082006b4"
# GET_SENDER
activate_feature "f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"
# FORWARD_SETCODE
activate_feature "2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"
# ONLY_BILL_FIRST_AUTHORIZER
activate_feature "8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"
# RESTRICT_ACTION_TO_SELF
activate_feature "ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"
# DISALLOW_EMPTY_PRODUCER_SCHEDULE
activate_feature "68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"
# FIX_LINKAUTH_RESTRICTION
activate_feature "e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"
# REPLACE_DEFERRED
activate_feature "ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"
# NO_DUPLICATE_DEFERRED_ID
activate_feature "4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"
# ONLY_LINK_TO_EXISTING_PERMISSION
activate_feature "1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"
# RAM_RESTRICTIONS
activate_feature "4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"
# WEBAUTHN_KEY
activate_feature "4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"
# WTMSIG_BLOCK_SIGNATURES
activate_feature "299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"

# ensure features are activated before deploying additional contracts
sleep 2

echo
echo "--------------------------------"
echo " Deploying additional contracts"
echo "--------------------------------"
deploy_contract "eosio.msig" "contracts/eosio.msig"
deploy_contract "eosio.token" "contracts/eosio.token"
deploy_contract "eosio" "contracts/eosio.system"

echo
echo "-----------------------------"
echo " Creating and issuing tokens"
echo "-----------------------------"
cleos push action eosio.token create '["eosio", "10000000000.0000 EOS"]' -p eosio.token@active
cleos push action eosio.token issue '["eosio", "1000000000.0000 EOS", "memo"]' -p eosio@active
cleos push action eosio init '["0","4,EOS"]' -p eosio@active

echo
echo "+==========+"
echo "| Finished |"
echo "+==========+"
echo "Optionally connect to nodeos screen with:"
echo "  screen -r nodeos -p 0"
echo "(Use [Ctrl]+[A],[K] to disconnect from the screen session and leave it running.)"