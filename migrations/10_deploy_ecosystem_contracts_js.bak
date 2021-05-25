// migrations/NN_deploy_upgradeable_box.js

const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Common = artifacts.require('StringCommon');
const Entity = artifacts.require('ImmutableEntity');
const Product = artifacts.require('ImmutableProduct');
const Activate = artifacts.require('ActivateToken');
const Custom = artifacts.require('CustomToken');

module.exports = async function (deployer, network) {
  const commonInstance = await deployProxy(Common, [], { deployer });
  console.log('Deployed common ', commonInstance.address);

  const entityInstance = await deployProxy(Entity, [commonInstance.address], { deployer });
  console.log('Deployed entity ', entityInstance.address);

  const productInstance = await deployProxy(Product, [entityInstance.address, commonInstance.address], { deployer });
  console.log('Deployed product ', productInstance.address);

  const activateInstance = await deployProxy(Activate, [entityInstance.address, productInstance.address], { deployer });
  console.log('Deployed activate token ', activateInstance.address);

  if (network != 'mainnet')
  {
    const customInstance = await deployProxy(Custom, [], { deployer });
    console.log('Deployed custom token ', customInstance.address);
  }
};

