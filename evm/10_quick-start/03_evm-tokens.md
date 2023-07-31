---
title: EVM Tokens
--- 

The `EOS` tokens on the `EOS EVM` are the exact same tokens as the ones on the `EOS Network`.

This means that `EOS` tokens you see on exchanges are the same as the ones you use on `EOS EVM`. However, since most 
exchanges only support the native version of those tokens, you must *bridge* your tokens to use them on the EVM.

## Testnet faucet

Want some EOS tokens to play with? Click the button below to get some from the testnet faucet.

<!-- translation-ignore -->

import FaucetTokens from '@site/src/components/FaucetTokens/FaucetTokens';

<FaucetTokens />

<!-- end-translation-ignore -->

## Bridge from EOS to EOS EVM

### Bridge tokens yourself 

If you have **EOS** tokens on the `EOS Mainnet` or `Jungle Testnet`, you can send **EOS** directly to your EVM address.
Open your wallet and send **EOS** tokens to `eosio.evm` with your EVM address as the `memo`.


### Bridge tokens from an exchange

> ⚠ **Disclaimer:**
> 
> Not all exchanges support sending tokens to a smart contract. Depending on the exchange you are using you might need
> to first send the tokens to your own wallet and then follow the directions in the previous section.

To withdraw EOS tokens from a centralized exchange (CEX) to an EOS EVM address:

1. Visit the withdrawal screen of the Exchange's app
2. Select EOS as Coin
3. Select EOS as Network
4. Enter `eosio.evm` as Wallet Address
5. Enter your EOS EVM public key as Memo

![EOS EVM Token Flow](/images/EOS-EVM_withdraw_from_CEX_to_wallet.png)




## Bridge from EOS EVM to EOS

### Bridge tokens yourself

To transfer tokens from an EVM address to an EOS account you must use the [EOS EVM Mainnet Bridge](https://bridge.evm.eosnetwork.com/)
or the [EOS EVM Jungle Testnet Bridge](https://bridge.testnet.evm.eosnetwork.com/).

1. Select `Withdraw`
2. Connect your wallet
3. Enter an amount
4. Enter an EOS account to send to
   1. Add an optional memo
5. Click `Transfer`

### Bridge tokens to an exchange

> ⚠ **Disclaimer:**
>
> Some exchanges do not yet support tracking inline transfers on EOS, which prevents them from seeing EOS EVM transfers. 
> If you are in doubt whether your exchange supports this, first bridge tokens to the native EOS Network, and then send them
> to your exchange account.

You can follow the same process as above, but instead of entering an EOS account, enter your exchange account name.

Most EOS exchanges also require a `memo` field, so make sure you enter it there **or your tokens will be lost**.








## Other known tokens

| Symbol    | Token Name      | Address                                                                |
|-----------|-----------------|------------------------------------------------------------------------|
| WEOS | Wrapped EOS     | 0xc00592aA41D32D137dC480d9f6d0Df19b860104F |
