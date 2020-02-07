# Pausable.sol

View Source: [@openzeppelin/contracts/lifecycle/Pausable.sol](../@openzeppelin/contracts/lifecycle/Pausable.sol)

**↗ Extends: [Context](Context.md), [PauserRole](PauserRole.md)**
**↘ Derived Contracts: [ERC20Pausable](ERC20Pausable.md)**

**Pausable**

Contract module which allows children to implement an emergency stop
mechanism that can be triggered by an authorized account.
 * This module is used through inheritance. It will make available the
modifiers `whenNotPaused` and `whenPaused`, which can be applied to
the functions of your contract. Note that they will not be pausable by
simply including this module, only once the modifiers are put in place.

## Contract Members
**Constants & Variables**

```js
bool private _paused;

```

**Events**

```js
event Paused(address  account);
event Unpaused(address  account);
```

## Modifiers

- [whenNotPaused](#whennotpaused)
- [whenPaused](#whenpaused)

### whenNotPaused

Modifier to make a function callable only when the contract is not paused.

```js
modifier whenNotPaused() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### whenPaused

Modifier to make a function callable only when the contract is paused.

```js
modifier whenPaused() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [()](#)
- [paused()](#paused)
- [pause()](#pause)
- [unpause()](#unpause)

### 

Initializes the contract in unpaused state. Assigns the Pauser role
to the deployer.

```js
function () internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### paused

Returns true if the contract is paused, and false otherwise.

```js
function paused() public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### pause

Called by a pauser to pause, triggers stopped state.

```js
function pause() public nonpayable onlyPauser whenNotPaused 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### unpause

Called by a pauser to unpause, returns to normal state.

```js
function unpause() public nonpayable onlyPauser whenPaused 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

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
