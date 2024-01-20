// Utilities library for ImmutableSoft UI
// Copyright 2020-2023 ImmutableSoft Inc. All rights reserved.
var bigInt = require("big-integer");

export function findProductIndex(entity, product, products)
{
  var i;

//    alert(entity + " : " + product);
  for (i = 0; i < products.length; ++i)
  {
//      alert("Check entity and product ids for product " i);
    // If this entity and product match, return the index
    if ((products[i].entity == entity) &&
        (products[i].product == product))
      return i;
  }
  return -1;
}

export function findReleaseHash(uri, theReleases)
{
  var i;

  for (i = 0; i < theReleases.length; ++i)
  {
    // If this entity and product match, return the index
    if (theReleases[i].split('::')[6] === uri)
      return theReleases[i].split('::')[7];
  }
  return 0;
}

export function secondsToDays(seconds)
{
  seconds = Number(seconds);
  var d = Math.floor(seconds / (3600 * 24));

  var dDisplay = d > 0 ? d + (d === 1 ? " day" : " days") : " 0 days";
  return dDisplay;
}

export function isValidFilename(filename)
{
  var regex = /^[^\\/:\*\?"<>\|]+$/;

  if (regex.test(filename) == false) // check for forbidden characters
    return false;
  else
    return true;
}

export function versionStringToUint256(versionString)
{
  var versionArray = versionString.split(".");
  var version = bigInt(0);
    
  for (var i = 0; i < 4; ++i)
  {
    if (i < versionArray.length)
      version = version.add(versionArray[i]);
    if (i < 3)
      version = version.shiftLeft(16);
  }
  return version;
}

// Returns hex string of creator tokenId
export function findCreatorTokenId(entity, product, release)
{
  var tokenId = bigInt(0);
    
//224 entity offset
//192 product offset
//160 release offset

  tokenId = tokenId.add(entity);
  tokenId = tokenId.shiftLeft(32);
  tokenId = tokenId.add(product);
  tokenId = tokenId.shiftLeft(32);
  tokenId = tokenId.add(release);
  tokenId = tokenId.shiftLeft(160);

  return '0x' + tokenId.toString(16);
}

export function convertFormToDataURI(formData)
{
  var result = {};

  formData.forEach(function(value, key)
    {
      result[key] = value;
    });

  return "data:application/json," + JSON.stringify(result);
}
