// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract StockIndexContract is Ownable{

    // 定义计数函数
    using Counters for Counters.Counter;

    Counters.Counter private phase;

    uint private minAmount = 1 * 10 ** 16;

    struct ProjectItem {
        uint amount; //每份金额
        uint16 totalAmount; //总金额
        uint16 totalNum; //总数量
        uint16 overNum; //已用数量
        uint16 ableNum; //可用数量
    }

    struct InvestItem {
        address investAddress;
        string guessNum;
        uint amount;
        uint timestamp;
    }

    struct ProjectInvestItem {
        InvestItem invest;
        uint size;
    }

    constructor() Ownable(){
        // 设置合约持有人
        transferOwnership(msg.sender);
        createProject(1*10**16, 10);
    }

    // using IterableMapping for ItMap;

    // ItMap shares;

    // projectId => projectItem
    mapping(uint256 => ProjectItem) private projects;
    // projectId => guess num => investItem
    mapping(uint256 => mapping(string => InvestItem)) private invests;
    // projectId => projectInvestItem
    mapping(uint256 => string[]) private investSize;

    event investEvent(address _investAddress, uint256 _value);

    event logEvent(string info);

    // 通过合约创建项目，并把项目存储在磁盘
    // uint = uint256
    function createProject(uint _amount, uint16 _totalNum) public onlyOwner returns (uint256){
        require(_amount >= minAmount, "amount err");
        require(_totalNum >= 10, "totalNum err");
        // require(_totalNum == _ableNum, "amount err");
        // 初始化设置为1
        phase.increment();
        // 获取本期期数
        uint256 currentPhase = phase.current();
        uint16 _totalAmount = uint16(_amount * _totalNum);
        ProjectItem memory projectItem = ProjectItem({amount: _amount, totalAmount:_totalAmount, totalNum: _totalNum, overNum: 0, ableNum:_totalNum});
        projects[currentPhase] = projectItem;
        return currentPhase;
    }

    // 获取当前执行期数
    function getCurrentPhase() public view returns (uint256){
        return phase.current();
    }

    // 获取当前执行项目信息
    function getCurrentProject() public view returns (uint256, uint16, uint16){
        require(phase.current()>0, "no project");
        return (projects[phase.current()].amount, projects[phase.current()].totalNum, projects[phase.current()].overNum);
    }

    // 根据ID获取项目信息
    function getProjectByPhase(uint256 _projectNo) public view returns (uint256, uint16, uint16) {
        require(phase.current() >= _projectNo, "project no exist");
        return (projects[_projectNo].amount, projects[_projectNo].totalNum, projects[_projectNo].overNum);
    }

    function investProject(uint256 _projectNo, string memory _guessNum) public payable{
        require(_projectNo > 0, "project id err");
        require(bytes(_guessNum).length != 0, "guess num err");
        require(msg.sender != address(0), "invest address err");
        // require(msg.sender != owner.address, "forbid owner");

        mapping(string => InvestItem) storage _projectInvests = invests[_projectNo];

         // 判断该数字是否已经已经参与本期竞猜
        if(investSize[_projectNo].length > 0){
            uint _timestamp = _projectInvests[_guessNum].timestamp;
            require(_timestamp > 0, "invest address err");
        }

        InvestItem memory investItem = InvestItem({investAddress: msg.sender, guessNum: _guessNum, amount: msg.value, timestamp: block.timestamp});
        invests[_projectNo][_guessNum] = investItem;
        investSize[_projectNo].push(_guessNum);
        emit investEvent(msg.sender, msg.value);
    }

    // 获取所有竞猜数
    function getCurrentInvest() public view returns(string[] memory){
        require(phase.current()>0, "no project");
        return investSize[phase.current()];
    }

    // 根据项目编号获取所有竞猜数
    function getCurrentInvestByProjectId(uint256 _projectNo) public view returns(string[] memory){
        require(phase.current() >= _projectNo, "no project");
        return investSize[_projectNo];
    }

    // 获取竞猜详细信息
    function getCurrentInvestByGuessNum(uint256 _projectNo, string memory _guessNum) public view returns(InvestItem memory){
        require(phase.current() >= _projectNo, "no project");
        require(bytes(_guessNum).length != 0, "guess num err");
        InvestItem memory item = invests[_projectNo][_guessNum];
        return item;
    }

    // 指定账户从合约提现
    function withdraw(address account) public onlyOwner{
        payable(account).transfer(address(this).balance);
    }

    // 获取合约余额
    function getBalance()public view returns (uint256){
        return address(this).balance;
    }

}