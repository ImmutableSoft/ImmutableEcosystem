# PullPaymentUpgradeable.sol

View Source: [@openzeppelin\contracts-upgradeable\security\PullPaymentUpgradeable.sol](..\@openzeppelin\contracts-upgradeable\security\PullPaymentUpgradeable.sol)

**↗ Extends: [Initializable](Initializable.md)**
**↘ Derived Contracts: [CreatorToken](CreatorToken.md), [ImmutableEntity](ImmutableEntity.md), [ProductActivate](ProductActivate.md)**

**PullPaymentUpgradeable**

Simple implementation of a
 https://consensys.github.io/smart-contract-best-practices/recommendations/#favor-pull-over-push-for-external-calls[pull-payment]
 strategy, where the paying contract doesn't interact directly with the
 receiver account, which must withdraw its payments itself.
 Pull-payments are often considered the best practice when it comes to sending
 Ether, security-wise. It prevents recipients from blocking execution, and
 eliminates reentrancy concerns.
 TIP: If you would like to learn more about reentrancy and alternative ways
 to protect against it, check out our blog post
 https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 To use, derive from the `PullPayment` contract, and use {_asyncTransfer}
 instead of Solidity's `transfer` function. Payees can query their due
 payments with {payments}, and retrieve them with {withdrawPayments}.

## Contract Members
**Constants & Variables**

```js
contract EscrowUpgradeable private _escrow;
uint256[50] private __gap;

```

## Functions

- [__PullPayment_init()](#__pullpayment_init)
- [__PullPayment_init_unchained()](#__pullpayment_init_unchained)
- [withdrawPayments(address payable payee)](#withdrawpayments)
- [payments(address dest)](#payments)
- [_asyncTransfer(address dest, uint256 amount)](#_asynctransfer)

### __PullPayment_init

```js
function __PullPayment_init() internal nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### __PullPayment_init_unchained

```js
function __PullPayment_init_unchained() internal nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### withdrawPayments

Withdraw accumulated payments, forwarding all gas to the recipient.
 Note that _any_ account can call this function, not just the `payee`.
 This means that contracts unaware of the `PullPayment` protocol can still
 receive funds this way, by having a separate account call
 {withdrawPayments}.
 WARNING: Forwarding all gas opens the door to reentrancy vulnerabilities.
 Make sure you trust the recipient, or are either following the
 checks-effects-interactions pattern or using {ReentrancyGuard}.

```js
function withdrawPayments(address payable payee) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address payable | Whose payments will be withdrawn. | 

### payments

Returns the payments owed to an address.

```js
function payments(address dest) public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| dest | address | The creditor's address. | 

### _asyncTransfer

Called by the payer to store the sent amount as credit to be pulled.
 Funds sent in this way are stored in an intermediate {Escrow} contract, so
 there is no danger of them being spent before withdrawal.

```js
function _asyncTransfer(address dest, uint256 amount) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| dest | address | The destination address of the funds. | 
| amount | uint256 | The amount to transfer. | 

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
