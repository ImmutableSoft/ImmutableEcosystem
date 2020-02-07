pragma solidity 0.5.16;

import "./ImmutableEntity.sol";
import "./ImmutableProduct.sol";

/// Comments within /*  */ are for toggling upgradable contracts */

/// @title The Immutable License - automated software sales
/// @author Sean Lawless for ImmutableSoft Inc.
/// @dev License elements and methods
contract ImmutableLicense is /*Initializable,*/ Ownable, ImmutableConstants
{
  struct LicenseOffer
  {
    uint256 priceInTokens;
    uint256 resellMinTokens;
    uint256 escrow;
  }

  struct License
  {
    uint256 entityID;
    uint256 productID;
    uint256 licenseValue;
    uint256 entityOwner;
    address owner;
    uint256 priceInTokens;
  }

  // Mapping of activation hash to License
  mapping (uint256 => License) private Licenses;

  // Mapping from entity to mapping of per product license offers
  mapping (uint256 => mapping (uint256 => LicenseOffer)) private LicenseOffers;

  // License interface events
  event licenseOfferEvent(uint256 entityIndex, uint256 productIndex,
                          string entityName, uint256 priceInTokens);
  event licenseOfferResaleEvent(address seller, uint256 sellerIndex,
                                uint256 entityIndex, uint256 productIndex,
                                uint256 licenseHash, uint256 priceInTokens);
  event licensePurchaseEvent(uint256 entityIndex,
                             uint256 productIndex);

  // External contract interfaces
  ImmutableProduct private productInterface;
  ImmutableEntity private entityInterface;
  ImmuteToken private tokenInterface;

  /// @notice License contract initializer/constructor.
  /// Executed on contract creation only.
  /// @param productAddr the address of the ImmutableProduct contract
  /// @param entityAddr the address of the ImmutableEntity contract
  /// @param tokenAddr the address of the IuT token contract
  constructor(address productAddr, address entityAddr,
              address tokenAddr)
    public
  {
/*  function initialize(address immuteToken, address ensAddr) initializer public
  {
    Ownable.initialize(msg.sender);
*/
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
  /// @param resellMinTokens The minimum token cost to resell license
  ///                        zero (0) prevents resale
  function licenseOffer(uint256 productIndex, uint256 priceInTokens,
                        uint256 resellMinTokens)
    external
  {
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));

    // Only a validated commercial entity can create an offer
    require(entityStatus > 0, "Entity not validated");
    require((entityStatus & Nonprofit) != Nonprofit, "Nonprofit prohibited");
    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");
    require(priceInTokens >= 0);
    require(resellMinTokens <= priceInTokens);

    // Allocate the offer for the product
    LicenseOffers[entityIndex][productIndex] =
                       LicenseOffer(priceInTokens, resellMinTokens, 0);

    string memory productName;
    string memory unused;
    uint256 details;
    (productName, unused, unused, details) =
         productInterface.productDetails(entityIndex + 1, productIndex);

    emit licenseOfferEvent(entityIndex + 1, productIndex,
                                  productName, priceInTokens);
  }

  /// @notice Transfer tokens to a product offer escrow.
  /// Not public, called internally. msg.sender is the purchaser.
  /// @param entityIndex The entity offering the product license
  /// @param productIndex The specific ID of the product
  function licenseTransferEscrow(uint256 entityIndex,
                                 uint256 productIndex)
    private returns (bool)
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, "Entity not validated");
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);
    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");
    LicenseOffer storage theOffer = LicenseOffers[entityIndex][productIndex];
    require(theOffer.priceInTokens > 0, OfferNotFound);

    bool transferResult;
    address customToken = address(0);

    // If custom token entity get the address
    if ((entityStatus & CustomToken) == CustomToken)
      customToken = entityInterface.entityCustomTokenAddress(entityIndex + 1);

    // If entity has custom token configured, transfer these tokens
    if (customToken != address(0))
    {
      ERC20 erc20Token = ERC20(customToken);
      transferResult = erc20Token.transferFrom(msg.sender,
                                address(this), theOffer.priceInTokens);
    }

    // Otherwise transfer immute tokens to the smart contract
    else
    {
      transferResult = tokenInterface.transferFrom(msg.sender,
                                address(this), theOffer.priceInTokens);
    }

    // Update the escrow of the offer to match what was transferred
    if (transferResult)
      theOffer.escrow += theOffer.priceInTokens;
    return transferResult;
  }

  /// @notice Create a product license.
  /// Not public, called internally. msg.sender is the license owner.
  /// @param entityIndex The local entity index of the license
  /// @param productIndex The specific ID of the product
  /// @param hash The external license activation hash
  /// @param value The activation value
function license_product(uint256 entityIndex, uint256 productIndex,
                         uint256 hash, uint256 value)
    private returns (uint256)
  {
    uint256 newHash;

    // Rehash the license hash to ensure uniqueness across products
    newHash = licenseLookupHash(entityIndex + 1, productIndex, hash);

    Licenses[newHash].licenseValue = value;
    Licenses[newHash].owner = msg.sender;
    Licenses[newHash].entityOwner = entityInterface.entityAddressToIndex(msg.sender);
    Licenses[newHash].entityID = entityIndex + 1;
    Licenses[newHash].productID = productIndex;
    Licenses[newHash].priceInTokens = 0;

    return newHash;
  }

  /// @notice Create manual product activation license for end user.
  /// mes.sender must own the entity and product.
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the activation license hash from end user
  /// @param licenseValue the value of the license (0 is unlicensed)
  function licenseCreate(uint256 productIndex, uint256 licenseHash,
                         uint256 licenseValue)
    external
  {
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    // Only a validated commercial entity can create an offer
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    require(entityStatus > 0, "Entity not validated");
    require((entityStatus & Nonprofit) != Nonprofit, "Nonprofit prohibited");

    license_product(entityIndex, productIndex, licenseHash,
                    licenseValue);
  }

  /// @notice Purchase a software product activation license.
  /// mes.sender is the purchaser.
  /// @param entityIndex The entity offering the product license
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the end user unique identifier to activate
  function licensePurchase(uint256 entityIndex,
                           uint256 productIndex,
                           uint256 licenseHash)
    external
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, "Entity not validated");

    if (licenseTransferEscrow(entityIndex, productIndex))
    {
      entityIndex = entityInterface.entityIdToLocalId(entityIndex);

      // Udpate the product license for this end user
      license_product(entityIndex, productIndex, licenseHash, 1);

      emit licensePurchaseEvent(entityIndex + 1, productIndex);
    }
    else
      revert("Transfer failed");
  }

  /// @notice Purchase a software product activation license in ETH.
  /// mes.sender is the purchaser.
  /// @param entityIndex The entity offering the product license
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the end user unique identifier to activate
  function licensePurchaseInETH(uint256 entityIndex,
                                uint256 productIndex,
                                uint256 licenseHash)
    external payable
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, "Entity not validated");
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");
    uint256 priceInTokens = LicenseOffers[entityIndex][productIndex].priceInTokens;
    require(priceInTokens > 0, "Offer not found");

    // Transfer the ETH to the entity bank address
    require(msg.value * tokenInterface.currentRate() >=
            priceInTokens, "Not enough ETH");
    entityInterface.entityTransfer.value(msg.value)(entityIndex + 1);

    // Udpate the product license for this end user
    license_product(entityIndex, productIndex, licenseHash, 1);

    emit licensePurchaseEvent(entityIndex + 1, productIndex);
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
    uint256 oldHash;

    // Rehash the license hash to ensure uniqueness across products
    oldHash = licenseLookupHash(entityIndex + 1, productIndex, oldLicenseHash);

    // Require the old license to be owned by the sender
    require((Licenses[oldHash].owner == msg.sender) ||
            ((Licenses[oldHash].entityOwner > 0) &&
             (Licenses[oldHash].entityOwner ==
              entityInterface.entityAddressToIndex(msg.sender))),
            "Sender does not own license");

    // Save old activation license value and ensure valid
    licenseValue = Licenses[oldHash].licenseValue;
    require(licenseValue > 0, "Old license not valid");

    // If entity not automatic, charge 1 IuT token to move license
    if ((entityInterface.entityAddressStatus(msg.sender) & Automatic) != Automatic)
    {
      // Transfer one token from msg.sender to Immutable
      if (tokenInterface.transferFrom(msg.sender, owner(), 1000000000000000000) == false)
        revert("Owner transfer failed");
    }

    // Clear/Deactivate old activation license
    Licenses[oldHash].entityID = 0;
    Licenses[oldHash].productID = 0;
    Licenses[oldHash].licenseValue = 0;
    Licenses[oldHash].owner = address(0);
    Licenses[oldHash].entityOwner = 0;
    Licenses[oldHash].priceInTokens = 0;

    // Create the new activation license
    license_product(entityIndex, productIndex, newLicenseHash,
                    licenseValue);
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

    uint256 ownerIndex = entityInterface.entityAddressToIndex(msg.sender);
    require((msg.sender == Licenses[oldHash].owner) ||
            (ownerIndex == Licenses[oldHash].entityOwner), "Not owner");

    // This is required to prevent license hijack from old entity address
    if (Licenses[oldHash].entityOwner > 0)
      require(Licenses[oldHash].entityOwner == entityInterface.entityAddressToIndex(msg.sender),
              "Owner stale (entity moved after activation) - move license before resale");

    // Ensure license can be resold and price within bounds defined by creator
    require(priceInTokens >= 0);
    uint256 price;
    uint256 resellMinTokens;
    (price, resellMinTokens) = licenseOfferDetails(entityIndex + 1, productIndex);
    require(resellMinTokens > 0, "Resale of product not allowed");
    require(priceInTokens >= resellMinTokens, "Resale price invalid");

    // Set the activation license as "for sale"
    Licenses[oldHash].priceInTokens = priceInTokens;

    // Emit an event notifying the ecosystem that license is for sale
    emit licenseOfferResaleEvent(msg.sender, ownerIndex, entityIndex + 1, productIndex,
                                 licenseHash, priceInTokens);
  }

  /// @notice Transfer/Resell a software product activation license.
  /// License must be 'for sale' and mes.sender is new owner.
  /// Does NOT change current activation.
  /// @param entityIndex The entity who owns the product
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the existing activation identifier to purchase
  function licenseTransfer(uint256 entityIndex,
                           uint256 productIndex,
                           uint256 licenseHash)
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
    uint256 priceInTokens;
    uint256 resellMinTokens;
    (priceInTokens, resellMinTokens) = licenseOfferDetails(entityIndex + 1, productIndex);
    require(resellMinTokens > 0, "Resale of product not allowed");
    // Require the license is offered for sale and price valid
    require(Licenses[oldHash].priceInTokens > 0, "License not for resale");
    require(Licenses[oldHash].priceInTokens >= resellMinTokens, "Resale price invalid");

    // Get the old activation license value and ensure it is valid
    licenseValue = Licenses[oldHash].licenseValue;
    require(licenseValue > 0, "Old license not valid");

    // Get the global entity index of the new owner
    uint256 newOwnerIndex = entityInterface.entityAddressToIndex(msg.sender);

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

    // If not automatic, charge a 5% fee
    if ((ownerStatus & Automatic) != Automatic)
    {
      // Charge one token to resale if purchased in custom token, otherwise 5%
      if (customToken != address(0))
        fee = 1000000000000000000;
      else
        fee = (Licenses[oldHash].priceInTokens * 5) / 100;

      // Transfer 5% fee from msg.sender to Immutable contract
      if (tokenInterface.transferFrom(msg.sender, address(this), fee) == false)
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
      if (tokenInterface.transferFrom(msg.sender, licenseOwner, Licenses[oldHash].priceInTokens - fee) == false)
        revert("Resell transfer failed");
    }

    // Change the owner of the activation license
    Licenses[oldHash].entityOwner = newOwnerIndex;
    Licenses[oldHash].owner = msg.sender;
  }

  /// @notice Withdraw tokens in escrow (accumulated license sales).
  /// Withdraws all license escrow amounts.
  function licenseTokensWithdraw()
    external
  {
    // Only a validated entity can withdraw
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    require(entityStatus > 0, "Entity not validated");
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                            entityInterface.entityAddressToIndex(msg.sender));
    uint256 offerEscrowAmount = 0;

    // Search all product license offers and sum escrow amounts
    uint256 numProducts = productInterface.productNumberOf(entityIndex + 1);
    for (uint id = 0; id < numProducts; ++id)
    {
      // If an escrow amount is present
      if (LicenseOffers[entityIndex][id].escrow > 0)
      {
        // Add escrow amount before zeroing escrow value
        offerEscrowAmount += LicenseOffers[entityIndex][id].escrow;
        LicenseOffers[entityIndex][id].escrow = 0;
      }
    }

    // If any escrow is available, withdraw (transfer) tokens
    if (offerEscrowAmount > 0)
    {
      address customToken = address(0);

      // If custom token entity get the address
      if ((entityStatus & CustomToken) == CustomToken)
        customToken = entityInterface.entityCustomTokenAddress(entityIndex + 1);

      // If entity has custom token configured, transfer these tokens
      if (customToken != address(0))
      {
        // Custom tokens only used for license activation sales
        ERC20 erc20Token = ERC20(customToken);

        // Transfer tokens from escrow (contract) to sender, revert if failure
        if (erc20Token.transfer(msg.sender, offerEscrowAmount) == false)
          revert("Custom token transfer failed");
      }
      else
      {
        // If an automatic account, transfer all the escrow amount
        if ((entityStatus & Automatic) == Automatic)
        {
          if (tokenInterface.transfer(msg.sender, offerEscrowAmount) == false)
            revert("Automatic transfer failed");
        }  

        // Otherwise transfer 95% of sale in escrow to entity, 5% to Immutable
        else
        {
          uint256 feeEscrowAmount = (offerEscrowAmount * 5) / 100;
          offerEscrowAmount -= feeEscrowAmount;

          // Transfer tokens to the sender and revert if failure
          if (tokenInterface.transfer(msg.sender, offerEscrowAmount) == false)
            revert("Entity transfer failed");

          // Transfer fee to Immutable and revert if failure
          if (tokenInterface.transfer(owner(), feeEscrowAmount) == false)
              revert("Owner transfer failed");
        }
      }
    }
  }

  /// All product license functions below are view type (read only)

  /// @notice Check balance of escrowed product licenses.
  /// Counts all available product license escrow amounts.
  function licenseTokenEscrow()
    external view returns (uint256)
  {
    // Only a validated entity can withdraw
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    require(entityStatus > 0, "Entity not validated");
    uint256 entityIndex = entityInterface.entityIdToLocalId(
                     entityInterface.entityAddressToIndex(msg.sender));
    uint256 offerEscrowAmount = 0;

    // Count all product license accumulated escrows
    uint256 numProducts = productInterface.productNumberOf(entityIndex + 1);
    for (uint id = 0; id < numProducts; ++id)
    {
      // Add escrow amount
      offerEscrowAmount += LicenseOffers[entityIndex][id].escrow;
    }

    // If not an automatic account, decrement the 5 percent fee
    if ((entityStatus & Automatic) != Automatic)
      offerEscrowAmount -= (offerEscrowAmount * 5) / 100;
    return offerEscrowAmount;
  }

  /// @notice Check if end user is activated for use of a product.
  /// Entity and product must be valid.
  /// @param entityIndex The entity the product license is for
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the external unique identifier to activate
  /// @return the license value (> 0 is valid)
  function licenseValid(uint256 entityIndex, uint256 productIndex,
                        uint256 licenseHash)
    external view returns (uint)
  {
    uint256 hash = licenseLookupHash(entityIndex, productIndex,
                                     licenseHash);

    return Licenses[hash].licenseValue;
  }

  /// @notice Return the price of a product activation license.
  /// Entity and Product must exist.
  /// @param entityIndex The index of the entity with offer
  /// @param productIndex The product ID of the new release
  /// @return the price in tokens for the activation license
  /// @return the minimum resale price in tokens
  function licenseOfferDetails(uint256 entityIndex,
                               uint256 productIndex)
    public view returns (uint256, uint256)
  {
    entityIndex = entityInterface.entityIdToLocalId(entityIndex);

    require(productInterface.productNumberOf(entityIndex + 1) > productIndex,
            "Product not found");

    // Return the price and minimum resale for this product offer
    return (LicenseOffers[entityIndex][productIndex].priceInTokens,
            LicenseOffers[entityIndex][productIndex].resellMinTokens);
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
