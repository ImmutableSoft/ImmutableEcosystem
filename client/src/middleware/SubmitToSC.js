// Middleware library for form submissions to ImmutableSoft
// smart contracts.
// Copyright 2020-2023 ImmutableSoft Inc. All rights reserved.
import SmartContracts from "./SmartContracts";

import { versionStringToUint256 } from "./Utilities";

var bigInt = require("big-integer");

export default class SubmitToSC {
  state = { SmartContracts };

  constructor (smartContracts) {
    this.state.SmartContracts = smartContracts;
  }

  submitEntityCreateForm = async (formData) => {
    const { SmartContracts } = this.state;
    const entityName = formData.get('name');
    const entityURL = formData.get('url');
    const entityEmail = formData.get('email');
    var result = { name : "", url : "", registerUrl : "" };

    var authorized = formData.get('authorized');

    // Ensure the authorized box was checked
    if ((authorized === null) || (authorized !== "on"))
      throw Error("You must be authorized to represent the entity - " + authorized);

    // Ensure the name and URL are not empty
    if ((entityName == null) || (entityName.length == 0) ||
        (entityURL == null) || (entityURL.length == 0))
      throw Error("Entity name and URL are required");

    // Basic check for URI validity
    if (!entityURL.includes("://"))
      throw Error("URI must contain :// (http://, https://, etc.");

    // Ensure the name has no html or script tags
    if ((entityName.split('<').length !== 1) ||
        (entityName.split('{').length !== 1))
      throw Error("Name contains invalid character (< or {)");
    await SmartContracts.entityCreate(entityName, entityURL);

    // Construct the result
    result.name = entityName;
    result.url = entityURL;

    // Append blockchain parameters for registration (contact info) URL
    result.registerUrlParams = SmartContracts.getAccounts()[0].substring(2) + ":" +
              this.state.SmartContracts.getNetworkId() +
              "&entity=" + entityName.replace(/ /g, "%20");

    return result;
  }

  submitEntityAddressMoveForm = async (formData) => {
    const { SmartContracts } = this.state;
    const entityAddress = formData.get('address');

    if ((entityAddress === null) || (entityAddress.length === 0) ||
        (entityAddress[0] !== '0') || (entityAddress[1] !== 'x') ||
        (entityAddress.length !== 42))
      throw Error("Incorrect address specified");

    await SmartContracts.entityAddressMove(entityAddress);

    return entityAddress;
  }

  submitEntityChangeAddressForm = async (formData) => {
    const { SmartContracts } = this.state;
    const entityAddress = formData.get('address');

    if ((entityAddress === null) || (entityAddress.length === 0) ||
        (entityAddress[0] !== '0') || (entityAddress[1] !== 'x') ||
        (entityAddress.length !== 42))
      throw Error("Incorrect address specified");

    await SmartContracts.entityAddressNext(entityAddress);
    return entityAddress;
  }

  submitEntityChangeBankForm = async (formData) => {
    const { SmartContracts } = this.state;
    const bankAddress = formData.get('address');

    if ((bankAddress === null) || (bankAddress.length === 0) ||
        (bankAddress[0] !== '0') || (bankAddress[1] !== 'x') ||
        (bankAddress.length !== 42))
      throw Error('Bank address invalid or missing');

    await SmartContracts.entityBankChange(bankAddress);
    return bankAddress;
  }

  submitEntityUpdateForm = async (formData) => {
    const { SmartContracts } = this.state;
    var result = { name : "", url : "" };
    const entityName = formData.get('name');
    const entityURL = formData.get('url');

    if ((entityName === null) || (entityName.length === 0) ||
        (entityURL === null) || (entityURL.length === 0))
      throw Error("Entity name and URL are required");

    // Ensure the URL begins with HTTP
    if (!entityURL.includes("://"))
      throw Error("URI must contain :// (http://, https://, etc.)");

    // Perform the smart contract transaction, awaiting result
    await SmartContracts.entityUpdate(entityName, entityURL);

    // Construct and return the result
    result.name = entityName;
    result.url = entityURL;
    return result;
  }

  // formData: name, url, logo, category, subcategory, option, languages (multi)
  submitProductChangeForm = async (formData, entityIndex, productIndex, isNew) => {
    const { SmartContracts } = this.state;
    const productName = formData.get('name');
    const productURL = formData.get('url');
    var logoURL = formData.get('logo');
    const category = formData.get('category');
    const subcategory = formData.get('subcategory');
    var options = formData.get('option');
    if (options === null)
    {
      if (StyleSheet === "MediaChain")
        options = 4;
      else
        options = 0;
    }
    var productDetails = bigInt(0);
    var languages = bigInt(0);

    // If edit and product name disabled, use current product name
    if (((productName === null) || (productName.length === 0) ||
        (productURL === null) || (productURL.length === 0)))
      throw Error("Product name and URL are required " + productName + " : " + productURL);

    // Read all the languages from the multi select listbox
    for(var pair of formData.entries()) {
      if (pair[0] === "languages")
        languages = languages.add(pair[1]); 
    }
//    alert(" languages = 0x" + languages.toString(16));

    // Add the languages flags first
    if (languages > 0)
    {
      productDetails = productDetails.add(languages);
      productDetails = productDetails.shiftLeft(32);
    }      

//    alert("After languages, details = 0x" + productDetails.toString(16));

    // Add the option flags second
    if (options > 0)
    {
      productDetails = productDetails.add(options);
      productDetails = productDetails.shiftLeft(32);
    }
    else
    {
      // Languages but no options, move 32 bits left
      if (languages > 0)
        productDetails = productDetails.shiftLeft(32)
    }

//    alert("After options, details = 0x" + productDetails.toString(16));

    // Ensure the URL begins with HTTP if present
    if ((productURL !== null) && (productURL.length !== 0) &&
        !(productURL.startsWith("data:") ||
          productURL.startsWith("http://") ||
          productURL.startsWith("HTTP://") ||
          productURL.startsWith("https://") ||
          productURL.startsWith("mailto:") ||
          productURL.startsWith("HTTPS://")))
      throw Error("URL must begin with data:, HTTP://, HTTPS:// or mailto:");

    // Ensure the Logo URL begins with HTTP or HTTPS if present
    if ((logoURL !== null) && (logoURL.length !== 0) &&
        !(logoURL.startsWith("data:") ||
          logoURL.startsWith("http://") ||
          logoURL.startsWith("HTTP://") ||
          logoURL.startsWith("https://") ||
          productURL.startsWith("mailto:") ||
          logoURL.startsWith("HTTPS://")))
      throw Error("Logo URL must begin with data:, HTTP://, HTTPS:// or mailto:");

    // Add the category (16 bits) and subcategory (16 bits)
    if (subcategory != null)
    {
      var cat = bigInt(subcategory).shiftLeft(16);
      cat = cat.add(category);
      productDetails = productDetails.add(cat);
    }
    else
    {
      productDetails = productDetails.add(category);
      subcategory = 0;
    }

//    alert(isNew + " name: " + productName + ", url: " + productURL + ", logo: " +
//          logoURL + ", details: 0x" + productDetails.toString(16));

    if (isNew == false)
      await SmartContracts.productEdit(productIndex, productName,
               productURL, logoURL, '0x' + productDetails.toString(16));
    else
      await SmartContracts.productCreate(productName,
               productURL, logoURL, '0x' + productDetails.toString(16));
    return { name : productName, url : productURL, logo : logoURL,
             category, subcategory, options, languages };
  }

  // formData: version, uri, hash, details, languages (multi), parentid
  submitProductReleaseForm = async (formData, entityIndex, productIndex) => {
    const { SmartContracts } = this.state;

    var parentID = formData.get('parentid');
    const productID = productIndex;
    var releaseVersion = formData.get('version');
    const releaseURI = formData.get('uri');
    var releaseHash = formData.get('hash');
    var details = formData.get('details');
    if (details === null)
      details = 0;

    // Convert parent id to the release hash of that id
    var detailValue = bigInt(details);
    var releaseDetails;
    var resultLanguages = bigInt(0);
    var languages = bigInt(0);

    // Read all the languages from the multi select listbox
    for(var pair of formData.entries()) {
      if (pair[0] === "languages")
      {
        languages = languages.add(pair[1]); 
//        alert('0x' + languages.toString(16) + ' ' + pair[1]);
      }
    }

    // Add the languages flags first
    if (languages > 0)
    {
      resultLanguages = resultLanguages.add(languages);
      resultLanguages = resultLanguages.shiftLeft(64);
    }

    if ((releaseVersion === null) || (releaseVersion.length === 0) ||
        (releaseURI === null) || (releaseURI.length === 0) ||
        (releaseHash === null) || (releaseHash.length === 0))
      throw Error("Release version ("+ releaseVersion + "), URI (" + releaseURI +
            ") and hash (" + releaseHash + ") are required");

    // Start with the release architecture details (bits 128 through 256)
    releaseDetails = detailValue.shiftLeft(128);

    // Add the languages (bits 64 through 128)

    // Convert version from string and add to the release details
    var versionConversion = versionStringToUint256(releaseVersion);
    releaseDetails = releaseDetails.add(versionConversion);

    releaseDetails = releaseDetails.add(resultLanguages);

//    alert(isNew + " name: " + productName + ", url: " + productURL + ", logo: " +
//          logoURL + ", details: 0x" + productDetails.toString(16));

    if (entityIndex > 0)
      await SmartContracts.creatorReleases([productID],
                 ['0x' + releaseDetails.toString(16)], [releaseHash],
                 [releaseURI], [parentID]);
    else
      await SmartContracts.creatorAnonFile(releaseHash, releaseURI, '0x' + releaseDetails.toString(16));
    return { flags : details, languages : resultLanguages,
             version : releaseVersion, mergedDetails : releaseDetails,
             hash : releaseHash, url : releaseURI };
  }

  // formData: price, duration, address, offerUrl, version, limit,
  //           platform (multi), languages (multi), preventResale, license
  submitProductOfferForm = async (formData, entityIndex, productIndex, ricardianRoot) => {
    const { SmartContracts } = this.state;

    const offerPrice = formData.get('price');
    var duration = formData.get('duration');
    if ((duration == null) || (duration == ""))
      duration = 0;
    duration = Number(duration) * (3600 * 24);
    var erc20Address = formData.get('address');
    var offerUrl = formData.get('offerUrl');
    var version = formData.get('version');
    if (version == null)
      version = "0.0";
    else if ((version.length > 0) && (version.split('.').length < 4)) 
      version = version + ".0";
    var limitNumOffers = formData.get('limit');
    var preventResale = formData.get('preventResale');
    if (preventResale == null)
      preventResale = 0;
    var languages = bigInt(0);
    var resultLanguages = bigInt(0);
    var platformInt = bigInt(0);

    if ((limitNumOffers === null) || (limitNumOffers.length === 0))
      limitNumOffers = 0;

    if ((erc20Address === null) || ((erc20Address.length === 0) || (erc20Address == 0) ||
        (erc20Address == '0x0')))
      erc20Address = '0x0000000000000000000000000000000000000000';

    // Read all the platforms from the multi select listbox
    for(var plat of formData.entries()) {
      if (plat[0] === "platform")
        platformInt = platformInt.add(plat[1]); 
    }

    // Read all the languages from the multi select listbox
    for(var pair of formData.entries()) {
      if (pair[0] === "languages")
        languages = languages.add(pair[1]); 
    }

    // Add the languages flags first
    if (languages > 0)
    {
      resultLanguages = resultLanguages.add(languages);
      resultLanguages = bigInt(resultLanguages.shiftLeft(64));
    }

    var resultVersion = versionStringToUint256(version);

    // Combine the version with languages and platform
    var verLang = bigInt(resultVersion.or(resultLanguages));
    var limitation = bigInt(verLang.or(platformInt));

    if ((productIndex !== null))
    {

      if ((offerPrice > 0) && (duration >= 0))
      {
        var price = bigInt(1000000000000000000 * offerPrice);

        // Check if prevent resale flag is set and valid
        if ((preventResale === null) || (preventResale.length === 0))
          preventResale = '0';
            
        await SmartContracts.productOfferLimitation(productIndex,
                     '0x0000000000000000000000000000000000000000', // ETH
                     '0x' + price.toString(16),
                     '0x' + limitation.toString(16),
                     '0x' + duration.toString(16),
                     limitNumOffers, 0,
                     offerUrl, // no info URL
                     preventResale === 1 ? true : false, //prevent resale
                     0, ricardianRoot);
        return { price, limitation, duration, offerUrl };
      }
      else
        throw Error('Price in tokens and duration required');
    }
    else
      throw Error('No product selected');
  }
}
