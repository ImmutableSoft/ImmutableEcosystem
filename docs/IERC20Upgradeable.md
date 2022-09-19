# IERC20Upgradeable.sol

View Source: [@openzeppelin\contracts-upgradeable\token\ERC20\IERC20Upgradeable.sol](..\@openzeppelin\contracts-upgradeable\token\ERC20\IERC20Upgradeable.sol)

**↘ Derived Contracts: [ERC20Upgradeable](ERC20Upgradeable.md), [IERC20MetadataUpgradeable](IERC20MetadataUpgradeable.md)**

**IERC20Upgradeable**

Interface of the ERC20 standard as defined in the EIP.

**Events**

```js
event Transfer(address indexed from, address indexed to, uint256  value);
event Approval(address indexed owner, address indexed spender, uint256  value);
```

## Functions

- [totalSupply()](#totalsupply)
- [balanceOf(address account)](#balanceof)
- [transfer(address to, uint256 amount)](#transfer)
- [allowance(address owner, address spender)](#allowance)
- [approve(address spender, uint256 amount)](#approve)
- [transferFrom(address from, address to, uint256 amount)](#transferfrom)

### totalSupply

Returns the amount of tokens in existence.

```js
function totalSupply() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### balanceOf

Returns the amount of tokens owned by `account`.

```js
function balanceOf(address account) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account | address |  | 

### transfer

Moves `amount` tokens from the caller's account to `to`.
 Returns a boolean value indicating whether the operation succeeded.
 Emits a {Transfer} event.

```js
function transfer(address to, uint256 amount) external nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address |  | 
| amount | uint256 |  | 

### allowance

Returns the remaining number of tokens that `spender` will be
 allowed to spend on behalf of `owner` through {transferFrom}. This is
 zero by default.
 This value changes when {approve} or {transferFrom} are called.

```js
function allowance(address owner, address spender) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address |  | 
| spender | address |  | 

### approve

Sets `amount` as the allowance of `spender` over the caller's tokens.
 Returns a boolean value indicating whether the operation succeeded.
 IMPORTANT: Beware that changing an allowance with this method brings the risk
 that someone may use both the old and the new allowance by unfortunate
 transaction ordering. One possible solution to mitigate this race
 condition is to first reduce the spender's allowance to 0 and set the
 desired value afterwards:
 https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
 Emits an {Approval} event.

```js
function approve(address spender, uint256 amount) external nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| spender | address |  | 
| amount | uint256 |  | 

### transferFrom

Moves `amount` tokens from `from` to `to` using the
 allowance mechanism. `amount` is then deducted from the caller's
 allowance.
 Returns a boolean value indicating whether the operation succeeded.
 Emits a {Transfer} event.

```js
function transferFrom(address from, address to, uint256 amount) external nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| amount | uint256 |  | 

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
