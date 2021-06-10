pragma solidity ^0.8.4;

// SPDX-License-Identifier: GPL-3.0-or-later

import "./ImmutableProduct.sol";

// OpenZepellin upgradable contracts
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";


/*
  The ActivateToken unique token id is a conglomeration of the entity, product,
  expiration, identifier and license value. The licenseValue portion is 128 bits
  and is product specific, allowing millions of uniquely identifiable sub-products

    uint256 tokenId = entityIndex | (productIndex << 32) | (licenseExpiration << 64) |
                      (activationIdFlags << 96) | (licenseValue << 128);
*/

contract ActivateToken is Initializable, OwnableUpgradeable,
                          PullPaymentUpgradeable,
                          ERC721EnumerableUpgradeable,
                          ERC721BurnableUpgradeable, ImmutableConstants
{
  address payable private Bank;
  uint256 private EthFee;

  // Mapping to and from token id to current activation id
  mapping (uint256 => uint256) private ActivateIdToTokenId;
  mapping (uint256 => uint256) private TokenIdToActivateId;
  // Mapping of the number of activations (used for uniqueness)
  mapping (uint256 => uint256) private NumberOfActivations;
  mapping (uint256 => uint256) private TokenIdToOfferPrice;

  ImmutableEntity entityInterface;
  ImmutableProduct productInterface;

  function initialize(address entityContractAddr,
                      address productContractAddr)
    public initializer
  {
    __Ownable_init();
    __PullPayment_init();
    __ERC721_init("Activate", "ACT");
    __ERC721Enumerable_init();

    // Initialize the entity contract interface
    entityInterface = ImmutableEntity(entityContractAddr);
    productInterface = ImmutableProduct(productContractAddr);

    // Set default fee and add the deployer as the bank
    EthFee = 1000000000000000; // Default $.40 with ETH $400
    Bank = payable(msg.sender);
  }

  /// @notice Burn a product activation license.
  /// Not public, called internally. msg.sender must be the token owner.
  /// @param tokenId The tokenId to burn
  function activation_burn(uint256 tokenId)
    private
  {
    uint256 activationId = TokenIdToActivateId[tokenId];
    require(ownerOf(tokenId) == msg.sender, "Burn requires being owner");

    ActivateIdToTokenId[activationId] = 0;
    TokenIdToActivateId[tokenId] = 0;
    TokenIdToOfferPrice[tokenId] = 0;
    burn(tokenId);
  }

  /// @notice Create a product activation license.
  /// Not public, called internally. msg.sender is the license owner.
  /// @param entityIndex The local entity index of the license
  /// @param productIndex The specific ID of the product
  /// @param licenseHash The external license activation hash
  /// @param licenseValue The activation value and flags (192 bits)
  function activation_mint(uint256 entityIndex, uint256 productIndex,
                           uint256 licenseHash, uint256 licenseValue)
    private
  {
    uint256 activationId =
      ++NumberOfActivations[entityIndex | (productIndex << 32)];

    uint256 tokenId = ((entityIndex << EntityIdOffset) & EntityIdMask) |
                      ((productIndex << ProductIdOffset) & ProductIdMask) |
                      ((activationId << UniqueIdOffset) & UniqueIdMask) |
                      (licenseValue & (FlagsMask | ExpirationMask | ValueMask));

    // If not unique, fudge the values until unique
    while (TokenIdToActivateId[tokenId] != 0)
    {
      // Bump up the activation id
      activationId =
        ++NumberOfActivations[entityIndex | (productIndex << 32)];

      tokenId = ((entityIndex << EntityIdOffset) & EntityIdMask) |
                ((productIndex << ProductIdOffset) & ProductIdMask) |
                ((activationId << UniqueIdOffset) & UniqueIdMask) |
                (licenseValue & (FlagsMask | ExpirationMask | ValueMask));

/*
      // If still not unique, decrease the expiration time slightly
      // Must decrease since zero is unlimited time
      if (TokenIdToActivateId[tokenId] != 0)
      {
        uint256 theDuration = ((licenseValue & ExpirationMask) >> ExpirationOffset);
        theDuration -= block.timestamp % 0xFF;

        // Update tokenId to include new expiration
        //  Clear the expiration
        licenseValue &= ~ExpirationMask;
        licenseValue |= (theDuration << ExpirationOffset) & ExpirationMask;

        tokenId = ((entityIndex << EntityIdOffset) & EntityIdMask) |
                  ((productIndex << ProductIdOffset) & ProductIdMask) |
                  ((activationId << UniqueIdOffset) & UniqueIdMask) |
                  (licenseValue & (FlagsMask | ExpirationMask | ValueMask));
      }
*/
    }

    // Require a unique tokenId
    require(TokenIdToActivateId[tokenId] == 0, TokenNotUnique);
    require(TokenIdToOfferPrice[tokenId] == 0, TokenNotUnique);
    require(ActivateIdToTokenId[licenseHash] == 0, TokenNotUnique);

    // Mint the new activate token
    _mint(msg.sender, tokenId);

    // Assign mappings for id-to-hash and hash-to-id
    TokenIdToActivateId[tokenId] = licenseHash;
    ActivateIdToTokenId[licenseHash] = tokenId;
  }

  ///////////////////////////////////////////////////////////
  /// PRODUCT ACTIVATE LICENSE
  ///////////////////////////////////////////////////////////

  /// @notice Change owner for all activate tokens (activations)
  /// Not public, called internally. msg.sender is the license owner.
  function activateOwner(address newOwner)
      external
  {
    // Retrieve the balance of activation tokens
    uint256 numActivations = balanceOf(msg.sender);

    // Safely transfer each token to the new owner
    for (uint i = 0; i < numActivations; ++i)
      safeTransferFrom(msg.sender, newOwner, tokenOfOwnerByIndex(msg.sender, i));
  }

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

  /// @notice Create manual product activation license for end user.
  /// mes.sender must own the entity and product.
  /// Costs 1 IuT token if sender not registered as automatic
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the activation license hash from end user
  /// @param licenseValue the value of the license
  function activateCreate(uint256 productIndex, uint256 licenseHash,
                          uint256 licenseValue)
    external payable
  {
    uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);
    // Only a validated commercial entity can create an offer
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);
    require(entityStatus > 0, EntityNotValidated);
    require((entityStatus & Nonprofit) != Nonprofit, "Nonprofit prohibited");
    require(productInterface.productNumberOf(entityIndex) > productIndex,
            "Product not found");

    // If entity not automatic, donate ETH to create activation
    if ((entityStatus & Automatic) != Automatic)
    {
      // Send ETH to configured ImmutableSoft bank
      require(msg.value >= EthFee, "Owner not automatic, ETH required");
      activateDonate(msg.value);
    }
    else
      require(msg.value == 0, "ETH not required");

    activation_mint(entityIndex, productIndex, licenseHash,
                    licenseValue);
  }

  /// @notice Purchase a software product activation license.
  /// mes.sender is the purchaser.
  /// @param entityIndex The entity offering the product license
  /// @param productIndex The specific ID of the product
  /// @param offerIndex the product activation offer to purchase
  /// @param licenseHash the end user unique identifier to activate
  function activatePurchase(uint256 entityIndex, uint256 productIndex,
                            uint256 offerIndex, uint256 licenseHash)
    external payable
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, EntityNotValidated);
    require(productInterface.productNumberOf(entityIndex) > productIndex,
            "Product not found");

    uint256 priceInTokens;
    uint256 value;
    address erc20token;
    string memory infoUrl;
    uint256 feeAmount = 0;

    (erc20token, priceInTokens, value, infoUrl) =
      productInterface.productOfferDetails(entityIndex, productIndex, offerIndex);
    require(priceInTokens > 0, OfferNotFound);
    require(licenseHash > 0, HashCannotBeZero);

    // If purchase offer is not a token, transfer ETH
    if (erc20token == address(0))
    {
      require(msg.value >= priceInTokens, "Not enough ETH");
      priceInTokens = msg.value;

      if ((entityStatus & Automatic) != Automatic)
        feeAmount = (priceInTokens * 1) / 100;

      // Transfer the ETH to the entity bank address
      entityInterface.entityTransfer{value: priceInTokens - feeAmount}
                                    (entityIndex, productIndex);

      // Move fee, if any, into ImmutableSoft bank account
      if (feeAmount > 0)
        activateDonate(feeAmount);
    }

    // Otherwise the purchase is an exchange of ERCXXX tokens
    else
    {
      IERC20Upgradeable erc20TokenInterface = IERC20Upgradeable(erc20token);

      // Transfer tokens to the sender and revert if failure
      erc20TokenInterface.transferFrom(msg.sender, entityInterface.
          entityIndexToAddress(entityIndex), priceInTokens);
    }

    uint256 theDuration = ((value & ExpirationMask) >> ExpirationOffset);

    // Check if this is a renewal (hash exists)
    if (ActivateIdToTokenId[licenseHash] > 0)
    {
      // Look up tokenId from the old activation hash
      uint256 tokenId = ActivateIdToTokenId[licenseHash];

      // Require that caller (msg.sender) is the owner
      require(ownerOf(tokenId) == msg.sender, "Not token owner");

      // Require entity/product id's, flags and limitations match the token
      require((tokenId & (EntityIdMask | ProductIdMask | FlagsMask | ValueMask)) ==
              ((entityIndex << EntityIdOffset) | (productIndex << ProductIdOffset) |
              (value & (FlagsMask | ValueMask))),
              "Token to extend does not match offer");

      // Extend time duration by whatever was remaining, if any
      if (((tokenId & ExpirationMask) >> ExpirationOffset) > block.timestamp)
        theDuration += ((tokenId & ExpirationMask) >> ExpirationOffset) - block.timestamp;

      // burn the old token
      activation_burn(tokenId);
    }

    // Update tokenId to include new expiration
    //  First clear then set expiration based on duration and now
    value &= ~ExpirationMask;
    value |= ((theDuration + block.timestamp) << ExpirationOffset) & ExpirationMask;

    // If a limited amount of offers, inform product offer of purchase
    if ((value << UniqueIdOffset) & UniqueIdMask > 0)
      productInterface.productOfferPurchased(entityIndex,
                                             productIndex, offerIndex);

    // Create a new ERC721 activate token for the sender
    activation_mint(entityIndex, productIndex, licenseHash, value);
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
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, EntityNotValidated);
    uint256 tokenId;

    // Look up tokenId from the old activation hash
    tokenId = ActivateIdToTokenId[oldLicenseHash];
    require(tokenId > 0, "TokenId invalid");
    require(msg.sender == ownerOf(tokenId), "Sender is not token owner");

    // Require the entity and product id's match the token
    require((tokenId & EntityIdMask) >> EntityIdOffset == entityIndex, TokenEntityNoMatch);
    require((tokenId & ProductIdMask) >> ProductIdOffset == productIndex, TokenProductNoMatch);

    // Require the hash matches the token and new one is different
    require(TokenIdToActivateId[tokenId] == oldLicenseHash, "Activate hash mismatch");
    require(TokenIdToActivateId[tokenId] != newLicenseHash, "New hash must differ");

    // If entity not automatic, charge 1 IuT token to move license
    if ((entityInterface.entityAddressStatus(msg.sender) & Automatic) != Automatic)
    {
      // Send ETH to contract owner
      require(msg.value >= EthFee, "Not subscribed, ETH required");
      activateDonate(msg.value);
    }
    else
      require(msg.value == 0, "ETH not required");

    // Update tokenId references and new activation on blockchain
    ActivateIdToTokenId[oldLicenseHash] = 0;
    ActivateIdToTokenId[newLicenseHash] = tokenId;
    TokenIdToActivateId[tokenId] = newLicenseHash;
  }

  /// @notice Offer a software product license for resale.
  /// mes.sender must own the activation license.
  /// @param entityIndex The entity who owns the product
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the existing activation identifier
  /// @param priceInEth The ETH cost to purchase license
  function activateOfferResale(uint256 entityIndex, uint256 productIndex,
                               uint256 licenseHash, uint256 priceInEth)
    external
  {
    // Ensure vendor is registered and product exists
    uint256 entityStatus = entityInterface.entityIndexStatus(entityIndex);
    require(entityStatus > 0, EntityNotValidated);
    uint256 tokenId;

    // Look up tokenId from the activation hash
    tokenId = ActivateIdToTokenId[licenseHash];
    require(tokenId > 0, "TokenId invalid");
    require(msg.sender == ownerOf(tokenId), "Sender is not token owner");

    // Require the entity and product id's match the token
    require((tokenId & EntityIdMask) >> EntityIdOffset == entityIndex, TokenEntityNoMatch);
    require((tokenId & ProductIdMask) >> ProductIdOffset == productIndex, TokenProductNoMatch);
    require((tokenId & NoResaleFlag) == 0, "No resale rights");

    // Set activation to "for sale" and approve this contract to transfer
    TokenIdToOfferPrice[tokenId] = priceInEth;
    approve(address(this), tokenId);
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
    require(entityStatus > 0, EntityNotValidated);

    uint256 tokenId;

    // Look up tokenId from the old activation hash
    tokenId = ActivateIdToTokenId[licenseHash];
    require(tokenId > 0, "TokenId invalid");

    // Require the license is offered for sale and price valid
    require(TokenIdToOfferPrice[tokenId] > 0, "License not for sale");
    if ((tokenId & ExpirationFlag) == ExpirationFlag)
      require((((tokenId & ExpirationMask) >> ExpirationOffset) == 0) ||
              (((tokenId & ExpirationMask) >> ExpirationOffset) > block.timestamp), "Resale of expired license invalid");

    // Ensure new identifier is different from current
    require(licenseHash != newLicenseHash, "Identifier identical");

    // Get the old activation license falgs and ensure it is valid
    require(((tokenId & FlagsMask) >> FlagsOffset) > 0, "Old license not valid");
    require((tokenId & NoResaleFlag) == 0, "No resale rights");

    // Require the entity and product id's match the token
    require((tokenId & EntityIdMask) >> EntityIdOffset == entityIndex, TokenEntityNoMatch);
    require((tokenId & ProductIdMask) >> ProductIdOffset == productIndex, TokenProductNoMatch);

    // Look up the license owner and their entity status
    uint256 fee = 0;
    address licenseOwner = ownerOf(tokenId);
    address payable payableOwner = payable(licenseOwner);//address(uint256(licenseOwner));
    uint256 ownerStatus = entityInterface.entityAddressStatus(licenseOwner);

    require(msg.value >= TokenIdToOfferPrice[tokenId], "Not enough ETH");

    // If activation owner is registered, use lower fee if any
    if (ownerStatus > 0)
    {
      if ((ownerStatus & Automatic) != Automatic)
        fee = (msg.value * 1) / 100;

      entityInterface.entityTransfer{value: msg.value - fee}
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
      payableOwner.transfer(msg.value - fee);
      activateDonate(fee);
    }

    // Transfer the activate token and update to the new owner
    this.safeTransferFrom(licenseOwner, msg.sender, tokenId);

    // Remove activate id reverse lookup and clear offer price
    ActivateIdToTokenId[TokenIdToActivateId[tokenId]] = 0;
    TokenIdToOfferPrice[tokenId] = 0;

    // Change the activation id after transfer
    TokenIdToActivateId[tokenId] = newLicenseHash;
    ActivateIdToTokenId[newLicenseHash] = tokenId;
  }

  /// All activate functions below are view type (read only)

  /// @notice Return end user activation value and expiration for product
  /// Entity and product must be valid.
  /// @param entityIndex The entity the product license is for
  /// @param productIndex The specific ID of the product
  /// @param licenseHash the external unique identifier to activate
  /// @return the activation value (flags, expiration, value)
  /// @return the price in tokens it is offered for resale
  function activateStatus(uint256 entityIndex, uint256 productIndex,
                          uint256 licenseHash)
    external view returns (uint256, uint256)
  {
    require(entityIndex > 0, EntityIsZero);
    uint256 tokenId = ActivateIdToTokenId[licenseHash];

    if (tokenId > 0)
    {
      require(entityIndex == (tokenId & EntityIdMask) >> EntityIdOffset,
              "EntityId does not match");
      require(productIndex == (tokenId & ProductIdMask) >> ProductIdOffset,
              "ProductId does not match");
    }

    // Return license flags, value. expiration and price
    return (
             (tokenId & (FlagsMask |      //flags
                         ExpirationMask | //expiration
                         ValueMask)),     //value
             TokenIdToOfferPrice[tokenId] //price
           );
  }

  /// @notice Return all license activation details for an address
  /// @param entityAddress The address that owns the activations
  /// @return array of entity id of product
  /// @return array of product id of product
  /// @return array of activation identifiers
  /// @return array of token values
  /// @return array of price in tokens if for resale
  function activateAllDetailsForAddress(address entityAddress)
    public view returns (uint256[] memory, uint256[] memory,
                         uint256[] memory, uint256[] memory,
                         uint256[] memory)
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
      // Return the number of activations (number of activate tokens)
      tokenId = tokenOfOwnerByIndex(entityAddress, i);

      // Return activate information from tokenId and mappings
      resultEntityId[i] = (tokenId & EntityIdMask) >> EntityIdOffset; // entityID
      resultProductId[i] = (tokenId & ProductIdMask) >> ProductIdOffset; //productID,
      resultValue[i] = tokenId & (FlagsMask |      //flags
                                  ExpirationMask | //expiration
                                  ValueMask);      //value
      resultHash[i] = TokenIdToActivateId[tokenId]; // activation hash
      resultPrice[i] = TokenIdToOfferPrice[tokenId]; // offer price
    }

    return (resultEntityId, resultProductId, resultHash,
            resultValue, resultPrice);
  }

  /// @notice Return all license activation details for an entity
  /// Entity must be valid.
  /// @param entityIndex The entity to return activations for
  /// @return array of entity id of product activated
  /// @return array of product id of product activated
  /// @return array of current identifiers that are activated
  /// @return array of license value (flags, expiration value)
  /// @return array of price in tokens if for resale
  function activateAllDetails(uint256 entityIndex)
    external view returns (uint256[] memory, uint256[] memory,
                           uint256[] memory, uint256[] memory,
                           uint256[] memory)
  {
    // Convert entityId to address and call details-for-address
    return activateAllDetailsForAddress(
                        entityInterface.entityIndexToAddress(entityIndex));
  }

  /// @notice Return all license activation details of ecosystem
  /// May eventually exceed available size
  /// @return array of entity id of product activated
  /// @return array of product id of product activated
  /// @return array of current identifiers that are activated
  /// @return array of flags/expiration/value
  /// @return array of price in tokens if for resale
  function activateAllTokenDetails()
    external view returns (uint256[] memory, uint256[] memory,
                           uint256[] memory, uint256[] memory,
                           uint256[] memory)
  {
    // Allocate result array based on the number of activate tokens
    //   Using tokenId for result length since no more stack space
    uint256 tokenId = totalSupply();
    uint256[] memory resultEntityId = new uint256[](tokenId);
    uint256[] memory resultProductId = new uint256[](tokenId);
    uint256[] memory resultHash = new uint256[](tokenId);
    uint256[] memory resultValue = new uint256[](tokenId);
    uint256[] memory resultPrice = new uint256[](tokenId);

    // Build result arrays for all activations of an Entity
    for (uint i = 0; i < totalSupply(); ++i)
    {
      // Return the number of activations (number of activate tokens)
      tokenId = tokenByIndex(i);

      // Return activate information from tokenId and mappings
      resultEntityId[i] = (tokenId & EntityIdMask) >> EntityIdOffset; // entityID
      resultProductId[i] = (tokenId & ProductIdMask) >> ProductIdOffset; //productID,
      resultValue[i] = tokenId & (FlagsMask |      //flags
                                  ExpirationMask | //expiration
                                  ValueMask);      //value
      resultHash[i] = TokenIdToActivateId[tokenId]; // activation hash
      resultPrice[i] = TokenIdToOfferPrice[tokenId]; // offer price
    }

    return (resultEntityId, resultProductId, resultHash,
            resultValue, resultPrice);
  }

  // Pass through the overrides to inherited super class
  //   To add per-transfer fee's/logic in the future do so here
  function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, amount);
    }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }
}
