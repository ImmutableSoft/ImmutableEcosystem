// migrations/NN_deploy_upgradeable_box.js

const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Common = artifacts.require('StringCommon');
const Entity = artifacts.require('ImmutableEntity');
const Product = artifacts.require('ImmutableProduct');
const Creator = artifacts.require('CreatorToken');
const Activate = artifacts.require('ActivateToken');
const ProductActivate = artifacts.require('ProductActivate');

module.exports = async function (deployer, network, accounts) {
  const commonInstance = await Common.deployed();

  const entityInstance = await Entity.deployed();

  const productInstance = await Product.deployed();

  const creatorInstance = await Creator.deployed();

//  const activateInstance = await deployer.deploy(Activate, commonInstance.address, entityInstance.address);
  const activateInstance = await deployProxy(Activate, 
        [commonInstance.address, entityInstance.address], { deployer });

  console.log('  Deployed activate token ', activateInstance.address);

//  await deployer.deploy(ProductActivate, commonInstance.address,
//    entityInstance.address, productInstance.address,
//    activateInstance.address, creatorInstance.address);
  const productActivateInstance = await deployProxy(ProductActivate, [commonInstance.address,
    entityInstance.address, productInstance.address,
    activateInstance.address, creatorInstance.address], { deployer });

  console.log('  Deployed product activate', productActivateInstance.address);

/*
//  const activateTokenInstance = await Activate.deployed();
  await activateInstance.restrictToken(productActivateInstance.address,
                                       creatorInstance.address);

  console.log('  Restricted activate token ');
*/

//  const creatorInstance = await deployProxy(Creator, [entityInstance.address, commonInstance.address], { deployer });
//  console.log('Deployed creator token ', creatorInstance.address);
};

