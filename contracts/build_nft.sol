// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract BUILD_NFT is ERC721, ERC721Enumerable, Ownable {
    string private _baseURIextended;

    uint256 public constant MAX_SUPPLY = 100;

    uint256 public constant PRICE_PER_TOKEN = 0.01 ether;

    constructor()ERC721("BUILD_NFT", "BFT"){

    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns(bool){
        return super.supportsInterface(interfaceId);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseURIextended = baseURI;
    }

    function mint(uint numberOfTokens) public payable {
        uint256 ts = totalSupply();

        require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, ts + i);
        }
    }

    function withdraw() public onlyOwner{
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

}