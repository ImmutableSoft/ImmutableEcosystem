# Immutable Entity - managed trust zone for the ecosystem (ImmutableEntity.sol)

View Source: [\contracts\ImmutableEntity.sol](..\contracts\ImmutableEntity.sol)

**↗ Extends: [Initializable](Initializable.md), [OwnableUpgradeable](OwnableUpgradeable.md), [PullPaymentUpgradeable](PullPaymentUpgradeable.md)**

**ImmutableEntity**

Token transfers use the ImmuteToken by default

## Structs
### Entity

```js
struct Entity {
 address payable bank,
 address prevAddress,
 address nextAddress,
 string name,
 string entityEnsName,
 string infoURL,
 uint256 createTime
}
```

## Contract Members
**Constants & Variables**

```js
//internal members
string internal constant BankNotConfigured;
uint256 internal NumberOfEntities;

//private members
mapping(address => uint256) private EntityIndex;
mapping(uint256 => uint256) private EntityStatus;
mapping(uint256 => address) private EntityArray;
mapping(uint256 => struct ImmutableEntity.Entity) private Entities;
contract StringCommon private commonInterface;

```

**Events**

```js
event entityEvent(uint256  entityIndex, string  name, string  url);
event entityTransferEvent(uint256  entityIndex, uint256  productIndex, uint256  amount);
```

## Functions

- [initialize(address commonAddr)](#initialize)
- [entityStatusUpdate(uint256 entityIndex, uint256 status)](#entitystatusupdate)
- [entityCreate(string entityName, string entityURL)](#entitycreate)
- [entityUpdate(string entityName, string entityURL)](#entityupdate)
- [entityBankChange(address payable newBank)](#entitybankchange)
- [entityAddressNext(address nextAddress)](#entityaddressnext)
- [entityAdminAddressNext(address entityAddress, address nextAddress)](#entityadminaddressnext)
- [entityAddressMove(address oldAddress)](#entityaddressmove)
- [entityPaymentsWithdraw()](#entitypaymentswithdraw)
- [entityTransfer(uint256 entityIndex, uint256 productIndex)](#entitytransfer)
- [entityIndexStatus(uint256 entityIndex)](#entityindexstatus)
- [entityAddressStatus(address entityAddress)](#entityaddressstatus)
- [entityAddressToIndex(address entityAddress)](#entityaddresstoindex)
- [entityIndexToAddress(uint256 entityIndex)](#entityindextoaddress)
- [entityDetailsByIndex(uint256 entityIndex)](#entitydetailsbyindex)
- [entityNumberOf()](#entitynumberof)
- [entityPaymentsCheck()](#entitypaymentscheck)
- [entityAllDetails()](#entityalldetails)

### initialize

Contract initializer
 Executed on contract creation only.

```js
function initialize(address commonAddr) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| commonAddr | address |  | 

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

### entityPaymentsWithdraw

Withdraw all payments (ETH) into entity bank.
 Uses OpenZeppelin PullPayment interface.

```js
function entityPaymentsWithdraw() external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### entityTransfer

Transfer ETH to an entity.
 Entity must exist and have bank configured.
 Payable, requires ETH transfer.
 msg.sender is the payee

```js
function entityTransfer(uint256 entityIndex, uint256 productIndex) public payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of entity recipient bank | 
| productIndex | uint256 |  | 

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

### entityPaymentsCheck

Check payment (ETH) due entity bank.
 Uses OpenZeppelin PullPayment interface.

```js
function entityPaymentsCheck() external view
returns(uint256)
```

**Returns**

the amount of ETH in the entity escrow

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

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
