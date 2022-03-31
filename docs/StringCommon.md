# Immutable String - common constants and string routines (StringCommon.sol)

View Source: [contracts/StringCommon.sol](../contracts/StringCommon.sol)

**↗ Extends: [Initializable](Initializable.md), [OwnableUpgradeable](OwnableUpgradeable.md)**

**StringCommon**

StringCommon is string related general/pure functions

## Contract Members
**Constants & Variables**

```js
uint256 public constant Unknown;
uint256 public constant Creator;
uint256 public constant Distributor;
uint256 public constant EndUser;
uint256 public constant Nonprofit;
uint256 public constant Automatic;
uint256 public constant CustomToken;
uint256 public constant CoutryCodeOffset;
uint256 public constant CoutryCodeMask;
uint256 public constant Tools;
uint256 public constant System;
uint256 public constant Platform;
uint256 public constant Education;
uint256 public constant Entertainment;
uint256 public constant Communications;
uint256 public constant Professional;
uint256 public constant Manufacturing;
uint256 public constant Business;
uint256 public constant Hazard;
uint256 public constant Adult;
uint256 public constant Restricted;
uint256 public constant USCryptoExport;
uint256 public constant EUCryptoExport;
uint256 public constant Mandarin;
uint256 public constant Spanish;
uint256 public constant English;
uint256 public constant Hindi;
uint256 public constant Bengali;
uint256 public constant Portuguese;
uint256 public constant Russian;
uint256 public constant Japanese;
uint256 public constant Punjabi;
uint256 public constant Marathi;
uint256 public constant Teluga;
uint256 public constant Wu;
uint256 public constant Turkish;
uint256 public constant Korean;
uint256 public constant French;
uint256 public constant German;
uint256 public constant Vietnamese;
uint256 public constant Windows_x86;
uint256 public constant Windows_amd64;
uint256 public constant Windows_aarch64;
uint256 public constant Linux_x86;
uint256 public constant Linux_amd64;
uint256 public constant Linux_aarch64;
uint256 public constant Android_aarch64;
uint256 public constant iPhone_arm64;
uint256 public constant BIOS_x86;
uint256 public constant BIOS_amd64;
uint256 public constant BIOS_aarch32;
uint256 public constant BIOS_aarch64;
uint256 public constant BIOS_arm64;
uint256 public constant Mac_amd64;
uint256 public constant Mac_arm64;
uint256 public constant SourceCode;
uint256 public constant Agnostic;
uint256 public constant NotApplicable;
uint256 public constant Other;
uint256 public constant ExpirationFlag;
uint256 public constant LimitationFlag;
uint256 public constant NoResaleFlag;
uint256 public constant FeatureFlag;
uint256 public constant LimitedOffersFlag;
uint256 public constant BulkOffersFlag;
uint256 public constant RicardianReqFlag;
uint256 public constant EntityIdOffset;
uint256 public constant EntityIdMask;
uint256 public constant ProductIdOffset;
uint256 public constant ProductIdMask;
uint256 public constant ReleaseIdOffset;
uint256 public constant ReleaseIdMask;
uint256 public constant UniqueIdOffset;
uint256 public constant UniqueIdMask;
uint256 public constant FlagsOffset;
uint256 public constant FlagsMask;
uint256 public constant ExpirationOffset;
uint256 public constant ExpirationMask;
uint256 public constant ValueOffset;
uint256 public constant ValueMask;
string public constant EntityIsZero;
string public constant OfferNotFound;
string public constant EntityNotValidated;
string public constant ProductNotFound;
string public constant TokenEntityNoMatch;
string public constant TokenProductNoMatch;
string public constant TokenNotUnique;

```

## Functions

- [initialize()](#initialize)
- [stringsEqual(string _a, string _b)](#stringsequal)

### initialize

Initialize the StringCommon smart contract
   Called during first deployment only (not on upgrade) as
   this is an OpenZepellin upgradable contract

```js
function initialize() public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### stringsEqual

Compare strings and return true if equal.
 Case sensitive.

```js
function stringsEqual(string _a, string _b) public pure
returns(bool)
```

**Returns**

true if strings are equal, otherwise false

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _a | string | The string to be compared | 
| _b | string | The string to compare | 

## Contracts

* [ActivateToken](ActivateToken.md)
* [AddressUpgradeable](AddressUpgradeable.md)
* [ContextUpgradeable](ContextUpgradeable.md)
* [CreatorToken](CreatorToken.md)
* [CustomToken](CustomToken.md)
* [ERC165Upgradeable](ERC165Upgradeable.md)
* [ERC20Upgradeable](ERC20Upgradeable.md)
* [ERC721BurnableUpgradeable](ERC721BurnableUpgradeable.md)
* [ERC721EnumerableUpgradeable](ERC721EnumerableUpgradeable.md)
* [ERC721Upgradeable](ERC721Upgradeable.md)
* [ERC721URIStorageUpgradeable](ERC721URIStorageUpgradeable.md)
* [IERC165Upgradeable](IERC165Upgradeable.md)
* [IERC20MetadataUpgradeable](IERC20MetadataUpgradeable.md)
* [IERC20Upgradeable](IERC20Upgradeable.md)
* [IERC721EnumerableUpgradeable](IERC721EnumerableUpgradeable.md)
* [IERC721MetadataUpgradeable](IERC721MetadataUpgradeable.md)
* [IERC721ReceiverUpgradeable](IERC721ReceiverUpgradeable.md)
* [IERC721Upgradeable](IERC721Upgradeable.md)
* [ImmutableEntity](ImmutableEntity.md)
* [ImmutableProduct](ImmutableProduct.md)
* [Initializable](Initializable.md)
* [Migrations](Migrations.md)
* [OwnableUpgradeable](OwnableUpgradeable.md)
* [ProductActivate](ProductActivate.md)
* [StringCommon](StringCommon.md)
* [StringsUpgradeable](StringsUpgradeable.md)
