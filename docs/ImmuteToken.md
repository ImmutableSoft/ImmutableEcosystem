# Immute (IuT) token, restricted ERC20 (FinHub guidance) (ImmuteToken.sol)

View Source: [contracts/ImmuteToken.sol](../contracts/ImmuteToken.sol)

**↗ Extends: [Ownable](Ownable.md), [ERC20Detailed](ERC20Detailed.md), [ERC20Mintable](ERC20Mintable.md), [ERC20Pausable](ERC20Pausable.md), [PullPayment](PullPayment.md)**

**ImmuteToken**

Token transfers allowed with ImmutableEcosystem only

## Structs
### Promo

```js
struct Promo {
 uint256 algoX,
 uint256 algoY,
 uint256 base
}
```

## Contract Members
**Constants & Variables**

```js
//internal members
uint256 internal constant MaxPromos;

//private members
address payable private bank;
address private entityAddr;
address private productAddr;
address private licenseAddr;
uint256 private ethRate;
struct ImmuteToken.Promo[5] private promos;

```

## Functions

- [(uint256 initialSupply)](#)
- [bankChange(address payable newBank)](#bankchange)
- [rateChange(uint256 newRate)](#ratechange)
- [promoSet(uint256 index, uint256 algoX, uint256 algoY, uint256 base)](#promoset)
- [currentRate()](#currentrate)
- [restrictTransferToContracts(address entityContract, address productContract, address licenseContract)](#restricttransfertocontracts)
- [transfer(address recipient, uint256 amount)](#transfer)
- [transferFrom(address sender, address recipient, uint256 amount)](#transferfrom)
- [checkPayments()](#checkpayments)
- [calculateBonus(uint256 numTokens)](#calculatebonus)
- [transferToBank()](#transfertobank)
- [transferToEscrow()](#transfertoescrow)
- [tokenPurchase()](#tokenpurchase)

### 

contract initializer/constructor

```js
function (uint256 initialSupply) public nonpayable ERC20Detailed ERC20Mintable ERC20Pausable PullPayment 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| initialSupply | uint256 | the initial supply of tokens | 

### bankChange

Change bank that contract pays ETH out too

```js
function bankChange(address payable newBank) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newBank | address payable | The Ethereum address of new ecosystem bank | 

### rateChange

Change exchange rate (ETH to token multiplier)

```js
function rateChange(uint256 newRate) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newRate | uint256 | The new ETH to token multiplier for new purchases | 

### promoSet

Set/Change promotion rate (token bonus calculator)

```js
function promoSet(uint256 index, uint256 algoX, uint256 algoY, uint256 base) public nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 | The promotion to change | 
| algoX | uint256 | The new token X (purchase) amount | 
| algoY | uint256 | The new token Y (bonus) amount | 
| base | uint256 | The base or start of promotion (is purchase size) | 

### currentRate

Retrieve the current ETH to Immute token multiplier (rate)

```js
function currentRate() external view
returns(uint256)
```

**Returns**

The ETH to token multiplier rate for new purchases

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### restrictTransferToContracts

Restrict transfers to ecosystem contract only

```js
function restrictTransferToContracts(address entityContract, address productContract, address licenseContract) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityContract | address | The Immutable entity contract address | 
| productContract | address | The Immutable entity contract address | 
| licenseContract | address | The Immutable entity contract address | 

### transfer

⤾ overrides [ERC20Pausable.transfer](ERC20Pausable.md#transfer)

ImmuteToken transfer must check for restrictions

```js
function transfer(address recipient, uint256 amount) public nonpayable
returns(bool)
```

**Returns**

true if transfer success, false if failed

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| recipient | address | The token recipient | 
| amount | uint256 | The token amount to transfer | 

### transferFrom

⤾ overrides [ERC20Pausable.transferFrom](ERC20Pausable.md#transferfrom)

ImmuteToken transferFrom must check for restrictions

```js
function transferFrom(address sender, address recipient, uint256 amount) public nonpayable
returns(bool)
```

**Returns**

true if transfer success, false if failed

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| sender | address | The token sender | 
| recipient | address | The token recipient | 
| amount | uint256 | The token amount to transfer | 

### checkPayments

Check payment (ETH) due ecosystem bank

```js
function checkPayments() external view
returns(uint256)
```

**Returns**

the entity status as maintained by Immutable

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### calculateBonus

Calculate the promotional bonus

```js
function calculateBonus(uint256 numTokens) public view
returns(uint256)
```

**Returns**

the amount of bonus tokens

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| numTokens | uint256 | the amount of tokens to calculate bonus for | 

### transferToBank

Transfer ecosystem funds to the configured bank address

```js
function transferToBank() external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### transferToEscrow

Transfer ETH funds to the configured bank address

```js
function transferToEscrow() external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### tokenPurchase

Purcahse tokens in exchange for an ETH transfer

```js
function tokenPurchase() external payable
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
