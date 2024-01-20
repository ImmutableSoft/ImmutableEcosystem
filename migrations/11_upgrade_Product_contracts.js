// migrations/MM_upgrade_product_contract.js
const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');
//const OZ_SDK_EXPORT = require("../openzeppelin-cli-export.json");
// Immutable Ecosystem 2.2 (Immutable DAO)
const Common = artifacts.require('StringCommon');
const Entity = artifacts.require('ImmutableEntity');
const Product = artifacts.require('ImmutableProduct');
const Activate = artifacts.require('ActivateToken');
const ProductActivate = artifacts.require('ProductActivate');
const CreatorToken = artifacts.require('CreatorToken');

module.exports = async function (deployer) {

//  const existingEntity = await Entity.deployed();
//  const instanceEntity = await upgradeProxy(existingEntity.address, Entity, { deployer });
//  console.log("Upgraded entity ", instanceEntity.address);

  const existingProduct = await Product.deployed();
  const instanceProduct = await upgradeProxy(existingProduct.address, Product, { deployer });
  console.log("Upgraded product ", instanceProduct.address);
  
//  const existingProductActivate = await ProductActivate.deployed();
//  const instanceProductActivate = await upgradeProxy(existingProductActivate.address, ProductActivate, { deployer });
//  console.log("Upgraded product activate ", instanceProductActivate.address);
};
