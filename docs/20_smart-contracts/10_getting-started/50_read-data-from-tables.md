---
title: Read Data from Tables
---

## Prerequisites

To follow this guide, you will need:

- An understanding of the EOS blockchain and how it works.
- A command-line interface to run curl commands.
- Access to an EOS node or an EOS API service.

## EOS Tables

EOS stores data in tables, which are similar to database tables. Each table has a name and a set of fields. Tables are organized into scopes, which are defined by the smart contract that created the table.

To retrieve data from a table, you need to know its name, scope, and the name of the smart contract that created it. You can also specify a lower and upper bound to limit the amount of data returned.

## Methods to Retrieve Data from EOS Tables

### Use get_table_rows Function

The `get_table_rows` function retrieves rows from a table. It takes the following parameters in JSON format:

- `"code"`: the eos account name which is the owner of the smart contract that created the table.
- `"scope"`: the scope of the table, it is an eos account name.
- `"table"`: a string representing the name of the table.
- `"json"`: (optional) a boolean value that specifies whether to return the row results in JSON format or binary format, defaults to binary.
- `"lower_bound"`: (optional) a string representing the lower bound for the table key, defaults to first value of the index used.
- `"upper_bound"`: (optional) a string representing the upper bound for the table key, defaults to the last value of the index used.
- `"index_position"`: (optional) the position of the index to use if the table has multiple indexes, accepted values are `primary`, `secondary`, `tertiary`, `fourth`, `fifth`, `sixth`, `seventh`, `eighth`, `ninth` , `tenth`, defaults to `primary`.
- `"key_type"`: (optional) a string representing the type of the table key, supported values `i64`, `i128`, `i256`, `float64`, `float128`, `sha256`, `ripemd160`, `name`.
- `"encode_type"`: (optional) a string representing the encoded type of the key_type parameter, either `dec` or `hex`, defaults to `dec`.
- `"limit"`: limits the number of results returned, defaults to 10.
- `"time_limit_ms"`: (optional) the maximum time should spend to retrieve the results, defaults to 10ms.
- `"reverse"`: (options) if `true` the results are retrieved in reverse order, from lower_bound up towards upper_bound, defaults to `false`.

Below is an example that retrieves rows from `abihash` table, owned by the `eosio` account and having as `scope` the `eosio` name.

```shell
curl --request POST \
--url https://eos.greymass.com/v1/chain/get_table_rows \
--header 'content-type: application/json' \
--data '{
"json": true,
"code": "eosio",
"scope": "eosio",
"table": "abihash",
"lower_bound": "eosio",
"limit": 3,
"reverse": false
}'
```

In the example above:

- The rows values are returned as JSON, set by the `json` parameter.
- The table is owned by the account `eosio`, set by the `code` parameter.
- The table scope is `eosio`, set by the `scope` parameter.
- The table name is `abihash.`, set by the `table` parameter.
- The query uses the primary index to search the rows and starts from the `eosio` lower bound index value, set by the `lower_bound` parameter.
- The function will fetch a maximum of 3 rows, set by the `limit` parameter.
- The retrieved rows will be in ascending order, set by the `reverse` parameter.

Alternatively, you can execute the same command with `cleos` utility tool, and have the same result:

```shell
dune -- cleos -u https://eos.greymass.com get table eosio eosio abihash --lower eosio --limit 3
```

#### The get_table_rows Result

The JSON returned by the `get_table_rows` has the following structure:

```json
{
  "rows": [
    { },
    ...
    { }
  ],
  "more": true,
  "next_key": ""
}
```

The `"rows"` field is an array of table row objects in JSON representation.
The `"more"` field indicates that there are additional rows beyond the ones returned.
The `"next_key"` field contains the key to be used as the lower bound in the next request to retrieve the next set of rows.

For example, the result from the previous section command contains three rows, and looks similar to the one below:

```json
{
  "rows": [
    {
      "owner": "eosio",
      "hash": "00e166885b16bcce50fea9ea48b6bd79434cb845e8bc93cf356ff787e445088c"
    },
    {
      "owner": "eosio.assert",
      "hash": "aad0ac9f3f3d8f71841d82c52080f99479e869cbde5794208c9cd08e94b7eb0f"
    },
    {
      "owner": "eosio.evm",
      "hash": "9f238b42f5a4be3b7f97861f90d00bbfdae03e707e5209a4c22d70dfbe3bcef7"
    }
  ],
  "more": true,
  "next_key": "6138663584080503808"
}
```

#### The get_table_rows Pagination

Note that the previous command has the `"more"` field set to `true`. That means there's more rows in the table, which match the filter used, that were not returned with the first issued command.

The `"next_key"`, `"lower_bound"` and `"upper_bound"` fields, can be used to implement pagination or iterative retrieval of data from any table in the EOS blockchain.

To fetch the next set of rows, you can issue another `get_table_rows` request, modifying the lower bound to be the value of the `"next_key"` field:

```shell
curl --request POST \
--url https://eos.greymass.com/v1/chain/get_table_rows \
--header 'content-type: application/json' \
--data '{
"json": true,
"code": "eosio",
"scope": "eosio",
"table": "abihash",
"lower_bound": "6138663584080503808",
"limit": 3,
"reverse": false
}'
```

Alternatively, you can execute the same command with `cleos` utility tool, and have the same result:

```shell
dune -- cleos -u https://eos.greymass.com get table eosio eosio abihash --lower 6138663584080503808 --limit 3
```

The above commands returns the subsequent 3 rows from the `abihash` table with the producer name value greater than `"6138663584080503808"`. By iterating this process, you can retrieve all the rows in the table.

If the response from the second request includes `"more": false`, it means that you have fetched all the available rows, which match the filter, and there is no need for further requests.

### Use get_table_by_scope Function

The purpose of `get_table_by_scope` is to scan the table names under a given `code` account, using `scope` as the primary key. If you already know the table name, e.g. `mytable`, it is not necessary to use `get_table_by_scope` unless you want to find out what are the scopes that have defined the `mytable` table.

These are the input parameters supported by `get_table_by_scope`:

- `"code"`: the eos account name which is the owner of the smart contract that created the table.
- `"table"`: a string representing the name of the table.
- `"lower_bound"` (optional): This field specifies the lower bound of the scope when querying for table rows. It determines the starting point for fetching rows based on the scope value. Defaults to first value of the scope.
- `"upper_bound"` (optional): This field specifies the upper bound of the scope when querying for table rows. It determines the ending point for fetching rows based on the scope value.  Defaults to last value of the scope.
- `"limit"` (optional): This field indicates the maximum number of rows to be returned in the function. It allows you to control the number of rows retrieved in a single request.
- `"reverse"` (optional): if `true` the results are retrieved in reverse order, from lower_bound up towards upper_bound, defaults to `false`.
- `"time_limit_ms"`: (optional) the maximum time should spend to retrieve the results, defaults to 10ms.

Below is an example JSON payload for the get_table_by_scope function:

```json
{
  "code": "accountname1",
  "table": "tablename",
  "lower_bound": "accountname2",
  "limit": 10,
  "reverse": false,
}
```

In the example above:

- The table is owned by the account `accountname1`, set by the `code` parameter.
- The table name is `tablename.`, set by the `table` parameter.
- The query starts from the `accountname2` scope value, set by the `lower_bound` parameter.
- The function will fetch a maximum of 10 rows, set by the `limit` parameter.
- The retrieved rows will be in ascending order, set by the `reverse` parameter.

#### The get_table_by_scope Result

The `get_table_by_scope` returns a JSON object containing information about the tables within the specified scope. The return JSON has the following fields:

- `"rows"`: This field contains an array of tables.
- `"more"`: This field indicates whether there are more results available. If it is set to true, it means there are additional rows that can be fetched using pagination. See previous section for more details on how to retrieve additional rows.

Each table row is represented by a JSON object that contains the following fields:

- `"code"`: The account name of the contract that owns the table.
- `"scope"`: The scope within the contract in which the table is found. It represents a specific instance or category within the contract.
- `"table"`: The name of the table as specified by the contract ABI.
- `"payer"`: The account name of the payer who covers the RAM cost for storing the row.
- `"count"`: The number of rows in the table multiplied by the number of indices defined by the table (including the primary index). For example, if the table has only the primary index defined then the `count` represents the number of rows in the table; for each additional secondary index defined for the table the count represents the number of rows multiplied by N where N = 1 + the number of secondary indices.

##### Empty Result

It is possible that the returned JSON looks like the one below:

```json
{
    "rows":[],
    "more": "accountname"
}
```

The above result means your request did not finish its execution due to the transaction time limit imposed by the blockchain configuration. The result tells you it did not find any table (`rows` field is empty) from the specified `lower_bound` to the `"accountname"` bound. In this case you must execute the request again with `lower_bound` set to the value provided by the `"more"` field, in this case `accountname`.

#### Real Example

For a real example, you can list the first three tables named `accounts` owned by the `eosio.token` account starting with the lower bound scope `eosromania`:

```shell
curl --request POST \
--url https://eos.greymass.com/v1/chain/get_table_by_scope \
--header 'content-type: application/json' \
--data '{
"json": true,
"code": "eosio.token",
"table": "accounts",
"lower_bound": "eosromania",
"upper_bound": "",
"reverse": false,
"limit": "3"
}'
```

The result looks similar to the one below:

```json
{
  "rows": [
    {
      "code": "eosio.token",
      "scope": "eosromania22",
      "table": "accounts",
      "payer": "tigerchainio",
      "count": 1
    },
    {
      "code": "eosio.token",
      "scope": "eosromaniaro",
      "table": "accounts",
      "payer": "gm3tqmrxhage",
      "count": 1
    },
    {
      "code": "eosio.token",
      "scope": "eosromansev1",
      "table": "accounts",
      "payer": "gateiowallet",
      "count": 1
    }
  ],
  "more": "eosromario11"
}
```
