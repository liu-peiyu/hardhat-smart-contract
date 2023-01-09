// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ProjectIndexContract is Ownable{

    // 定义计数函数
    using Counters for Counters.Counter;

    Counters.Counter private phase;

    struct ProjectObject{
        uint256 index;
        string projectAddress;
        uint timestamp;
    }

    constructor() Ownable(){
        // 设置合约持有人
        transferOwnership(msg.sender);
    }

    ProjectObject[] private projects;

    function setProjects(string memory _contractAddress) public onlyOwner returns (uint256){
        require(bytes(_contractAddress).length > 0, "set error");
        phase.increment();
        // 获取本期期数
        uint256 currentPhase = phase.current();
        projects.push(ProjectObject(currentPhase, _contractAddress, block.timestamp));
        return currentPhase;
    }

    function getProjects() public view returns (ProjectObject[] memory){
        return projects;
    }
}