pragma solidity 0.5.16;

import "./StringCommon.sol";
import "./ImmuteToken.sol";
import "./ImmutableConstants.sol";
import "./ImmutableResolver.sol";

//import "@ensdomains/ens/contracts/ENS.sol";
//import "./AddrResolver.sol";

/// Comments within /*  */ are for toggling upgradable contracts */

/// @title Immutable Entity - managed trust zone for the ecosystem
/// @author Sean Lawless for ImmutableSoft Inc.
/// @notice Token transfers use the ImmuteToken by default
/// @dev Entity variables and methods
contract ImmutableEntity is /*Initializable,*/ Ownable, PullPayment,
                               ImmutableConstants
{
  // Bonus token constants
  uint256 constant ReferralEntityBonus =        4000000000000000000; //  4 IuT
  uint256 constant ReferralSubscriptionBonus = 40000000000000000000; // 40 IuT
  uint256 constant EntitySubscriptionBonus =   80000000000000000000; // 80 IuT

  // Error strings
  string constant EntityNotValid = "Entity not valid";
  string constant EntityIsZero = "EntityID zero";
  string constant EntityNotValidated = "Entity not validated";
  string constant BankNotConfigured = "Bank not configured";

  // Mapping between the organization address and the global entity index
  mapping (address => uint256) private EntityIndex;

  // Mapping between the entity index and the entity status
  mapping (uint256 => uint256) private EntityStatus;

  // Organizational entity
  struct Entity
  {
    address payable bank;
    address prevAddress;
    address nextAddress;
    string name;
    string entityEnsName;
    string infoURL;
    uint256 numberOfOffers;
    uint256 numberOfLicenses;
    uint256 escrow;
    address erc20Token;
    uint256 referral;
    uint256 createTime;
    mapping(uint => TokenBlockOffer) offers;
  }

  // Offer of tokens for resale
  struct TokenBlockOffer
  {
    uint256 rate;
    uint256 blockSize;
    uint256 escrow;
  }

  // Array of current entity addresses, indexable by local entity index
  //   ie. local entity index equals global entity index - 1
  address[] private EntityArray;

  // Array of entities, indexable by local entity index
  Entity[] private Entities;

  // External contract interfaces
  ImmuteToken private tokenInterface;
  StringCommon private commonInterface;
  // Ethereum Name Service contract and variables
  ImmutableResolver private resolver;

  // Entity interface events
  event entityEvent(uint256 entityIndex,
                    string name, string url);
  event entityTokenBlockOfferEvent(uint256 entityIndex, uint rate,
                                   uint tokens, uint amount);
  event entityTokenBlockPurchaseEvent(address indexed purchaserAddress,
                              uint256 entityIndex, uint rate,
                              uint tokens, uint amount);

  /// @notice Contract initializer/constructor.
  /// Executed on contract creation only.
  /// @param immuteToken the address of the IuT token contract
  /// @param commonAddr the address of the CommonString contract
  constructor(address immuteToken, address commonAddr)
    public PullPayment()
  {
/*  function initialize(address immuteToken, address commonAddr) initializer public
  {
    Ownable.initialize(msg.sender);
    PullPayment.initialize();
*/
    // Initialize string and token contract interfaces
    commonInterface = StringCommon(commonAddr);
    tokenInterface = ImmuteToken(immuteToken);
  }

  ///////////////////////////////////////////////////////////
  /// ADMIN (onlyOwner)
  ///////////////////////////////////////////////////////////

  /// @notice Set ImmutableSoft ENS resolver. A zero address disables resolver.
  /// Administrator (onlyOwner)
  /// @param resolverAddr the address of the immutable resolver
  function entityResolver(address resolverAddr, bytes32 rootNode)
    external onlyOwner
  {
    resolver = ImmutableResolver(resolverAddr);
    resolver.setRootNode(rootNode);
  }

  /// @notice Update an entity status, non-zero value is approval.
  /// See ImmutableConstants.sol for status values and flags.
  /// Administrator (onlyOwner)
  /// @param entityIndex index of entity to change status
  /// @param status The new complete status aggregate value
  function entityStatusUpdate(uint256 entityIndex, uint status)
    external onlyOwner
  {
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];
    uint256 previousStatus = EntityStatus[entityIndex];

    // Update the organization status
    EntityStatus[entityIndex] = status;

    // If ENS configured, add resolver
    if (address(resolver) != address(0))
    {
      // Register entity with ENS: <entityName>.immutablesoft.eth
      string memory normalName = commonInterface.normalizeString(entity.name);
      bytes32 subnode = commonInterface.namehash(entityRootNode(),
                          commonInterface.stringToBytes32(normalName));

      // Set address for node, owner to entity address and name to
      //   normalized name string.
      resolver.setAddr(subnode, EntityArray[entityIndex]);
//      setName(subnode, normalName);
      entity.entityEnsName = normalName;
    }

    // If entity is new then apply any token bonus
    if ((previousStatus == 0) && (entity.createTime < now + 30 days))
    {
      // Check if a subscription
      if (((status & Automatic) == Automatic) ||
          ((status & CustomToken) == CustomToken))
      {
        // Subscription entities get a minted token bonus
        tokenInterface.mint(EntityArray[entityIndex],
                            EntitySubscriptionBonus);

        // Subscription referrals get a minted token bonus
        if (entity.referral > 0)
          tokenInterface.mint(EntityArray[entity.referral - 1],
                              ReferralSubscriptionBonus);
      }

      // Otherwise if referral mint standard entity bonus
      else if (entity.referral > 0)

      {
        // Pay out 4 token escrow amount to the referral
        tokenInterface.mint(EntityArray[entity.referral - 1],
                            ReferralEntityBonus);
      }
    }
  }

  /// @notice Update entity with custom ERC20.
  /// Must NOT be called if entity has existing product sales escrow.
  /// Entity requires prior approval with custom token status.
  /// Administrator (onlyOwner)
  /// @param entityIndex The entity global index
  /// @param tokenAddress The custom ERC20 contract address
  function entityCustomToken(uint256 entityIndex, address tokenAddress)
    external onlyOwner
  {
    uint256 entityStatus = entityIndexStatus(entityIndex);
    entityIndex = entityIdToLocalId(entityIndex);
    require((entityStatus & CustomToken) == CustomToken,
            "CustomToken required");

    // Assign the custom ERC20 token address
    Entities[entityIndex].erc20Token = tokenAddress;
  }

  ///////////////////////////////////////////////////////////
  /// Ecosystem is split into entity, product and license
  ///////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////
  /// ENTITY
  ///////////////////////////////////////////////////////////

  /// @notice Create an organization.
  /// Entities require approval (entityStatusUpdate) after create.
  /// @param entityName The legal name of the entity
  /// @param entityURL The valid URL of the entity
  function entityCreate(string memory entityName,
                        string memory entityURL,
                        uint256 referralEntityIndex)
    public returns (uint256)
  {
    require(bytes(entityName).length != 0, "Entity name empty");
    require(bytes(entityURL).length != 0, "Entity URL empty");
    uint256 entityIndex = Entities.length + 1;
    require(EntityIndex[msg.sender] == 0, "Entity already created");

    // Require the entity name is unique
    for (uint i = 0; i < Entities.length; ++i)
      require(!commonInterface.stringsEqual(Entities[i].name, entityName),
              "Entity name already exists");

    // Push the entity to permenant storage on the blockchain
    Entities.push(Entity(address(0),address(0), address(0), entityName,
                         "", entityURL, 0, 0, 0, address(0),
                         referralEntityIndex, now));

    EntityIndex[msg.sender] = entityIndex;
    // Push the address to the entity array and clear status
    EntityArray.push(msg.sender);
    EntityStatus[entityIndex] = 0;

    // Emit entity event
    emit entityEvent(entityIndex, entityName, entityURL);
    return entityIndex;
  }

  /// @notice Update an organization.
  /// Entities require reapproval (entityStatusUpdate) after update.
  /// @param entityName The legal name of the entity
  /// @param entityURL The valid URL of the entity
  function entityUpdate(string calldata entityName,
                        string calldata entityURL)
    external
  {
    require(bytes(entityName).length != 0, "Entity name empty");
    require(bytes(entityURL).length != 0, "Entity URL empty");
    uint256 entityIndex = EntityIndex[msg.sender];
    require(entityIndex > 0, "Sender is not an entity owner");
    entityIndex = entityIndex - 1;

    // Update entity name and/or URL
    Entities[entityIndex].name = entityName;
    Entities[entityIndex].infoURL = entityURL;

    // Clear referral so re-validation does not trigger bonus
    Entities[entityIndex].referral = 0;

    // Clear the entity status as re-validation required
    EntityStatus[entityIndex] = 0;

    // Emit entity event
    emit entityEvent(entityIndex, entityName, entityURL);
  }

  /// @notice Change bank address that contract pays out to.
  /// msg.sender must be a registered entity.
  /// @param newBank payable Ethereum address owned by entity
  function entityBankChange(address payable newBank)
    external
  {
    uint256 entityIndex = EntityIndex[msg.sender];
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];

    // Only a validated entity can configue a bank address
    require(entityAddressStatus(msg.sender) > 0, EntityNotValidated);
    require(newBank != address(0), "Bank cannot be zero");
    entity.bank = newBank;
  }

  /// @notice Propose to move an entity (change addresses).
  /// To complete move, call entityMoveAddress with new address.
  /// msg.sender must be a registered entity.
  /// @param nextAddress The next address of the entity
  /// @param numTokens The number of tokens to move to the new address
  function entityAddressNext(address nextAddress, uint256 numTokens)
    external
  {
    uint256 entityIndex = EntityIndex[msg.sender];
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];

    // Ensure tokens are available and next address is valid
    require(tokenInterface.balanceOf(msg.sender) >= numTokens, "Too many tokens");
    require(msg.sender != nextAddress, "Next address not different");
    require(nextAddress != address(0), "Next address is zero");
    require(entityAddressStatus(msg.sender) > 0, EntityNotValidated);

    // Require next address to have no entity configured
    require(EntityIndex[nextAddress] == 0, "Next address in use");

    // Assign the new address to the organization
    entity.nextAddress = nextAddress;

    // Transfer tokens to the contract escrow
    if (numTokens > 0)
    {
      if (tokenInterface.transferFrom(msg.sender, address(this), numTokens))
        entity.escrow = numTokens;
      else
        revert("Token transfer failed");
    }
  }

  /// @notice Admin override for moving an entity (change addresses).
  /// To complete move call entityMoveAddress with new address.
  /// msg.sender must be Administrator (owner).
  /// @param entityAddress The address of the entity to move
  /// @param nextAddress The next address of the entity
  /// @param numTokens The number of tokens to move to the new address
  function entityAdminAddressNext(address entityAddress,
                                address nextAddress, uint256 numTokens)
    external onlyOwner
  {
    uint256 entityIndex = EntityIndex[entityAddress];
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];

    // Ensure tokens are available and next address is valid
    require(tokenInterface.balanceOf(entityAddress) >= numTokens,
            "Too many tokens");
    require(entityAddress != nextAddress, "Next address not different");
    require(nextAddress != address(0), "Next address is zero");
    // Require next address to have no entity configured
    require(EntityIndex[nextAddress] == 0, "Next address in use");

    // Assign the new address to the organization
    entity.nextAddress = nextAddress;

    // Transfer tokens to the contract escrow
    if (numTokens > 0)
    {
      if (tokenInterface.transferFrom(entityAddress, address(this), numTokens))
        entity.escrow = numTokens;
      else
        revert("Token transfer failed");
    }
  }

  /// @notice Finish moving an entity (change addresses).
  /// First call entityNextAddress with previous address.
  /// msg.sender must be new entity address set with entityNextAddress.
  /// @param oldAddress The previous address of the entity
  function entityAddressMove(address oldAddress)
    external
  {
    uint256 entityIndex = EntityIndex[oldAddress];
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];
    require(entity.nextAddress == msg.sender, "Next address not sender");
    uint256 entityStatus = entityAddressStatus(oldAddress);
    require(entityStatus > 0, EntityNotValidated);

    // Assign the indexing for the new address
    EntityIndex[msg.sender] = entityIndex + 1;
    // Clear the old address
    EntityIndex[oldAddress] = 0;
    EntityArray[entityIndex] = msg.sender;
    entity.prevAddress = oldAddress;

    // All the products and releases are unchanged

    // Move tokens if any in escrow
    if (entity.escrow > 0)
    {
      // Transfer tokens out of escrow into the new account
      if (tokenInterface.transfer(msg.sender, entity.escrow))
        entity.escrow = 0;
      else
        revert("Token transfer failed");
    }
  }

  /// @notice Withdraw all payments (ETH) into entity bank.
  /// Uses OpenZeppelin PullPayment interface.
  function entityPaymentsWithdraw()
    external
  {
    uint256 entityIndex = EntityIndex[msg.sender];
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];
    uint256 entityStatus = entityAddressStatus(msg.sender);
    require(entityStatus > 0, EntityNotValidated);

    // Ensure entity has a configured bank
    require(entity.bank != address(0), "Bank address zero");

    if (payments(entity.bank) > 0)
      withdrawPayments/*WithGas*/(entity.bank);
  }

  /// @notice Offer a block of tokens in exchange for ETH.
  /// Purchasers can buy any multiple of 'tokens' up to 'count'.
  /// 'tokens' multipled by 'count' will be escrowed in offer.
  /// msg.sender must be a registered entity.
  /// @param rate The rate of exchange (multiplyer of ETH)
  /// @param tokens The minimum multiplyer of tokens offered
  /// @param count The number of blocks, or 'tokens' amounts
  function entityTokenBlockOffer(uint256 rate, uint256 tokens,
                                 uint256 count)
    external
  {
    uint256 amount = tokens * count;
    uint256 entityIndex = EntityIndex[msg.sender];
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];
    require(entityAddressStatus(msg.sender) > 0, EntityNotValidated);
    require(rate >= tokenInterface.currentRate(), "Rate less than currentRate");

    // Ensure entity has a configured bank
    require(entity.bank != address(0), BankNotConfigured);

    // Transfer tokens to the contract escrow
    if (tokenInterface.transferFrom(msg.sender, address(this), amount))
    {
      uint i;
      for (i = 0; i < entity.numberOfOffers; ++i)
      {
        // Reuse an old offer if escrow empty
        if (entity.offers[i].escrow == 0)
          break;
      }
      if (i == entity.numberOfOffers)
        ++entity.numberOfOffers;

      entity.offers[i] = TokenBlockOffer(rate, tokens, amount);
      emit entityTokenBlockOfferEvent(entityIndex + 1, rate, tokens, amount);
    }
    else
      revert("TransferFrom failed");

  }

  /// @notice Revoke a previous offer of a block of tokens.
  /// Offer must already exist and owned by msg.sender.
  /// @param offerIndex The identifier of the offer to revoke
  function entityTokenBlockOfferRevoke(uint offerIndex)
    external
  {
    uint256 entityIndex = EntityIndex[msg.sender];
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];

    require(entityAddressStatus(msg.sender) > 0, EntityNotValidated);
    require(entity.numberOfOffers > offerIndex, OfferNotFound);

    // Transfer offer escrow tokens back to the entity
    if (tokenInterface.transfer(msg.sender, entity.offers[offerIndex].escrow))
    {
      uint256 rate = entity.offers[offerIndex].rate;
      uint256 blockSize = entity.offers[offerIndex].blockSize;

      // Zero out the token offer
      entity.offers[offerIndex] = TokenBlockOffer(0, 0, 0);
      if (offerIndex == entity.numberOfOffers - 1)
        entity.numberOfOffers--;

      // Event of zero number of blocks signifies a revoke
      emit entityTokenBlockOfferEvent(entityIndex + 1, rate, blockSize, 0);
    }
    else
      revert("Tranfer failed");
  }

  /// @notice Transfer ETH to an entity.
  /// Entity must exist and have bank configured.
  /// Payable, requires ETH transfer.
  /// msg.sender is the payee
  /// @param entityIndex The index of entity recipient bank
  function entityTransfer(uint256 entityIndex)
    public payable
  {
    uint256 entityStatus = entityIndexStatus(entityIndex);
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];
    uint256 fee = 0;

    require(entityStatus > 0, EntityNotValidated);
    require(msg.value > 0, "ETH value zero");
    require(entity.bank != address(0), BankNotConfigured);

    // If not an Automation entity subtract the 5% fee
    if ((entityStatus & Automatic) != Automatic)
      fee = (msg.value * 5) / 100;

    // Transfer ETH funds minus the fee if any
    _asyncTransfer(entity.bank, msg.value - fee);

    // If a fee charged, transfer it to Immutable escrow bank
    if (fee > 0)
      tokenInterface.transferToEscrow.value(fee)();
  }

  /// @notice Purchase an block of tokens offered for ETH.
  /// Offer must already exist. Payable, requires ETH transfer.
  /// msg.sender is the purchaser.
  /// @param entityIndex The index of the entity with offer
  /// @param offerIndex The specific offer
  /// @param count The number of blocks of the offer to purchase
  function entityTokenBlockPurchase(uint256 entityIndex,
                                    uint offerIndex, uint count)
    external payable
  {
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];
    require(EntityStatus[entityIndex] > 0, EntityNotValidated);
    require(entity.numberOfOffers > offerIndex, OfferNotFound);
    uint256 numTokens = entity.offers[offerIndex].blockSize * count;

    // Ensure enough ETH was sent to purchase the tokens
    require(msg.value * entity.offers[offerIndex].rate >= numTokens,
            "Not enough ETH");

    // Ensure entity has a configured bank
    require(entity.bank != address(0), BankNotConfigured);

    require(entity.offers[offerIndex].escrow >= numTokens,
            "Not enough tokens in escrow");

    // Transfer the ETH to the offering entity bank
    _asyncTransfer(entity.bank, msg.value);

    // Transfer tokens to the purchaser
    if (tokenInterface.transfer(msg.sender, numTokens))
    {
      // Reduce offer escrow
      if (entity.offers[offerIndex].escrow == numTokens)
      {
        entity.offers[offerIndex].escrow = 0;

        // If last offer, decrease the numberOfOffers
        if (offerIndex == entity.numberOfOffers - 1)
          entity.numberOfOffers--;
      }
      else
        entity.offers[offerIndex].escrow -= numTokens;

      // Send an event for the purchase
      emit entityTokenBlockPurchaseEvent(msg.sender, entityIndex + 1,
                                        entity.offers[offerIndex].rate,
                           entity.offers[offerIndex].blockSize, count);
    }
    else
      revert("Transfer failed");
  }

  /// All entity functions below are view type (read only)

  /// @notice Return the local entity ID (index).
  /// Entity must exist and id be valid.
  /// @param entityIndex The global index of the entity
  /// @return The local index of the entity
  function entityIdToLocalId(uint256 entityIndex)
    public view returns (uint256)
  {
    require(entityIndex > 0, EntityIsZero);
    require(entityIndex <= entityNumberOf(), EntityNotValid);

    return entityIndex - 1;
  }

  /// @notice Retrieve official entity status.
  /// Status of zero (0) return if entity not found.
  /// @param entityIndex The index of the entity
  /// @return the entity status as maintained by Immutable
  function entityIndexStatus(uint256 entityIndex)
    public view returns (uint)
  {
    if ((entityIndex > 0) && (entityIndex <= Entities.length))
      return EntityStatus[entityIndex - 1];
    else
      return 0;
  }

  /// @notice Retrieve official entity status.
  /// Status of zero (0) return if entity not found.
  /// @param entityAddress The address of the entity
  /// @return the entity status as maintained by Immutable
  function entityAddressStatus(address entityAddress)
    public view returns (uint)
  {
    uint256 entityIndex = EntityIndex[entityAddress];

    return entityIndexStatus(entityIndex);
  }

  /// @notice Retrieve official global entity index.
  /// Return index of zero (0) is not found.
  /// @param entityAddress The address of the entity
  /// @return the entity index as maintained by Immutable
  function entityAddressToIndex(address entityAddress)
    public view returns (uint)
  {
    return EntityIndex[entityAddress];
  }

  /// @notice Retrieve entity details from index.
  /// @param entityIndex The index of the entity
  /// @return the entity name
  /// @return the entity URL
  function entityDetailsByIndex(uint256 entityIndex)
    public view returns (string memory, string memory)
  {
    if ((entityIndex == 0) || (entityIndex > Entities.length))
      return ("", "");
    Entity storage entity = Entities[entityIndex - 1];
    string memory name;
    string memory infoURL;

    // Return the name and URL for this organization
    infoURL = entity.infoURL;
    name = entity.name;
    return (name, infoURL);
  }

  /// @notice Retrieve entity referral details.
  /// @param entityIndex The index of the entity
  /// @return the entity referral
  /// @return the entity creation date
  function entityReferralByIndex(uint256 entityIndex)
    public view returns (address, uint256)
  {
    // Return empty referral if entityIndex invalid
    if ((entityIndex == 0) || (entityIndex > Entities.length))
      return (address(0), 0);
    Entity storage entity = Entities[entityIndex - 1];

    // Return empty referral if referral not set or invalid
    if ((entity.referral == 0) || (entity.referral > Entities.length))
      return (address(0), 0);

    // Return referral address and creation time
    return (EntityArray[entity.referral - 1], entity.createTime);
  }

  /// @notice Retrieve number of entities.
  /// @return the number of entities
  function entityNumberOf()
    public view returns (uint256)
  {
    return Entities.length;
  }

  /// @notice Return the number of token offers for an entity.
  /// Entity must exist and index be valid.
  /// @param entityIndex The index of the entity
  /// @return the current number of token offers
  function entityNumberOfOffers(uint256 entityIndex)
    external view returns (uint)
  {
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];

    // Return the number of products for this entity
    return entity.numberOfOffers;
  }

  /// @notice Retrieve details of a token offer.
  /// Returns empty name and URL if not found.
  /// @param entityIndex The index of the entity to lookup
  /// @return the ETH to token exchange rate
  /// @return the block size
  /// @return the remaining size of escrow
  function entityOfferDetails(uint256 entityIndex,
                              uint offerId)
    external view returns (uint256, uint256, uint256)
  {
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];

    require(entity.numberOfOffers > offerId, OfferNotFound);

    // Return the name and URL for this organization
    return (entity.offers[offerId].rate,
            entity.offers[offerId].blockSize,
            entity.offers[offerId].escrow);
  }

  /// @notice Check payment (ETH) due entity bank.
  /// Uses OpenZeppelin PullPayment interface.
  /// @return the amount of ETH in the entity escrow
  function entityPaymentsCheck()
    external view returns (uint256)
  {
    uint256 entityIndex = EntityIndex[msg.sender];
    if (entityIndex == 0)
      return 0;
    entityIndex = entityIdToLocalId(entityIndex);
    Entity storage entity = Entities[entityIndex];
    uint256 entityStatus = entityAddressStatus(msg.sender);
    require(entityStatus > 0, EntityNotValidated);

    // Return zero if bank is unconfigured
    if (entity.bank == address(0))
      return 0;

    // Return the amount of ETH payments accumulated
    return payments(entity.bank);
  }

  /// @notice Return the entity custom ERC20 contract address.
  /// @param entityIndex The index of the entity to lookup
  /// @return the entity custom ERC20 token or zero address
  function entityCustomTokenAddress(uint256 entityIndex)
    external view returns (address)
  {
    if (entityIndex > 0)
      return Entities[entityIndex - 1].erc20Token;
    else
      return address(0);
  }

  /// @notice Return ENS immutablesoft root node.
  /// @return the bytes32 ENS root node for immutablesoft.eth
  function entityRootNode()
    public view returns (bytes32)
  {
    if (address(resolver) != address(0))
      return resolver.rootNode();
    else
      return 0;
  }

}
