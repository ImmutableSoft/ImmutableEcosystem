# Immutable Entity - managed trust zone for the ecosystem (ImmutableEntity.sol)

View Source: [contracts/ImmutableEntity.sol](../contracts/ImmutableEntity.sol)

**↗ Extends: [Ownable](Ownable.md), [PullPayment](PullPayment.md), [ImmutableConstants](ImmutableConstants.md)**

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
 uint256 escrow,
 address erc20Token,
 uint256 referral,
 uint256 createTime,
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
//internal members
uint256 internal constant ReferralEntityBonus;
uint256 internal constant ReferralSubscriptionBonus;
uint256 internal constant EntitySubscriptionBonus;
string internal constant EntityIsZero;
string internal constant BankNotConfigured;

//private members
mapping(address => uint256) private EntityIndex;
mapping(uint256 => uint256) private EntityStatus;
address[] private EntityArray;
struct ImmutableEntity.Entity[] private Entities;
contract ImmuteToken private tokenInterface;
contract StringCommon private commonInterface;
contract ImmutableResolver private resolver;

```

**Events**

```js
event entityEvent(uint256  entityIndex, string  name, string  url);
event entityTokenBlockOfferEvent(uint256  entityIndex, uint256  rate, uint256  tokens, uint256  amount);
event entityTokenBlockPurchaseEvent(address indexed purchaserAddress, uint256  entityIndex, uint256  rate, uint256  tokens, uint256  amount);
event entityTransferEvent(uint256  entityIndex, uint256  productIndex, uint256  amount);
event entityDonateEvent(uint256  entityIndex, uint256  productIndex, uint256  numTokens);
```

## Functions

- [(address immuteToken, address commonAddr)](#)
- [entityResolver(address resolverAddr, bytes32 rootNode)](#entityresolver)
- [entityStatusUpdate(uint256 entityIndex, uint256 status)](#entitystatusupdate)
- [entityCustomToken(uint256 entityIndex, address tokenAddress)](#entitycustomtoken)
- [entityCreate(string entityName, string entityURL, uint256 referralEntityIndex)](#entitycreate)
- [entityUpdate(string entityName, string entityURL)](#entityupdate)
- [entityBankChange(address payable newBank)](#entitybankchange)
- [entityAddressNext(address nextAddress, uint256 numTokens)](#entityaddressnext)
- [entityAdminAddressNext(address entityAddress, address nextAddress, uint256 numTokens)](#entityadminaddressnext)
- [entityAddressMove(address oldAddress)](#entityaddressmove)
- [entityPaymentsWithdraw()](#entitypaymentswithdraw)
- [entityTokenBlockOffer(uint256 rate, uint256 tokens, uint256 count)](#entitytokenblockoffer)
- [entityTokenBlockOfferChange(uint256 offerIndex, uint256 rate, uint256 count)](#entitytokenblockofferchange)
- [entityTransfer(uint256 entityIndex, uint256 productIndex)](#entitytransfer)
- [entityDonate(uint256 entityIndex, uint256 productIndex, uint256 numTokens)](#entitydonate)
- [entityTokenBlockPurchase(uint256 entityIndex, uint256 offerIndex, uint256 count)](#entitytokenblockpurchase)
- [entityIdToLocalId(uint256 entityIndex)](#entityidtolocalid)
- [entityIndexStatus(uint256 entityIndex)](#entityindexstatus)
- [entityAddressStatus(address entityAddress)](#entityaddressstatus)
- [entityAddressToIndex(address entityAddress)](#entityaddresstoindex)
- [entityIndexToAddress(uint256 entityIndex)](#entityindextoaddress)
- [entityDetailsByIndex(uint256 entityIndex)](#entitydetailsbyindex)
- [entityReferralByIndex(uint256 entityIndex)](#entityreferralbyindex)
- [entityNumberOf()](#entitynumberof)
- [entityNumberOfOffers(uint256 entityIndex)](#entitynumberofoffers)
- [entityOfferDetails(uint256 entityIndex, uint256 offerId)](#entityofferdetails)
- [entityPaymentsCheck()](#entitypaymentscheck)
- [entityCustomTokenAddress(uint256 entityIndex)](#entitycustomtokenaddress)
- [entityRootNode()](#entityrootnode)

### 

Contract initializer/constructor.
 Executed on contract creation only.

```js
function (address immuteToken, address commonAddr) public nonpayable PullPayment 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| immuteToken | address | the address of the IuT token contract | 
| commonAddr | address | the address of the CommonString contract | 

### entityResolver

Set ImmutableSoft ENS resolver. A zero address disables resolver.
 Administrator (onlyOwner)

```js
function entityResolver(address resolverAddr, bytes32 rootNode) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| resolverAddr | address | the address of the immutable resolver | 
| rootNode | bytes32 |  | 

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

### entityCustomToken

Update entity with custom ERC20.
 Must NOT be called if entity has existing product sales escrow.
 Entity requires prior approval with custom token status.
 Administrator (onlyOwner)

```js
function entityCustomToken(uint256 entityIndex, address tokenAddress) external nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The entity global index | 
| tokenAddress | address | The custom ERC20 contract address | 

### entityCreate

Create an organization.
 Entities require approval (entityStatusUpdate) after create.

```js
function entityCreate(string entityName, string entityURL, uint256 referralEntityIndex) public nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityName | string | The legal name of the entity | 
| entityURL | string | The valid URL of the entity | 
| referralEntityIndex | uint256 |  | 

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
function entityAddressNext(address nextAddress, uint256 numTokens) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| nextAddress | address | The next address of the entity | 
| numTokens | uint256 | The number of tokens to move to the new address | 

### entityAdminAddressNext

Admin override for moving an entity (change addresses).
 To complete move call entityMoveAddress with new address.
 msg.sender must be Administrator (owner).

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

### entityTokenBlockOffer

Offer a block of tokens in exchange for ETH.
 Purchasers can buy any multiple of 'tokens' up to 'count'.
 'tokens' multipled by 'count' will be escrowed in offer.
 msg.sender must be a registered entity.

```js
function entityTokenBlockOffer(uint256 rate, uint256 tokens, uint256 count) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rate | uint256 | The rate of exchange (multiplyer of ETH) | 
| tokens | uint256 | The minimum multiplyer of tokens offered | 
| count | uint256 | The number of blocks, or 'tokens' amounts | 

### entityTokenBlockOfferChange

Change rate and/or number of blocks of token offer.
 Offer must already exist and owned by msg.sender.

```js
function entityTokenBlockOfferChange(uint256 offerIndex, uint256 rate, uint256 count) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| offerIndex | uint256 | The identifier of the offer to revoke | 
| rate | uint256 |  | 
| count | uint256 |  | 

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

### entityDonate

Donate tokens to an entity.
 Entity must exist
 msg.sender is the payee

```js
function entityDonate(uint256 entityIndex, uint256 productIndex, uint256 numTokens) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of entity | 
| productIndex | uint256 | The index of product | 
| numTokens | uint256 | The number of tokens to donate | 

### entityTokenBlockPurchase

Purchase an block of tokens offered for ETH.
 Offer must already exist. Payable, requires ETH transfer.
 msg.sender is the purchaser.

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

Return the local entity ID (index).
 Entity must exist and id be valid.

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
returns(string, string)
```

**Returns**

the entity name

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityIndex | uint256 | The index of the entity | 

### entityReferralByIndex

Retrieve entity referral details.

```js
function entityReferralByIndex(uint256 entityIndex) public view
returns(address, uint256)
```

**Returns**

the entity referral

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

### entityNumberOfOffers

Return the number of token offers for an entity.
 Entity must exist and index be valid.

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

Retrieve details of a token offer.
 Returns empty name and URL if not found.

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

### entityCustomTokenAddress

Return the entity custom ERC20 contract address.

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

Return ENS immutablesoft root node.

```js
function entityRootNode() public view
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
