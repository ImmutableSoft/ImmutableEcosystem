pragma solidity >=0.7.6;

// SPDX-License-Identifier: GPL-3.0-or-later

import "./StringCommon.sol";
import "./ImmutableEntity.sol";
import "./CreatorToken.sol";
import "./ProductActivate.sol";

// OpenZepellin upgradable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

/*
// OpenZepellin standard contracts
//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
*/

/*
  The ActivateToken unique token id is a conglomeration of the entity, product,
  expiration, identifier and license value. The licenseValue portion is 128 bits
  and is product specific, allowing millions of uniquely identifiable sub-products

    uint256 tokenId = entityIndex | (productIndex << 32) | (licenseExpiration << 64) |
                      (activationIdFlags << 96) | (licenseValue << 128);
*/

// OpenZepellin upgradable contracts
contract ActivateToken is Initializable, OwnableUpgradeable,
                          ERC721EnumerableUpgradeable,
                          ERC721BurnableUpgradeable
/*
contract ActivateToken is Ownable,
                          ERC721Enumerable,
                          ERC721Burnable
*/
{
  // Mapping to and from token id and activation id
  mapping (uint256 => uint256) private ActivateIdToTokenId;
  mapping (uint256 => uint256) private TokenIdToActivateId;

  // Mapping the number of activations (used for uniqueness)
  mapping (uint64 => uint64) private NumberOfActivations;

  // Mapping any Ricardian contract requirements
  mapping (uint256 => uint256) private TokenIdToRicardianParent;

  ProductActivate activateInterface;
  CreatorToken creatorInterface;
  ImmutableEntity entityInterface;
  StringCommon commonInterface;

  // OpenZepellin upgradable contracts
  function initialize(address commonContractAddr, address entityContractAddr)
    public initializer
  {
    __Ownable_init();
    __ERC721_init("Activate", "ACT");
    __ERC721Enumerable_init();
    __ERC721Burnable_init();
/*
  // OpenZepellin standard contracts
  constructor(address commonContractAddr, address entityContractAddr)
                                           Ownable()
                                           ERC721("Activate", "ACT")
                                           ERC721Enumerable()
  {
*/
    // Initialize the contract interfaces
    commonInterface = StringCommon(commonContractAddr);
    entityInterface = ImmutableEntity(entityContractAddr);
  }

  /// @notice Restrict the token to the activate contract
  ///   Called internally. msg.sender must contract owner
  /// @param activateAddress The ProductActivate contract address
  /// @param creatorAddress The Creator token contract address
  function restrictToken(address activateAddress, address creatorAddress)
    public onlyOwner
  {
    activateInterface = ProductActivate(activateAddress);  
    creatorInterface = CreatorToken(creatorAddress);
  }

  /// @notice Burn a product activation license.
  /// Not public, called internally. msg.sender must be the token owner.
  /// @param tokenId The tokenId to burn
  function burn(uint256 tokenId) public override(ERC721BurnableUpgradeable)
  {
    uint256 activationId = TokenIdToActivateId[tokenId];

    ActivateIdToTokenId[activationId] = 0;
    TokenIdToActivateId[tokenId] = 0;

    // If called from restricted address skip approval check
    if (msg.sender == address(activateInterface))
      super._burn(tokenId);

    // Otherwise ensure caller is approved for the token
    else
      super.burn(tokenId);
  }

  /// @notice Create a product activation license.
  /// Not public, called internally. msg.sender is the license owner.
  /// @param entityIndex The local entity index of the license
  /// @param productIndex The specific ID of the product
  /// @param licenseHash The external license activation hash
  /// @param licenseValue The activation value and flags (192 bits)
  /// @param ricardianParent The Ricardian contract parent (if required)
  /// @return tokenId The resulting new unique token identifier
  function mint(address sender, uint256 entityIndex, uint256 productIndex,
                uint256 licenseHash, uint256 licenseValue,
                uint256 ricardianParent)
    public returns (uint256)
  {
    uint256 activationId =
      ++NumberOfActivations[(uint64)(entityIndex | (productIndex << 32))];

    uint256 tokenId = ((entityIndex << commonInterface.EntityIdOffset()) & commonInterface.EntityIdMask()) |
                      ((productIndex << commonInterface.ProductIdOffset()) & commonInterface.ProductIdMask()) |
                      ((activationId << commonInterface.UniqueIdOffset()) & commonInterface.UniqueIdMask()) |
                      (licenseValue & (commonInterface.FlagsMask() | commonInterface.ExpirationMask() | commonInterface.ValueMask()));

    // If no expiration to the activation, use those bits for more randomness
    if ((licenseValue & commonInterface.ExpirationFlag() == 0) && (activationId > 0xFFFF))
      tokenId |= ((activationId >> 16) << commonInterface.ExpirationOffset()) & commonInterface.ExpirationMask();

    require(address(activateInterface) != address(0));
    require(msg.sender == address(activateInterface));

// Do NOT uncomment this, it can potentially infinite loop
//   But the idea is valid, leaving until a better solution
/*
    // If not unique, fudge the values until unique
    while (TokenIdToActivateId[tokenId] != 0)
    {
      // Bump up the activation id
      activationId =
        ++NumberOfActivations[entityIndex | (productIndex << 32)];

      tokenId = ((entityIndex << commonInterface.EntityIdOffset()) & commonInterface.EntityIdMask()) |
                ((productIndex << commonInterface.ProductIdOffset()) & commonInterface.ProductIdMask()) |
                ((activationId << commonInterface.UniqueIdOffset()) & commonInterface.UniqueIdMask()) |
                (licenseValue & (commonInterface.FlagsMask() | commonInterface.ExpirationMask() | commonInterface.ValueMask()));
*/
/*
      // If still not unique, decrease the expiration time slightly
      // Must decrease since zero is unlimited time
      if (TokenIdToActivateId[tokenId] != 0)
      {
        uint256 theDuration = ((licenseValue & ImmutableConstants.ExpirationMask) >> ImmutableConstants.ExpirationOffset);
        theDuration -= block.timestamp % 0xFF;

        // Update tokenId to include new expiration
        //  Clear the expiration
        licenseValue &= ~ImmutableConstants.ExpirationMask;
        licenseValue |= (theDuration << ImmutableConstants.ExpirationOffset) & ImmutableConstants.ExpirationMask;

        tokenId = ((entityIndex << ImmutableConstants.EntityIdOffset) & ImmutableConstants.EntityIdMask) |
                  ((productIndex << ImmutableConstants.ProductIdOffset) & ImmutableConstants.ProductIdMask) |
                  ((activationId << ImmutableConstants.UniqueIdOffset) & ImmutableConstants.UniqueIdMask) |
                  (licenseValue & (ImmutableConstants.FlagsMask | ImmutableConstants.ExpirationMask | ImmutableConstants.ValueMask));
      }
*/
//    }


    // Require a unique tokenId
    require(tokenId > 0, "TokenId zero");
    require(TokenIdToActivateId[tokenId] == 0, commonInterface.TokenNotUnique());
    require(ActivateIdToTokenId[licenseHash] == 0, commonInterface.TokenNotUnique());

    // Mint the new activate token
    _mint(sender, tokenId);

    // Assign mappings for id-to-hash and hash-to-id
    TokenIdToActivateId[tokenId] = licenseHash;
    if (licenseHash > 0)
      ActivateIdToTokenId[licenseHash] = tokenId;
    if (ricardianParent > 0)
      TokenIdToRicardianParent[tokenId] = ricardianParent;
    return tokenId;
  }

  ///////////////////////////////////////////////////////////
  /// PRODUCT ACTIVATE LICENSE
  ///////////////////////////////////////////////////////////

  /// @notice Change owner for all activate tokens (activations)
  /// Not public, called internally. msg.sender is the license owner.
  /// @param newOwner The new owner to receive transfer of tokens
  function activateOwner(address newOwner)
      external
  {
    // Retrieve the balance of activation tokens
    uint256 numActivations = balanceOf(msg.sender);

    // Safely transfer each token (index 0) to the new owner
    for (uint i = 0; i < numActivations; ++i)
    {
      // Always transfer token index zero, to ensure the same
      // order/index for the new address
      safeTransferFrom(msg.sender, newOwner, tokenOfOwnerByIndex(msg.sender, 0));
    }      
  }

  /// @notice Change activation identifier for an activate token
  ///   Caller must be the ProductActivate contract.
  /// @param tokenId The token identifier to move
  /// @param newHash The new activation hash/identifier
  /// @param oldHash The previous activation hash/identifier
  function activateTokenMoveHash(uint256 tokenId, uint256 newHash,
                                 uint256 oldHash)
    external
  {
    require(address(activateInterface) != address(0));
    require(msg.sender == address(activateInterface));

    // Clear old hash if present
    if (oldHash > 0)
      ActivateIdToTokenId[oldHash] = 0;

    // Clear token-to-activate lookup
    if (TokenIdToActivateId[tokenId] > 0)
      ActivateIdToTokenId[TokenIdToActivateId[tokenId]] = 0;

    // Update tokenId references and new activation on blockchain
    ActivateIdToTokenId[newHash] = tokenId;
    TokenIdToActivateId[tokenId] = newHash;
  }

  /// All activate functions below are view type (read only)

  /// @notice Find token identifier associated with activation hash
  /// @param licenseHash the external unique identifier
  /// @return the tokenId value
  function activateIdToTokenId(uint256 licenseHash)
    external view returns (uint256)
  {
    return ActivateIdToTokenId[licenseHash];
  }

  /// @notice Find activation hash associated with token identifier
  /// @param tokenId is the unique token identifier
  /// @return the license hash/unique activation identifier
  function tokenIdToActivateId(uint256 tokenId)
    external view returns (uint256)
  {
    return TokenIdToActivateId[tokenId];
  }
  
  /// @notice Find end user activation value and expiration for product
  /// Entity and product must be valid.
  /// @param entityIndex The entity the product license is for
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the external unique identifier to activate
  /// @return value (with flags) and price of the activation.\
  ///         **value** The activation value (flags, expiration, value)\
  ///         **price** The price in tokens if offered for resale
  function activateStatus(uint256 entityIndex, uint256 productIndex,
                          uint256 licenseHash)
    external view returns (uint256 value, uint256 price)
  {
    require(entityIndex > 0, commonInterface.EntityIsZero());
    uint256 tokenId = ActivateIdToTokenId[licenseHash];

    if (tokenId > 0)
    {
      require(entityIndex == (tokenId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset(),
              "EntityId does not match");
      require(productIndex == (tokenId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset(),
              "ProductId does not match");
    }

    // Return license flags, value. expiration and price
    return (
             (tokenId & (commonInterface.FlagsMask() |      //flags
                         commonInterface.ExpirationMask() | //expiration
                         commonInterface.ValueMask())),     //value
                         activateInterface.activateTokenIdToOfferPrice(tokenId) //price
           );
  }

  /// @notice Find all license activation details for an address
  /// @param entityAddress The address that owns the activations
  /// @return entities , products, hashes, values and prices as arrays.\
  ///         **entities** Array of entity ids of product\
  ///         **products** Array of product ids of product\
  ///         **hashes** Array of activation identifiers\
  ///         **values** Array of token values\
  ///         **prices** Array of price in tokens if for resale
  function activateAllDetailsForAddress(address entityAddress)
    public view returns (uint256[] memory entities, uint256[] memory products,
                         uint256[] memory hashes, uint256[] memory values,
                         uint256[] memory prices)
  {
    // Allocate result array based on the number of activate tokens
    //   Using tokenId for result length since no more stack space
    uint256 tokenId = balanceOf(entityAddress);
    uint256[] memory resultEntityId = new uint256[](tokenId);
    uint256[] memory resultProductId = new uint256[](tokenId);
    uint256[] memory resultHash = new uint256[](tokenId);
    uint256[] memory resultValue = new uint256[](tokenId);
    uint256[] memory resultPrice = new uint256[](tokenId);

    // Build result arrays for all activations of an Entity
    for (uint i = 0; i < balanceOf(entityAddress); ++i)
    {
      // Retrieve the token id of this index
      tokenId = tokenOfOwnerByIndex(entityAddress, i);

      // Return activate information from tokenId and mappings
      resultEntityId[i] = (tokenId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset(); // entityID
      resultProductId[i] = (tokenId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset(); //productID,
      resultValue[i] = tokenId & (commonInterface.FlagsMask() |      //flags
                                  commonInterface.ExpirationMask() | //expiration
                                  commonInterface.ValueMask());      //value
      resultHash[i] = TokenIdToActivateId[tokenId]; // activation hash
      resultPrice[i] = activateInterface.activateTokenIdToOfferPrice(tokenId); // offer price
    }

    return (resultEntityId, resultProductId, resultHash,
            resultValue, resultPrice);
  }

  /// @notice Find all license activation details for an entity
  /// Entity must be valid.
  /// @param entityIndex The entity to return activations for
  /// @return entities , products, hashes, values and prices as arrays.\
  ///         **entities** Array of entity ids of product\
  ///         **products** Array of product ids of product\
  ///         **hashes** Array of activation identifiers\
  ///         **values** Array of token values (flags, expiration)\
  ///         **prices** Array of price in tokens if for resale
  function activateAllDetails(uint256 entityIndex)
    external view returns (uint256[] memory entities, uint256[] memory products,
                           uint256[] memory hashes, uint256[] memory values,
                           uint256[] memory prices)
  {
    // Convert entityId to address and call details-for-address
    return activateAllDetailsForAddress(
                        entityInterface.entityIndexToAddress(entityIndex));
  }

  /// @notice Return all license activations for sale in the ecosystem
  /// When this exceeds available return size index will be added
  /// @return entities , products, hashes, values and prices as arrays.\
  ///         **entities** Array of entity ids of product\
  ///         **products** Array of product ids of product\
  ///         **hashes** Array of activation identifiers\
  ///         **values** Array of token values (flags, expiration)\
  ///         **prices** Array of price in tokens if for resale
  function activateAllForSaleTokenDetails()
    external view returns (uint256[] memory entities, uint256[] memory products,
                           uint256[] memory hashes, uint256[] memory values,
                           uint256[] memory prices)
  {
    // Allocate result array based on the number of activate tokens
    //   Using tokenId for result length since no more stack space
    uint256 tokenId;
    uint i = 0;
    uint j = 0;


    // First iterate and find how many are for sale
    for (i = 0; i < totalSupply(); ++i)
    {
      // Return the number of activations (number of activate tokens)
      tokenId = tokenByIndex(i);

      if (activateInterface.activateTokenIdToOfferPrice(tokenId) > 0)
        j++;
    }

    // Allocate resulting arrays based on size
    uint256[] memory resultEntityId = new uint256[](j);
    uint256[] memory resultProductId = new uint256[](j);
    uint256[] memory resultHash = new uint256[](j);
    uint256[] memory resultValue = new uint256[](j);
    uint256[] memory resultPrice = new uint256[](j);

    // Build result arrays for all activations of an Entity
    if (j > 0)
    {
      i = 0;
      for (j = 0; i < totalSupply(); ++i)
      {
        // Return the number of activations (number of activate tokens)
        tokenId = tokenByIndex(i);

        if (activateInterface.activateTokenIdToOfferPrice(tokenId) > 0)
        {
          // Return activate information from tokenId and mappings
          resultPrice[j] = activateInterface.activateTokenIdToOfferPrice(tokenId); // offer price
          resultEntityId[j] = (tokenId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset(); // entityID
          resultProductId[j] = (tokenId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset(); //productID,
          resultValue[j] = tokenId & (commonInterface.FlagsMask() |      //flags
                                      commonInterface.ExpirationMask() | //expiration
                                      commonInterface.ValueMask());      //value
          resultHash[j] = TokenIdToActivateId[tokenId]; // activation hash
          j++;
        }
      }
    }

    return (resultEntityId, resultProductId, resultHash,
            resultValue, resultPrice);
  }

  /// @notice Perform validity check before transfer of token allowed
  /// @param from The token origin address
  /// @param to The token destination address
  /// @param tokenId The token to transfer
  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
      internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
  {

    // Check flags/validity only after the first mint
    if (from != address(0))
    {
      // Only token owner may transfer without resale rights
      require((msg.sender == ownerOf(tokenId)) ||
              ((tokenId & commonInterface.NoResaleFlag()) == 0), "Not owner/resalable");

      // Check any required Ricardian contracts
      if ((msg.sender != ownerOf(tokenId)) &&
          (TokenIdToRicardianParent[tokenId] > 0) &&
          (address(creatorInterface) != address(0)))
      {
        uint hasChild = creatorInterface.creatorHasChildOf(to, TokenIdToRicardianParent[tokenId]);
        require(hasChild > 0, "Ricardian child agreement not found.");
      }
    }

    super._beforeTokenTransfer(from, to, tokenId);
  }

  /// @notice Return the type of supported ERC interfaces
  /// @param interfaceId The interface desired
  /// @return TRUE (1) if supported, FALSE (0) otherwise
  function supportsInterface(bytes4 interfaceId)
      public view virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
