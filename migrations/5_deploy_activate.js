// migrations/NN_deploy_upgradeable_box.js

const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Entity = artifacts.require('ImmutableEntity');
const Product = artifacts.require('ImmutableProduct');
const Activate = artifacts.require('ActivateToken');

module.exports = async function (deployer, network) {
  const entityInstance = await Entity.deployed();
  console.log('  Using entity ', entityInstance.address);

  const productInstance = await Product.deployed();
  console.log('  Using product ', productInstance.address);

  const activateInstance = await deployProxy(Activate, [entityInstance.address, productInstance.address], { deployer });
  console.log('Deployed activate token ', activateInstance.address);
};

