# ERC721URIStorageUpgradeable.sol

View Source: [@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721URIStorageUpgradeable.sol](..\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721URIStorageUpgradeable.sol)

**↗ Extends: [Initializable](Initializable.md), [ERC721Upgradeable](ERC721Upgradeable.md)**
**↘ Derived Contracts: [CreatorToken](CreatorToken.md)**

**ERC721URIStorageUpgradeable**

ERC721 token with storage based token URI management.

## Contract Members
**Constants & Variables**

```js
mapping(uint256 => string) private _tokenURIs;
uint256[49] private __gap;

```

## Functions

- [__ERC721URIStorage_init()](#__erc721uristorage_init)
- [__ERC721URIStorage_init_unchained()](#__erc721uristorage_init_unchained)
- [tokenURI(uint256 tokenId)](#tokenuri)
- [_setTokenURI(uint256 tokenId, string _tokenURI)](#_settokenuri)
- [_burn(uint256 tokenId)](#_burn)

### __ERC721URIStorage_init

```js
function __ERC721URIStorage_init() internal nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### __ERC721URIStorage_init_unchained

```js
function __ERC721URIStorage_init_unchained() internal nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### tokenURI

See {IERC721Metadata-tokenURI}.

```js
function tokenURI(uint256 tokenId) public view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 

### _setTokenURI

Sets `_tokenURI` as the tokenURI of `tokenId`.
 Requirements:
 - `tokenId` must exist.

```js
function _setTokenURI(uint256 tokenId, string _tokenURI) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 
| _tokenURI | string |  | 

### _burn

Destroys `tokenId`.
 The approval is cleared when the token is burned.
 Requirements:
 - `tokenId` must exist.
 Emits a {Transfer} event.

```js
function _burn(uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 

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
* [EscrowUpgradeable](EscrowUpgradeable.md)
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
* [PullPaymentUpgradeable](PullPaymentUpgradeable.md)
* [StringCommon](StringCommon.md)
* [StringsUpgradeable](StringsUpgradeable.md)
