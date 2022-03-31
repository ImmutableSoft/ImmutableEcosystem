# ERC721EnumerableUpgradeable.sol

View Source: [@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol](../@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol)

**↗ Extends: [Initializable](Initializable.md), [ERC721Upgradeable](ERC721Upgradeable.md), [IERC721EnumerableUpgradeable](IERC721EnumerableUpgradeable.md)**
**↘ Derived Contracts: [ActivateToken](ActivateToken.md), [CreatorToken](CreatorToken.md)**

**ERC721EnumerableUpgradeable**

This implements an optional extension of {ERC721} defined in the EIP that adds
 enumerability of all the token ids in the contract as well as all token ids owned by each
 account.

## Contract Members
**Constants & Variables**

```js
mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
mapping(uint256 => uint256) private _ownedTokensIndex;
uint256[] private _allTokens;
mapping(uint256 => uint256) private _allTokensIndex;
uint256[46] private __gap;

```

## Functions

- [__ERC721Enumerable_init()](#__erc721enumerable_init)
- [__ERC721Enumerable_init_unchained()](#__erc721enumerable_init_unchained)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)
- [tokenOfOwnerByIndex(address owner, uint256 index)](#tokenofownerbyindex)
- [totalSupply()](#totalsupply)
- [tokenByIndex(uint256 index)](#tokenbyindex)
- [_beforeTokenTransfer(address from, address to, uint256 tokenId)](#_beforetokentransfer)
- [_addTokenToOwnerEnumeration(address to, uint256 tokenId)](#_addtokentoownerenumeration)
- [_addTokenToAllTokensEnumeration(uint256 tokenId)](#_addtokentoalltokensenumeration)
- [_removeTokenFromOwnerEnumeration(address from, uint256 tokenId)](#_removetokenfromownerenumeration)
- [_removeTokenFromAllTokensEnumeration(uint256 tokenId)](#_removetokenfromalltokensenumeration)

### __ERC721Enumerable_init

```js
function __ERC721Enumerable_init() internal nonpayable onlyInitializing 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### __ERC721Enumerable_init_unchained

```js
function __ERC721Enumerable_init_unchained() internal nonpayable onlyInitializing 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### supportsInterface

See {IERC165-supportsInterface}.

```js
function supportsInterface(bytes4 interfaceId) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| interfaceId | bytes4 |  | 

### tokenOfOwnerByIndex

See {IERC721Enumerable-tokenOfOwnerByIndex}.

```js
function tokenOfOwnerByIndex(address owner, uint256 index) public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address |  | 
| index | uint256 |  | 

### totalSupply

See {IERC721Enumerable-totalSupply}.

```js
function totalSupply() public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### tokenByIndex

See {IERC721Enumerable-tokenByIndex}.

```js
function tokenByIndex(uint256 index) public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 |  | 

### _beforeTokenTransfer

Hook that is called before any token transfer. This includes minting
 and burning.
 Calling conditions:
 - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
 transferred to `to`.
 - When `from` is zero, `tokenId` will be minted for `to`.
 - When `to` is zero, ``from``'s `tokenId` will be burned.
 - `from` cannot be the zero address.
 - `to` cannot be the zero address.
 To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

```js
function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 

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
* [AddressUpgradeable](AddressUpgradeable.md)
* [ContextUpgradeable](ContextUpgradeable.md)
* [CreatorToken](CreatorToken.md)
* [CustomToken](CustomToken.md)
* [ERC165Upgradeable](ERC165Upgradeable.md)
* [ERC20Upgradeable](ERC20Upgradeable.md)
* [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md)
* [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md)
* [ERC721Upgradeable](ERC721Upgradeable.md)
* [ERC721URIStorageUpgradeable](ERC721URIStorageUpgradeable.md)
* [IERC165Upgradeable](IERC165Upgradeable.md)
* [IERC20MetadataUpgradeable](IERC20MetadataUpgradeable.md)
* [IERC20Upgradeable](IERC20Upgradeable.md)
* [IERC721EnumerableUpgradeable](IERC721EnumerableUpgradeable.md)
* [IERC721MetadataUpgradeable](IERC721MetadataUpgradeable.md)
* [IERC721ReceiverUpgradeable](IERC721ReceiverUpgradeable.md)
* [IERC721Upgradeable](IERC721Upgradeable.md)
* [ImmutableEntity](ImmutableEntity.md)
* [ImmutableProduct](ImmutableProduct.md)
* [Initializable](Initializable.md)
* [Migrations](Migrations.md)
* [OwnableUpgradeable](OwnableUpgradeable.md)
* [ProductActivate](ProductActivate.md)
* [StringCommon](StringCommon.md)
* [StringsUpgradeable](StringsUpgradeable.md)
