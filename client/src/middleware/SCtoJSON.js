// Middleware library for reading from ImmutableSoft
// smart contracts into JSON name/value pairs.
// Copyright 2020-2023 ImmutableSoft Inc. All rights reserved.

import { findProductIndex, secondsToDays } from "./Utilities";

var bigInt = require("big-integer");

export default class SCtoJSON {
  state = { SmartContracts : null, MarketExtension : {} };

  // MarketExtension is JSON with example format:
  //   {
  //     "subcategories" :
  //     [
  //       { "number" : 1, "name" : "JSON Form" },
  //       {... }
  //     ]
  //   }

  constructor (smartContracts, marketExtention) {
    this.state.SmartContracts = smartContracts;
    this.state.MarketExtension = marketExtention;
  }

  /*****************************************************/
  /** Utility API                                      */
  /*****************************************************/

  // String conversion and lookup functions

  versionUint128ToString(versionType, subcategories)
  {
    var versionBigInt = bigInt(versionType);
    var versionString = "";

    var version1 = bigInt(versionBigInt.and(0xFFFF000000000000).shiftRight(48));
    var version2 = bigInt(versionBigInt.and(0xFFFF00000000).shiftRight(32));
    var version3 = bigInt(versionBigInt.and(0xFFFF0000).shiftRight(16));

    // last 16bits of version the platform type
    var typeBigInt = bigInt(versionBigInt.and(0xFFFF));

    if (version1.gt(0) || version2.gt(0) || version3.gt(0))
      versionString = version1 + '.' + + version2 + '.' + version3;

    // If a custom category is registered use it
    if (subcategories)
    {
      for (var i = 0; i < subcategories.length; ++i)
      {
        if (typeBigInt.and(subcategories[i].number).
                       compare(subcategories[i].number) == 0)
          versionString = versionString + " " + subcategories[i].name;
      } 
    }
    else /* otherwise default for software apps */
    {
      // Add the executing architecture
      if (typeBigInt.and(1).compare(1) === 0)
        versionString = versionString + " Windows (x86)";
      if (typeBigInt.and(2).compare(2) === 0)
        versionString = versionString + " Windows (amd64)";
      if (typeBigInt.and(4).compare(4) === 0)
        versionString = versionString + " Windows (aarch64)";
      if (typeBigInt.and(8).compare(8) === 0)
        versionString = versionString + " Linux (x86)";
      if (typeBigInt.and(16).compare(16) === 0)
        versionString = versionString + " Linux (amd64)";
      if (typeBigInt.and(32).compare(32) === 0)
        versionString = versionString + " Linux (aarch64)";
      if (typeBigInt.and(64).compare(64) === 0)
        versionString = versionString + " Android (aarch64)";
      if (typeBigInt.and(128).compare(128) === 0)
        versionString = versionString + " iPhone (arm64)";
      if (typeBigInt.and(256).compare(256) === 0)
        versionString = versionString + " BIOS (x86)";
      if (typeBigInt.and(512).compare(512) === 0)
        versionString = versionString + " BIOS (amd64)";
      if (typeBigInt.and(1024).compare(1024) === 0)
        versionString = versionString + " BIOS (aarch32)";
      if (typeBigInt.and(2048).compare(2048) === 0)
        versionString = versionString + " BIOS (aarch64)";
      if (typeBigInt.and(4096).compare(4096) === 0)
        versionString = versionString + " BIOS (arm64)";
      if (typeBigInt.and(8192).compare(8192) === 0)
        versionString = versionString + " MacOS (amd64)";
      if (typeBigInt.and(16384).compare(16384) === 0)
        versionString = versionString + " MacOS (arm64)";
      if (typeBigInt.and(0x1000000).compare(0x1000000) === 0)
        versionString = versionString + " Source Code";
      if (typeBigInt.and(0x2000000).compare(0x2000000) === 0)
        versionString = versionString + " Agnostic";
      if (typeBigInt.and(0x4000000).compare(0x4000000) === 0)
        versionString = versionString + " Agreement/Contract";
      if (typeBigInt.and(0x8000000).compare(0x8000000) === 0)
        versionString = versionString + " Other";
      if (typeBigInt.equals(0))
        versionString = versionString + " (any)";
    }

    // Add the available languages if any
    if (versionBigInt.toString(16).length > 16)
    {
      var languages = versionBigInt.shiftRight(64);

      if (languages.and(1).compare(1) === 0)
        versionString = versionString + " Mandarin";
      if (languages.and(2).compare(2) === 0)
        versionString = versionString + " Spanish";
      if (languages.and(4).compare(4) === 0)
        versionString = versionString + " English";
      if (languages.and(8).compare(8) === 0)
        versionString = versionString + " Hindi";
      if (languages.and(16).compare(16) === 0)
        versionString = versionString + " Bengali";
      if (languages.and(32).compare(32) === 0)
        versionString = versionString + " Portuguese";
      if (languages.and(64).compare(64) === 0)
        versionString = versionString + " Russian";
      if (languages.and(128).compare(128) === 0)
        versionString = versionString + " Japanese";
      if (languages.and(256).compare(256) === 0)
        versionString = versionString + " Punjabi";
      if (languages.and(512).compare(512) === 0)
        versionString = versionString + " Marathi";
      if (languages.and(1024).compare(1024) === 0)
        versionString = versionString + " Teluga";
      if (languages.and(2048).compare(2048) === 0)
        versionString = versionString + " Wu";
      if (languages.and(4096).compare(4096) === 0)
        versionString = versionString + " Turkish";
      if (languages.and(8192).compare(8192) === 0)
        versionString = versionString + " Korean";
      if (languages.and(16384).compare(16384) === 0)
        versionString = versionString + " French";
      if (languages.and(32768).compare(32768) === 0)
        versionString = versionString + " German";
      if (languages.and(65536).compare(65536) === 0)
        versionString = versionString + " Vietnamese";
    }
    return versionString;
  }

  versionUint256ToString(versionType, subcategories)
  {
    var versionBigInt = bigInt(versionType);

    var typeBigInt = versionBigInt.shiftRight(128);
    var timestampBigInt = versionBigInt.shiftRight(160).and(0xFFFFFFFF);
    var versionString = "";

    var version1 = versionBigInt.and(0xFFFF000000000000).shiftRight(48);
    var version2 = versionBigInt.and(0xFFFF00000000).shiftRight(32);
    var version3 = versionBigInt.and(0xFFFF0000).shiftRight(16);
    var version4 = versionBigInt.and(0xFFFF);
    versionString = version1 + '.' + + version2 + '.' + version3 + '.' + version4;

    // If a custom subcategory is registered use it
    if (subcategories)
    {
      for (var i = 0; i < subcategories.length; ++i)
      {
        if (typeBigInt.and(subcategories[i].number).
                       compare(subcategories[i].number) == 0)
          versionString = versionString + " " + subcategories[i].name;
      } 
    }
    else /* otherwise default for software apps */
    {
      // Add the executing architecture
      if (typeBigInt.and(1).compare(1) === 0)
        versionString = versionString + " Windows (x86)";
      if (typeBigInt.and(2).compare(2) === 0)
        versionString = versionString + " Windows (amd64)";
      if (typeBigInt.and(4).compare(4) === 0)
        versionString = versionString + " Windows (aarch64)";
      if (typeBigInt.and(8).compare(8) === 0)
        versionString = versionString + " Linux (x86)";
      if (typeBigInt.and(16).compare(16) === 0)
        versionString = versionString + " Linux (amd64)";
      if (typeBigInt.and(32).compare(32) === 0)
        versionString = versionString + " Linux (aarch64)";
      if (typeBigInt.and(64).compare(64) === 0)
        versionString = versionString + " Android (aarch64)";
      if (typeBigInt.and(128).compare(128) === 0)
        versionString = versionString + " iPhone (arm64)";
      if (typeBigInt.and(256).compare(256) === 0)
        versionString = versionString + " BIOS (x86)";
      if (typeBigInt.and(512).compare(512) === 0)
        versionString = versionString + " BIOS (amd64)";
      if (typeBigInt.and(1024).compare(1024) === 0)
        versionString = versionString + " BIOS (aarch32)";
      if (typeBigInt.and(2048).compare(2048) === 0)
        versionString = versionString + " BIOS (aarch64)";
      if (typeBigInt.and(4096).compare(4096) === 0)
        versionString = versionString + " BIOS (arm64)";
      if (typeBigInt.and(8192).compare(8192) === 0)
        versionString = versionString + " MacOS (amd64)";
      if (typeBigInt.and(16384).compare(16384) === 0)
        versionString = versionString + " MacOS (arm64)";
      if (typeBigInt.and(0x1000000).compare(0x1000000) === 0)
        versionString = versionString + " Source Code";
      if (typeBigInt.and(0x2000000).compare(0x2000000) === 0)
        versionString = versionString + " Agnostic";
      if (typeBigInt.and(0x4000000).compare(0x4000000) === 0)
        versionString = versionString + " Agreement/Contract";
      if (typeBigInt.and(0x8000000).compare(0x8000000) === 0)
        versionString = versionString + " Other";
      if (typeBigInt.equals(0))
        versionString = versionString + " (any)";
    }

    // Add the available languages
    var languages = versionBigInt.shiftRight(64);

    if (languages.and(1).compare(1) === 0)
      versionString = versionString + " Mandarin";
    if (languages.and(2).compare(2) === 0)
      versionString = versionString + " Spanish";
    if (languages.and(4).compare(4) === 0)
      versionString = versionString + " English";
    if (languages.and(8).compare(8) === 0)
      versionString = versionString + " Hindi";
    if (languages.and(16).compare(16) === 0)
      versionString = versionString + " Bengali";
    if (languages.and(32).compare(32) === 0)
      versionString = versionString + " Portuguese";
    if (languages.and(64).compare(64) === 0)
      versionString = versionString + " Russian";
    if (languages.and(128).compare(128) === 0)
      versionString = versionString + " Japanese";
    if (languages.and(256).compare(256) === 0)
      versionString = versionString + " Punjabi";
    if (languages.and(512).compare(512) === 0)
      versionString = versionString + " Marathi";
    if (languages.and(1024).compare(1024) === 0)
      versionString = versionString + " Teluga";
    if (languages.and(2048).compare(2048) === 0)
      versionString = versionString + " Wu";
    if (languages.and(4096).compare(4096) === 0)
      versionString = versionString + " Turkish";
    if (languages.and(8192).compare(8192) === 0)
      versionString = versionString + " Korean";
    if (languages.and(16384).compare(16384) === 0)
      versionString = versionString + " French";
    if (languages.and(32768).compare(32768) === 0)
      versionString = versionString + " German";
    if (languages.and(65536).compare(65536) === 0)
      versionString = versionString + " Vietnamese";

    if (timestampBigInt > 0)
    {
      var releaseDate = new Date(timestampBigInt * 1000);
      versionString = versionString + " " + releaseDate.toISOString().substr(0,10);
    }
    return versionString;
  }

  isUserLicensed(entityIndex, productIndex, release, activations)
  {
    var currentDate = new Date();
//    alert("entity " + entityIndex + ", product" + productIndex + ", activations " + activations.length);
//    alert("isUserLicensed " + release);
    for (let i = 0; i < activations.length; i++)
    {
//       alert(this.state.licenseActivations[i].split("::")[4].split(":")[1].trim() + " and " +
//             this.state.releases[rIndex].split('::')[5]);
       const timestamp = Date.parse(activations[i].split("::")[4].split(":")[0]);
       const expireDate = new Date(timestamp);

//       alert(i + ":" + this.state.licenseActivations.length +
//             "(" + this.state.licenseActivations[i].split("::")[0] + ":" + entityIndex +
//            ")(" + this.state.licenseActivations[i].split("::")[1] + ":" + productIndex +
//            ")(" + expireDate + ":" + currentDate + ")");

       // If the same product and not expired
       if ((activations[i].split("::")[0] == entityIndex) &&
           (activations[i].split("::")[1] == productIndex) &&
           (expireDate >= currentDate))
       {
//         alert("licenseActivation " + this.state.licenseActivations[i]);
         // If this license is for any/all files, return true
         if (activations[i].split('::')[4].split(":")[1].toUpperCase().includes("ANY"))
           return true;

         // Otherwise search through all release options
         var flags = activations[i].split('::')[4].split(":")[1].trim();
         var options = flags.split(" ");
         var j;
         for (j = 0; j < options.length; ++j)
         {
            if (!release.version.includes(
               options[j].trim()))
            {
//              alert(release.version + " does not include " + options[j].trim());
              break;
            }
         }

//         alert("Same product, unexpired and " + j + " != " + options.length);
         // If all required license options are in release, return true
         if (j == options.length)
           return true;
//        else
//          alert("not all options included");
       }
//       else alert("entity " + activations[i].split("::")[0] + " product " +
//                  activations[i].split("::")[1] + " mismatch or expired");
    }
    return false;
  }

  isReleaseActivated(release, activation)
  {
    var currentDate = new Date();
    const timestamp = Date.parse(activation.split("::")[4].split(":")[0]);
    const expireDate = new Date(timestamp);

//       alert(i + ":" + this.state.license.length +
//             "(" + license.split("::")[0] + ":" + release.split("::")[2] +
//            ")(" + license.split("::")[1] + ":" + release.split("::")[3] +
//            ")(" + expireDate + ":" + currentDate + ")");

    // If the same product and not expired
    if ((activation.split("::")[0] === release.split("::")[2]) && // entity ID
        (activation.split("::")[1] === release.split("::")[3]) &&// product ID
        (expireDate >= currentDate))
    {
      // If this license is for any/all files, return true
      if (activation.split('::')[4].split(":")[1].includes("Any"))
        return true;

      // Otherwise search through all release options
      var flags = activation.split('::')[4].split(":")[1].trim();
      var options = flags.split(" ");
      var j;
      for (j = 0; j < options.length; ++j)
      {
        if (!release.version.includes(options[j].trim()))
        {
          alert(release.version + //licenseActivations[i].split('::')[4].split(":")[1].trim() +
                " does not include " + options[j].trim());
          break;
        }
      }

//         alert("Same product, unexpired and " + j + " != " + options.length);
      // If all required license options are in release, return true
      if (j == options.length)
        return true;
    }
    return false;
  }

  isReleaseLicensed(release, options)
  {
     // Address : price : limitations : duration : offers : URL : ricardianRoot

//        alert(license);
//        alert(license.split(':')[2]);
//        alert(license.split(':')[2].split("-")[1]);
    var j;
    for (j = 0; j < options.length; ++j)
    {
//      alert(options[j]);

      // If this license is for any/all files, it is good
      if (options[j].trim().startsWith("Any"))
        continue;

      // If a version, check version match (TODO)
      if (options[j].trim().split('.').length == 4)
      {
      }

      // Otherwise ensure language/region and type are included
      else if (!release.version.includes(options[j].trim()))
      {
//             alert("Failed: "+ release);
//             alert(release.split('::')[5] + //licenseActivations[i].split('::')[4].split(":")[1].trim() +
//                   " does not include " + options[j].trim());
        break;
      }
    }

//         alert("Same product, unexpired and " + j + " != " + options.length);
    // If all required license options are in release, return true
    if (j == options.length)
      return true;

    return false;
  }

  numFilesLicensed(license, releases)
  {
    var numFiles = 0;
//    alert(license + " in " + releases.length);

    if ((license.length <= 0) || (license.startsWith("no:longer:available")) ||
        (license.split(':').length < 3) || (license.split(':')[2].split("-").length < 2))
    {
//      alert("parameter error " + license);
      return 0;
    }

    // Gather all license options
    var flags = license.split(':')[2].split("-")[1].trim();
    var options = flags.split(" ");
//    alert(flags + " options " + options + " releases " + releases.length);

    for (let i = 0; i < releases.length; ++i)
    {
//      alert(options + " are in " + releases[i] + "?");
      // Count if this release is licensed
      if (this.isReleaseLicensed(releases[i], options))
        numFiles = numFiles + 1;
    }
    return numFiles;
  }

  numFilesActivated(activation, releases)
  {
    var numFiles = 0;
//    alert(activation + " in " + releases.length);
    for (let i = 0; i < releases.length; ++i)
    {
//      alert(license + " is in " + releases[i]);
      // Count if this release is licensed
      if (this.isReleaseActivated(releases[i], activation))
        numFiles = numFiles + 1;
    }
    return numFiles;
  }

  readHasRicardianChild = async (ricardianRoot) => {
    const { SmartContracts  } = this.state;

    var hasRicardianChild = await SmartContracts.creatorHasChildOf(
                SmartContracts.getAccounts()[0], ricardianRoot);
    return hasRicardianChild;
  }

  /*****************************************************/
  /** Public facing API                                */
  /*****************************************************/

  // Read status of current users wallet
  // ****************************************************
  // result.status, result.expiration, result.flags, result.index
  readUserInfoFromWallet = async () =>
  {
    const { SmartContracts } = this.state;
    var result = {};

    if (SmartContracts.getAccounts().length == 0)
    {
      alert("No accounts");
      result.status = "No Wallet";
      result.flags = "Invalid";
      result.expiration = 0;
      result.index = 0;

      return result;
    }
    var entityIndex = await SmartContracts.entityAddressToIndex(SmartContracts.getAccounts()[0]);
    var entityStatus = (entityIndex > 0) ? await SmartContracts.entityAddressStatus() : 0;
    var owner = await SmartContracts.entityOwner();
    var response = bigInt(entityStatus);
    var responseInt = response > 0 ? bigInt('0x0' + response.toString(16).slice(-8)) : bigInt(0);
    var countryCode;

    var status = "";
    if (owner == SmartContracts.getAccounts()[0])
      status = "Owner ";
      
      if (responseInt.and(0xFF) == 0)
        status = status + "Unapproved";
      if (responseInt.and(0xFF) == 1)
        status = status + "Creator";
      if (responseInt.and(0xFF) == 2)
        status = status + "Distributor";
      if (responseInt.and(0xFF) == 3)
        status = status + "End User";
      if (status == "")
        status = "Unknown" ;
      result.status = status;

      var flags = response > 0 ? bigInt('0x0' + response.toString(16).slice(-16,-8)) : bigInt(0);

      var country = response > 0 ? bigInt('0x0' + response.toString(16).slice(-20,-16)) : bigInt(0);

      var expiration = response > 0 ? bigInt('0x0' + response.toString(16).slice(-40,-32)) : bigInt(0);
//      alert(expiration.toString(16));
      result.expiration = expiration;

      if (!country.isZero())
      {
        countryCode = String.fromCharCode(
                    country.shiftRight(8).and(0xFF), country.and(0xFF));
      }
      else
        countryCode = "";

      if (flags.and(0xFF) == 1)
        result.flags = "Nonprofit (" + countryCode + ") ";
      else if (flags.and(0xFF) == 6)
        result.flags = "Auto Custom (" + countryCode + ") ";
      else if (flags.and(0xFF) == 2)
        result.flags = "Auto (" + countryCode + ") ";
      else if (flags.and(0xFF) == 4)
        result.flags = "Custom (" + countryCode + ") ";
      else
        result.flags = "(" + countryCode + ") ";
    result.index = entityIndex;
    return result;
  }

  readEntityDetails = async (entityIndex) => {
    var details = [ "", "" ];

    // Get entity details to check if account is already registered.
    if(entityIndex > 0)
      details = await this.state.SmartContracts.entityDetailsByIndex(entityIndex);

    return { name : details[0], url : details[1] };
//    alert(details[0]);
//    this.setState({ entityIndex, entityName : details[0],
//                    entityURL : details[1] });

  }

  readEntityProductsArray = async (entityIndex) => {
    const { SmartContracts } = this.state;
    let resultProducts = [];
    
    if (entityIndex > 0)
    {
      let productDetails = await SmartContracts.productAllDetails(entityIndex);
      const numProducts = (productDetails !== undefined) ? productDetails[0].length : 0;

      for (let i = 0; i < numProducts ; i++)
      {
//        alert(productDetails[3] + " " + productDetails[3].toString(16));

        // Name, URL, Logo URL, category, flags, languages
        var uint256Details = bigInt(productDetails[3][i]);

        resultProducts.push({
                               name : productDetails[0][i],
                               url : productDetails[1][i],
                               logoURL : productDetails[2][i],
                               category : uint256Details.and('0xFFFF'),
                               subcategory : uint256Details.shiftRight(16).and('0xFFFF'),
                               flags : uint256Details.shiftRight(32).and('0xFFFFFFFF'),
                               languages : uint256Details.shiftRight(64).and('0xFFFFFFFF'),
                               offers : productDetails[4][i]
                             });
      }
    }
    return resultProducts;
//    this.setState({ entityProducts : resultProducts });

//    return resultProducts.length;
  }


  readAllEntitiesArray = async () =>
  {
    const { SmartContracts } = this.state;
    var countryCode;
    let resultEntities = [];

    let allEntities = await SmartContracts.entityAllDetails();

  //    alert(dateTime + ':' + seconds + ':' + minutes + ':' + hours + '::' + numEntities + '::' + showcasingEntity)
    // Loop through all approved entities and read all products
    for (let i = 0; i < allEntities[0].length ; i++)
    {
      var status = bigInt(allEntities[0][i]);
      var statusInt = bigInt('0x0' + status.toString(16).slice(-8));

      var statusString = "";

      if (statusInt.and(0xFF) == 0)
        statusString = statusString + "Unapproved";
      if (statusInt.and(0xFF) == 1)
        statusString = statusString + "Creator";
      if (statusInt.and(0xFF) == 2)
        statusString = statusString + "Distributor";
      if (statusInt.and(0xFF) == 3)
        statusString = statusString + "End User";
      if (statusString == "")
        statusString = "Unknown" ;
        
      var flags = bigInt('0x0' + status.toString(16).slice(-16,-8));
      var country = bigInt('0x0' + status.toString(16).slice(-20,-16));

      if (!country.isZero())
      {
        countryCode = String.fromCharCode(
                    country.shiftRight(8).and(0xFF), country.and(0xFF));
      }
      else
        countryCode = "";


      if (flags.and(0xFF) === 1)
        statusString = statusString + " Nonprofit (" + countryCode + ")";
      else if (flags.and(0xFF) === 2)
        statusString = statusString + " Auto (" + countryCode + ")";
      else if (flags.and(0xFF) === 3)
        statusString = statusString + " Custom (" + countryCode + ")";
      else
        statusString = statusString + " (" + countryCode + ")";

      resultEntities.push({ name : allEntities[1][i], status : statusString,
                            url : allEntities[2][i] });
//      alert(allEntities[1][i] + statusString + ':' + flags + ':' + country);
    }

    // Initialize state variables for products and entities
    return resultEntities;
  }

  // Circular loop to read products from entities until productCount
  // or more products are loaded from blockchain. Store all products
  // even more than productCount.
  readProductsArray = async (theEntities, startingEntity,
                             startingProducts, productCount) =>
  {
    const { SmartContracts } = this.state;
    let resultProducts = startingProducts;
    var ID = resultProducts.length;
    var i, count = 0;
    var entitiesLoaded = [];

    // If existing products then recalibrate count
    if (startingProducts.length > 0)
    {
      var lastEntity = -1;

      // Loop through current products counting them
      for (let k = 0; k < startingProducts.length; ++k)
      {
        // If entity of this product differs, count it
        if (startingProducts[k].entity != lastEntity)
        {
          count = count + 1;
          lastEntity = startingProducts[k].entity;
          entitiesLoaded.push(lastEntity);
        }
      }
    }

    var startID = ID;

//    alert("Enter updateProductsArray " + theEntities.length + " : " + startingEntity + " c " + count + " ID " + ID);
  //    alert(dateTime + ':' + seconds + ':' + minutes + ':' + hours + '::' + numEntities + '::' + showcasingEntity)

      // Loop on all entities, starting with showcasing, and read all products
      for (i = startingEntity; count < theEntities.length; i++)
      {
        var k;

        if (i > theEntities.length)
          i = 1;

        if (ID - startID >= productCount)
          break;

        // Check loaded entities array to see if already loaded
        if (entitiesLoaded.includes(i) == true)
          break;

        // If we broke out of last loop then skip this entity
        if (k < resultProducts.length)
        {
//          alert(k + " k less than length " + resultProducts.length);
          break;
        }

        // If an approved entity, queue for display all products
        if (theEntities[i - 1].status.includes("Unapproved") == false)
        {
           // Read all the products owned by the entity
          let products = await SmartContracts.productAllDetails(i);
          const numProducts = (products != undefined) ? products[0].length : 0;

//          alert("Entity " + i + " with " + numProducts + " products");
          for (let j = 0; j < numProducts ; j++)
          {
            // Split up category, flags, languages
            var uint256Details = bigInt(products[3][j]);
            var indexEnd = 0 - (uint256Details.toString(16).length);
            var categoryID = 0;
            var flags = 0;
            var languageFlags = 0;

            // Read the 32 bit category field
            if (indexEnd <= -8)
              categoryID = bigInt('0x' + uint256Details.toString(16).slice(-8));
            else
              categoryID = bigInt('0x' + uint256Details.toString(16).slice(indexEnd));

            // Split category into two 16 bit parts, main and subcategory
            var subCategory = categoryID.shiftRight(16);
            categoryID = categoryID.and(0xFFFF);

            if (indexEnd <= -16)
              flags = bigInt('0x' + uint256Details.toString(16).slice(-16, -8));
            else if (indexEnd <= -8)
              flags = bigInt('0x' + uint256Details.toString(16).slice(indexEnd, -8));

            if (indexEnd <= -24)
              languageFlags = bigInt('0x' + uint256Details.toString(16).slice(-24, -16));
            else if (indexEnd <= -16)
              languageFlags = bigInt('0x' + uint256Details.toString(16).slice(indexEnd, -16));

//            alert("raw " + products[3][j] + " details 0x" + uint256Details.toString(16) + " = category " + category + " flags 0x" +
//                  flags.toString(16) +
//                  " languages 0x" + languages.toString(16) + " indexEnd " + indexEnd);

            // index :: category :: subcategory :: entity :: productID :: releases :: name :: url :: logo ::
            // offerPrice :: flags :: languages :: releases
            resultProducts.push( { index : ID,  category : categoryID, subcategory : subCategory,
                                   entity : i, product : j, name : products[0][j],
                                   url : products[1][j], logo : products[2][j],
                                   price : products[4][j],
                                   options  : '0x' + flags.toString(16),
                                   languages : languageFlags, releases : []} );
            ID = ID + 1;
          }
//          this.setState({ loadEntity : count + 1, loadApplication : resultProducts.length });
        }
        entitiesLoaded.push(i);
        count = count + 1;
      }

    if (count == theEntities.length)
      i = -1;

    return { products : resultProducts, nextEntity : i };
  }

  readActivationsArray = async (loadProducts, entities, products) => {
    const { SmartContracts, MarketExtension } = this.state;
    let resultActivations = [];

    {
      // Search all license activations for current wallet holder
      let licenseDetails = await SmartContracts.activateAllDetailsForWallet();
      const numLicenses = (licenseDetails != undefined) ? licenseDetails[0].length : 0;
//      alert(numLicenses);
      var newProducts = products;//this.state.products;
      var result = { products : newProducts, nextEntity : 0 }
//      alert("Num licenses " + numLicenses);
      for (let j = 0; j < numLicenses ; j++)
      {
        // If license exists (entity is valid)
        if (licenseDetails[0][j] > 0)
        {
          var value = bigInt(licenseDetails[3][j]);
//          alert(value.toString(16));
  //        alert('0x' + value.toString(16));
          var topValue = value.shiftRight(128);
          var flags = value.shiftRight(160).and('0xFFFF');
          var offers = value.shiftRight(176).and('0xFFFF');
  //        alert('topValue 0x' + topValue.toString(16) + ' flags 0x' + flags.toString(16));
          
          var expiration = bigInt('0x' + topValue.and('0xFFFFFFFF').toString(16));
          var all32bits = bigInt('0xFFFFFFFF');
          var all64bits = all32bits.or(all32bits.shiftLeft(32));
          var half = value.and(all64bits);
          var verLimitation = bigInt(half);//'0x' + half.toString(16));
  //        alert('0x' + verLimitation.toString(16));
          var langLimitation = bigInt('0x' + value.shiftRight(64).and(all64bits).toString(16));
  //        alert('0x' + langLimitation.toString(16));
          var allLimitations = value.and(all64bits).or(value.shiftRight(64).and(all64bits).shiftLeft(64));

          var resaleString = "";
          if (flags.and(4).compare(4) === 0)
            resaleString = '(NO resale)';

          var expireDate = new Date(expiration * 1000);

          // Show all activations so users can Extend
          {
            var bigActivation = bigInt(licenseDetails[2][j]);

            // Look up the entity and product and return error if not found
            var index = findProductIndex(licenseDetails[0][j], licenseDetails[1][j], newProducts);
//            alert(licenseDetails[0][j] + ":" + licenseDetails[1][j] + ":" + index);

            if (loadProducts && (index < 0))
            {
              // Load the entity products from chain
              var productResult = await this.readProductsArray(entities, licenseDetails[0][j], newProducts, 1);
//              this.setState({ products : result.products,
//                              nextEntity : result.nextEntity });
              newProducts = productResult.products;
              index = findProductIndex(licenseDetails[0][j], licenseDetails[1][j], newProducts);
//              alert(j + " missing product " + licenseDetails[1][j] + " for entity " + licenseDetails[0][j] + ", now found at " + index);
            }

            if (index >= 0)
            {
              // entityID :: productID : productName :: activationID :: expiration date :: logoURL
              resultActivations.push(licenseDetails[0][j] + '::' +
                                     licenseDetails[1][j] + '::' + newProducts[index].name + '::' +
                                     '0x' + bigActivation.toString(16) + '::' +
                                     expireDate.toISOString().substr(0,10) + ':' +
                                     resaleString + ' ' +
                                     this.versionUint128ToString(allLimitations, MarketExtension?.subcategories) + '::' +
                                     licenseDetails[4][j] + // expire date and resale price
                                     '::' + newProducts[index].logo); // Logo URL
            }
            else
            {
//              alert("Activation but product not loaded");
              // entityID :: productID : productName :: activationID :: expiration date :: logoURL
              resultActivations.push(licenseDetails[0][j] + '::' +
                                     licenseDetails[1][j] + '::' + "Unknown Product" + '::' +
                                     '0x' + bigActivation.toString(16) + '::' +
                                     expireDate.toISOString().substr(0,10) + ':' +
                                     resaleString + ' ' +
                                     this.versionUint128ToString(allLimitations, MarketExtension?.subcategories) + '::' +
                                     licenseDetails[4][j] + // expire date and resale price
                                     '::' + "Unknown logo URL"); // Logo URL
            }
          }
        }
      }
    }


//    this.setState({ licenseActivations : resultActivations });
//    alert("Num activations " + resultActivations.length);
    return { activations : resultActivations, products : newProducts,
             nextEntity : result.nextEntity };
  }

  readForSaleActivationsArray = async () => {
    const { SmartContracts, MarketExtension } = this.state;
      let resultActivations = [];
      var licenseDetails = [];
      var numLicenses;
      var activationID = 0;

//      alert("here");
      // Read all for sale activations from the blockchain
      try {
        licenseDetails = await SmartContracts.activateAllForSaleTokenDetails();
        numLicenses = ((licenseDetails != undefined) && (licenseDetails.length > 0)) ? licenseDetails[0].length : 0;
      } catch (err) {
        numLicenses = 0;
        err.message = "Error reading for sale activations. " + err.message;
        this.displayError(err);
      }

//      alert("Ecosystem has " + numLicenses + " activation license tokens");
      for (let j = 0; j < numLicenses ; j++)
      {
        // If license exists (activation identifier not zero)
        if (licenseDetails[2][j] > 0)
        {

//          var expireDate = new Date(licenseDetails[3][j] * 1000);
          var price = bigInt(licenseDetails[4][j]);

          var value = bigInt(licenseDetails[3][j]);
//          alert(value.toString(16));
  //        alert('0x' + value.toString(16));
          var topValue = value.shiftRight(128);
          var flags = value.shiftRight(160).and('0xFFFF');
//          var offers = value.shiftRight(176).and('0xFFFF');
  //        alert('topValue 0x' + topValue.toString(16) + ' flags 0x' + flags.toString(16));
          
          var expiration = bigInt('0x' + topValue.and('0xFFFFFFFF').toString(16));
          var all32bits = bigInt('0xFFFFFFFF');
          var all64bits = all32bits.or(all32bits.shiftLeft(32));
          var verLimitation = value.and(all64bits);//.toString(16));
  //        alert('0x' + verLimitation.toString(16));
          var langLimitation = value.shiftRight(64).and(all64bits);//bigInt('0x' + value.shiftRight(64).and(all64bits).toString(16));
  //        alert('0x' + langLimitation.toString(16));

          var languageString = "";
          var resaleString = "";
          if (flags.and(4).compare(4) === 0)
            resaleString = '(NO resale)';

          // If a limitation activation, display limited languages/version
      //    if (flags.and(2).compare(2) === 0)
      //    {
      //    alert(langLimitation);
          if (langLimitation.gt(0))
          {
          if (langLimitation.and(1).compare(1) === 0)
            languageString = languageString + " Mandarin";
          if (langLimitation.and(2).compare(2) === 0)
            languageString = languageString + " Spanish";
          if (langLimitation.and(4).compare(4) === 0)
            languageString = languageString + " English";
          if (langLimitation.and(8).compare(8) === 0)
            languageString = languageString + " Hindi";
          if (langLimitation.and(16).compare(16) === 0)
            languageString = languageString + " Bengali";
          if (langLimitation.and(32).compare(32) === 0)
            languageString = languageString + " Portuguese";
          if (langLimitation.and(64).compare(64) === 0)
            languageString = languageString + " Russian";
          if (langLimitation.and(128).compare(128) === 0)
            languageString = languageString + " Japanese";
          if (langLimitation.and(256).compare(256) === 0)
            languageString = languageString + " Punjabi";
          if (langLimitation.and(512).compare(512) === 0)
            languageString = languageString + " Marathi";
          if (langLimitation.and(1024).compare(1024) === 0)
            languageString = languageString + " Teluga";
          if (langLimitation.and(2048).compare(2048) === 0)
            languageString = languageString + " Wu";
          if (langLimitation.and(4096).compare(4096) === 0)
            languageString = languageString + " Turkish";
          if (langLimitation.and(8192).compare(8192) === 0)
            languageString = languageString + " Korean";
          if (langLimitation.and(16384).compare(16384) === 0)
            languageString = languageString + " French";
          if (langLimitation.and(32768).compare(32768) === 0)
            languageString = languageString + " German";
          if (langLimitation.and(65536).compare(65536) === 0)
            languageString = languageString + " Vietnamese";
          }

          var expireDate = new Date(expiration * 1000);

          // If unexpired and listed for sale and to the resulting activations
          if (price.gt(0) && (expiration.eq(0) || (expireDate > new Date())))
          {
//           alert(activationID + '::' + licenseDetails[0][j] + '::' + licenseDetails[1][j] + '::' +
//                 j + '::' + expireDate.toLocaleDateString() + '::' + price.divide(1000000000000000000) +
//                 '::' + licenseDetails[2][j] + '::' + allEntities[1][i]);

            // index :: entityID :: productID : offerID :: expiration date :: price :: hash :: entityName
            resultActivations.push(activationID + '::' + licenseDetails[0][j] + '::' + licenseDetails[1][j] + '::' +
                                   j + '::' + expireDate.toISOString().substr(0,10) + ':' +
                                   resaleString + ' ' + languageString + ' ' +
                                   this.versionUint128ToString(verLimitation, MarketExtension?.subcategories) + '::' +
                                   (price / 1000000000000000000) +
                                   ' ($' + SmartContracts.getBalanceUSD(price).toFixed(2) + ')::' +
                                   licenseDetails[2][j] + '::' + '');
            activationID = activationID + 1;
          }
        }
      }
      return resultActivations;
  }

  readProductReleases = async (entityID, productID, product) => {
    const { SmartContracts, MarketExtension } = this.state;
    let resultReleases = [];

        // Get all the releases as an array from the blockchain
        let releaseDetails = await SmartContracts.creatorAllReleaseDetails(entityID, productID);

  //      alert(entityID + ":" + productID + "-" + releaseDetails[0].length);
        const numReleases = (releaseDetails !== undefined) ? releaseDetails[0].length : 0;
        var hexHash;
        var i;
        var parentHash;
        
  //      alert(numReleases);

        // For each release, add a release to the UI
        for (i = numReleases - 1; i >= 0 ; --i)
        {
          // Skip if this release is void
          if ((releaseDetails[0][i] == 0) && (releaseDetails[1][i] == "") &&
              (releaseDetails[2][i] == 0) && (releaseDetails[3][i] == 0))
            continue;

          hexHash = SmartContracts.toHex(releaseDetails[2][i]);//web3.utils.toHex(releaseDetails[2][i]);
          if (releaseDetails[3][i] > 0)
            parentHash = SmartContracts.toHex(releaseDetails[3][i]);
          else
            parentHash = 0;

          // Product index, category, entity, product, release, version string, uri, hash and parent hash
          resultReleases.push( { index : product.index,
                                 category : product.category,
                                 entity : entityID, product : productID,
                                 release : i, version: this.versionUint256ToString(releaseDetails[0][i], MarketExtension?.subcategories),
                                 uri : releaseDetails[1][i], hash : hexHash, parent : parentHash }); // URI and hashes
        }
    return resultReleases;
  }

  readAllOffers  = async (entityID, productID) =>
  {
    const { SmartContracts, MarketExtension } = this.state;
    let resultAllOffers = [];
    var i;
//    alert("updateSelectedOffersArray " + entityIndex + ":" + productID);

    if (entityID > 0)
    {
      let offerDetails = await SmartContracts.productAllOfferDetails(entityID, productID);

      var firstOffer = 0;

      for (i = 0; i < offerDetails[0].length; ++i)
      {
        var value = bigInt(offerDetails[2][i]);
  //        alert('0x' + value.toString(16));
        var topValue = value.shiftRight(128);
        var flags = value.shiftRight(160).and('0xFFFF');
        var offers = value.shiftRight(176).and('0xFFFF');
  //        alert('topValue 0x' + topValue.toString(16) + ' flags 0x' + flags.toString(16));
          
        var expiration = '0x' + topValue.and('0xFFFFFFFF').toString(16);
        var all32bits = bigInt('0xFFFFFFFF');
        var all64bits = all32bits.or(all32bits.shiftLeft(32));
//        var verLimitation = value.and(all64bits);//bigInt('0x' + value.and(all64bits).toString(16));
  //        alert('0x' + verLimitation.toString(16));
        var allLimitations = value.and(all64bits).or(value.shiftRight(64).and(all64bits).shiftLeft(64));
  //        alert('0x' + langLimitation.toString(16));

        var resaleString = "";
        if (flags.and(4).compare(4) === 0)
          resaleString = '(NO resale)';


        // Address : price : limitations : duration : offers : URL : ricardianRoot
        if (offerDetails[1][i] == 0)
        {
          resultAllOffers.push('no:longer:available:-' + offerDetails[3][i] + ":-" + offerDetails[5][i]);
          if (i == firstOffer)
          {
            firstOffer = firstOffer + 1;
          }
        }
        else if (offerDetails[0][i] === '0x0000000000000000000000000000000000000000')
          resultAllOffers.push((((SmartContracts.getNetworkId() === 137) || (SmartContracts.getNetworkId() === 80001)) ? 'MATIC' : 'ETH') + ':' +
                               (offerDetails[1][i] / 1000000000000000000) + ' ($' +
                               SmartContracts.getBalanceUSD(offerDetails[1][i]).toFixed(2) + '):' +
                               resaleString + ' -' + this.versionUint128ToString(allLimitations, MarketExtension?.subcategories) + ':' +
                               secondsToDays(expiration) + ':' + offers + ':-' +
                               offerDetails[3][i] + ':-' + offerDetails[5][i]);
        else
          resultAllOffers.push(offerDetails[0][i] + ':' +
                               (offerDetails[1][i] / 1000000000000000000) + ' ($' +
                               SmartContracts.getBalanceUSD(offerDetails[1][i]).toFixed(2) + '):' +
                               resaleString + ' -' + this.versionUint128ToString(allLimitations, MarketExtension?.subcategories) + ':' +
                               secondsToDays(expiration) + ':' + offers + ':-' +
                               offerDetails[3][i] + ':-' + offerDetails[5][i]);
      }
    }
    return { allOffers : resultAllOffers, firstOffer };
  }

}
