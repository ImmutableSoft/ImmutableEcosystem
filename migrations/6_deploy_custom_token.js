// migrations/NN_deploy_upgradeable_box.js

const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Custom = artifacts.require('CustomToken');

module.exports = async function (deployer, network) {
  if (network != 'mainnet')
  {
    const customInstance = await deployProxy(Custom, [], { deployer });
    console.log('Deployed custom token ', customInstance.address);
  }
};

