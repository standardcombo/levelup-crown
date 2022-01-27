// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

// Helper we wrote to encode in Base64
import "./libraries/Base64.sol";

// Our contract inherits from ERC721, which is the standard NFT contract!
contract LevelUpCrown is ERC721 {

  struct CrownAttributes {
    uint crownIndex;
    uint level;
  }

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string[] images;
  address public owner;

  // We create a mapping from the nft's tokenId => that NFTs attributes.
  mapping(uint256 => CrownAttributes) public nftHolderAttributes;

  // A mapping from an address => the NFTs tokenId. Gives me an ez way
  // to store the owner of the NFT and reference it later.
  mapping(address => uint256) public nftHolders;

  constructor()
    ERC721("LevelUpCrowns", "CROWN")
  {
    owner = msg.sender;
    images = [
      "https://imgur.com/x1b59ta.gif",
      "https://imgur.com/YMpH8bm.gif",
      "https://imgur.com/s442l2C.gif",
      "https://imgur.com/glTAHwl.gif",
      "https://imgur.com/CxbAzXK.gif"
    ];

    // First ID is 1
    _tokenIds.increment();
  }

  function levelUp(address _address) public {
    require(owner == msg.sender, "Error: tried to levelUp a crown from a non-authorized address");

    uint256 nftTokenIdOfPlayer = nftHolders[_address];
    CrownAttributes storage crown = nftHolderAttributes[nftTokenIdOfPlayer];

    require(
      crown.level < 5,
      "Error: crown has already reached the maximum level."
    );

    crown.level = crown.level + 1;
  }

  function reset(address _address) public {
    require(owner == msg.sender, "Error: tried to levelUp a crown from a non-authorized address");

    uint256 nftTokenIdOfPlayer = nftHolders[_address];
    CrownAttributes storage crown = nftHolderAttributes[nftTokenIdOfPlayer];

    crown.level = 1;
  }

  function mint(address _address) external {
    uint256 newItemId = _tokenIds.current();
    _safeMint(_address, newItemId);

    nftHolderAttributes[newItemId] = CrownAttributes({
      crownIndex: newItemId,
      level: 1
    });
    console.log("Minted NFT w/ tokenId %s", newItemId);
    
    nftHolders[_address] = newItemId;
    _tokenIds.increment();
  }

  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    CrownAttributes memory crownAttributes = nftHolderAttributes[_tokenId];

    string memory strLevel = Strings.toString(crownAttributes.level);
    string memory imageURI = images[crownAttributes.level - 1];

    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "Crown #: ',
            Strings.toString(_tokenId),
            '", "description": "A beautiful crown belonging to one of the thousands of fallen kings.", "image": "',
            imageURI,
            '", "attributes": [ { "trait_type": "Level", "value": ',strLevel,', "max_value":5} ]}'
          )
        )
      )
    );

    string memory output = string(
      abi.encodePacked("data:application/json;base64,", json)
    );
    
    return output;
  }
}