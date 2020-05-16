pragma solidity 0.5.16;

/*
//For truffle testing
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";
*/

// For upgradable contracts
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol";

contract CustomToken is Ownable, ERC20Detailed, ERC20Mintable
{

  /*constructor() public ERC20Detailed("CustomToken", "CuT", 18)
                                     ERC20Mintable()
  {
  */
  function initialize() public initializer
  {
    Ownable.initialize(msg.sender);
    ERC20Mintable.initialize(msg.sender);
    ERC20Detailed.initialize("CustomToken", "CuT", 18);

    _mint(msg.sender, 1000000000000000000);
  }
}
