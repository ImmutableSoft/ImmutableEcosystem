# ResolverBase.sol

View Source: [contracts/ResolverBase.sol](../contracts/ResolverBase.sol)

**ResolverBase**

## Contract Members
**Constants & Variables**

```js
bytes4 private constant INTERFACE_META_ID;

```

## Modifiers

- [authorised](#authorised)

### authorised

```js
modifier authorised(bytes32 node) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 

## Functions

- [supportsInterface(bytes4 interfaceID)](#supportsinterface)
- [isAuthorised(bytes32 node)](#isauthorised)
- [bytesToAddress(bytes b)](#bytestoaddress)
- [addressToBytes(address a)](#addresstobytes)

### supportsInterface

```js
function supportsInterface(bytes4 interfaceID) public pure
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| interfaceID | bytes4 |  | 

### isAuthorised

```js
function isAuthorised(bytes32 node) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 

### bytesToAddress

```js
function bytesToAddress(bytes b) internal pure
returns(a address payable)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| b | bytes |  | 

### addressToBytes

```js
function addressToBytes(address a) internal pure
returns(b bytes)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | address |  | 

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
