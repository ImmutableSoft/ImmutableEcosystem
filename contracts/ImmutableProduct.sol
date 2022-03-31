pragma solidity >=0.7.6;
pragma abicoder v2;

// SPDX-License-Identifier: GPL-3.0-or-later

import "./StringCommon.sol";
import "./ImmutableEntity.sol";

// OpenZepellin upgradable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

/*
// OpenZepellin standard contracts
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
*/

/// @title Entity self-managed product interface
/// @author Sean Lawless for ImmutableSoft Inc.
/// @notice Entity requires registration and approval
contract ImmutableProduct is Initializable, OwnableUpgradeable
{
  // Product activation offer
  struct Offer
  {
    address tokenAddr; // ERC20 token address of offer. Zero (0) is ETH
    uint256 price; // the offer price in tokens/ETH
    uint256 value; // duration, flags/resellability and
                   // product feature (languages, version, game item, etc.)
    string  infoURL;// Offer information details
    uint256 transferSurcharge; // transfer fee in ETH
    uint256 ricardianParent; // required ricardian parent contract
  }

  // Product information
  struct Product
  {
    string name;
    string infoURL;
    string logoURL;
    uint256 details; // category, flags/restrictions, languages
    uint256 numberOfOffers;
    mapping(uint256 => Offer) offers;
  }

  // Mapping between external entity id and array of products
  mapping (uint256 => mapping (uint256 => Product)) private Products;
  mapping (uint256 => uint256) private NumberOfProducts;

  // Product interface events
  event productEvent(uint256 entityIndex, uint256 productIndex,
                     string name, string infoUrl, uint256 details);

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
/*
  constructor(address entityAddr, address commonAddr)
  {
*/
    entityInterface = ImmutableEntity(entityAddr);
    commonInterface = StringCommon(commonAddr);
  }

  /// @notice Create a new product for an entity.
  /// Entity must exist and be validated by Immutable.
  /// @param productName The name of the new product
  /// @param productURL The primary URL of the product
  /// @param logoURL The logo URL of the product
  /// @param details the product category, languages, etc.
  /// @return the new (unique per entity) product identifier (index)
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
            commonInterface.EntityNotValidated());
    require(bytes(productName).length != 0, "name invalid");
    require(bytes(productURL).length != 0, "URL invalid");

    // If product name exists exactly revert the transaction
    for (productID = 0; productID < NumberOfProducts[entityIndex];
         ++productID)
    {
      // Check if the product name matches
      if (commonInterface.stringsEqual(Products[entityIndex][productID].name,
                                       productName))
        revert("name exists");
    }

    // Populate information for new product and increment index
    Products[entityIndex][lastProduct].name = productName;
    Products[entityIndex][lastProduct].infoURL = productURL;
    Products[entityIndex][lastProduct].logoURL = logoURL;
    Products[entityIndex][lastProduct].details = details;
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
  /// @param limited number of offers, (0) unlimited, 65535 max
  /// @param bulk number of activions per offer, > 0 to 65535 max
  /// @param infoUrl The official URL for more information about offer
  /// @param noResale Flag to disable resale capabilities for purchaser
  /// @param transferSurcharge Surcharged levied upon resale of purchase
  /// @param requireRicardian parent of required Ricardian client contract
  function productOfferFeature(uint256 productIndex, address erc20token,
                               uint256 price, uint256 feature,
                               uint256 expiration, uint16 limited,
                               uint16 bulk, string calldata infoUrl,
                               bool noResale,
                               uint256 transferSurcharge,
                               uint256 requireRicardian)
    external
  {
    if (noResale)
      require(expiration > 0, "Resale requires expiration");
    if (limited > 0)
      require(bulk == 0, "No Bulk when Limited");

    return productOffer(productIndex, erc20token, price,
                        (commonInterface.FeatureFlag() | commonInterface.ExpirationFlag() |
                        (noResale ? commonInterface.NoResaleFlag() : 0) |
                        ((limited > 0)? commonInterface.LimitedOffersFlag() : 0) |
                        ((bulk > 0) ? commonInterface.BulkOffersFlag() : 0) |
                         ((expiration << commonInterface.ExpirationOffset()) & commonInterface.ExpirationMask())  |
                         (((uint256)(limited | bulk) << commonInterface.UniqueIdOffset()) & commonInterface.UniqueIdMask()) |
                         ((feature << commonInterface.ValueOffset()) & commonInterface.ValueMask())),
                         infoUrl, transferSurcharge, requireRicardian);
  }

  /// @notice Offer a software product license for sale.
  /// mes.sender must have a valid entity and product.
  /// @param productIndex The specific ID of the product
  /// @param erc20token Address of ERC 20 token offer
  /// @param price The token cost to purchase activation
  /// @param limitation The version and language limitations
  /// @param expiration activation expiration, (0) forever/unexpiring
  /// @param limited number of offers, (0) unlimited, 65535 max
  /// @param bulk number of activions per offer, > 0 to 65535 max
  /// @param infoUrl The official URL for more information about offer
  /// @param noResale Prevent the resale of any purchased activation
  /// @param transferSurcharge Surcharged levied upon resale of purchase
  /// @param requireRicardian parent of required Ricardian client contract
  function productOfferLimitation(uint256 productIndex, address erc20token,
                                  uint256 price, uint256 limitation,
                                  uint256 expiration, uint16 limited,
                                  uint16 bulk, string calldata infoUrl,
                                  bool noResale,
                                  uint256 transferSurcharge,
                                  uint256 requireRicardian)
    external
  {
    if (noResale)
      require(expiration > 0, "Resale requires expiration");
    if (limited > 0)
      require(bulk == 0, "No Bulk when Limited");

    return productOffer(productIndex, erc20token, price,
                        (commonInterface.LimitationFlag() | commonInterface.ExpirationFlag() |
                        (noResale ? commonInterface.NoResaleFlag() : 0) |
                        ((limited > 0)? commonInterface.LimitedOffersFlag() : 0) |
                        ((bulk > 0) ? commonInterface.BulkOffersFlag() : 0) |
                         ((expiration << commonInterface.ExpirationOffset()) & commonInterface.ExpirationMask())  |
                         (((uint256)(limited | bulk) << commonInterface.UniqueIdOffset()) & commonInterface.UniqueIdMask()) |
                         ((limitation << commonInterface.ValueOffset()) & commonInterface.ValueMask())),
                         infoUrl, transferSurcharge, requireRicardian);
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
  /// @param transferSurcharge ETH to creator for each transfer
  /// @param requireRicardian Ricardian leaf required for purchase
  function productOffer(uint256 productIndex, address erc20token,
                        uint256 price, uint256 value,
                       string memory infoUrl, uint256 transferSurcharge,
                        uint256 requireRicardian)
    private
  {
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);
    uint256 offerId = 0;

    // Only a validated commercial entity can create an offer
    require(entityStatus > 0, commonInterface.EntityNotValidated());
    require((entityStatus & commonInterface.Nonprofit()) != commonInterface.Nonprofit(), "Nonprofit prohibited");

    // Sanity check the input parameters
    require(NumberOfProducts[entityIndex] > productIndex,
            commonInterface.ProductNotFound());
    require(price >= 0, "Offer requires price");

    // If token configured specified, do a quick validity check
    if (erc20token != address(0))
    {
      require((entityStatus & commonInterface.CustomToken()) == commonInterface.CustomToken(),
              "Token offers require custom status.");
      IERC20Upgradeable theToken = IERC20Upgradeable(erc20token);

      require(theToken.totalSupply() > 0,
              "Not ERC20 token or no supply");
    }

    // Check if any offer has been exhausted/revoked
    for (;offerId < Products[entityIndex][productIndex].numberOfOffers; ++offerId)
      if (Products[entityIndex][productIndex].offers[offerId].price == 0)
        break;

    // Assign new digital product offer
    Products[entityIndex][productIndex].offers[offerId].tokenAddr = erc20token;
    Products[entityIndex][productIndex].offers[offerId].price = price;
    Products[entityIndex][productIndex].offers[offerId].value = value;
    Products[entityIndex][productIndex].offers[offerId].infoURL = infoUrl;
    Products[entityIndex][productIndex].offers[offerId].transferSurcharge = transferSurcharge;
    Products[entityIndex][productIndex].offers[offerId].ricardianParent = requireRicardian;

    // If creating a new offer update the offer count
    if (offerId >= Products[entityIndex][productIndex].numberOfOffers)
      offerId = Products[entityIndex][productIndex].numberOfOffers++;

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
    require(entityStatus > 0, commonInterface.EntityNotValidated());
    require((entityStatus & commonInterface.Nonprofit()) != commonInterface.Nonprofit(), "Nonprofit prohibited");
    require(NumberOfProducts[entityIndex] > productIndex,
            commonInterface.ProductNotFound());
    require(Products[entityIndex][productIndex].numberOfOffers > offerIndex,
            "Offer out of range");

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
    require(entityIndex > 0, commonInterface.EntityIsZero());

    require(NumberOfProducts[entityIndex] > productIndex,
            commonInterface.ProductNotFound());

    require(Products[entityIndex][productIndex].numberOfOffers > offerIndex,
            commonInterface.OfferNotFound());

    uint256 value =
      Products[entityIndex][productIndex].offers[offerIndex].value;

    uint256 count = (value & commonInterface.UniqueIdMask()) >> commonInterface.UniqueIdOffset();
    require(count > 0, "Count required");

    value = value & ~(commonInterface.UniqueIdMask());
    value = value | (((count - 1) << commonInterface.UniqueIdOffset()) & commonInterface.UniqueIdMask());

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
    require(entityInterface.entityAddressStatus(msg.sender) > 0, commonInterface.EntityNotValidated());
    require((bytes(productName).length == 0) || (bytes(productURL).length != 0), "URL required");
    require(NumberOfProducts[entityIndex] > productIndex,
            commonInterface.ProductNotFound());

    // Check the product name for duplicates if present
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
            revert("name already exists");
          }
        }
      }
    }

    // Update the product information
    Products[entityIndex][productIndex].name = productName;
    Products[entityIndex][productIndex].infoURL = productURL;
    Products[entityIndex][productIndex].logoURL = logoURL;
    Products[entityIndex][productIndex].details = details;

    // Emit new product event and return the product index
    emit productEvent(entityIndex, productIndex, productName,
                      productURL, details);
    return;
  }

  /// @notice Return the number of products maintained by an entity.
  /// Entity must exist.
  /// @param entityIndex The index of the entity
  /// @return the current number of products for the entity
  function productNumberOf(uint256 entityIndex)
    external view returns (uint256)
  {
    require(entityIndex > 0, commonInterface.EntityIsZero());

    // Return the number of products for this entity
    if (NumberOfProducts[entityIndex] > 0)
      return NumberOfProducts[entityIndex];
    else
      return 0;
  }

  /// @notice Retrieve existing product name, info and details.
  /// Entity and product must exist.
  /// @param entityIndex The index of the entity
  /// @param productIndex The specific ID of the product
  /// @return name , infoURL, logoURL and details are return values.\
  ///         **name** The name of the product\
  ///         **infoURL** The primary URL for information about the product\
  ///         **logoURL** The URL for the product logo\
  ///         **details** The detail flags (category, language) of product
  function productDetails(uint256 entityIndex, uint256 productIndex)
    external view returns (string memory name, string memory infoURL,
                           string memory logoURL, uint256 details)
  {
    require(entityIndex > 0, commonInterface.EntityIsZero());
    string memory resultName;
    string memory resultInfoURL;
    string memory resultLogoURL;

    require(NumberOfProducts[entityIndex] > productIndex,
            commonInterface.ProductNotFound());

    // Return the hash for this organizations product and version
    resultInfoURL = Products[entityIndex][productIndex].infoURL;
    resultLogoURL = Products[entityIndex][productIndex].logoURL;
    resultName = Products[entityIndex][productIndex].name;
    return (resultName, resultInfoURL, resultLogoURL,
            Products[entityIndex][productIndex].details);
  }

  /// @notice Retrieve details for all products of an entity.
  /// Empty arrays if no products are found.
  /// @return names , infoURLs, logoURLs, details and offers are returned as arrays.\
  ///         **names** Array of names of the product\
  ///         **infoURLs** Array of primary URL about the product\
  ///         **logoURLs** Array of URL for the product logos\
  ///         **details** Array of detail flags (category, etc.)\
  ///         **offers** Array of number of Activation offers
  function productAllDetails(uint256 entityIndex)
    external view returns (string[] memory names, string[] memory infoURLs,
                           string[] memory logoURLs, uint256[] memory details,
                           uint256[] memory offers)
  {
    require(entityIndex > 0, commonInterface.EntityIsZero());

    string[] memory resultName = new string[](NumberOfProducts[entityIndex]);
    string[] memory resultInfoURL = new string[](NumberOfProducts[entityIndex]);
    string[] memory resultLogoURL = new string[](NumberOfProducts[entityIndex]);
    uint256[] memory resultDetails = new uint256[](NumberOfProducts[entityIndex]);
    uint256[] memory resultNumOffers = new uint256[](NumberOfProducts[entityIndex]);

    // Build result arrays for all product information of an Entity
    for (uint i = 0; i < NumberOfProducts[entityIndex]; ++i)
    {
      resultName[i] = Products[entityIndex][i].name;
      resultInfoURL[i] = Products[entityIndex][i].infoURL;
      resultLogoURL[i] = Products[entityIndex][i].logoURL;
      resultDetails[i] = Products[entityIndex][i].details;
      resultNumOffers[i] = Products[entityIndex][i].numberOfOffers;
    }

    return (resultName, resultInfoURL, resultLogoURL, resultDetails,
            resultNumOffers);
  }

  /// @notice Return the offer price of a product activation license.
  /// Entity, Product and Offer must exist.
  /// @param entityIndex The index of the entity with offer
  /// @param productIndex The product ID of the offer
  /// @param offerIndex The per-product offer ID
  /// @return erc20Token , price, value, offerURL, surcharge and parent are return values.\
  ///         **erc20Token** The address of ERC20 token offer (zero is ETH)\
  ///         **price** The price (ETH or ERC20) for the activation license\
  ///         **value** The duration, flags and value of activation\
  ///         **offerURL** The URL to more information about the offer\
  ///         **surcharge** The transfer surcharge of offer\
  ///         **parent** The required ricardian contract parent (if any)
  function productOfferDetails(uint256 entityIndex,
                               uint256 productIndex,
                               uint256 offerIndex)
    public view returns (address erc20Token, uint256 price, uint256 value,
                         string memory offerURL, uint256 surcharge,
                         uint256 parent)
  {
    require(entityIndex > 0, commonInterface.EntityIsZero());
    require(NumberOfProducts[entityIndex] > productIndex,
            commonInterface.ProductNotFound());

    require(Products[entityIndex][productIndex].numberOfOffers > offerIndex,
            commonInterface.OfferNotFound());

    // Return price, value/duration/flags and ERC token of offer
    return (Products[entityIndex][productIndex].offers[offerIndex].tokenAddr,
            Products[entityIndex][productIndex].offers[offerIndex].price,
            Products[entityIndex][productIndex].offers[offerIndex].value,
            Products[entityIndex][productIndex].offers[offerIndex].infoURL,
            Products[entityIndex][productIndex].offers[offerIndex].transferSurcharge,
            Products[entityIndex][productIndex].offers[offerIndex].ricardianParent);
  }

  struct OfferResult
  {
      address[] resultAddr;
      uint256[] resultPrice;
      uint256[] resultValue;
      string[] resultInfoUrl;
      uint256[] resultSurcharge;
      uint256[] resultParent;
  }

  /// @notice Return all the product activation offers
  /// Entity and Product must exist.
  /// @param entityIndex The index of the entity with offer
  /// @param productIndex The product ID of the offer
  /// @return erc20Tokens , prices, values, offerURLs, surcharges and parents are array return values.\
  ///         **erc20Tokens** Array of addresses of ERC20 token offer (zero is ETH)\
  ///         **prices** Array of prices for the activation license\
  ///         **values** Array of duration, flags, and value of activation\
  ///         **offerURLs** Array of URLs to more information on the offers\
  ///         **surcharges** Array of transfer surcharge of offers\
  ///         **parents** Array of ricardian contract parent (if any)
  function productAllOfferDetails(uint256 entityIndex,
                                  uint256 productIndex)
    public view returns (address[] memory erc20Tokens, uint256[] memory prices,
                    uint256[] memory values, string[] memory offerURLs,
                    uint256[] memory surcharges, uint256[] memory parents)
  {
    require(entityIndex > 0, commonInterface.EntityIsZero());

    require(NumberOfProducts[entityIndex] > productIndex,
            commonInterface.ProductNotFound());
    OfferResult memory theResult;

    {
      theResult.resultAddr = new address[](Products[entityIndex][productIndex].numberOfOffers);
      theResult.resultPrice = new uint256[](Products[entityIndex][productIndex].numberOfOffers);
      theResult.resultValue = new uint256[](Products[entityIndex][productIndex].numberOfOffers);
      theResult.resultInfoUrl = new string[](Products[entityIndex][productIndex].numberOfOffers);
      theResult.resultSurcharge = new uint256[](Products[entityIndex][productIndex].numberOfOffers);
      theResult.resultParent = new uint256[](Products[entityIndex][productIndex].numberOfOffers);
    }

    // Build result arrays for all offer information of a product
    for (uint i = 0; i < Products[entityIndex][productIndex].numberOfOffers; ++i)
    {
      theResult.resultAddr[i] = Products[entityIndex][productIndex].offers[i].tokenAddr;
      theResult.resultPrice[i] = Products[entityIndex][productIndex].offers[i].price;
      theResult.resultValue[i] = Products[entityIndex][productIndex].offers[i].value;
      theResult.resultInfoUrl[i] = Products[entityIndex][productIndex].offers[i].infoURL;
      theResult.resultSurcharge[i] = Products[entityIndex][productIndex].offers[i].transferSurcharge;
      theResult.resultParent[i] = Products[entityIndex][productIndex].offers[i].ricardianParent;
    }

    // Return array of ERC20 token address, price, value/duration/flags and URL
    return (theResult.resultAddr, theResult.resultPrice, theResult.resultValue,
            theResult.resultInfoUrl, theResult.resultSurcharge, theResult.resultParent);
  }
}
