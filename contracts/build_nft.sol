// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract BUILDNFT is ERC721, ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    string private _baseURIextended;

    uint256 public constant MAX_SUPPLY = 100;

    uint256 public constant PRICE_PER_TOKEN = 0.01 ether;

    constructor() ERC721("BUILDNFT", "BFT") ERC721URIStorage() Ownable(){}

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns(bool){
        return super.supportsInterface(interfaceId);
    }

    // function setBaseURI(string memory baseURI) external onlyOwner {
    //     _baseURIextended = baseURI;
    // }

    // function mint(uint numberOfTokens) public payable {
    //     uint256 ts = totalSupply();

    //     require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
    //     require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");

    //     for (uint256 i = 0; i < numberOfTokens; i++) {
    //         _safeMint(msg.sender, ts + i);
    //     }
    // }

    function mintNFT(address recipient, string memory _tokenURI) public payable onlyOwner  returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        return newItemId;
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage){
        super._burn(tokenId);
    }

    function withdraw() public onlyOwner{
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

}