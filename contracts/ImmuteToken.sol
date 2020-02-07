pragma solidity 0.5.16;

//For truffle testing
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";
import "@openzeppelin/contracts/payment/PullPayment.sol";

/*
// For upgradable contracts
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Pausable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/payment/PullPayment.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
*/

import "./ImmutableEntity.sol";

/// @title Immute (IuT) token, restricted ERC20 (FinHub guidance)
/// @author Sean Lawless for ImmutableSoft Inc.
/// @notice Token transfers allowed with ImmutableEcosystem only
/// @dev All transfers reset approval of all tokens to ecosystem
contract ImmuteToken is /*Initializable,*/ Ownable, /*ERC20,*/ ERC20Detailed,
                   ERC20Mintable, ERC20Pausable, PullPayment
{
  uint256 constant MaxPromos = 5;

  struct Promo
  {
    uint256 algoX;
    uint256 algoY;
    uint256 base;
  }

  address payable private bank;
  address private entityAddr;
  address private productAddr;
  address private licenseAddr;
  uint256 private ethRate;
  Promo[MaxPromos] private promos;
  ImmutableEntity entityInterface;

  /// @notice Token contract initializer/constructor.
  /// Executed on contract creation only.
  /// @param initialSupply the initial supply of tokens
  constructor(uint256 initialSupply) public ERC20Detailed("Immute", "IuT", 18)
                                     ERC20Mintable()
                                     ERC20Pausable()
                                     PullPayment()
  {
/*  function initialize(uint256 initialSupply) initializer public
  {
    Ownable.initialize(msg.sender);
    ERC20Detailed.initialize("Immute", "IuT", 18);
    ERC20Mintable.initialize(msg.sender);
    ERC20Pausable.initialize(msg.sender);
    PullPayment.initialize();
*/
    ethRate = 500; // $.25 if ETH $125

    // Set the default (primary 0) promotion at 20%
    //   (5x = 1y) 1/5 (20%) bonus after 1000 tokens
    promoSet(0, 5, 1, 1000 * 100000000000000000);
    _mint(msg.sender, initialSupply);
  }

  /// @notice Change bank that contract pays ETH out too.
  /// Administrator only.
  /// @param newBank The Ethereum address of new ecosystem bank
  function bankChange(address payable newBank)
    external onlyOwner
  {
    require(newBank != address(0), "Bank cannot be zero address");
    bank = newBank;
  }

  /// @notice Change exchange rate (ETH to token multiplier).
  /// Administrator only.
  /// @param newRate The new ETH to token multiplier for new purchases
  function rateChange(uint256 newRate)
    external onlyOwner
  {
    require(newRate > 0, "ETH to token exchange rate cannot be zero");
    ethRate = newRate;
  }

  /// @notice Set/Change promotion rate (token bonus calculator).
  /// Administrator only.
  /// @param index The promotion to change
  /// @param algoX The new token X (purchase) amount
  /// @param algoY The new token Y (bonus) amount
  /// @param base The base or start of promotion (is purchase size)
  function promoSet(uint256 index, uint256 algoX, uint256 algoY,
                    uint256 base)
    public onlyOwner
  {
    require(index < MaxPromos, "Promo index out of range");
    promos[index].algoX = algoX; // Set to zero to disable
    promos[index].algoY = algoY;
    promos[index].base = base;
  }

  /// @notice Retrieve current ETH to Immute token multiplier (rate).
  /// @return The ETH to token multiplier rate for new purchases
  function currentRate()
    external view returns (uint256)
  {
    return ethRate;
  }

  /// @notice Restrict transfers/minting to ecosystem contract only.
  /// Administrator only.
  /// @param entityContract The Immutable entity contract address
  /// @param productContract The Immutable entity contract address
  /// @param licenseContract The Immutable entity contract address
  function restrictTransferToContracts(address entityContract,
                                       address productContract,
                                       address licenseContract)
    external onlyOwner
  {
    // Assign contract addresses token will be restricted to
    entityAddr = entityContract;
    productAddr = productContract;
    licenseAddr = licenseContract;

    // Product and entity contracts are minters, renounce owner
    addMinter(productContract);
    addMinter(entityContract);
    renounceMinter();

    // Initialize the entity contract interface
    entityInterface = ImmutableEntity(entityContract);
  }

  /// @notice ImmuteToken transfer must check for restrictions.
  /// If ecosystem restricted auto-approve ecosystem transfers.
  /// @param recipient The token recipient
  /// @param amount The token amount to transfer
  /// @return true if transfer success, false if failed
  function transfer(address recipient, uint256 amount)
    public returns (bool)
  {
    // Restrict token transfer to ecosystem contracts if configured
    if ((((productAddr == address(0)) || (recipient == productAddr)) ||
         (msg.sender == productAddr)) ||
        (((entityAddr == address(0)) || (recipient == entityAddr)) ||
         (msg.sender == entityAddr)) ||
        (((licenseAddr == address(0)) || (recipient == licenseAddr)) ||
         (msg.sender == licenseAddr)))
    {
      // Transfer the tokens
      ERC20.transfer(recipient, amount);

      // If tokens purchased from entity, pre-approve for use
      if (msg.sender == entityAddr)
      {
        _approve(recipient, licenseAddr, balanceOf(recipient));
        _approve(recipient, productAddr, balanceOf(recipient));
      }

      // Otherwise if tokens from product or license approve for resale
      else if ((msg.sender == productAddr) || (msg.sender == licenseAddr))
        _approve(recipient, entityAddr, allowance(recipient, entityAddr) + amount);

      return true;
    }
    else
      return false;
  }

  /// @notice ImmuteToken transferFrom must check for restrictions.
  /// If ecosystem restricted auto-approve ecosystem transfers.
  /// @param sender The token sender
  /// @param recipient The token recipient
  /// @param amount The token amount to transfer
  /// @return true if transfer success, false if failed
  function transferFrom(address sender, address recipient,
                        uint256 amount)
    public returns (bool)
  {
    // Restrict token transfer to ecosystem contracts if configured
    if ((((productAddr == address(0)) || (recipient == productAddr)) ||
         (msg.sender == productAddr)) ||
        (((entityAddr == address(0)) || (recipient == entityAddr)) ||
         (msg.sender == entityAddr)) ||
        (((licenseAddr == address(0)) || (recipient == licenseAddr)) ||
         (msg.sender == licenseAddr)))
    {
      // Transfer the tokens
      ERC20.transferFrom(sender, recipient, amount);

      // If tokens purchased from entity, pre-approve for use
      if (msg.sender == entityAddr)
      {
        _approve(recipient, licenseAddr, balanceOf(recipient));
        _approve(recipient, productAddr, balanceOf(recipient));
      }

      // Otherwise if tokens from product or license approve for resale
      else if ((msg.sender == productAddr) || (msg.sender == licenseAddr))
        _approve(recipient, entityAddr, allowance(recipient, entityAddr) + amount);

      return true;
    }
    else
      return false;
  }

  /// @notice Check payment (ETH) due ecosystem bank.
  /// Uses OpenZeppelin PullPayment interface.
  /// @return the entity status as maintained by Immutable
  function checkPayments()
    external view returns (uint256)
  {
    require(bank != address(0), "Bank address is zero address");

    // Ensure entity has a configured bank
    return payments(bank);
  }

  /// @notice Calculate the promotional bonus.
  /// @param numTokens the amount of tokens to calculate bonus for
  /// @return the amount of bonus tokens
  function calculateBonus(uint256 numTokens)
    public view returns (uint256)
  {
    uint256 bonusTokens = 0;

    // Apply bonus of all applicable promotional offers
    for (uint256 i = 0; i < MaxPromos; ++i)
    {
      // Proceed only if promotion is active/valid
      if ((promos[i].algoX > 0) && (promos[i].algoY > 0))
      {
        // Apply promotion only if this purchase qualifies
        if (numTokens >= promos[i].base)
          bonusTokens += (numTokens * promos[i].algoY ) / promos[i].algoX;
      }
    }
    return bonusTokens;
  }

  /// @notice Transfer ecosystem funds to the configured bank address.
  /// Uses OpenZeppelin PullPayment interface.
  function transferToBank()
    external onlyOwner
  {
    require(bank != address(0), "Bank address is zero address");
    withdrawPayments/*WithGas*/(bank);
  }

  /// @notice Transfer ETH funds to the configured bank address.
  /// Uses OpenZeppelin PullPayment interface.
  function transferToEscrow()
    external payable
  {
    _asyncTransfer(bank, msg.value);
  }

  ///////////////////////////////////
  /// Payable functions
  ///////////////////////////////////

  /// @notice Purcahse tokens in exchange for an ETH transfer.
  /// Uses OpenZeppelin PullPayment interface.
  function tokenPurchase()
    external payable
  {
    uint256 numTokens = msg.value * ethRate;

    // Ensure ETH was sent to exchange for tokens
    require(msg.value > 0, "No ETH sent.");

    // Cannot purchase until bank address is configured by owner
    require(bank != address(0), "Bank address is zero address");

    // Transfer the ETH to the bank escrow account
    _asyncTransfer(bank, msg.value);

    // Add the amount of promotional bonus tokens
    uint256 bonusTokens = calculateBonus(numTokens);

    // Mint new tokens for the purchaser
    _mint(msg.sender, numTokens + bonusTokens);

    // Purchased tokens are pre-approved for use
    _approve(msg.sender, licenseAddr, balanceOf(msg.sender));
    _approve(msg.sender, productAddr, balanceOf(msg.sender));

    // Check if entity is registered with token
    if (address(entityInterface) != address(0))
    {
      // Check if the purchaser is a registered entity
      uint256 entityIndex = entityInterface.entityAddressToIndex(msg.sender);
      if (entityIndex > 0)
      {
        address referralAddress;
        uint256 creationTime;
        (referralAddress, creationTime) =
                   entityInterface.entityReferralByIndex(entityIndex);

        // If referral is valid (within 30 days), mint out the 10% bonus
        if ((referralAddress != address(0)) && (creationTime < now + 30 days))
        {
          numTokens = numTokens / 10; // 10 %

          // Mint bonus tokens for the referral
          _mint(referralAddress, numTokens);

          // Bonus tokens are pre-approved for use
          _approve(referralAddress, licenseAddr, balanceOf(referralAddress));
          _approve(referralAddress, productAddr, balanceOf(referralAddress));
        }
      }
    }
  }

}
