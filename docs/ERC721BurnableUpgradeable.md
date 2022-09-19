# ERC721 Burnable Token (ERC721BurnableUpgradeable.sol)

View Source: [@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721BurnableUpgradeable.sol](..\@openzeppelin\contracts-upgradeable\token\ERC721\extensions\ERC721BurnableUpgradeable.sol)

**↗ Extends: [Initializable](Initializable.md), [ContextUpgradeable](ContextUpgradeable.md), [ERC721Upgradeable](ERC721Upgradeable.md)**
**↘ Derived Contracts: [ActivateToken](ActivateToken.md), [CreatorToken](CreatorToken.md)**

**ERC721BurnableUpgradeable**

ERC721 Token that can be irreversibly burned (destroyed).

## Contract Members
**Constants & Variables**

```js
uint256[50] private __gap;

```

## Functions

- [__ERC721Burnable_init()](#__erc721burnable_init)
- [__ERC721Burnable_init_unchained()](#__erc721burnable_init_unchained)
- [burn(uint256 tokenId)](#burn)

### __ERC721Burnable_init

```js
function __ERC721Burnable_init() internal nonpayable onlyInitializing 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### __ERC721Burnable_init_unchained

```js
function __ERC721Burnable_init_unchained() internal nonpayable onlyInitializing 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### burn

Burns `tokenId`. See {ERC721-_burn}.
 Requirements:
 - The caller must own `tokenId` or be an approved operator.

```js
function burn(uint256 tokenId) public nonpayable
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
