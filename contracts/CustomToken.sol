pragma solidity ^0.8.4;

// SPDX-License-Identifier: GPL-3.0-or-later

// OpenZeppelin upgradable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract CustomToken is Initializable, OwnableUpgradeable, ERC20Upgradeable
{
  function initialize() public initializer
  {
    __Ownable_init();//.initialize(msg.sender);
    __ERC20_init("CustomToken", "CuT");

    _mint(msg.sender, 1000000000000000000);
  }
}
