# Immutable Entity trust zone used by ecosystem members (ImmutableEntity.sol)

View Source: [contracts/ImmutableEntity.sol](../contracts/ImmutableEntity.sol)

**↗ Extends: [Initializable](Initializable.md), [OwnableUpgradeable](OwnableUpgradeable.md)**

**ImmutableEntity**

Member entities can accept ETH escrow payments and change
         or configure a recovery wallet address. Only after new
         members create their Entity (with a blockchain transaction)
         is ownership of the wallet address proven to ImmutableSoft
         which then allows us to approve the new member.

## Structs
### Entity

```js
struct Entity {
 address payable bank,
 address prevAddress,
 address nextAddress,
 string name,
 string infoURL,
 uint256 createTime
}
```

## Contract Members
**Constants & Variables**

```js
//private members
address payable private Bank;
mapping(address => uint256) private EntityIndex;
mapping(uint256 => uint256) private EntityStatus;
mapping(uint256 => address) private EntityArray;
mapping(uint256 => struct ImmutableEntity.Entity) private Entities;
contract StringCommon private commonInterface;

//internal members
uint256 internal UpgradeFee;
uint256 internal NumberOfEntities;

```

**Events**

```js
event entityEvent(uint256  entityIndex, string  name, string  url);
```

## Functions

- [initialize(address commonAddr)](#initialize)
- [entityOwnerBank(address payable newBank)](#entityownerbank)
- [entityOwnerUpgradeFee(uint256 newFee)](#entityownerupgradefee)
- [entityStatusUpdate(uint256 entityIndex, uint256 status)](#entitystatusupdate)
- [entityCreate(string entityName, string entityURL)](#entitycreate)
- [entityUpdate(string entityName, string entityURL)](#entityupdate)
- [entityBankChange(address payable newBank)](#entitybankchange)
- [entityAddressNext(address nextAddress)](#entityaddressnext)
- [entityAdminAddressNext(address entityAddress, address nextAddress)](#entityadminaddressnext)
- [entityAddressMove(address oldAddress)](#entityaddressmove)
- [entityUpgrade()](#entityupgrade)
- [entityPay(uint256 entityIndex)](#entitypay)
- [entityIndexStatus(uint256 entityIndex)](#entityindexstatus)
- [entityAddressStatus(address entityAddress)](#entityaddressstatus)
- [entityAddressToIndex(address entityAddress)](#entityaddresstoindex)
- [entityIndexToAddress(uint256 entityIndex)](#entityindextoaddress)
- [entityDetailsByIndex(uint256 entityIndex)](#entitydetailsbyindex)
- [entityNumberOf()](#entitynumberof)
- [entityUpgradeFee()](#entityupgradefee)
- [entityBank(uint256 entityIndex)](#entitybank)
- [entityAllDetails()](#entityalldetails)

### initialize

Initialize the ImmutableEntity smart contract
   Called during first deployment only (not on upgrade) as
   this is an OpenZepellin upgradable contract

```js
function initialize(address commonAddr) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| commonAddr | address | The StringCommon contract address | 

### entityOwnerBank

Change bank that contract pays ETH out too.
 Administrator only.

```js
function entityOwnerBank(address payable newBank) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newBank | address payable | The Ethereum address of new ecosystem bank | 

### entityOwnerUpgradeFee

Retrieve fee to upgrade.
 Administrator only.

```js
function entityOwnerUpgradeFee(uint256 newFee) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newFee | uint256 | the new upgrade fee | 

### entityStatusUpdate

Update an entity status, non-zero value is approval.
 See ImmutableConstants.sol for status values and flags.
 Administrator (onlyOwner)

```js
function entityStatusUpdate(uint256 entityIndex, uint256 status) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | index of entity to change status | 
| status | uint256 | The new complete status aggregate value | 

### entityCreate

Create an organization.
 Entities require approval (entityStatusUpdate) after create.

```js
function entityCreate(string entityName, string entityURL) public nonpayable
returns(uint256)
```

**Returns**

the new entity unique identifier (index)

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityName | string | The legal name of the entity | 
| entityURL | string | The valid URL of the entity | 

### entityUpdate

Update an organization.
 Entities require reapproval (entityStatusUpdate) after update.

```js
function entityUpdate(string entityName, string entityURL) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityName | string | The legal name of the entity | 
| entityURL | string | The valid URL of the entity | 

### entityBankChange

Change bank address that contract pays out to.
 msg.sender must be a registered entity.

```js
function entityBankChange(address payable newBank) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newBank | address payable | payable Ethereum address owned by entity | 

### entityAddressNext

Propose to move an entity (change addresses).
 To complete move, call entityMoveAddress with new address.
 msg.sender must be a registered entity.

```js
function entityAddressNext(address nextAddress) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| nextAddress | address | The next address of the entity | 

### entityAdminAddressNext

Admin override for moving an entity (change addresses).
 To complete move call entityMoveAddress with new address.
 msg.sender must be Administrator (owner).

```js
function entityAdminAddressNext(address entityAddress, address nextAddress) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityAddress | address | The address of the entity to move | 
| nextAddress | address | The next address of the entity | 

### entityAddressMove

Finish moving an entity (change addresses).
 First call entityNextAddress with previous address.
 msg.sender must be new entity address set with entityNextAddress.

```js
function entityAddressMove(address oldAddress) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| oldAddress | address | The previous address of the entity | 

### entityUpgrade

Pay (transfer ETH to ImmutableSoft) for an upgrade.
 msg.sender must be registered Entity in good standing.
 Payable, requires ETH transfer. Current status of Manual upgrades
 to Automatic, Automatic upgrades to Custom. Upgrading Custom only
 extends your membership.

```js
function entityUpgrade() public payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### entityPay

Pay (transfer ETH to) an entity.
 Entity must exist and have bank configured.
 Payable, requires ETH transfer.
 msg.sender is the payee (could be ProductActivate contract)

```js
function entityPay(uint256 entityIndex) public payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of entity recipient bank | 

### entityIndexStatus

Retrieve official entity status.
 Status of zero (0) return if entity not found.

```js
function entityIndexStatus(uint256 entityIndex) public view
returns(uint256)
```

**Returns**

the entity status as maintained by Immutable

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 

### entityAddressStatus

Retrieve official entity status.
 Status of zero (0) return if entity not found.

```js
function entityAddressStatus(address entityAddress) public view
returns(uint256)
```

**Returns**

the entity status as maintained by Immutable

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityAddress | address | The address of the entity | 

### entityAddressToIndex

Retrieve official global entity index.
 Return index of zero (0) is not found.

```js
function entityAddressToIndex(address entityAddress) public view
returns(uint256)
```

**Returns**

the entity index as maintained by Immutable

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityAddress | address | The address of the entity | 

### entityIndexToAddress

Retrieve current global entity address.
 Return address of zero (0) is not found.

```js
function entityIndexToAddress(uint256 entityIndex) public view
returns(address)
```

**Returns**

the current entity address as maintained by Immutable

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The global index of the entity | 

### entityDetailsByIndex

Retrieve entity details from index.

```js
function entityDetailsByIndex(uint256 entityIndex) public view
returns(name string, URL string)
```

**Returns**

name and URL are return values.\
         **name** the entity name\
         **URL** the entity name\

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 

### entityNumberOf

Retrieve number of entities.

```js
function entityNumberOf() public view
returns(uint256)
```

**Returns**

the number of entities

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### entityUpgradeFee

Retrieve fee to upgrade.

```js
function entityUpgradeFee() public view
returns(uint256)
```

**Returns**

the number of entities

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### entityBank

Retrieve bank address that contract pays out to

```js
function entityBank(uint256 entityIndex) external view
returns(bank address)
```

**Returns**

bank Ethereum address to pay out entity

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 

### entityAllDetails

Retrieve all entity details
 Status of empty arrays if none found.

```js
function entityAllDetails() external view
returns(status uint256[], name string[], URL string[])
```

**Returns**

status , name and URL arrays are return values.\
         **status** Array of entity status\
         **name** Array of entity names\
         **URL** Array of entity URLs

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

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
