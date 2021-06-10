pragma solidity ^0.8.4;

// SPDX-License-Identifier: GPL-3.0-or-later

import "./ImmutableEntity.sol";

// OpenZepellin upgradable contracts
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

/// @title The Immutable Product - authentic product distribution
/// @author Sean Lawless for ImmutableSoft Inc.
/// @notice Token transfers use the ImmuteToken only
/// @dev Ecosystem is split in three, Entities, Releases and Licenses
contract ImmutableProduct is Initializable, OwnableUpgradeable, ImmutableConstants
{
  struct Product
  {
    string name;
    string infoURL;
    string logoURL;
    uint256 details; // category, flags/restrictions, languages
    uint256 numberOfReleases;
    uint256 numberOfOffers;
    mapping(uint256 => Release) releases;
    mapping(uint256 => Offer) offers;
  }

  // Product activation offer
  struct Offer
  {
    address tokenAddr; // ERC20 token address of offer. Zero (0) is ETH
    uint256 price; // the offer price in tokens/ETH
    uint256 value; // duration, flags/resellability and
                   // product feature (languages, version, game item, etc.)
    string  infoURL;// Offer information details
  }

  struct Release
  {
    uint256 hash;
    string fileURI;
    uint256 version; // version, architecture, languages
  }

  // Mapping between external entity id and array of products
  mapping (uint256 => mapping (uint256 => Product)) private Products;
  mapping (uint256 => uint256) private NumberOfProducts;
  mapping (uint256 => uint256) private HashToRelease;

  // Product interface events
  event productEvent(uint256 entityIndex, uint256 productIndex,
                     string name, string infoUrl, uint256 details);
  event productReleaseEvent(uint256 entityIndex,
                            uint256 productIndex, uint256 version);

  event productOfferEvent(uint256 entityIndex, uint256 productIndex,
                          string productName, address erc20token,
                          uint256 price, uint256 value, string infoUrl);

  // External contract interfaces
  ImmutableEntity private entityInterface;
  StringCommon private commonInterface;

  ///////////////////////////////////////////////////////////
  /// PRODUCT RELEASE
  ///////////////////////////////////////////////////////////

  /// @notice Product contract initializer/constructor.
  /// Executed on contract creation only.
  /// @param entityAddr the address of the ImmutableEntity contract
  /// @param commonAddr the address of the StringCommon contract
  function initialize(address entityAddr,
                      address commonAddr) public initializer
  {
    __Ownable_init();

    entityInterface = ImmutableEntity(entityAddr);
    commonInterface = StringCommon(commonAddr);
  }

  /// @notice Create a new product for an entity.
  /// Entity must exist and be validated by Immutable.
  /// @param productName The name of the new product
  /// @param productURL The primary URL of the product
  /// @param logoURL The logo URL of the product
  /// @param details the product category, languages, etc.
  function productCreate(string calldata productName,
                         string calldata productURL,
                         string calldata logoURL,
                         uint256 details)
    external returns (uint256)
  {
    uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);
    uint256 productID;
    uint256 lastProduct = NumberOfProducts[entityIndex];

    // Only a validated entity can create a product
    require(entityInterface.entityAddressStatus(msg.sender) > 0,
            "Entity is not validated");
    require(bytes(productName).length != 0, "Product name parameter invalid");
    require(bytes(productURL).length != 0, "Product URL parameter invalid");

    // If product exists with same name modify existing
    for (productID = 0; productID < NumberOfProducts[entityIndex];
         ++productID)
    {
      // Check if the product name matches an existing product
      if (commonInterface.stringsEqual(Products[entityIndex][productID].name,
                                       productName))
      {
        // Revert the transaction as product already exists
        revert("Product name already exists");
      }
    }

    // Populate information for new product and increment index
    Products[entityIndex][lastProduct].name = productName;
    Products[entityIndex][lastProduct].infoURL = productURL;
    Products[entityIndex][lastProduct].logoURL = logoURL;
    Products[entityIndex][lastProduct].numberOfReleases = 0;
    Products[entityIndex][lastProduct].numberOfOffers = 0;
    NumberOfProducts[entityIndex]++;

    // Emit an new product event and return the product index
    emit productEvent(entityIndex, productID, productName,
                      productURL, details);
    return lastProduct;
  }

  /// @notice Offer a software product license for sale.
  /// mes.sender must have a valid entity and product.
  /// @param productIndex The specific ID of the product
  /// @param erc20token Address of ERC 20 token offer
  /// @param price The token cost to purchase activation
  /// @param feature The product feature value/item (128 LSB only)
  ///              (128 MSB only) is duration, flags/resallability
  /// @param expiration activation expiration, (0) forever/unexpiring
  /// @param number of offers, (0) is unlimited 65535 is maximum
  /// @param infoUrl The official URL for more information about offer
  /// @param noResale Flag to disable resale capabilities for purchaser
  function productOfferFeature(uint256 productIndex, address erc20token,
                               uint256 price, uint256 feature,
                               uint256 expiration, uint256 number,
                               string calldata infoUrl, bool noResale)
    external
  {
    if (noResale)
      require(expiration > 0, "No expiration must allow resale per EU law");

    return productOffer(productIndex, erc20token, price,
                        (FeatureFlag | ExpirationFlag | (noResale ? NoResaleFlag : 0) |
                         ((expiration << ExpirationOffset) & ExpirationMask) |
                         ((number << UniqueIdOffset) & UniqueIdMask) |
                         ((feature << ValueOffset) & ValueMask)), infoUrl);
  }

  /// @notice Offer a software product license for sale.
  /// mes.sender must have a valid entity and product.
  /// @param productIndex The specific ID of the product
  /// @param erc20token Address of ERC 20 token offer
  /// @param price The token cost to purchase activation
  /// @param limitation The version and language limitations
  /// @param expiration activation expiration, (0) forever/unexpiring
  /// @param number of offers, (0) is unlimited 65535 is maximum
  /// @param infoUrl The official URL for more information about offer
  /// @param noResale Prevent the resale of any purchased activation
  function productOfferLimitation(uint256 productIndex, address erc20token,
                                  uint256 price, uint256 limitation,
                                  uint256 expiration, uint256 number,
                                  string calldata infoUrl, bool noResale)
    external
  {
    if (noResale)
      require(expiration > 0, "No expiration must allow resale per EU law");
    return productOffer(productIndex, erc20token, price,
                        (LimitationFlag | ExpirationFlag | (noResale ? NoResaleFlag : 0) |
                         ((expiration << ExpirationOffset) & ExpirationMask)  |
                         ((number << UniqueIdOffset) & UniqueIdMask) |
                         ((limitation << ValueOffset) & ValueMask)), infoUrl);
  }

  /// @notice Offer a software product license for sale.
  /// mes.sender must have a valid entity and product.
  /// @param productIndex The specific ID of the product
  /// @param erc20token Address of ERC 20 token offer
  /// @param price The token cost to purchase activation
  /// @param value The product activation value/item (128 LSB only)
  ///              (128 MSB only) is duration, flags/resallability
  ///              Zero (0) duration is forever/unexpiring
  /// @param infoUrl The official URL for more information about offer
  function productOffer(uint256 productIndex, address erc20token,
                        uint256 price, uint256 value,
                        string memory infoUrl)
    private
  {
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);
    uint256 offerId = 0;

    // Only a validated commercial entity can create an offer
    require(entityStatus > 0, EntityNotValidated);
    require((entityStatus & Nonprofit) != Nonprofit, "Nonprofit prohibited");

    // If token configured specified, do a quick validity check
    if (erc20token != address(0))
    {
      require((entityStatus & CustomToken) == CustomToken,
              "Token offers require custom status.");
      IERC20Upgradeable theToken = IERC20Upgradeable(erc20token);

      require(theToken.totalSupply() > 0,
              "Address is not ERC20 token or no supply");
    }

    require(NumberOfProducts[entityIndex] > productIndex,
            "Product not found");
    require(price >= 0, "Product offer price cannot be zero");

    // Check if any offer has been exhausted/revoked
    for (;offerId < Products[entityIndex][productIndex].numberOfOffers; ++offerId)
      if (Products[entityIndex][productIndex].offers[offerId].price == 0)
        break;

    // Reuse old offer if present
    if (offerId < Products[entityIndex][productIndex].numberOfOffers)
    {
      Products[entityIndex][productIndex].offers[offerId].tokenAddr = erc20token;
      Products[entityIndex][productIndex].offers[offerId].price = price;
      Products[entityIndex][productIndex].offers[offerId].value = value;
      Products[entityIndex][productIndex].offers[offerId].infoURL = infoUrl;
    }

    // Otherwise create a new offer
    else
      Products[entityIndex][productIndex].offers[Products[entityIndex][productIndex].numberOfOffers++] =
        Offer(erc20token, price, value, infoUrl);

    emit productOfferEvent(entityIndex, productIndex,
                           Products[entityIndex][productIndex].name,
                           erc20token, price, value, infoUrl);
  }

  /// @notice Change a software product license offer price
  /// mes.sender must have a valid entity and product
  /// @param productIndex The specific ID of the product
  /// @param offerIndex the index of the offer to change
  /// @param price The token cost to purchase activation
  function productOfferEditPrice(uint256 productIndex,
                                 uint256 offerIndex, uint256 price)
    public
  {
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);

    // Only a validated commercial entity can create an offer
    require(entityStatus > 0, EntityNotValidated);
    require((entityStatus & Nonprofit) != Nonprofit, "Nonprofit prohibited");
    require(NumberOfProducts[entityIndex] > productIndex,
            "Product not found");
    require(Products[entityIndex][productIndex].numberOfOffers > offerIndex,
            "Product offer out of range");

    // Update the offer price, zero revokes the offer
    Products[entityIndex][productIndex].offers[offerIndex].price = price;
    if (price == 0)
      Products[entityIndex][productIndex].offers[offerIndex].value = 0;

    // While the last offer and empty, remove index
    while ((Products[entityIndex][productIndex].numberOfOffers > 0) &&
           (offerIndex == Products[entityIndex][productIndex].numberOfOffers - 1) &&
           (Products[entityIndex][productIndex].offers[offerIndex].price == 0))
    {
      offerIndex--;
      Products[entityIndex][productIndex].numberOfOffers--;
    }
  }

  /// @notice Count a purchase of a product activation license.
  /// Entity, Product and Offer must exist.
  /// @param entityIndex The index of the entity with offer
  /// @param productIndex The product ID of the offer
  /// @param offerIndex The per-product offer ID
  function productOfferPurchased(uint256 entityIndex,
                                 uint256 productIndex,
                                 uint256 offerIndex)
    public
  {
    require(entityIndex > 0, EntityIsZero);

    require(NumberOfProducts[entityIndex] > productIndex,
            "Product not found");

    require(Products[entityIndex][productIndex].numberOfOffers > offerIndex,
            "Offer not found");

    uint256 value =
      Products[entityIndex][productIndex].offers[offerIndex].value;

    uint256 count = (value & UniqueIdMask) >> UniqueIdOffset;
    require(count > 0, "Offer count not set");

    value = value & ~(UniqueIdMask);
    value = value | (((count - 1) << UniqueIdOffset) & UniqueIdMask);

    // Update the offer value with the new lower count
    Products[entityIndex][productIndex].offers[offerIndex].value = value;

    // If no more offers available, remove this offer
    if (count - 1 == 0)
    {
      Products[entityIndex][productIndex].offers[offerIndex].value = 0;
      Products[entityIndex][productIndex].offers[offerIndex].price = 0;

      // While the last offer and empty, remove index
      while ((Products[entityIndex][productIndex].numberOfOffers > 0) &&
             (offerIndex == Products[entityIndex][productIndex].numberOfOffers - 1) &&
             (Products[entityIndex][productIndex].offers[offerIndex].price == 0))
      {
        offerIndex--;
        Products[entityIndex][productIndex].numberOfOffers--;
      }
    }
  }

  /// @notice Edit an existing product of an entity.
  /// Entity must exist and be validated by Immutable.
  /// @param productName The name of the new product
  /// @param productURL The primary URL of the product
  /// @param logoURL The logo URL of the product
  /// @param details the product category, languages, etc.
  function productEdit(uint256 productIndex,
                       string calldata productName,
                       string calldata productURL,
                       string calldata logoURL,
                       uint256 details)
    external
  {
    uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);
    uint256 productID;

    // Only a validated entity can create a product
    require(entityInterface.entityAddressStatus(msg.sender) > 0, "Entity is not validated");
    require((bytes(productName).length == 0) || (bytes(productURL).length != 0), "Product URL parameter required");
    require(NumberOfProducts[entityIndex] > productIndex, "Product not found");

    // Update the product information
    if (bytes(productName).length > 0)
    {
      // If product exists with same name then fatal error so revert
      for (productID = 0; productID < NumberOfProducts[entityIndex];
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
      Products[entityIndex][productIndex].details = details;
    }

    // Else if name is empty then a delete, so clear entire product
    else
    {
      delete Products[entityIndex][productIndex];

      // If this is the last product then decrease size of array
      if ((NumberOfProducts[entityIndex] - 1 == productIndex) &&
          (Products[entityIndex][NumberOfProducts[entityIndex] - 1].numberOfReleases == 0))
      {
        NumberOfProducts[entityIndex]--;

        // Remove all stranded empty products before this one
        while ((NumberOfProducts[entityIndex] > 0) &&
               (bytes(Products[entityIndex]
                              [NumberOfProducts[entityIndex] - 1].name).length == 0) &&
                (Products[entityIndex]
                         [NumberOfProducts[entityIndex] - 1].numberOfReleases == 0))
        {
          delete Products[entityIndex][NumberOfProducts[entityIndex] - 1];
          NumberOfProducts[entityIndex]--;
        }
      }
    }

    // Emit an new product event and return the product index
    emit productEvent(entityIndex, productIndex, productName,
                      productURL, details);
    return;
  }

  /// @notice Create a new release of an existing product.
  /// Entity and Product must exist.
  /// @param productIndex The product ID of the new release
  /// @param newVersion The new product version, architecture and languages
  /// @param newHash The new release binary SHA256 CRC hash
  /// @param newFileUri The valid URI of the release binary
  function productRelease(uint256 productIndex, uint256 newVersion,
                          uint256 newHash, string calldata newFileUri)
    external
  {
    uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    uint256 version = newVersion | (block.timestamp << 160); // add timestamp

    // Only a validated entity can create a release
    require(entityStatus > 0, "Entity is not validated");

    require(newHash != 0, "Hash parameter is zero");
    require(bytes(newFileUri).length != 0, "URI cannot be empty");
    require(NumberOfProducts[entityIndex] > productIndex, "Product not found");

    // Populate the release
    Products[entityIndex][productIndex].
        releases[Products[entityIndex][productIndex].numberOfReleases++] =
                                      Release(newHash, newFileUri, version);

    // Populate the reverse lookup (entityId, productId, releaseId)
    HashToRelease[newHash] = (((entityIndex & 0xFFFFFFFF) << 64) |
                              ((productIndex & 0xFFFFFFFF) << 32) |
      (((Products[entityIndex][productIndex].numberOfReleases - 1) & 0xFFFFFFFF) << 0));

    emit productReleaseEvent(entityIndex, productIndex, version);
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
    require(entityIndex > 0, EntityIsZero);
    require(NumberOfProducts[entityIndex] > productIndex, "Product not found");
    require(Products[entityIndex][productIndex].numberOfReleases > releaseIndex,
            "Release not found");

    // Return the version, URI and hash for this product
    return (Products[entityIndex][productIndex].releases[releaseIndex].version,
            Products[entityIndex][productIndex].releases[releaseIndex].fileURI,
            Products[entityIndex][productIndex].releases[releaseIndex].hash);
  }

  /// @notice Reverse lookup, return entity, product, URI of product release.
  /// Entity, Product and Release must exist.
  /// @param fileHash The index of the product release
  /// @return The index of the entity owner of product
  /// @return The product ID of the release
  /// @return The release ID of the release
  /// @return the version, architecture and language(s)
  /// @return the URI to the product release file
  function productReleaseHashDetails(uint256 fileHash)
    external view returns (uint256, uint256, uint256, uint256, string memory)
  {
    uint256 releaseId = HashToRelease[fileHash];
    uint256 entityIndex = (releaseId >> 64) & 0xFFFFFFFF;
    uint256 productIndex = (releaseId >> 32) & 0xFFFFFFFF;
    uint256 releaseIndex = (releaseId >> 0) & 0xFFFFFFFF;

    // Ensure release hash lookup is valid
    if ((entityIndex == 0) ||
        (NumberOfProducts[entityIndex] <= productIndex) ||
        (Products[entityIndex][productIndex].numberOfReleases <= releaseIndex))
      return (0, 0, 0, 0, "");

    // Return the entity, product, version, and URI for this hash
    return (entityIndex, productIndex, releaseIndex,
            Products[entityIndex][productIndex].releases[releaseIndex].version,
            Products[entityIndex][productIndex].releases[releaseIndex].fileURI);
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
    require(entityIndex > 0, EntityIsZero);
    require(NumberOfProducts[entityIndex] > productIndex, "Product not found");

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
    require(entityIndex > 0, EntityIsZero);

    // Return the number of products for this entity
    if (NumberOfProducts[entityIndex] > 0)
      return NumberOfProducts[entityIndex];
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
    require(entityIndex > 0, EntityIsZero);
    require(NumberOfProducts[entityIndex] > productIndex,
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
    require(entityIndex > 0, EntityIsZero);
    string memory name;
    string memory infoURL;
    string memory logoURL;

    require(NumberOfProducts[entityIndex] > productIndex, "Product not found");

    // Return the hash for this organizations product and version
    infoURL = Products[entityIndex][productIndex].infoURL;
    logoURL = Products[entityIndex][productIndex].logoURL;
    name = Products[entityIndex][productIndex].name;
    return (name, infoURL, logoURL,
            Products[entityIndex][productIndex].details);
  }

  /// @notice Retrieve details for all products
  /// Status of empty arrays if none found.
  /// @return array of name, infoURL, logoURL, status details
  ///                  number of releases, price in tokens
  function productAllDetails(uint256 entityIndex)
    external view returns (string[] memory, string[] memory,
                           string[] memory, uint256[] memory,
                           uint256[] memory, uint256[] memory)
  {
    require(entityIndex > 0, EntityIsZero);

    string[] memory resultName = new string[](NumberOfProducts[entityIndex]);
    string[] memory resultInfoURL = new string[](NumberOfProducts[entityIndex]);
    string[] memory resultLogoURL = new string[](NumberOfProducts[entityIndex]);
    uint256[] memory resultDetails = new uint256[](NumberOfProducts[entityIndex]);
    uint256[] memory resultNumReleases = new uint256[](NumberOfProducts[entityIndex]);
    uint256[] memory resultNumOffers = new uint256[](NumberOfProducts[entityIndex]);

    // Build result arrays for all product information of an Entity
    for (uint i = 0; i < NumberOfProducts[entityIndex]; ++i)
    {
      resultName[i] = Products[entityIndex][i].name;
      resultInfoURL[i] = Products[entityIndex][i].infoURL;
      resultLogoURL[i] = Products[entityIndex][i].logoURL;
      resultDetails[i] = Products[entityIndex][i].details;
      resultNumReleases[i] = Products[entityIndex][i].numberOfReleases;
      resultNumOffers[i] = Products[entityIndex][i].numberOfOffers;
    }

    return (resultName, resultInfoURL, resultLogoURL, resultDetails,
            resultNumReleases, resultNumOffers);
  }

  /// @notice Return the price of a product activation license.
  /// Entity and Product must exist.
  /// @param entityIndex The index of the entity with offer
  /// @param productIndex The product ID of the offer
  /// @param offerIndex The per-product offer ID
  /// @return address of ERC20 token of offer (zero address is ETH)
  /// @return the price in tokens for the activation license
  /// @return the value of the activation (duration, flags, value)
  /// @return the URL to more information about the offer
  function productOfferDetails(uint256 entityIndex,
                               uint256 productIndex,
                               uint256 offerIndex)
    public view returns (address, uint256, uint256, string memory)
  {
    require(entityIndex > 0, EntityIsZero);

    require(NumberOfProducts[entityIndex] > productIndex,
            "Product not found");

    require(Products[entityIndex][productIndex].numberOfOffers > offerIndex,
            "Offer not found");

    // Return price, value/duration/flags and ERC token of offer
    return (Products[entityIndex][productIndex].offers[offerIndex].tokenAddr,
            Products[entityIndex][productIndex].offers[offerIndex].price,
            Products[entityIndex][productIndex].offers[offerIndex].value,
            Products[entityIndex][productIndex].offers[offerIndex].infoURL);
  }

  /// @notice Return all the product activation offers
  /// Entity and Product must exist.
  /// @param entityIndex The index of the entity with offer
  /// @param productIndex The product ID of the offer
  /// @return address of ERC20 token of offer (zero address is ETH)
  /// @return the price in tokens for the activation license
  /// @return the value of the activation (duration, flags, value)
  /// @return the URL to more information about the offer
  function productAllOfferDetails(uint256 entityIndex,
                                  uint256 productIndex)
    public view returns (address[] memory, uint256[] memory,
                         uint256[] memory, string[] memory)
  {
    require(entityIndex > 0, EntityIsZero);

    require(NumberOfProducts[entityIndex] > productIndex,
            "Product not found");

    address[] memory resultAddr = new address[](Products[entityIndex][productIndex].numberOfOffers);
    uint256[] memory resultPrice = new uint256[](Products[entityIndex][productIndex].numberOfOffers);
    uint256[] memory resultValue = new uint256[](Products[entityIndex][productIndex].numberOfOffers);
    string[] memory resultInfoUrl = new string[](Products[entityIndex][productIndex].numberOfOffers);

    // Build result arrays for all offer information of a product
    for (uint i = 0; i < Products[entityIndex][productIndex].numberOfOffers; ++i)
    {
      resultAddr[i] = Products[entityIndex][productIndex].offers[i].tokenAddr;
      resultPrice[i] = Products[entityIndex][productIndex].offers[i].price;
      resultValue[i] = Products[entityIndex][productIndex].offers[i].value;
      resultInfoUrl[i] = Products[entityIndex][productIndex].offers[i].infoURL;
    }

    // Return array of ERC20 token address, price, value/duration/flags and URL
    return (resultAddr, resultPrice, resultValue, resultInfoUrl);
  }
}
