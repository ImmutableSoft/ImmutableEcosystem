# Initializable.sol

View Source: [@openzeppelin\contracts-upgradeable\proxy\utils\Initializable.sol](..\@openzeppelin\contracts-upgradeable\proxy\utils\Initializable.sol)

**↘ Derived Contracts: [ActivateToken](ActivateToken.md), [ContextUpgradeable](ContextUpgradeable.md), [CreatorToken](CreatorToken.md), [CustomToken](CustomToken.md), [ERC165Upgradeable](ERC165Upgradeable.md), [ERC20Upgradeable](ERC20Upgradeable.md), [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md), [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md), [ERC721Upgradeable](ERC721Upgradeable.md), [ERC721URIStorageUpgradeable](ERC721URIStorageUpgradeable.md), [ImmutableEntity](ImmutableEntity.md), [ImmutableProduct](ImmutableProduct.md), [OwnableUpgradeable](OwnableUpgradeable.md), [ProductActivate](ProductActivate.md), [StringCommon](StringCommon.md)**

**Initializable**

This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 case an upgrade adds a module that needs to be initialized.
 For example:
 [.hljs-theme-light.nopadding]
 ```
 contract MyToken is ERC20Upgradeable {
     function initialize() initializer public {
         __ERC20_init("MyToken", "MTK");
     }
 }
 contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
     function initializeV2() reinitializer(2) public {
         __ERC20Permit_init("MyToken");
     }
 }
 ```
 TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 [CAUTION]
 ====
 Avoid leaving a contract uninitialized.
 An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 [.hljs-theme-light.nopadding]
 ```
 ///

## Contract Members
**Constants & Variables**

```js
uint8 private _initialized;
bool private _initializing;

```

**Events**

```js
event Initialized(uint8  version);
```

## Modifiers

- [initializer](#initializer)
- [reinitializer](#reinitializer)
- [onlyInitializing](#onlyinitializing)

### initializer

A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
 `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.

```js
modifier initializer() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### reinitializer

A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
 contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
 used to initialize parent contracts.
 `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
 initialization step. This is essential to configure modules that are added through upgrades and that require
 initialization.
 Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
 a contract, executing them in the right order is up to the developer or operator.

```js
modifier reinitializer(uint8 version) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| version | uint8 |  | 

### onlyInitializing

Modifier to protect an initialization function so that it can only be invoked by functions with the
 {initializer} and {reinitializer} modifiers, directly or indirectly.

```js
modifier onlyInitializing() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [_disableInitializers()](#_disableinitializers)
- [_setInitializedVersion(uint8 version)](#_setinitializedversion)

### _disableInitializers

Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
 Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
 to any version. It is recommended to use this to lock implementation contracts that are designed to be called
 through proxies.

```js
function _disableInitializers() internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### _setInitializedVersion

```js
function _setInitializedVersion(uint8 version) private nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| version | uint8 |  | 

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
