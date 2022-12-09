// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TicketContract{

    address private owner;

    constructor(){
        owner = msg.sender;
    }

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
        require(msg.value >= 0.01*10**18);        
        payable(owner).transfer(0.001 * 10 ** 18);
        uint8 randomNumber = uint8( uint256(keccak256(abi.encodePacked(ticket, block.timestamp, block.difficulty))) % 10);
        uint256 contractBalance = address(this).balance;
        uint256 amount = contractBalance * randomNumber / 100;
        emit Log(randomNumber, contractBalance, amount);
        supportList.push(SupportItem(msg.sender, ticket, randomNumber, amount, block.timestamp));
        payable(msg.sender).transfer(amount);
    }

    function getSupports() public view returns (SupportItem[] memory){
        return supportList;
    }

    function getBalance()public view returns (uint256){
        return address(this).balance;
    }
}