---
title: Inscriptions
---

Inscriptions on EVM chains are arbitrary data written into the chain's history using the `calldata` field. 
Because the data is only stored in the chain's history, and not within state itself, it lowers the cost of
sending data to the chain.

However, because the data is not actually stored in state, it is impossible to use the data from within smart contracts.
This means that inscriptions are only useful for indexing and other off-chain purposes until the data is written into state.

## Gas fees, throughput, and inscriptions

On the majority of other EVM supporting chains, inscriptions has caused massive upward pressure on gas fees, as well as 
degradation of throughput. However, on EOS EVM the gas fee is fixed, and the chain is more than capable of handling the
load of inscriptions without any noticeable impact on throughput.

## The inscription format

Inscriptions are a simple `JSON` format that can be embedded in the call data of a transaction.
The format must be adhered to or third party tooling like indexers will not be able to process the data.

> ✔ **You can add other fields**
> 
> You are free to add fields to the `JSON` object that your specific project might benefit from, 
> but every field below is required.

```json
{
  "p": "eorc-20",
  "op": "deploy",
  "tick": "orcs"
}
```

| Key | Description                                            |
| --- |--------------------------------------------------------|
| `p` | The protocol helps tooling identify and process events |
| `op` | The operation type: `deploy, mint, transfer, list`      |
| `tick` | The token ticker                                       |


### Deploy

```json
{ 
  "p": "eorc-20",
  "op": "deploy",
  "tick": "orcs",
  "max": "420420",
  "lim": "69"
}
```

| Key | Description                     |
| --- |---------------------------------|
| `max` | The maximum supply of the token |
| `lim` | The mint limit per inscription  |


### Mint

```json
{ 
  "p": "eorc-20",
  "op": "mint",
  "tick": "orcs",
  "amt": "69"
}
```

| Key | Description |
| --- |-------------|
| `amt` | The amount to mint |


### Transfer

```json
{ 
  "p": "eorc-20",
  "op": "transfer",
  "tick": "orcs",
  "amt": "1"
}
```

| Key | Description |
| --- |-------------|
| `amt` | The amount to transfer |


## Sending inscriptions

When sending inscriptions to the chain you must specify the `mime-type` of the data, or leave it as `data:,` so that it 
defaults to `text/plain`.

For example:

```
data:,{"p":"eorc-20","op":"deploy","tick":"orcs","max":"420420","lim":"69"}
```

Then, you must convert the `JSON` to `hex` and use the `data` field of the transaction to send the inscription.

An example of this using `ethers` would be:

```js
const { ethers } = require('ethers');
const provider = new ethers.providers.JsonRpcProvider('RPC_URL');
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const json = {
    p: 'eorc-20',
    op: 'deploy',
    tick: 'orcs',
    max: '420420',
    lim: '69',
};

const utfBytes = ethers.utils.toUtf8Bytes(JSON.stringify(json));
const hexData = ethers.utils.hexlify(utfBytes);

const tx = {
    to: '0x123...',
    value: 0,
    data: hexData
};

wallet.sendTransaction(tx).then(...);
```
