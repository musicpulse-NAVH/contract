// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MusicPulseNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string[] public musicURLList;

  constructor() ERC721("MusicPulseNFT", "MPN") {}

  function mint(address to_, string memory tokenURI_) public returns (uint256) {
    uint256 newItemId = _tokenIds.current();
    _mint(to_, newItemId);
    _setTokenURI(newItemId, tokenURI_);

    _tokenIds.increment();
    musicURLList.push(tokenURI_);
    return newItemId;
  }

  function getMusicURLList() external view returns (string[] memory) {
    return musicURLList;
  }
}