# The Immutable Product - authentic product distribution (ImmutableProduct.sol)

View Source: [\contracts\ImmutableProduct.sol](..\contracts\ImmutableProduct.sol)

**↗ Extends: [Initializable](Initializable.md), [OwnableUpgradeable](OwnableUpgradeable.md)**

**ImmutableProduct**

Token transfers use the ImmuteToken only

## Structs
### Offer

```js
struct Offer {
 address tokenAddr,
 uint256 price,
 uint256 value,
 string infoURL,
 uint256 transferSurcharge,
 uint256 ricardianParent
}
```

### Product

```js
struct Product {
 string name,
 string infoURL,
 string logoURL,
 uint256 details,
 uint256 numberOfOffers,
 mapping(uint256 => struct ImmutableProduct.Offer) offers
}
```

### OfferResult

```js
struct OfferResult {
 address[] resultAddr,
 uint256[] resultPrice,
 uint256[] resultValue,
 string[] resultInfoUrl,
 uint256[] resultSurcharge,
 uint256[] resultParent
}
```

## Contract Members
**Constants & Variables**

```js
mapping(uint256 => mapping(uint256 => struct ImmutableProduct.Product)) private Products;
mapping(uint256 => uint256) private NumberOfProducts;
contract ImmutableEntity private entityInterface;
contract StringCommon private commonInterface;

```

**Events**

```js
event productEvent(uint256  entityIndex, uint256  productIndex, string  name, string  infoUrl, uint256  details);
event productOfferEvent(uint256  entityIndex, uint256  productIndex, string  productName, address  erc20token, uint256  price, uint256  value, string  infoUrl);
```

## Functions

- [initialize(address entityAddr, address commonAddr)](#initialize)
- [productCreate(string productName, string productURL, string logoURL, uint256 details)](#productcreate)
- [productOfferFeature(uint256 productIndex, address erc20token, uint256 price, uint256 feature, uint256 expiration, uint16 limited, uint16 bulk, string infoUrl, bool noResale, uint256 transferSurcharge, uint256 requireRicardian)](#productofferfeature)
- [productOfferLimitation(uint256 productIndex, address erc20token, uint256 price, uint256 limitation, uint256 expiration, uint16 limited, uint16 bulk, string infoUrl, bool noResale, uint256 transferSurcharge, uint256 requireRicardian)](#productofferlimitation)
- [productOffer(uint256 productIndex, address erc20token, uint256 price, uint256 value, string infoUrl, uint256 transferSurcharge, uint256 requireRicardian)](#productoffer)
- [productOfferEditPrice(uint256 productIndex, uint256 offerIndex, uint256 price)](#productoffereditprice)
- [productOfferPurchased(uint256 entityIndex, uint256 productIndex, uint256 offerIndex)](#productofferpurchased)
- [productEdit(uint256 productIndex, string productName, string productURL, string logoURL, uint256 details)](#productedit)
- [productNumberOf(uint256 entityIndex)](#productnumberof)
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
function productCreate(string productName, string productURL, string logoURL, uint256 details) external nonpayable
returns(uint256)
```

**Returns**

the new (unique per entity) product identifier (index)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productName | string | The name of the new product | 
| productURL | string | The primary URL of the product | 
| logoURL | string | The logo URL of the product | 
| details | uint256 | the product category, languages, etc. | 

### productOfferFeature

Offer a software product license for sale.
 mes.sender must have a valid entity and product.

```js
function productOfferFeature(uint256 productIndex, address erc20token, uint256 price, uint256 feature, uint256 expiration, uint16 limited, uint16 bulk, string infoUrl, bool noResale, uint256 transferSurcharge, uint256 requireRicardian) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| erc20token | address | Address of ERC 20 token offer | 
| price | uint256 | The token cost to purchase activation | 
| feature | uint256 | The product feature value/item (128 LSB only)               (128 MSB only) is duration, flags/resallability | 
| expiration | uint256 | activation expiration, (0) forever/unexpiring | 
| limited | uint16 | number of offers, (0) unlimited, 65535 max | 
| bulk | uint16 | number of activions per offer, > 0 to 65535 max | 
| infoUrl | string | The official URL for more information about offer | 
| noResale | bool | Flag to disable resale capabilities for purchaser | 
| transferSurcharge | uint256 | Surcharged levied upon resale of purchase | 
| requireRicardian | uint256 | parent of required Ricardian client contract | 

### productOfferLimitation

Offer a software product license for sale.
 mes.sender must have a valid entity and product.

```js
function productOfferLimitation(uint256 productIndex, address erc20token, uint256 price, uint256 limitation, uint256 expiration, uint16 limited, uint16 bulk, string infoUrl, bool noResale, uint256 transferSurcharge, uint256 requireRicardian) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| erc20token | address | Address of ERC 20 token offer | 
| price | uint256 | The token cost to purchase activation | 
| limitation | uint256 | The version and language limitations | 
| expiration | uint256 | activation expiration, (0) forever/unexpiring | 
| limited | uint16 | number of offers, (0) unlimited, 65535 max | 
| bulk | uint16 | number of activions per offer, > 0 to 65535 max | 
| infoUrl | string | The official URL for more information about offer | 
| noResale | bool | Prevent the resale of any purchased activation | 
| transferSurcharge | uint256 | Surcharged levied upon resale of purchase | 
| requireRicardian | uint256 | parent of required Ricardian client contract | 

### productOffer

Offer a software product license for sale.
 mes.sender must have a valid entity and product.

```js
function productOffer(uint256 productIndex, address erc20token, uint256 price, uint256 value, string infoUrl, uint256 transferSurcharge, uint256 requireRicardian) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 | The specific ID of the product | 
| erc20token | address | Address of ERC 20 token offer | 
| price | uint256 | The token cost to purchase activation | 
| value | uint256 | The product activation value/item (128 LSB only)               (128 MSB only) is duration, flags/resallability               Zero (0) duration is forever/unexpiring | 
| infoUrl | string | The official URL for more information about offer | 
| transferSurcharge | uint256 | ETH to creator for each transfer | 
| requireRicardian | uint256 | Ricardian leaf required for purchase | 

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
function productEdit(uint256 productIndex, string productName, string productURL, string logoURL, uint256 details) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256 |  | 
| productName | string | The name of the new product | 
| productURL | string | The primary URL of the product | 
| logoURL | string | The logo URL of the product | 
| details | uint256 | the product category, languages, etc. | 

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

### productDetails

Retrieve existing product name, info and details.
 Entity and product must exist.

```js
function productDetails(uint256 entityIndex, uint256 productIndex) external view
returns(name string, infoURL string, logoURL string, details uint256)
```

**Returns**

name , infoURL, logoURL and details are return values.\
         **name** The name of the product\
         **infoURL** The primary URL for information about the product\
         **logoURL** The URL for the product logo\
         **details** The detail flags (category, language) of product

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 
| productIndex | uint256 | The specific ID of the product | 

### productAllDetails

Retrieve details for all products of an entity.
 Empty arrays if no products are found.

```js
function productAllDetails(uint256 entityIndex) external view
returns(names string[], infoURLs string[], logoURLs string[], details uint256[], offers uint256[])
```

**Returns**

names , infoURLs, logoURLs, details and offers are returned as arrays.\
         **names** Array of names of the product\
         **infoURLs** Array of primary URL about the product\
         **logoURLs** Array of URL for the product logos\
         **details** Array of detail flags (category, etc.)\
         **offers** Array of number of Activation offers

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 |  | 

### productOfferDetails

Return the offer price of a product activation license.
 Entity, Product and Offer must exist.

```js
function productOfferDetails(uint256 entityIndex, uint256 productIndex, uint256 offerIndex) public view
returns(erc20Token address, price uint256, value uint256, offerURL string, surcharge uint256, parent uint256)
```

**Returns**

erc20Token , price, value, offerURL, surcharge and parent are return values.\
         **erc20Token** The address of ERC20 token offer (zero is ETH)\
         **price** The price (ETH or ERC20) for the activation license\
         **value** The duration, flags and value of activation\
         **offerURL** The URL to more information about the offer\
         **surcharge** The transfer surcharge of offer\
         **parent** The required ricardian contract parent (if any)

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
returns(erc20Tokens address[], prices uint256[], values uint256[], offerURLs string[], surcharges uint256[], parents uint256[])
```

**Returns**

erc20Tokens , prices, values, offerURLs, surcharges and parents are array return values.\
         **erc20Tokens** Array of addresses of ERC20 token offer (zero is ETH)\
         **prices** Array of prices for the activation license\
         **values** Array of duration, flags, and value of activation\
         **offerURLs** Array of URLs to more information on the offers\
         **surcharges** Array of transfer surcharge of offers\
         **parents** Array of ricardian contract parent (if any)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity with offer | 
| productIndex | uint256 | The product ID of the offer | 

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
* [EscrowUpgradeable](EscrowUpgradeable.md)
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
* [PullPaymentUpgradeable](PullPaymentUpgradeable.md)
* [StringCommon](StringCommon.md)
* [StringsUpgradeable](StringsUpgradeable.md)
