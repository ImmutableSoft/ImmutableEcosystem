# ResolverBase.sol

View Source: [contracts/ResolverBase.sol](../contracts/ResolverBase.sol)

**↘ Derived Contracts: [AddrResolver](AddrResolver.md)**

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

⤿ Overridden Implementation(s): [AddrResolver.supportsInterface](AddrResolver.md#supportsinterface)

```js
function supportsInterface(bytes4 interfaceID) public pure
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| interfaceID | bytes4 |  | 

### isAuthorised

⤿ Overridden Implementation(s): [ImmutableResolver.isAuthorised](ImmutableResolver.md#isauthorised)

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
