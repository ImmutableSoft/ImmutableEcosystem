# The Immutable Product - authentic product distribution (ImmutableProduct.sol)

View Source: [contracts/ImmutableProduct.sol](../contracts/ImmutableProduct.sol)

**↗ Extends: [Ownable](Ownable.md), [ImmutableConstants](ImmutableConstants.md)**

**ImmutableProduct**

Token transfers use the ImmuteToken only

## Structs
### Product

```js
struct Product {
 string name,
 string infoURL,
 string logoURL,
 uint256 details,
 uint256 numberOfReleases,
 mapping(uint256 => struct ImmutableProduct.Release) releases
}
```

### Release

```js
struct Release {
 uint256 hash,
 string fileURI,
 uint256 version,
 uint256 expireTime,
 uint256 escrow
}
```

## Contract Members
**Constants & Variables**

```js
//internal members
uint256 internal constant ReferralProductBonus;

//private members
mapping(uint256 => struct ImmutableProduct.Product[]) private Products;
contract ImmutableEntity private entityInterface;
contract ImmuteToken private tokenInterface;
contract StringCommon private commonInterface;
uint256 private escrowAmount;

```

**Events**

```js
event productEvent(uint256  entityIndex, uint256  productIndex, string  name, string  url, uint256  details);
event productReleaseEvent(uint256  entityIndex, uint256  productIndex, uint256  version);
event productReleaseChallengeEvent(address indexed challenger, uint256  entityIndex, uint256  productIndex, uint256  releaseIndex, uint256  newHash);
event productReleaseChallengeAwardEvent(address indexed challenger, uint256  entityIndex, uint256  productIndex, uint256  releaseIndex, uint256  newHash);
```

## Functions

- [(address entityAddr, address tokenAddr, address commonAddr)](#)
- [productCreate(string productName, string productURL, string logoURL, uint256 productDetails)](#productcreate)
- [productRelease(uint256 productIndex, uint256 newVersion, uint256 newHash, string newFileUri, uint256 escrow)](#productrelease)
- [productReleaseChallenge(uint256 entityIndex, uint256 productIndex, uint256 releaseIndex, uint256 newHash)](#productreleasechallenge)
- [productTokensWithdraw()](#producttokenswithdraw)
- [productChallengeReward(address challengerAddress, uint256 entityIndex, uint256 productIndex, uint256 releaseIndex, uint256 newHash)](#productchallengereward)
- [productTokenEscrow()](#producttokenescrow)
- [productReleaseDetails(uint256 entityIndex, uint256 productIndex, uint256 releaseIndex)](#productreleasedetails)
- [productNumberOf(uint256 entityIndex)](#productnumberof)
- [productNumberOfReleases(uint256 entityIndex, uint256 productIndex)](#productnumberofreleases)
- [productDetails(uint256 entityIndex, uint256 productIndex)](#productdetails)

### 

Product contract initializer/constructor.
 Executed on contract creation only.

```js
function (address entityAddr, address tokenAddr, address commonAddr) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityAddr | address | the address of the ImmutableEntity contract | 
| tokenAddr | address | the address of the ImmuteToken contract | 
| commonAddr | address | the address of the StringCommon contract | 

### productCreate

Create a new product for an entity.
 Entity must exist and be validated by Immutable.

```js
function productCreate(string productName, string productURL, string logoURL, uint256 productDetails) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productName | string | The name of the new product | 
| productURL | string | The primary URL of the product | 
| logoURL | string | The logo URL of the product | 
| productDetails | uint256 | the product category, languages, etc. | 

### productRelease

Create a new release of an existing product.
 Entity and Product must exist.

```js
function productRelease(uint256 productIndex, uint256 newVersion, uint256 newHash, string newFileUri, uint256 escrow) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The product ID of the new release | 
| newVersion | uint256 | The new product version, architecture and languages | 
| newHash | uint256 | The new release binary SHA256 CRC hash | 
| newFileUri | string | The valid URI of the release binary | 
| escrow | uint256 | The amount of tokens to put into the release escrow | 

### productReleaseChallenge

Challenge an existing product product release.
 Entity, Product and Release must exist, hash must differ.

```js
function productReleaseChallenge(uint256 entityIndex, uint256 productIndex, uint256 releaseIndex, uint256 newHash) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity to challenge | 
| productIndex | uint256 | The product ID of the new release | 
| releaseIndex | uint256 | The index of the product release | 
| newHash | uint256 | The different release binary SHA256 CRC hash | 

### productTokensWithdraw

Withdraw expired product release escrows.
 Withdraws all expired product release escrows amounts.

```js
function productTokensWithdraw() external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### productChallengeReward

Administrator (onlyOwner) reward previous user challenge.
 Product release must exist with an escrow and different hash.

```js
function productChallengeReward(address challengerAddress, uint256 entityIndex, uint256 productIndex, uint256 releaseIndex, uint256 newHash) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| challengerAddress | address | Ethereum address of challenge sender | 
| entityIndex | uint256 | Index of entity responsible for product | 
| productIndex | uint256 | The index of the entity product | 
| releaseIndex | uint256 | The index of the specific product release | 
| newHash | uint256 | The new SHA256 checksum hash of the release URI | 

### productTokenEscrow

Check balance of escrowed product releases.
 Counts all expired/available product release escrows amounts.

```js
function productTokenEscrow() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### productReleaseDetails

Return version, URI and hash of existing product release.
 Entity, Product and Release must exist.

```js
function productReleaseDetails(uint256 entityIndex, uint256 productIndex, uint256 releaseIndex) external view
returns(uint256, string, uint256)
```

**Returns**

the version, architecture and language(s)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity to challenge | 
| productIndex | uint256 | The product ID of the new release | 
| releaseIndex | uint256 | The index of the product release | 

### productNumberOf

Return the number of products maintained by an entity.
 Entity must exist.

```js
function productNumberOf(uint256 entityIndex) external view
returns(uint256)
```

**Returns**

the current number of products for the entity

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 

### productNumberOfReleases

Return the number of product releases of a product.
 Entity and product must exist.

```js
function productNumberOfReleases(uint256 entityIndex, uint256 productIndex) external view
returns(uint256)
```

**Returns**

the current number of releases for the product

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The glabal entity index | 
| productIndex | uint256 | The index of the product | 

### productDetails

Retrieve existing product name, info and details.
 Entity and product must exist.

```js
function productDetails(uint256 entityIndex, uint256 productIndex) external view
returns(string, string, string, uint256)
```

**Returns**

the name of the product

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 
| productIndex | uint256 | The specific ID of the product | 

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
