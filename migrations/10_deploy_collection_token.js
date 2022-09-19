const { deployProxy } = require('@openzeppelin/truffle-upgrades');

var CollectionToken = artifacts.require("CollectionToken");
var CollectionProxy = artifacts.require("CollectionProxy");
const CreatorToken = artifacts.require('CreatorToken');
const Common = artifacts.require('StringCommon');

module.exports = async function (deployer) {
  const commonInstance = await Common.deployed();
  const existingCreator = await CreatorToken.deployed();

  // Deploy CollectionToken contract with creator contract address
//  await deployer.deploy(CollectionToken, existingCreator.address);

  const proxyInstance = await deployProxy(CollectionProxy,
    [commonInstance.address, existingCreator.address, 1, 0], { deployer });

  console.log('  Deployed proxy contract ', proxyInstance.address);
  // Deploy CollectionProxy contract. Parameters:
  // StringCommon and CreatorToken contract addresses,
  // Entity and product id must be fixed for the collection
//  await deployer.deploy(CollectionProxy, commonInstance.address,
//                        existingCreator.address, 1, 0);
};
