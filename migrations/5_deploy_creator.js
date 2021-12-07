// migrations/NN_deploy_upgradeable_box.js

const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Common = artifacts.require('StringCommon');
const Entity = artifacts.require('ImmutableEntity');
const Product = artifacts.require('ImmutableProduct');
const Creator = artifacts.require('CreatorToken');

module.exports = async function (deployer, network) {
  const commonInstance = await Common.deployed();

  const entityInstance = await Entity.deployed();

  const productInstance = await Product.deployed();

//  await deployer.deploy(Creator, commonInstance.address, entityInstance.address,
//                        productInstance.address);
  const creatorInstance = await deployProxy(Creator, [commonInstance.address, entityInstance.address,
                    productInstance.address], { deployer });
  console.log('  Deployed creator token ', creatorInstance.address);

};

