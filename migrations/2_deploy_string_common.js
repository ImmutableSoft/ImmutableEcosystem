// migrations/NN_deploy_upgradeable_box.js

const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Common = artifacts.require('StringCommon');

module.exports = async function (deployer, network) {
  const commonInstance = await deployProxy(Common, [], { deployer });
  console.log('Deployed common ', commonInstance.address);
};

