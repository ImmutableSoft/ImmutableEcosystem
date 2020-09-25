# ERC721Mintable (ERC721Mintable.sol)

View Source: [@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Mintable.sol](../@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Mintable.sol)

**↗ Extends: [Initializable](Initializable.md), [ERC721](ERC721.md), [MinterRole](MinterRole.md)**
**↘ Derived Contracts: [ActivateToken](ActivateToken.md)**

**ERC721Mintable**

ERC721 minting logic.

## Contract Members
**Constants & Variables**

```js
uint256[50] private ______gap;

```

## Functions

- [initialize(address sender)](#initialize)
- [mint(address to, uint256 tokenId)](#mint)
- [safeMint(address to, uint256 tokenId)](#safemint)
- [safeMint(address to, uint256 tokenId, bytes _data)](#safemint)

### initialize

⤾ overrides [MinterRole.initialize](MinterRole.md#initialize)

```js
function initialize(address sender) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| sender | address |  | 

### mint

Function to mint tokens.

```js
function mint(address to, uint256 tokenId) public nonpayable onlyMinter 
returns(bool)
```

**Returns**

A boolean that indicates if the operation was successful.

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address | The address that will receive the minted token. | 
| tokenId | uint256 | The token id to mint. | 

### safeMint

Function to safely mint tokens.

```js
function safeMint(address to, uint256 tokenId) public nonpayable onlyMinter 
returns(bool)
```

**Returns**

A boolean that indicates if the operation was successful.

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address | The address that will receive the minted token. | 
| tokenId | uint256 | The token id to mint. | 

### safeMint

Function to safely mint tokens.

```js
function safeMint(address to, uint256 tokenId, bytes _data) public nonpayable onlyMinter 
returns(bool)
```

**Returns**

A boolean that indicates if the operation was successful.

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address | The address that will receive the minted token. | 
| tokenId | uint256 | The token id to mint. | 
| _data | bytes | bytes data to send along with a safe transfer check. | 

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
