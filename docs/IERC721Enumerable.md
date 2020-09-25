# ERC-721 Non-Fungible Token Standard, optional enumeration extension (IERC721Enumerable.sol)

View Source: [@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721Enumerable.sol](../@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721Enumerable.sol)

**↗ Extends: [Initializable](Initializable.md), [IERC721](IERC721.md)**
**↘ Derived Contracts: [ERC721Enumerable](ERC721Enumerable.md)**

**IERC721Enumerable**

See https://eips.ethereum.org/EIPS/eip-721

## Functions

- [totalSupply()](#totalsupply)
- [tokenOfOwnerByIndex(address owner, uint256 index)](#tokenofownerbyindex)
- [tokenByIndex(uint256 index)](#tokenbyindex)

### totalSupply

⤿ Overridden Implementation(s): [ERC721Enumerable.totalSupply](ERC721Enumerable.md#totalsupply)

```js
function totalSupply() public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### tokenOfOwnerByIndex

⤿ Overridden Implementation(s): [ERC721Enumerable.tokenOfOwnerByIndex](ERC721Enumerable.md#tokenofownerbyindex)

```js
function tokenOfOwnerByIndex(address owner, uint256 index) public view
returns(tokenId uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address |  | 
| index | uint256 |  | 

### tokenByIndex

⤿ Overridden Implementation(s): [ERC721Enumerable.tokenByIndex](ERC721Enumerable.md#tokenbyindex)

```js
function tokenByIndex(uint256 index) public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 |  | 

## Contracts

* [ActivateToken](ActivateToken.md)
* [Address](Address.md)
* [Context](Context.md)
* [Counters](Counters.md)
* [CustomToken](CustomToken.md)
* [ERC165](ERC165.md)
* [ERC20](ERC20.md)
* [ERC20Detailed](ERC20Detailed.md)
* [ERC20Mintable](ERC20Mintable.md)
* [ERC721](ERC721.md)
* [ERC721Burnable](ERC721Burnable.md)
* [ERC721Enumerable](ERC721Enumerable.md)
* [ERC721Mintable](ERC721Mintable.md)
* [Escrow](Escrow.md)
* [IERC165](IERC165.md)
* [IERC20](IERC20.md)
* [IERC721](IERC721.md)
* [IERC721Enumerable](IERC721Enumerable.md)
* [IERC721Receiver](IERC721Receiver.md)
* [ImmutableConstants](ImmutableConstants.md)
* [ImmutableEntity](ImmutableEntity.md)
* [ImmutableProduct](ImmutableProduct.md)
* [Initializable](Initializable.md)
* [Migrations](Migrations.md)
* [MinterRole](MinterRole.md)
* [Ownable](Ownable.md)
* [PullPayment](PullPayment.md)
* [ResolverBase](ResolverBase.md)
* [Roles](Roles.md)
* [SafeMath](SafeMath.md)
* [Secondary](Secondary.md)
* [StringCommon](StringCommon.md)
