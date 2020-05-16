pragma solidity 0.5.16;

import "./ImmutableEntity.sol";
import "./ImmutableProduct.sol";

/// Comments within /*  */ are for toggling upgradable contracts */

/// @title The Immutable License - automated software sales
/// @author Sean Lawless for ImmutableSoft Inc.
/// @dev License elements and methods
contract ImmutableLicense is Initializable, Ownable, ImmutableConstants
{
  string constant HashCannotBeZero = "Hash cannot be zero";

  struct LicenseOffer
  {
    uint256 priceInTokens;
    uint256 duration;
    uint256 promoPriceInTokens;
    uint256 promoDuration;
  }

  struct License
  {
    uint256 entityID;
    uint256 productID;
    uint256 licenseValue;
    uint256 entityOwner;
    address owner;
    uint256 expiration;
    uint256 priceInTokens;
  }

  struct LicenseReference
  {
    uint256 entityID;
    uint256 productID;
    uint256 hashIndex;
  }

  // Mapping of activation hash to License
  mapping (uint256 => License) private Licenses;

  // Mapping between external entity id and array of license hashes
  mapping (uint256 => LicenseReference[]) private LicenseReferences;

  // Mapping from entity to mapping of per product license offers
  mapping (uint256 => mapping (uint256 => LicenseOffer)) private LicenseOffers;

  // License interface events
  event licenseOfferEvent(uint256 entityIndex, uint256 productIndex,
                          string entityName, uint256 priceInTokens,
                          uint256 duration, uint256 promoPriceInTokens,
                          uint256 promoDuration);
  event licenseOfferResaleEvent(address seller, uint256 sellerIndex,
                                uint256 entityIndex, uint256 productIndex,
                                uint256 licenseHash, uint256 priceInTokens,
                                uint256 duration);
  event licensePurchaseEvent(uint256 entityIndex, uint256 productIndex,
                             uint256 expireTime);

  // External contract interfaces
  ImmutableProduct private productInterface;
  ImmutableEntity private entityInterface;
  ImmuteToken private tokenInterface;

  /// @notice License contract initializer/constructor.
  /// Executed on contract creation only.
  /// @param productAddr the address of the ImmutableProduct contract
  /// @param entityAddr the address of the ImmutableEntity contract
  /// @param tokenAddr the address of the IuT token contract
/*  constructor(address productAddr, address entityAddr,
              address tokenAddr)
    public
  {
*/
  function initialize(address productAddr, address entityAddr,
                      address tokenAddr) public initializer
  {
    Ownable.initialize(msg.sender);

    productInterface = ImmutableProduct(productAddr);
    entityInterface = ImmutableEntity(entityAddr);
    tokenInterface = ImmuteToken(tokenAddr);
  }

  ///////////////////////////////////////////////////////////
  /// PRODUCT ACTIVATION LICENSE
  ///////////////////////////////////////////////////////////

  /// @notice Offer a software product license for sale.
  /// mes.sender must have a valid entity and product.
  /// @param productIndex The specific ID of the product
  /// @param priceInTokens The token cost to purchase activation
  /// @param duration The minimum token cost to resell license
  ///                        zero (0) prevents resale
  function licenseOffer(uint256 productIndex, uint256 priceInTokens,
                        uint256 duration, uint256 promoPriceInTokens,
                        uint256 promoDuration)
    external
  {
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));

    // Only a validated commercial entity can create an offer
    require(entityStatus > 0, EntityNotValidated);
    require((entityStatus & Nonprofit) != Nonprofit, "Nonprofit prohibited");
    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");
    require(priceInTokens >= 0);

    // Allocate the offer for the product
    LicenseOffers[entityIndex][productIndex] =
                    LicenseOffer(priceInTokens, duration,
                                 promoPriceInTokens, promoDuration);

    string memory productName;
    string memory unused;
    uint256 details;
    (productName, unused, unused, details) =
         productInterface.productDetails(entityIndex + 1, productIndex);

    emit licenseOfferEvent(entityIndex + 1, productIndex,
                           productName, priceInTokens, duration,
                           promoPriceInTokens, promoDuration);
  }

  /// @notice Transfer tokens to a product offer escrow.
  /// Not public, called internally. msg.sender is the purchaser.
  /// @param entityIndex The entity offering the product license
  /// @param productIndex The specific ID of the product
  function licenseTransferEscrow(uint256 entityIndex,
                                 uint256 productIndex,
                                 uint256 promotional)
    private returns (bool)
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, EntityNotValidated);
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");
    LicenseOffer storage theOffer = LicenseOffers[entityIndex][productIndex];
    require(theOffer.priceInTokens > 0, OfferNotFound);

    bool transferResult;
    address customToken = address(0);
    uint256 price;

    // Set price based on promotion
    if (promotional > 0)
      price = theOffer.promoPriceInTokens;
    else
      price = theOffer.priceInTokens;

    // If custom token entity get the address
    if ((entityStatus & CustomToken) == CustomToken)
      customToken = entityInterface.entityCustomTokenAddress(entityIndex + 1);

    // If entity has custom token configured, transfer these tokens
    if (customToken != address(0))
    {
      ERC20 erc20Token = ERC20(customToken);
      transferResult = erc20Token.transferFrom(msg.sender,
          entityInterface.entityIndexToAddress(entityIndex + 1), price);
    }

    // Otherwise transfer immute tokens to the creator //smart contract
    else
    {
      // If manual, transfer 99% of sale to entity, 1% to Immutable
      if ((entityStatus & Automatic) != Automatic)
      {
        uint256 feeAmount = (price * 1) / 100;
        price -= feeAmount;

        // Transfer tokens to the sender and revert if failure
        if (tokenInterface.transferFrom(msg.sender,
            entityInterface.entityIndexToAddress(entityIndex + 1), price) == false)
          revert("Entity transfer failed");

        // Transfer fee to Immutable owner and revert if failure
        transferResult = tokenInterface.transferFrom(msg.sender,
                                                   owner(), feeAmount);
      }

      // Otherwise an automatic account, transfer entire amount
      else
        transferResult = tokenInterface.transferFrom(msg.sender,
          entityInterface.entityIndexToAddress(entityIndex + 1), price);
    }
    return transferResult;
  }

  /// @notice Create a product license.
  /// Not public, called internally. msg.sender is the license owner.
  /// @param entityIndex The local entity index of the license
  /// @param productIndex The specific ID of the product
  /// @param hash The external license activation hash
  /// @param value The activation value
  /// @param expiration The activation expiration
  /// @param previousHash The previous identifier or 0
function license_product(uint256 entityIndex, uint256 productIndex,
                         uint256 hash, uint256 value,
                         uint256 expiration, uint256 previousHash)
    private returns (uint256)
  {
    uint256 newHash;
    uint256 oldHash;
    uint256 i;

    // Rehash the license hash to ensure uniqueness across products
    newHash = licenseLookupHash(entityIndex + 1, productIndex, hash);
    oldHash = licenseLookupHash(entityIndex + 1, productIndex, previousHash);

    if (Licenses[newHash].licenseValue == 0)
    {
      Licenses[newHash].licenseValue = value;
      Licenses[newHash].owner = msg.sender;
      Licenses[newHash].entityOwner = entityInterface.entityAddressToIndex(msg.sender);
      Licenses[newHash].entityID = entityIndex + 1;
      Licenses[newHash].productID = productIndex;
      Licenses[newHash].expiration = expiration;
      Licenses[newHash].priceInTokens = 0;

      // If an old hash then find and update or revert
      if (previousHash > 0)
      {
        // Check if this is a license move (old and new same owner)
        if ((Licenses[newHash].entityOwner > 0) &&
            (Licenses[newHash].entityOwner == Licenses[oldHash].entityOwner))
        {
          // Update the reference
          for (i = 0; i < LicenseReferences[Licenses[newHash].entityOwner - 1].length;
               ++i)
          {
            // If this reference does not match entity/product, skip it
            if ((LicenseReferences[Licenses[newHash].entityOwner - 1][i].entityID != entityIndex + 1) ||
                (LicenseReferences[Licenses[newHash].entityOwner - 1][i].productID != productIndex))
              continue;

            // If this matches then update it and break out
            if (LicenseReferences[Licenses[newHash].entityOwner - 1][i].hashIndex == previousHash)
            {
              LicenseReferences[Licenses[newHash].entityOwner - 1][i].hashIndex = hash;
              break;
            }
          }
          if (i >= LicenseReferences[Licenses[newHash].entityOwner - 1].length)
            revert("license reference failed to update on move");
        }

        // Otherwise this is a transfer so clear old reference if any
        else if (Licenses[oldHash].entityOwner > 0)
        {
          for (i = 0; i < LicenseReferences[Licenses[oldHash].entityOwner - 1].length;
               ++i)
          {
            // If this reference does not match entity/product, skip it
            if ((LicenseReferences[Licenses[oldHash].entityOwner - 1][i].entityID != entityIndex + 1) ||
                (LicenseReferences[Licenses[oldHash].entityOwner - 1][i].productID != productIndex))
              continue;

            // If old hash reference is found then clear it and break out
            if (LicenseReferences[Licenses[oldHash].entityOwner - 1][i].hashIndex == previousHash)
            {
              LicenseReferences[Licenses[oldHash].entityOwner - 1][i].hashIndex = 0;
              LicenseReferences[Licenses[oldHash].entityOwner - 1][i].entityID = 0;
              LicenseReferences[Licenses[oldHash].entityOwner - 1][i].productID = 0;
              break;
            }
          }
          if (i >= LicenseReferences[Licenses[oldHash].entityOwner - 1].length)
            revert("old license reference failed to clear on transfer");
        }
      }

      // If purchaser registered and not a move, add license reference
      if ((Licenses[newHash].entityOwner > 0) && // purchaser registered
          ((previousHash == 0) || // and not a move
           (Licenses[newHash].entityOwner != Licenses[oldHash].entityOwner)))
      {
        for (i = 0; i < LicenseReferences[Licenses[newHash].entityOwner - 1].length;
             ++i)
        {
          // If an empty reference, use it
          if (LicenseReferences[Licenses[newHash].entityOwner - 1][i].entityID == 0)
          {
            LicenseReferences[Licenses[newHash].entityOwner - 1][i].hashIndex = hash;
            LicenseReferences[Licenses[newHash].entityOwner - 1][i].entityID = entityIndex + 1;
            LicenseReferences[Licenses[newHash].entityOwner - 1][i].productID = productIndex;
            return newHash;
          }
        }

        // If an empty reference, use it
        LicenseReferences[Licenses[newHash].entityOwner - 1].push(
                  LicenseReference(entityIndex + 1, productIndex, hash));
      }
    }

    // Otherwise license already exists so extend the expiration
    else
    {
      // Require license to be owned by the sender
      require((Licenses[newHash].owner == msg.sender) ||
              ((Licenses[newHash].entityOwner > 0) &&
               (Licenses[newHash].entityOwner ==
                entityInterface.entityAddressToIndex(msg.sender))),
              "Sender does not own license2");

      require(Licenses[newHash].licenseValue == value, "Update requires same value");
      require(Licenses[newHash].entityID == entityIndex + 1, "Entity ID does not match");
      require(Licenses[newHash].productID == productIndex, "Product ID does not match");

      Licenses[newHash].owner = msg.sender;
      Licenses[newHash].entityOwner = entityInterface.entityAddressToIndex(msg.sender);

      // Extend the activation expiration if not yet expired
      if (Licenses[newHash].expiration > now)
        Licenses[newHash].expiration = expiration + (Licenses[newHash].expiration - now);
      else
        Licenses[newHash].expiration = expiration;

      // If an old hash then find and clear moved reference
      if (previousHash > 0)
      {
        if (Licenses[oldHash].entityOwner > 0)
        {
          // Require license to be owned by the sender
          require((Licenses[oldHash].owner == msg.sender) ||
                  ((Licenses[oldHash].entityOwner > 0) &&
                   (Licenses[oldHash].entityOwner ==
                    entityInterface.entityAddressToIndex(msg.sender))),
                  "Sender does not own original license");

          for (i = 0; i < LicenseReferences[Licenses[oldHash].entityOwner - 1].length;
               ++i)
          {
            // If this reference does not match entity/product, skip it
            if ((LicenseReferences[Licenses[oldHash].entityOwner - 1][i].entityID != entityIndex + 1) ||
                (LicenseReferences[Licenses[oldHash].entityOwner - 1][i].productID != productIndex))
              continue;

            // If old hash reference is found then clear it and break out
            if (LicenseReferences[Licenses[oldHash].entityOwner - 1][i].hashIndex == previousHash)
            {
              LicenseReferences[Licenses[oldHash].entityOwner - 1][i].hashIndex = 0;
              LicenseReferences[Licenses[oldHash].entityOwner - 1][i].entityID = 0;
              LicenseReferences[Licenses[oldHash].entityOwner - 1][i].productID = 0;
              break;
            }
          }
          if (i >= LicenseReferences[Licenses[newHash].entityOwner - 1].length)
            revert("old license reference failed to be cleared");
        }
      }
    }

    return newHash;
  }

  /// @notice Check if a license can be resold.
  /// Not public, called internally.
  /// @param entityIndex The local entity index of the license
  /// @param productIndex The specific ID of the product
  /// @return true if licenses are resellable
function license_resellable(uint256 entityIndex, uint256 productIndex)
    internal view returns (bool)
  {
    LicenseOffer storage theOffer = LicenseOffers[entityIndex][productIndex];

    if (theOffer.duration > 0)
      return true;
    else
      return false;
  }

  /// @notice Create manual product activation license for end user.
  /// mes.sender must own the entity and product.
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the activation license hash from end user
  /// @param licenseValue the value of the license (0 is unlicensed)
  /// @param expiration the date/time the license is valid for
  function licenseCreate(uint256 productIndex, uint256 licenseHash,
                         uint256 licenseValue, uint256 expiration)
    external
  {
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    // Only a validated commercial entity can create an offer
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    require(entityStatus > 0, EntityNotValidated);
    require((entityStatus & Nonprofit) != Nonprofit, "Nonprofit prohibited");

    license_product(entityIndex, productIndex, licenseHash,
                    licenseValue, expiration, 0);
  }

  /// @notice Purchase a software product activation license.
  /// mes.sender is the purchaser.
  /// @param entityIndex The entity offering the product license
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the end user unique identifier to activate
  /// @param promotional whether promotional offer purchased
  function licensePurchase(uint256 entityIndex, uint256 productIndex,
                           uint256 licenseHash, uint256 promotional)
    external
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, EntityNotValidated);
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");
    LicenseOffer storage theOffer = LicenseOffers[entityIndex][productIndex];
    require(theOffer.priceInTokens > 0, OfferNotFound);
    require(licenseHash > 0, HashCannotBeZero);

    if (licenseTransferEscrow(entityIndex + 1, productIndex, promotional))
    {
      uint256 duration;

      if (promotional > 0)
        duration = theOffer.promoDuration;
      else
        duration = theOffer.duration;

      // Udpate the product license for this end user
      license_product(entityIndex, productIndex, licenseHash, 1,
                      now + duration, 0);

      emit licensePurchaseEvent(entityIndex + 1, productIndex,
                                now + duration);
    }
    else
      revert("Transfer failed");
  }

  /// @notice Purchase a software product activation license in ETH.
  /// mes.sender is the purchaser.
  /// @param entityIndex The entity offering the product license
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the end user unique identifier to activate
  /// @param promotional whether promotional offer purchased
  function licensePurchaseInETH(uint256 entityIndex,
                                uint256 productIndex,
                                uint256 licenseHash,
                                uint256 promotional)
    external payable
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, EntityNotValidated);
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");
    uint256 priceInTokens;
    uint256 duration;

    // Set price and duration based on promotion
    if (promotional > 0)
    {
      priceInTokens = LicenseOffers[entityIndex][productIndex].promoPriceInTokens;
      duration =  LicenseOffers[entityIndex][productIndex].promoDuration;
    }
    else
    {
      priceInTokens = LicenseOffers[entityIndex][productIndex].priceInTokens;
      duration =  LicenseOffers[entityIndex][productIndex].duration;
    }
    require(priceInTokens > 0, OfferNotFound);
    require(licenseHash > 0, HashCannotBeZero);

    // Transfer the ETH to the entity bank address
    require(msg.value * tokenInterface.currentRate() >=
            priceInTokens, "Not enough ETH");
    entityInterface.entityTransfer.value(msg.value)(entityIndex + 1,
                                                    productIndex);

    // Udpate the product license for this end user
    license_product(entityIndex, productIndex, licenseHash, 1,
                    now + duration, 0);

    emit licensePurchaseEvent(entityIndex + 1, productIndex,
                              now + duration);
  }

  /// @notice Move a software product activation license.
  /// Costs 1 IuT token if sender not registered as automatic.
  /// mes.sender must be the activation license owner.
  /// @param entityIndex The entity who owns the product
  /// @param productIndex The specific ID of the product
  /// @param oldLicenseHash the existing activation identifier
  /// @param newLicenseHash the new activation identifier
  function licenseMove(uint256 entityIndex,
                       uint256 productIndex,
                       uint256 oldLicenseHash,
                       uint256 newLicenseHash)
    external
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0);
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    uint256 licenseValue;
    uint256 expiration;
    uint256 oldHash;

    // Rehash the license hash to ensure uniqueness across products
    oldHash = licenseLookupHash(entityIndex + 1, productIndex, oldLicenseHash);

    // Require the old license to be owned by the sender
    require((Licenses[oldHash].owner == msg.sender) ||
            ((Licenses[oldHash].entityOwner > 0) &&
             (Licenses[oldHash].entityOwner ==
              entityInterface.entityAddressToIndex(msg.sender))),
            "Sender does not own license");

    require(newLicenseHash != oldLicenseHash, "Identifier identical");

    // Save old activation license value and ensure valid
    licenseValue = Licenses[oldHash].licenseValue;
    expiration = Licenses[oldHash].expiration;
    require(licenseValue > 0, "Old license not valid");
    require((expiration == 0) || (expiration > now),
            "Resale of expired license invalid");
    require(newLicenseHash > 0, HashCannotBeZero);

    // If entity not automatic, charge 1 IuT token to move license
    if ((entityInterface.entityAddressStatus(msg.sender) & Automatic) != Automatic)
    {
      // Transfer one token from msg.sender to Immutable owner
      if (tokenInterface.transferFrom(msg.sender, owner(), 1000000000000000000) == false)
        revert("Owner transfer failed");
    }

    // Create the new activation license
    license_product(entityIndex, productIndex, newLicenseHash,
                    licenseValue, expiration, oldLicenseHash);

    // Clear/Deactivate old activation license
    Licenses[oldHash].entityID = 0;
    Licenses[oldHash].productID = 0;
    Licenses[oldHash].licenseValue = 0;
    Licenses[oldHash].owner = address(0);
    Licenses[oldHash].entityOwner = 0;
    Licenses[oldHash].priceInTokens = 0;
    Licenses[oldHash].expiration = 0;
  }

  /// @notice Offer a software product license for resale.
  /// mes.sender must own the activation license.
  /// @param entityIndex The entity who owns the product
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the existing activation identifier
  /// @param priceInTokens The token cost to purchase license
  /// @return The product license offer identifier
  function licenseOfferResale(uint256 entityIndex, uint256 productIndex,
                            uint256 licenseHash, uint256 priceInTokens)
    external
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0);
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    uint256 oldHash;

    // Rehash the license hash to ensure uniqueness across products
    oldHash = licenseLookupHash(entityIndex + 1, productIndex, licenseHash);

    require(Licenses[oldHash].licenseValue > 0, "License not valid");
    require((Licenses[oldHash].expiration == 0) ||
            (Licenses[oldHash].expiration > now), "Resale of expired license invalid");

    uint256 ownerIndex = entityInterface.entityAddressToIndex(msg.sender);
    require((msg.sender == Licenses[oldHash].owner) ||
            (ownerIndex == Licenses[oldHash].entityOwner), "Not owner");

    // This is required to prevent license hijack from old entity address
    if (Licenses[oldHash].entityOwner > 0)
      require(Licenses[oldHash].entityOwner == entityInterface.entityAddressToIndex(msg.sender),
              "Owner stale (entity moved after activation) - move license before resale");

    // Ensure license can be resold
    require(license_resellable(entityIndex, productIndex) == true, "Resale of product not allowed");

    // Set the activation license as "for sale"
    Licenses[oldHash].priceInTokens = priceInTokens;

    // Emit an event notifying the ecosystem that license is for sale
    emit licenseOfferResaleEvent(msg.sender, ownerIndex, entityIndex + 1, productIndex,
                                 licenseHash, priceInTokens, Licenses[oldHash].expiration);
  }

  /// @notice Transfer/Resell a software product activation license.
  /// License must be 'for sale' and msg.sender is new owner.
  /// Does NOT change current activation.
  /// @param entityIndex The entity who owns the product
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the existing activation identifier to purchase
  /// @param newLicenseHash the new activation identifier after purchase
  function licenseTransfer(uint256 entityIndex,
                           uint256 productIndex,
                           uint256 licenseHash,
                           uint256 newLicenseHash)
    external
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0);
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    uint256 licenseValue;
    uint256 oldHash;

    // Rehash the license hash to ensure uniqueness across products
    oldHash = licenseLookupHash(entityIndex + 1, productIndex, licenseHash);

    // Ensure resale is allowed and price is valid
    require(license_resellable(entityIndex, productIndex) == true, "Resale of product not allowed");
    // Require the license is offered for sale and price valid
    require(Licenses[oldHash].priceInTokens > 0, "License not for sale");
    require((Licenses[oldHash].expiration == 0) ||
            (Licenses[oldHash].expiration > now), "Resale of expired license invalid");
    // Ensure new identifier is different from current
    require(licenseHash != newLicenseHash, "Identifier identical");

    // Get the old activation license value and ensure it is valid
    licenseValue = Licenses[oldHash].licenseValue;
    require(licenseValue > 0, "Old license not valid");

    require(entityIndex + 1 == Licenses[oldHash].entityID, "Entity ID mismatch");
    require(productIndex == Licenses[oldHash].productID, "Product ID mismatch");

    // Look up the license owner and their entity status
    uint256 fee = 0;
    address customToken = address(0);
    address licenseOwner = Licenses[oldHash].owner;
    uint256 ownerStatus = entityInterface.entityAddressStatus(licenseOwner);

    // This is required to prevent license hijack from old entity address
    require(entityInterface.entityAddressToIndex(licenseOwner) == Licenses[oldHash].entityOwner,
            "Owner stale (entity moved after resale offer) - owner must move license before resale");

    // If custom token entity get the ERC20 token contract address
    if ((entityStatus & CustomToken) == CustomToken)
      customToken = entityInterface.entityCustomTokenAddress(entityIndex + 1);

    // If not automatic, charge a 1% fee
    if ((ownerStatus & Automatic) != Automatic)
    {
      // Charge one token to resale if purchased in custom token, otherwise 1%
      if (customToken != address(0))
        fee = 1000000000000000000;
      else
        fee = (Licenses[oldHash].priceInTokens * 1) / 100;

      // Transfer 1% fee from msg.sender to Immutable contract
      if (tokenInterface.transferFrom(msg.sender, owner(), fee) == false)
        revert("Owner transfer failed");
    }

    // If entity has custom token configured, transfer these tokens
    if (customToken != address(0))
    {
      ERC20 erc20Token = ERC20(customToken);
      if (erc20Token.transferFrom(msg.sender, licenseOwner, Licenses[oldHash].priceInTokens) == false)
        revert("Custom token resell transfer failed");
    }

    // Otherwise transfer immute tokens from purchaser to seller
    else
    {
      // Transfer tokens from the new owner (purchaser) to the seller
      //   Requires the new owner has pre-approved the token transfer
      if (tokenInterface.transferFrom(msg.sender, licenseOwner,
                       Licenses[oldHash].priceInTokens - fee) == false)
        revert("Resell transfer failed");
    }

    // Create the new activation license and reference
    license_product(entityIndex, productIndex, newLicenseHash,
                    Licenses[oldHash].licenseValue, Licenses[oldHash].expiration, licenseHash);

    // Clear/Deactivate old activation license
    Licenses[oldHash].entityID = 0;
    Licenses[oldHash].productID = 0;
    Licenses[oldHash].licenseValue = 0;
    Licenses[oldHash].owner = address(0);
    Licenses[oldHash].entityOwner = 0;
    Licenses[oldHash].priceInTokens = 0;
    Licenses[oldHash].expiration = 0;
  }

  /// All product license functions below are view type (read only)

  /// @notice Return the number of license activations for an entity
  /// Entity and product must be valid.
  /// @param entityIndex The entity the product license is for
  /// @return the length of the license reference array
  function licenseNumberOf(uint256 entityIndex)
    external view returns (uint256)
  {
    // Only a validated entity can have licenses
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, EntityNotValidated);
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    // Return the number of activations (length of array)
    return LicenseReferences[entityIndex].length;
  }

  /// @notice Return end user activation value and expiration for product
  /// Entity and product must be valid.
  /// @param entityIndex The entity the product license is for
  /// @param licenseIndex The specific ID of the activation license
  /// @return the entity identifier of product activated
  /// @return the product identifier of product activated
  /// @return the current end user identifier that is activated
  function licenseDetails(uint256 entityIndex, uint256 licenseIndex)
    external view returns (uint256, uint256, uint256)
  {
    // Only a validated entity can have licenses
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, EntityNotValidated);
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    require(LicenseReferences[entityIndex].length > licenseIndex, "License not found");

    // If purchaser registered, add the license reference information
    return (LicenseReferences[entityIndex][licenseIndex].entityID,
            LicenseReferences[entityIndex][licenseIndex].productID,
            LicenseReferences[entityIndex][licenseIndex].hashIndex);
  }

  /// @notice Return end user activation value and expiration for product
  /// Entity and product must be valid.
  /// @param entityIndex The entity the product license is for
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the external unique identifier to activate
  /// @return the license value (> 0 is valid)
  /// @return the expiration value (seconds since epoch)
  /// @return the price in tokens it is offered for resale
  function licenseStatus(uint256 entityIndex, uint256 productIndex,
                         uint256 licenseHash)
    external view returns (uint256, uint256, uint256)
  {
    uint256 hash = licenseLookupHash(entityIndex, productIndex,
                                     licenseHash);

    // If license is expired return not valid
    if ((Licenses[hash].expiration > 0) &&
        (Licenses[hash].expiration < now))
      return (0, 0, 0);

    // Otherwise return license value
    else
      return (Licenses[hash].licenseValue, Licenses[hash].expiration,
              Licenses[hash].priceInTokens);
  }

  /// @notice Return the price of a product activation license.
  /// Entity and Product must exist.
  /// @param entityIndex The index of the entity with offer
  /// @param productIndex The product ID of the new release
  /// @return the price in tokens for the activation license
  /// @return the duration of the activation
  /// @return the promotion price in tokens
  /// @return the promotion duration
  function licenseOfferDetails(uint256 entityIndex,
                               uint256 productIndex)
    public view returns (uint256, uint256, uint256, uint256)
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");

    // Return price and duration of the product activation offer
    return (LicenseOffers[entityIndex][productIndex].priceInTokens,
            LicenseOffers[entityIndex][productIndex].duration,
            LicenseOffers[entityIndex][productIndex].promoPriceInTokens,
            LicenseOffers[entityIndex][productIndex].promoDuration);
  }

  /// @notice Return the internal activation license hash.
  /// Entity and Product must exist. Private. Called internally only.
  /// @param entityIndex The index of the entity with offer
  /// @param productIndex The product ID of the new release
  /// @param licenseHash The external license hash
  /// @return the internal activation license hash
  function licenseLookupHash(uint256 entityIndex, uint256 productIndex,
                             uint256 licenseHash)
    private view returns (uint256)
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");

    // Look up the entity name
    string memory entityName;
    string memory entityUrl;
    (entityName, entityUrl) = entityInterface.entityDetailsByIndex(entityIndex + 1);

    // Look up the product name
    string memory productName;
    string memory unused;
    uint256 details;
    (productName, unused, unused, details) =
        productInterface.productDetails(entityIndex + 1, productIndex);

    // Require entity name and product name are valid
    require((bytes(entityName).length > 0) &&
            (bytes(productName).length > 0));

    // Rehash the external license hash and return the internal hash
    bytes memory encodedBlob = abi.encodePacked(licenseHash,
                                              entityName, productName);
    return uint256(keccak256(encodedBlob));
  }

}
