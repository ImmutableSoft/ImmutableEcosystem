// migrations/NN_deploy_upgradeable_box.js

const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Common = artifacts.require('StringCommon');
const Entity = artifacts.require('ImmutableEntity');

module.exports = async function (deployer, network) {
  const commonInstance = await Common.deployed();
  console.log('  Using common ', commonInstance.address);

  const entityInstance = await deployProxy(Entity, [commonInstance.address], { deployer });
  console.log('Deployed entity ', entityInstance.address);
};

