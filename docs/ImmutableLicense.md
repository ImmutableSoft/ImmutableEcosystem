# The Immutable License - automated software sales (ImmutableLicense.sol)

View Source: [contracts/ImmutableLicense.sol](../contracts/ImmutableLicense.sol)

**↗ Extends: [Ownable](Ownable.md), [ImmutableConstants](ImmutableConstants.md)**

**ImmutableLicense**

License elements and methods

## Structs
### LicenseOffer

```js
struct LicenseOffer {
 uint256 priceInTokens,
 uint256 duration,
 uint256 promoPriceInTokens,
 uint256 promoDuration
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
 uint256 expiration,
 uint256 priceInTokens
}
```

### LicenseReference

```js
struct LicenseReference {
 uint256 entityID,
 uint256 productID,
 uint256 hashIndex
}
```

## Contract Members
**Constants & Variables**

```js
//internal members
string internal constant HashCannotBeZero;

//private members
mapping(uint256 => struct ImmutableLicense.License) private Licenses;
mapping(uint256 => struct ImmutableLicense.LicenseReference[]) private LicenseReferences;
mapping(uint256 => mapping(uint256 => struct ImmutableLicense.LicenseOffer)) private LicenseOffers;
contract ImmutableProduct private productInterface;
contract ImmutableEntity private entityInterface;
contract ImmuteToken private tokenInterface;

```

**Events**

```js
event licenseOfferEvent(uint256  entityIndex, uint256  productIndex, string  entityName, uint256  priceInTokens, uint256  duration, uint256  promoPriceInTokens, uint256  promoDuration);
event licenseOfferResaleEvent(address  seller, uint256  sellerIndex, uint256  entityIndex, uint256  productIndex, uint256  licenseHash, uint256  priceInTokens, uint256  duration);
event licensePurchaseEvent(uint256  entityIndex, uint256  productIndex, uint256  expireTime);
```

## Functions

- [(address productAddr, address entityAddr, address tokenAddr)](#)
- [licenseOffer(uint256 productIndex, uint256 priceInTokens, uint256 duration, uint256 promoPriceInTokens, uint256 promoDuration)](#licenseoffer)
- [licenseTransferEscrow(uint256 entityIndex, uint256 productIndex, uint256 promotional)](#licensetransferescrow)
- [license_product(uint256 entityIndex, uint256 productIndex, uint256 hash, uint256 value, uint256 expiration, uint256 previousHash)](#license_product)
- [license_resellable(uint256 entityIndex, uint256 productIndex)](#license_resellable)
- [licenseCreate(uint256 productIndex, uint256 licenseHash, uint256 licenseValue, uint256 expiration)](#licensecreate)
- [licensePurchase(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 promotional)](#licensepurchase)
- [licensePurchaseInETH(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 promotional)](#licensepurchaseineth)
- [licenseMove(uint256 entityIndex, uint256 productIndex, uint256 oldLicenseHash, uint256 newLicenseHash)](#licensemove)
- [licenseOfferResale(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 priceInTokens)](#licenseofferresale)
- [licenseTransfer(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 newLicenseHash)](#licensetransfer)
- [licenseNumberOf(uint256 entityIndex)](#licensenumberof)
- [licenseDetails(uint256 entityIndex, uint256 licenseIndex)](#licensedetails)
- [licenseStatus(uint256 entityIndex, uint256 productIndex, uint256 licenseHash)](#licensestatus)
- [licenseOfferDetails(uint256 entityIndex, uint256 productIndex)](#licenseofferdetails)
- [licenseLookupHash(uint256 entityIndex, uint256 productIndex, uint256 licenseHash)](#licenselookuphash)

### 

License contract initializer/constructor.
 Executed on contract creation only.

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

Offer a software product license for sale.
 mes.sender must have a valid entity and product.

```js
function licenseOffer(uint256 productIndex, uint256 priceInTokens, uint256 duration, uint256 promoPriceInTokens, uint256 promoDuration) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| priceInTokens | uint256 | The token cost to purchase activation | 
| duration | uint256 | The minimum token cost to resell license
                        zero (0) prevents resale | 
| promoPriceInTokens | uint256 |  | 
| promoDuration | uint256 |  | 

### licenseTransferEscrow

Transfer tokens to a product offer escrow.
 Not public, called internally. msg.sender is the purchaser.

```js
function licenseTransferEscrow(uint256 entityIndex, uint256 productIndex, uint256 promotional) private nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity offering the product license | 
| productIndex | uint256 | The specific ID of the product | 
| promotional | uint256 |  | 

### license_product

Create a product license.
 Not public, called internally. msg.sender is the license owner.

```js
function license_product(uint256 entityIndex, uint256 productIndex, uint256 hash, uint256 value, uint256 expiration, uint256 previousHash) private nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The local entity index of the license | 
| productIndex | uint256 | The specific ID of the product | 
| hash | uint256 | The external license activation hash | 
| value | uint256 | The activation value | 
| expiration | uint256 | The activation expiration | 
| previousHash | uint256 | The previous identifier or 0 | 

### license_resellable

Check if a license can be resold.
 Not public, called internally.

```js
function license_resellable(uint256 entityIndex, uint256 productIndex) internal view
returns(bool)
```

**Returns**

true if licenses are resellable

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The local entity index of the license | 
| productIndex | uint256 | The specific ID of the product | 

### licenseCreate

Create manual product activation license for end user.
 mes.sender must own the entity and product.

```js
function licenseCreate(uint256 productIndex, uint256 licenseHash, uint256 licenseValue, uint256 expiration) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the activation license hash from end user | 
| licenseValue | uint256 | the value of the license (0 is unlicensed) | 
| expiration | uint256 | the date/time the license is valid for | 

### licensePurchase

Purchase a software product activation license.
 mes.sender is the purchaser.

```js
function licensePurchase(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 promotional) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity offering the product license | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the end user unique identifier to activate | 
| promotional | uint256 | whether promotional offer purchased | 

### licensePurchaseInETH

Purchase a software product activation license in ETH.
 mes.sender is the purchaser.

```js
function licensePurchaseInETH(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 promotional) external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity offering the product license | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the end user unique identifier to activate | 
| promotional | uint256 | whether promotional offer purchased | 

### licenseMove

Move a software product activation license.
 Costs 1 IuT token if sender not registered as automatic.
 mes.sender must be the activation license owner.

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

Offer a software product license for resale.
 mes.sender must own the activation license.

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

Transfer/Resell a software product activation license.
 License must be 'for sale' and msg.sender is new owner.
 Does NOT change current activation.

```js
function licenseTransfer(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 newLicenseHash) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity who owns the product | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the existing activation identifier to purchase | 
| newLicenseHash | uint256 | the new activation identifier after purchase | 

### licenseNumberOf

Return the number of license activations for an entity
 Entity and product must be valid.

```js
function licenseNumberOf(uint256 entityIndex) external view
returns(uint256)
```

**Returns**

the length of the license reference array

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity the product license is for | 

### licenseDetails

Return end user activation value and expiration for product
 Entity and product must be valid.

```js
function licenseDetails(uint256 entityIndex, uint256 licenseIndex) external view
returns(uint256, uint256, uint256)
```

**Returns**

the entity identifier of product activated

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity the product license is for | 
| licenseIndex | uint256 | The specific ID of the activation license | 

### licenseStatus

Return end user activation value and expiration for product
 Entity and product must be valid.

```js
function licenseStatus(uint256 entityIndex, uint256 productIndex, uint256 licenseHash) external view
returns(uint256, uint256, uint256)
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

Return the price of a product activation license.
 Entity and Product must exist.

```js
function licenseOfferDetails(uint256 entityIndex, uint256 productIndex) public view
returns(uint256, uint256, uint256, uint256)
```

**Returns**

the price in tokens for the activation license

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity with offer | 
| productIndex | uint256 | The product ID of the new release | 

### licenseLookupHash

Return the internal activation license hash.
 Entity and Product must exist. Private. Called internally only.

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
