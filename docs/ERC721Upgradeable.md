# ERC721Upgradeable.sol

View Source: [@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol](..\@openzeppelin\contracts-upgradeable\token\ERC721\ERC721Upgradeable.sol)

**↗ Extends: [Initializable](Initializable.md), [ContextUpgradeable](ContextUpgradeable.md), [ERC165Upgradeable](ERC165Upgradeable.md), [IERC721Upgradeable](IERC721Upgradeable.md), [IERC721MetadataUpgradeable](IERC721MetadataUpgradeable.md)**
**↘ Derived Contracts: [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md), [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md), [ERC721URIStorageUpgradeable](ERC721URIStorageUpgradeable.md)**

**ERC721Upgradeable**

Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 the Metadata extension, but not including the Enumerable extension, which is available separately as
 {ERC721Enumerable}.

## Contract Members
**Constants & Variables**

```js
string private _name;
string private _symbol;
mapping(uint256 => address) private _owners;
mapping(address => uint256) private _balances;
mapping(uint256 => address) private _tokenApprovals;
mapping(address => mapping(address => bool)) private _operatorApprovals;
uint256[44] private __gap;

```

## Functions

- [__ERC721_init(string name_, string symbol_)](#__erc721_init)
- [__ERC721_init_unchained(string name_, string symbol_)](#__erc721_init_unchained)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)
- [balanceOf(address owner)](#balanceof)
- [ownerOf(uint256 tokenId)](#ownerof)
- [name()](#name)
- [symbol()](#symbol)
- [tokenURI(uint256 tokenId)](#tokenuri)
- [_baseURI()](#_baseuri)
- [approve(address to, uint256 tokenId)](#approve)
- [getApproved(uint256 tokenId)](#getapproved)
- [setApprovalForAll(address operator, bool approved)](#setapprovalforall)
- [isApprovedForAll(address owner, address operator)](#isapprovedforall)
- [transferFrom(address from, address to, uint256 tokenId)](#transferfrom)
- [safeTransferFrom(address from, address to, uint256 tokenId)](#safetransferfrom)
- [safeTransferFrom(address from, address to, uint256 tokenId, bytes _data)](#safetransferfrom)
- [_safeTransfer(address from, address to, uint256 tokenId, bytes _data)](#_safetransfer)
- [_exists(uint256 tokenId)](#_exists)
- [_isApprovedOrOwner(address spender, uint256 tokenId)](#_isapprovedorowner)
- [_safeMint(address to, uint256 tokenId)](#_safemint)
- [_safeMint(address to, uint256 tokenId, bytes _data)](#_safemint)
- [_mint(address to, uint256 tokenId)](#_mint)
- [_burn(uint256 tokenId)](#_burn)
- [_transfer(address from, address to, uint256 tokenId)](#_transfer)
- [_approve(address to, uint256 tokenId)](#_approve)
- [_setApprovalForAll(address owner, address operator, bool approved)](#_setapprovalforall)
- [_checkOnERC721Received(address from, address to, uint256 tokenId, bytes _data)](#_checkonerc721received)
- [_beforeTokenTransfer(address from, address to, uint256 tokenId)](#_beforetokentransfer)
- [_afterTokenTransfer(address from, address to, uint256 tokenId)](#_aftertokentransfer)

### __ERC721_init

Initializes the contract by setting a `name` and a `symbol` to the token collection.

```js
function __ERC721_init(string name_, string symbol_) internal nonpayable onlyInitializing 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| name_ | string |  | 
| symbol_ | string |  | 

### __ERC721_init_unchained

```js
function __ERC721_init_unchained(string name_, string symbol_) internal nonpayable onlyInitializing 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| name_ | string |  | 
| symbol_ | string |  | 

### supportsInterface

See {IERC165-supportsInterface}.

```js
function supportsInterface(bytes4 interfaceId) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| interfaceId | bytes4 |  | 

### balanceOf

See {IERC721-balanceOf}.

```js
function balanceOf(address owner) public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address |  | 

### ownerOf

See {IERC721-ownerOf}.

```js
function ownerOf(uint256 tokenId) public view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 

### name

See {IERC721Metadata-name}.

```js
function name() public view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### symbol

See {IERC721Metadata-symbol}.

```js
function symbol() public view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### tokenURI

See {IERC721Metadata-tokenURI}.

```js
function tokenURI(uint256 tokenId) public view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 

### _baseURI

Base URI for computing {tokenURI}. If set, the resulting URI for each
 token will be the concatenation of the `baseURI` and the `tokenId`. Empty
 by default, can be overridden in child contracts.

```js
function _baseURI() internal view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### approve

See {IERC721-approve}.

```js
function approve(address to, uint256 tokenId) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address |  | 
| tokenId | uint256 |  | 

### getApproved

See {IERC721-getApproved}.

```js
function getApproved(uint256 tokenId) public view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 

### setApprovalForAll

See {IERC721-setApprovalForAll}.

```js
function setApprovalForAll(address operator, bool approved) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| operator | address |  | 
| approved | bool |  | 

### isApprovedForAll

See {IERC721-isApprovedForAll}.

```js
function isApprovedForAll(address owner, address operator) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address |  | 
| operator | address |  | 

### transferFrom

See {IERC721-transferFrom}.

```js
function transferFrom(address from, address to, uint256 tokenId) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 

### safeTransferFrom

See {IERC721-safeTransferFrom}.

```js
function safeTransferFrom(address from, address to, uint256 tokenId) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 

### safeTransferFrom

See {IERC721-safeTransferFrom}.

```js
function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 
| _data | bytes |  | 

### _safeTransfer

Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
 are aware of the ERC721 protocol to prevent tokens from being forever locked.
 `_data` is additional data, it has no specified format and it is sent in call to `to`.
 This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
 implement alternative mechanisms to perform token transfer, such as signature-based.
 Requirements:
 - `from` cannot be the zero address.
 - `to` cannot be the zero address.
 - `tokenId` token must exist and be owned by `from`.
 - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
 Emits a {Transfer} event.

```js
function _safeTransfer(address from, address to, uint256 tokenId, bytes _data) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 
| _data | bytes |  | 

### _exists

Returns whether `tokenId` exists.
 Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
 Tokens start existing when they are minted (`_mint`),
 and stop existing when they are burned (`_burn`).

```js
function _exists(uint256 tokenId) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 

### _isApprovedOrOwner

Returns whether `spender` is allowed to manage `tokenId`.
 Requirements:
 - `tokenId` must exist.

```js
function _isApprovedOrOwner(address spender, uint256 tokenId) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| spender | address |  | 
| tokenId | uint256 |  | 

### _safeMint

Safely mints `tokenId` and transfers it to `to`.
 Requirements:
 - `tokenId` must not exist.
 - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
 Emits a {Transfer} event.

```js
function _safeMint(address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address |  | 
| tokenId | uint256 |  | 

### _safeMint

Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
 forwarded in {IERC721Receiver-onERC721Received} to contract recipients.

```js
function _safeMint(address to, uint256 tokenId, bytes _data) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address |  | 
| tokenId | uint256 |  | 
| _data | bytes |  | 

### _mint

Mints `tokenId` and transfers it to `to`.
 WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
 Requirements:
 - `tokenId` must not exist.
 - `to` cannot be the zero address.
 Emits a {Transfer} event.

```js
function _mint(address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address |  | 
| tokenId | uint256 |  | 

### _burn

Destroys `tokenId`.
 The approval is cleared when the token is burned.
 Requirements:
 - `tokenId` must exist.
 Emits a {Transfer} event.

```js
function _burn(uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 

### _transfer

Transfers `tokenId` from `from` to `to`.
  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
 Requirements:
 - `to` cannot be the zero address.
 - `tokenId` token must be owned by `from`.
 Emits a {Transfer} event.

```js
function _transfer(address from, address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 

### _approve

Approve `to` to operate on `tokenId`
 Emits a {Approval} event.

```js
function _approve(address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address |  | 
| tokenId | uint256 |  | 

### _setApprovalForAll

Approve `operator` to operate on all of `owner` tokens
 Emits a {ApprovalForAll} event.

```js
function _setApprovalForAll(address owner, address operator, bool approved) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address |  | 
| operator | address |  | 
| approved | bool |  | 

### _checkOnERC721Received

Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
 The call is not executed if the target address is not a contract.

```js
function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes _data) private nonpayable
returns(bool)
```

**Returns**

bool whether the call correctly returned the expected magic value

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address | address representing the previous owner of the given token ID | 
| to | address | target address that will receive the tokens | 
| tokenId | uint256 | uint256 ID of the token to be transferred | 
| _data | bytes | bytes optional data to send along with the call | 

### _beforeTokenTransfer

Hook that is called before any token transfer. This includes minting
 and burning.
 Calling conditions:
 - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
 transferred to `to`.
 - When `from` is zero, `tokenId` will be minted for `to`.
 - When `to` is zero, ``from``'s `tokenId` will be burned.
 - `from` and `to` are never both zero.
 To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

```js
function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 

### _afterTokenTransfer

Hook that is called after any transfer of tokens. This includes
 minting and burning.
 Calling conditions:
 - when `from` and `to` are both non-zero.
 - `from` and `to` are never both zero.
 To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

```js
function _afterTokenTransfer(address from, address to, uint256 tokenId) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 

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
