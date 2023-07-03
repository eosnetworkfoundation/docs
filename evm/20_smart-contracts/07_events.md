---
title: Events
---

Events in Solidity are a way for a contract to communicate that something happened on the blockchain to your app
front-end, which can be listening for certain events and take action when they happen.

## Event Declaration

Events are declared with the `event` keyword, followed by the name of the event, and then a list of parameters.

```solidity
event MyEvent(bool _myParam);
```

## Emitting Events

Events are emitted with the `emit` keyword, followed by the name of the event, and then a list of arguments.

```solidity
emit MyEvent(true);
```

## Indexing events

Events can be indexed, which allows you to filter events based on the indexed parameters.

```solidity
event MyEvent(uint256 indexed _myParam);
```

> 💰 **Cost of indexing**
>
> Indexing events costs more gas than non-indexed events. You should only index events that you plan to filter on,
> otherwise you are unnecessarily increasing the cost on users of your contract.

