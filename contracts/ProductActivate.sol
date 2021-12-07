pragma solidity >=0.7.6;

// SPDX-License-Identifier: GPL-3.0-or-later

import "./StringCommon.sol";
import "./ImmutableEntity.sol";
import "./ProductActivate.sol";
import "./CreatorToken.sol";
import "./ActivateToken.sol";

// OpenZepellin upgradable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PullPaymentUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

/*
// OpenZepellin standard contracts
//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
*/

// OpenZepellin upgradable contracts
contract ProductActivate is Initializable, OwnableUpgradeable,
                          PullPaymentUpgradeable
/*
// OpenZepellin standard contracts
contract ProductActivate is Ownable, PullPayment
*/
{
  address payable private Bank;
//  uint256 private EthFee;

  mapping (uint256 => uint256) private TokenIdToOfferPrice;
  mapping (uint256 => uint256) private TransferSurcharge;

  ActivateToken private activateTokenInterface;
  CreatorToken private creatorTokenInterface;
  ImmutableEntity entityInterface;
  ImmutableProduct productInterface;
  StringCommon commonInterface;

// OpenZepellin upgradable contracts
  function initialize(address commonAddr, address entityContractAddr,
                      address productContractAddr, address activateTokenAddr,
                      address creatorTokenAddr)
    public initializer
  {
    __Ownable_init();
    __PullPayment_init();

/*
  // OpenZepellin standard contracts
  constructor(address commonAddr, address entityContractAddr,
              address productContractAddr, address activateTokenAddr,
              address creatorTokenAddr)
                                           Ownable()
                                           PullPayment()
  {
*/
    // Initialize the entity contract interface
    commonInterface = StringCommon(commonAddr);
    entityInterface = ImmutableEntity(entityContractAddr);
    productInterface = ImmutableProduct(productContractAddr);
    activateTokenInterface = ActivateToken(activateTokenAddr);
    creatorTokenInterface = CreatorToken(creatorTokenAddr);

    // Set default fee and add the deployer as the bank
//    EthFee = 1000000000000000; // Default $.40 with ETH $400
    Bank = payable(msg.sender);
  }

  ///////////////////////////////////////////////////////////
  /// PRODUCT ACTIVATE LICENSE
  ///////////////////////////////////////////////////////////

  /// @notice Transfer ETH funds to ImmutableSoft bank address.
  /// Uses OpenZeppelin PullPayment interface.
  function activateDonate(uint256 amount)
    public payable
  {
    _asyncTransfer(Bank, amount);
  }

  /// @notice Change bank that contract pays ETH out too.
  /// Administrator only.
  /// @param newBank The Ethereum address of new ecosystem bank
  function activateBankChange(address payable newBank)
    external onlyOwner
  {
    require(newBank != address(0), "Bank cannot be zero address");
    Bank = newBank;
  }
/*
  /// @notice Change license creation and move fee value
  /// Administrator only.
  /// @param newFee The new ETH fee for pay-as-you-go entities
  function activateFeeChange(uint256 newFee)
    external onlyOwner
  {
    EthFee = newFee;
  }

  /// @notice Retrieve current ETH pay-as-you-go fee
  /// @return The fee in ETH wei
  function activateFeeValue()
    external view returns (uint256)
  {
    return EthFee;
  }
*/

  /// @notice Create manual product activation license for end user.
  /// mes.sender must own the entity and product.
  /// Costs 1 IuT token if sender not registered as automatic
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the activation license hash from end user
  /// @param licenseValue the value of the license
  /// @param transferSurcharge the additional cost/surcharge to transfer
  /// @param ricardianParent The Ricardian contract parent (if any)
  function activateCreate(uint256 productIndex, uint256 licenseHash,
                          uint256 licenseValue, uint256 transferSurcharge,
                          uint256 ricardianParent)
    external payable
  {
    uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);
    // Only a validated commercial entity can create an offer
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    require(entityStatus > 0, commonInterface.EntityNotValidated());
    require((entityStatus & commonInterface.Nonprofit()) != commonInterface.Nonprofit(), "Nonprofit prohibited");
    require(productInterface.productNumberOf(entityIndex) > productIndex,
            "Product not found");
    require((((licenseValue & commonInterface.RicardianReqFlag()) == 0) ||
             (ricardianParent > 0)), "Ricardian required flag but no parent");
    require((entityStatus & commonInterface.Automatic()) != commonInterface.Automatic(),
            "Entity not Auto");
/*
    // If entity not automatic, donate ETH to create activation
    if ((entityStatus & commonInterface.Automatic()) != commonInterface.Automatic())
    {
      // Send ETH to configured ImmutableSoft bank
      require(msg.value >= EthFee, "Owner not automatic, ETH required");
      activateDonate(msg.value);
    }
    else
      require(msg.value == 0, "ETH not required");
*/

    uint256 tokenId = activateTokenInterface.mint(msg.sender, entityIndex, productIndex,
                          licenseHash, licenseValue, /*transferSurcharge,*/
                          ricardianParent);
    TransferSurcharge[tokenId] = transferSurcharge;
  }

  struct ActivationOffer
  {
    uint256 priceInTokens;
    uint256 value;
    address erc20token;
    string infoUrl;
    uint256 transferSurcharge;
    uint256 ricardianParent;
  }


  /// @notice Purchase a software product activation license.
  /// mes.sender is the purchaser.
  /// @param entityIndex The entity offering the product license
  /// @param productIndex The specific ID of the product
  /// @param offerIndex the product activation offer to purchase
  /// @param numLicenses the number of activations to purchase
  /// @param licenseHashes Array of end user identifiers to activate
  /// @param ricardianClients Array of end client agreement contracts
  function activatePurchase(uint256 entityIndex, uint256 productIndex,
                            uint256 offerIndex, uint16 numLicenses,
                            uint256[] memory licenseHashes,
                            uint256[] memory ricardianClients)
    external payable
  {
    // Ensure vendor is registered and product exists
    require(entityInterface.entityIndexStatus(entityIndex) > 0, commonInterface.EntityNotValidated());
    require(productInterface.productNumberOf(entityIndex) > productIndex,
            "Product not found");
    ActivationOffer memory theOffer;

    (theOffer.erc20token, theOffer.priceInTokens, theOffer.value,
     theOffer.infoUrl, theOffer.transferSurcharge, theOffer.ricardianParent) =
      productInterface.productOfferDetails(entityIndex, productIndex, offerIndex);
    require(theOffer.priceInTokens > 0, commonInterface.OfferNotFound());
    require(numLicenses > 0, "Invalid num licenses");

    // If purchase offer is not a token, transfer ETH
    if (theOffer.erc20token == address(0))
    {
      uint256 feeAmount = 0;
      require(msg.value >= theOffer.priceInTokens * numLicenses, "Not enough ETH");
      theOffer.priceInTokens = msg.value;

      if ((entityInterface.entityIndexStatus(entityIndex) &
           commonInterface.Automatic()) != commonInterface.Automatic())
        feeAmount = (theOffer.priceInTokens * 1) / 100;

      // Transfer the ETH to the entity bank address
      entityInterface.entityTransfer{value: theOffer.priceInTokens - feeAmount}
                                    (entityIndex, productIndex);

      // Move fee, if any, into ImmutableSoft bank account
      if (feeAmount > 0)
        activateDonate(feeAmount);
    }

    // Otherwise the purchase is an exchange of ERC20 tokens
    else
    {
      IERC20Upgradeable erc20TokenInterface = IERC20Upgradeable(theOffer.erc20token);

      // Transfer tokens to the sender and revert if failure
      erc20TokenInterface.transferFrom(msg.sender, entityInterface.
          entityIndexToAddress(entityIndex), theOffer.priceInTokens * numLicenses);
    }

    uint256 theDuration = ((theOffer.value & commonInterface.ExpirationMask()) >> commonInterface.ExpirationOffset());
    uint256 tokenId;

    // If expiration then update tokenId to include new expiration
    //  First clear then set expiration based on duration and now
    if ((theDuration > 0) && ((theOffer.value & commonInterface.ExpirationFlag()) > 0))
    {
      theOffer.value &= ~commonInterface.ExpirationMask();
      theOffer.value |= ((theDuration + block.timestamp) << commonInterface.ExpirationOffset()) & commonInterface.ExpirationMask();
    }

//    require(licenseHashes[i] > 0, commonInterface.HashCannotBeZero());

    // If a bulk purchase offer, expect to create multiple tokens
    if ((theOffer.value & commonInterface.BulkOffersFlag()) > 0)
    {
      require((theOffer.value & commonInterface.LimitedOffersFlag()) == 0, "Bulk or Limited, not both");
      numLicenses = (uint16)((theOffer.value & commonInterface.UniqueIdMask()) >> commonInterface.UniqueIdOffset());
    }

    // Purchase all the activation licenses
    for (uint i = 0; i < numLicenses; ++i)
    {
//      require(licenseHashes[i] > 0, commonInterface.HashCannotBeZero());

      // Check that ricardian client matches the offer's parent
      if (theOffer.ricardianParent > 0)
      {
        require(ricardianClients[i] > 0, "Client required");
        uint parentDepth = creatorTokenInterface.creatorParentOf(
                        ricardianClients[i], theOffer.ricardianParent);
        require(parentDepth > 0, "Parent not found");
      }
      else
        require(ricardianClients[i] == 0, "Client not allowed");

      // Check if this is a renewal (hash exists)
      if (activateTokenInterface.activateIdToTokenId(licenseHashes[i]) > 0)
      {
        // Look up tokenId from the old activation hash
        tokenId = activateTokenInterface.activateIdToTokenId(licenseHashes[i]);

        // Require that caller (msg.sender) is the owner
        require(activateTokenInterface.ownerOf(tokenId) == msg.sender, "Not token owner");

        // Require entity/product id's, flags and limitations match the token
        require((tokenId & (commonInterface.EntityIdMask() | commonInterface.ProductIdMask() | commonInterface.FlagsMask() | commonInterface.ValueMask())) ==
                ((entityIndex << commonInterface.EntityIdOffset()) | (productIndex << commonInterface.ProductIdOffset()) |
                (theOffer.value & (commonInterface.FlagsMask() | commonInterface.ValueMask()))),
                "Token to extend does not match offer");

        // Extend time duration by whatever was remaining, if any
        if (((tokenId & commonInterface.ExpirationMask()) >> commonInterface.ExpirationOffset()) > block.timestamp)
          theDuration += ((tokenId & commonInterface.ExpirationMask()) >> commonInterface.ExpirationOffset()) - block.timestamp;

        // burn the old token
        activateTokenInterface.burn(tokenId);
      }

      // If a limited amount of offers, inform product offer of purchase
      if ((theOffer.value & commonInterface.LimitedOffersFlag()) > 0)
        productInterface.productOfferPurchased(entityIndex,
                                               productIndex, offerIndex);

      // Create a new ERC721 activate token for the sender
      tokenId = activateTokenInterface.mint(msg.sender, entityIndex, productIndex,
                                  licenseHashes[i], theOffer.value,
          ((theOffer.value & commonInterface.RicardianReqFlag()) > 0) ?
                                  theOffer.ricardianParent : 0);
      TransferSurcharge[tokenId] = theOffer.transferSurcharge;
    }
  }

  /// @notice Move a software product activation license.
  /// Costs 1 IuT token if sender not registered as automatic.
  /// mes.sender must be the activation license owner.
  /// @param entityIndex The entity who owns the product
  /// @param productIndex The specific ID of the product
  /// @param oldLicenseHash the existing activation identifier
  /// @param newLicenseHash the new activation identifier
  function activateMove(uint256 entityIndex,
                        uint256 productIndex,
                        uint256 oldLicenseHash,
                        uint256 newLicenseHash)
    external payable
  {
    // Ensure vendor is registered and product exists
    require(entityInterface.entityIndexStatus(entityIndex) > 0, commonInterface.EntityNotValidated());
    uint256 tokenId;

    // Look up tokenId from the old activation hash
    tokenId = activateTokenInterface.activateIdToTokenId(oldLicenseHash);
    require(tokenId > 0, "TokenId invalid");

    // Ensure sender is the token owner
    require(msg.sender == activateTokenInterface.ownerOf(tokenId), "Sender is not token owner");

    // Require the entity and product id's match the token
    require((tokenId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset() == entityIndex, commonInterface.TokenEntityNoMatch());
    require((tokenId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset() == productIndex, commonInterface.TokenProductNoMatch());

    // Require the hash matches the token and new one is different
    require(activateTokenInterface.tokenIdToActivateId(tokenId) == oldLicenseHash, "Activate hash mismatch");
    require(activateTokenInterface.tokenIdToActivateId(tokenId) != newLicenseHash, "New hash must differ");

/*
    // If entity not automatic, charge 1 IuT token to move license
    if ((entityInterface.entityAddressStatus(msg.sender) & commonInterface.Automatic()) != commonInterface.Automatic())
    {
      // Send ETH to contract owner
      require(msg.value >= EthFee, "Not subscribed, ETH required");
      activateDonate(msg.value);
    }
    else
      require(msg.value == 0, "ETH not required");
*/

    activateTokenInterface.activateTokenMoveHash(tokenId,
                                       newLicenseHash, oldLicenseHash);
  }

  /// @notice Offer a software product license for resale.
  /// mes.sender must own the activation license.
  /// @param entityIndex The entity who owns the product
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the existing activation identifier
  /// @param priceInEth The ETH cost to purchase license
  /// @return the tokenId of the activation offered for resale
  function activateOfferResale(uint256 entityIndex, uint256 productIndex,
                               uint256 licenseHash, uint256 priceInEth)
    external returns (uint256)
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, commonInterface.EntityNotValidated());
    uint256 tokenId;

    // Look up tokenId from the activation hash
    tokenId = activateTokenInterface.activateIdToTokenId(licenseHash);
    require(tokenId > 0, "TokenId invalid");
    require(msg.sender == activateTokenInterface.ownerOf(tokenId), "Sender is not token owner");

    // Require the entity and product id's match the token
    require((tokenId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset() == entityIndex, commonInterface.TokenEntityNoMatch());
    require((tokenId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset() == productIndex, commonInterface.TokenProductNoMatch());
    require((tokenId & commonInterface.NoResaleFlag()) == 0, "No resale rights");

    // Set activation to "for sale"
    TokenIdToOfferPrice[tokenId] = priceInEth;
    return tokenId;
  }

  /// @notice Transfer/Resell a software product activation license.
  /// License must be 'for sale' and msg.sender is new owner.
  /// @param entityIndex The entity who owns the product
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the existing activation identifier to purchase
  /// @param newLicenseHash the new activation identifier after purchase
  function activateTransfer(uint256 entityIndex,
                            uint256 productIndex,
                            uint256 licenseHash,
                            uint256 newLicenseHash)
    external payable
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, commonInterface.EntityNotValidated());

    uint256 tokenId;

    // Look up tokenId from the old activation hash
    tokenId = activateTokenInterface.activateIdToTokenId(licenseHash);
    require(tokenId > 0, "TokenId invalid");

    // Require the license is offered for sale and price valid
    require(TokenIdToOfferPrice[tokenId] > 0, "License not for sale");
    if ((tokenId & commonInterface.ExpirationFlag()) == commonInterface.ExpirationFlag())
      require((((tokenId & commonInterface.ExpirationMask()) >> commonInterface.ExpirationOffset()) == 0) ||
              (((tokenId & commonInterface.ExpirationMask()) >> commonInterface.ExpirationOffset()) > block.timestamp), "Resale of expired license invalid");

    // Ensure new identifier is different from current
    require(licenseHash != newLicenseHash, "Identifier identical");

    // Get the old activation license falgs and ensure it is valid
    require(((tokenId & commonInterface.FlagsMask()) >> commonInterface.FlagsOffset()) > 0, "Old license not valid");
    require((tokenId & commonInterface.NoResaleFlag()) == 0, "No resale rights");

    // Require the entity and product id's match the token
    require((tokenId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset() == entityIndex, commonInterface.TokenEntityNoMatch());
    require((tokenId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset() == productIndex, commonInterface.TokenProductNoMatch());

    // Look up the license owner and their entity status
    uint256 fee = 0;
    address licenseOwner = activateTokenInterface.ownerOf(tokenId);
    address payable payableOwner = payable(licenseOwner);
    uint256 ownerStatus = entityInterface.entityAddressStatus(licenseOwner);

    require(msg.value >= TokenIdToOfferPrice[tokenId] + TransferSurcharge[tokenId], "Not enough ETH");

    // Transfer any surcharge to original creator if required
    if (TransferSurcharge[tokenId] > 0)
    {
      entityInterface.entityTransfer{value: TransferSurcharge[tokenId]}
               (entityIndex, productIndex);
    }


    // If activation owner is registered, use lower fee if any
    //   Any additional ETH is a "tip" to creator
    if (ownerStatus > 0)
    {
      if ((ownerStatus & commonInterface.Automatic()) != commonInterface.Automatic())
        fee = (msg.value * 1) / 100;

      entityInterface.entityTransfer{value: msg.value - TransferSurcharge[tokenId] - fee}
               (entityInterface.entityAddressToIndex(licenseOwner), 0);

      // Move fee, if any, into ImmutableSoft bank account
      if (fee > 0)
        activateDonate(fee);
    }

    // Otherwise an unregistered resale has a 5% fee
    else
    {
      fee = (msg.value * 5) / 100;

      // Transfer ETH funds minus the fee if any
      payableOwner.transfer(msg.value - TransferSurcharge[tokenId] - fee);
      activateDonate(fee);
    }

    // Transfer the activate token and update to the new owner
    activateTokenInterface.safeTransferFrom(licenseOwner,
                                            msg.sender, tokenId);

    // Update to the intended activation identifier of the new owner
    activateTokenInterface.activateTokenMoveHash(tokenId, newLicenseHash, 0);

    // Clear offer price so the token is no longer listed for sale
    TokenIdToOfferPrice[tokenId] = 0;
  }

  /// @notice Query activate token offer price
  /// @param tokenId The activate token identifier
  /// @return The price of the token if for sale
  function activateTokenIdToOfferPrice(uint256 tokenId)
    external view returns (uint256)
  {
    return TokenIdToOfferPrice[tokenId];
  }

}
