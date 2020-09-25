# Initializable
 * (Initializable.sol)

View Source: [@openzeppelin/upgrades/contracts/Initializable.sol](../@openzeppelin/upgrades/contracts/Initializable.sol)

**↘ Derived Contracts: [ActivateToken](ActivateToken.md), [Context](Context.md), [ERC165](ERC165.md), [ERC20](ERC20.md), [ERC20Detailed](ERC20Detailed.md), [ERC20Mintable](ERC20Mintable.md), [ERC721](ERC721.md), [ERC721Burnable](ERC721Burnable.md), [ERC721Enumerable](ERC721Enumerable.md), [ERC721Mintable](ERC721Mintable.md), [Escrow](Escrow.md), [IERC721](IERC721.md), [IERC721Enumerable](IERC721Enumerable.md), [ImmutableEntity](ImmutableEntity.md), [ImmutableProduct](ImmutableProduct.md), [MinterRole](MinterRole.md), [Ownable](Ownable.md), [PullPayment](PullPayment.md), [Secondary](Secondary.md)**

**Initializable**

Helper contract to support initializer functions. To use it, replace
the constructor with a function that has the `initializer` modifier.
WARNING: Unlike constructors, initializer functions must be manually
invoked. This applies both to deploying an Initializable contract, as well
as extending an Initializable contract via inheritance.
WARNING: When used with inheritance, manual care must be taken to not invoke
a parent initializer twice, or ensure that all initializers are idempotent,
because this is not dealt with automatically as with constructors.

## Contract Members
**Constants & Variables**

```js
bool private initialized;
bool private initializing;
uint256[50] private ______gap;

```

## Modifiers

- [initializer](#initializer)

### initializer

Modifier to use in the initializer function of a contract.

```js
modifier initializer() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [isConstructor()](#isconstructor)

### isConstructor

Returns true if and only if the function is running in the constructor

```js
function isConstructor() private view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

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
