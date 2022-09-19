# ERC721 token receiver interface (IERC721ReceiverUpgradeable.sol)

View Source: [@openzeppelin\contracts-upgradeable\token\ERC721\IERC721ReceiverUpgradeable.sol](..\@openzeppelin\contracts-upgradeable\token\ERC721\IERC721ReceiverUpgradeable.sol)

**IERC721ReceiverUpgradeable**

Interface for any contract that wants to support safeTransfers
 from ERC721 asset contracts.

## Functions

- [onERC721Received(address operator, address from, uint256 tokenId, bytes data)](#onerc721received)

### onERC721Received

Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
 by `operator` from `from`, this function is called.
 It must return its Solidity selector to confirm the token transfer.
 If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
 The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.

```js
function onERC721Received(address operator, address from, uint256 tokenId, bytes data) external nonpayable
returns(bytes4)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| operator | address |  | 
| from | address |  | 
| tokenId | uint256 |  | 
| data | bytes |  | 

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
* [StringCommon](StringCommon.md)
* [StringsUpgradeable](StringsUpgradeable.md)
