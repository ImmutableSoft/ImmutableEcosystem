pragma solidity >=0.7.6;

// SPDX-License-Identifier: GPL-3.0-or-later

// OpenZeppelin upgradable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

/*
// OpenZepellin standard contracts
//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
*/

contract CustomToken is Initializable, OwnableUpgradeable, ERC20Upgradeable
//contract CustomToken is Ownable, ERC20
{

  function initialize() public initializer
  {
    __Ownable_init();//.initialize(msg.sender);
    __ERC20_init("CustomToken", "CuT");
/*
  constructor() Ownable()
                ERC20("CustomToken", "CuT")
  {
*/
    _mint(msg.sender, 1000000000000000000);
  }
}
