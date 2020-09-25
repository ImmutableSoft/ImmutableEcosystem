# PullPayment.sol

View Source: [@openzeppelin/contracts-ethereum-package/contracts/payment/PullPayment.sol](../@openzeppelin/contracts-ethereum-package/contracts/payment/PullPayment.sol)

**↗ Extends: [Initializable](Initializable.md)**
**↘ Derived Contracts: [ActivateToken](ActivateToken.md), [ImmutableEntity](ImmutableEntity.md)**

**PullPayment**

Simple implementation of a
https://consensys.github.io/smart-contract-best-practices/recommendations/#favor-pull-over-push-for-external-calls[pull-payment]
strategy, where the paying contract doesn't interact directly with the
receiver account, which must withdraw its payments itself.
 * Pull-payments are often considered the best practice when it comes to sending
Ether, security-wise. It prevents recipients from blocking execution, and
eliminates reentrancy concerns.
 * TIP: If you would like to learn more about reentrancy and alternative ways
to protect against it, check out our blog post
https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 * To use, derive from the `PullPayment` contract, and use {_asyncTransfer}
instead of Solidity's `transfer` function. Payees can query their due
payments with {payments}, and retrieve them with {withdrawPayments}.

## Contract Members
**Constants & Variables**

```js
contract Escrow private _escrow;
uint256[50] private ______gap;

```

## Functions

- [initialize()](#initialize)
- [withdrawPayments(address payable payee)](#withdrawpayments)
- [withdrawPaymentsWithGas(address payable payee)](#withdrawpaymentswithgas)
- [payments(address dest)](#payments)
- [_asyncTransfer(address dest, uint256 amount)](#_asynctransfer)

### initialize

⤿ Overridden Implementation(s): [ERC165.initialize](ERC165.md#initialize),[ERC721.initialize](ERC721.md#initialize),[ERC721Enumerable.initialize](ERC721Enumerable.md#initialize)

```js
function initialize() public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### withdrawPayments

Withdraw accumulated payments.
     * Note that _any_ account can call this function, not just the `payee`.
This means that contracts unaware of the `PullPayment` protocol can still
receive funds this way, by having a separate account call
{withdrawPayments}.
     * NOTE: This function has been deprecated, use {withdrawPaymentsWithGas}
instead. Calling contracts with fixed gas limits is an anti-pattern and
may break contract interactions in network upgrades (hardforks).
https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more.]
     *

```js
function withdrawPayments(address payable payee) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address payable | Whose payments will be withdrawn. | 

### withdrawPaymentsWithGas

Same as {withdrawPayments}, but forwarding all gas to the recipient.
     * WARNING: Forwarding all gas opens the door to reentrancy vulnerabilities.
Make sure you trust the recipient, or are either following the
checks-effects-interactions pattern or using {ReentrancyGuard}.
     * _Available since v2.4.0._

```js
function withdrawPaymentsWithGas(address payable payee) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| payee | address payable |  | 

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
     *

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
