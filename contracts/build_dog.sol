// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BuildDog is ERC20, Ownable {

    uint constant _initial_supply = 1000*10**18;

    constructor() ERC20("BuildDoG", "BDG") Ownable(){
        _mint(msg.sender, _initial_supply);
    }

    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "address is zero");
        // 铸造代币并给account
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public {
        require(account == msg.sender, "burn error");
        // 从account销毁代币
        _burn(account, amount);
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

}