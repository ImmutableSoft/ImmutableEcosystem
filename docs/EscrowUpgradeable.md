# Escrow (EscrowUpgradeable.sol)

View Source: [@openzeppelin\contracts-upgradeable\utils\escrow\EscrowUpgradeable.sol](..\@openzeppelin\contracts-upgradeable\utils\escrow\EscrowUpgradeable.sol)

**↗ Extends: [Initializable](Initializable.md), [OwnableUpgradeable](OwnableUpgradeable.md)**

**EscrowUpgradeable**

Base escrow contract, holds funds designated for a payee until they
 withdraw them.
 Intended usage: This contract (and derived escrow contracts) should be a
 standalone contract, that only interacts with the contract that instantiated
 it. That way, it is guaranteed that all Ether will be handled according to
 the `Escrow` rules, and there is no need to check for payable functions or
 transfers in the inheritance tree. The contract that uses the escrow as its
 payment method should be its owner, and provide public methods redirecting
 to the escrow's deposit and withdraw.

## Contract Members
**Constants & Variables**

```js
mapping(address => uint256) private _deposits;
uint256[49] private __gap;

```

**Events**

```js
event Deposited(address indexed payee, uint256  weiAmount);
event Withdrawn(address indexed payee, uint256  weiAmount);
```

## Functions

- [initialize()](#initialize)
- [__Escrow_init()](#__escrow_init)
- [__Escrow_init_unchained()](#__escrow_init_unchained)
- [depositsOf(address payee)](#depositsof)
- [deposit(address payee)](#deposit)
- [withdraw(address payable payee)](#withdraw)

### initialize

```js
function initialize() public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### __Escrow_init

```js
function __Escrow_init() internal nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### __Escrow_init_unchained

```js
function __Escrow_init_unchained() internal nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### depositsOf

```js
function depositsOf(address payee) public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address |  | 

### deposit

Stores the sent amount as credit to be withdrawn.

```js
function deposit(address payee) public payable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address | The destination address of the funds. | 

### withdraw

Withdraw accumulated balance for a payee, forwarding all gas to the
 recipient.
 WARNING: Forwarding all gas opens the door to reentrancy vulnerabilities.
 Make sure you trust the recipient, or are either following the
 checks-effects-interactions pattern or using {ReentrancyGuard}.

```js
function withdraw(address payable payee) public nonpayable onlyOwner 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address payable | The address whose funds will be withdrawn and transferred to. | 

## Contracts

* [ActivateToken](ActivateToken.md)
* [AddressUpgradeable](AddressUpgradeable.md)
* [ContextUpgradeable](ContextUpgradeable.md)
* [CreatorToken](CreatorToken.md)
* [CustomToken](CustomToken.md)
* [ERC165Upgradeable](ERC165Upgradeable.md)
* [ERC20Upgradeable](ERC20Upgradeable.md)
* [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md)
* [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md)
* [ERC721Upgradeable](ERC721Upgradeable.md)
* [ERC721URIStorageUpgradeable](ERC721URIStorageUpgradeable.md)
* [EscrowUpgradeable](EscrowUpgradeable.md)
* [IERC165Upgradeable](IERC165Upgradeable.md)
* [IERC20MetadataUpgradeable](IERC20MetadataUpgradeable.md)
* [IERC20Upgradeable](IERC20Upgradeable.md)
* [IERC721EnumerableUpgradeable](IERC721EnumerableUpgradeable.md)
* [IERC721MetadataUpgradeable](IERC721MetadataUpgradeable.md)
* [IERC721ReceiverUpgradeable](IERC721ReceiverUpgradeable.md)
* [IERC721Upgradeable](IERC721Upgradeable.md)
* [ImmutableEntity](ImmutableEntity.md)
* [ImmutableProduct](ImmutableProduct.md)
* [Initializable](Initializable.md)
* [Migrations](Migrations.md)
* [OwnableUpgradeable](OwnableUpgradeable.md)
* [ProductActivate](ProductActivate.md)
* [PullPaymentUpgradeable](PullPaymentUpgradeable.md)
* [StringCommon](StringCommon.md)
* [StringsUpgradeable](StringsUpgradeable.md)
