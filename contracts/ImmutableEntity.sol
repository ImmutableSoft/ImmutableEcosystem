pragma solidity >=0.7.6;
pragma abicoder v2;

// SPDX-License-Identifier: GPL-3.0-or-later

import "./StringCommon.sol";

// OpenZepellin upgradable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PullPaymentUpgradeable.sol";

/*
// OpenZepellin standard contracts
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";
*/

/* //ENS integration (old/deprecated)
import "./ImmutableResolver.sol";
import "@ensdomains/ens/contracts/ENS.sol";
import "./AddrResolver.sol";
*/

/// @title Immutable Entity - managed trust zone for the ecosystem
/// @author Sean Lawless for ImmutableSoft Inc.
/// @notice Token transfers use the ImmuteToken by default
/// @dev Entity variables and methods
contract ImmutableEntity is Initializable, OwnableUpgradeable,
                            PullPaymentUpgradeable
/*
contract ImmutableEntity is Initializable, Ownable, PullPayment*/
{
  // Error strings
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
    uint256 createTime;
  }

  // Array of current entity addresses, indexable by entity index
  mapping (uint256 => address) private EntityArray;

  // Array of entities, indexable by entity index
  mapping (uint256 => Entity) private Entities;
  uint256 NumberOfEntities;

  // External contract interfaces
  StringCommon private commonInterface;
  // Ethereum Name Service contract and variables
//  ImmutableResolver private resolver;

  // Entity interface events
  event entityEvent(uint256 entityIndex,
                    string name, string url);
  event entityTransferEvent(uint256 entityIndex, uint256 productIndex,
                            uint256 amount);

  /// @notice Contract initializer
  /// Executed on contract creation only.
  function initialize(address commonAddr) public initializer
  {
    __Ownable_init();
    __PullPayment_init();
/*
  // OpenZepellin standard contracts
  constructor(address commonAddr) Ownable()
                                  PullPayment()
  {
*/
    // Initialize string and token contract interfaces
    commonInterface = StringCommon(commonAddr);
  }

  ///////////////////////////////////////////////////////////
  /// ADMIN (onlyOwner)
  ///////////////////////////////////////////////////////////
/*
  /// @notice Set ENS resolver. Zero address disables resolver.
  /// Administrator (onlyOwner)
  /// @param resolverAddr the address of the immutable resolver
  function entityResolver(address resolverAddr, bytes32 rootNode)
    external onlyOwner
  {
    resolver = ImmutableResolver(resolverAddr);
    resolver.setRootNode(rootNode);
  }
*/

  /// @notice Update an entity status, non-zero value is approval.
  /// See ImmutableConstants.sol for status values and flags.
  /// Administrator (onlyOwner)
  /// @param entityIndex index of entity to change status
  /// @param status The new complete status aggregate value
  function entityStatusUpdate(uint256 entityIndex, uint256 status)
    external onlyOwner
  {
    // Update the organization status
    EntityStatus[entityIndex] = status;

/*
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
*/
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
  /// @return the new entity unique identifier (index)
  function entityCreate(string memory entityName,
                        string memory entityURL)
    public returns (uint256)
  {
    require(bytes(entityName).length != 0, "Entity name empty");
    require(bytes(entityURL).length != 0, "Entity URL empty");
    uint256 entityIndex = NumberOfEntities + 1;
    require(EntityIndex[msg.sender] == 0, "Entity already created");

    // Require the entity name be unique
    for (uint256 i = 1; i < NumberOfEntities + 1; ++i)
      require(!commonInterface/*StringCommon*/.stringsEqual(Entities[i].name, entityName),
              "Entity name already exists");

    // Push the entity to permenant storage on the blockchain
    Entities[entityIndex] = Entity(payable(msg.sender), address(0),
                address(0), entityName, "", entityURL, block.timestamp);

    // Push the address to the entity array and clear status
    EntityArray[entityIndex] = msg.sender;
    EntityStatus[entityIndex] = 0;
    EntityIndex[msg.sender] = entityIndex; // glbal entity id
    NumberOfEntities++;

    // Emit entity event: id, name and URL
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
    require(entityIndex > 0, "Sender is not an entity");

    // Require the new entity name be unique
    for (uint256 i = 0; i < NumberOfEntities; ++i)
    {
      // Skip the duplicate name check for sender entity
      //   ie. Allow only URL to be changed
      if (i != entityIndex)
        require(!commonInterface/*StringCommon*/.stringsEqual(Entities[i].name,
                entityName), "Entity name already exists");
    }

    // Update entity name and/or URL
    Entities[entityIndex].name = entityName;
    Entities[entityIndex].infoURL = entityURL;

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
    require(entityIndex > 0, commonInterface.EntityIsZero());
    Entity storage entity = Entities[entityIndex];

    // Only a validated entity can configue a bank address
    require(entityAddressStatus(msg.sender) > 0, commonInterface.EntityNotValidated());
    require(newBank != address(0), "Bank cannot be zero");
    entity.bank = newBank;
  }

  /// @notice Propose to move an entity (change addresses).
  /// To complete move, call entityMoveAddress with new address.
  /// msg.sender must be a registered entity.
  /// @param nextAddress The next address of the entity
  function entityAddressNext(address nextAddress)
    external
  {
    uint256 entityIndex = EntityIndex[msg.sender];
    require(entityIndex > 0, commonInterface.EntityIsZero());
    Entity storage entity = Entities[entityIndex];

    // Ensure next address and status and status are valid
    require(msg.sender != nextAddress, "Next address not different");
    require(nextAddress != address(0), "Next address is zero");
    require(entityAddressStatus(msg.sender) > 0, commonInterface.EntityNotValidated());

    // Require next address to have no entity configured
    require(EntityIndex[nextAddress] == 0, "Next address in use");

    // Assign the new address to the organization
    entity.nextAddress = nextAddress;
  }

  /// @notice Admin override for moving an entity (change addresses).
  /// To complete move call entityMoveAddress with new address.
  /// msg.sender must be Administrator (owner).
  /// @param entityAddress The address of the entity to move
  /// @param nextAddress The next address of the entity
  function entityAdminAddressNext(address entityAddress,
                                  address nextAddress)
    external onlyOwner
  {
    uint256 entityIndex = EntityIndex[entityAddress];
    require(entityIndex > 0, commonInterface.EntityIsZero());
    Entity storage entity = Entities[entityIndex];

    // Ensure next address is valid
    require(entityAddress != nextAddress, "Next address not different");
    require(nextAddress != address(0), "Next address is zero");
    // Require next address to have no entity configured
    require(EntityIndex[nextAddress] == 0, "Next address in use");

    // Assign the new address to the organization
    entity.nextAddress = nextAddress;
  }

  /// @notice Finish moving an entity (change addresses).
  /// First call entityNextAddress with previous address.
  /// msg.sender must be new entity address set with entityNextAddress.
  /// @param oldAddress The previous address of the entity
  function entityAddressMove(address oldAddress)
    external
  {
    uint256 entityIndex = EntityIndex[oldAddress];
    require(entityIndex > 0, commonInterface.EntityIsZero());
    Entity storage entity = Entities[entityIndex];
    require(entity.nextAddress == msg.sender, "Next address not sender");
    uint256 entityStatus = entityAddressStatus(oldAddress);
    require(entityStatus > 0, commonInterface.EntityNotValidated());

    // Assign the indexing for the new address
    EntityIndex[msg.sender] = entityIndex;
    // Clear the old address
    EntityIndex[oldAddress] = 0;
    EntityArray[entityIndex] = msg.sender;
    entity.prevAddress = oldAddress;

    // If old bank address was adminstrator, move bank to new address
    if (entity.bank == oldAddress)
      entity.bank = payable(msg.sender);
  }

  /// @notice Withdraw all payments (ETH) into entity bank.
  /// Uses OpenZeppelin PullPayment interface.
  function entityPaymentsWithdraw()
    external
  {
    uint256 entityIndex = EntityIndex[msg.sender];
    require(entityIndex > 0, commonInterface.EntityIsZero());
    Entity storage entity = Entities[entityIndex];
    uint256 entityStatus = entityAddressStatus(msg.sender);
    require(entityStatus > 0, commonInterface.EntityNotValidated());

    // Ensure entity has a configured bank
    require(entity.bank != address(0), "Bank address zero");

    if (payments(entity.bank) > 0)
      withdrawPayments/*WithGas*/(entity.bank);
  }

  /// @notice Transfer ETH to an entity.
  /// Entity must exist and have bank configured.
  /// Payable, requires ETH transfer.
  /// msg.sender is the payee
  /// @param entityIndex The index of entity recipient bank
  function entityTransfer(uint256 entityIndex, uint256 productIndex)
    public payable
  {
    uint256 entityStatus = entityIndexStatus(entityIndex);
    require(entityIndex > 0, commonInterface.EntityIsZero());
    Entity storage entity = Entities[entityIndex];

    require(entityStatus > 0, commonInterface.EntityNotValidated());
    require(msg.value > 0, "ETH value zero");
    require(entity.bank != address(0), BankNotConfigured);

    // Transfer ETH funds
    _asyncTransfer(entity.bank, msg.value);

    // Send event for transfer
    emit entityTransferEvent(entityIndex, productIndex, msg.value);
  }

  /// @notice Retrieve official entity status.
  /// Status of zero (0) return if entity not found.
  /// @param entityIndex The index of the entity
  /// @return the entity status as maintained by Immutable
  function entityIndexStatus(uint256 entityIndex)
    public view returns (uint256)
  {
    if ((entityIndex > 0) && (entityIndex <= NumberOfEntities))
      return EntityStatus[entityIndex];
    else
      return 0;
  }

  /// @notice Retrieve official entity status.
  /// Status of zero (0) return if entity not found.
  /// @param entityAddress The address of the entity
  /// @return the entity status as maintained by Immutable
  function entityAddressStatus(address entityAddress)
    public view returns (uint256)
  {
    uint256 entityIndex = EntityIndex[entityAddress];

    return entityIndexStatus(entityIndex);
  }

  /// @notice Retrieve official global entity index.
  /// Return index of zero (0) is not found.
  /// @param entityAddress The address of the entity
  /// @return the entity index as maintained by Immutable
  function entityAddressToIndex(address entityAddress)
    public view returns (uint256)
  {
    return EntityIndex[entityAddress];
  }

  /// @notice Retrieve current global entity address.
  /// Return address of zero (0) is not found.
  /// @param entityIndex The global index of the entity
  /// @return the current entity address as maintained by Immutable
  function entityIndexToAddress(uint256 entityIndex)
    public view returns (address)
  {
    if ((entityIndex == 0) || (entityIndex > NumberOfEntities))
      return (address(0));
    return EntityArray[entityIndex];
  }

  /// @notice Retrieve entity details from index.
  /// @param entityIndex The index of the entity
  /// @return name and URL are return values.\
  ///         **name** the entity name\
  ///         **URL** the entity name\
  function entityDetailsByIndex(uint256 entityIndex)
    public view returns (string memory name, string memory URL)
  {
    if ((entityIndex == 0) || (entityIndex > NumberOfEntities))
      return ("", "");
    Entity storage entity = Entities[entityIndex];

    // Return the name and URL for this organization
    return (entity.name, entity.infoURL);
  }

  /// @notice Retrieve number of entities.
  /// @return the number of entities
  function entityNumberOf()
    public view returns (uint256)
  {
    return NumberOfEntities;
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
    Entity storage entity = Entities[entityIndex];
    uint256 entityStatus = entityAddressStatus(msg.sender);
    require(entityStatus > 0, commonInterface.EntityNotValidated());

    // Return zero if bank is unconfigured
    if (entity.bank == address(0))
      return 0;

    // Return the amount of ETH payments accumulated
    return payments(entity.bank);
  }

/*
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
*/

  /// @notice Retrieve all entity details
  /// Status of empty arrays if none found.
  /// @return status , name and URL arrays are return values.\
  ///         **status** Array of entity status\
  ///         **name** Array of entity names\
  ///         **URL** Array of entity URLs
  function entityAllDetails()
    external view returns (uint256[] memory status, string[] memory name,
                           string[] memory URL)
  {
    uint256[] memory resultStatus = new uint256[](NumberOfEntities);
    string[] memory resultName = new string[](NumberOfEntities);
    string[] memory resultURL = new string[](NumberOfEntities);

    for (uint i = 1; i <= NumberOfEntities; ++i)
    {
      resultStatus[i - 1] = EntityStatus[i];
      resultName[i- 1] = Entities[i].name;
      resultURL[i - 1] = Entities[i].infoURL;
    }

    return (resultStatus, resultName, resultURL);
  }
}
