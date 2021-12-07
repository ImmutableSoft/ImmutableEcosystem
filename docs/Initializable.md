# Initializable.sol

View Source: [@openzeppelin\contracts-upgradeable\proxy\utils\Initializable.sol](..\@openzeppelin\contracts-upgradeable\proxy\utils\Initializable.sol)

**↘ Derived Contracts: [ActivateToken](ActivateToken.md), [ContextUpgradeable](ContextUpgradeable.md), [CreatorToken](CreatorToken.md), [CustomToken](CustomToken.md), [ERC165Upgradeable](ERC165Upgradeable.md), [ERC20Upgradeable](ERC20Upgradeable.md), [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md), [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md), [ERC721Upgradeable](ERC721Upgradeable.md), [ERC721URIStorageUpgradeable](ERC721URIStorageUpgradeable.md), [EscrowUpgradeable](EscrowUpgradeable.md), [ImmutableEntity](ImmutableEntity.md), [ImmutableProduct](ImmutableProduct.md), [OwnableUpgradeable](OwnableUpgradeable.md), [ProductActivate](ProductActivate.md), [PullPaymentUpgradeable](PullPaymentUpgradeable.md)**

**Initializable**

This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.

## Contract Members
**Constants & Variables**

```js
bool private _initialized;
bool private _initializing;

```

## Modifiers

- [initializer](#initializer)

### initializer

Modifier to protect an initializer function from being invoked twice.

```js
modifier initializer() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

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
