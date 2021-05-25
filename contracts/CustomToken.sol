pragma solidity ^0.8.4;

// SPDX-License-Identifier: UNLICENSED

/*
//For truffle testing
import "@openzeppelin/contracts/ownership/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20DetailedUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20MintableUpgradeable.sol";
*/

// For upgradable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
//import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Mintable.sol";

contract CustomToken is Initializable, OwnableUpgradeable, ERC20Upgradeable// ERC20Detailed//, ERC20Mintable
{

  /*constructor() public ERC20Detailed("CustomToken", "CuT", 18)
                                     ERC20Mintable()
  {
  */
  function initialize() public initializer
  {
    __Ownable_init();//.initialize(msg.sender);
//    ERC20Mintable.initialize(msg.sender);
    __ERC20_init("CustomToken", "CuT");

    _mint(msg.sender, 1000000000000000000);
  }
}
