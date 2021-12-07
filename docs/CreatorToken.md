# The Immutable Product - authentic product distribution (CreatorToken.sol)

View Source: [\contracts\CreatorToken.sol](..\contracts\CreatorToken.sol)

**↗ Extends: [Initializable](Initializable.md), [OwnableUpgradeable](OwnableUpgradeable.md), [PullPaymentUpgradeable](PullPaymentUpgradeable.md), [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md), [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md), [ERC721URIStorageUpgradeable](ERC721URIStorageUpgradeable.md)**

**CreatorToken**

Token transfers use the ImmuteToken only

## Structs
### Release

```js
struct Release {
 uint256 hash,
 string fileURI,
 uint256 version,
 uint256 parent
}
```

### ReleaseInformation

```js
struct ReleaseInformation {
 uint256 index,
 uint256 product,
 uint256 release,
 uint256 version,
 string fileURI,
 uint256 parent
}
```

## Contract Members
**Constants & Variables**

```js
//internal members
mapping(uint256 => struct CreatorToken.Release) internal Releases;

//private members
mapping(uint256 => uint256) private HashToRelease;
mapping(uint256 => mapping(uint256 => uint256)) private ReleasesNumberOf;
contract StringCommon private commonInterface;
contract ImmutableEntity private entityInterface;
contract ImmutableProduct private productInterface;

```

**Events**

```js
event creatorReleaseEvent(uint256  entityIndex, uint256  productIndex, uint256  version);
```

## Functions

- [initialize(address commonAddr, address entityAddr, address productAddr)](#initialize)
- [creatorReleases(uint256[] productIndex, uint256[] newVersion, uint256[] newHash, string[] newFileUri, uint256[] parentHash)](#creatorreleases)
- [creatorReleaseDetails(uint256 entityIndex, uint256 productIndex, uint256 releaseIndex)](#creatorreleasedetails)
- [creatorReleaseHashDetails(uint256 fileHash)](#creatorreleasehashdetails)
- [creatorParentOf(uint256 childHash, uint256 parentHash)](#creatorparentof)
- [creatorHasChildOf(address clientAddress, uint256 parentHash)](#creatorhaschildof)
- [creatorAllReleaseDetails(uint256 entityIndex, uint256 productIndex)](#creatorallreleasedetails)
- [creatorReleasesNumberOf(uint256 entityIndex, uint256 productIndex)](#creatorreleasesnumberof)
- [_beforeTokenTransfer(address from, address to, uint256 tokenId)](#_beforetokentransfer)
- [tokenURI(uint256 tokenId)](#tokenuri)
- [_burn(uint256 tokenId)](#_burn)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)

### initialize

Product contract initializer/constructor.
 Executed on contract creation only.

```js
function initialize(address commonAddr, address entityAddr, address productAddr) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| commonAddr | address |  | 
| entityAddr | address |  | 
| productAddr | address |  | 

### creatorReleases

Create new release(s) of an existing product.
 Entity and Product must exist.

```js
function creatorReleases(uint256[] productIndex, uint256[] newVersion, uint256[] newHash, string[] newFileUri, uint256[] parentHash) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| productIndex | uint256[] | Array of product IDs of new release(s) | 
| newVersion | uint256[] | Array of version, architecture and languages | 
| newHash | uint256[] | Array of file SHA256 CRC hash | 
| newFileUri | string[] | Array of valid URIs of the release binary | 
| parentHash | uint256[] | Array of SHA256 CRC hash of parent contract | 

### creatorReleaseDetails

Return version, URI and hash of existing product release.
 Entity, Product and Release must exist.

```js
function creatorReleaseDetails(uint256 entityIndex, uint256 productIndex, uint256 releaseIndex) external view
returns(flags uint256, URI string, fileHash uint256, parentHash uint256)
```

**Returns**

flags , URI, fileHash and parentHash are return values.\
         **flags** The version, architecture and language(s)\
         **URI** The URI to the product release file\
         **fileHash** The SHA256 checksum hash of the file\
         **parentHash** The SHA256 checksum hash of the parent file

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity owner of product | 
| productIndex | uint256 | The product ID of the new release | 
| releaseIndex | uint256 | The index of the product release | 

### creatorReleaseHashDetails

Reverse lookup, return entity, product, URI of product release.
 Entity, Product and Release must exist.

```js
function creatorReleaseHashDetails(uint256 fileHash) public view
returns(entity uint256, product uint256, release uint256, version uint256, URI string, parent uint256)
```

**Returns**

entity , product, release, version, URI and parent are return values.\
         **entity** The index of the entity owner of product\
         **product** The product ID of the release\
         **release** The release ID of the release\
         **version** The version, architecture and language(s)\
         **URI** The URI to the product release file
         **parent** The SHA256 checksum of ricarding parent file

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| fileHash | uint256 | The index of the product release | 

### creatorParentOf

Return depth of ricardian parent relative to child
   The childHash and parentHash must exist as same product

```js
function creatorParentOf(uint256 childHash, uint256 parentHash) public view
returns(uint256)
```

**Returns**

the child document depth compared to parent (> 0 is parent)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| childHash | uint256 | SHA256 checksum hash of the child file | 
| parentHash | uint256 | SHA256 checksum hash of the parent file | 

### creatorHasChildOf

Determine if an address owns a client token of parent
   The clientAddress and parentHash must be valid

```js
function creatorHasChildOf(address clientAddress, uint256 parentHash) public view
returns(uint256)
```

**Returns**

The child Ricardian depth to parent (> 0 has child)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| clientAddress | address | Ethereum address of client | 
| parentHash | uint256 | SHA256 checksum hash of the parent file | 

### creatorAllReleaseDetails

Retrieve details for all product releases
 Status of empty arrays if none found.

```js
function creatorAllReleaseDetails(uint256 entityIndex, uint256 productIndex) external view
returns(versions uint256[], URIs string[], hashes uint256[], parents uint256[])
```

**Returns**

versions , URIs, hashes, parents are array return values.\
         **versions** Array of version, architecture and language(s)\
         **URIs** Array of URI to the product release files\
         **hashes** Array of SHA256 checksum hash of the files\
         **parents** Aarray of SHA256 checksum hash of the parent files

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity owner of product | 
| productIndex | uint256 | The product ID of the new release | 

### creatorReleasesNumberOf

Return the number of releases of a product
 Entity must exist.

```js
function creatorReleasesNumberOf(uint256 entityIndex, uint256 productIndex) external view
returns(uint256)
```

**Returns**

the current number of products for the entity

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 
| productIndex | uint256 |  | 

### _beforeTokenTransfer

```js
function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 

### tokenURI

Look up the release URI from the token Id

```js
function tokenURI(uint256 tokenId) public view
returns(string)
```

**Returns**

the file name and/or URI secured by this token

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 | The unique token identifier | 

### _burn

Burn a product activation license.
 Not public, called internally. msg.sender must be the token owner.

```js
function _burn(uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 | The tokenId to burn | 

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
