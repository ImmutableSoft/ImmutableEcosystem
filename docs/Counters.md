# Counters (Counters.sol)

View Source: [@openzeppelin/contracts-ethereum-package/contracts/drafts/Counters.sol](../@openzeppelin/contracts-ethereum-package/contracts/drafts/Counters.sol)

**Counters**

Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
of elements in a mapping, issuing ERC721 ids, or counting request ids.
 * Include with `using Counters for Counters.Counter;`
Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
directly accessed.

## Structs
### Counter

```js
struct Counter {
 uint256 _value
}
```

## Functions

- [current(struct Counters.Counter counter)](#current)
- [increment(struct Counters.Counter counter)](#increment)
- [decrement(struct Counters.Counter counter)](#decrement)

### current

```js
function current(struct Counters.Counter counter) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| counter | struct Counters.Counter |  | 

### increment

```js
function increment(struct Counters.Counter counter) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| counter | struct Counters.Counter |  | 

### decrement

```js
function decrement(struct Counters.Counter counter) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| counter | struct Counters.Counter |  | 

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
