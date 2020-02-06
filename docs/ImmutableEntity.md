# Immutable Entity - authentic software from the source (ImmutableEntity.sol)

View Source: [contracts/ImmutableEntity.sol](../contracts/ImmutableEntity.sol)

**↗ Extends: [Ownable](Ownable.md), [PullPayment](PullPayment.md), [ImmutableConstants](ImmutableConstants.md), [AddrResolver](AddrResolver.md)**

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
 uint256 numberOfOffers,
 uint256 numberOfLicenses,
 uint256 escrow,
 address erc20Token,
 mapping(uint256 => struct ImmutableEntity.TokenBlockOffer) offers
}
```

### TokenBlockOffer

```js
struct TokenBlockOffer {
 uint256 rate,
 uint256 blockSize,
 uint256 escrow
}
```

## Contract Members
**Constants & Variables**

```js
//public members
bytes32 public constant TLD_NODE;
uint256 public constant COIN_TYPE_ETH;

//internal members
string internal constant EntityNotValid;
string internal constant EntityIsZero;
string internal constant EntityNotValidated;
string internal constant BankNotConfigured;

//private members
mapping(address => uint256) private EntityIndex;
mapping(uint256 => uint256) private EntityStatus;
address[] private EntityArray;
struct ImmutableEntity.Entity[] private Entities;
contract ImmuteToken private tokenInterface;
contract StringCommon private commonInterface;
contract ENS private ens;
address private ensAddress;
bytes32 private rootNode;

```

**Events**

```js
event entityEvent(uint256  entityIndex, string  name, string  url);
event entityTokenBlockOfferEvent(uint256  entityIndex, uint256  rate, uint256  tokens, uint256  amount);
event entityTokenBlockPurchaseEvent(address indexed purchaserAddress, uint256  entityIndex, uint256  rate, uint256  tokens, uint256  amount);
```

## Functions

- [(address immuteToken, address commonAddr, address ensAddr)](#)
- [isAuthorised(bytes32 )](#isauthorised)
- [entityStatusUpdate(uint256 entityIndex, uint256 status)](#entitystatusupdate)
- [entityCustomToken(uint256 entityIndex, address tokenAddress)](#entitycustomtoken)
- [entityCreate(string entityName, string entityURL)](#entitycreate)
- [entityUpdate(string entityName, string entityURL)](#entityupdate)
- [entityBankChange(address payable newBank)](#entitybankchange)
- [entityAddressNext(address nextAddress, uint256 numTokens)](#entityaddressnext)
- [entityAdminAddressNext(address entityAddress, address nextAddress, uint256 numTokens)](#entityadminaddressnext)
- [entityAddressMove(address oldAddress)](#entityaddressmove)
- [entityPaymentsWithdraw()](#entitypaymentswithdraw)
- [entityTokenBlockOffer(uint256 rate, uint256 tokens, uint256 count)](#entitytokenblockoffer)
- [entityTokenBlockOfferRevoke(uint256 offerIndex)](#entitytokenblockofferrevoke)
- [entityTransfer(uint256 entityIndex)](#entitytransfer)
- [entityTokenBlockPurchase(uint256 entityIndex, uint256 offerIndex, uint256 count)](#entitytokenblockpurchase)
- [entityIdToLocalId(uint256 entityIndex)](#entityidtolocalid)
- [entityIndexStatus(uint256 entityIndex)](#entityindexstatus)
- [entityAddressStatus(address entityAddress)](#entityaddressstatus)
- [entityAddressToIndex(address entityAddress)](#entityaddresstoindex)
- [entityDetailsByIndex(uint256 entityIndex)](#entitydetailsbyindex)
- [entityNumberOf()](#entitynumberof)
- [entityNumberOfOffers(uint256 entityIndex)](#entitynumberofoffers)
- [entityOfferDetails(uint256 entityIndex, uint256 offerId)](#entityofferdetails)
- [entityPaymentsCheck()](#entitypaymentscheck)
- [entityCustomTokenAddress(uint256 entityIndex)](#entitycustomtokenaddress)
- [entityRootNode()](#entityrootnode)

### 

contract initializer/constructor

```js
function (address immuteToken, address commonAddr, address ensAddr) public nonpayable PullPayment 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| immuteToken | address | the address of the IuT token contract | 
| commonAddr | address | the address of the CommonString contract | 
| ensAddr | address | the address of the ENS contract | 

### isAuthorised

⤾ overrides [ResolverBase.isAuthorised](ResolverBase.md#isauthorised)

ENS authorization check

```js
function isAuthorised(bytes32 ) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
|  | bytes32 |  | 

### entityStatusUpdate

Administrator (onlyOwner) update an entity status

```js
function entityStatusUpdate(uint256 entityIndex, uint256 status) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | index of entity to change status | 
| status | uint256 | The new complete status aggregate value | 

### entityCustomToken

Administrator (onlyOwner) update entity with custom ERC20

```js
function entityCustomToken(uint256 entityIndex, address tokenAddress) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity global index | 
| tokenAddress | address | The custom ERC20 contract address | 

### entityCreate

Create an organization

```js
function entityCreate(string entityName, string entityURL) public nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityName | string | The legal name of the entity | 
| entityURL | string | The valid URL of the entity | 

### entityUpdate

Update an organization

```js
function entityUpdate(string entityName, string entityURL) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityName | string | The legal name of the entity | 
| entityURL | string | The valid URL of the entity | 

### entityBankChange

Change bank address that contract pays out to

```js
function entityBankChange(address payable newBank) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newBank | address payable | payable Ethereum address owned by entity | 

### entityAddressNext

Propose to move an entity (change addresses)

```js
function entityAddressNext(address nextAddress, uint256 numTokens) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| nextAddress | address | The next address of the entity | 
| numTokens | uint256 | The number of tokens to move to the new address | 

### entityAdminAddressNext

Admin override for moving an entity (change addresses)

```js
function entityAdminAddressNext(address entityAddress, address nextAddress, uint256 numTokens) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityAddress | address | The address of the entity to move | 
| nextAddress | address | The next address of the entity | 
| numTokens | uint256 | The number of tokens to move to the new address | 

### entityAddressMove

Finish moving an entity (change addresses)

```js
function entityAddressMove(address oldAddress) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| oldAddress | address | The previous address of the entity | 

### entityPaymentsWithdraw

Withdraw all payments (ETH) into entity bank

```js
function entityPaymentsWithdraw() external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### entityTokenBlockOffer

Offer a block of tokens in exchange for ETH

```js
function entityTokenBlockOffer(uint256 rate, uint256 tokens, uint256 count) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rate | uint256 | The rate of exchange (multiplyer of ETH) | 
| tokens | uint256 | The minimum multiplyer of tokens offered | 
| count | uint256 | The number of blocks, or 'tokens' amounts | 

### entityTokenBlockOfferRevoke

Revoke a previous offer of a block of tokens

```js
function entityTokenBlockOfferRevoke(uint256 offerIndex) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| offerIndex | uint256 | The identifier of the offer to revoke | 

### entityTransfer

Transfer ETH to an entity

```js
function entityTransfer(uint256 entityIndex) public payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of entity recipient bank | 

### entityTokenBlockPurchase

Purchase an block of tokens offered for ETH

```js
function entityTokenBlockPurchase(uint256 entityIndex, uint256 offerIndex, uint256 count) external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity with offer | 
| offerIndex | uint256 | The specific offer | 
| count | uint256 | The number of blocks of the offer to purchase | 

### entityIdToLocalId

Return the local entity ID (index)

```js
function entityIdToLocalId(uint256 entityIndex) public view
returns(uint256)
```

**Returns**

The local index of the entity

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The global index of the entity | 

### entityIndexStatus

Retrieve official entity status

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

Retrieve official entity status

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

Retrieve official global entity index

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

### entityDetailsByIndex

Retrieve entity details from index

```js
function entityDetailsByIndex(uint256 entityIndex) public view
returns(string, string)
```

**Returns**

the entity name

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 

### entityNumberOf

Retrieve number of entities

```js
function entityNumberOf() public view
returns(uint256)
```

**Returns**

the number of entities

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### entityNumberOfOffers

Return the number of token offers for an entity

```js
function entityNumberOfOffers(uint256 entityIndex) external view
returns(uint256)
```

**Returns**

the current number of token offers

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 

### entityOfferDetails

Retrieve details of a token offer

```js
function entityOfferDetails(uint256 entityIndex, uint256 offerId) external view
returns(uint256, uint256, uint256)
```

**Returns**

the ETH to token exchange rate

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity to lookup | 
| offerId | uint256 |  | 

### entityPaymentsCheck

Check payment (ETH) due entity bank

```js
function entityPaymentsCheck() external view
returns(uint256)
```

**Returns**

the amount of ETH in the entity escrow

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### entityCustomTokenAddress

Return the entity custom ERC20 contract address

```js
function entityCustomTokenAddress(uint256 entityIndex) external view
returns(address)
```

**Returns**

the entity custom ERC20 token or zero address

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity to lookup | 

### entityRootNode

Return ENS immutablesoft root node

```js
function entityRootNode() external view
returns(bytes32)
```

**Returns**

the bytes32 ENS root node for immutablesoft.eth

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

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
