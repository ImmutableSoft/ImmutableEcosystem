# ActivateToken.sol

View Source: [\contracts\ActivateToken.sol](..\contracts\ActivateToken.sol)

**↗ Extends: [Initializable](Initializable.md), [OwnableUpgradeable](OwnableUpgradeable.md), [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md), [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md)**

**ActivateToken**

## Contract Members
**Constants & Variables**

```js
//private members
mapping(uint256 => uint256) private ActivateIdToTokenId;
mapping(uint256 => uint256) private TokenIdToActivateId;
mapping(uint64 => uint64) private NumberOfActivations;
mapping(uint256 => uint256) private TokenIdToRicardianParent;

//internal members
contract ProductActivate internal activateInterface;
contract CreatorToken internal creatorInterface;
contract ImmutableEntity internal entityInterface;
contract StringCommon internal commonInterface;

```

## Functions

- [initialize(address commonContractAddr, address entityContractAddr)](#initialize)
- [restrictToken(address activateAddress, address creatorAddress)](#restricttoken)
- [burn(uint256 tokenId)](#burn)
- [mint(address sender, uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 licenseValue, uint256 ricardianParent)](#mint)
- [activateOwner(address newOwner)](#activateowner)
- [activateTokenMoveHash(uint256 tokenId, uint256 newHash, uint256 oldHash)](#activatetokenmovehash)
- [activateIdToTokenId(uint256 licenseHash)](#activateidtotokenid)
- [tokenIdToActivateId(uint256 tokenId)](#tokenidtoactivateid)
- [activateStatus(uint256 entityIndex, uint256 productIndex, uint256 licenseHash)](#activatestatus)
- [activateAllDetailsForAddress(address entityAddress)](#activatealldetailsforaddress)
- [activateAllDetails(uint256 entityIndex)](#activatealldetails)
- [activateAllForSaleTokenDetails()](#activateallforsaletokendetails)
- [_beforeTokenTransfer(address from, address to, uint256 tokenId)](#_beforetokentransfer)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)

### initialize

```js
function initialize(address commonContractAddr, address entityContractAddr) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| commonContractAddr | address |  | 
| entityContractAddr | address |  | 

### restrictToken

Restrict the token to the activate contract
   Called internally. msg.sender must contract owner

```js
function restrictToken(address activateAddress, address creatorAddress) public nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| activateAddress | address | The ProductActivate contract address | 
| creatorAddress | address | The Creator token contract address | 

### burn

Burn a product activation license.
 Not public, called internally. msg.sender must be the token owner.

```js
function burn(uint256 tokenId) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 | The tokenId to burn | 

### mint

Create a product activation license.
 Not public, called internally. msg.sender is the license owner.

```js
function mint(address sender, uint256 entityIndex, uint256 productIndex, uint256 licenseHash, uint256 licenseValue, uint256 ricardianParent) public nonpayable
returns(uint256)
```

**Returns**

tokenId The resulting new unique token identifier

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| sender | address |  | 
| entityIndex | uint256 | The local entity index of the license | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | The external license activation hash | 
| licenseValue | uint256 | The activation value and flags (192 bits) | 
| ricardianParent | uint256 | The Ricardian contract parent (if required) | 

### activateOwner

Change owner for all activate tokens (activations)
 Not public, called internally. msg.sender is the license owner.

```js
function activateOwner(address newOwner) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newOwner | address | The new owner to receive transfer of tokens | 

### activateTokenMoveHash

Change activation identifier for an activate token
   Caller must be the ProductActivate contract.

```js
function activateTokenMoveHash(uint256 tokenId, uint256 newHash, uint256 oldHash) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 | The token identifier to move | 
| newHash | uint256 | The new activation hash/identifier | 
| oldHash | uint256 | The previous activation hash/identifier | 

### activateIdToTokenId

Find token identifier associated with activation hash

```js
function activateIdToTokenId(uint256 licenseHash) external view
returns(uint256)
```

**Returns**

the tokenId value

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| licenseHash | uint256 | the external unique identifier | 

### tokenIdToActivateId

Find activation hash associated with token identifier

```js
function tokenIdToActivateId(uint256 tokenId) external view
returns(uint256)
```

**Returns**

the license hash/unique activation identifier

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 | is the unique token identifier | 

### activateStatus

Find end user activation value and expiration for product
 Entity and product must be valid.

```js
function activateStatus(uint256 entityIndex, uint256 productIndex, uint256 licenseHash) external view
returns(value uint256, price uint256)
```

**Returns**

value (with flags) and price of the activation.\
         **value** The activation value (flags, expiration, value)\
         **price** The price in tokens if offered for resale

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity the product license is for | 
| productIndex | uint256 | The specific ID of the product | 
| licenseHash | uint256 | the external unique identifier to activate | 

### activateAllDetailsForAddress

Find all license activation details for an address

```js
function activateAllDetailsForAddress(address entityAddress) public view
returns(entities uint256[], products uint256[], hashes uint256[], values uint256[], prices uint256[])
```

**Returns**

entities , products, hashes, values and prices as arrays.\
         **entities** Array of entity ids of product\
         **products** Array of product ids of product\
         **hashes** Array of activation identifiers\
         **values** Array of token values\
         **prices** Array of price in tokens if for resale

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityAddress | address | The address that owns the activations | 

### activateAllDetails

Find all license activation details for an entity
 Entity must be valid.

```js
function activateAllDetails(uint256 entityIndex) external view
returns(entities uint256[], products uint256[], hashes uint256[], values uint256[], prices uint256[])
```

**Returns**

entities , products, hashes, values and prices as arrays.\
         **entities** Array of entity ids of product\
         **products** Array of product ids of product\
         **hashes** Array of activation identifiers\
         **values** Array of token values (flags, expiration)\
         **prices** Array of price in tokens if for resale

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity to return activations for | 

### activateAllForSaleTokenDetails

Return all license activations for sale in the ecosystem
 When this exceeds available return size index will be added

```js
function activateAllForSaleTokenDetails() external view
returns(entities uint256[], products uint256[], hashes uint256[], values uint256[], prices uint256[])
```

**Returns**

entities , products, hashes, values and prices as arrays.\
         **entities** Array of entity ids of product\
         **products** Array of product ids of product\
         **hashes** Array of activation identifiers\
         **values** Array of token values (flags, expiration)\
         **prices** Array of price in tokens if for resale

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### _beforeTokenTransfer

Perform validity check before transfer of token allowed

```js
function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address | The token origin address | 
| to | address | The token destination address | 
| tokenId | uint256 | The token to transfer | 

### supportsInterface

Return the type of supported ERC interfaces

```js
function supportsInterface(bytes4 interfaceId) public view
returns(bool)
```

**Returns**

TRUE (1) if supported, FALSE (0) otherwise

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| interfaceId | bytes4 | The interface desired | 

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
