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
Open your wallet and send **EOS** tokens to `eosio.evmin` with your EVM address as the `memo`.


### Bridge tokens from an exchange

> ⚠ **Disclaimer:**
>
> Not all exchanges support sending tokens to a smart contract. Depending on the exchange you are using you might need
> to first send the tokens to your own wallet and then follow the directions in the previous section.

To withdraw EOS tokens from a centralized exchange (CEX) to an EOS EVM address:

1. Visit the withdrawal screen of the Exchange's app
2. Select EOS as Coin
3. Select EOS as Network
4. Enter `eosio.evmin` as Wallet Address
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








## Important ERC-20 tokens

There are a few ERC-20 tokens that are available on the `EOS EVM` which serve as core components of apps and defi.

### Wrapped EOS

Wrapped EOS represents the core system token `EOS`, but in the form of an ERC-20.


| Symbol    | Decimals | Address                                                                |
|-----------|----------|------------------------------------------------------------------------|
| WEOS | 18       | 0xc00592aA41D32D137dC480d9f6d0Df19b860104F |


<!-- translation-ignore -->

import AddTokenToMetaMask from '@site/src/components/AddTokenToMetaMask/AddTokenToMetaMask';

<AddTokenToMetaMask address="0xc00592aA41D32D137dC480d9f6d0Df19b860104F" symbol="WEOS" decimals="18" />

<!-- end-translation-ignore -->

### USDT

The `USDT` token is an ERC-20 that represents the stable-coin `Tether`.


| Symbol    | Decimals | Address                                                                |
|-----------|----------|------------------------------------------------------------------------|
| USDT | 6        | 0x33b57dc70014fd7aa6e1ed3080eed2b619632b8e |


<!-- translation-ignore -->

<AddTokenToMetaMask address="0x33b57dc70014fd7aa6e1ed3080eed2b619632b8e" symbol="USDT" decimals="6" />

<!-- end-translation-ignore -->

### Other tokens

These are other third party tokens which are supported across chains. 


| Symbol | Decimals | Address                                                                |
|--------|----------|------------------------------------------------------------------------|
| USN    | 6        | 0x8d0258d6ccfb0ce394dc542c545566936b7974f9 |
| SEOS   | 6        | 0xbfb10f85b889328e4a42507e31a07977ae00eec6 |
| BOX    | 6        | 0x9b3754f036de42846e60c8d8c89b18764f168367 |
| BANANA    | 4        | 0xc500c831af8a5d1f4f3b1fc3940175a8db68c3cb |
| BRAM    | 4        | 0x102f21abc12ebd194259c1081b13916192e7cbe5 |
| ZEOS    | 4        | 0x477f09a0bdb273c8933429109febd3c3b0388b8a |


<!-- translation-ignore -->

<AddTokenToMetaMask address="0x8d0258d6ccfb0ce394dc542c545566936b7974f9" symbol="USN" decimals="6" />
<AddTokenToMetaMask address="0xbfb10f85b889328e4a42507e31a07977ae00eec6" symbol="SEOS" decimals="6" />
<AddTokenToMetaMask address="0x9b3754f036de42846e60c8d8c89b18764f168367" symbol="BOX" decimals="6" />
<AddTokenToMetaMask address="0xc500c831af8a5d1f4f3b1fc3940175a8db68c3cb" symbol="BANANA" decimals="4" />
<AddTokenToMetaMask address="0x102f21abc12ebd194259c1081b13916192e7cbe5" symbol="BRAM" decimals="4" />
<AddTokenToMetaMask address="0x477f09a0bdb273c8933429109febd3c3b0388b8a" symbol="ZEOS" decimals="4" />

<!-- end-translation-ignore -->
