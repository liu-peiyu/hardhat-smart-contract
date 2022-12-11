// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TicketContract{

    address private owner;

    constructor(){
        owner = msg.sender;
    }

    uint private baseAmount = 1 * 10 ** 18;

    uint8 private div = 100;

    struct SupportItem {
        address supportAddress;
        string supportText;
        uint8 ratio;
        uint256 amount;
        uint timestamp;
    }

    event Log(uint8 rnd, uint256 balance, uint256 amount);

    SupportItem[] public supportList;

    function supportTicket(string memory ticket) public payable{
        require(msg.value >= (baseAmount / div));
        payable(owner).transfer(baseAmount / div / 10);
        uint8 randomNumber = uint8( uint256(keccak256(abi.encodePacked(ticket, block.number, block.difficulty))) % 10);
        uint256 contractBalance = address(this).balance;
        uint256 amount = contractBalance * randomNumber / 100;
        emit Log(randomNumber, contractBalance, amount);
        supportList.push(SupportItem(msg.sender, ticket, randomNumber, amount, block.timestamp));
        payable(msg.sender).transfer(amount);
    }

    function getSupports() public view returns (SupportItem[] memory){
        return supportList;
    }

    function setDiv(uint8 _div) external returns (uint8){
        require(msg.sender == owner);
        div = _div;
        return div;
    }

    function getDiv() public view returns (uint8){
        return div;
    }

    function getBalance()public view returns (uint256){
        return address(this).balance;
    }
}