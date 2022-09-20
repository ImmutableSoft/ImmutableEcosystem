// Copyright 2022 ImmutableSoft Inc.

pragma solidity >=0.7.6;

// SPDX-License-Identifier: GPL-3.0-or-later

// OpenZepellin upgradable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol";

/*
// OpenZepellin standard contracts
//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
*/

// ImmutableSoft DAO smart contracts
import "./StringCommon.sol";
import "./ImmutableEntity.sol";
import "./ImmutableProduct.sol";
import "./CreatorToken.sol";

/// @title Example call proxy for NFT collection - uses CreatorToken
/// @author Sean Lawless for ImmutableSoft Inc.
contract CollectionProxy is Initializable, OwnableUpgradeable,
                          IERC721MetadataUpgradeable,
                          IERC721EnumerableUpgradeable
/*
contract CollectionProxy is Ownable, IERC721Metadata, IERC721Enumerable
*/
{
  string private _name;
  string private _symbol;
  uint256 private _entity;
  uint256 private _product;

  // External contract interfaces (ImmutableSoft DAO)
  StringCommon private commonInterface;
  CreatorToken private creatorToken;

  /// @notice Initialize the CollectionProxy smart contract
  ///   Called during first deployment only
  /// @param commonAddr The StringCommon contract address
  /// @param creatorTokenAddr The Creator Token contract address
  /// @param entity The Immutable DAO entityID of collection
  /// @param product The Immutable DAO productID of collection
/*  constructor(address commonAddr, address creatorTokenAddr,
              uint256 entity, uint256 product)
     Ownable()*/
  function initialize(address commonAddr, address creatorTokenAddr,
      address entityAddr, address productAddr,
      string memory collectionName, string memory theSymbol,
      uint256 entity, uint256 product) public initializer
  {
    __Ownable_init();
    ImmutableEntity entityInterface = ImmutableEntity(entityAddr);

    // If not immutablesoft owner, check entity owner matches sender
    if (msg.sender != entityInterface.owner())
    {
      uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
      uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);

      // Ensure the proxy is deployed with entity address
      require(entity == entityIndex, "Not authorized");

      // Only a validated commercial entity can create an offer
      require(entityStatus > 0, commonInterface.EntityNotValidated());
      require((entityStatus & commonInterface.Nonprofit()) !=
              commonInterface.Nonprofit(), "Nonprofit prohibited");

      // Verify product and use product name as collection name
      string memory url;
      string memory logo;
      uint256 details;
      ImmutableProduct productInterface = ImmutableProduct(productAddr);
      (_name, url, logo, details) = productInterface.productDetails(entity, product);
      require(commonInterface.stringsEqual(_name, collectionName),
              "Product name does not match");
    }
    else
      _name = collectionName;


    // Finalize the smart contract data
    _symbol = theSymbol;
    _entity = entity;
    _product = product;
    commonInterface = StringCommon(commonAddr);
    creatorToken = CreatorToken(creatorTokenAddr);
  }

  /// @notice Retrieve the token name (ie. collection name)
  /// @return Return the token name as a string
  function name() public view
      returns (string memory)
  {
    return _name;
  }

  /// @notice Retrieve the token symbol
  /// @return Return the token symbol as a string
  function symbol() public view
      returns (string memory)
  {
    return _symbol;
  }

  /// @notice Return the type of supported ERC interfaces
  /// @param interfaceId The interface desired
  /// @return TRUE (1) if supported, FALSE (0) otherwise
  function supportsInterface(bytes4 interfaceId) public view
      returns (bool)
  {
    return creatorToken.supportsInterface(interfaceId);
  }

  /// @notice Look up the release URI from the token Id
  /// @param tokenId The unique token identifier
  /// @return the file name and/or URI secured by this token
  function tokenURI(uint256 tokenId) public view
      returns (string memory)
  {
    return creatorToken.tokenURI(tokenId);
  }

  /// @notice Approve and address for token Id transfer/burn
  /// @param to The address to approve (smart contract, etc.)
  /// @param to The tokenId to approve
  function approve(address to, uint256 tokenId) public
  {
    return creatorToken.approve(to, tokenId);
  }
  
  /// @notice Query approval address for token Id
  /// @param tokenId The token identifier
  /// @return operator The approved address of operator
  function getApproved(uint256 tokenId) public view
    returns (address operator)
  {
    return creatorToken.getApproved(tokenId);
  }

  /// @notice Query approval address for owner
  /// @param owner The address of token owner
  /// @param operator The address of operator to check
  /// @return The true if approved for all tokens
  function isApprovedForAll(address owner, address operator) public view
    returns (bool)
  {
    return creatorToken.isApprovedForAll(owner, operator);
  }

  /// @notice Query owner of token
  /// @param tokenId The token identifier to lookup owner of
  /// @return owner The address of the token owner
  function ownerOf(uint256 tokenId) public view
    returns (address owner)
  {
    return creatorToken.ownerOf(tokenId);
  }

  /// @notice Change approval rights for operator
  /// @param operator The address to token operator
  /// @param _approved True or false of new approval status
  function setApprovalForAll(address operator, bool _approved) public
  {
    return creatorToken.setApprovalForAll(operator, _approved);
  }

  /// @notice Safely transfer a token
  /// @param from The old token owner address
  /// @param to The new token owner address
  /// @param tokenId The token id to transfer
  function safeTransferFrom(address from, address to, uint256 tokenId)
    public
  {
    return creatorToken.safeTransferFrom(from, to, tokenId);
  }

  /// @notice Safely transfer a token with data
  /// @param from The old token owner address
  /// @param to The new token owner address
  /// @param tokenId The token id to transfer
  /// @param data Additional data
  function safeTransferFrom(address from, address to, uint256 tokenId,
                            bytes calldata data)
    public
  {
    return creatorToken.safeTransferFrom(from, to, tokenId, data);
  }

  /// @notice Transfer a token
  /// @param from The old token owner address
  /// @param to The new token owner address
  /// @param tokenId The token id to transfer
  function transferFrom(address from, address to, uint256 tokenId)
    public
  {
    return creatorToken.transferFrom(from, to, tokenId);
  }

  /// @notice Find and return the number of or tokenID of
  /// @param owner The (optional) owner of
  /// @param index The (optaionl) index of
  /// @return The token count or ID of the lookup
  function _tokenOf(address owner, uint256 index)
    internal view returns (uint256)
  {
    uint256 currentIndex = 0;
    uint256 i;
    uint256 max =(owner != address(0)) ?
                   creatorToken.balanceOf(owner) :
                   creatorToken.totalSupply();

    //Interate ownedTokens and count only this entity and product
    for (i = 0;i < max; ++i)
    {
      uint256 tokenId = (owner != address(0)) ?
                        creatorToken.tokenOfOwnerByIndex(owner, i) :
                        creatorToken.tokenByIndex(i);
                          
      uint256 entityIndex = ((tokenId &
                             commonInterface.EntityIdMask()) >>
                             commonInterface.EntityIdOffset());
      uint256 productIndex = ((tokenId &
                              commonInterface.ProductIdMask()) >>
                              commonInterface.ProductIdOffset());

      if ((entityIndex == _entity) && (productIndex == _product))
      {
        ++currentIndex;
        if ((index > 0) && (index == currentIndex))
          return tokenId;

      }
    }

    // If not a tokenId lookup then return the token count
    if (index == 0)
      return currentIndex;

    // Otherwise return tokenId zero (not found)
    else
      return 0;
  }

  /// @notice Return balance of owned tokens
  /// @dev Returns subset of ImmutableSoft DAO tokens that match
  ///      the entity and product this proxy was initialized for.
  /// @param owner The old token owner address
  /// @return balance The number of tokens owned
  function balanceOf(address owner) public view
    returns (uint256 balance)
  {
    return _tokenOf(owner, 0);
  }

  /// @notice Return tokenId of index owned by an address
  /// @dev Returns subset of ImmutableSoft DAO tokens that match
  ///      the entity and product this proxy was initialized for.
  /// @param owner The old token owner address
  /// @param index The old token index of this specific owner
  /// @return the tokenId of the specific token
  function tokenOfOwnerByIndex(address owner, uint256 index) public view 
    returns (uint256)
  {
    return _tokenOf(owner, index);
  }

  /// @notice Return the total supply of tokens
  /// @dev Returns subset of ImmutableSoft DAO tokens that match
  ///      the entity and product this proxy was initialized for.
  /// @return the number of tokens within this collection
  function totalSupply() public view
    returns (uint256)
  {
    return _tokenOf(address(0), 0);
  }

  /// @notice Return the tokenId by global index
  /// @dev Returns subset of ImmutableSoft DAO tokens that match
  ///      the entity and product this proxy was initialized for.
  /// @return the tokenId of specific index within this collection
  function tokenByIndex(uint256 index) public view 
    returns (uint256)
  {
    return _tokenOf(address(0), index);
  }
}
