---
title: Indexing
---

## Envio

Envio is the data layer for blockchain apps. It gives EOS EVM developers the fastest, most flexible way to get real-time and historical onchain data, from a single GraphQL API to raw high-speed access, with managed hosting on Envio Cloud.

[Get started with Envio](https://envio.dev/?utm_source=eos-evm&utm_medium=partner-docs)

## HyperIndex

HyperIndex is Envio's framework for building custom indexers. It natively supports indexing any EVM chain out of the box, including EOS EVM, using your own RPC as the data source. You define the events you care about, write your handlers, and query the results through a ready-made GraphQL API.

To index EOS EVM, add the chain ID and an RPC endpoint to your `config.yaml` as shown below.

```yaml
networks:
  - id: 17777
    rpc:
      - url: https://api.evm.eosnetwork.com
        for: sync
    start_block: 0
    contracts:
      - name: MyContract
        address:
          - "0xYourContractAddress"
        handler: ./src/EventHandlers.ts
        events:
          - event: Transfer(address indexed from, address indexed to, uint256 value)
```

## Resources

- [Quickstart](https://docs.envio.dev/docs/HyperIndex/quickstart?utm_source=eos-evm&utm_medium=partner-docs)
- [Benchmarks](https://docs.envio.dev/docs/HyperIndex/benchmarking?utm_source=eos-evm&utm_medium=partner-docs)
