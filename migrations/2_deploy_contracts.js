
const StringCommon = artifacts.require("./StringCommon.sol");
const ImmutableEntity = artifacts.require("./ImmutableEntity.sol");
//const ImmutableResolver = artifacts.require("./ImmutableResolver.sol");
const ImmutableProduct = artifacts.require("./ImmutableProduct.sol");
//const ImmutableLicense = artifacts.require("./ImmutableLicense.sol");
const ActivateToken = artifacts.require("./ActivateToken.sol");
//const ImmuteToken = artifacts.require("./ImmuteToken.sol");
const CustomToken = artifacts.require("./CustomToken.sol");

var ENS = artifacts.require("@ensdomains/ens/ENSRegistry");
const namehash = require('eth-ens-namehash');
const FIFSRegistrar = artifacts.require("@ensdomains/ens/FIFSRegistrar");
//const ReverseRegistrar = artifacts.require("@ensdomains/ens/ReverseRegistrar");
//const OwnedResolver = artifacts.require("@ensdomains/resolver/contracts/OwnedResolver.sol");
const utils = require('web3-utils');

//require('openzeppelin-test-helpers/configure')({ web3 });

//const { singletons } = require('@openzeppelin/test-helpers');

const tld = "eth";

module.exports = function(deployer, network, accounts)
{
    const rate = 600;
    const wallet = accounts[0];
    let ens;
    let resolver;
    let token;
    let common;
    let registrar;
    let entity;
    let product;
    let activate;
//    const erc1820 = singletons.ERC1820Registry(accounts[0]);

    deployer.deploy(StringCommon)
        .then(function(commonInstance) {
            common = commonInstance;
            return deployer.deploy(ImmutableEntity);
        })
        // Registrar
//        .then(function(entityInstance) {
//          entity = entityInstance;
//          return deployer.deploy(ImmutableResolver, entity.address, ens.address);
//        })
        // Registrar
//        .then(function(resolverInstance) {
//          resolver = resolverInstance;
//          return setupResolver(ens, resolver, accounts);
//        })
        .then(function(entityInstance) {
          entity = entityInstance; //
          return entity.initialize(common.address);
        })
        .then(function() {
            return deployer.deploy(ImmutableProduct);
        })
        .then(function(productInstance) {
            product = productInstance;
            return product.initialize(entity.address, common.address);
        })
        .then(function() {
            return deployer.deploy(ActivateToken); //ImmutableLicense
        })
        .then(function(activateInstance) {
            activate = activateInstance;
            return activateInstance.initializeMe(entity.address, product.address);
        })
//        .then(function() {
          //return deployer.deploy(ImmuteToken);
          //        .then(function(tokenInstance) {
          //            token = tokenInstance;
          //            return deployer.deploy(ENS);
          //        })
      
          //        .then(function(ensInstance) {
          //            ens = ensInstance;
          //            return deployer.deploy(OwnedResolver);
          //        })
          //        .then(function(ensResolver) {
          //            return deployer.deploy(ImmutableBase, token.address,
          //                                   ens.address, ensResolver.address);
          //        })
//        })
       // .then(function(tokenInstance/*ensInstance*/) {
      //            ens = ensInstance;
      //        token = tokenInstance;
      //        return token.initializeMe(10000000000000, entity.address, product.address, activate.address);
      //  })
//        .then(function() {
//              return entity.entityToken(token.address);
//        })
//        .then(function() {
//              return product.productToken(token.address);
//        })
//        .then(function() {
//              return activate.activateToken(token.address);
//        })
        .then(function() {
                return deployer.deploy(CustomToken);
        })
        .then(function(customInstance) {
            return customInstance.initialize();
        })
//        .then(function() {
//          return deployer.deploy(FIFSRegistrar, ens.address, namehash.hash(tld));
//        })
//        .then(function(registrarInstance) {
//          registrar = registrarInstance;
//          return setupRegistrar(ens, registrar, resolver);
//        })

        // Old: Reverse Registrar
//        .then(function() {
//          return deployer.deploy(ReverseRegistrar, ens.address, resolver.address);
//        })
//        .then(function(reverseRegistrarInstance) {
//          return setupReverseRegistrar(ens, resolver, reverseRegistrarInstance, accounts);
//        })
};

async function setupResolver(ens, resolver, accounts) {
  const resolverNode = namehash.hash("resolver");
  const resolverLabel = utils.sha3("resolver");

//  const immutableLabel = utils.sha3("immutablesoft");

  await ens.setSubnodeOwner("0x0000000000000000000000000000000000000000", resolverLabel,
                            accounts[0]);
  await ens.setResolver(resolverNode, resolver.address);
  await resolver.setAddr(resolverNode, resolver.address);

//  await ens.setSubnodeOwner("0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae",
//                            immutableLabel, accounts[0]);

}

async function setupRegistrar(ens, registrar, resolver) {
  await ens.setSubnodeOwner("0x0000000000000000000000000000000000000000", utils.sha3(tld), registrar.address);
}

async function setupReverseRegistrar(ens, resolver, reverseRegistrar, accounts) {
  await ens.setSubnodeOwner("0x0000000000000000000000000000000000000000", utils.sha3("reverse"), accounts[0]);
  await ens.setSubnodeOwner(namehash.hash("reverse"), utils.sha3("addr"), reverseRegistrar.address);
}
