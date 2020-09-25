# Immutable String - common string routines for ecosystem (StringCommon.sol)

View Source: [contracts/StringCommon.sol](../contracts/StringCommon.sol)

**StringCommon**

StringCommon is string related general/pure functions

## Functions

- [namehash(bytes32 node, bytes32 label)](#namehash)
- [normalizeString(string str)](#normalizestring)
- [stringsEqual(string _a, string _b)](#stringsequal)
- [stringToBytes32(string source)](#stringtobytes32)

### namehash

Convert a base ENS node and label to a node (namehash).
 ENS nodes are represented as bytes32.

```js
function namehash(bytes32 node, bytes32 label) public pure
returns(bytes32)
```

**Returns**

The namehash in bytes32 format

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| node | bytes32 | The ENS subnode the label is a part of | 
| label | bytes32 | The bytes32 of end label | 

### normalizeString

Convert an ASCII string to a normalized string.
 Oversimplified, removes many legitimate characters.

```js
function normalizeString(string str) public pure
returns(string)
```

**Returns**

The normalized string

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| str | string | The string to normalize | 

### stringsEqual

Compare strings and return true if equal.
 Case sensitive.

```js
function stringsEqual(string _a, string _b) public pure
returns(bool)
```

**Returns**

true if strings are equal, otherwise false

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _a | string | The string to be compared | 
| _b | string | The string to compare | 

### stringToBytes32

Convert a string to a bytes32 equivalent.
 Case sensitive.

```js
function stringToBytes32(string source) public pure
returns(result bytes32)
```

**Returns**

the bytes32 equivalent of 'source'

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| source | string | The source string | 

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
