pragma solidity 0.5.16;

//For truffle testing
//import "@openzeppelin/contracts/ownership/Ownable.sol";


// For upgradable contracts
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";

import "@ensdomains/ens/contracts/ENS.sol";
import "./AddrResolver.sol";
import "./ImmutableEntity.sol";

/// Comments within /*  */ are for toggling upgradable contracts */

/// @title Immutable Resolver- resolve immutablesoft.eth addresses
/// @author Sean Lawless for ImmutableSoft Inc.
/// @notice Inherits ENS example AddrResolver
contract ImmutableResolver is Initializable, Ownable, AddrResolver
{
  // Ethereum Name Service contract and variables
  ENS private ens;
  address private ensAddress;
  bytes32 private root;

  // Immutable string and entity contract interfaces
  ImmutableEntity private entityInterface;

  /// @notice ImmutableResolver contract initializer/constructor.
  /// Executed on contract creation only.
  /// @param entityAddr is address of ImmutableEntity contract
  /// @param ensAddr is address of the ENS contract
/*  constructor(address entityAddr, address ensAddr) public
  {
*/
  function initialize(address entityAddr, address ensAddr) public initializer
  {
    Ownable.initialize(msg.sender);

    require(ensAddr != address(0));
    require(entityAddr != address(0));

    // Initialize immutable entity contract interface
    entityInterface = ImmutableEntity(entityAddr);
    ensAddress = ensAddr;
    ens = ENS(ensAddr);
  }

  /// @notice ENS authorization check.
  /// Executed on ENS resolver calls
  /// The parameter is unused as this is an owned resolver
  /// @return true if msg.sender is owner, false otherwise
  function isAuthorised(bytes32) internal view returns(bool)
  {
    return (msg.sender == owner());
  }
  
  /// @notice Sets the ENS immutablesoft root node
  /// @param rootNode is bytes32 ENS root node for immutablesoft.eth
  function setRootNode(bytes32 rootNode)
    public
  {
    // Initialize resolver root node to contract address
    setAddr(root, address(this));
    root = rootNode;
  }

  /// @notice Return ENS immutablesoft root node
  /// @return the bytes32 ENS root node for immutablesoft.eth
  function rootNode()
    public view returns (bytes32)
  {
    // return the root node
    return root;
  }

}
