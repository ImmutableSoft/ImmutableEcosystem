# The Immutable License - authentic software from the source (ImmutableLicense.sol)

View Source: [contracts/ImmutableLicense.sol](../contracts/ImmutableLicense.sol)

**↗ Extends: [Ownable](Ownable.md), [ImmutableConstants](ImmutableConstants.md)**

**ImmutableLicense**

License elements and methods

## Structs
### LicenseOffer

```js
struct LicenseOffer {
 uint256 priceInTokens,
 uint256 resellMinTokens,
 uint256 escrow
}
```

### License

```js
struct License {
 uint256 entityID,
 uint256 productID,
 uint256 licenseValue,
 uint256 entityOwner,
 address owner,
 uint256 priceInTokens
}
```

## Contract Members
**Constants & Variables**

```js
mapping(uint256 => struct ImmutableLicense.License) private Licenses;
mapping(uint256 => mapping(uint256 => struct ImmutableLicense.LicenseOffer)) private LicenseOffers;
contract ImmutableProduct private productInterface;
contract ImmutableEntity private entityInterface;
contract ImmuteToken private tokenInterface;

```

**Events**

```js
event licenseOfferEvent(uint256  entityIndex, uint256  productIndex, string  entityName, uint256  priceInTokens);
event licenseOfferResaleEvent(address  seller, uint256  sellerIndex, uint256  entityIndex, uint256  productIndex, uint256  licenseHash, uint256  priceInTokens);
event licensePurchaseEvent(uint256  entityIndex, uint256  productIndex);
```

## Functions

- [(address productAddr, address entityAddr, address tokenAddr)](#)
- [licenseOffer(uint256 productIndex, uint256 priceInTokens, uint256 resellMinTokens)](#licenseoffer)
- [licenseTransferEscrow(uint256 entityIndex, uint256 productIndex)](#licensetransferescrow)
- [license_product(uint256 entityIndex, uint256 productIndex, uint256 hash, uint256 value)](#license_product)
- [licenseCreate(uint256 productIndex, uint256 licenseHash, uint256 licenseValue)](#licensecreate)
- [licensePurchase(uint256 entityIndex, uint256 productIndex, uint256 licenseHash)](#licensepurchase)
- [licensePurchaseInETH(uint256 entityIndex, uint256 productIndex, uint256 licenseHash)](#licensepurchaseineth)
- [licenseMove(uint256 entityIndex, uint256 productIndex, uint256 oldLicenseHash, uint256 newLicenseHash)](#licensemove)
- [licenseOfferResale(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 priceInTokens)](#licenseofferresale)
- [licenseTransfer(uint256 entityIndex, uint256 productIndex, uint256 licenseHash)](#licensetransfer)
- [licenseTokensWithdraw()](#licensetokenswithdraw)
- [licenseTokenEscrow()](#licensetokenescrow)
- [licenseValid(uint256 entityIndex, uint256 productIndex, uint256 licenseHash)](#licensevalid)
- [licenseOfferDetails(uint256 entityIndex, uint256 productIndex)](#licenseofferdetails)
- [licenseLookupHash(uint256 entityIndex, uint256 productIndex, uint256 licenseHash)](#licenselookuphash)

### 

contract initializer/constructor

```js
function (address productAddr, address entityAddr, address tokenAddr) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productAddr | address | the address of the ImmutableProduct contract | 
| entityAddr | address | the address of the ImmutableEntity contract | 
| tokenAddr | address | the address of the IuT token contract | 

### licenseOffer

Offer a software product license for sale

```js
function licenseOffer(uint256 productIndex, uint256 priceInTokens, uint256 resellMinTokens) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| priceInTokens | uint256 | The token cost to purchase activation | 
| resellMinTokens | uint256 | The minimum token cost to resell license
                        zero (0) prevents resale | 

### licenseTransferEscrow

Transfer tokens to a product offer escrow

```js
function licenseTransferEscrow(uint256 entityIndex, uint256 productIndex) private nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity offering the product license | 
| productIndex | uint256 | The specific ID of the product | 

### license_product

Create a product license

```js
function license_product(uint256 entityIndex, uint256 productIndex, uint256 hash, uint256 value) private nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The local entity index of the license | 
| productIndex | uint256 | The specific ID of the product | 
| hash | uint256 | The external license activation hash | 
| value | uint256 | The activation value | 

### licenseCreate

Create manual product activation license for end user

```js
function licenseCreate(uint256 productIndex, uint256 licenseHash, uint256 licenseValue) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the activation license hash from end user | 
| licenseValue | uint256 | the value of the license (0 is unlicensed) | 

### licensePurchase

Purchase a software product activation license

```js
function licensePurchase(uint256 entityIndex, uint256 productIndex, uint256 licenseHash) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity offering the product license | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the end user unique identifier to activate | 

### licensePurchaseInETH

Purchase a software product activation license in ETH

```js
function licensePurchaseInETH(uint256 entityIndex, uint256 productIndex, uint256 licenseHash) external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity offering the product license | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the end user unique identifier to activate | 

### licenseMove

Move a software product activation license

```js
function licenseMove(uint256 entityIndex, uint256 productIndex, uint256 oldLicenseHash, uint256 newLicenseHash) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity who owns the product | 
| productIndex | uint256 | The specific ID of the product | 
| oldLicenseHash | uint256 | the existing activation identifier | 
| newLicenseHash | uint256 | the new activation identifier | 

### licenseOfferResale

Offer a software product license for resale

```js
function licenseOfferResale(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 priceInTokens) external nonpayable
```

**Returns**

The product license offer identifier

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity who owns the product | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the existing activation identifier | 
| priceInTokens | uint256 | The token cost to purchase license | 

### licenseTransfer

Transfer/Resell a software product activation license

```js
function licenseTransfer(uint256 entityIndex, uint256 productIndex, uint256 licenseHash) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity who owns the product | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the existing activation identifier to purchase | 

### licenseTokensWithdraw

Withdraw tokens in escrow (accumulated product license sales)

```js
function licenseTokensWithdraw() external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### licenseTokenEscrow

Check balance of escrowed product licenses

```js
function licenseTokenEscrow() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### licenseValid

Check if end user is activated for use of a product

```js
function licenseValid(uint256 entityIndex, uint256 productIndex, uint256 licenseHash) external view
returns(uint256)
```

**Returns**

the license value (> 0 is valid)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity the product license is for | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the external unique identifier to activate | 

### licenseOfferDetails

Return the price of a product activation license

```js
function licenseOfferDetails(uint256 entityIndex, uint256 productIndex) public view
returns(uint256, uint256)
```

**Returns**

the price in tokens for the activation license

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity with offer | 
| productIndex | uint256 | The product ID of the new release | 

### licenseLookupHash

Return the internal activation license hash

```js
function licenseLookupHash(uint256 entityIndex, uint256 productIndex, uint256 licenseHash) private view
returns(uint256)
```

**Returns**

the internal activation license hash

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity with offer | 
| productIndex | uint256 | The product ID of the new release | 
| licenseHash | uint256 | The external license hash | 

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
