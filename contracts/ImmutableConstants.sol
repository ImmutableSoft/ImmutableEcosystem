pragma solidity 0.5.16;

/// @title Immutable Constants - authentic software from the source
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

  // The Type of Version begins at bit 128 and goes until bit 159
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
  // Room here for expansion

  // End with general types
  uint256 constant SourceCode =     (1 << 156);
  uint256 constant Agnostic =       (1 << 157);
  uint256 constant NotApplicable =  (1 << 158);
  uint256 constant Other =          (1 << 159);
  // Room for expansion up to value (255 << 152) (last byte of type)

  // Bits 160 through 256 are available for expansion

  // Error strings
  string constant OfferNotFound = "Offer not found";
  string constant EntityNotValidated = "Entity not validated";
}
