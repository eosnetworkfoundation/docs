# Contributing to EOS Docs

First, the fact you're even here right now means you're awesome. Thanks!

Contributing can be as easy or as hard as you want it to be. 
We're happy to accept anything from small typo corrections to entirely new documents. 
If you're looking for a place to start, consider [taking an item from our backlog](https://github.com/orgs/eosnetworkfoundation/projects/18/views/10)
that doesn't have a `🔥 crit` priority (we usually take those in our upcoming iteration)

Some ways you can contribute:
- [Reporting an issue](https://github.com/eosnetworkfoundation/docs/issues)
- [Creating new documents](#creating-a-new-document)
- Updating existing documents (same process as creating a new document)

## General guidelines

- **Never make a PR directly to `main`**
- Numbering of documents is done using the prefix of `XX_` where `XX` is the next available number in the sequence
- Documents can only have an underscore (`_`) separating between the order and the title, use hyphens (`-`) for all other spaces
- The title of the document should be in title case
- The subheaders should be in sentence case
- **If you edit a document, add yourself to the contributors list!**

## Creating a new document

Here is the process for creating a new document:
- [Fork the repository](https://github.com/eosnetworkfoundation/docs/fork)
- Switch to the `staging` branch (`git checkout staging`)
- Create a new branch (`git checkout -b doc/my-new-document`)
- Create your document in the `native` or `evm`
  - Use the [TEMPLATE](TEMPLATE.md) as a starting point
- When you're ready, create a pull request from your branch to `staging`
- Once the PR is approved, it will be merged into `staging`
- When the next release is ready, `staging` will be merged into `main` and the document will be live
- New directories must have an `index.md` which is hidden from the sidebar
  - These become categories if they are root level under `native` or `evm`





