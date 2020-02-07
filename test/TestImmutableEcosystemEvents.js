const ImmutableProduct = artifacts.require("./ImmutableProduct.sol");
const ImmutableEntity = artifacts.require("./ImmutableEntity.sol");
const truffleAssert = require('truffle-assertions');

contract("ImmutableEcosystemEvents", accounts => {

  it("Check the new organization event", async () => {
    const immutableEntityInstance = await ImmutableEntity.deployed();
    
    // Create a new test organization
    let newEntity = await immutableEntityInstance.entityCreate("Test Org Event",
             "http://exampleEvent.com", 0, { from: accounts[1] });
 
    truffleAssert.eventEmitted(newEntity, 'entityEvent', (ev) => {
        return ev.entityIndex == 1 && ev.name === "Test Org Event";
    });

  });

  it("Check the new product event", async () => {
    const immutableEntityInstance = await ImmutableEntity.deployed();
    const immutableProductInstance = await ImmutableProduct.deployed();
    
    // Read back the organization status
    const status = await immutableEntityInstance.entityIndexStatus(1);
    if (status == 0)
    {
      // Administrator (accounts[0]) must update status to a creator (1)
      await immutableEntityInstance.entityStatusUpdate(
                                                 1, 1, { from: accounts[0] });
    }

    // Create a new test organization
    let newEntity = await immutableProductInstance.productCreate("Test Product Event",
             "http://exampleEvent.com", "http://exampleEvent.com/favicon.ico", 0, { from: accounts[1] });
 
    truffleAssert.eventEmitted(newEntity, 'productEvent', (ev) => {
        return ev.entityIndex == 1 && ev.name === "Test Product Event";
    });

  });

});
