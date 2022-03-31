# ContextUpgradeable.sol

View Source: [@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol](../@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol)

**↗ Extends: [Initializable](Initializable.md)**
**↘ Derived Contracts: [ERC20Upgradeable](ERC20Upgradeable.md), [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md), [ERC721Upgradeable](ERC721Upgradeable.md), [OwnableUpgradeable](OwnableUpgradeable.md)**

**ContextUpgradeable**

Provides information about the current execution context, including the
 sender of the transaction and its data. While these are generally available
 via msg.sender and msg.data, they should not be accessed in such a direct
 manner, since when dealing with meta-transactions the account sending and
 paying for execution may not be the actual sender (as far as an application
 is concerned).
 This contract is only required for intermediate, library-like contracts.

## Contract Members
**Constants & Variables**

```js
uint256[50] private __gap;

```

## Functions

- [__Context_init()](#__context_init)
- [__Context_init_unchained()](#__context_init_unchained)
- [_msgSender()](#_msgsender)
- [_msgData()](#_msgdata)

### __Context_init

```js
function __Context_init() internal nonpayable onlyInitializing 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### __Context_init_unchained

```js
function __Context_init_unchained() internal nonpayable onlyInitializing 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### _msgSender

```js
function _msgSender() internal view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### _msgData

```js
function _msgData() internal view
returns(bytes)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

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
