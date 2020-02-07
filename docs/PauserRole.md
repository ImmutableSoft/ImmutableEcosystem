# PauserRole.sol

View Source: [@openzeppelin/contracts/access/roles/PauserRole.sol](../@openzeppelin/contracts/access/roles/PauserRole.sol)

**↗ Extends: [Context](Context.md)**
**↘ Derived Contracts: [Pausable](Pausable.md)**

**PauserRole**

## Contract Members
**Constants & Variables**

```js
struct Roles.Role private _pausers;

```

**Events**

```js
event PauserAdded(address indexed account);
event PauserRemoved(address indexed account);
```

## Modifiers

- [onlyPauser](#onlypauser)

### onlyPauser

```js
modifier onlyPauser() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [()](#)
- [isPauser(address account)](#ispauser)
- [addPauser(address account)](#addpauser)
- [renouncePauser()](#renouncepauser)
- [_addPauser(address account)](#_addpauser)
- [_removePauser(address account)](#_removepauser)

### 

```js
function () internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### isPauser

```js
function isPauser(address account) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account | address |  | 

### addPauser

```js
function addPauser(address account) public nonpayable onlyPauser 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account | address |  | 

### renouncePauser

```js
function renouncePauser() public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### _addPauser

```js
function _addPauser(address account) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account | address |  | 

### _removePauser

```js
function _removePauser(address account) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account | address |  | 

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
