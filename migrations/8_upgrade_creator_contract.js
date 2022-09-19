// migrations/MM_upgrade_product_contract.js
const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');
//const OZ_SDK_EXPORT = require("../openzeppelin-cli-export.json");

const Common = artifacts.require('StringCommon');
const Entity = artifacts.require('ImmutableEntity');
const Product = artifacts.require('ImmutableProduct');
const Activate = artifacts.require('ActivateToken');
const ProductActivate = artifacts.require('ProductActivate');
const CreatorToken = artifacts.require('CreatorToken');

module.exports = async function (deployer) {

//  const existingCommon = await Common.deployed();
//  const instanceCommon = await upgradeProxy(existingCommon.address, Common, { deployer });
//  console.log("Upgraded common ", instanceCommon.address);

//  const existingEntity = await Entity.deployed();
//  const instanceEntity = await upgradeProxy(existingEntity.address, Entity, { deployer });
//  console.log("Upgraded entity ", instanceEntity.address);

//  const existingProduct = await Product.deployed();
//  const instanceProduct = await upgradeProxy(existingProduct.address, Product, { deployer });
//  console.log("Upgraded product ", instanceProduct.address);

//  const existingActivate = await Activate.deployed();
//  const instanceActivate = await upgradeProxy(existingActivate.address, Activate, { deployer });
//  console.log("Upgraded activate token ", instanceActivate.address);

  const existingCreator = await CreatorToken.deployed();
  const instanceCreator = await upgradeProxy(existingCreator.address, CreatorToken, { deployer });
  console.log("Upgraded creator token ", instanceCreator.address);
};
