# Ownable.sol

View Source: [@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol](../@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol)

**↗ Extends: [Initializable](Initializable.md), [Context](Context.md)**
**↘ Derived Contracts: [CustomToken](CustomToken.md), [ImmutableEntity](ImmutableEntity.md), [ImmutableLicense](ImmutableLicense.md), [ImmutableProduct](ImmutableProduct.md), [ImmutableResolver](ImmutableResolver.md), [ImmuteToken](ImmuteToken.md)**

**Ownable**

Contract module which provides a basic access control mechanism, where
there is an account (an owner) that can be granted exclusive access to
specific functions.
 * This module is used through inheritance. It will make available the modifier
`onlyOwner`, which can be aplied to your functions to restrict their use to
the owner.

## Contract Members
**Constants & Variables**

```js
address private _owner;
uint256[50] private ______gap;

```

**Events**

```js
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
```

## Modifiers

- [onlyOwner](#onlyowner)

### onlyOwner

Throws if called by any account other than the owner.

```js
modifier onlyOwner() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [initialize(address sender)](#initialize)
- [owner()](#owner)
- [isOwner()](#isowner)
- [renounceOwnership()](#renounceownership)
- [transferOwnership(address newOwner)](#transferownership)
- [_transferOwnership(address newOwner)](#_transferownership)

### initialize

⤿ Overridden Implementation(s): [ERC20Mintable.initialize](ERC20Mintable.md#initialize),[ERC20Pausable.initialize](ERC20Pausable.md#initialize),[MinterRole.initialize](MinterRole.md#initialize),[Pausable.initialize](Pausable.md#initialize),[PauserRole.initialize](PauserRole.md#initialize)

Initializes the contract setting the deployer as the initial owner.

```js
function initialize(address sender) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| sender | address |  | 

### owner

Returns the address of the current owner.

```js
function owner() public view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### isOwner

Returns true if the caller is the current owner.

```js
function isOwner() public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### renounceOwnership

Leaves the contract without owner. It will not be possible to call
`onlyOwner` functions anymore. Can only be called by the current owner.
     * > Note: Renouncing ownership will leave the contract without an owner,
thereby removing any functionality that is only available to the owner.

```js
function renounceOwnership() public nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### transferOwnership

Transfers ownership of the contract to a new account (`newOwner`).
Can only be called by the current owner.

```js
function transferOwnership(address newOwner) public nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newOwner | address |  | 

### _transferOwnership

Transfers ownership of the contract to a new account (`newOwner`).

```js
function _transferOwnership(address newOwner) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newOwner | address |  | 

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
