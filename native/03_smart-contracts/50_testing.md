---
title: Testing
---

<!-- translation-ignore -->

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<!-- end-translation-ignore -->

The easiest way to test EOS Smart Contracts is using VeRT (VM emulation RunTime for WASM-based blockchain contracts).

It is a JavaScript library that allows you to run EOS smart contracts in a Node.js environment.
You use it along-side other testing libraries like Mocha, Chai, and Sinon.

This guide will use Mocha as the testing framework, and assumes you already know how mocha works, as well as JavaScript.

## Installation

If you're using [FuckYea](https://github.com/nsjames/fuckyea) you already have everything installed, otherwise follow
the installation steps below.

We're going to install
- VeRT
- Mocha
- Chai

```shell
npm install -D @eosnetwork/vert mocha chai
```

You should also add `"type": "module"` to your `package.json`. 

To make life easier, add a test script to your `package.json` so that we can easily run tests from mocha. (change `.js` to `.ts` if you're using TypeScript)

```json
"scripts": {
  "test": "mocha tests/**/*.spec.js"
},
```

Your `package.json` will look something like this now:

```json
{
  "name": "your-project",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "test": "mocha tests/**/*.spec.js"
  },
  "devDependencies": {
    "@eosnetwork/vert": "^0.3.24",
    "chai": "^4.3.10",
    "mocha": "^10.2.0"
  }
}
```

## Testing

Create a `tests` directory and a test file that ends with `.spec.js` (or `.spec.ts` if you're using typescript).

### Setup your test file

Let's look at how to import our dependencies, setup the emulator and some accounts, and define a test.

```javascript
// tests/mycontract.spec.js

import { Blockchain, nameToBigInt, expectToThrow } from "@eosnetwork/vert";
import { assert } from "chai";

// instantiate the blockchain emulator
const blockchain = new Blockchain()

// Load a contract
const contract = blockchain.createContract(
    // The account to set the contract on
    'accountname', 
    // The path to the contract's wasm file
    'build/yourcontract'
)

// Create some accounts to work with
const [alice, bob] = blockchain.createAccounts('alice', 'bob')

// You can clear the tables in the 
// contract before each test
beforeEach(async () => {
    blockchain.resetTables()
})

describe('Testing Suite', () => {
    it('should do X', async () => {
        
        // Your test goes here...
        
    });
});
```

### Sending transactions

You can send transactions to your contract like this:

```javascript
const result = await contract.actions.youraction(
    // Parameters are passed as an array, and must match the types in the contract
    ['yourparams', 1]
).send(
    // To send the transaction you need to pass the name and permission
    // of the account that is sending it within .send()
    'alice@active'
);
```

### Getting table data

You can get the data from a table in your contract like this:

```javascript
const rows = contract.tables.yourtable(
    // Set the scope of the table
    nameToBigInt('accountname')
).getTableRow(
    // Find the row using the primary index
    nameToBigInt('alice')
);

// Make sure the row exists or fail the test
assert(!!rows, "User not found")
```

### Logging console output

If you're printing to the console in your contract, you can access the logs in your test files like this:

```javascript
console.log(contract.bc.console);
````

### Catching errors

If you want to test that your contract throws a specific error, you can use the `expectToThrow` function like this:

```javascript
expectToThrow(
    contract.actions.throwserror([]).send('bob@active'),
    'This will be the error inside check()'
)
```



## Troubleshooting

Sometimes you run into problems. If you have anything that isn't on this list, please reach out in the [Developers Telegram](https://t.me/antelopedevs) group.

### Seeing table deltas

Sometimes it's helpful to see the changes in tables after a transaction.
You can enable storage deltas and then print them out to see what has changed.

```javascript
blockchain.enableStorageDeltas()

contract.actions.youraction([]).send(...)

blockchain.printStorageDeltas()
blockchain.disableStorageDeltas()
```


### Exported memory

VeRT requires exported memory in your contract. 

If you are using CDT to compile your contracts, you need to export memory in your contract manually prior to version 4.1.0.

```bash
# if you don't have wabt:
apt-get install wabt
# export memory
wasm2wat FILENAME.wasm | sed -e 's|(memory |(memory (export "memory") |' > TMP_FILE.wat
wat2wasm -o FILENAME.wasm TMP_FILE.wat
rm TMP_FILE.wat
```

