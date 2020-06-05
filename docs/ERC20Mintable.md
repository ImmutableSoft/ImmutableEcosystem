# ERC20Mintable.sol

View Source: [@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol](../@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol)

**↗ Extends: [Initializable](Initializable.md), [ERC20](ERC20.md), [MinterRole](MinterRole.md)**
**↘ Derived Contracts: [CustomToken](CustomToken.md), [ImmuteToken](ImmuteToken.md)**

**ERC20Mintable**

Extension of {ERC20} that adds a set of accounts with the {MinterRole},
which have permission to mint (create) new tokens as they see fit.
 * At construction, the deployer of the contract is the only minter.

## Contract Members
**Constants & Variables**

```js
uint256[50] private ______gap;

```

## Functions

- [initialize(address sender)](#initialize)
- [mint(address account, uint256 amount)](#mint)

### initialize

⤾ overrides [MinterRole.initialize](MinterRole.md#initialize)

⤿ Overridden Implementation(s): [ERC20Pausable.initialize](ERC20Pausable.md#initialize),[Pausable.initialize](Pausable.md#initialize),[PauserRole.initialize](PauserRole.md#initialize)

```js
function initialize(address sender) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| sender | address |  | 

### mint

See {ERC20-_mint}.
     * Requirements:
     * - the caller must have the {MinterRole}.

```js
function mint(address account, uint256 amount) public nonpayable onlyMinter 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account | address |  | 
| amount | uint256 |  | 

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
