# Pausable token (ERC20Pausable.sol)

View Source: [@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Pausable.sol](../@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Pausable.sol)

**↗ Extends: [Initializable](Initializable.md), [ERC20](ERC20.md), [Pausable](Pausable.md)**
**↘ Derived Contracts: [ImmuteToken](ImmuteToken.md)**

**ERC20Pausable**

ERC20 with pausable transfers and allowances.
 * Useful if you want to stop trades until the end of a crowdsale, or have
an emergency switch for freezing all token transfers in the event of a large
bug.

## Contract Members
**Constants & Variables**

```js
uint256[50] private ______gap;

```

## Functions

- [initialize(address sender)](#initialize)
- [transfer(address to, uint256 value)](#transfer)
- [transferFrom(address from, address to, uint256 value)](#transferfrom)
- [approve(address spender, uint256 value)](#approve)
- [increaseAllowance(address spender, uint256 addedValue)](#increaseallowance)
- [decreaseAllowance(address spender, uint256 subtractedValue)](#decreaseallowance)

### initialize

⤾ overrides [Pausable.initialize](Pausable.md#initialize)

```js
function initialize(address sender) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| sender | address |  | 

### transfer

⤾ overrides [ERC20.transfer](ERC20.md#transfer)

⤿ Overridden Implementation(s): [ImmuteToken.transfer](ImmuteToken.md#transfer)

```js
function transfer(address to, uint256 value) public nonpayable whenNotPaused 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address |  | 
| value | uint256 |  | 

### transferFrom

⤾ overrides [ERC20.transferFrom](ERC20.md#transferfrom)

⤿ Overridden Implementation(s): [ImmuteToken.transferFrom](ImmuteToken.md#transferfrom)

```js
function transferFrom(address from, address to, uint256 value) public nonpayable whenNotPaused 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| value | uint256 |  | 

### approve

⤾ overrides [ERC20.approve](ERC20.md#approve)

```js
function approve(address spender, uint256 value) public nonpayable whenNotPaused 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| spender | address |  | 
| value | uint256 |  | 

### increaseAllowance

⤾ overrides [ERC20.increaseAllowance](ERC20.md#increaseallowance)

```js
function increaseAllowance(address spender, uint256 addedValue) public nonpayable whenNotPaused 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| spender | address |  | 
| addedValue | uint256 |  | 

### decreaseAllowance

⤾ overrides [ERC20.decreaseAllowance](ERC20.md#decreaseallowance)

```js
function decreaseAllowance(address spender, uint256 subtractedValue) public nonpayable whenNotPaused 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| spender | address |  | 
| subtractedValue | uint256 |  | 

## Contracts

* [Address](Address.md)
* [AddrResolver](AddrResolver.md)
* [Context](Context.md)
* [CustomToken](CustomToken.md)
* [ENS](ENS.md)
* [ERC20](ERC20.md)
* [ERC20Detailed](ERC20Detailed.md)
* [ERC20Mintable](ERC20Mintable.md)
* [ERC20Pausable](ERC20Pausable.md)
* [Escrow](Escrow.md)
* [IERC20](IERC20.md)
* [ImmutableConstants](ImmutableConstants.md)
* [ImmutableEntity](ImmutableEntity.md)
* [ImmutableLicense](ImmutableLicense.md)
* [ImmutableProduct](ImmutableProduct.md)
* [ImmutableResolver](ImmutableResolver.md)
* [ImmuteToken](ImmuteToken.md)
* [Initializable](Initializable.md)
* [Migrations](Migrations.md)
* [MinterRole](MinterRole.md)
* [Ownable](Ownable.md)
* [Pausable](Pausable.md)
* [PauserRole](PauserRole.md)
* [PullPayment](PullPayment.md)
* [ResolverBase](ResolverBase.md)
* [Roles](Roles.md)
* [SafeMath](SafeMath.md)
* [Secondary](Secondary.md)
* [StringCommon](StringCommon.md)
