---
title: EVM Tokens
---

The `Vaulta EVM` uses EOS tokens as the gas token. 
You can bridge those tokens from Vaulta to EOS and back again by using the `Vaulta EVM Bridge`.

## Bridge from Vaulta to Vaulta EVM

### Bridge tokens yourself

If you have **Vaulta** tokens on Vaulta or Jungle Testnet, you will need to swap your Vaulta to EOS and then send 
**EOS** directly to your EVM address.

> ⚠ **Disclaimer:**
> 
> If you have Vaulta tokens and need EOS tokens you can send your Vaulta tokens to `core.vaulta` and it will be swapped and sent back to you.

Open your wallet and send **EOS** tokens to `eosio.evmin` with your EVM address as the `memo`.

### Bridge tokens from an exchange

Depending on whether the exchange supports Vaulta or EOS you might have to swap your tokens. 

> ⚠ **Disclaimer:**
>
> Not all exchanges support sending tokens to a smart contract. Depending on the exchange you are using you might need
> to first send the tokens to your own wallet and then follow the directions in the previous section.

To withdraw EOS tokens from a centralized exchange (CEX) to a Vaulta EVM address:

1. Visit the withdrawal screen of the Exchange's app
2. Select EOS as Coin
3. Select EOS as Network
4. Open your wallet and transfer your EOS tokens
   1. Enter `eosio.evmin` as Wallet Address 
   2. Enter your Vaulta EVM public key as Memo

![Vaulta EVM Token Flow](/images/EOS-EVM_withdraw_from_CEX_to_wallet.png)

To withdraw Vaulta tokens from a centralized exchange (CEX) to a Vaulta EVM address:
1. Visit the withdrawal screen of the Exchange's app
2. Select `A` as Coin
3. Select Vaulta as Network
4. Swap your Vaulta tokens to EOS
   1. Send Vaulta tokens to `core.vaulta` to get EOS
5. Open your wallet and transfer your EOS tokens
   1. Enter `eosio.evmin` as Wallet Address 
   2. Enter your Vaulta EVM public key as Memo



## Bridge from Vaulta EVM to Vaulta

### Bridge tokens yourself

To transfer tokens from an EVM address to a Vaulta account you must use the [Vaulta EVM Mainnet Bridge](https://bridge.evm.eosnetwork.com/).

1. Select `Withdraw`
2. Connect your wallet
3. Enter an amount
4. Enter a Vaulta account to send to
5. Add an optional memo
6. Click `Transfer`

At this point, if you need Vaulta you can swap back:
1. Send your EOS tokens to `core.vaulta`
2. This will send back the same amount of Vaulta tokens to your account

### Bridge tokens to an exchange

> ⚠ **Disclaimer:**
>
> Some exchanges do not yet support tracking inline transfers on Vaulta, which prevents them from seeing Vaulta EVM transfers.
> If you are in doubt whether your exchange supports this, first bridge tokens to the native Vaulta network, and then send them to your exchange account.

You can follow the same process as above, but instead of entering an Vaulta account, enter your exchange account name.

Most exchanges also require a `memo` field, so make sure you enter it there **or your tokens will be lost**.








## Important ERC-20 tokens

There are a few ERC-20 tokens that are available on the `Vaulta EVM` which serve as core components of apps and defi.

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
| MLNK    | 8        | 0x47c727d53ebe90317144917f66a588dd45d4b114 |
| CHEX    | 18        | 0xde90b6ad3b8c81f38af250d56dfd4bf256b87512 |
| ZEOS    | 4        | 0x477f09a0bdb273c8933429109febd3c3b0388b8a |
| BRAM    | 0        | 0x102f21abc12ebd194259c1081b13916192e7cbe5 |
| SEOS   | 6        | 0xbfb10f85b889328e4a42507e31a07977ae00eec6 |
| BOX    | 6        | 0x9b3754f036de42846e60c8d8c89b18764f168367 |
| USN    | 6        | 0x8d0258d6ccfb0ce394dc542c545566936b7974f9 |
| BANANA    | 4        | 0xc500c831af8a5d1f4f3b1fc3940175a8db68c3cb |


<!-- translation-ignore -->

<AddTokenToMetaMask address="0x47c727d53ebe90317144917f66a588dd45d4b114" symbol="MLNK" decimals="8" />
<AddTokenToMetaMask address="0xde90b6ad3b8c81f38af250d56dfd4bf256b87512" symbol="CHEX" decimals="18" />
<AddTokenToMetaMask address="0x477f09a0bdb273c8933429109febd3c3b0388b8a" symbol="ZEOS" decimals="4" />
<AddTokenToMetaMask address="0x102f21abc12ebd194259c1081b13916192e7cbe5" symbol="BRAM" decimals="0" />
<AddTokenToMetaMask address="0xbfb10f85b889328e4a42507e31a07977ae00eec6" symbol="SEOS" decimals="6" />
<AddTokenToMetaMask address="0x9b3754f036de42846e60c8d8c89b18764f168367" symbol="BOX" decimals="6" />
<AddTokenToMetaMask address="0x8d0258d6ccfb0ce394dc542c545566936b7974f9" symbol="USN" decimals="6" />
<AddTokenToMetaMask address="0xc500c831af8a5d1f4f3b1fc3940175a8db68c3cb" symbol="BANANA" decimals="4" />

<!-- end-translation-ignore -->
