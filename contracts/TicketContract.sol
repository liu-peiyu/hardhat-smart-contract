// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TicketContract{
    address private owner;

    constructor(){
        owner = msg.sender;
    }

    event Log(uint8 rnd, uint256 balance, uint256 amount);

    mapping(address => bool) public whiteList;

    function supportTicket(string memory ticket) public payable{
        require(msg.value >= 0.01*10**18);
        whiteList[msg.sender] = true;
        payable(owner).transfer(0.001 * 10 ** 18);
        uint8 randomNumber = uint8( uint256(keccak256(abi.encodePacked(ticket, block.timestamp, block.difficulty))) % 10);
        uint256 contractBalance = address(this).balance;
        uint256 amount = contractBalance * randomNumber / 100;
        emit Log(randomNumber, contractBalance, amount);
        payable(msg.sender).transfer(amount);
    }

    function getBalance()public view returns (uint256){
        return address(this).balance;
    }
}