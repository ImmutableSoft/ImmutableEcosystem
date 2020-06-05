# Secondary.sol

View Source: [@openzeppelin/contracts-ethereum-package/contracts/ownership/Secondary.sol](../@openzeppelin/contracts-ethereum-package/contracts/ownership/Secondary.sol)

**↗ Extends: [Initializable](Initializable.md), [Context](Context.md)**
**↘ Derived Contracts: [Escrow](Escrow.md)**

**Secondary**

A Secondary contract can only be used by its primary account (the one that created it).

## Contract Members
**Constants & Variables**

```js
address private _primary;
uint256[50] private ______gap;

```

**Events**

```js
event PrimaryTransferred(address  recipient);
```

## Modifiers

- [onlyPrimary](#onlyprimary)

### onlyPrimary

Reverts if called from any account other than the primary.

```js
modifier onlyPrimary() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [initialize(address sender)](#initialize)
- [primary()](#primary)
- [transferPrimary(address recipient)](#transferprimary)

### initialize

⤿ Overridden Implementation(s): [Escrow.initialize](Escrow.md#initialize)

Sets the primary account to the one that is creating the Secondary contract.

```js
function initialize(address sender) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| sender | address |  | 

### primary

```js
function primary() public view
returns(address)
```

**Returns**

the address of the primary.

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### transferPrimary

Transfers contract to a new primary.

```js
function transferPrimary(address recipient) public nonpayable onlyPrimary 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| recipient | address | The address of new primary. | 

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
