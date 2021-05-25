pragma solidity ^0.8.4;

// SPDX-License-Identifier: UNLICENSED

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// @title Immutable String - common string routines for ecosystem
/// @author Sean Lawless for ImmutableSoft Inc.
/// @dev StringCommon is string related general/pure functions
contract StringCommon is Initializable
{
  function initialize() public initializer
  {
  }

/*
  /// @notice Convert a base ENS node and label to a node (namehash).
  /// ENS nodes are represented as bytes32.
  /// @param node The ENS subnode the label is a part of
  /// @param label The bytes32 of end label
  /// @return The namehash in bytes32 format
  function namehash(bytes32 node, bytes32 label)
    public pure returns (bytes32)
  {
    return keccak256(abi.encodePacked(node, label));
  }

  /// @notice Convert an ASCII string to a normalized string.
  /// Oversimplified, removes many legitimate characters.
  /// @param str The string to normalize
  /// @return The normalized string
  function normalizeString(string memory str)
    public pure returns (string memory)
  {
    bytes memory bStr = bytes(str);
    uint j = 0;
    uint i = 0;

    // Loop to count number of characters result will have
    for (i = 0; i < bStr.length; i++) {
      // Skip if character is not a letter
      if ((bStr[i] < 'A') || (bStr[i] > 'z') ||
          ((bStr[i] > 'Z') && (bStr[i] < 'a')))
        continue;
      ++j;
    }

    // Allocate the resulting string
    bytes memory bLower = new bytes(j);

    // Loop again converting characters to normalized equivalent
    j = 0;
    for (i = 0; i < bStr.length; i++)
    {
      // Skip if character is not a letter
      if ((bStr[i] < 'A') || (bStr[i] > 'z') ||
          ((bStr[i] > 'Z') && (bStr[i] < 'a')))
        continue;

      // Convert uppercase to lower
      if ((bStr[i] >= 'A') && (bStr[i] <= 'Z')) {
        // So we add 32 to make it lowercase
        bLower[j] = bytes1(uint8(bStr[i]) + 32);
      } else {
        bLower[j] = bStr[i];
      }
      ++j;
    }
    return string(bLower);
  }
*/

  /// @notice Compare strings and return true if equal.
  /// Case sensitive.
  /// @param _a The string to be compared
  /// @param _b The string to compare
  /// @return true if strings are equal, otherwise false
  function stringsEqual(string memory _a, string memory _b)
    public pure returns (bool)
  {
    bytes memory a = bytes(_a);
    bytes memory b = bytes(_b);
    if (a.length != b.length)
      return false; // @todo unroll this loop
    for (uint i = 0; i < a.length; i ++)
      if (a[i] != b[i])
        return false;
    return true;
  }

/*
  /// @notice Convert a string to a bytes32 equivalent.
  /// Case sensitive.
  /// @param source The source string
  /// @return the bytes32 equivalent of 'source'
  function stringToBytes32(string memory source)
    public pure returns (bytes32 result)
  {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0)
      return 0x0;

    assembly
    {
      result := mload(add(source, 32))
    }
  }
*/
}
