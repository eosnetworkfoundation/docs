---
title: EVM Tokens
--- 

The `EOS` tokens on the `EOS EVM` are the exact same tokens as the ones on the `EOS Network`.

This means that `EOS` tokens you see on exchanges are the same as the ones you use on `EOS EVM`. However, since most 
exchanges only support the native version of those tokens, you must *bridge* your tokens to use them on the EVM.

## Testnet faucet

import FaucetTokens from '@site/src/components/FaucetTokens/FaucetTokens';

Want some EOS tokens to play with? Click the button below to get some from the testnet faucet.

<FaucetTokens />

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

1. Visit the withdraw screen of the Exchange's app
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

> ⚠ **Disclaimer:**
>
> Please note that none of these tokens or smart contracts are endorsed by the EOS Network Foundation.
> 
> Engaging with these must be done at the risk of the user.
> All the resources within this document are to be taken as educational material and NOT financial advice. Trading and/or investing in
> cryptocurrency and/or any related commodities/securities/derivatives/instruments is extremely high risk and you can very easily
> lose all of your investment capital!

| Symbol    | Token Name      | Address                                                                |
|-----------|-----------------|------------------------------------------------------------------------|
| USDT | Multichain USDT | 0xfA9343C3897324496A05fC75abeD6bAC29f8A40f           |
| WETH | Multichain WETH | 0x922D641a426DcFFaeF11680e5358F34d97d112E1 |
| WBTC | Multichain WBTC | 0xeFAeeE334F0Fd1712f9a8cc375f427D9Cdd40d73 |
| USDC | Multichain USDC | 0x765277EebeCA2e31912C9946eAe1021199B39C61 |
| DAI | Multichain DAI  | 0x818ec0A7Fe18Ff94269904fCED6AE3DaE6d6dC0b |
| BNB | Multichain BNB  | 0x461d52769884ca6235B685EF2040F47d30C94EB5 |
| WEOS | Wrapped EOS     | 0xc00592aA41D32D137dC480d9f6d0Df19b860104F |
