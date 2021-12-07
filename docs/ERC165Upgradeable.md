# ERC165Upgradeable.sol

View Source: [@openzeppelin\contracts-upgradeable\utils\introspection\ERC165Upgradeable.sol](..\@openzeppelin\contracts-upgradeable\utils\introspection\ERC165Upgradeable.sol)

**↗ Extends: [Initializable](Initializable.md), [IERC165Upgradeable](IERC165Upgradeable.md)**
**↘ Derived Contracts: [ERC721Upgradeable](ERC721Upgradeable.md)**

**ERC165Upgradeable**

Implementation of the {IERC165} interface.
 Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 for the additional interface id that will be supported. For example:
 ```solidity
 function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 }
 ```
 Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.

## Contract Members
**Constants & Variables**

```js
uint256[50] private __gap;

```

## Functions

- [__ERC165_init()](#__erc165_init)
- [__ERC165_init_unchained()](#__erc165_init_unchained)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)

### __ERC165_init

```js
function __ERC165_init() internal nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### __ERC165_init_unchained

```js
function __ERC165_init_unchained() internal nonpayable initializer 
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
