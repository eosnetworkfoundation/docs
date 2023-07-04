---
title: EOAs vs Smart Contracts
contributors:
  - { name: Esteban Saá, github: stebansaa }
---

## Common ERC standards

In the EOSEVM ecosystem, several widely adopted ERC (Ethereum Request for Comments) standards exist. These standards provide guidelines and specifications for implementing various functionalities and use cases on the EOSEVM network. Here are four commonly used ERC standards: ERC-20, ERC-721, ERC-777, and ERC-1155.

### ERC-20
ERC-20 is a standard interface for fungible tokens on the EOSEVM network. Fungible tokens are interchangeable and have identical values. ERC-20 tokens have methods to transfer tokens, check balances, and approve token spending on behalf of an address.

#### Example ERC-20 Contract
Here's an example of a basic ERC-20 token contract written in Solidity:

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowances[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        require(amount <= balances[sender], "Insufficient balance");
        require(amount <= allowances[sender][msg.sender], "Insufficient allowance");
        balances[sender] -= amount;
        balances[recipient] += amount;
        allowances[sender][msg.sender] -= amount;
        return true;
    }
}
```


### ERC-721
ERC-721 is a standard for non-fungible tokens (NFTs) on the EOSEVM network. NFTs are unique and indivisible tokens that represent ownership of a specific item or asset. Each NFT has a distinct identifier, and they can be used for digital collectibles, unique assets, and more.

#### Example ERC-721 Contract
Here's an example of a basic ERC-721 token contract using the OpenZeppelin library in Solidity:

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("MyNFT", "NFT") {}

    function mintNFT(address recipient, string memory tokenURI) external returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}
```

### ERC-777
ERC-777 is an improved fungible token standard that incorporates additional features compared to ERC-20. It introduces advanced functionalities like hooks, which allow contracts to react to token transfers, and operator approvals, which enable third-party operators to handle tokens on behalf of token holders.

### ERC-1155
ERC-1155 is a multi-token standard that enables the creation of both fungible and non-fungible tokens within a single contract. This standard is particularly useful for projects that require the management of multiple types of tokens, such as gaming platforms or decentralized exchanges.

These ERC standards provide a foundation for building various token-based applications and use cases on the EOSEVM network. It's important to note that while these standards originated on Ethereum, they can also be implemented and utilized within the EOSEVM ecosystem.