# ERC-721 Non-Fungible Token Standard, optional enumeration extension (IERC721EnumerableUpgradeable.sol)

View Source: [@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol](../@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol)

**↗ Extends: [IERC721Upgradeable](IERC721Upgradeable.md)**
**↘ Derived Contracts: [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md)**

**IERC721EnumerableUpgradeable**

See https://eips.ethereum.org/EIPS/eip-721

## Functions

- [totalSupply()](#totalsupply)
- [tokenOfOwnerByIndex(address owner, uint256 index)](#tokenofownerbyindex)
- [tokenByIndex(uint256 index)](#tokenbyindex)

### totalSupply

Returns the total amount of tokens stored by the contract.

```js
function totalSupply() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### tokenOfOwnerByIndex

Returns a token ID owned by `owner` at a given `index` of its token list.
 Use along with {balanceOf} to enumerate all of ``owner``'s tokens.

```js
function tokenOfOwnerByIndex(address owner, uint256 index) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address |  | 
| index | uint256 |  | 

### tokenByIndex

Returns a token ID at a given `index` of all the tokens stored by the contract.
 Use along with {totalSupply} to enumerate all tokens.

```js
function tokenByIndex(uint256 index) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 |  | 

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
