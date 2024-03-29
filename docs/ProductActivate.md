# ProductActivate.sol

View Source: [\contracts\ProductActivate.sol](..\contracts\ProductActivate.sol)

**↗ Extends: [Initializable](Initializable.md), [OwnableUpgradeable](OwnableUpgradeable.md)**

**ProductActivate**

## Structs
### ActivationOffer

```js
struct ActivationOffer {
 uint256 priceInTokens,
 uint256 value,
 address erc20token,
 string infoUrl,
 uint256 transferSurcharge,
 uint256 ricardianParent
}
```

## Contract Members
**Constants & Variables**

```js
mapping(uint256 => uint256) private TokenIdToOfferPrice;
mapping(uint256 => uint256) private TransferSurcharge;
contract ActivateToken private activateTokenInterface;
contract CreatorToken private creatorTokenInterface;
contract ImmutableEntity private entityInterface;
contract ImmutableProduct private productInterface;
contract StringCommon private commonInterface;

```

## Functions

- [initialize(address commonAddr, address entityContractAddr, address productContractAddr, address activateTokenAddr, address creatorTokenAddr)](#initialize)
- [activateCreate(uint256 productIndex, uint256 licenseHash, uint256 licenseValue, uint256 transferSurcharge, uint256 ricardianParent)](#activatecreate)
- [activatePurchase(uint256 entityIndex, uint256 productIndex, uint256 offerIndex, uint16 numPurchases, uint256[] licenseHashes, uint256[] ricardianClients)](#activatepurchase)
- [activateMove(uint256 entityIndex, uint256 productIndex, uint256 oldLicenseHash, uint256 newLicenseHash)](#activatemove)
- [activateOfferResale(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 priceInEth)](#activateofferresale)
- [activateTransfer(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 newLicenseHash)](#activatetransfer)
- [activateTokenIdToOfferPrice(uint256 tokenId)](#activatetokenidtoofferprice)

### initialize

Initialize the ProductActivate smart contract
   Called during first deployment only (not on upgrade) as
   this is an OpenZepellin upgradable contract

```js
function initialize(address commonAddr, address entityContractAddr, address productContractAddr, address activateTokenAddr, address creatorTokenAddr) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| commonAddr | address | The StringCommon contract address | 
| entityContractAddr | address | The ImmutableEntity token contract address | 
| productContractAddr | address | The ImmutableProduct token contract address | 
| activateTokenAddr | address | The ActivateToken token contract address | 
| creatorTokenAddr | address | The CreatorToken token contract address | 

### activateCreate

Create manual product activation license for end user.
 mes.sender must own the entity and product.
 Costs 1 IuT token if sender not registered as automatic

```js
function activateCreate(uint256 productIndex, uint256 licenseHash, uint256 licenseValue, uint256 transferSurcharge, uint256 ricardianParent) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the activation license hash from end user | 
| licenseValue | uint256 | the value of the license | 
| transferSurcharge | uint256 | the additional cost/surcharge to transfer | 
| ricardianParent | uint256 | The Ricardian contract parent (if any) | 

### activatePurchase

Purchase a digital product activation license.
 mes.sender is the purchaser.

```js
function activatePurchase(uint256 entityIndex, uint256 productIndex, uint256 offerIndex, uint16 numPurchases, uint256[] licenseHashes, uint256[] ricardianClients) external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity offering the product license | 
| productIndex | uint256 | The specific ID of the product | 
| offerIndex | uint256 | the product activation offer to purchase | 
| numPurchases | uint16 | the number of offers to purchase | 
| licenseHashes | uint256[] | Array of end user identifiers to activate | 
| ricardianClients | uint256[] | Array of end client agreement contracts | 

### activateMove

Move a digital product activation license.
 mes.sender must be the activation license owner.

```js
function activateMove(uint256 entityIndex, uint256 productIndex, uint256 oldLicenseHash, uint256 newLicenseHash) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity who owns the product | 
| productIndex | uint256 | The specific ID of the product | 
| oldLicenseHash | uint256 | the existing activation identifier | 
| newLicenseHash | uint256 | the new activation identifier | 

### activateOfferResale

Offer a digital product license for resale.
 mes.sender must own the activation license.

```js
function activateOfferResale(uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 priceInEth) external nonpayable
returns(uint256)
```

**Returns**

the tokenId of the activation offered for resale

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity who owns the product | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the existing activation identifier | 
| priceInEth | uint256 | The ETH cost to purchase license | 

### activateTransfer

Transfer/Resell a digital product activation license.
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

### activateTokenIdToOfferPrice

Query activate token offer price

```js
function activateTokenIdToOfferPrice(uint256 tokenId) external view
returns(uint256)
```

**Returns**

The price of the token if for sale

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 | The activate token identifier | 

## Contracts

* [ActivateToken](ActivateToken.md)
* [AddressUpgradeable](AddressUpgradeable.md)
* [ContextUpgradeable](ContextUpgradeable.md)
* [CreatorToken](CreatorToken.md)
* [CustomToken](CustomToken.md)
* [ERC165Upgradeable](ERC165Upgradeable.md)
* [ERC20Upgradeable](ERC20Upgradeable.md)
* [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md)
* [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md)
* [ERC721Upgradeable](ERC721Upgradeable.md)
* [ERC721URIStorageUpgradeable](ERC721URIStorageUpgradeable.md)
* [IERC165Upgradeable](IERC165Upgradeable.md)
* [IERC20MetadataUpgradeable](IERC20MetadataUpgradeable.md)
* [IERC20Upgradeable](IERC20Upgradeable.md)
* [IERC721EnumerableUpgradeable](IERC721EnumerableUpgradeable.md)
* [IERC721MetadataUpgradeable](IERC721MetadataUpgradeable.md)
* [IERC721ReceiverUpgradeable](IERC721ReceiverUpgradeable.md)
* [IERC721Upgradeable](IERC721Upgradeable.md)
* [ImmutableEntity](ImmutableEntity.md)
* [ImmutableProduct](ImmutableProduct.md)
* [Initializable](Initializable.md)
* [Migrations](Migrations.md)
* [OwnableUpgradeable](OwnableUpgradeable.md)
* [ProductActivate](ProductActivate.md)
* [StringCommon](StringCommon.md)
* [StringsUpgradeable](StringsUpgradeable.md)
