# ERC-721 Non-Fungible Token with optional enumeration extension logic (ERC721Enumerable.sol)

View Source: [@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Enumerable.sol](../@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Enumerable.sol)

**↗ Extends: [Initializable](Initializable.md), [Context](Context.md), [ERC165](ERC165.md), [ERC721](ERC721.md), [IERC721Enumerable](IERC721Enumerable.md)**
**↘ Derived Contracts: [ActivateToken](ActivateToken.md)**

**ERC721Enumerable**

See https://eips.ethereum.org/EIPS/eip-721

## Contract Members
**Constants & Variables**

```js
mapping(address => uint256[]) private _ownedTokens;
mapping(uint256 => uint256) private _ownedTokensIndex;
uint256[] private _allTokens;
mapping(uint256 => uint256) private _allTokensIndex;
bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE;
uint256[50] private ______gap;

```

## Functions

- [initialize()](#initialize)
- [_hasBeenInitialized()](#_hasbeeninitialized)
- [tokenOfOwnerByIndex(address owner, uint256 index)](#tokenofownerbyindex)
- [totalSupply()](#totalsupply)
- [tokenByIndex(uint256 index)](#tokenbyindex)
- [_transferFrom(address from, address to, uint256 tokenId)](#_transferfrom)
- [_mint(address to, uint256 tokenId)](#_mint)
- [_burn(address owner, uint256 tokenId)](#_burn)
- [_tokensOfOwner(address owner)](#_tokensofowner)
- [_addTokenToOwnerEnumeration(address to, uint256 tokenId)](#_addtokentoownerenumeration)
- [_addTokenToAllTokensEnumeration(uint256 tokenId)](#_addtokentoalltokensenumeration)
- [_removeTokenFromOwnerEnumeration(address from, uint256 tokenId)](#_removetokenfromownerenumeration)
- [_removeTokenFromAllTokensEnumeration(uint256 tokenId)](#_removetokenfromalltokensenumeration)

### initialize

⤾ overrides [ERC721.initialize](ERC721.md#initialize)

Constructor function.

```js
function initialize() public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### _hasBeenInitialized

⤾ overrides [ERC721._hasBeenInitialized](ERC721.md#_hasbeeninitialized)

```js
function _hasBeenInitialized() internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### tokenOfOwnerByIndex

⤾ overrides [IERC721Enumerable.tokenOfOwnerByIndex](IERC721Enumerable.md#tokenofownerbyindex)

Gets the token ID at a given index of the tokens list of the requested owner.

```js
function tokenOfOwnerByIndex(address owner, uint256 index) public view
returns(uint256)
```

**Returns**

uint256 token ID at the given index of the tokens list owned by the requested address

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address | address owning the tokens list to be accessed | 
| index | uint256 | uint256 representing the index to be accessed of the requested tokens list | 

### totalSupply

⤾ overrides [IERC721Enumerable.totalSupply](IERC721Enumerable.md#totalsupply)

Gets the total amount of tokens stored by the contract.

```js
function totalSupply() public view
returns(uint256)
```

**Returns**

uint256 representing the total amount of tokens

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### tokenByIndex

⤾ overrides [IERC721Enumerable.tokenByIndex](IERC721Enumerable.md#tokenbyindex)

Gets the token ID at a given index of all the tokens in this contract
Reverts if the index is greater or equal to the total number of tokens.

```js
function tokenByIndex(uint256 index) public view
returns(uint256)
```

**Returns**

uint256 token ID at the given index of the tokens list

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 | uint256 representing the index to be accessed of the tokens list | 

### _transferFrom

⤾ overrides [ERC721._transferFrom](ERC721.md#_transferfrom)

Internal function to transfer ownership of a given token ID to another address.
As opposed to transferFrom, this imposes no restrictions on msg.sender.

```js
function _transferFrom(address from, address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address | current owner of the token | 
| to | address | address to receive the ownership of the given token ID | 
| tokenId | uint256 | uint256 ID of the token to be transferred | 

### _mint

⤾ overrides [ERC721._mint](ERC721.md#_mint)

Internal function to mint a new token.
Reverts if the given token ID already exists.

```js
function _mint(address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address | address the beneficiary that will own the minted token | 
| tokenId | uint256 | uint256 ID of the token to be minted | 

### _burn

⤾ overrides [ERC721._burn](ERC721.md#_burn)

Internal function to burn a specific token.
Reverts if the token does not exist.
Deprecated, use {ERC721-_burn} instead.

```js
function _burn(address owner, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address | owner of the token to burn | 
| tokenId | uint256 | uint256 ID of the token being burned | 

### _tokensOfOwner

Gets the list of token IDs of the requested owner.

```js
function _tokensOfOwner(address owner) internal view
returns(uint256[])
```

**Returns**

uint256[] List of token IDs owned by the requested address

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address | address owning the tokens | 

### _addTokenToOwnerEnumeration

Private function to add a token to this extension's ownership-tracking data structures.

```js
function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address | address representing the new owner of the given token ID | 
| tokenId | uint256 | uint256 ID of the token to be added to the tokens list of the given address | 

### _addTokenToAllTokensEnumeration

Private function to add a token to this extension's token tracking data structures.

```js
function _addTokenToAllTokensEnumeration(uint256 tokenId) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 | uint256 ID of the token to be added to the tokens list | 

### _removeTokenFromOwnerEnumeration

Private function to remove a token from this extension's ownership-tracking data structures. Note that
while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
gas optimizations e.g. when performing a transfer operation (avoiding double writes).
This has O(1) time complexity, but alters the order of the _ownedTokens array.

```js
function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address | address representing the previous owner of the given token ID | 
| tokenId | uint256 | uint256 ID of the token to be removed from the tokens list of the given address | 

### _removeTokenFromAllTokensEnumeration

Private function to remove a token from this extension's token tracking data structures.
This has O(1) time complexity, but alters the order of the _allTokens array.

```js
function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 | uint256 ID of the token to be removed from the tokens list | 

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
