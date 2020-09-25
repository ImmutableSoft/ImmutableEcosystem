# ActivateToken.sol

View Source: [contracts/ActivateToken.sol](../contracts/ActivateToken.sol)

**↗ Extends: [Initializable](Initializable.md), [Ownable](Ownable.md), [PullPayment](PullPayment.md), [ERC721Enumerable](ERC721Enumerable.md), [ERC721Mintable](ERC721Mintable.md), [ERC721Burnable](ERC721Burnable.md), [ImmutableConstants](ImmutableConstants.md)**

**ActivateToken**

## Contract Members
**Constants & Variables**

```js
//private members
address payable private Bank;
uint256 private EthFee;
mapping(uint256 => uint256) private ActivateIdToTokenId;
mapping(uint256 => uint256) private TokenIdToActivateId;
mapping(uint256 => uint256) private NumberOfActivations;
mapping(uint256 => uint256) private TokenIdToOfferPrice;

//internal members
contract ImmutableEntity internal entityInterface;
contract ImmutableProduct internal productInterface;

```

## Functions

- [initializeMe(address entityContractAddr, address productContractAddr)](#initializeme)
- [activation_burn(uint256 tokenId)](#activation_burn)
- [activation_mint(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 licenseValue)](#activation_mint)
- [activateOwner(address newOwner)](#activateowner)
- [activateDonate(uint256 amount)](#activatedonate)
- [activateBankChange(address payable newBank)](#activatebankchange)
- [activateFeeChange(uint256 newFee)](#activatefeechange)
- [activateFeeValue()](#activatefeevalue)
- [activateCreate(uint256 productIndex, uint256 licenseHash, uint256 licenseValue)](#activatecreate)
- [activatePurchase(uint256 entityIndex, uint256 productIndex, uint256 offerIndex, uint256 licenseHash)](#activatepurchase)
- [activateMove(uint256 entityIndex, uint256 productIndex, uint256 oldLicenseHash, uint256 newLicenseHash)](#activatemove)
- [activateOfferResale(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 priceInEth)](#activateofferresale)
- [activateTransfer(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 newLicenseHash)](#activatetransfer)
- [activateStatus(uint256 entityIndex, uint256 productIndex, uint256 licenseHash)](#activatestatus)
- [activateAllDetailsForAddress(address entityAddress)](#activatealldetailsforaddress)
- [activateAllDetails(uint256 entityIndex)](#activatealldetails)
- [activateAllTokenDetails()](#activatealltokendetails)

### initializeMe

```js
function initializeMe(address entityContractAddr, address productContractAddr) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityContractAddr | address |  | 
| productContractAddr | address |  | 

### activation_burn

Burn a product activation license.
 Not public, called internally. msg.sender must be the token owner.

```js
function activation_burn(uint256 tokenId) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 | The tokenId to burn | 

### activation_mint

Create a product activation license.
 Not public, called internally. msg.sender is the license owner.

```js
function activation_mint(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 licenseValue) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The local entity index of the license | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | The external license activation hash | 
| licenseValue | uint256 | The activation value and flags (192 bits) | 

### activateOwner

Change owner for all activate tokens (activations)
 Not public, called internally. msg.sender is the license owner.

```js
function activateOwner(address newOwner) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newOwner | address |  | 

### activateDonate

Transfer ETH funds to ImmutableSoft bank address.
 Uses OpenZeppelin PullPayment interface.

```js
function activateDonate(uint256 amount) public payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| amount | uint256 |  | 

### activateBankChange

Change bank that contract pays ETH out too.
 Administrator only.

```js
function activateBankChange(address payable newBank) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newBank | address payable | The Ethereum address of new ecosystem bank | 

### activateFeeChange

Change license creation and move fee value
 Administrator only.

```js
function activateFeeChange(uint256 newFee) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newFee | uint256 | The new ETH fee for pay-as-you-go entities | 

### activateFeeValue

Retrieve current ETH pay-as-you-go fee

```js
function activateFeeValue() external view
returns(uint256)
```

**Returns**

The fee in ETH wei

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### activateCreate

Create manual product activation license for end user.
 mes.sender must own the entity and product.
 Costs 1 IuT token if sender not registered as automatic

```js
function activateCreate(uint256 productIndex, uint256 licenseHash, uint256 licenseValue) external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the activation license hash from end user | 
| licenseValue | uint256 | the value of the license | 

### activatePurchase

Purchase a software product activation license.
 mes.sender is the purchaser.

```js
function activatePurchase(uint256 entityIndex, uint256 productIndex, uint256 offerIndex, uint256 licenseHash) external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity offering the product license | 
| productIndex | uint256 | The specific ID of the product | 
| offerIndex | uint256 | the product activation offer to purchase | 
| licenseHash | uint256 | the end user unique identifier to activate | 

### activateMove

Move a software product activation license.
 Costs 1 IuT token if sender not registered as automatic.
 mes.sender must be the activation license owner.

```js
function activateMove(uint256 entityIndex, uint256 productIndex, uint256 oldLicenseHash, uint256 newLicenseHash) external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity who owns the product | 
| productIndex | uint256 | The specific ID of the product | 
| oldLicenseHash | uint256 | the existing activation identifier | 
| newLicenseHash | uint256 | the new activation identifier | 

### activateOfferResale

Offer a software product license for resale.
 mes.sender must own the activation license.

```js
function activateOfferResale(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 priceInEth) external nonpayable
```

**Returns**

The product license offer identifier

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity who owns the product | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the existing activation identifier | 
| priceInEth | uint256 | The ETH cost to purchase license | 

### activateTransfer

Transfer/Resell a software product activation license.
 License must be 'for sale' and msg.sender is new owner.

```js
function activateTransfer(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 newLicenseHash) external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity who owns the product | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the existing activation identifier to purchase | 
| newLicenseHash | uint256 | the new activation identifier after purchase | 

### activateStatus

Return end user activation value and expiration for product
 Entity and product must be valid.

```js
function activateStatus(uint256 entityIndex, uint256 productIndex, uint256 licenseHash) external view
returns(uint256, uint256)
```

**Returns**

the activation value (flags, expiration, value)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity the product license is for | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the external unique identifier to activate | 

### activateAllDetailsForAddress

Return all license activation details for an address

```js
function activateAllDetailsForAddress(address entityAddress) public view
returns(uint256[], uint256[], uint256[], uint256[], uint256[])
```

**Returns**

array of entity id of product

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityAddress | address | The address that owns the activations | 

### activateAllDetails

Return all license activation details for an entity
 Entity must be valid.

```js
function activateAllDetails(uint256 entityIndex) external view
returns(uint256[], uint256[], uint256[], uint256[], uint256[])
```

**Returns**

array of entity id of product activated

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity to return activations for | 

### activateAllTokenDetails

Return all license activation details of ecosystem
 May eventually exceed available size

```js
function activateAllTokenDetails() external view
returns(uint256[], uint256[], uint256[], uint256[], uint256[])
```

**Returns**

array of entity id of product activated

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Contracts

* [ActivateToken](ActivateToken.md)
* [Address](Address.md)
* [Context](Context.md)
* [Counters](Counters.md)
* [CustomToken](CustomToken.md)
* [ERC165](ERC165.md)
* [ERC20](ERC20.md)
* [ERC20Detailed](ERC20Detailed.md)
* [ERC20Mintable](ERC20Mintable.md)
* [ERC721](ERC721.md)
* [ERC721Burnable](ERC721Burnable.md)
* [ERC721Enumerable](ERC721Enumerable.md)
* [ERC721Mintable](ERC721Mintable.md)
* [Escrow](Escrow.md)
* [IERC165](IERC165.md)
* [IERC20](IERC20.md)
* [IERC721](IERC721.md)
* [IERC721Enumerable](IERC721Enumerable.md)
* [IERC721Receiver](IERC721Receiver.md)
* [ImmutableConstants](ImmutableConstants.md)
* [ImmutableEntity](ImmutableEntity.md)
* [ImmutableProduct](ImmutableProduct.md)
* [Initializable](Initializable.md)
* [Migrations](Migrations.md)
* [MinterRole](MinterRole.md)
* [Ownable](Ownable.md)
* [PullPayment](PullPayment.md)
* [ResolverBase](ResolverBase.md)
* [Roles](Roles.md)
* [SafeMath](SafeMath.md)
* [Secondary](Secondary.md)
* [StringCommon](StringCommon.md)
