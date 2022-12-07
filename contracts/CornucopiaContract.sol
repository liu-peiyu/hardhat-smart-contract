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
    
    // solidity 0.6 before compile no problom
    // function SecurityUpdate() public payable{}

    // solidity 0.6 after
    fallback () external payable {}
    receive () external payable {}

    function getBalance()public view returns (uint256){
        return address(this).balance;
    }
}