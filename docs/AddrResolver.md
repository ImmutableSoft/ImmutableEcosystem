# AddrResolver.sol

View Source: [contracts/AddrResolver.sol](../contracts/AddrResolver.sol)

**↗ Extends: [ResolverBase](ResolverBase.md)**
**↘ Derived Contracts: [ImmutableResolver](ImmutableResolver.md)**

**AddrResolver**

## Contract Members
**Constants & Variables**

```js
//private members
bytes4 private constant ADDR_INTERFACE_ID;
bytes4 private constant ADDRESS_INTERFACE_ID;
uint256 private constant COIN_TYPE_ETH;

//internal members
mapping(bytes32 => mapping(uint256 => bytes)) internal _addresses;

```

**Events**

```js
event AddrChanged(bytes32 indexed node, address  a);
event AddressChanged(bytes32 indexed node, uint256  coinType, bytes  newAddress);
```

## Functions

- [setAddr(bytes32 node, address a)](#setaddr)
- [addr(bytes32 node)](#addr)
- [setAddr(bytes32 node, uint256 coinType, bytes a)](#setaddr)
- [addr(bytes32 node, uint256 coinType)](#addr)
- [supportsInterface(bytes4 interfaceID)](#supportsinterface)

### setAddr

```js
function setAddr(bytes32 node, address a) public nonpayable authorised 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 | The node to update. | 
| a | address | The address to set. | 

### addr

```js
function addr(bytes32 node) public view
returns(address payable)
```

**Returns**

The associated address.

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 | The ENS node to query. | 

### setAddr

```js
function setAddr(bytes32 node, uint256 coinType, bytes a) public nonpayable authorised 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 
| coinType | uint256 |  | 
| a | bytes |  | 

### addr

```js
function addr(bytes32 node, uint256 coinType) public view
returns(bytes)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 
| coinType | uint256 |  | 

### supportsInterface

⤾ overrides [ResolverBase.supportsInterface](ResolverBase.md#supportsinterface)

```js
function supportsInterface(bytes4 interfaceID) public pure
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| interfaceID | bytes4 |  | 

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
