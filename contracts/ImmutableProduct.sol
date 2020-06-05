pragma solidity 0.5.16;

// Optimized ecosystem read interface returns arrays and
// requires experimental ABIEncoderV2
//   DO NOT release in production with compiler < 0.5.7
pragma experimental ABIEncoderV2;

import "./ImmutableEntity.sol";

/// Comments within /*  */ are for toggling upgradable contracts */

/// @title The Immutable Product - authentic product distribution
/// @author Sean Lawless for ImmutableSoft Inc.
/// @notice Token transfers use the ImmuteToken only
/// @dev Ecosystem is split in three, Entities, Releases and Licenses
contract ImmutableProduct is Initializable, Ownable, ImmutableConstants
{
  uint256 constant ReferralProductBonus = 4000000000000000000; //  4 IuT

  struct Product
  {
    string name;
    string infoURL;
    string logoURL;
    uint256 details; // category, flags/restrictions, languages
    uint256 numberOfReleases;
    mapping(uint256 => Release) releases;
  }

  struct Release
  {
    uint256 hash;
    string fileURI;
    uint256 version; // version, architecture, languages
    uint256 expireTime; // Escrow expiration
    uint256 escrow;
  }

  // Mapping between external entity id and array of products
  mapping (uint256 => Product[]) private Products;

  // Product interface events
  event productEvent(uint256 entityIndex, uint256 productIndex,
                     string name, string url, uint256 details);
  event productReleaseEvent(uint256 entityIndex,
                            uint256 productIndex, uint256 version);
  event productReleaseChallengeEvent(address indexed challenger,
          uint256 entityIndex, uint256 productIndex, uint256 releaseIndex,
          uint256 newHash);
  event productReleaseChallengeAwardEvent(address indexed challenger,
           uint256 entityIndex, uint256 productIndex, uint256 releaseIndex,
           uint256 newHash);

  // External contract interfaces
  ImmutableEntity private entityInterface;
  ImmuteToken private tokenInterface;
  StringCommon private commonInterface;

  // Product release escrow amount
  //   Default is 1 IuT token
  uint256 private escrowAmount;

  ///////////////////////////////////////////////////////////
  /// PRODUCT RELEASE
  ///////////////////////////////////////////////////////////

  /// @notice Product contract initializer/constructor.
  /// Executed on contract creation only.
  /// @param entityAddr the address of the ImmutableEntity contract
  /// @param tokenAddr the address of the ImmuteToken contract
  /// @param commonAddr the address of the StringCommon contract
/*
  constructor(address entityAddr, address tokenAddr,
              address commonAddr)
    public
  {
*/
  function initialize(address entityAddr, address tokenAddr,
                      address commonAddr) public initializer
  {
    Ownable.initialize(msg.sender);

    entityInterface = ImmutableEntity(entityAddr);
    tokenInterface = ImmuteToken(tokenAddr);
    commonInterface = StringCommon(commonAddr);
    escrowAmount = 1000000000000000000; // 1 IuT token escrow amount
  }

  /// @notice Create a new product for an entity.
  /// Entity must exist and be validated by Immutable.
  /// @param productName The name of the new product
  /// @param productURL The primary URL of the product
  /// @param logoURL The logo URL of the product
  /// @param productDetails the product category, languages, etc.
  function productCreate(string calldata productName,
                         string calldata productURL,
                         string calldata logoURL,
                         uint256 productDetails)
    external returns (uint256)
  {
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    uint256 productID;
    address referralAddress;
    uint256 creationTime;

    // Only a validated entity can create a product
    require(entityInterface.entityAddressStatus(msg.sender) > 0, "Entity is not validated");
    require(bytes(productName).length != 0, "Product name parameter invalid");
    require(bytes(productURL).length != 0, "Product URL parameter invalid");

    // If product exists with same name modify existing
    for (productID = 0; productID < Products[entityIndex].length;
         ++productID)
    {
      // Check if the product name matches an existing product
      if (commonInterface.stringsEqual(Products[entityIndex][productID].name, productName))
      {
        // Revert the transaction as product already exists
        revert("Product name already exists");
      }
    }

    Products[entityIndex].push(Product(productName, productURL, logoURL,
                               productDetails, 0));

    (referralAddress, creationTime) = entityInterface.entityReferralByIndex(
                                                      entityIndex + 1);

    // If referral is valid (within 30 days), mint out the 10% bonus
    if ((referralAddress != address(0)) && (creationTime < now + 30 days))
    {
      // Mint bonus tokens for the referral
      tokenInterface.mint(referralAddress, ReferralProductBonus);
    }

    // Emit an new product event and return the product index
    emit productEvent(entityIndex + 1, productID, productName,
                      productURL, productDetails);
    return productID;
  }

  /// @notice Edit an existing product of an entity.
  /// Entity must exist and be validated by Immutable.
  /// @param productName The name of the new product
  /// @param productURL The primary URL of the product
  /// @param logoURL The logo URL of the product
  /// @param productDetails the product category, languages, etc.
  function productEdit(uint256 productIndex,
                       string calldata productName,
                       string calldata productURL,
                       string calldata logoURL,
                       uint256 productDetails)
    external
  {
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    uint256 productID;

    // Only a validated entity can create a product
    require(entityInterface.entityAddressStatus(msg.sender) > 0, "Entity is not validated");
    require((bytes(productName).length == 0) || (bytes(productURL).length != 0), "Product URL parameter required");
    require(Products[entityIndex].length > productIndex, "Product not found");

    // Update the product information
    if (bytes(productName).length > 0)
    {
      // If product exists with same name then fatal error so revert
      for (productID = 0; productID < Products[entityIndex].length;
           ++productID)
      {
        if (productIndex != productID)
        {
          // Check if the product name matches an existing product
          if (commonInterface.stringsEqual(Products[entityIndex][productID].name, productName))
          {
            // Revert the transaction as product already exists
            revert("Product name already exists");
          }
        }
      }

      // Update the product information
      Products[entityIndex][productIndex].name = productName;
      Products[entityIndex][productIndex].infoURL = productURL;
      Products[entityIndex][productIndex].logoURL = logoURL;
      Products[entityIndex][productIndex].details = productDetails;
    }

    // Else if name is empty then a delete, so clear entire product 
    else
    {
      delete Products[entityIndex][productIndex];

      // If this is the last product then decrease size of array
      if ((Products[entityIndex].length - 1 == productIndex) &&
          (Products[entityIndex][Products[entityIndex].length - 1].numberOfReleases == 0))
      {
        Products[entityIndex].length--;

        // Remove all stranded empty products before this one
        while ((Products[entityIndex].length > 0) &&
               (bytes(Products[entityIndex]
                              [Products[entityIndex].length - 1].name).length == 0) &&
                (Products[entityIndex]
                         [Products[entityIndex].length - 1].numberOfReleases == 0))
        {
          delete Products[entityIndex][Products[entityIndex].length - 1];
          Products[entityIndex].length--;
        }
      }
    }

    // Emit an new product event and return the product index
    emit productEvent(entityIndex + 1, productIndex, productName,
                      productURL, productDetails);
    return;
  }

  /// @notice Create a new release of an existing product.
  /// Entity and Product must exist.
  /// @param productIndex The product ID of the new release
  /// @param newVersion The new product version, architecture and languages
  /// @param newHash The new release binary SHA256 CRC hash
  /// @param newFileUri The valid URI of the release binary
  /// @param escrow The amount of tokens to put into the release escrow
  function productRelease(uint256 productIndex, uint256 newVersion,
                          uint256 newHash, string calldata newFileUri,
                          uint256 escrow)
    external
  {
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);

    // Only a validated entity can create a release
    require(entityStatus > 0, "Entity is not validated");

    require(newHash != 0, "Hash parameter is zero");
    require(bytes(newFileUri).length != 0, "URI cannot be empty");
    require(Products[entityIndex].length > productIndex, "Product not found");
    require((escrow >= escrowAmount) ||
            ((entityStatus & Nonprofit) == Nonprofit), "Escrow required");

    // If nonprofit then gift the escrow amount
    if ((entityStatus & Nonprofit) == Nonprofit)
    {
      escrow = escrowAmount;
      tokenInterface.mint(address(this), escrow);
    }

    // Otherwise transfer tokens to escrow amount or revert
    else if (tokenInterface.transferFrom(msg.sender, address(this),
             escrow) == false)
      revert("Transfer failed");

    Products[entityIndex][productIndex].
        releases[Products[entityIndex][productIndex].numberOfReleases++] =
        Release(newHash, newFileUri, newVersion, now + 365 days, escrow);
    emit productReleaseEvent(entityIndex + 1, productIndex, newVersion);
  }

  /// @notice Challenge an existing product product release.
  /// Entity, Product and Release must exist, hash must differ.
  /// @param entityIndex The index of the entity to challenge
  /// @param productIndex The product ID of the new release
  /// @param releaseIndex The index of the product release
  /// @param newHash The different release binary SHA256 CRC hash
  function productReleaseChallenge(uint256 entityIndex,
           uint256 productIndex, uint256 releaseIndex, uint256 newHash)
    external
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    require(Products[entityIndex].length > productIndex, "Product not found");
    require(Products[entityIndex][productIndex].numberOfReleases > releaseIndex,
            "Release not found");
    require(newHash != Products[entityIndex][productIndex].releases[releaseIndex].hash,
            "Challenge hash must differ");

    // Emit a product release challenge event
    emit productReleaseChallengeEvent(msg.sender, entityIndex + 1,
                                  productIndex, releaseIndex, newHash);
  }

  /// @notice Withdraw expired product release escrows.
  /// Withdraws all expired product release escrows amounts.
  function productTokensWithdraw()
    external
  {
    // Only a validated entity can withdraw
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    require(entityStatus > 0, EntityNotValidated);
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    uint256 releaseEscrowAmount = 0;

    // Search all product releases for expired releases.
    for (uint256 id = 0; id < Products[entityIndex].length; ++id)
    {
      for (uint256 rel = 0; rel < Products[entityIndex][id].numberOfReleases;
           ++rel)
      {
        // If time is expired and an escrow amount is present
        if ((Products[entityIndex][id].releases[rel].expireTime <= now) &&
            (Products[entityIndex][id].releases[rel].escrow > 0))
        {
          // Get escrow amount
          // Increase escrow amount before zeroing escrow value
          releaseEscrowAmount += Products[entityIndex][id].releases[rel].escrow;
          Products[entityIndex][id].releases[rel].escrow = 0;
        }
      }
    }

    // If any escrow available, withdraw (transfer) tokens
    if (releaseEscrowAmount > 0)
    {
      // Transfer tokens to the sender and revert if failure
      if (tokenInterface.transfer(msg.sender, releaseEscrowAmount) == false)
        revert("Transfer to entity failed");
    }
  }

  /// @notice Administrator (onlyOwner) reward previous user challenge.
  /// Product release must exist with an escrow and different hash.
  /// @param challengerAddress Ethereum address of challenge sender
  /// @param entityIndex Index of entity responsible for product
  /// @param productIndex The index of the entity product
  /// @param releaseIndex The index of the specific product release
  /// @param newHash The new SHA256 checksum hash of the release URI
  function productChallengeReward(address challengerAddress,
                         uint256 entityIndex, uint256 productIndex,
                         uint256 releaseIndex, uint256 newHash)
    external onlyOwner
  {
    uint256 amount;

    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    // Ensure entity, product and release are valid
    require(Products[entityIndex].length > productIndex, "Product not found");
    require(Products[entityIndex][productIndex].numberOfReleases > releaseIndex,
            "Release not found");

    // The new hash of a challenge must be different
    require(Products[entityIndex][productIndex].releases[releaseIndex].hash !=
            newHash, "Challenge hash must differ");

    // Ensure an escrow amount exists
    require(Products[entityIndex][productIndex].releases[releaseIndex].escrow > 0,
            "Challenged release has no escrow");

    // Get escrow amount before halving escrow value
    amount = Products[entityIndex][productIndex].releases[releaseIndex].escrow;

    uint256 challengeReward = amount / 2;

    // Otherwise transfer half of escrow to challenger
    if (tokenInterface.transfer(challengerAddress, challengeReward) == false)
      revert("Transfer failed");

    // Remove half the escrow after successfull challenge and emit event
    Products[entityIndex][productIndex].releases[releaseIndex].escrow =
                                                       challengeReward;
    emit productReleaseChallengeAwardEvent(challengerAddress,
                 entityIndex + 1, productIndex, releaseIndex, newHash);
  }

  /// All product release functions below are view type (read only)

  /// @notice Check balance of escrowed product releases.
  /// Counts all expired/available product release escrows amounts.
  function productTokenEscrow()
    external view returns (uint256)
  {
    // Only a validated entity can withdraw
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    require(entityStatus > 0, EntityNotValidated);
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    uint256 releaseEscrowAmount = 0;

    // Search all product releases and offers for expired releases.
    for (uint256 id = 0; id < Products[entityIndex].length; ++id)
    {
      for (uint256 rel = 0; rel < Products[entityIndex][id].numberOfReleases;
           ++rel)
      {
        // If time is expired and an escrow amount is present
        if ((Products[entityIndex][id].releases[rel].expireTime <= now) &&
            (Products[entityIndex][id].releases[rel].escrow > 0))
        {
          // Add the product release escrow to the total
          releaseEscrowAmount += Products[entityIndex][id].releases[rel].escrow;
        }
      }
    }

    // Return total count of escrowed tokens available for withdrawl
    return releaseEscrowAmount;
  }

  /// @notice Return version, URI and hash of existing product release.
  /// Entity, Product and Release must exist.
  /// @param entityIndex The index of the entity owner of product
  /// @param productIndex The product ID of the new release
  /// @param releaseIndex The index of the product release
  /// @return the version, architecture and language(s)
  /// @return the URI to the product release file
  /// @return the SHA256 checksum hash of the file
  function productReleaseDetails(uint256 entityIndex,
                            uint256 productIndex, uint256 releaseIndex)
    external view returns (uint256, string memory, uint256)
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    require(Products[entityIndex].length > productIndex, "Product not found");
    require(Products[entityIndex][productIndex].numberOfReleases > releaseIndex,
            "Release not found");

    // Return the version, URI and hash for this product
    return (Products[entityIndex][productIndex].releases[releaseIndex].version,
            Products[entityIndex][productIndex].releases[releaseIndex].fileURI,
            Products[entityIndex][productIndex].releases[releaseIndex].hash);
  }

  /// @notice Retrieve details for all product releases
  /// Status of empty arrays if none found.
  /// @param entityIndex The index of the entity owner of product
  /// @param productIndex The product ID of the new release
  /// @return array of version, architecture and language(s)
  /// @return array of URI to the product release file
  /// @return array of SHA256 checksum hash of the file
  function productAllReleaseDetails(uint256 entityIndex, uint256 productIndex)
    external view returns (uint256[] memory, string[] memory,
                           uint256[] memory)
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    require(Products[entityIndex].length > productIndex, "Product not found");

    uint256[] memory resultVersion = new uint256[](Products[entityIndex][productIndex].numberOfReleases);
    string[] memory resultURI = new string[](Products[entityIndex][productIndex].numberOfReleases);
    uint256[] memory resultHash = new uint256[](Products[entityIndex][productIndex].numberOfReleases);

    // Build result arrays for all release information of a product
    for (uint i = 0; i < Products[entityIndex][productIndex].numberOfReleases; ++i)
    {
      resultVersion[i] = Products[entityIndex][productIndex].releases[i].version;
      resultURI[i] = Products[entityIndex][productIndex].releases[i].fileURI;
      resultHash[i] = Products[entityIndex][productIndex].releases[i].hash;
    }

    return (resultVersion, resultURI, resultHash);
  }

  /// @notice Return the number of products maintained by an entity.
  /// Entity must exist.
  /// @param entityIndex The index of the entity
  /// @return the current number of products for the entity
  function productNumberOf(uint256 entityIndex)
    external view returns (uint256)
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    // Return the number of products for this entity
    if (Products[entityIndex].length > 0)
      return Products[entityIndex].length;
    else
      return 0;
  }

  /// @notice Return the number of product releases of a product.
  /// Entity and product must exist.
  /// @param entityIndex The glabal entity index
  /// @param productIndex The index of the product
  /// @return the current number of releases for the product
  function productNumberOfReleases(uint256 entityIndex,
                                   uint256 productIndex)
    external view returns (uint256)
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    require(Products[entityIndex].length > productIndex,
            "Product not found");

    // Return the number of products for this entity
    return Products[entityIndex][productIndex].numberOfReleases;
  }

  /// @notice Retrieve existing product name, info and details.
  /// Entity and product must exist.
  /// @param entityIndex The index of the entity
  /// @param productIndex The specific ID of the product
  /// @return the name of the product
  /// @return the primary URL for information about the product
  /// @return the URL for the product logo
  /// @return details (category, language(s)) of the product
  function productDetails(uint256 entityIndex, uint256 productIndex)
    external view returns (string memory, string memory, string memory,
                           uint256)
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    string memory name;
    string memory infoURL;
    string memory logoURL;

    require(Products[entityIndex].length > productIndex, "Product not found");

    // Return the hash for this organizations product and version
    infoURL = Products[entityIndex][productIndex].infoURL;
    logoURL = Products[entityIndex][productIndex].logoURL;
    name = Products[entityIndex][productIndex].name;
    return (name, infoURL, logoURL,
            Products[entityIndex][productIndex].details);
  }

  /// @notice Retrieve details for all products
  /// Status of empty arrays if none found.
  /// @return array of name, infoURL, logoURL and status details
  function productAllDetails(uint256 entityIndex)
    external view returns (string[] memory, string[] memory,
                           string[] memory, uint256[] memory)
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    string[] memory resultName = new string[](Products[entityIndex].length);
    string[] memory resultInfoURL = new string[](Products[entityIndex].length);
    string[] memory resultLogoURL = new string[](Products[entityIndex].length);
    uint256[] memory resultDetails = new uint256[](Products[entityIndex].length);

    // Build result arrays for all product information of an Entity
    for (uint i = 0; i < Products[entityIndex].length; ++i)
    {
      resultName[i] = Products[entityIndex][i].name;
      resultInfoURL[i] = Products[entityIndex][i].infoURL;
      resultLogoURL[i] = Products[entityIndex][i].logoURL;
      resultDetails[i] = Products[entityIndex][i].details;
    }

    return (resultName, resultInfoURL, resultLogoURL, resultDetails);
  }


}
