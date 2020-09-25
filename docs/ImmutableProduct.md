# The Immutable Product - authentic product distribution (ImmutableProduct.sol)

View Source: [contracts/ImmutableProduct.sol](../contracts/ImmutableProduct.sol)

**↗ Extends: [Initializable](Initializable.md), [Ownable](Ownable.md), [ImmutableConstants](ImmutableConstants.md)**

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
 uint256 numberOfOffers,
 mapping(uint256 => struct ImmutableProduct.Release) releases,
 mapping(uint256 => struct ImmutableProduct.Offer) offers
}
```

### Offer

```js
struct Offer {
 address tokenAddr,
 uint256 price,
 uint256 value,
 string infoURL
}
```

### Release

```js
struct Release {
 uint256 hash,
 string fileURI,
 uint256 version
}
```

## Contract Members
**Constants & Variables**

```js
mapping(uint256 => mapping(uint256 => struct ImmutableProduct.Product)) private Products;
mapping(uint256 => uint256) private NumberOfProducts;
mapping(uint256 => uint256) private HashToRelease;
contract ImmutableEntity private entityInterface;
contract StringCommon private commonInterface;

```

**Events**

```js
event productEvent(uint256  entityIndex, uint256  productIndex, string  name, string  infoUrl, uint256  details);
event productReleaseEvent(uint256  entityIndex, uint256  productIndex, uint256  version);
event productOfferEvent(uint256  entityIndex, uint256  productIndex, string  productName, address  erc20token, uint256  price, uint256  value, string  infoUrl);
```

## Functions

- [initialize(address entityAddr, address commonAddr)](#initialize)
- [productCreate(string productName, string productURL, string logoURL, uint256 productDetails)](#productcreate)
- [productOfferFeature(uint256 productIndex, address erc20token, uint256 price, uint256 feature, uint256 expiration, uint256 number, string infoUrl, bool noResale)](#productofferfeature)
- [productOfferLimitation(uint256 productIndex, address erc20token, uint256 price, uint256 limitation, uint256 expiration, uint256 number, string infoUrl, bool noResale)](#productofferlimitation)
- [productOffer(uint256 productIndex, address erc20token, uint256 price, uint256 value, string infoUrl)](#productoffer)
- [productOfferEditPrice(uint256 productIndex, uint256 offerIndex, uint256 price)](#productoffereditprice)
- [productOfferPurchased(uint256 entityIndex, uint256 productIndex, uint256 offerIndex)](#productofferpurchased)
- [productEdit(uint256 productIndex, string productName, string productURL, string logoURL, uint256 productDetails)](#productedit)
- [productRelease(uint256 productIndex, uint256 newVersion, uint256 newHash, string newFileUri)](#productrelease)
- [productReleaseDetails(uint256 entityIndex, uint256 productIndex, uint256 releaseIndex)](#productreleasedetails)
- [productReleaseHashDetails(uint256 fileHash)](#productreleasehashdetails)
- [productAllReleaseDetails(uint256 entityIndex, uint256 productIndex)](#productallreleasedetails)
- [productNumberOf(uint256 entityIndex)](#productnumberof)
- [productNumberOfReleases(uint256 entityIndex, uint256 productIndex)](#productnumberofreleases)
- [productDetails(uint256 entityIndex, uint256 productIndex)](#productdetails)
- [productAllDetails(uint256 entityIndex)](#productalldetails)
- [productOfferDetails(uint256 entityIndex, uint256 productIndex, uint256 offerIndex)](#productofferdetails)
- [productAllOfferDetails(uint256 entityIndex, uint256 productIndex)](#productallofferdetails)

### initialize

Product contract initializer/constructor.
 Executed on contract creation only.

```js
function initialize(address entityAddr, address commonAddr) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityAddr | address | the address of the ImmutableEntity contract | 
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

### productOfferFeature

Offer a software product license for sale.
 mes.sender must have a valid entity and product.

```js
function productOfferFeature(uint256 productIndex, address erc20token, uint256 price, uint256 feature, uint256 expiration, uint256 number, string infoUrl, bool noResale) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| erc20token | address | Address of ERC 20 token offer | 
| price | uint256 | The token cost to purchase activation | 
| feature | uint256 | The product feature value/item (128 LSB only)
              (128 MSB only) is duration, flags/resallability | 
| expiration | uint256 | activation expiration, (0) forever/unexpiring | 
| number | uint256 | of offers, (0) is unlimited 65535 is maximum | 
| infoUrl | string | The official URL for more information about offer | 
| noResale | bool | Flag to disable resale capabilities for purchaser | 

### productOfferLimitation

Offer a software product license for sale.
 mes.sender must have a valid entity and product.

```js
function productOfferLimitation(uint256 productIndex, address erc20token, uint256 price, uint256 limitation, uint256 expiration, uint256 number, string infoUrl, bool noResale) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| erc20token | address | Address of ERC 20 token offer | 
| price | uint256 | The token cost to purchase activation | 
| limitation | uint256 | The version and language limitations | 
| expiration | uint256 | activation expiration, (0) forever/unexpiring | 
| number | uint256 | of offers, (0) is unlimited 65535 is maximum | 
| infoUrl | string | The official URL for more information about offer | 
| noResale | bool | Prevent the resale of any purchased activation | 

### productOffer

Offer a software product license for sale.
 mes.sender must have a valid entity and product.

```js
function productOffer(uint256 productIndex, address erc20token, uint256 price, uint256 value, string infoUrl) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| erc20token | address | Address of ERC 20 token offer | 
| price | uint256 | The token cost to purchase activation | 
| value | uint256 | The product activation value/item (128 LSB only)
              (128 MSB only) is duration, flags/resallability
              Zero (0) duration is forever/unexpiring | 
| infoUrl | string | The official URL for more information about offer | 

### productOfferEditPrice

Change a software product license offer price
 mes.sender must have a valid entity and product

```js
function productOfferEditPrice(uint256 productIndex, uint256 offerIndex, uint256 price) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| offerIndex | uint256 | the index of the offer to change | 
| price | uint256 | The token cost to purchase activation | 

### productOfferPurchased

Count a purchase of a product activation license.
 Entity, Product and Offer must exist.

```js
function productOfferPurchased(uint256 entityIndex, uint256 productIndex, uint256 offerIndex) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity with offer | 
| productIndex | uint256 | The product ID of the offer | 
| offerIndex | uint256 | The per-product offer ID | 

### productEdit

Edit an existing product of an entity.
 Entity must exist and be validated by Immutable.

```js
function productEdit(uint256 productIndex, string productName, string productURL, string logoURL, uint256 productDetails) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 |  | 
| productName | string | The name of the new product | 
| productURL | string | The primary URL of the product | 
| logoURL | string | The logo URL of the product | 
| productDetails | uint256 | the product category, languages, etc. | 

### productRelease

Create a new release of an existing product.
 Entity and Product must exist.

```js
function productRelease(uint256 productIndex, uint256 newVersion, uint256 newHash, string newFileUri) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The product ID of the new release | 
| newVersion | uint256 | The new product version, architecture and languages | 
| newHash | uint256 | The new release binary SHA256 CRC hash | 
| newFileUri | string | The valid URI of the release binary | 

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
| entityIndex | uint256 | The index of the entity owner of product | 
| productIndex | uint256 | The product ID of the new release | 
| releaseIndex | uint256 | The index of the product release | 

### productReleaseHashDetails

Reverse lookup, return entity, product, URI of product release.
 Entity, Product and Release must exist.

```js
function productReleaseHashDetails(uint256 fileHash) external view
returns(uint256, uint256, uint256, uint256, string)
```

**Returns**

The index of the entity owner of product

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| fileHash | uint256 | The index of the product release | 

### productAllReleaseDetails

Retrieve details for all product releases
 Status of empty arrays if none found.

```js
function productAllReleaseDetails(uint256 entityIndex, uint256 productIndex) external view
returns(uint256[], string[], uint256[])
```

**Returns**

array of version, architecture and language(s)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity owner of product | 
| productIndex | uint256 | The product ID of the new release | 

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

### productAllDetails

Retrieve details for all products
 Status of empty arrays if none found.

```js
function productAllDetails(uint256 entityIndex) external view
returns(string[], string[], string[], uint256[], uint256[], uint256[])
```

**Returns**

array of name, infoURL, logoURL, status details
                  number of releases, price in tokens

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 |  | 

### productOfferDetails

Return the price of a product activation license.
 Entity and Product must exist.

```js
function productOfferDetails(uint256 entityIndex, uint256 productIndex, uint256 offerIndex) public view
returns(address, uint256, uint256, string)
```

**Returns**

address of ERC20 token of offer (zero address is ETH)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity with offer | 
| productIndex | uint256 | The product ID of the offer | 
| offerIndex | uint256 | The per-product offer ID | 

### productAllOfferDetails

Return all the product activation offers
 Entity and Product must exist.

```js
function productAllOfferDetails(uint256 entityIndex, uint256 productIndex) public view
returns(address[], uint256[], uint256[], string[])
```

**Returns**

address of ERC20 token of offer (zero address is ETH)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity with offer | 
| productIndex | uint256 | The product ID of the offer | 

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
