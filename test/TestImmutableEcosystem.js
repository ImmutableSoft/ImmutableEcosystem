
const truffleAssert = require('truffle-assertions');
//const createKeccakHash = require('keccak');
const { singletons, BN, expectEvent } = require('@openzeppelin/test-helpers');

const ImmuteToken = artifacts.require("./ImmuteToken.sol");
const ImmutableEntity = artifacts.require("./ImmutableEntity.sol");
const ImmutableProduct = artifacts.require("./ImmutableProduct.sol");
const ImmutableLicense = artifacts.require("./ImmutableLicense.sol");
//const ENS = artifacts.require("@ensdomains/ens/ENSRegistry");
const CustomToken = artifacts.require("./CustomToken.sol");

contract("ImmutableEcosystem", accounts => {

  const Account = accounts[7];
  const SecondAccount = accounts[4];
  const Account2 = accounts[3];
  const EndUser = accounts[6];
  const EndUser2 = accounts[8];
  const Owner = accounts[2];
  const TokenOwner = accounts[5];

  let immuteTokenInstance;
  let immutableEntityInstance;
  let immutableProductInstance;
  let immutableLicenseInstance;
  let customTokenInstance;
  let EnsInstance;
  let ensInstance;

  beforeEach('setup contract for each test case', async () => {
//    ensInstance = await ENS.new({from: accounts[0]});
//    immuteTokenInstance = await ImmuteToken.new("1000000000000000000", {from: accounts[0]});
//    immutableEcosystemInstance = await ImmutableEcosystem.new(immuteTokenInstance.address,
//                             ensInstance.address, {from: accounts[0]});
    immuteTokenInstance = await ImmuteToken.deployed();
    immutableEntityInstance = await ImmutableEntity.deployed();
    immutableProductInstance = await ImmutableProduct.deployed();
    immutableLicenseInstance = await ImmutableLicense.deployed();
    customTokenInstance = await CustomToken.deployed();
//    ensInstance = await ENS.deployed();
  })

  it("Restrict ImmuteToken transfer to ImmutableEcosystem", async () => {
    // Restrict the transfer of tokens to the contracts
    await immuteTokenInstance.restrictTransferToContracts(immutableEntityInstance.address,
             immutableProductInstance.address, immutableLicenseInstance.address, { from: accounts[0] });
  });

  it("Change ImmutableEcosystem owner", async () => {
    // Change the owner
    await immutableProductInstance.transferOwnership(Owner, { from: accounts[0] });
    // Change the entity owner
    await immutableEntityInstance.transferOwnership(Owner, { from: accounts[0] });
    // Change the owner
    await immutableLicenseInstance.transferOwnership(Owner, { from: accounts[0] });
  });

  it("Change ImmuteToken owner", async () => {
    // Add the new owner as a pauser
    await immuteTokenInstance.addPauser(TokenOwner, { from: accounts[0] });

    // Change the owner
    await immuteTokenInstance.transferOwnership(TokenOwner, { from: accounts[0] });

    // Renounce the old owner as pauser
    await immuteTokenInstance.renouncePauser({ from: accounts[0] });
  });
  it("Change ImmuteToken bank", async () => {
    // Change the owner
    await immuteTokenInstance.bankChange(TokenOwner, { from: TokenOwner });
  });

/* Uncomment to test ecosystem with unrestricted transfers
  it("Unrestrict ImmuteToken transfer to ImmutableEcosystem", async () => {
    // Unrestrict the transfer of tokens to the contracts
    await immuteTokenInstance.restrictTransferToContracts('0x0000000000000000000000000000000000000000',
             '0x0000000000000000000000000000000000000000',
             '0x0000000000000000000000000000000000000000', { from: TokenOwner});
  });
*/

  it("Find or create new entity", async () => {
    // Get the organization name
    var storedData = await immutableEntityInstance.entityDetailsByIndex(1);

    if (storedData[0] == "")
    {
      // Create a new test organization
      await immutableEntityInstance.entityCreate("Test Org",
             "http://example.com", 0, { from: Account });

      // Get all entities
      entities = await immutableEntityInstance.entityNumberOf();
      assert.equal(entities, 1, "Failed, number of Entities mismatch");

      // Get the organization name for entity 1
      storedData = await immutableEntityInstance.entityDetailsByIndex(1);

    }
    assert.equal(storedData[0], "Test Org", "Failed! Name mismatch.");
  });

  it("Update an organization status", async () => {
    // Update the organization status to a distributor (2)
    await immutableEntityInstance.entityStatusUpdate(
                                                 1, 1, { from: Owner });

    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(1);

    assert.equal(status, 1, "Failed! Status not one (Owner).");
  });
/*
  it("Resolve address from ENS name", async () => {

    const rootNode = await immutableEntityInstance.entityRootNode();

    var node = createKeccakHash('keccak256');
    node = node.update(rootNode);  // immutablesoft.eth
    node = node.update("testorg"); //Normalization of "Test Org"

    const result = node.digest('hex');
    const address = await immutableEntityInstance.addr('0x' + result);

    console.log(rootNode);
    console.log('0x' + result);
    console.log(address);
//    assert.equal(address, Account, "Failed! ENS address not Account.");
  });
*/
  it("Find or create a new product ", async () => {
    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(1);
    if (status == 0)
    {
      // Update the organization status to a creator (1)
      await immutableEntityInstance.entityStatusUpdate(1, 1, { from: Owner });
    }

    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(1);

    if (numProducts == 0)
    {
      // Create a new test product
      await immutableProductInstance.productCreate("Test Product0",
              "http://example.com/TestProduct0",
              "http://example.com/TestProduct0/favicon.ico", 0, { from: Account });
    }

    // Get the product name
    storedData = await immutableProductInstance.productDetails(1, 0);
    
    assert.equal(storedData[0], "Test Product0", "Failed! Name mismatch.");
  });

  it("Purchase tokens", async () => {
    // Purchase tokens (auto-approved for use in immutable ecosystem)
    // TODO: Move from ERC20 to ERC777?
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 10000000000;
    await immuteTokenInstance.tokenPurchase({ from: Account,
                                            value: bigPurchase });
  });

  it("Pause token contract", async () => {
    await immuteTokenInstance.pause({ from: TokenOwner });

    // Attempt token transfer, ensure it reverts
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 10000000000;
    await truffleAssert.reverts(immuteTokenInstance.transferFrom(Account,
        immutableEntityInstance.address, 10000000000, { from: Account }));

    await immuteTokenInstance.unpause({ from: TokenOwner });
  });


  it("Create a new product release", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf('1');

    if (numProducts == 0)
    {
      // Create a new test product
      await immutableProductInstance.productCreate("Test Product0",
              "http://example.com/TestProduct0",
              "http://example.com/TestProduct0/favicon.ico", 0, { from: Account });
    }

    var bigEscrow = new BN(100000000)
    bigEscrow = bigEscrow * 10000000000;

    // Create the release
    await immutableProductInstance.productRelease(0, 0, 0x900DF00D,
            "http://example.com/releases/TestProduct.zip", '0x' + bigEscrow.toString(16),
            { from: Account });

    // Read back the release hash
    const details = await immutableProductInstance.
                                  productReleaseDetails(1, 0, 0);

    assert.equal(details[2], 0x900DF00D, "Failed! Release hash mismatch.");
  });
  
  it("Create three (3) products and verify", async () => {
    // Get the number of products
    var numProducts = await immutableProductInstance.productNumberOf(1);
    if (numProducts < 2)
    {
      // Create a new test product
      await immutableProductInstance.productCreate("Test Product1",
              "http://example.com/TestProduct1",
              "http://example.com/TestProduct1/favicon.ico", 0, { from: Account });
      // Get the number of products
      numProducts = await immutableProductInstance.productNumberOf(1);
    }

    if (numProducts < 3)
    {
      // Create a new test product
      await immutableProductInstance.productCreate("Test Product2",
              "http://example.com/TestProduct2",
              "http://example.com/TestProduct2/favicon.ico", 0, { from: Account });
      // Get the number of products
      numProducts = await immutableProductInstance.productNumberOf(1);
    }
    assert.equal(numProducts, 3, "Failed! Number of products mismatch.");

    var i;
    for (i = 0; i < numProducts; ++i)
    {
      var details = await immutableProductInstance.productDetails(
                                                 1, i);
      var testResult = "Test Product";
      
      var name = testResult.concat(i.toString());
      assert.equal(details[0], name, "Failed! Product name mismatch.");
    }
  });

  it("Find or create second entity", async () => {
    // Get the organization name
    var storedData = await immutableEntityInstance.entityDetailsByIndex(2);

    if (storedData[0] == "")
    {
      // Create a new test organization
      await immutableEntityInstance.entityCreate("Test Org2",
             "http://example2.com", 0, { from: SecondAccount });

      // Get all entities
      entities = await immutableEntityInstance.entityNumberOf();
      assert.equal(entities, 2, "Failed, number of Entities mismatch");

      // Get the organization name
      storedData = await immutableEntityInstance.entityDetailsByIndex(2);

    }
    assert.equal(storedData[0], "Test Org2", "Failed! Name mismatch.");
  });

  it("Find or create second entity new product ", async () => {
    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(2);
    if (status == 0)
    {
      // Update the organization status to a creator (1)
      await immutableEntityInstance.entityStatusUpdate(
                                                 2, 1, { from: Owner });
    }

    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(
                                                 2);

    if (numProducts == 0)
    {
      // Create a new test product
      await immutableProductInstance.productCreate("Test Product2",
              "http://example2.com/TestProduct2",
              "http://example2.com/TestProduct2/favicon.ico", 0, { from: SecondAccount });
    }

    // Get the product name
    storedData = await immutableProductInstance.productDetails(
                                                   2, 0);
    
    assert.equal(storedData[0], "Test Product2", "Failed! Name mismatch.");
  });

  it("Create second entity new product release", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(
                                                 2);

    if (numProducts == 0)
    {
      // Create a new test product
      await immutableProductInstance.productCreate("Test Product2",
              "http://example2.com/TestProduct2",
              "http://example2.com/TestProduct2/favicon.ico", 0, { from: SecondAccount });
    }

    // Purchase tokens (auto-approved for use in immutable ecosystem)
    // TODO: Move from ERC20 to ERC777?
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 10000000000;
    await immuteTokenInstance.tokenPurchase({ from: SecondAccount,
                                            value: bigPurchase });

    // Create the release
    await immutableProductInstance.productRelease(0, 0, 0x900DF00D,
            "http://example2.com/releases/TestProduct2.zip", bigPurchase.toString(10, 20),
            { from: SecondAccount });

    // Read back the release hash
    const details = await immutableProductInstance.
                                  productReleaseDetails(2, 0, 0);

    assert.equal(details[2], 0x900DF00D, "Failed! Release hash mismatch.");
  });
  
  it("Create and test a license", async () => {
    // Get the organization name
    var entity = await immutableEntityInstance.entityDetailsByIndex(1);

    if (entity[0] == "")
    {
      // Create a new test organization
      await immutableEntityInstance.entityCreate("Test Org",
             "http://example.com", 0, { from: Account });

      // Get the organization name
      entity = await immutableEntityInstance.entityDetailsByIndex(1);
    }

    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(
                                                 1);

    if (numProducts == 0)
    {
      // Assert failure
      assert.equal(1, 0, "No products exist");
    }

    // Create the product license
    await immutableLicenseInstance.licenseCreate(0, 0xFEEDBEEF, 1, 0, { from: Account });

    // Check validity of the license
    const storedData = await immutableLicenseInstance.licenseStatus(1, 0, 0xFEEDBEEF);
    
    assert.equal(storedData[0], 1, "Failed! License mismatch.");
  });

  it("Update an organization status", async () => {
    // Update the organization status to a distributor (2)
    await immutableEntityInstance.entityStatusUpdate(
                                                 1, 2, { from: Owner });

    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(1);

    assert.equal(status, 2, "Failed! Status not two (Distributor).");
  });

  it("Check ImmutableEcosystem token balance matches escrow amount", async () => {
    // Check the balance of the ecosystem (should be 2 escrow amounts 
    const balance = await immuteTokenInstance.balanceOf(immutableProductInstance.address);
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 20000000000;

    assert.equal(balance, bigPurchase, "Failed, contract balance not equal to escrow amount");
  });

  it("Challenge a nonprofit organization release (minted escrow)", async () => {
    // Create a new test organization
    await immutableEntityInstance.entityCreate("OrgAccount1",
             "http://orgaccount1.com", 0, { from: accounts[9] });

    // Update the organization status with Automatic = (2 << 32);
    var NonprofitCreator = new BN(0x100000001); // (1 << 32) non-profit flag
//    NonprofitCreator = NonprofitCreator + 1; // Creator
    assert.equal("0x" + NonprofitCreator.toString(16), "0x100000001" /*"0x" + NonprofitCreator.toString(16)*/, "Failed! Status number mismatch");

    await immutableEntityInstance.entityStatusUpdate(3, "0x" + NonprofitCreator.toString(16), { from: Owner });

    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(3);

    assert.equal("0x" + status.toString(16), "0x100000001" /*"0x" + NonprofitCreator.toString(16)*/, "Failed! Status not four (non-profit).");

    // Create a new test product
    await immutableProductInstance.productCreate("Test Nonprofit",
              "http://nonprofit.org/TestProduct",
              "http://nonprofit.org/TestProduct/favicon.ico", 0, { from: accounts[9] });

    // Create the release
    await immutableProductInstance.productRelease(0, 0, 0x900DF00D,
            "http://nonprofit.org/releases/TestProduct.zip", 0,
            { from: accounts[9] });

    // Challenge the nonprofit release and get 1/2 escrow
    const balanceBefore = await immuteTokenInstance.balanceOf(EndUser2);
    await immutableProductInstance.productChallengeReward(EndUser2,
               3, 0, 0, 0x0BADF00D, { from: Owner });
    const balanceAfter = await immuteTokenInstance.balanceOf(EndUser2);

    var halfEscrow = new BN(100000000)
    halfEscrow = halfEscrow * 5000000000; // 1/2  token
    assert.equal(balanceAfter - balanceBefore, halfEscrow,
                 "Failed, balance did not increase by expected amount");
/*
    // To enable this remove the time constraint to withdraw release escrow

    // Withdraw release escrow tokens (1/2 or remaining or 1/4 token)
    const balanceBefore = await immuteTokenInstance.balanceOf(accounts[9]);
    await immutableProductInstance.productTokensWithdraw({ from: accounts[9] });
    const balanceAfter = await immuteTokenInstance.balanceOf(accounts[9]);

    var quarterEscrow = new BN(100000000)
    quarterEscrow = quarterEscrow * 2500000000; // 1/4  token
    assert.equal(balanceAfter - balanceBefore, quarterEscrow,
                 "Failed, balance did not increase by expected amount");
*/
  });

  it("Transfer ImmuteToken contract ETH balance to bank", async () => {
    // Transfer the ETH escrow balance to the bank
    await immuteTokenInstance.transferToBank({ from: TokenOwner });
  });

  it("Attempt to transfer new tokens between accounts", async () => {
    // Purchase tokens and approve them for use by accounts[9]
    const balanceBefore = await immuteTokenInstance.balanceOf(accounts[9]);
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 20000000000; // 2 tokens
    await immuteTokenInstance.tokenPurchase({ from: EndUser,
                                            value: '0x' + bigPurchase.toString(16) });
    await immuteTokenInstance.approve(accounts[9],
                                      20000000000 * 500, { from: EndUser });

    // Transfer the tokens
    await immuteTokenInstance.transfer(accounts[9],
                                       10000000000, { from: EndUser });
    const balanceAfter = await immuteTokenInstance.balanceOf(accounts[9]);
    assert.equal(balanceAfter - balanceBefore, 0, "Failed, tokens were transferred!");
  });

  it("Attempt to transfer from another to the ecosystem", async () => {
    // Purchase tokens and approve them for use by accounts[9]
    const balanceBefore = await immuteTokenInstance.balanceOf(EndUser);
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 20000000000; // 2 tokens

    // Attemp transfer of tokens to pre-approved ecosystem contract
    await truffleAssert.reverts(immuteTokenInstance.transferFrom(EndUser,
        immutableEntityInstance.address, 10000000000, { from: Owner }));
    const balanceAfter = await immuteTokenInstance.balanceOf(EndUser);
    assert.equal(balanceAfter - balanceBefore, 0, "Failed, tokens were transferred!");
  });

  it("Create a product license offer", async () => {
    // Create the produce license offer for a one year activation
    await immutableLicenseInstance.licenseOffer(0,
                                    10000000000, (365 * (24 * (60 * 60))),
                                    20000000000, (3 * 365 * (24 * (60 * 60))), { from: Account });

    const offerPrice = await immutableLicenseInstance.licenseOfferDetails(1, 0, { from: Account });
    assert.equal(offerPrice[0], 10000000000, "Failed, product activation license price mismatch");
  });

  it("Purchase a product activation license", async () => {
    const origBalance = await immuteTokenInstance.balanceOf(Account);

    // Create an end user entity account
    await immutableEntityInstance.entityCreate("John Smith",
             "http://linkedin.com/john_smith", 0, { from: EndUser });
    var entityIndex = await immutableEntityInstance.entityAddressToIndex(EndUser);

    // Update the end user status to an EndUser (3)
    await immutableEntityInstance.entityStatusUpdate(entityIndex, 3, { from: Owner });

    // Create the product activation license offer
    //  (entity, productID, activationHash)
    await immutableLicenseInstance.licensePurchase(
              1, 0, 0xF00D, 0, { from: EndUser });

    // Check the license. (entity, productID, activation hash)
    const storedData = await immutableLicenseInstance.licenseStatus(1, 0, 0xF00D);

    // Value is the offerID, which is the offerIndex + 1.
    //   ie. The constant 1 below should match offerIndex + 1
    // match the purchased offerID above
    assert.equal(storedData[0], 1, "Failed! License mismatch.");

    const newBalance = await immuteTokenInstance.balanceOf(Account);

    assert.equal(newBalance - origBalance, 9499967488 /*(10000000000 * 95) / 100*/,
                 "Failed, not enough tokens transferred to creator!");
  });

  it("Move a purchased activation license", async () => {
    const oldBalance = await immuteTokenInstance.balanceOf(EndUser);

    // Check the license
    let result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xF00D);
    assert.equal(result[0], 1, "Failed! Not license.");

    // Move the product activation license offer
    await immutableLicenseInstance.licenseMove(
              1, 0, 0xF00D, 0xFEED, { from: EndUser });

    // Check the old license
    result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xF00D);
    assert.equal(result[0], 0, "Failed! Old license is not invalid.");

    // Check the new license
    result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xFEED);
    assert.equal(result[0], 1, "Failed! New license is not valid.");

    const newBalance = await immuteTokenInstance.balanceOf(EndUser);

    var bigEscrow = new BN(100000000)
    bigEscrow = bigEscrow * 10000000000; // two escrows
    assert.equal(oldBalance - newBalance, bigEscrow + 262100, "Tokens not charged for moving license");
  });
/*
  it("Withdraw tokens earned from product licenses", async () => {
    // Withdraw the license purchase tokens from previous test
    const balanceBefore = await immuteTokenInstance.balanceOf(Account);
    await immutableLicenseInstance.licenseTokensWithdraw({ from: Account });
    const balanceAfter = await immuteTokenInstance.balanceOf(Account);
    assert.equal(balanceAfter - balanceBefore, 9499967488,
                 "Failed, balance did not increase by expected amount");
  });
*/
  it("Offer a product activation license for resale", async () => {
    await immutableLicenseInstance.licenseOfferResale(1, 0, 0xFEED, 5000000000, { from: EndUser });
  });

  it("Purchase a second hand activation license", async () => {

    var rate = await immuteTokenInstance.currentRate();
    await immuteTokenInstance.tokenPurchase({ from: EndUser2,
                                           value: 5000000000 / rate });
    const oldBalance = await immuteTokenInstance.balanceOf(EndUser);
    const user2Balance = await immuteTokenInstance.balanceOf(EndUser2);

    // Check the license
    let result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xFEED);
    assert.equal(result[0], 1, "Failed! Not licensed.");

    // Approve tokens for transfer to EndUser
//    await customTokenInstance.approve(EndUser, 5000000000,
//                                      { from: EndUser2 });

    // Transfer (resell) the product activation license
    await immutableLicenseInstance.licenseTransfer(
              1, 0, 0xFEED, 0xFEAD, { from: EndUser2 });

    // Check the new license
    result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xFEAD);
    assert.equal(result[0], 1, "Failed! New license is not valid.");

    const newBalance = await immuteTokenInstance.balanceOf(EndUser);
    const newUser2Balance = await immuteTokenInstance.balanceOf(EndUser2);

    assert.equal(user2Balance - newUser2Balance, 5000000000, "Tokens not charged for resell");
    assert.equal(newBalance - oldBalance, 4750049280, "Tokens not earned for resell");
  });

  it("Move a resold activation license", async () => {
    // Check the license
    let result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xFEAD);
    assert.equal(result[0], 1, "Failed! Not licensed.");

    // Purchase tokens
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 10000000000; // 1 tokens
    await immuteTokenInstance.tokenPurchase({ from: EndUser2,
                                            value: '0x' + bigPurchase.toString(16) });

    // Move the product activation license offer
    await immutableLicenseInstance.licenseMove(
              1, 0, 0xFEAD, 0xF00D, { from: EndUser2 });

    // Check the old license
    result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xFEED);
    assert.equal(result[0], 0, "Failed! Old license is not invalid.");

    // Check the new license
    result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xF00D);
    assert.equal(result[0], 1, "Failed! New license is not valid.");

  });

  it("Configure a bank", async () => {
    // Configure the bank to be the same as the address
    await immutableEntityInstance.entityBankChange(Account, { from: Account });
  });

  it("Create a Token Offer", async () => {
    const balanceBefore = new BN(await immuteTokenInstance.balanceOf(Account));

    // Create a token block offer (rate, amount, block count)
    await immutableEntityInstance.entityTokenBlockOffer(1200,
     1200000000, 2, { from: Account });

    const offers = await immutableEntityInstance.entityNumberOfOffers(1, { from: Account });
    assert.equal(offers, 1, "Failed, product activation license offers is zero");

    var balanceAfter = new BN(await immuteTokenInstance.balanceOf(Account));
    assert.equal(balanceBefore - balanceAfter , 2399928320, "Failed, not enough tokens transfered to contract!");

  });

  it("Purchase a Token Offer", async () => {
    // Purchase the previous tests token offer
    const balanceBefore = await immuteTokenInstance.balanceOf(EndUser);
    let tokenPurchase = await immutableEntityInstance.entityTokenBlockPurchase(1, 0, 1, { from: EndUser, value: 1200000000 / 1200 });
    const balanceAfter = await immuteTokenInstance.balanceOf(EndUser);
    assert.equal(balanceAfter - balanceBefore, 1200095232, "Failed, end user balance incorrect");

//    truffleAssert.eventEmitted(tokenPurchase, 'EntityTokenBlockPurchaseEvent', (ev) => {
//        return ((ev.challenger == EndUser) && (ev.creator == Account) &&
//                (ev.newHash == 0x0BADF00D));
  });

  it("Withdraw ETH from the token purchase", async () => {
    var ethInEscrow = await immutableEntityInstance.entityPaymentsCheck({ from: Account});
    assert.equal(ethInEscrow, 1200000000 / 1200, "Failed, ETH in escrow incorrect amount");

    // Withdraw the payments in escrow from previous test
    await immutableEntityInstance.entityPaymentsWithdraw({ from: Account} );

    // Recheck escrow and ensure it went to zero
    ethInEscrow = await immutableEntityInstance.entityPaymentsCheck({ from: Account });
    assert.equal(ethInEscrow, 0, "Failed, ETH in escrow after withdraw");
  });

  it("Revoke a token block offer", async () => {
    // Revoke the token block offer
    await immutableEntityInstance.entityTokenBlockOfferRevoke(0, { from: Account });

    const offers = await immutableEntityInstance.entityNumberOfOffers(1);
    assert.equal(offers, 0, "Failed, product token block offers is not zero");
  });

  it("Challenge a product release", async () => {
    // Challenge the product release by providing new hash
    let newChallenge = await immutableProductInstance.productReleaseChallenge(1, 0, 0,
                                            0x0BADF00D, { from: EndUser });

    truffleAssert.eventEmitted(newChallenge, 'productReleaseChallengeEvent', (ev) => {
        return ((ev.challenger == EndUser) && (ev.entityIndex == 1) &&
                (ev.newHash == 0x0BADF00D));
    });
  });

  it("Award a product release challenge (onlyOwner)", async () => {
    // Have the Admin reward the challenger
    var balanceBefore = await immuteTokenInstance.balanceOf(EndUser);

    let newChallenge = await immutableProductInstance.productChallengeReward(EndUser,
               1, 0, 0, 0x0BADF00D, { from: Owner });

    var balanceAfter = await immuteTokenInstance.balanceOf(EndUser);

    // Assert if correct event was not emitted
    truffleAssert.eventEmitted(newChallenge, 'productReleaseChallengeAwardEvent', (ev) => {
        return ((ev.challenger == EndUser) && (ev.entityIndex == 1) &&
                (ev.newHash == 0x0BADF00D));
    });

    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 5000000000; // TODO whats with rounding errors?
    assert.equal(balanceAfter - balanceBefore, bigPurchase - 131100, "Failed, end user balance delta incorrect");
  });

  it("Move an entity and all tokens to a new address", async () => {
    var oldAccountBalanceBefore = await immuteTokenInstance.balanceOf(Account);
    var newAccountBalanceBefore = await immuteTokenInstance.balanceOf(Account2);

    // Approve the transfer of all tokens to escrow
    await immuteTokenInstance.approve(immutableEntityInstance.address,
                                      oldAccountBalanceBefore,
                                      { from: Account });

    // Configure next entity address and move tokens to escrow
    await immutableEntityInstance.entityAddressNext(Account2,
                           oldAccountBalanceBefore, { from: Account });

    // Move the entity, including all the tokens
    await immutableEntityInstance.entityAddressMove(Account, { from: Account2 });

    var oldAccountBalanceAfter = await immuteTokenInstance.balanceOf(Account);
    var newAccountBalanceAfter = await immuteTokenInstance.balanceOf(Account2);

    assert.equal(oldAccountBalanceAfter, 0, "Old account balance is not zero");
    assert.equal(newAccountBalanceAfter - newAccountBalanceBefore, oldAccountBalanceBefore, "New account did not get tokens");
  });

  it("Purchase activation license directly with ETH", async () => {
    var ethInEscrow = await immutableEntityInstance.entityPaymentsCheck({ from: Account2});
    
    var bigPurchase = new BN(10000000000); // license price

    // Update the organization status with Automatic = (1 << 33);
    var Automatic = new BN(0x200000001); // (1 << 33) automatic flag
    await immutableEntityInstance.entityStatusUpdate(1, "0x" + Automatic.toString(16), { from: Owner });

    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(1);
    assert.equal("0x" + status.toString(16), "0x200000001"/*"0x" + Automatic.toString(16)*/, "Failed! Status not four (non-profit).");

    var rate = await immuteTokenInstance.currentRate();

    // Convert big purchase to ETH
    bigPurchase = bigPurchase / rate;
    await immutableLicenseInstance.licensePurchaseInETH(
              1, 0, 0xBEEF, 0, { from: EndUser, value: bigPurchase });

    var ethOutEscrow = await immutableEntityInstance.entityPaymentsCheck({ from: Account2});
    assert.equal(ethOutEscrow - ethInEscrow, bigPurchase, "Failed, ETH in escrow incorrect amount");

  });

  it("Move a purchased activation license after entity move", async () => {
    var newAccountBalanceBefore = await immuteTokenInstance.balanceOf(EndUser2);

    // Create the product activation license offer
    //  (entity, productID, offerIndex, activationHash)
    await immutableLicenseInstance.licensePurchase(
              1, 0, 0xBEEF, 0, { from: EndUser });

    var oldAccountBalanceBefore = await immuteTokenInstance.balanceOf(EndUser);

    // Check the license. (entity, productID, activation hash)
    const storedData = await immutableLicenseInstance.licenseStatus(1, 0, 0xBEEF);
    assert.equal(storedData[0], 1, "Failed! Old license should not be valid.");

    // Approve the transfer of all tokens to escrow
    await immuteTokenInstance.approve(immutableEntityInstance.address,
                                      oldAccountBalanceBefore,
                                      { from: EndUser });

    // Configure next entity address and move tokens to escrow
    await immutableEntityInstance.entityAddressNext(EndUser2,
                           oldAccountBalanceBefore, { from: EndUser });

    // Move the entity, including all the tokens
    await immutableEntityInstance.entityAddressMove(EndUser, { from: EndUser2 });

    // Check the license after moving entity
    result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xBEEF);
    assert.equal(result[0], 1, "Failed! No license found.");

    // Move product activation license offer with new entity address
    await immutableLicenseInstance.licenseMove(
              1, 0, 0xBEEF, 0xDEED, { from: EndUser2 });

    // Check the old license
    result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xBEEF);
    assert.equal(result[0], 0, "Failed! Old license should not be valid.");

    // Check the new license
    result = await immutableLicenseInstance.
                                     licenseStatus(1, 0, 0xDEED);
    assert.equal(result[0], 1, "Failed! New license is not valid.");
  });

  it("Revoke a product license offer", async () => {
    // Revoke the produce license offer
    await immutableLicenseInstance.licenseOffer(0, 0, 0, 0, 0, { from: Account2 });

    // Create the product activation license offer
    //  (entity, productID, activationHash)
    result = await immutableLicenseInstance.licenseOfferDetails(
              1, 0);
    assert.equal(result[0], 0, "Failed! License offer not zero.");
    await truffleAssert.reverts(immutableLicenseInstance.licensePurchase(
          1, 0, 0xF00D, 0, { from: EndUser }), "Offer not found");
  });

  //////////////////////////////////////////////////////////
  // Custom ERC20 token
  //////////////////////////////////////////////////////////

  it("Find or create new entity with referral", async () => {
    // Get the organization name
    var storedData = await immutableEntityInstance.entityDetailsByIndex(5);

    if (storedData[0] == "")
    {
      var nonprofitIndex = await immutableEntityInstance.entityAddressToIndex(accounts[9]);
      assert.equal(3, nonprofitIndex, "Failed, referral index not 3");

      // Create a new test organization with referral
      await immutableEntityInstance.entityCreate("Test Company 4",
             "http://company.com", 3, { from: Account });

      // Get all entities
      entities = await immutableEntityInstance.entityNumberOf();
      assert.equal(entities, 5, "Failed, number of Entities mismatch");

      // Get the organization name for entity 1
      storedData = await immutableEntityInstance.entityDetailsByIndex(5);
    }
    assert.equal(storedData[0], "Test Company 4", "Failed! Name mismatch.");
  });

  it("Update an organization status", async () => {
    // Check balance to ensure referral received bonus
    const beforeBalance = await immuteTokenInstance.balanceOf(accounts[9]);
    var CustomTokenCreator = new BN(0x600000001); // (1 << 34) custom token flag
                                                  // (1 << 33) automatic

    // Update organization status to custom token (1 << 34) and creator (1)
    await immutableEntityInstance.entityStatusUpdate(
           5, '0x' + CustomTokenCreator.toString(16), { from: Owner });

    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(5);

    assert.equal("0x" + status.toString(16), "0x600000001", "Failed! Status not custom token creator.");

    // Check balance to ensure referral received bonus
    var bigReferral = new BN(100000000)
    bigReferral = bigReferral * 400000000000;
    const afterBalance = await immuteTokenInstance.balanceOf(accounts[9]);
    assert.equal(afterBalance - beforeBalance, bigReferral, "Failed! Token bonus not applied to referral.");
  });

  it("Update entity with a custom token", async () => {
    // Update organization with a custom ERC token address
    await immutableEntityInstance.entityCustomToken(
           5, customTokenInstance.address, { from: Owner });

    // Read back the token address
    const customAddress = await immutableEntityInstance.entityCustomTokenAddress(5);

    assert.equal(customAddress, customTokenInstance.address, "Failed! Status not custom token creator.");
  });

  it("Find or create a new product ", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(5);

    if (numProducts == 0)
    {
      const beforeBalance = await immuteTokenInstance.balanceOf(accounts[9]);
      // Create a new test product
      await immutableProductInstance.productCreate("Test Product4",
              "http://example.com/TestProduct0",
              "http://example.com/TestProduct0/favicon.ico", 0, { from: Account });

      // Check balance to ensure referral received bonus
      var bigReferral = new BN(100000000)
      bigReferral = bigReferral * 40000000000;
      const afterBalance = await immuteTokenInstance.balanceOf(accounts[9]);
      assert.equal(afterBalance - beforeBalance, bigReferral, "Failed! Token bonus not applied to referral.");
    }

    // Get the product name
    storedData = await immutableProductInstance.productDetails(5, 0);

    assert.equal(storedData[0], "Test Product4", "Failed! Name mismatch.");
  });

  it("Create a new product release", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(5);

    assert.equal(numProducts, 1, "One product not found");

    // Purchase tokens for escrow and ensure referral received bonus
    const beforeBalance = await immuteTokenInstance.balanceOf(accounts[9]);
    // Purchase tokens (auto-approved for use in immutable ecosystem)
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 10000000000;
    await immuteTokenInstance.tokenPurchase({ from: Account,
                                            value: bigPurchase });
    const afterBalance = await immuteTokenInstance.balanceOf(accounts[9]);
    var rate = await immuteTokenInstance.currentRate();
    assert.equal(afterBalance - beforeBalance, (bigPurchase * rate) / 10, "Failed! Token bonus not applied to referral.");

    // Create the release
    await immutableProductInstance.productRelease(0, 0, 0x900DFEED,
            "http://example.com/releases/TestProduct.zip", bigPurchase.toString(10, 20),
            { from: Account });

    // Read back the release hash
    const details = await immutableProductInstance.
                                  productReleaseDetails(5, 0, 0);

    assert.equal(details[2], 0x900DFEED, "Failed! Release hash mismatch.");
  });
  
  it("Create a product license offer", async () => {
    // Create the produce license offer
    await immutableLicenseInstance.licenseOffer(0, 10000000000, // standard 1 year
                                        (365 * (24 * (60 * 60))),
                                        20000000000, // 3 year promo for price of 2
                                        (3 * 365 * (24 * (60 * 60))), { from: Account });

    const offerPrice = await immutableLicenseInstance.licenseOfferDetails(5, 0, { from: Account });
    assert.equal(offerPrice[0], 10000000000, "Failed, product activation license price mismatch");
  });

  it("Purchase a custom token product activation license", async () => {
    const beforeBalance = await customTokenInstance.balanceOf(accounts[0]);

    // Approve custom tokens for transfer
    await customTokenInstance.approve(immutableLicenseInstance.address, 10000000000,
                                              { from: accounts[0] });

    // Create the product activation license offer
    //  (entity, productID, activationHash)
    await immutableLicenseInstance.licensePurchase(
              5, 0, 0xFEAD, 0, { from: accounts[0] });

    // Check the license. (entity, productID, activation hash)
    const storedData = await immutableLicenseInstance.licenseStatus(5, 0, 0xFEAD);

    // Value is the offerID, which is the offerIndex + 1.
    //   ie. The constant 1 below should match offerIndex + 1
    // match the purchased offerID above
    assert.equal(storedData[0], 1, "Failed! License mismatch.");

    const afterBalance = await customTokenInstance.balanceOf(accounts[0]);

    assert.equal(beforeBalance - afterBalance, 10000000000, "Failed, tokens not transferred.");
  });
/*
  it("Withdraw custom tokens earned from product licenses", async () => {
    // Withdraw the license purchase tokens from previous test
    const balanceBefore = await customTokenInstance.balanceOf(Account);
    await immutableLicenseInstance.licenseTokensWithdraw({ from: Account });
    const balanceAfter = await customTokenInstance.balanceOf(Account);
    assert.equal(balanceAfter - balanceBefore, 10000000000,
                 "Failed, Account balance did not increase by expected amount");
  });
*/
  it("Offer a product activation license for resale", async () => {
    await immutableLicenseInstance.licenseOfferResale(5, 0, 0xFEAD, 5000000000, { from: accounts[0] });
  });

  it("Purchased third party custom token activation license", async () => {
    // Purchase tokens (auto-approved for use in immutable ecosystem)
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 20000000000;
    await immuteTokenInstance.tokenPurchase({ from: EndUser,
                                            value: bigPurchase });
    // Approve custom tokens for transfer
    await customTokenInstance.approve(EndUser, 10000000000,
                                      { from: accounts[0] });

    // Transfer custom tokens to EndUser
    await customTokenInstance.transfer(EndUser, 10000000000,
                                      { from: accounts[0] });

    const oldBalance = await customTokenInstance.balanceOf(accounts[0]);

    // Check the license
    let result = await immutableLicenseInstance.
                                     licenseStatus(5, 0, 0xFEAD);
    assert.equal(result[0], 1, "Failed! Not license.");

    // Approve custom tokens for transfer
    await customTokenInstance.approve(immutableLicenseInstance.address, 5000000000,
                                      { from: EndUser });

    // Check allowance of custom tokens for transfer
    let newAllowance = await customTokenInstance.allowance(EndUser, immutableLicenseInstance.address);
    assert.equal(newAllowance, 5000000000, "Allowance did not stick!");

    // Transfer (sell) the product activation license offer
    await immutableLicenseInstance.licenseTransfer(5, 0, 0xFEAD, 0xFEED, { from: EndUser });

    // Check the new license
    result = await immutableLicenseInstance.
                                     licenseStatus(5, 0, 0xFEED);
    assert.equal(result[0], 1, "Failed! New license is not valid.");

    const newBalance = await customTokenInstance.balanceOf(accounts[0]);

    assert.equal(newBalance - oldBalance, 5000000000, "Tokens not charged for resell");
  });

  it("Move a resold custom token activation license", async () => {
    const oldBalance = await immuteTokenInstance.balanceOf(EndUser);

    // Check the license
    let result = await immutableLicenseInstance.
                                     licenseStatus(5, 0, 0xFEED);
    assert.equal(result[0], 1, "Failed! Not license.");

    // Move the product activation license offer
    await immutableLicenseInstance.licenseMove(
              5, 0, 0xFEED, 0xF00D, { from: EndUser });

    // Check the old license
    result = await immutableLicenseInstance.
                                     licenseStatus(5, 0, 0xFEAD);
    assert.equal(result[0], 0, "Failed! Old license is not invalid.");

    // Check the new license
    result = await immutableLicenseInstance.
                                     licenseStatus(5, 0, 0xF00D);
    assert.equal(result[0], 1, "Failed! New license is not valid.");

    const newBalance = await immuteTokenInstance.balanceOf(EndUser);

    var bigEscrow = new BN(100000000)
    bigEscrow = bigEscrow * 10000000000; // one token
    assert.equal(oldBalance - newBalance, bigEscrow + 262100, "Tokens not charged for moving license");
  });


});
