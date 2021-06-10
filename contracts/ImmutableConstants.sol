pragma solidity ^0.8.4;

// SPDX-License-Identifier: GPL-3.0-or-later

/// @title Immutable Constants - common constant definitions
/// @author Sean Lawless for ImmutableSoft Inc.
/// @dev Constants for structures across contracts
contract ImmutableConstants
{
  // Entity Status
  // Type is first 32 bits (bits 0 through 31)
  uint256 constant Unknown =         0;
  uint256 constant Creator =         1;
  uint256 constant Distributor =     2;
  uint256 constant EndUser =         3;

  // Flags begin at bit 32 and go until bit 63
  uint256 constant Nonprofit =       (1 << 32);
  uint256 constant Automatic =       (1 << 33);
  uint256 constant CustomToken =     (1 << 34);

  // Country of origin
  uint256 constant CoutryCodeOffset =64;
  uint256 constant CoutryCodeMask =  (0xFFFF << CoutryCodeOffset);

  // Product Details
  // Category is first 32 bits (bits 0 through 31)
  uint256 constant Tools =          0;
  uint256 constant System =         1;
  uint256 constant Platform =       2;
  uint256 constant Education =      3;
  uint256 constant Entertainment =  4;
  uint256 constant Communications = 5;
  uint256 constant Professional =   6;
  uint256 constant Manufacturing =  7;
  uint256 constant Business =       8;
  // Room here for expansion

  // Flags begin at bit 32 and go until bit 63
  uint256 constant Hazard =         (1 << 32);
  uint256 constant Adult =          (1 << 33);
  uint256 constant Restricted =     (1 << 34);
  // Distribution restricted by export laws of orgin country?
  uint256 constant USCryptoExport = (1 << 35);
  uint256 constant EUCryptoExport = (1 << 36);

  // Languages begin at bit 64 and go until bit 127
  //   Ordered by percentage of native speakers
  //   https://en.wikipedia.org/wiki/List_of_languages_by_number_of_native_speakers
  uint256 constant Mandarin =       (1 << 64);
  uint256 constant Spanish =        (1 << 65);
  uint256 constant English =        (1 << 66);
  uint256 constant Hindi =          (1 << 67);
  uint256 constant Bengali =        (1 << 68);
  uint256 constant Portuguese =     (1 << 69);
  uint256 constant Russian =        (1 << 70);
  uint256 constant Japanese =       (1 << 71);
  uint256 constant Punjabi =        (1 << 71);
  uint256 constant Marathi =        (1 << 72);
  uint256 constant Teluga =         (1 << 73);
  uint256 constant Wu =             (1 << 74);
  uint256 constant Turkish =        (1 << 75);
  uint256 constant Korean =         (1 << 76);
  uint256 constant French =         (1 << 77);
  uint256 constant German =         (1 << 78);
  uint256 constant Vietnamese =     (1 << 79);
  // Room here for 47 additional languages (bit 127)
  // Bits 128 - 255 Room here for expansion
  //   Up to 128 additional languages for example

  // Product Release Version
  // Version is first four 16 bit values (first 64 bits)
  // Version 0.0.0.0

  // Language bits from above form bits 64 to 127

  // The Platform Type begins at bit 128 and goes until bit 159
  uint256 constant Windows_x86 =    (1 << 128);
  uint256 constant Windows_amd64 =  (1 << 129);
  uint256 constant Windows_aarch64 =(1 << 130);
  uint256 constant Linux_x86 =      (1 << 131);
  uint256 constant Linux_amd64 =    (1 << 132);
  uint256 constant Linux_aarch64 =  (1 << 133);
  uint256 constant Android_aarch64 =(1 << 134);
  uint256 constant iPhone_arm64 =   (1 << 135);
  uint256 constant BIOS_x86 =       (1 << 136);
  uint256 constant BIOS_amd64 =     (1 << 137);
  uint256 constant BIOS_aarch32 =   (1 << 138);
  uint256 constant BIOS_aarch64 =   (1 << 139);
  uint256 constant BIOS_arm64 =     (1 << 140);
  uint256 constant Mac_amd64 =      (1 << 141);
  uint256 constant Mac_arm64 =      (1 << 142);
  // Room here for expansion

  // End with general types
  uint256 constant SourceCode =     (1 << 156);
  uint256 constant Agnostic =       (1 << 157);
  uint256 constant NotApplicable =  (1 << 158);
  uint256 constant Other =          (1 << 159);
  // Room for expansion up to value (255 << 152) (last byte of type)

  // Bits 160 through 256 are available for expansion

  // Product License Activation Flags
  
  // Flags begin at bit 160 and go until bit 191
  uint256 constant ExpirationFlag =     (1 << 160); // Activation expiration
  uint256 constant LimitationFlag =     (1 << 161); // Version/language limitations
                                                    // Cannot be used with feature
  uint256 constant NoResaleFlag =       (1 << 162); // Disallow resale after purchase
                                                    // Per EU "first sale" law, cannot
                                                    // be set if expiration NOT set
  uint256 constant FeatureFlag =        (1 << 163); // Specific application feature
                                                    // ie. Value is feature specific
                                                    // CANNOT be used with Limitation
                                                    // flag
  uint256 constant LimitedOffersFlag =  (1 << 164); // Limited number of offers
                                                    // UniqueId is used for number
                                                    // Offer flag only, not used in
                                                    // activate token id
  uint256 constant BulkOffersFlag =     (1 << 165); // Limited number of offers
                                                    // UniqueId is used for number
                                                    // Offer flag only, not used in
                                                    // activate token id. Cannot be
                                                    // used with LimitedOffersFlag

  // Offset and mask of entity and product identifiers
  uint256 constant EntityIdOffset = 224;
  uint256 constant EntityIdMask =  (0xFFFFFFFF << EntityIdOffset);
  uint256 constant ProductIdOffset = 192;
  uint256 constant ProductIdMask =  (0xFFFFFFFF << ProductIdOffset);

  // Bits to help enforce non fungible (unique) token
  uint256 constant UniqueIdOffset = 176;
  uint256 constant UniqueIdMask =  (0xFFFF << UniqueIdOffset);

  // Flags allow different activation types and Value layout
  uint256 constant FlagsOffset = 160;
  uint256 constant FlagsMask =  (0xFFFF << FlagsOffset);

  // Expiration is common, last before common 128 bit Value
  uint256 constant ExpirationOffset = 128;
  uint256 constant ExpirationMask = (0xFFFFFFFF <<
                                     ExpirationOffset);

  // If limitation flag set, the Value is entirely utilized

  // Bits 64 - 127 are for language (as defined above)
  uint256 constant LanguageOffset = 64;
  uint256 constant LanguageMask =  (0xFFFFFFFFFFFFFFFF <<
                                    LanguageOffset);

  // Final 64 bits of value is version (4 different 16 bit values)
  uint256 constant LimitVersionOffset = 0;
  uint256 constant LimitVersionMask =  (0xFFFFFFFFFFFFFFFF <<
                                        LimitVersionOffset);

  // The value is the 128 LSBs
  //   32 bits if limitations flag set (96 bits version/language)
  //   All 128 bits if limitations flag not set
  //   
  uint256 constant ValueOffset = 0;
  uint256 constant ValueMask =  0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

  // Error strings
  string constant EntityIsZero = "EntityID zero";
  string constant OfferNotFound = "Offer not found";
  string constant EntityNotValidated = "Entity not validated";

  string constant HashCannotBeZero = "Hash cannot be zero";
  string constant TokenEntityNoMatch = "Token entity does not match";
  string constant TokenProductNoMatch = "Token product id does not match";
  string constant TokenNotUnique = "TokenId is NOT unique";
}
