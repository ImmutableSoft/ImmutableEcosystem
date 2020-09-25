# ERC721 token receiver interface (IERC721Receiver.sol)

View Source: [@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721Receiver.sol](../@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721Receiver.sol)

**IERC721Receiver**

Interface for any contract that wants to support safeTransfers
from ERC721 asset contracts.

## Functions

- [onERC721Received(address operator, address from, uint256 tokenId, bytes data)](#onerc721received)

### onERC721Received

Handle the receipt of an NFT

```js
function onERC721Received(address operator, address from, uint256 tokenId, bytes data) public nonpayable
returns(bytes4)
```

**Returns**

bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| operator | address | The address which called `safeTransferFrom` function | 
| from | address | The address which previously owned the token | 
| tokenId | uint256 | The NFT identifier which is being transferred | 
| data | bytes | Additional data with no specified format | 

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
