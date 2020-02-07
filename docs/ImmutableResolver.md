# Immutable Resolver- resolve immutablesoft.eth addresses (ImmutableResolver.sol)

View Source: [contracts/ImmutableResolver.sol](../contracts/ImmutableResolver.sol)

**↗ Extends: [Ownable](Ownable.md), [AddrResolver](AddrResolver.md)**

**ImmutableResolver**

Inherits ENS example AddrResolver

## Contract Members
**Constants & Variables**

```js
contract ENS private ens;
address private ensAddress;
bytes32 private root;
contract ImmutableEntity private entityInterface;

```

## Functions

- [(address entityAddr, address ensAddr)](#)
- [isAuthorised(bytes32 )](#isauthorised)
- [setRootNode(bytes32 rootNode)](#setrootnode)
- [rootNode()](#rootnode)

### 

ImmutableResolver contract initializer/constructor.
 Executed on contract creation only.

```js
function (address entityAddr, address ensAddr) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| entityAddr | address | is address of ImmutableEntity contract | 
| ensAddr | address | is address of the ENS contract | 

### isAuthorised

⤾ overrides [ResolverBase.isAuthorised](ResolverBase.md#isauthorised)

ENS authorization check.
 Executed on ENS resolver calls
 The parameter is unused as this is an owned resolver

```js
function isAuthorised(bytes32 ) internal view
returns(bool)
```

**Returns**

true if msg.sender is owner, false otherwise

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
|  | bytes32 |  | 

### setRootNode

Sets the ENS immutablesoft root node

```js
function setRootNode(bytes32 rootNode) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rootNode | bytes32 | is bytes32 ENS root node for immutablesoft.eth | 

### rootNode

Return ENS immutablesoft root node

```js
function rootNode() public view
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
