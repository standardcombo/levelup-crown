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
  mapping(string => uint256) public nftHolders;

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

  function levelUp(string memory _address) public {
    require(owner == msg.sender, "Error: tried to levelUp a crown from a non-authorized address");

    uint256 nftTokenIdOfPlayer = nftHolders[_address];
    CrownAttributes storage crown = nftHolderAttributes[nftTokenIdOfPlayer];

    require(
      crown.level < 5,
      "Error: crown has already reached the maximum level."
    );

    crown.level = crown.level + 1;
  }

  function reset(string memory _address) public {
    require(owner == msg.sender, "Error: tried to levelUp a crown from a non-authorized address");

    uint256 nftTokenIdOfPlayer = nftHolders[_address];
    CrownAttributes storage crown = nftHolderAttributes[nftTokenIdOfPlayer];

    crown.level = 1;
  }

  function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
      bytes memory tmp = bytes(_a);
      uint160 iaddr = 0;
      uint160 b1;
      uint160 b2;
      for (uint i = 2; i < 2 + 2 * 20; i += 2) {
          iaddr *= 256;
          b1 = uint160(uint8(tmp[i]));
          b2 = uint160(uint8(tmp[i + 1]));
          if ((b1 >= 97) && (b1 <= 102)) {
              b1 -= 87;
          } else if ((b1 >= 65) && (b1 <= 70)) {
              b1 -= 55;
          } else if ((b1 >= 48) && (b1 <= 57)) {
              b1 -= 48;
          }
          if ((b2 >= 97) && (b2 <= 102)) {
              b2 -= 87;
          } else if ((b2 >= 65) && (b2 <= 70)) {
              b2 -= 55;
          } else if ((b2 >= 48) && (b2 <= 57)) {
              b2 -= 48;
          }
          iaddr += (b1 * 16 + b2);
      }
      return address(iaddr);
  }

  function mint(string memory _address) external {
    uint256 newItemId = _tokenIds.current();
    _safeMint(parseAddr(_address), newItemId);

    nftHolderAttributes[newItemId] = CrownAttributes({
      crownIndex: newItemId,
      level: 1
    });

    console.log("Minted NFT w/ tokenId %s", newItemId);
    
    // Keep an easy way to see who owns what NFT.
    nftHolders[_address] = newItemId;

    // Increment the tokenId for the next person that uses it.
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