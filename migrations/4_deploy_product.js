// migrations/NN_deploy_upgradeable_box.js

const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Common = artifacts.require('StringCommon');
const Entity = artifacts.require('ImmutableEntity');
const Product = artifacts.require('ImmutableProduct');

module.exports = async function (deployer, network) {
  const commonInstance = await Common.deployed();
  console.log('  Using common ', commonInstance.address);

  const entityInstance = await Entity.deployed();
  console.log('  Using entity ', entityInstance.address);

  const productInstance = await deployProxy(Product, [entityInstance.address, commonInstance.address], { deployer });
  console.log('Deployed product ', productInstance.address);
};

