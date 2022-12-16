---
title: "V1 History Alternatives"
sidebar_position: 1
---

# V1 History Alternatives

The latest EOS v3.1 release officially ends support for the legacy V1 History plugin. Therefore, block producers and node operators who have integrations that rely on V1 History must seek alternative solutions.

## Production Ready Alternatives

The following battle tested and V1 compliant history solutions are available:
- Hyperion History Solution
- Roborovski History API

# Roborovski History API

## Overview

Roborovski History API is designed as a drop-in replacement for the V1 history API. It relies on the Trace API Plugin to extract the history data and then packs it in V1 format before it gives it back to the client request.

## Who Runs Roborovski History API

Roborovski History API is implemented and ran by [Greymass Inc.](https://greymass.com/)

## What makes the Roborovski History API safe

Roborovski History API has a high degree of safety because it is created by [Greymass Inc.](https://greymass.com/) which has been a credible and stable block producer and wallet developer (Anchor) company for EOS, WAX, TELOS, PROTON, FIO and other EOS based chains.

## Understanding the risks associated with hosted solutions

If you rely on a hosted solution, you are reliant on the correctness of data and processes that you do not control. Therefore, if your application critically relies on on-chain data, it is highly recommended that you host your own history solution. However, since Roborovsky is currently closed source, if you want to run your own node you will need to see Hyperion below.

## Roborovski History API and V1 History Standard

Roborovski History API is compliant with the V1 history API standard. It also adds two more functions on top of the standard ones.

Existing V1 History Plugin integrators can simply replace their current API url with Greymass' one and it will work flawlessly.

## API Reference

### How To Connect

The Roborovski History API connection endpoint is `https://eos.greymass.com`

### Functions List

- Get Actions (V1 compatible)
    - POST `https://eos.greymass.com/v1/history/get_actions`
- Get Transaction (V1 compatible)
    - POST `https://eos.greymass.com/v1/history/get_transaction`
- Get Transaction (new method, not in V1)
    - GET `https://eos.greymass.com/v1/history/get_transaction?id=<TXID>`
- Get Actions (new method, not in V1)
    - GET `https://eos.greymass.com/v1/history/get_actions?account_name=<NAME>`

### Performance Numbers

As it was observed and measured so far the Roborovski History API supports at least 50 requests per second; this limit is defined as a low load, the solution is capable of handling more, but no higher specific limits are known at the moment.


Hyperion History Solution
# Hyperion History Solution

## Overview

Hyperion History is a full history solution for indexing, storing and retrieving EOS-based blockchain historical data. It can be deployed by node operators to provide data querying support for actions, transactions, and blocks stored on the blockchain.

Hyperion History API provides both V2 and V1 (legacy history plugin) endpoints. Therefore, it is fully compliant with V1 history.

## What makes the Hyperion safe

Hyperion is developed and maintained by EOS Rio: https://eosrio.io/hyperion/ and has been battle tested on every Antelope public network (EOS, WAX, TELOS, PROTON, FIO, etc).

* Github: https://github.com/eosrio/Hyperion-History-API
* Documentation: https://hyperion.docs.eosrio.io/

## Requirements

Hyperion History requires the following components for a fully functional Hyperion API deployment:
- **Elasticsearch Cluster** - stores all indexed data
- **RabbitMQ** - message/data transport/queue for indexer stages
- **Redis** - used as predictive temporary database
- **EOS State History plugin** - feeds action traces and state deltas to indexer via websocket
- **Hyperion Indexer** - indexes State History data (launched from PM2 Node.js manager)
- **Hyperion API** - API server that listens to V1/V2 requests

## Installation

Providers have the following options to install Hyperion History solution:

- Manual installation:
  https://hyperion.docs.eosrio.io/manual_installation/

## Set Up

To set up Hyperion History solution after a successful installation:
- Configuration: https://hyperion.docs.eosrio.io/hyperion_configuration/
- Connection Configuration: https://hyperion.docs.eosrio.io/connections/
- Chain Configuration: https://hyperion.docs.eosrio.io/chain/

## V1 History Support

Hyperion History is compliant with the V1 history API standard.

### V1 History API reference

For a full description of the V1 History API endpoints supported by Hyperion History, please visit: https://hyperion.docs.eosrio.io/v1/

- `/v1/history/get_transaction`

  Get transaction by id
    - method: `POST`
    - schema:
      variable | type | description
      -|-|-
      id | string | transaction id

- `/v1/history/get_actions`

  Legacy get actions query
    - method: `POST`
    - schema:
      variable | type | description
      -|-|-
      account_name | type | description
      pos | integer | action position (pagination)
      offset | integer | limit of [n] actions per page
      filter | string (minLength: 3) | code:name filter
      sort | string | sort direction (Enum: [desc, asc, 1, -1])
      after | string($date-time) | filter after specified date (ISO8601)
      before | string($date-time) | filter before specified date (ISO8601)
      parent | integer (min: 0) | filter by parent global sequence

### Usage

Once Hyperion History is deployed on a server or cluster, existing V1 History Plugin clients can simply replace their current API domain URL with the one provided by the listening server or cluster.

### Examples

Some examples to illustrate usage of V1 History endpoints:

- Get all actions from given transaction:
    ```
    curl -X POST https://eos.hyperion.eosrio.io/v1/history/get_transaction -d '{
      "id": "<TXID>"
    }'
    ```

- Get all actions from last 10 transactions for given account:
    ```
    curl -X POST https://eos.hyperion.eosrio.io/v1/history/get_transaction -d '{
      "account_name": "<NAME>",
      "pos": -1
    }'
    ```

## Endpoint List

For a list of endpoint servers using Hyperion, check:
https://hyperion.docs.eosrio.io/endpoint/
