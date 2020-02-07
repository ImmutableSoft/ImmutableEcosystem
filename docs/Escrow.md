# Escrow (Escrow.sol)

View Source: [@openzeppelin/contracts/payment/escrow/Escrow.sol](../@openzeppelin/contracts/payment/escrow/Escrow.sol)

**↗ Extends: [Secondary](Secondary.md)**

**Escrow**

Base escrow contract, holds funds designated for a payee until they
withdraw them.
  * Intended usage: This contract (and derived escrow contracts) should be a
standalone contract, that only interacts with the contract that instantiated
it. That way, it is guaranteed that all Ether will be handled according to
the `Escrow` rules, and there is no need to check for payable functions or
transfers in the inheritance tree. The contract that uses the escrow as its
payment method should be its primary, and provide public methods redirecting
to the escrow's deposit and withdraw.

## Contract Members
**Constants & Variables**

```js
mapping(address => uint256) private _deposits;

```

**Events**

```js
event Deposited(address indexed payee, uint256  weiAmount);
event Withdrawn(address indexed payee, uint256  weiAmount);
```

## Functions

- [depositsOf(address payee)](#depositsof)
- [deposit(address payee)](#deposit)
- [withdraw(address payable payee)](#withdraw)
- [withdrawWithGas(address payable payee)](#withdrawwithgas)

### depositsOf

```js
function depositsOf(address payee) public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address |  | 

### deposit

Stores the sent amount as credit to be withdrawn.

```js
function deposit(address payee) public payable onlyPrimary 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address | The destination address of the funds. | 

### withdraw

Withdraw accumulated balance for a payee, forwarding 2300 gas (a
Solidity `transfer`).
     * NOTE: This function has been deprecated, use {withdrawWithGas} instead.
Calling contracts with fixed-gas limits is an anti-pattern and may break
contract interactions in network upgrades (hardforks).
https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more.]
     *

```js
function withdraw(address payable payee) public nonpayable onlyPrimary 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address payable | The address whose funds will be withdrawn and transferred to. | 

### withdrawWithGas

Same as {withdraw}, but forwarding all gas to the recipient.
     * WARNING: Forwarding all gas opens the door to reentrancy vulnerabilities.
Make sure you trust the recipient, or are either following the
checks-effects-interactions pattern or using {ReentrancyGuard}.
     * _Available since v2.4.0._

```js
function withdrawWithGas(address payable payee) public nonpayable onlyPrimary 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address payable |  | 

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
