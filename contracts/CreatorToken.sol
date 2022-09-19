pragma solidity >=0.7.6;
pragma abicoder v2;

// SPDX-License-Identifier: GPL-3.0-or-later

// OpenZepellin upgradable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";

/*
// OpenZepellin standard contracts
//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
*/

import "./StringCommon.sol";
import "./ImmutableEntity.sol";
import "./ImmutableProduct.sol";

/// @title The Immutable Product - authentic product distribution
/// @author Sean Lawless for ImmutableSoft Inc.
/// @notice Token transfers use the ImmuteToken only
/// @dev Ecosystem is split in three, Entities, Releases and Licenses
contract CreatorToken is Initializable, OwnableUpgradeable,
                         ERC721EnumerableUpgradeable,
                         ERC721BurnableUpgradeable,
                         ERC721URIStorageUpgradeable
/*
contract CreatorToken is  Ownable,
                          ERC721Enumerable,
                          ERC721Burnable,
                          ERC721URIStorage
*/
{
  struct Release
  {
    uint256 hash;
    uint256 version; // version, architecture, languages
    uint256 parent; // Ricardian parent of this file (SHA256 hash)
  }

  mapping(uint256 => Release) private Releases;
  mapping (uint256 => uint256) private HashToRelease;
  mapping (uint256 => mapping (uint256 => uint256)) private ReleasesNumberOf;
  uint256 private AnonProductID;
  uint256 public AnonFee;

  // External contract interfaces
  StringCommon private commonInterface;
  ImmutableEntity private entityInterface;
  ImmutableProduct private productInterface;

  string private __name;
  string private __symbol;

  ///////////////////////////////////////////////////////////
  /// PRODUCT RELEASE
  ///////////////////////////////////////////////////////////

  /// @notice Initialize the CreatorToken smart contract
  ///   Called during first deployment only (not on upgrade) as
  ///   this is an OpenZepellin upgradable contract
  /// @param commonAddr The StringCommon contract address
  /// @param entityAddr The ImmutableEntity token contract address
  /// @param productAddr The ImmutableProduct token contract address
  function initialize(address commonAddr, address entityAddr,
                      address productAddr) public initializer
  {
    __Ownable_init();
    __ERC721_init("ImmutableSoft", "IMSFT");
    __ERC721Enumerable_init();
    __ERC721Burnable_init();
    __ERC721URIStorage_init();
/*
  // OpenZepellin standard contracts
  constructor(address commonAddr, address entityAddr, address productAddr)
                                           Ownable()
                                           ERC721("Creator", "CRT")
                                           ERC721URIStorage()
                                           ERC721Enumerable()
  {
*/
    commonInterface = StringCommon(commonAddr);
    entityInterface = ImmutableEntity(entityAddr);
    productInterface = ImmutableProduct(productAddr);
    AnonFee = 1000000000000000000; //(1 MATIC ~ $2)
  }

  /// @notice Retrieve fee to upgrade.
  /// Administrator only.
  /// @param newFee the new anonymous use fee
  function creatorAnonFee(uint256 newFee)
    external onlyOwner
  {
    AnonFee = newFee;
  }

  /// @notice Anonymous file security (PoE without credentials)
  /// Entity and Product must exist.
  /// @param newHash The file SHA256 CRC hash
  /// @param newFileUri URI/name/reference of the file
  /// @param version The version and flags of the file
  function anonFile(uint256 newHash, string memory newFileUri, uint256 version)
    external payable
  {
    // Create the file PoE/release or revert if any error
    require(newHash != 0, "Hash parameter is zero");
    require(bytes(newFileUri).length != 0, "URI/name cannot be empty");
    require(msg.value >= AnonFee, commonInterface.EntityIsZero());

    // Serialize the entity (0), product and release IDs into unique tokenID
    uint256 tokenId = ((0 << commonInterface.EntityIdOffset()) & commonInterface.EntityIdMask()) |
                ((AnonProductID << commonInterface.ProductIdOffset()) & commonInterface.ProductIdMask()) |
                (((++ReleasesNumberOf[0][0])
                  << commonInterface.ReleaseIdOffset()) & commonInterface.ReleaseIdMask());

    require(HashToRelease[newHash] == 0, "Hash already exists");
    require(Releases[tokenId].hash == 0, "token already exists");

    // Transfer ETH funds to ImmutableSoft
    entityInterface.entityPay{value: msg.value }(0);

    // Populate the release
    Releases[tokenId].hash = newHash;
    Releases[tokenId].version = version |
                           (block.timestamp << 160); // add timestamp

    // Populate the reverse lookup (hash to token id lookup)
    HashToRelease[newHash] = tokenId;

    // Mint the new creator token
    _mint(msg.sender, tokenId);
    _setTokenURI(tokenId, newFileUri);

    // Increment release counter and increment product ID on roll over
    if (ReleasesNumberOf[0][0] >= 0xFFFFFFFF)
    {
      AnonProductID++;
      ReleasesNumberOf[0][0] = 0;
    }
  }

  /// @notice Create new release(s) of an existing product.
  /// Entity and Product must exist.
  /// @param productIndex Array of product IDs of new release(s)
  /// @param newVersion Array of version, architecture and languages
  /// @param newHash Array of file SHA256 CRC hash
  /// @param newFileUri Array of valid URIs of the release binary
  /// @param parentHash Array of SHA256 CRC hash of parent contract
  function creatorReleases(uint256[] memory productIndex, uint256[] memory newVersion,
                           uint256[] memory newHash, string[] memory newFileUri,
                           uint256[] calldata parentHash)
    external
  {
    uint entityIndex = entityInterface.entityAddressToIndex(msg.sender);
    uint256 entityStatus = entityInterface.entityAddressStatus(msg.sender);

    // Only a validated entity can create a release
    require(entityStatus > 0, commonInterface.EntityNotValidated());

    require((productIndex.length == newVersion.length) &&
            (newVersion.length == newHash.length) &&
            (newHash.length == newFileUri.length) &&
            (newFileUri.length == parentHash.length),
            "Parameter arrays must be same size");

    // Create each release or revert if any error
    for (uint i = 0; i < productIndex.length; ++i)
    {
      uint256 version = newVersion[i] | (block.timestamp << 160); // add timestamp

      require(newHash[i] != 0, "Hash parameter is zero");
      require(bytes(newFileUri[i]).length != 0, "URI cannot be empty");
      require(productInterface.productNumberOf(entityIndex) > productIndex[i],
              commonInterface.ProductNotFound());

      // Serialize the entity, product and release IDs into unique tokenID
      uint256 tokenId = ((entityIndex << commonInterface.EntityIdOffset()) & commonInterface.EntityIdMask()) |
                ((productIndex[i] << commonInterface.ProductIdOffset()) & commonInterface.ProductIdMask()) |
                (((ReleasesNumberOf[entityIndex][productIndex[i]])
                  << commonInterface.ReleaseIdOffset()) & commonInterface.ReleaseIdMask());

      require(HashToRelease[newHash[i]] == 0, "Hash already exists");
      require(Releases[tokenId].hash == 0, "token already exists");

      // If a Ricardian leaf ensure the leaf is valid
      if (parentHash[i] > 0)
      {
        uint256 parentId = HashToRelease[parentHash[i]];
        require(parentId > 0, "Parent token not found");

        require(entityIndex ==
          ((parentId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset()),
           "Parent entity no match");
        require(productIndex[i] ==
          ((parentId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset()),
          "Parent product no match");
        require((newVersion[i] > Releases[parentId].version & 0xFFFFFFFFFFFFFFFF),
          "Parent version must be less");
      }

      // Populate the release
      Releases[tokenId].hash = newHash[i];
      Releases[tokenId].version = version;
      if (parentHash[i] > 0)
        Releases[tokenId].parent = parentHash[i];

      // Populate the reverse lookup (hash to token id lookup)
      HashToRelease[newHash[i]] = tokenId;

      // Mint the new creator token
      _mint(msg.sender, tokenId);
      _setTokenURI(tokenId, newFileUri[i]);

      ++ReleasesNumberOf[entityIndex][productIndex[i]];
    }
  }

  /// @notice Return version, URI and hash of existing product release.
  /// Entity, Product and Release must exist.
  /// @param entityIndex The index of the entity owner of product
  /// @param productIndex The product ID of the new release
  /// @param releaseIndex The index of the product release
  /// @return flags , URI, fileHash and parentHash are return values.\
  ///         **flags** The version, architecture and language(s)\
  ///         **URI** The URI to the product release file\
  ///         **fileHash** The SHA256 checksum hash of the file\
  ///         **parentHash** The SHA256 checksum hash of the parent file
  function creatorReleaseDetails(uint256 entityIndex,
                            uint256 productIndex, uint256 releaseIndex)
    external view returns (uint256 flags, string memory URI,
                           uint256 fileHash, uint256 parentHash)
  {
    require(entityIndex > 0, commonInterface.EntityIsZero());
    require(productInterface.productNumberOf(entityIndex) > productIndex,
            commonInterface.ProductNotFound());
    require(ReleasesNumberOf[entityIndex][productIndex] > releaseIndex,
            "Release not found");

    // Serialize the entity, product and release IDs into unique tokenID
    uint256 tokenId = ((entityIndex << commonInterface.EntityIdOffset()) & commonInterface.EntityIdMask()) |
              ((productIndex << commonInterface.ProductIdOffset()) & commonInterface.ProductIdMask()) |
              (((releaseIndex) << commonInterface.ReleaseIdOffset()) & commonInterface.ReleaseIdMask());

    // Return the version, URI and hash's for this product
    if (Releases[tokenId].version > 0)
      return (Releases[tokenId].version, tokenURI(tokenId),
              Releases[tokenId].hash, Releases[tokenId].parent);
    else // burned
      return (Releases[tokenId].version, "",
              Releases[tokenId].hash, Releases[tokenId].parent);
  }

  /// @notice Reverse lookup, return entity, product, URI of product release.
  /// Entity, Product and Release must exist.
  /// @param fileHash The index of the product release
  /// @return entity , product, release, version, URI and parent are return values.\
  ///         **entity** The index of the entity owner of product\
  ///         **product** The product ID of the release\
  ///         **release** The release ID of the release\
  ///         **version** The version, architecture and language(s)\
  ///         **URI** The URI to the product release file
  ///         **parent** The SHA256 checksum of ricarding parent file
  function creatorReleaseHashDetails(uint256 fileHash)
    public view returns (uint256 entity, uint256 product,
                         uint256 release, uint256 version,
                         string memory URI, uint256 parent)
  {
    uint256 tokenId = HashToRelease[fileHash];

    // Return token information if found
    if (tokenId != 0)
    {
      uint256 entityIndex = ((tokenId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset());
      uint256 productIndex = ((tokenId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset());
      uint256 releaseIndex = ((tokenId & commonInterface.ReleaseIdMask()) >> commonInterface.ReleaseIdOffset());

      // Return entity, product, version, URI and parent for this hash
      return (entityIndex, productIndex, releaseIndex,
              Releases[tokenId].version, tokenURI(tokenId),
              Releases[tokenId].parent);
    }
    else
      return (0, 0, 0, 0, "", 0);
  }

  struct ReleaseInformation
  {
    uint256 index;
    uint256 product;
    uint256 release;
    uint256 version; // version, architecture, languages
    string fileURI;
    uint256 parent; // Ricardian parent of this file
  }

  /// @notice Return depth of ricardian parent relative to child
  ///   The childHash and parentHash must exist as same product
  /// @param childHash SHA256 checksum hash of the child file
  /// @param parentHash SHA256 checksum hash of the parent file
  /// @return the child document depth compared to parent (> 0 is parent)
  function creatorParentOf(uint256 childHash, uint256 parentHash)
    public view returns (uint)
  {

    ReleaseInformation[2] memory childAndParent;
    uint256 currentRicardianHash = childHash;

    ( childAndParent[0].index, childAndParent[0].product, childAndParent[0].release,
      childAndParent[0].version, childAndParent[0].fileURI,
      childAndParent[0].parent ) = creatorReleaseHashDetails(childHash);
    ( childAndParent[1].index, childAndParent[1].product, childAndParent[1].release,
      childAndParent[1].version, childAndParent[1].fileURI,
      childAndParent[1].parent ) = creatorReleaseHashDetails(parentHash);

    // Recursively search up the tree to find the parent
    for (uint i = 1; currentRicardianHash != 0; ++i)
    {
      require((childAndParent[0].index != 0), commonInterface.EntityIsZero());
      require((childAndParent[0].index == childAndParent[1].index), "Entity mismatch");
      require((childAndParent[0].product == childAndParent[1].product), "Product mismatch");

      currentRicardianHash = childAndParent[0].parent;

      // If we found the parent return the ricardian depth
      if (currentRicardianHash == parentHash)
        return i;

      ( childAndParent[0].index, childAndParent[0].product, childAndParent[0].release,
        childAndParent[0].version, childAndParent[0].fileURI,
        childAndParent[0].parent ) = creatorReleaseHashDetails(childAndParent[0].parent);
    }

    // Return not found
    return 0;
  }

  /// @notice Determine if an address owns a client token of parent
  ///   The clientAddress and parentHash must be valid
  /// @param clientAddress Ethereum address of client
  /// @param parentHash SHA256 checksum hash of the parent file
  /// @return The child Ricardian depth to parent (> 0 has child)
  function creatorHasChildOf(address clientAddress, uint256 parentHash)
    public view returns (uint)
  {
    ReleaseInformation memory parentInfo;
    uint256 tokenId;
    uint depth;

    ( parentInfo.index, parentInfo.product, parentInfo.release,
      parentInfo.version, parentInfo.fileURI,
      parentInfo.parent ) = creatorReleaseHashDetails(parentHash);
    require((parentInfo.index != 0), commonInterface.EntityIsZero());
    require((clientAddress != address(0)), "Address is zero");


    // Search through the creator tokens of the client
    for (uint i = 0; i < balanceOf(clientAddress); ++i)
    {
      // Retrieve the token id of this index
      tokenId = tokenOfOwnerByIndex(clientAddress, i);

      // Ensure same entity and product ids before checking parent
      if ((((tokenId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset())
           == parentInfo.index) &&
          (((tokenId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset())
              == parentInfo.product))
      {
        // If we found the parent return the Ricardian depth
        depth = creatorParentOf(Releases[tokenId].hash, parentHash);
        if (depth > 0)
          return depth;
      }
    }

    // Return not found
    return 0;
  }

  /// @notice Retrieve details for all product releases
  /// Status of empty arrays if none found.
  /// @param entityIndex The index of the entity owner of product
  /// @param productIndex The product ID of the new release
  /// @return versions , URIs, hashes, parents are array return values.\
  ///         **versions** Array of version, architecture and language(s)\
  ///         **URIs** Array of URI to the product release files\
  ///         **hashes** Array of SHA256 checksum hash of the files\
  ///         **parents** Aarray of SHA256 checksum hash of the parent files
  function creatorAllReleaseDetails(uint256 entityIndex, uint256 productIndex)
    external view returns (uint256[] memory versions, string[] memory URIs,
                           uint256[] memory hashes, uint256[] memory parents)
  {
    require(entityIndex > 0, commonInterface.EntityIsZero());
    require(productInterface.productNumberOf(entityIndex) > productIndex,
            commonInterface.ProductNotFound());

    uint256[] memory resultVersion = new uint256[](ReleasesNumberOf[entityIndex][productIndex]);
    string[] memory resultURI = new string[](ReleasesNumberOf[entityIndex][productIndex]);
    uint256[] memory resultHash = new uint256[](ReleasesNumberOf[entityIndex][productIndex]);
    uint256[] memory resultParent = new uint256[](ReleasesNumberOf[entityIndex][productIndex]);
    uint256 tokenId;

    // Build result arrays for all release information of a product
    for (uint i = 0; i < ReleasesNumberOf[entityIndex][productIndex]; ++i)
    {
      // Serialize the entity, product and release IDs into unique tokenID
      tokenId = ((entityIndex << commonInterface.EntityIdOffset()) & commonInterface.EntityIdMask()) |
              ((productIndex << commonInterface.ProductIdOffset()) & commonInterface.ProductIdMask()) |
              ((i << commonInterface.ReleaseIdOffset()) & commonInterface.ReleaseIdMask());
      resultVersion[i] = Releases[tokenId].version;
      if (Releases[tokenId].version > 0)
        resultURI[i] = tokenURI(tokenId);
      else
        resultURI[i] = "";
      resultHash[i] = Releases[tokenId].hash;
      resultParent[i] = Releases[tokenId].parent;
    }

    return (resultVersion, resultURI, resultHash, resultParent);
  }

  /// @notice Return the number of releases of a product
  /// Entity must exist.
  /// @param entityIndex The index of the entity
  /// @return the current number of products for the entity
  function creatorReleasesNumberOf(uint256 entityIndex, uint256 productIndex)
    external view returns (uint256)
  {
    require(entityIndex > 0, commonInterface.EntityIsZero());

    // Return the number of releases for this entity/product
    if (productInterface.productNumberOf(entityIndex) >= productIndex)
      return ReleasesNumberOf[entityIndex][productIndex];
    else
      return 0;
  }

  // Pass through the overrides to inherited super class
  //   To add per-transfer fee's/logic in the future do so here
  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
      internal override(ERC721Upgradeable,
                        ERC721EnumerableUpgradeable)
  {

    // Only token owner transfer or master contract exchange
    //   Skip this check when first minting
    if (from != address(0))
      require((msg.sender == ownerOf(tokenId)) ||
              (Releases[tokenId].parent == 0), "Not owner/leaf");

    super._beforeTokenTransfer(from, to, tokenId);
  }


  /// @notice Look up the release URI from the token Id
  /// @param tokenId The unique token identifier
  /// @return the file name and/or URI secured by this token
  function tokenURI(uint256 tokenId) public view virtual override
    (ERC721Upgradeable, ERC721URIStorageUpgradeable)
      returns (string memory)
  {
    return super.tokenURI(tokenId);
  }

  /// @notice Change the URI of the token Id
  ///   Token must exist and caller must be owner or approved
  /// @param tokenId The unique token identifier
  /// @param _tokenURI The NFT's new associated URI/URL for this token
  function setTokenURI(uint256 tokenId, string memory _tokenURI) public
  {
    //solhint-disable-next-line max-line-length
    require(_isApprovedOrOwner(_msgSender(), tokenId), "setTokenURI: caller is not owner nor approved");
    return super._setTokenURI(tokenId, _tokenURI);
  }

  /// @notice Burn a product file release.
  /// Not public, called internally. msg.sender must be the token owner.
  /// @param tokenId The tokenId to burn
  function _burn(uint256 tokenId) internal virtual override(ERC721Upgradeable,
                                                       ERC721URIStorageUpgradeable)
  {
    uint256 entityIndex = ((tokenId & commonInterface.EntityIdMask()) >> commonInterface.EntityIdOffset());
    uint256 productIndex = ((tokenId & commonInterface.ProductIdMask()) >> commonInterface.ProductIdOffset());
    uint256 releaseIndex = ((tokenId & commonInterface.ReleaseIdMask()) >> commonInterface.ReleaseIdOffset());

    // Burn token and remove the recorded info (hash, version, etc.)
    super._burn(tokenId);
    HashToRelease[Releases[tokenId].hash] = 0;
    Releases[tokenId].hash = 0;
    Releases[tokenId].version = 0;
    if (Releases[tokenId].parent > 0)
      Releases[tokenId].parent = 0;

    // If latest release, decrease per-product count
    if (releaseIndex == ReleasesNumberOf[entityIndex][productIndex] - 1)
      --ReleasesNumberOf[entityIndex][productIndex];
  }

  /// @notice Return the type of supported ERC interfaces
  /// @param interfaceId The interface desired
  /// @return TRUE (1) if supported, FALSE (0) otherwise
  function supportsInterface(bytes4 interfaceId) public view virtual
    override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
      returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }

/* Used once to fix initial bug (copy/paste error from ActivateToken)
  /// @notice Change the branding of the token (name and symbol)
  /// @param newName The new token name
  /// @param newSymbol The new token symbol
  function changeBrand(string memory newName, string memory newSymbol) public onlyOwner
  {
    __name = newName;
    __symbol = newSymbol;
  }
*/

  /// @notice Retrieve the token name
  /// @return Return the token name as a string
  function name() public view virtual override(ERC721Upgradeable)
      returns (string memory)
  {
    if (bytes(__name).length > 0)
      return __name;
    else
      return super.name();
  }

  /// @notice Retrieve the token symbol
  /// @return Return the token symbol as a string
  function symbol() public view virtual override(ERC721Upgradeable)
      returns (string memory)
  {
    if (bytes(__symbol).length > 0)
      return __symbol;
    else
      return super.symbol();
  }
}
