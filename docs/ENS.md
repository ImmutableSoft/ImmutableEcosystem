# ENS.sol

View Source: [@ensdomains/ens/contracts/ENS.sol](../@ensdomains/ens/contracts/ENS.sol)

**ENS**

**Events**

```js
event NewOwner(bytes32 indexed node, bytes32 indexed label, address  owner);
event Transfer(bytes32 indexed node, address  owner);
event NewResolver(bytes32 indexed node, address  resolver);
event NewTTL(bytes32 indexed node, uint64  ttl);
```

## Functions

- [setSubnodeOwner(bytes32 node, bytes32 label, address owner)](#setsubnodeowner)
- [setResolver(bytes32 node, address resolver)](#setresolver)
- [setOwner(bytes32 node, address owner)](#setowner)
- [setTTL(bytes32 node, uint64 ttl)](#setttl)
- [owner(bytes32 node)](#owner)
- [resolver(bytes32 node)](#resolver)
- [ttl(bytes32 node)](#ttl)

### setSubnodeOwner

```js
function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 
| label | bytes32 |  | 
| owner | address |  | 

### setResolver

```js
function setResolver(bytes32 node, address resolver) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 
| resolver | address |  | 

### setOwner

```js
function setOwner(bytes32 node, address owner) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 
| owner | address |  | 

### setTTL

```js
function setTTL(bytes32 node, uint64 ttl) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 
| ttl | uint64 |  | 

### owner

```js
function owner(bytes32 node) external view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 

### resolver

```js
function resolver(bytes32 node) external view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 

### ttl

```js
function ttl(bytes32 node) external view
returns(uint64)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 |  | 

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
