const { deployProxy } = require('@openzeppelin/truffle-upgrades');

var CollectionProxy = artifacts.require("CollectionProxy");
const CreatorToken = artifacts.require('CreatorToken');
const Common = artifacts.require('StringCommon');

module.exports = async function (deployer) {
  const commonInstance = await Common.deployed();
  const existingCreator = await CreatorToken.deployed();


  const proxyInstance = await deployProxy(CollectionProxy,
    [commonInstance.address, existingCreator.address, 1, 0], { deployer });

  console.log('  Deployed collection proxy contract ', proxyInstance.address);
};
