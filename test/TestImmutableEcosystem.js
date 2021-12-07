
const truffleAssert = require('truffle-assertions');
//const createKeccakHash = require('keccak');
const { singletons, BN, expectEvent } = require('@openzeppelin/test-helpers');
const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');

//const ImmuteToken = artifacts.require("./ImmuteToken.sol");
const StringCommon = artifacts.require("StringCommon.sol");
const ImmutableEntity = artifacts.require("ImmutableEntity.sol");
const ImmutableProduct = artifacts.require("ImmutableProduct");
const CreatorToken = artifacts.require("CreatorToken.sol");
const ActivateToken = artifacts.require("ActivateToken.sol");
const ProductActivate = artifacts.require("ProductActivate.sol");
//const ENS = artifacts.require("@ensdomains/ens/ENSRegistry");
const CustomToken = artifacts.require("CustomToken.sol");

var bigInt = require("big-integer");

contract("ImmutableEcosystem", accounts => {

  const Account = accounts[7];
  const SecondAccount = accounts[4];
  const Account2 = accounts[3];
  const EndUser = accounts[6];
  const EndUser2 = accounts[8];
  const Owner = accounts[2];
//  const TokenOwner = accounts[5];

  let immuteTokenInstance;
  let immutableEntityInstance;
  let creatorTokenInstance;
  let activateTokenInstance;
  let productActivateInstance;
//  let immutableLicenseInstance;
//  let activateTokenInstance;
  let customTokenInstance;
  let EnsInstance;
  let ensInstance;

  beforeEach('setup contract for each test case', async () => {
    stringCommonInstance = await StringCommon.deployed();
    immutableEntityInstance = await ImmutableEntity.deployed();
    immutableProductInstance = await ImmutableProduct.deployed();
    creatorTokenInstance = await CreatorToken.deployed();
    activateTokenInstance = await ActivateToken.deployed();
    productActivateInstance = await ProductActivate.deployed();
    customTokenInstance = await CustomToken.deployed();
//    ensInstance = await ENS.deployed();
  })

  it('Check if upgradeable contracts work', async () => {
    lastCommon = await StringCommon.deployed();
    const common2 = await upgradeProxy(lastCommon.address, StringCommon);
    assert.equal(lastCommon.address, common2.address,
                 "Upgraded common contract address changed");

    lastEntity = await ImmutableEntity.deployed();
    const entity2 = await upgradeProxy(lastEntity.address, ImmutableEntity);
    assert.equal(lastEntity.address, entity2.address,
                 "Upgraded entity contract address changed");

    lastCreator = await CreatorToken.deployed();
    const creator2 = await upgradeProxy(lastCreator.address, CreatorToken);
    assert.equal(lastCreator.address, creator2.address,
                 "Upgraded product contract address changed");

    lastActivate = await ActivateToken.deployed();
    const activate2 = await upgradeProxy(lastActivate.address, ActivateToken);
    assert.equal(lastActivate.address, activate2.address,
                 "Upgraded activate contract address changed");
  });

  it("Restrict the activate token (required)", async () => {

    //  const activateTokenInstance = await Activate.deployed();
    await activateTokenInstance.restrictToken(productActivateInstance.address,
                                       creatorTokenInstance.address, { from: accounts[0] });
  });

  it("Change ImmutableEcosystem owner", async () => {

    // Change the entity owner
    await immutableEntityInstance.transferOwnership(Owner, { from: accounts[0] });

    // Change the product owner
    await immutableProductInstance.transferOwnership(Owner, { from: accounts[0] });

    // Change the activate token owner
    await activateTokenInstance.transferOwnership(Owner, { from: accounts[0] });
  });
/*
  it("Change ImmuteToken owner", async () => {
    // Add the new owner as a pauser
//    await immuteTokenInstance.addPauser(TokenOwner, { from: accounts[0] });

    // Add the new owner as a minter
    await immuteTokenInstance.addMinter(TokenOwner, { from: accounts[0] });

    // Change the owner
    await immuteTokenInstance.transferOwnership(TokenOwner, { from: accounts[0] });

    // Renounce the old owner as minter
    await immuteTokenInstance.renounceMinter({ from: accounts[0] });

    // Renounce the old owner as pauser
//    await immuteTokenInstance.renouncePauser({ from: accounts[0] });
  });

  it("Change ImmuteToken bank", async () => {
    // Change the owner
    await immuteTokenInstance.bankChange(TokenOwner, { from: TokenOwner });
  });
  */

  it("Find or create new entity", async () => {
    // Get the organization name
    var storedData = await immutableEntityInstance.entityDetailsByIndex(1);

    if (storedData[0] == "")
    {
      // Create a new test organization
      let newEntity = await immutableEntityInstance.entityCreate("Test Org",
             "http://example.com", { from: Account });

      truffleAssert.eventEmitted(newEntity, 'entityEvent', (ev) => {
          return ev.entityIndex == 1 && ev.name === "Test Org";
      });

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
  it("Owner can mint tokens for others", async () => {
    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 20000000000; // 2 tokens

    // Mint tokens for the new account
    await immuteTokenInstance.tokenMint(Account,
                    '0x' + bigPurchase.toString(16), { from: TokenOwner });
  });*/
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
      let newProduct = await immutableProductInstance.productCreate("Test Product0",
              "http://example.com/TestProduct0",
              "http://example.com/TestProduct0/favicon.ico", 0, { from: Account });

      truffleAssert.eventEmitted(newProduct, 'productEvent', (ev) => {
          return ev.entityIndex == 1 && ev.name === "Test Product0";
      });
    }

    // Get the product name
    storedData = await immutableProductInstance.productDetails(1, 0);
    
    assert.equal(storedData[0], "Test Product0", "Failed! Name mismatch.");
  });

  it("Create a duplicate product ", async () => {
    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(1);
    if (status == 0)
    {
      // Update the organization status to a creator (1)
      await immutableEntityInstance.entityStatusUpdate(1, 1, { from: Owner });
    }

    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(1);

    if (numProducts == 1)
    {
      // Create a new test product
      await truffleAssert.reverts(immutableProductInstance.productCreate("Test Product0",
              "http://example.com/TestProduct0",
              "http://example.com/TestProduct0/favicon.ico", 0, { from: Account }));
    }

    // Get the product name
    storedData = await immutableProductInstance.productDetails(1, 0);
    
    assert.equal(storedData[0], "Test Product0", "Failed! Name mismatch.");
  });

  it("Edit product ", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(1);

    if (numProducts == 1)
    {
      // Edit the test product
      await immutableProductInstance.productEdit(0, "Test Product 0",
              "http://testproduct0.example.com/",
              "http://testproduct0.example.com/favicon.ico", 0, { from: Account });
    }

    // Get the product name
    storedData = await immutableProductInstance.productDetails(1, 0);
    
    assert.equal(storedData[0], "Test Product 0", "Failed! Name mismatch.");
  });

  it("Create a new product release", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf('1');

    if (numProducts <= 0)
    {
      // Create a new test product
      assert.equal(true, false, "Failed, product does not exist");
      return;
    }

    // Create the release
    const receipt = await creatorTokenInstance.creatorReleases([0], [3], [0x900DF00D],
            ["http://example.com/releases/MasterContract.pdf"], [0],
            { from: Account });

    console.log("GasUsed: " + bigInt(receipt.receipt.gasUsed).toString(10))

    // Read back the release hash
    const details = await creatorTokenInstance.
                                       creatorReleaseDetails(1, 0, 0);

    assert.equal(details[2], 0x900DF00D, "Failed! Release hash mismatch.");
  });

  it("Create 10 new product release", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf('1');

    if (numProducts <= 0)
    {
      // Create a new test product
      assert.equal(true, false, "Failed, product does not exist");
      return;
    }

    // Create 10 releases
    const receipt = await creatorTokenInstance.creatorReleases([0,0,0,0,0,0,0,0,0,0],
            [4, 5, 6, 7, 8, 9, 10, 11, 12, 13], [0x900DF01D, 0x900DF02D,
            0x900DF03D, 0x900DF04D, 0x900DF05D, 0x900DF06D, 0x900DF07D,
            0x900DF08D, 0x900DF09D, 0x900DF0AD],
            ["http://example.com/releases/TestProduct10.pdf", "http://example.com/releases/TestProduct11.zip",
             "http://example.com/releases/TestProduct12.zip", "http://example.com/releases/TestProduct13.zip",
             "http://example.com/releases/TestProduct14.zip", "http://example.com/releases/TestProduct15.zip",
             "http://example.com/releases/TestProduct16.zip", "http://example.com/releases/TestProduct17.zip",
             "http://example.com/releases/TestProduct18.zip", "http://example.com/releases/Client10Contract.pdf"],
             [0, 0, 0, 0, 0, 0, 0, 0, 0, 0x900DF00D],
            { from: Account });

    console.log("GasUsed: " + bigInt(receipt.receipt.gasUsed).toString(10))

    // Read back the release hash
    const details = await creatorTokenInstance.
                                       creatorReleaseDetails(1, 0, 0);

    assert.equal(details[2], 0x900DF00D, "Failed! Release hash mismatch.");
  });

  it("Reverse lookup a product release", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf('1');

    if (numProducts <= 0)
    {
      // Create a new test product
      assert.equal(true, false, "Failed, product does not exist");
      return;
    }

    // Reverse lookup from the release hash
    const details = await creatorTokenInstance.creatorReleaseHashDetails(0x900DF00D);

//                                  external view returns (uint256, uint256, uint256, uint256, string memory)

    var version = bigInt(details[3]);

    assert.equal(details[0], 1, "Failed! Entity ID not 1.");
    assert.equal(details[1], 0, "Failed! Product ID not 0.");
    assert.equal(details[2], 0, "Failed! Release ID not 0.");

    // Skip over timestamp to check last byte of version
    assert.equal(version.toString(16)[version.toString(16).length - 1],
                 "3", "Failed! Version not 3.");
    assert.equal(details[4], "http://example.com/releases/MasterContract.pdf",
                                "Failed! URI does not match");
  });

  it("Look up release URI with tokenId", async () => {

    // Look up URI from the manually generated tokenId                                                                                                   
    const details = await creatorTokenInstance.
     //         |EntityID|ProdID|RelID  |
     tokenURI('0x0000000100000000000000000000000000000000000000000000000000000000');

    assert.equal(details, "http://example.com/releases/MasterContract.pdf",
                                "Failed! URI does not match");
  });

  it("Check owner of new release token", async () => {

    const tokenOwner = await creatorTokenInstance.
      ownerOf('0x0000000100000000000000000000000000000000000000000000000000000000');

    assert.equal(Account, tokenOwner);
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
      if (i == 0)
        var testResult = "Test Product ";
      else
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
             "http://example2.com", { from: SecondAccount });

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
    // Create the release
    await creatorTokenInstance.creatorReleases([0], [0], [0x0D0DF00D],
            ["http://example2.com/releases/TestProduct20.zip"], [0],
            { from: SecondAccount });

    // Read back the release hash
    const details = await creatorTokenInstance.creatorReleaseDetails(2, 0, 0);

    assert.equal(details[2], 0x0D0DF00D, "Failed! Release hash mismatch.");
  });

  it("Create and test a license", async () => {
    // Get the organization name
    var entity = await immutableEntityInstance.entityDetailsByIndex(1);

    if (entity[0] == "")
    {
      // Create a new test organization
      await immutableEntityInstance.entityCreate("Test Org",
             "http://example.com", { from: Account });

      // Get the organization name
      entity = await immutableEntityInstance.entityDetailsByIndex(1);
    }

    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(1);

    if (numProducts == 0)
    {
      // Assert failure
      assert.equal(1, 0, "No products exist");
    }

    // Set Expiration (1), Limitation (2) flags, add activation value 1
    var value = bigInt('0x3').shiftLeft(160).add(1);//0000000000000000000000000000000000000001');
    // Create the product license
    await productActivateInstance.activateCreate(0, 0xFEEDBEEF, '0x' + value.toString(16),
                                                 0, 0, { from: Account });//,
//                                               value: 1000000000000000 });

    // Check validity of the license
    var storedData = await activateTokenInstance.activateStatus(1, 0, 0xFEEDBEEF);
//    var licenseValue = new BN('0x' + storedData[0].toString(16));

    value = bigInt(storedData[0]);
//    var flags = value.shiftRight(160).and(0xFFFF);
//    var expiration = value.shiftRight(128).and(0xFFFFFFFF);
    
    assert.equal(value.toString(16)[0], '3', "Failed! License flags is not zero.");
    assert.equal(value.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License sale price not zero.");
  });

  it("Create and test a non-resellable license", async () => {
    // Get the organization name
    var entity = await immutableEntityInstance.entityDetailsByIndex(1);

    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(1);

    if (numProducts == 0)
    {
      // Assert failure
      assert.equal(1, 0, "No products exist");
    }

    // Set Expiration (1), Limitation (2) and NoResale (4) flags
    var value = bigInt('0x7').shiftLeft(160).add(1);
    // Create the product license
    await productActivateInstance.activateCreate(0, 0xFEEDB00F, '0x' + value.toString(16),
                                                 0, 0, { from: Account });//,
//                                               value: 1000000000000000 });

    // Check validity of the license
    var storedData = await activateTokenInstance.activateStatus(1, 0, 0xFEEDB00F);
//    var licenseValue = new BN('0x' + storedData[0].toString(16));

    value = bigInt(storedData[0]);
//    var flags = value.shiftRight(160).and(0xFFFF);
//    var expiration = value.shiftRight(128).and(0xFFFFFFFF);
    
    assert.equal(value.toString(16)[0], '7', "Failed! License flags is not 7.");
    assert.equal(value.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License sale price not zero.");
  });

  it("Offer non-resellable activation for resale (reverts)", async () => {
    await truffleAssert.reverts(productActivateInstance.
      activateOfferResale(1, 0, 0xFEEDB00F, 5000000000, { from: Account }));
  });

  it("Ensure ownership transfer of non-resellable activation", async () => {

    const tokenId = await activateTokenInstance.activateIdToTokenId(0xFEEDB00F);

    await activateTokenInstance.approve(EndUser, tokenId, { from: Account });

    await activateTokenInstance.transferFrom(Account, EndUser, tokenId, { from: Account });

    let tokenOwner = await activateTokenInstance.ownerOf(tokenId);
    assert.equal(tokenOwner.toString(16), EndUser.toString(16), "Token owner not changed.");
    
  });

// start Ricardian activation tests
  it("Create and test a Ricardian required license", async () => {
    // Get the organization name
    var entity = await immutableEntityInstance.entityDetailsByIndex(1);

    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(1);

    if (numProducts == 0)
    {
      // Assert failure
      assert.equal(1, 0, "No products exist");
    }

    // Set Expiration (1), Limitation (2) and RicardianReq (64 ie. 0x40) flags
    var value = bigInt('0x43').shiftLeft(160).add(1);

    // Ensure revert if RicardianReq flag but no parent
    await truffleAssert.reverts(productActivateInstance.activateCreate(0, 0xFEEDB11F, '0x' + value.toString(16),
                                                 0, 0, { from: Account }));

    // Create the product license if Ricardian Required transfer
    await productActivateInstance.activateCreate(0, 0xFEEDB11F, '0x' + value.toString(16),
                                                 0, 0x900DF00D, { from: Account });//,
//                                               value: 1000000000000000 });

    // Check validity of the license
    var storedData = await activateTokenInstance.activateStatus(1, 0, 0xFEEDB11F);
//    var licenseValue = new BN('0x' + storedData[0].toString(16));

    value = bigInt(storedData[0]);
//    var flags = value.shiftRight(160).and(0xFFFF);
//    var expiration = value.shiftRight(128).and(0xFFFFFFFF);
    
    assert.equal(value.toString(16)[0], '4', "Failed! License flags is not 4.");
    assert.equal(value.toString(16)[1], '3', "Failed! License flags is not 3.");
    assert.equal(value.toString(16).length, 42, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License sale price not zero.");
  });

  it("Check Account owns a Ricardian client - creatorHasChildOf()", async () => {

    // Check that the new address has Ricardian client - creatorHasChildOf()
    const receipt = await creatorTokenInstance.creatorHasChildOf(Account,
                                                                 0x900DF00D);

    assert.equal(receipt, 1, "Failed! Release parent depth not one (1).");
  });

  it("Ensure ownership transfer of Ricardian required activation", async () => {

    const tokenId = await activateTokenInstance.activateIdToTokenId(0xFEEDB11F);

    await activateTokenInstance.approve(EndUser, tokenId, { from: Account });

    await activateTokenInstance.transferFrom(Account, EndUser, tokenId, { from: Account });

    let tokenOwner = await activateTokenInstance.ownerOf(tokenId);
    assert.equal(tokenOwner.toString(16), EndUser.toString(16), "Token owner not changed.");
    
  });

  it("Offer Ricardian required activation for resale", async () => {
    var offerResult = await productActivateInstance.
      activateOfferResale(1, 0, 0xFEEDB11F, 5000000000, { from: EndUser });

    const tokenId = await activateTokenInstance.activateIdToTokenId(0xFEEDB11F);

//    var tid = bigInt(tokenId);
//    console.log("TokenId " + tokenId + " tid " + tid);
    await activateTokenInstance.approve(productActivateInstance.address, tokenId, { from: EndUser });
  });

  it("Check address that does not own a Ricardian client (revert)", async () => {

    // Check that the new address has Ricardian client - creatorHasChildOf()
    let result = await creatorTokenInstance.creatorHasChildOf(EndUser,
                                                                 0x900DF00D);
    assert.equal(result, 0, "Failed! Release parent depth not zero (0).");
  });

  it("Ensure revert if RicardianReq flag but owner has no client", async () => {
    // Ensure revert if RicardianReq flag but owner has no client
    await truffleAssert.fails(productActivateInstance.activateTransfer(
              1, 0, 0xFEEDB11F, 0x900DF0AD, { from: EndUser2, value: 5000000000 }));

  });

  it("Purchase second hand activation license with Ricardian requirement", async () => {
    // Check the license
    let result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xFEEDB11F);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '4', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 42, "Failed! License value not large enough."); 

    // Transfer (resell) the product activation license (Account has client)
    await productActivateInstance.activateTransfer(
              1, 0, 0xFEEDB11F, 0xFEEDB12F, { from: Account, value: 5000000000 });

    // Check the new license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xFEEDB12F);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '4', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 42, "Failed! License value not large enough."); 

  });

// end Ricardian activation tests

  it("Mint a new activate tokenId as token contract owner (reverts)", async () => {

    // Look up URI from the                                                                                                   
    await truffleAssert.fails(activateTokenInstance.
      mint(Owner, 1, 0, 0xFEED0FF, 0, 0, { from: Owner }));
  });

  it("Update an organization status", async () => {
    // Update the organization status to a distributor (2)
    await immutableEntityInstance.entityStatusUpdate(
                                                 1, 2, { from: Owner });

    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(1);

    assert.equal(status, 2, "Failed! Status not two (Distributor).");
  });

  it("Create a nonprofit organization and product release", async () => {
    // Create a new test organization
    await immutableEntityInstance.entityCreate("OrgAccount1",
             "http://orgaccount1.com", { from: accounts[9] });

    // Update the organization status with Automatic = (2 << 32);
    var NonprofitCreator = new BN(0x100000001); // (1 << 32) non-profit flag
//    NonprofitCreator = NonprofitCreator + 1; // Creator
    assert.equal("0x" + NonprofitCreator.toString(16), "0x100000001" , "Failed! Status number mismatch");

    await immutableEntityInstance.entityStatusUpdate(3, "0x" + NonprofitCreator.toString(16), { from: Owner });

    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(3);

    assert.equal("0x" + status.toString(16), "0x100000001" , "Failed! Status not four (non-profit).");

    // Create a new test product
    await immutableProductInstance.productCreate("Test Nonprofit",
              "http://nonprofit.org/TestProduct",
              "http://nonprofit.org/TestProduct/favicon.ico", 0, { from: accounts[9] });

    // Create the release
    await creatorTokenInstance.creatorReleases([0], [0], [0x0D1DF00D],
            ["http://nonprofit.org/releases/TestProduct.zip"], [0],
            { from: accounts[9] });
  });

  it("Create a product license offer", async () => {
    // Create the produce license offer for a one year activation

    // Update the license value with the expiration
    var expiringLicense = bigInt(365 * (24 * (60 * 60)));//.shiftLeft(128);

    // Add the product activation value (1)
//    expiringLicense = expiringLicense.add(1);

    await immutableProductInstance.productOfferLimitation(0,
       '0x0000000000000000000000000000000000000000', 10000000000,
       0, '0x' + expiringLicense.toString(16), 0, 0, "", 0, 0, 0, { from: Account });

    var offerPrice = await immutableProductInstance.productOfferDetails(1, 0, 0, { from: Account });
    assert.equal(offerPrice[1], 10000000000, "Failed, product activation license price mismatch");
  });

  it("Purchase a product activation license", async () => {
//    const origBalance = await immuteTokenInstance.balanceOf(Account);
    // Create the product activation license offer
    //  (entity, productID, activationHash)
    const receipt = await productActivateInstance.activatePurchase(
              1, 0, 0, 1, [0xF00D], [0], { from: EndUser, value: 10000000000 });
    console.log("GasUsed: " + bigInt(receipt.receipt.gasUsed).toString(10))

    // Check the license. (entity, productID, activation hash)
    var storedData = await activateTokenInstance.activateStatus(1, 0, 0xF00D);

    var licenseValue = bigInt(storedData[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! License flags is not zero.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License sale price not zero.");

//    const newBalance = await immuteTokenInstance.balanceOf(Account);

//    assert.equal(newBalance - origBalance, 9900130304,
//                 "Failed, not enough tokens transferred to creator!");
  });

  it("Purchase 10 product activation licenses", async () => {
//    const origBalance = await immuteTokenInstance.balanceOf(Account);
    // Create the product activation license offer
    //  (entity, productID, activationHash)
    const receipt = await productActivateInstance.activatePurchase(
              1, 0, 0, 10, [0xF01D, 0xF02D, 0xF03D, 0xF04D, 0xF05D,0xF06D,0xF07D,0xF08D,0xF09D,0xF0AD],
              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], { from: EndUser, value: 10000000000 * 10});
    console.log("GasUsed: " + bigInt(receipt.receipt.gasUsed).toString(10))

    // Check the license. (entity, productID, activation hash)
    var storedData = await activateTokenInstance.activateStatus(1, 0, 0xF01D);

    var licenseValue = bigInt(storedData[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! License flags is not zero.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License sale price not zero.");

//    const newBalance = await immuteTokenInstance.balanceOf(Account);

//    assert.equal(newBalance - origBalance, 9900130304 ,
//                 "Failed, not enough tokens transferred to creator!");
  });

  it("Extend a product activation license", async () => {
//    var origBalance = await immuteTokenInstance.balanceOf(Account);

    // Create the product activation license offer
    //  (entity, productID, activationHash)
    await productActivateInstance.activatePurchase(
              1, 0, 0, 1, [0xF00D], [0], { from: EndUser, value: 10000000000 });

    // Check the license. (entity, productID, activation hash)
    const storedData = await activateTokenInstance.activateStatus(1, 0, 0xF00D);
    var licenseValue = bigInt(storedData[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! License flags is not zero.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License sale price not zero.");

//    var newBalance = await immuteTokenInstance.balanceOf(Account);

//    assert.equal(newBalance.sub(origBalance), 9900000000 ,
//                 "Failed, not enough tokens transferred to creator!");
  });

  it("Purchase a duplicate product activation license with a different user", async () => {
    // Ensure revert if purchase of a duplicate activation license
    //  (entity, productID, activationHash, promotional)
    await truffleAssert.fails(productActivateInstance.activatePurchase(
              1, 0, 0, 1, [0xF00D], [0], { from: EndUser2, value: 10000000000 }));
    // Check the license. (entity, productID, activation hash)
    const storedData = await activateTokenInstance.activateStatus(1, 0, 0xF00D);

    // Check to ensure license is still valid
    var licenseValue = bigInt(storedData[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! License flags is not zero.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License sale price not zero.");

  });

  it("Move a purchased activation license", async () => {
//    const oldBalance = await immuteTokenInstance.balanceOf(EndUser);

    // Check the license
    let result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xF00D);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! License flags is not zero.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(result[1], 0, "Failed! License sale price not zero.");

    // Move the product activation license offer
    await productActivateInstance.activateMove(
              1, 0, 0xF00D, 0xFEED, { from: EndUser, value: 1000000000000000 });

    // Check the old license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xF00D);
    assert.equal(result[0], 0, "Failed! Old license is not invalid.");

    // Check the new license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xFEED);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! New License flags is not zero.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(result[1], 0, "Failed! License sale price not zero.");

//    const newBalance = await immuteTokenInstance.balanceOf(EndUser);

//    var bigEscrow = new BN(100000000)
//    bigEscrow = bigEscrow * 10000000000; // two escrows
//    assert.equal(oldBalance.sub(newBalance), bigEscrow, "Tokens not charged for moving license");
  });

  it("Read all for sale activations from the ecosystem", async () => {
    // Read the for-sale activations from the ecosystem
    let activations = await activateTokenInstance.activateAllForSaleTokenDetails();

    assert.equal(activations[0].length, 0, "Failed! Not zero activations for sale." + activations[0].length);
  });

  it("Offer a product activation license for resale", async () => {
    await productActivateInstance.activateOfferResale(1, 0, 0xFEED, 5000000000, { from: EndUser });

    const tokenId = await activateTokenInstance.activateIdToTokenId(0xFEED);

//    var tid = bigInt(tokenId);
//    console.log("TokenId " + tokenId + " tid " + tid);
    await activateTokenInstance.approve(productActivateInstance.address, tokenId, { from: EndUser });
  });

  it("Purchase a second hand activation license", async () => {
    // Check the license
    let result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xFEED);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

    // Approve tokens for transfer to EndUser
//    await customTokenInstance.approve(EndUser, 5000000000,
//                                      { from: EndUser2 });

    // Transfer (resell) the product activation license
    await productActivateInstance.activateTransfer(
              1, 0, 0xFEED, 0xFEAD, { from: EndUser2, value: 5000000000 });

    // Check the new license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xFEAD);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

  });

  it("Purchase another product activation license and offer it for resale", async () => {
//    const origBalance = await immuteTokenInstance.balanceOf(Account);

    // Create the product activation license offer
    //  (entity, productID, activationHash)
    await productActivateInstance.activatePurchase(
              1, 0, 0, 1, [0xF00D], [0], { from: EndUser, value: 10000000000 });

    // Check the license. (entity, productID, activation hash)
    const storedData = await activateTokenInstance.activateStatus(1, 0, 0xF00D);

    var licenseValue = bigInt(storedData[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

    await productActivateInstance.activateOfferResale(1, 0, 0xF00D, 5000000000, { from: EndUser });

    const tokenId = await activateTokenInstance.activateIdToTokenId(0xF00D);

    await activateTokenInstance.approve(productActivateInstance.address, tokenId, { from: EndUser });

  });

  it("Extend existing activation with a second hand activation purchase", async () => {

    // Check the license
    let result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xF00D);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

    // Transfer (resell) the product activation license
    await productActivateInstance.activateTransfer(
              1, 0, 0xF00D, 0xFEAD, { from: EndUser2, value: 5000000000 });

    // Check the new license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xFEAD);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

  });

  it("Move a resold activation license", async () => {
    // Check the license
    let result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xFEAD);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

    // Move the product activation license offer
    await productActivateInstance .activateMove(
              1, 0, 0xFEAD, 0xF00D, { from: EndUser2, value: 1000000000000000 });

    // Check the old license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xFEED);
    assert.equal(result[0], 0, "Failed! Old license is not invalid.");

    // Check the new license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xF00D);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

  });

// test for resale transfer fee

  it("Create a product license offer with 600000000 (10%) resale transfer fee", async () => {
    // Create the produce license offer for a one year activation

    // Update the license value with the expiration
    var expiringLicense = bigInt(365 * (24 * (60 * 60)));//.shiftLeft(128);

    // Add the product activation value (1)
//    expiringLicense = expiringLicense.add(1);

    await immutableProductInstance.productOfferLimitation(0,
       '0x0000000000000000000000000000000000000000',     6000000000,
       0, '0x' + expiringLicense.toString(16), 0, 0, "", 0,  600000000, 0, { from: Account });

    var offerPrice = await immutableProductInstance.productOfferDetails(1, 0, 1, { from: Account });
    assert.equal(offerPrice[1], 6000000000, "Failed, product activation license price mismatch");
  });

  it("Purchase a product activation license with resale fee", async () => {

    // Create the product activation license offer
    //  (entity, productID, activationHash)
    const receipt = await productActivateInstance.activatePurchase(
              1, 0, 1, 1, [0xF88D], [0], { from: EndUser, value: 6000000000 });
    console.log("GasUsed: " + bigInt(receipt.receipt.gasUsed).toString(10))

    // Check the license. (entity, productID, activation hash)
    var storedData = await activateTokenInstance.activateStatus(1, 0, 0xF88D);

    var licenseValue = bigInt(storedData[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! License flags is not zero.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License sale price not zero.");

  });

  it("Offer a product activation with transfer fee for resale", async () => {
    await productActivateInstance.activateOfferResale(1, 0, 0xF88D, 1000000000, { from: EndUser });

    const tokenId = await activateTokenInstance.activateIdToTokenId(0xF88D);

//    var tid = bigInt(tokenId);
//    console.log("TokenId " + tokenId + " tid " + tid);
    await activateTokenInstance.approve(productActivateInstance.address, tokenId, { from: EndUser });
  });

  it("Purchase a second hand activation license with transfer fee", async () => {
    // Check the license
    let result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xF88D);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

    // Approve tokens for transfer to EndUser
//    await customTokenInstance.approve(EndUser, 5000000000,
//                                      { from: EndUser2 });

    // Revert on transfer of activation license without resale fee
    await truffleAssert.fails(productActivateInstance.activateTransfer(
              1, 0, 0xF88D, 0xF99D, { from: EndUser2, value: 1000000000 }));

    // Transfer the product activation license only with resale fee
    await productActivateInstance.activateTransfer(
              1, 0, 0xF88D, 0xF99D, { from: EndUser2, value: 1600000000 });

    // Check the new license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xF99D);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

  });


// End tests for resale transfer fee

  it("Create a new product for use as a ricardian legal agreement", async () => {
    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(1);
    if (status == 0)
    {
      // Update the organization status to a creator (1)
      await immutableEntityInstance.entityStatusUpdate(1, 1, { from: Owner });
    }

    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(1);

    // Create a new legal contract for test product
    await immutableProductInstance.productCreate("Test Product0 Legal Contract",
            "http://example.com/TestProduct0 Legal Contract",
            "http://example.com/TestProduct0 Legal Contract/favicon.ico", 0, { from: Account });

    // Get the product name
    storedData = await immutableProductInstance.productDetails(1, 3);
    
    assert.equal(storedData[0], "Test Product0 Legal Contract", "Failed! Name mismatch.");
  });

  it("Create the base ricarding contract agreement", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf('1');

    console.log("Entity1 numProducts " + numProducts)

    if (numProducts != 4)
    {
      // Create a new test product
      assert.equal(true, false, "Failed, product number inconsistent");
      return;
    }

    // Create the ricardian contract base
    const receipt = await creatorTokenInstance.creatorReleases([3], [0], ["0xDF00D1"],
            ["http://example.com/releases/TestProduct0 Legal Contract_v0.pdf"], [0],
            { from: Account });

    // Read back the release hash
    const details = await creatorTokenInstance.
                                       creatorReleaseDetails(1, 3, 0);

    assert.equal(details[2], 0xDF00D1, "Failed! Release hash mismatch.");
  });

  it("Reverse lookup the ricardian release", async () => {

    // Reverse lookup from the release hash
    const details = await creatorTokenInstance.creatorReleaseHashDetails("0xDF00D1");

//                                  external view returns (uint256, uint256, uint256, uint256, string memory)

    var version = bigInt(details[3]);

    assert.equal(details[0], 1, "Failed! Entity ID not 1.");
    assert.equal(details[1], 3, "Failed! Product ID not 3.");
    assert.equal(details[2], 0, "Failed! Release ID not 0.");

    // Skip over timestamp to check last byte of version
    assert.equal(version.toString(16)[version.toString(16).length - 1],
                 "0", "Failed! Version not 0.");
    assert.equal(details[4], "http://example.com/releases/TestProduct0 Legal Contract_v0.pdf",
                                "Failed! URI does not match");
  });

  it("Create the client agreed upon Ricarding contract leaf", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf('1');

    if (numProducts <= 0)
    {
      // Create a new test product
      assert.equal(true, false, "Failed, product does not exist");
      return;
    }

    // Create the ricardian contract base
    const receipt = await creatorTokenInstance.creatorReleases([3], [1], [0xDF00D2],
            ["http://example.com/releases/TestProduct0 Legal Contract_v0_client1.pdf"], [0xDF00D1],
            { from: Account });

    // Read back the release hash
    const details = await creatorTokenInstance.
                                       creatorReleaseDetails(1, 3, 1);

    assert.equal(details[2], 0xDF00D2, "Failed! Release hash mismatch.");
  });

  it("Reverse lookup the Ricardian release of client", async () => {

    // Reverse lookup from the release hash
    const details = await creatorTokenInstance.creatorReleaseHashDetails(0xDF00D2);

//                                  external view returns (uint256, uint256, uint256, uint256, string memory)

    var version = bigInt(details[3]);

    assert.equal(details[0], 1, "Failed! Entity ID not 1.");
    assert.equal(details[1], 3, "Failed! Product ID not 1.");
    assert.equal(details[2], 1, "Failed! Release ID not 1.");

    // Skip over timestamp to check last byte of version
    assert.equal(version.toString(16)[version.toString(16).length - 1],
                 "1", "Failed! Version not 1.");
    assert.equal(details[4], "http://example.com/releases/TestProduct0 Legal Contract_v0_client1.pdf",
                                "Failed! URI does not match");
  });

  it("Check Ricardian contract leaf is parent of", async () => {

    // Create the ricardian contract base
    const receipt = await creatorTokenInstance.creatorParentOf(0xDF00D2,
                                                               0xDF00D1);

    assert.equal(receipt, 1, "Failed! Release parent depth not one (1).");
  });

  it("Check address owns a Ricardian client - creatorHasChildOf()", async () => {

    // Check address owns a Ricardian client - creatorHasChildOf()
    const receipt = await creatorTokenInstance.creatorHasChildOf(Account,
                                                                 0xDF00D1);

    assert.equal(receipt, 1, "Failed! Release parent depth not one (1).");
  });

  it("Create a product license offer with ricardian requirement", async () => {
    // Create the produce license offer for a one year activation

    // Update the license value with the expiration
    var expiringLicense = bigInt(365 * (24 * (60 * 60)));//.shiftLeft(128);

    // Add the product activation value (1)
//    expiringLicense = expiringLicense.add(1);

    await immutableProductInstance.productOfferLimitation(0,
       '0x0000000000000000000000000000000000000000', 100000000000,
       0, '0x' + expiringLicense.toString(16), 0, 0, "", 0, 0, 0xDF00D1, { from: Account });

    var offerPrice = await immutableProductInstance.productOfferDetails(1, 0, 2, { from: Account });
    assert.equal(offerPrice[1], 100000000000, "Failed, product activation license price mismatch");
  });

  it("Purchase a product activation license with ricadian requirement", async () => {
//    const origBalance = await immuteTokenInstance.balanceOf(Account);
    // Create the product activation license offer
    //  (entity, productID, offerID (2 requires ricardian),
    //   numLicenses, activationHashes, clientRicardians)
    const receipt = await productActivateInstance.activatePurchase(
              1, 0, 2, 1, [0xF00D1], [0xDF00D2], { from: EndUser, value: 100000000000 });
    console.log("GasUsed: " + bigInt(receipt.receipt.gasUsed).toString(10))

    // Check the license. (entity, productID, activation hash)
    var storedData = await activateTokenInstance.activateStatus(1, 0, 0xF00D1);

    var licenseValue = bigInt(storedData[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! License flags is not zero.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License resale price not zero.");

//    const newBalance = await immuteTokenInstance.balanceOf(Account);

//    assert.equal(newBalance - origBalance, 9900130304 ,
//                 "Failed, not enough tokens transferred to creator!");
  });


  it("Configure a bank", async () => {
    // Configure the bank to be the same as the address
    await immutableEntityInstance.entityBankChange(Account, { from: Account });
  });
  it("Move an entity to a new address", async () => {
    // Configure next entity address and move tokens to escrow
    await immutableEntityInstance.entityAddressNext(Account2,
                           { from: Account });

    // Move the entity, including all the tokens
    await immutableEntityInstance.entityAddressMove(Account, { from: Account2 });

//    var oldAccountBalanceAfter = await immuteTokenInstance.balanceOf(Account);
//    var newAccountBalanceAfter = await immuteTokenInstance.balanceOf(Account2);

//    assert.equal(oldAccountBalanceAfter, 0, "Old account balance is not zero");
//    assert.equal(newAccountBalanceAfter - newAccountBalanceBefore, oldAccountBalanceBefore, "New account did not get tokens");
  });

  it("Create a product license offer for ETH", async () => {
    // Create the produce license offer for a one year activation

    // Update the license value with the expiration
    var expiringLicense = bigInt(365 * (24 * (60 * 60)));//.shiftLeft(128);

    // Add the product activation value (1)
//    expiringLicense = expiringLicense.add(1);

    await immutableProductInstance.productOfferLimitation(0,
       '0x0000000000000000000000000000000000000000', 20000000000,
       0, '0x' + expiringLicense.toString(16), 0, 0, "", 0, 0, 0, { from: Account2 });

    var offerPrice = await immutableProductInstance.productOfferDetails(1, 0, 3, { from: Account });
    assert.equal(offerPrice[1], 20000000000, "Failed, product activation license price mismatch");

//    var rawExpiration = bigInt(offerPrice[2]);
//    assert.equal(expiringLicense.toString(16), rawExpiration.toString(16), "Failed, product activation license duration mismatch");
  });

  it("Purchase activation license with ETH", async () => {
    var ethInEscrow = await immutableEntityInstance.entityPaymentsCheck({ from: Account2});
    
//    var bigPurchase = new BN(20000000000); // license price
    // Convert big purchase to ETH
//    bigPurchase = bigPurchase / rate;
    await productActivateInstance.activatePurchase(
              1, 0, 3, 1, [0xBEEF], [0], { from: EndUser, value: 20000000000 });

    var ethOutEscrow = await immutableEntityInstance.entityPaymentsCheck({ from: Account2});
    assert.equal(ethOutEscrow.sub(ethInEscrow).toString(10), 19800000000, "Failed, ETH in escrow incorrect amount");

  });

  it("Move a purchased activation license after entity move", async () => {
//    var newAccountBalanceBefore = await immuteTokenInstance.balanceOf(EndUser2);

    // Extend the product activation license for 0xBEEF
    //  (entity, productID, offerIndex, activationHash)
    await productActivateInstance.activatePurchase(
              1, 0, 0, 1, [0xBEEF], [0], { from: EndUser, value: 10000000000 });

//    var oldAccountBalanceBefore = await immuteTokenInstance.balanceOf(EndUser);

    // Check the license. (entity, productID, activation hash)
    var result = await activateTokenInstance.activateStatus(1, 0, 0xBEEF);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

    // Create an end user entity account
    await immutableEntityInstance.entityCreate("John Smith",
             "http://linkedin.com/john_smith", { from: EndUser });
    var entityIndex = await immutableEntityInstance.entityAddressToIndex(EndUser);

    // Update the end user status to an EndUser (3)
    await immutableEntityInstance.entityStatusUpdate(entityIndex, 3, { from: Owner });

    // Configure next entity address and move tokens to escrow
    await immutableEntityInstance.entityAddressNext(EndUser2,
                           { from: EndUser });

    // Move the activations, ie. all activate tokens
    await activateTokenInstance.activateOwner(EndUser2, { from: EndUser });

    // Move the entity, including all the tokens
    await immutableEntityInstance.entityAddressMove(EndUser, { from: EndUser2 });

    // Check the license after moving entity
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xBEEF);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

    // Move product activation license offer with new entity address
    await productActivateInstance.activateMove(
              1, 0, 0xBEEF, 0xDEED, { from: EndUser2, value: 1000000000000000 });

    // Check the old license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xBEEF);
    assert.equal(result[0], 0, "Failed! Old license should not be valid.");

    // Check the new license
    result = await activateTokenInstance.
                                     activateStatus(1, 0, 0xDEED);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 
  });

  it("Revoke a product license offer", async () => {
    // Revoke the produce license offer
    await immutableProductInstance.productOfferEditPrice(0, 0, 0, { from: Account2 });

    // Create the product activation license offer
    //  (entity, productID, activationHash)
    result = await immutableProductInstance.productOfferDetails(
              1, 0, 0);
    assert.equal(result[0], 0, "Failed! License offer not zero.");
    await truffleAssert.reverts(productActivateInstance.activatePurchase(
          1, 0, 0, 1, [0xF00D], [0], { from: EndUser }), "Offer not found");
  });

  //////////////////////////////////////////////////////////
  // Custom ERC20 token
  //////////////////////////////////////////////////////////

  it("Find or create new entity using custom ERC20 token", async () => {
    // Get the organization name
    var storedData = await immutableEntityInstance.entityDetailsByIndex(5);

    if (storedData[0] == "")
    {
      var nonprofitIndex = await immutableEntityInstance.entityAddressToIndex(accounts[9]);
      assert.equal(3, nonprofitIndex, "Failed, referral index not 3");

      // Create a new test organization for custom token
      await immutableEntityInstance.entityCreate("Test Company 4",
             "http://company.com", { from: Account });

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
//    const beforeBalance = await immuteTokenInstance.balanceOf(accounts[9]);
    var CustomTokenCreator = new BN(0x600000001); // (1 << 34) custom token flag
                                                  // (1 << 33) automatic

    // Update organization status to custom token (1 << 34) and creator (1)
    await immutableEntityInstance.entityStatusUpdate(
           5, '0x' + CustomTokenCreator.toString(16), { from: Owner });

    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(5);

    assert.equal("0x" + status.toString(16), "0x600000001", "Failed! Status not custom token creator.");
  });
  it("Find or create a new product ", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(5);

    if (numProducts == 0)
    {
//      const beforeBalance = await immuteTokenInstance.balanceOf(accounts[9]);
      // Create a new test product
      await immutableProductInstance.productCreate("Test Product4",
              "http://example.com/TestProduct0",
              "http://example.com/TestProduct0/favicon.ico", 0, { from: Account });
    }

    // Get the product name
    storedData = await immutableProductInstance.productDetails(5, 0);

    assert.equal(storedData[0], "Test Product4", "Failed! Name mismatch.");
  });

  it("Create a new product release", async () => {
    // Get the number of products
    const numProducts = await immutableProductInstance.productNumberOf(5);

    assert.equal(numProducts, 1, "One product not found");

    // Create the release
    await creatorTokenInstance.creatorReleases([0], [0], [0x900DFEED],
            ["http://example.com/releases/TestProduct.zip"], [0],
            { from: Account });

    // Read back the release hash
    const details = await creatorTokenInstance.
                                  creatorReleaseDetails(5, 0, 0);

    assert.equal(details[2], 0x900DFEED, "Failed! Release hash mismatch.");
  });
  
  it("Create a product license offer with custom token", async () => {
    // Update the license value with the expiration
    var expiringLicense = bigInt(365 * (24 * (60 * 60)));//.shiftLeft(128);

    // Add the product activation value (1)
//    expiringLicense = expiringLicense.add(1);

    // Create the produce license offer
//    await creatorTokenInstance.productOffer(0, customTokenInstance.address, 10000000000,
//       '0x' + expiringLicense.toString(16), "", { from: Account });

    await immutableProductInstance.productOfferLimitation(0,
       customTokenInstance.address, 10000000000,
       0, '0x' + expiringLicense.toString(16), 0, 0, "", 0, 0, 0, { from: Account });

    const offerPrice = await immutableProductInstance.productOfferDetails(5, 0, 0, { from: Account });
    assert.equal(offerPrice[1], 10000000000, "Failed, product activation license price mismatch");
    assert.equal(offerPrice[0], customTokenInstance.address, "Failed, product activation license toke address mismatch");
  });

  it("Purchase a custom token product activation license", async () => {
    const beforeBalance = await customTokenInstance.balanceOf(accounts[0]);

    // Approve custom tokens for transfer
    await customTokenInstance.approve(productActivateInstance.address, 10000000000,
                                              { from: accounts[0] });

    // Create the product activation license offer
    //  (entity, productID, activationHash)
    await productActivateInstance.activatePurchase(
              5, 0, 0, 1, [0xFEAD], [0], { from: accounts[0] });

    // Check the license. (entity, productID, activation hash)
    const storedData = await activateTokenInstance.activateStatus(5, 0, 0xFEAD);

    var licenseValue = bigInt(storedData[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

    const afterBalance = await customTokenInstance.balanceOf(accounts[0]);

    assert.equal(beforeBalance.sub(afterBalance), 10000000000, "Failed, tokens not transferred.");
  });

  it("Create customer, move and offer activation license for resale", async () => {
    // We have purchased an activation but are unregistered
    //  After registering and being approved, if we move an activation
    //  it becomes managed and can be resold

    // Create a new test organization with referral
    await immutableEntityInstance.entityCreate("Owner Company",
             "https://immutablesoft.org", { from: accounts[0] });

    // Update organization status with Automatic (1 << 33) creator (1 << 0)
    var Automatic = new BN(0x200000001); // automatic and creator flags
    await immutableEntityInstance.entityStatusUpdate(
           6, "0x" + Automatic.toString(16), { from: Owner });

    // Move the product activation license offer
    await productActivateInstance.activateMove(
              5, 0, 0xFEAD, 0xFAD0, { from: accounts[0] });

    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 20000000000;
          
    // Finally, offer the purchased activation for sale
    await productActivateInstance.activateOfferResale(5, 0, 0xFAD0,
               '0x' + bigPurchase.toString(16), { from: accounts[0] });

    const tokenId = await activateTokenInstance.activateIdToTokenId(0xFAD0);

    await activateTokenInstance.approve(productActivateInstance.address, tokenId, { from: accounts[0] });
  });

  it("Purchased third party custom token activation license", async () => {

    // Check the license
    let result = await activateTokenInstance.
                                     activateStatus(5, 0, 0xFAD0);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

    let oldBalance = await web3.eth.getBalance(EndUser);
    console.log("Eth balance " + oldBalance);
    //    const oldBalance = await accounts[0].balance();//immuteTokenInstance.balanceOf(accounts[0]);

    var bigPurchase = new BN(100000000)
    bigPurchase = bigPurchase * 20000000000;

    // Transfer (purchase) the product activation license offer
    await productActivateInstance.activateTransfer(5, 0, 0xFAD0, 0xFEED,
             { from: EndUser, value: '0x' + bigPurchase.toString(16) });

    // Check the new license
    result = await activateTokenInstance.
                                     activateStatus(5, 0, 0xFEED);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

//    const newBalance = await accounts[0].balance();//immuteTokenInstance.balanceOf(accounts[0]);
    let newBalance = await web3.eth.getBalance(EndUser);
    console.log("Eth balance " + newBalance);

    // Ensure enough ETH transferred, gas cost ensures not equal
    if (oldBalance - newBalance < bigPurchase.toString(10))
      assert.equal(oldBalance - newBalance, bigPurchase.toString(10), "Tokens not charged for resell");
  });

  it("Move a resold custom token activation license", async () => {
      // Check the license
    let result = await activateTokenInstance.
                                     activateStatus(5, 0, 0xFEED);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

//    const oldBalance = await immuteTokenInstance.balanceOf(EndUser);

    // Move the product activation license offer
    await productActivateInstance.activateMove(
              5, 0, 0xFEED, 0xF00D, { from: EndUser, value: 1000000000000000 });

    // Check the old license
    result = await activateTokenInstance.
                                     activateStatus(5, 0, 0xFEED);
    assert.equal(result[0], 0, "Failed! Old license is not invalid.");

    // Check the new license
    result = await activateTokenInstance.
                                     activateStatus(5, 0, 0xF00D);
    var licenseValue = bigInt(result[0]);

    assert.equal(licenseValue.toString(16)[0], '3', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 41, "Failed! License value not large enough."); 

  });

  it("Create one-time license ERC20 offer", async () => {
    // Update the license value with the expiration
    var expiringLicense = bigInt(365 * (24 * (60 * 60)));//.shiftLeft(128);

    // Add the product activation value (1)
//    expiringLicense = expiringLicense.add(1);

    // Create the produce license offer
//    await creatorTokenInstance.productOffer(0, customTokenInstance.address, 10000000000,
//       '0x' + expiringLicense.toString(16), "", { from: Account });

    await immutableProductInstance.productOfferLimitation(0,
       customTokenInstance.address, 14000000000,
       0, '0x' + expiringLicense.toString(16), 1, 0, "", 0, 0, 0, { from: Account });

    const offerPrice = await immutableProductInstance.productOfferDetails(5, 0, 1, { from: Account });
    assert.equal(offerPrice[1], 14000000000, "Failed, product activation license price mismatch");
    assert.equal(offerPrice[0], customTokenInstance.address, "Failed, product activation license toke address mismatch");
  });

  it("Purchase a ERC20 token product activation license from limited offer", async () => {
    const beforeBalance = await customTokenInstance.balanceOf(accounts[0]);

    // Approve custom tokens for transfer
    await customTokenInstance.approve(productActivateInstance.address, 28000000000,
                                              { from: accounts[0] });

    // Purchase this offer
    await productActivateInstance.activatePurchase(
              5, 0, 1, 1, [0xFEAD], [0], { from: accounts[0] });

    // Check the license. (entity, productID, activation hash)
    const storedData = await activateTokenInstance.activateStatus(5, 0, 0xFEAD);

    var licenseValue = bigInt(storedData[0]);

    assert.equal(licenseValue.toString(16)[0], '1', "Failed! Not licensed.");
    assert.equal(licenseValue.toString(16).length, 42, "Failed! License value not large enough."); 

    const afterBalance = await customTokenInstance.balanceOf(accounts[0]);

    assert.equal(beforeBalance.sub(afterBalance), 14000000000, "Failed, tokens not transferred.");

    // Purchase another offer (ensure it reverts - no more offers
    await truffleAssert.fails(productActivateInstance.activatePurchase(
              5, 0, 1, 1, [0x1FEAD], [0], { from: accounts[0] }));
  });

  it("Create a product license 10 activation bulk offer", async () => {
    // Create the produce license offer for a one year activation

    // Update the license value with the expiration
    var expiringLicense = bigInt(365 * (24 * (60 * 60)));


    await immutableProductInstance.productOfferLimitation(0,
       '0x0000000000000000000000000000000000000000', 16000000000,
       0, '0x' + expiringLicense.toString(16), 0, 10, "", 0, 0, 0, { from: Account });

    var offerPrice = await immutableProductInstance.productOfferDetails(5, 0, 1, { from: Account });
    console.log("offer price: 0x" + offerPrice[1].toString(16));
    assert.equal(offerPrice[1], 16000000000, "Failed, product activation license price mismatch");
  });

  it("Purchase a bulk of 10 activation licenses", async () => {

    // Purcahse the product activation license offer
    const receipt = await productActivateInstance.activatePurchase(
              5, 0, 1, 1,
              [0xF10D, 0xF20D,0xF30D,0xF40D,0xF50D,0xF60D,0xF70D,0xF80D,0xF90D,0xFA0D],
              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], { from: EndUser, value: 16000000000 });
    console.log("GasUsed: " + bigInt(receipt.receipt.gasUsed).toString(10))

    // Check the license. (entity, productID, activation hash)
    var storedData = await activateTokenInstance.activateStatus(5, 0, 0xFA0D);

    var licenseValue = bigInt(storedData[0]);

//    console.log("license value: 0x" + licenseValue.toString(16));
    assert.equal(licenseValue.toString(16)[0], '2', "Failed! License flags is not zero.");
    assert.equal(licenseValue.toString(16).length, 42, "Failed! License value not large enough."); 
    assert.equal(storedData[1], 0, "Failed! License sale price not zero.");

  });

  it("Read all the entities", async () => {
    // Read all the entities
    let entities = await immutableEntityInstance.entityAllDetails();

    assert.equal(entities[1][0], "Test Org", "Failed! Test Org not found." + entities[1]);
  });

  it("Read all the products for the first entity", async () => {
    // Read all the products for entity one
    let products = await immutableProductInstance.productAllDetails(1);

    assert.equal(products[0].length, 4, "Failed! Result array length not 3" + products[0].length);
    assert.equal(products[0][0], "Test Product 0", "Failed! Test Product 0 not found." + products[0]);
  });

  it("Read all the releases for the first entity, first product", async () => {
    // Read all the releases for the first product
    let releases = await creatorTokenInstance.creatorAllReleaseDetails(1, 0);

    assert.equal(releases[1][0], "http://example.com/releases/MasterContract.pdf",
      "Failed! Release URI does not match." + releases[1]);
  });


  it("Read all (15) activations for the fourth entity (enduser/enduser2)", async () => {
    // Read all the activations for the end user
    let activations = await activateTokenInstance.activateAllDetails(4);

    assert.equal(activations[0].length, 16, "Failed! Not fifteen (16) activations." + activations[0].length);
  });

  it("Offer product activation license for resale", async () => {
    await productActivateInstance.activateOfferResale(5, 0, 0xF00D, 5000000000, { from: EndUser });

    const tokenId = await activateTokenInstance.activateIdToTokenId(0xF00D);

//    var tid = bigInt(tokenId);
//    console.log("TokenId " + tokenId + " tid " + tid);
    await activateTokenInstance.approve(productActivateInstance.address, tokenId, { from: EndUser });
  });

  it("Read all for sale activations from the ecosystem", async () => {
    // Read the for-sale activations from the ecosystem
    let activations = await activateTokenInstance.activateAllForSaleTokenDetails();

    assert.equal(activations[0].length, 1, "Failed! Not one (1) activation for sale." + activations[0].length);
  });

});
