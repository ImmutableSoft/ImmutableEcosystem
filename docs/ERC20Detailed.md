# ERC20Detailed.sol

View Source: [@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol](../@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol)

**↗ Extends: [Initializable](Initializable.md), [IERC20](IERC20.md)**
**↘ Derived Contracts: [CustomToken](CustomToken.md)**

**ERC20Detailed**

Optional functions from the ERC20 standard.

## Contract Members
**Constants & Variables**

```js
string private _name;
string private _symbol;
uint8 private _decimals;
uint256[50] private ______gap;

```

## Functions

- [initialize(string name, string symbol, uint8 decimals)](#initialize)
- [name()](#name)
- [symbol()](#symbol)
- [decimals()](#decimals)

### initialize

Sets the values for `name`, `symbol`, and `decimals`. All three of
these values are immutable: they can only be set once during
construction.

```js
function initialize(string name, string symbol, uint8 decimals) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| name | string |  | 
| symbol | string |  | 
| decimals | uint8 |  | 

### name

Returns the name of the token.

```js
function name() public view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### symbol

Returns the symbol of the token, usually a shorter version of the
name.

```js
function symbol() public view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### decimals

Returns the number of decimals used to get its user representation.
For example, if `decimals` equals `2`, a balance of `505` tokens should
be displayed to a user as `5,05` (`505 / 10 ** 2`).
     * Tokens usually opt for a value of 18, imitating the relationship between
Ether and Wei.
     * NOTE: This information is only used for _display_ purposes: it in
no way affects any of the arithmetic of the contract, including
{IERC20-balanceOf} and {IERC20-transfer}.

```js
function decimals() public view
returns(uint8)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

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
