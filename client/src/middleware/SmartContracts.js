// Middleware library for blockchain interactions to ImmutableSoft
// smart contracts.
// Copyright 2020-2023 ImmutableSoft Inc. All rights reserved.

//Smart Contract imports
import ImmutableEntityContract from "../contracts/ImmutableEntity.json";
import ImmutableProductContract from "../contracts/ImmutableProduct.json";
import CreatorTokenContract from "../contracts/CreatorToken.json";
import ActivateTokenContract from "../contracts/ActivateToken.json";
import ProductActivateContract from "../contracts/ProductActivate.json";

//Web3 imports
import getWeb3 from "../utils/getWeb3";
import getWalletConnect from "../utils/getWalletConnect";

const ethPrice = require('eth-price');

export default class SmartContracts {

  state = { networkId: 0, web3: null, accounts: null, ethBalance: 0,
            infuraOn : 0, priceUSD: 0, entityContract: null,
            productContract: null, activateContract: null,
            productActivateContract: null, creatorContract: null,
            productActivateAddress: null, creatorAddress: null };

  ConnectWallet = async (type) =>
  {
    var web3, accounts, balance, networkId, infuraOn;
    var entityInstance, productInstance, activateInstance,
        productActivateInstance, creatorInstance;

//    alert("ConnectWallet " + type);

    try {
      // Get network provider and web3 instance.
      if (type == 0)
        web3 = await getWeb3();
      else
        web3 = await getWalletConnect();
    } catch (error) {
//      alert("Error getWeb3");
      // Catch any errors for any of the above operations.
      if (error.message.includes("502"))
        alert("The endpoint used to communicate with the blockchain is down. Please make sure you are logged into your wallet. If so, try loading the page later.");
      else if (error.message.includes("429"))
        alert("The endpoint used to communicate with the blockchain has serviced too many requests. Try waiting and loading the page later.");
      else
        alert(error.message + `\n\nFailed to load web3. You must use a browser that supports web3 (MetaMask plug in).`);
      console.error(error);
      return false;
    }

//    alert("2");

    try {
      // Use web3 to get the user's accounts.
      accounts = await web3.eth.getAccounts();
      if (accounts.length > 0)
      {
        balance = await web3.eth.getBalance(accounts[0]);
        infuraOn = 0;
      }
      else
      {
        infuraOn = 1;
        accounts = [];
        balance = 0;
      }
    } catch (error) {
      // Catch any errors for any of the above operations.
      if (error.message.includes("502"))
        alert("The endpoint used to communicate with the blockchain is down. Please make sure you are logged into your wallet. If so, try loading the page later.");
      else if (error.message.includes("429"))
        alert("The endpoint used to communicate with the blockchain has serviced too many requests. Try waiting and loading the page later.");

//      alert(error.message + `\n\nInstall/enable MetaMask or WalletConnect account. Browsing mode only enabled.`);
      infuraOn = 1;
      accounts = [];
      balance = 0;
    }

//    alert("Infura " + infuraOn);
    try {

      // Get the entity contract instance.
      networkId = await web3.eth.net.getId();
//      alert(networkId);
      const deployedEntityNetwork = ImmutableEntityContract.networks[networkId];
      entityInstance = new web3.eth.Contract(
        ImmutableEntityContract.abi,
        deployedEntityNetwork && deployedEntityNetwork.address,
      );

      // Get the product contract instance.
      const deployedProductNetwork = ImmutableProductContract.networks[networkId];
      productInstance = new web3.eth.Contract(
        ImmutableProductContract.abi,
        deployedProductNetwork && deployedProductNetwork.address,
      );

      // Get the license contract instance.
      const deployedActivateNetwork = ActivateTokenContract.networks[networkId];
      activateInstance = new web3.eth.Contract(
        ActivateTokenContract.abi,
        deployedActivateNetwork && deployedActivateNetwork.address,
      );

      // Get the product activate contract instance.
      const deployedProductActivateNetwork = ProductActivateContract.networks[networkId];
      productActivateInstance = new web3.eth.Contract(
        ProductActivateContract.abi,
        deployedProductActivateNetwork && deployedProductActivateNetwork.address,
      );

      // Get the creator token contract instance.
      const deployedCreatorNetwork = CreatorTokenContract.networks[networkId];
      creatorInstance = new web3.eth.Contract(
        CreatorTokenContract.abi,
        deployedCreatorNetwork && deployedCreatorNetwork.address,
      );

      if ((deployedEntityNetwork === undefined) ||
          (deployedProductNetwork === undefined) ||
          (deployedProductActivateNetwork === undefined) ||
          (deployedCreatorNetwork === undefined) ||
          (deployedActivateNetwork === undefined))
        throw Error("Immutable Ecosystem contracts not found on Ethereum network.\n\nCheck your Ethereum network. Are you on Polygon?");

        this.state.creatorAddress = deployedCreatorNetwork.address;
        this.state.productActivateAddress = deployedProductActivateNetwork.address;
    } catch (error) {
      // Catch any errors for any of the above operations.
      if (error.message.includes("502"))
        alert("The endpoint used to communicate with the blockchain is down. Please make sure you are logged into your wallet. If so, try loading the page later.");
      else if (error.message.includes("429"))
        alert("The endpoint used to communicate with the blockchain has serviced too many requests. Try waiting and loading the page later.");
      else
        alert(error.message + `\n\nFailed to load contracts. Is the Ethereum network correct?`);
      console.error(error);
      return false;
    }

    try {
      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.state.web3 = web3;
      this.state.accounts = accounts;
      this.state.entityContract = entityInstance;
      this.state.productContract = productInstance;
      this.state.activateContract = activateInstance;
      this.state.creatorContract = creatorInstance;
      this.state.productActivateContract = productActivateInstance;
      this.state.networkId = networkId;
      this.state.infuraOn = infuraOn;

      // Default to Account0
      this.state.ethBalance = balance;

      const priceData = await ethPrice('usd,matic');
      var dataString = priceData.toString();
//      alert(dataString + ':' + priceData);
      var priceETHUSD = dataString.split(',')[0].split(': ')[1];
      var priceMATIC =  dataString.split(',')[1].split(': ')[1];
      var priceUSD;
      if ((this.state.networkId === 137) || (this.state.networkId === 80001))
        priceUSD = priceETHUSD / priceMATIC;
      else
        priceUSD = priceETHUSD;

//      alert(priceUSD + ':' + priceETHUSD + ':' + priceMATIC);
      this.state.priceUSD = priceUSD;
    } catch (error) {
      // Catch any errors for any of the above operations.
      if (error.message.includes("502"))
        alert("The endpoint used to communicate with the blockchain is down. Please make sure you are logged into your wallet. If so, try loading the page later.");
      else if (error.message.includes("429"))
        alert("The endpoint used to communicate with the blockchain has serviced too many requests. Try waiting and loading the page later.");
      else
        alert(error.message + `\n\nFailed to load web3, accounts, or contracts. MetaMask not installed or locked. Please install/unlock the MetaMask wallet plugin and refresh this page.`);
      console.error(error);
      return false;
    }
    return true;
  }

  getWeb3()
  {
    return this.state.web3;
  }

  toHex(value)
  {
    const { web3 } = this.state;
    return web3.utils.toHex(value);
  }

  getAccounts()
  {
    return this.state.accounts;
  }

  getNetworkId()
  {
    return this.state.networkId;
  }

  getInfuraOn()
  {
    return this.state.infuraOn;
  }

  getBalance()
  {
    return this.state.ethBalance;
  }

  getPrice()
  {
    return this.state.priceUSD;
  }

  getBalanceUSD(ethBalance)
  {
    const { priceUSD } = this.state;

    return (priceUSD * ethBalance) / 1000000000000000000;
  }

  // ImmutableEntity smart contract interface
  // ************************************************************************
  entityAddressStatus = async () =>
  {
    const { entityContract, accounts } = this.state;
    return entityContract.methods.entityAddressStatus(accounts[0]).call();
  }

  entityOwner = async () =>
  {
    const { entityContract } = this.state;
    return entityContract.methods.owner().call();
  }
  
  entityAddressToIndex = async (address) =>
  {
    const { entityContract } = this.state;
    return entityContract.methods.entityAddressToIndex(address).call();
  }

  entityAllDetails = async () =>
  {
    const { entityContract } = this.state;
    return entityContract.methods.entityAllDetails().call();
  }

  entityDetailsByIndex = async (index) =>
  {
    const { entityContract } = this.state;
    return entityContract.methods.entityDetailsByIndex(index).call();
  }

  entityCreate = async (entityName, entityURL) =>
  {
    const { entityContract, accounts } = this.state;
    return entityContract.methods.entityCreate(entityName,
                                 entityURL).send({ from: accounts[0] });
  }

  entityUpdate = async (entityName, entityURL) =>
  {
    const { entityContract, accounts } = this.state;
    return entityContract.methods.entityUpdate(entityName,
                                 entityURL).send({ from: accounts[0] });
  }

  entityAddressNext = async (entityAddress) =>
  {
    const { entityContract, accounts } = this.state;
    return entityContract.methods.entityAddressNext(entityAddress).send({ from: accounts[0] });
  }

  entityAddressMove = async (entityAddress) =>
  {
    const { entityContract, accounts } = this.state;
    return entityContract.methods.entityAddressMove(entityAddress).send({ from: accounts[0] });
  }

  entityStatusUpdate = async (index, status) =>
  {
    const { entityContract, accounts } = this.state;
    return entityContract.methods.entityStatusUpdate(index, status).send({ from: accounts[0] });
  }

  entityTransferOwnership = async (newAddress) =>
  {
    const { entityContract, accounts } = this.state;
    return entityContract.methods.transferOwnership(newAddress).send({ from: accounts[0] });
  }

  entityBankChange = async (bankAddress) =>
  {
    const { entityContract, accounts } = this.state;
    return entityContract.methods.entityBankChange(bankAddress).send({ from: accounts[0] });
  }

  entityPay = async (entityId, amount) =>
  {
    const { entityContract, accounts } = this.state;
    return entityContract.methods.entityPay(entityId).send({ from: accounts[0], value : amount });
  }

  // ImmutableProduct smart contract interface
  // ************************************************************************
  productAllDetails = async (index) =>
  {
    const { productContract } = this.state;
    return productContract.methods.productAllDetails(index).call();
  }

  productAllOfferDetails = async (entityIndex, productID) =>
  {
    const { productContract } = this.state;
    return productContract.methods.productAllOfferDetails(entityIndex,
                                                      productID).call();
  }

  productEdit = async (index, name, url, logo, details) =>
  {
    const { productContract, accounts } = this.state;
    return productContract.methods.productEdit(index, name, url, logo,
                                   details).send({ from: accounts[0] });
  }

  productCreate = async (name, url, logo, details) =>
  {
    const { productContract, accounts } = this.state;
    return productContract.methods.productCreate(name, url, logo,
                                   details).send({ from: accounts[0] });
  }

  productTransferOwnership = async (newAddress) =>
  {
    const { productContract, accounts } = this.state;
    return productContract.methods.transferOwnership(newAddress).send({ from: accounts[0] });
  }

  productOfferLimitation = async (productId, priceAddress, price, limitations, duration,
                                    limitedOffers, bulkOffers, offerUrl, resale, surcharge, ricardianRoot) =>
  {
    const { productContract, accounts } = this.state;
    return productContract.methods.productOfferLimitation(productId, priceAddress, price,
                                                          limitations, duration,
                                                          limitedOffers, bulkOffers,
                                                          offerUrl,resale, surcharge, ricardianRoot).send({ from: accounts[0] });
  }

  productOfferEditPrice = async (productId, offerId, price) =>
  {
    const { productContract, accounts } = this.state;
    return productContract.methods.productOfferEditPrice(productId,
             offerId, price).send({ from: accounts[0] });
  }

  // CreatorToken smart contract interface
  // ************************************************************************
  creatorAllReleaseDetails = async (entityId, productId) =>
  {
    const { creatorContract } = this.state;
    return creatorContract.methods.creatorAllReleaseDetails(entityId,
                                                     productId).call();
  }

  creatorReleases = async (releaseId, details, hash, uri, parentId) =>
  {
    const { creatorContract, accounts } = this.state;

    return creatorContract.methods.creatorReleases(releaseId, details,
                       hash, uri, parentId).send({ from: accounts[0] });
  }

  creatorReleaseHashDetails = async (hash) =>
  {
    const { creatorContract } = this.state;
    return creatorContract.methods.creatorReleaseHashDetails(hash).call();
  }

  creatorAnonFile = async (hash, uri, details) =>
  {
    const { creatorContract, accounts } = this.state;
    const anonFee = await creatorContract.methods.AnonFee();
    return creatorContract.methods.anonFile(
            hash, uri, details).send({ from: accounts[0],
                                       value: '0x' + (anonFee).toString(16) });
  }

  creatorTransferOwnership = async (newAddress) =>
  {
    const { creatorContract, accounts } = this.state;
    return creatorContract.methods.transferOwnership(newAddress).send({ from: accounts[0] });
  }

  creatorChangeBrand = async (tokenName, tokenSymbol) =>
  {
    const { creatorContract, accounts } = this.state;
    return creatorContract.methods.changeBrand(tokenName, tokenSymbol).send({ from: accounts[0] });
  }

  creatorBurn = async (tokenId) =>
  {
    const { creatorContract, accounts } = this.state;
    return creatorContract.methods.burn(tokenId).send({ from: accounts[0] });
  }

  creatorApprove = async (address, tokenId) =>
  {
    const { creatorContract, accounts } = this.state;
    return creatorContract.methods.approve(address, tokenId).send({ from: accounts[0] });
  }

  creatorSafeTransferFrom = async (from, to, tokenId) =>
  {
    const { creatorContract, accounts } = this.state;
    return creatorContract.methods.safeTransferFrom(from, to, tokenId, []).send({ from: accounts[0] });
  }

  creatorHasChildOf = async (address, root) =>
  {
    const { creatorContract } = this.state;
    return creatorContract.methods.creatorHasChildOf(address, root).call();
  }

  getCreatorAddress()
  {
    return this.state.creatorAddress;
  }

  // ActivateToken smart contract interface
  // ************************************************************************
  activateAllForSaleTokenDetails = async (index) =>
  {
    const { activateContract } = this.state;
    return activateContract.methods.activateAllForSaleTokenDetails().call();
  }

  activateAllDetailsForWallet = async () =>
  {
    const { activateContract, accounts } = this.state;
    return activateContract.methods.activateAllDetailsForAddress(accounts[0]).call();
  }

  activateBankChange = async (bankAddress) =>
  {
    const { activateContract, accounts } = this.state;
    return activateContract.methods.activateBankChange(bankAddress).send({ from: accounts[0] });
  }

  activateFeeChange = async (rate) =>
  {
    const { activateContract, accounts } = this.state;
    return activateContract.methods.activateFeeChange(rate).send({ from: accounts[0] });
  }

  activateTransferOwnership = async (newAddress) =>
  {
    const { activateContract, accounts } = this.state;
    return activateContract.methods.transferOwnership(newAddress).send({ from: accounts[0] });
  }

  restrictToken = async (productActivateAddress, creatorTokenAddress) =>
  {
    const { activateContract, accounts } = this.state;
    return activateContract.methods.restrictToken(productActivateAddress,
                       creatorTokenAddress).send({ from: accounts[0] });
  }

  // ProductActivate smart contract interface
  // ************************************************************************
  productActivateTransferOwnership = async (newAddress) =>
  {
    const { productActivateContract, accounts } = this.state;
    return productActivateContract.methods.transferOwnership(newAddress).send({ from: accounts[0] });
  }

  activateMove = async (entityId, productId, oldIdentifier, newIdentifier) =>
  {
    const { productActivateContract, accounts } = this.state;
    return productActivateContract.methods.activateMove(entityId, productId,
                  oldIdentifier, newIdentifier).send({ from: accounts[0] });
  }

  activateCreate = async (productId, hash, value, surcharge, parent) =>
  {
    const { productActivateContract, accounts } = this.state;
    return productActivateContract.methods.activateCreate(productId,
            hash, value, surcharge, parent).send({ from: accounts[0] });
  }

  activateOfferResale = async (entityId, productId, hash, price) =>
  {
    const { productActivateContract, accounts } = this.state;
    return productActivateContract.methods.activateOfferResale(entityId,
             productId, hash, price).send({ from: accounts[0] });
  }

  activatePurchase = async (entityId, productId, offerId, number, hashes, parents, fee) =>
  {
    const { productActivateContract, accounts } = this.state;
    return productActivateContract.methods.activatePurchase(entityId,
             productId, offerId, number, hashes, parents).send({ from: accounts[0], value: fee });
  }

  activateTransfer = async (entityId, productId, licenseHash, newLicenseHash, price) =>
  {
    const { productActivateContract, accounts } = this.state;
    return productActivateContract.methods.activateTransfer(entityId,
                productId, licenseHash, newLicenseHash).send({ from: accounts[0],
                  value: price });
  }

  getProductActivateAddress()
  {
    return this.state.productActivateAddress;
  }
}
