// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ProjectContract is Ownable{

    uint256 private baseAmount = 1 * 10 ** 18;

    uint256 private minAmount = baseAmount / 100;

    uint256 private rewardRate = 90;

    address constant emptyAddress = address(0x0);
    
    uint256 private amount;
    uint256 private totalAmount;
    uint256 private totalNum;
    uint256 private overNum = 0;
    uint256 private perAmount = minAmount;

    bool private investStatus = false;
    bool private withdrawStatus = false;

    struct InvestItem {
        address investAddress;
        string guessNum;
        uint amount;
        uint timestamp;
    }

    // init contract
    constructor(uint256 _amount, uint256 _totalNum) Ownable(){
        uint256 tmpAmount = (_amount * baseAmount) / 100;
        require(tmpAmount >= minAmount, "amount err");
        require(_totalNum >= 5, "totalNum err");
        // set owner
        transferOwnership(msg.sender);
        uint16 _totalAmount = uint16(tmpAmount * _totalNum);
        amount = _amount;
        totalAmount = _totalAmount;
        totalNum = _totalNum;
        perAmount = tmpAmount;
    }

    // investItem
    InvestItem[] private invests;

    // winner number
    string private winNum;

    // Is exits guess number 
    mapping(string => bool) private exitsGussNum;

    // Is exits address
    mapping(address => bool) private exitsAddress;

    event investEvent(address _investAddress, uint256 _value, uint status);

    // get contract param
    function getCurrentProject() public view returns (uint256, uint256, uint256){
        return (amount, totalNum, overNum);
    }

    // 1000 guess number empty
    // 1001 not contract owner participate
    // 1002 exits guess number
    // 1003 exits address
    // 1005 invest amount not lt perAmount
    function investProject(string memory _guessNum) public payable{
        require(bytes(_guessNum).length > 0, "1000");
        require(msg.sender != owner(), "1001");
        require(!exitsGussNum[_guessNum], "1002");
        require(!exitsAddress[msg.sender], "1003");
        require(invests.length < totalNum, "1004");
        require(msg.value >= perAmount, "1005");
        require(!investStatus, "1006");

        invests.push(InvestItem(msg.sender, _guessNum, msg.value, block.timestamp));
        exitsAddress[msg.sender] = true;
        exitsGussNum[_guessNum] = true;
        overNum = invests.length;
        investStatus = (invests.length == totalNum);
        emit investEvent(msg.sender, msg.value, 1);
    }

    // get invest list
    function getInvestList() public view returns(InvestItem[] memory){
        return invests;
    }

    // 1006 set win number
    function withdraw() public payable onlyOwner{
        require(bytes(winNum).length > 0, "2000");
        address account = emptyAddress;
        for(uint i=0;i < invests.length; i++){
            InvestItem memory invest = invests[i];
            if(keccak256(abi.encode(invest.guessNum)) == keccak256(abi.encode(winNum))){
                account = invest.investAddress;
            }
        }
        if(account != emptyAddress){
            uint256 balance = address(this).balance;
            uint256 rewardAmount = (balance * rewardRate) / 100;
            payable(account).transfer(rewardAmount);
            payable(owner()).transfer(balance - rewardAmount);
            withdrawStatus = true;
        }
    }

    function getBalance()public view returns (uint256){
        return address(this).balance;
    }
    
    function setWinNum(string memory _winNum) public onlyOwner {
        require(invests.length == totalNum, "1007");
        winNum = _winNum;
    }

    function getWinNum() public view returns (string memory){
        return winNum;
    }

    function getStatus() public view returns (bool, bool) {
        return (investStatus, withdrawStatus);
    }

}
