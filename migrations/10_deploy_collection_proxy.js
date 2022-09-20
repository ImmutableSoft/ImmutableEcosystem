const { deployProxy } = require('@openzeppelin/truffle-upgrades');

var CollectionProxy = artifacts.require("CollectionProxy");
const CreatorToken = artifacts.require('CreatorToken');
const Common = artifacts.require('StringCommon');
const Entity = artifacts.require('ImmutableEntity');
const Product = artifacts.require('ImmutableProduct');

module.exports = async function (deployer) {
  const commonInstance = await Common.deployed();
  const existingCreator = await CreatorToken.deployed();
  const entityInstance = await Entity.deployed();
  const productInstance = await Product.deployed();

  const proxyInstance = await deployProxy(CollectionProxy,
    [commonInstance.address, existingCreator.address,
     entityInstance.address, productInstance.address,
     /* REQUIRED: Change the parameters below. */
     /* CollectionName, SymbolName, EntityID, ProductID. */
     "CollectionProxy", "PXY", 1, 0], { deployer });

  console.log('  Deployed collection proxy contract ', proxyInstance.address);
};
