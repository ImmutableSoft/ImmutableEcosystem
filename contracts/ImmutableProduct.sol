pragma solidity 0.5.16;

import "./ImmutableEntity.sol";

/// Comments within /*  */ are for toggling upgradable contracts */

/// @title The Immutable Product - authentic product distribution
/// @author Sean Lawless for ImmutableSoft Inc.
/// @notice Token transfers use the ImmuteToken only
/// @dev Ecosystem is split in three, Entities, Releases and Licenses
contract ImmutableProduct is /*Initializable,*/ Ownable, ImmutableConstants
{
  uint256 constant ReferralProductBonus = 4000000000000000000; //  4 IuT

  struct Product
  {
    string name;
    string infoURL;
    string logoURL;
    uint256 details; // category, flags/restrictions, languages
    uint256 numberOfReleases;
    mapping(uint => Release) releases;
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
  constructor(address entityAddr, address tokenAddr,
              address commonAddr)
    public //ImmutableBase(immuteToken, commonAddr, ensAddr)
  {
/*
    Ownable.initialize(msg.sender);
    PullPayment.initialize();
*/
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
    external returns (uint)
  {
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    uint256 productID;

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
        // Update the product information
        Products[entityIndex][productID].name = productName;
        Products[entityIndex][productID].infoURL = productURL;
        Products[entityIndex][productID].logoURL = logoURL;
        Products[entityIndex][productID].details = productDetails;
        break;
      }
    }

    // If not an update to existing product, create a new product
    if (productID >= Products[entityIndex].length)
    {
      Products[entityIndex].push(Product(productName, productURL, logoURL,
                                 productDetails, 0));

      address referralAddress;
      uint256 creationTime;
      (referralAddress, creationTime) = entityInterface.entityReferralByIndex(
                                                      entityIndex + 1);

      // If referral is valid (within 30 days), mint out the 10% bonus
      if ((referralAddress != address(0)) && (creationTime < now + 30 days))
      {
        // Mint bonus tokens for the referral
        tokenInterface.mint(referralAddress, ReferralProductBonus);
      }
    }

    // Emit an new product event and return the product index
    emit productEvent(entityIndex + 1, productID, productName,
                      productURL, productDetails);
    return productID;
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
    require(entityStatus > 0, "Entity not validated");
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    uint256 releaseEscrowAmount = 0;

    // Search all product releases for expired releases.
    for (uint id = 0; id < Products[entityIndex].length; ++id)
    {
      for (uint rel = 0; rel < Products[entityIndex][id].numberOfReleases;
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
      uint256 splitEscrowAmount = releaseEscrowAmount / 2;

      // Transfer half of tokens to the sender and revert if failure
      if (tokenInterface.transfer(msg.sender, splitEscrowAmount) == false)
        revert("Transfer to entity failed");

      // Transfer remaining half of tokens to Immutable and revert if failure
      if (tokenInterface.transfer(owner(), splitEscrowAmount) == false)
          revert("Transfer to owner failed");
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
    require(entityStatus > 0, "Entity not validated");
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    uint256 releaseEscrowAmount = 0;

    // Search all product releases and offers for expired releases.
    for (uint id = 0; id < Products[entityIndex].length; ++id)
    {
      for (uint rel = 0; rel < Products[entityIndex][id].numberOfReleases;
           ++rel)
      {
        // If time is expired and an escrow amount is present
        if ((Products[entityIndex][id].releases[rel].expireTime <= now) &&
            (Products[entityIndex][id].releases[rel].escrow > 0))
        {
          // Entity shares half the product release escrows
          releaseEscrowAmount += Products[entityIndex][id].releases[rel].escrow / 2;
        }
      }
    }

    // Return total count of escrowed tokens available for withdrawl
    return releaseEscrowAmount;
  }

  /// @notice Return version, URI and hash of existing product release.
  /// Entity, Product and Release must exist.
  /// @param entityIndex The index of the entity to challenge
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

  /// @notice Return the number of products maintained by an entity.
  /// Entity must exist.
  /// @param entityIndex The index of the entity
  /// @return the current number of products for the entity
  function productNumberOf(uint256 entityIndex)
    external view returns (uint)
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
    external view returns (uint)
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

}
