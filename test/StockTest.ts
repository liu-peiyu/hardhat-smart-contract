import { expect } from "chai";
import { ethers } from "hardhat";

let Token:any;
let owner:any;
let addr1:any, addr2:any;

let hardToken:any;

beforeEach(async function () {
    Token = await ethers.getContractFactory("StockIndexContract");
    [owner, addr1, addr2] = await ethers.getSigners();
    console.log(owner.address);
    console.log(addr1.address);
    console.log(addr2.address);
    hardToken = await Token.deploy();
    console.log("Token address:", hardToken.address);
    
  });

describe("Token contract", function(){
    it("Test one", async function () {
        let ret1 = await hardToken.investProject(1, "20");
        // let ret2 = await hardToken.investProject(1, "20");
        console.log('ret1', ret1);
        // console.log('ret2', ret2);
        // await hardToken.burn(addr2.address, 5);

        const balance = await hardToken.getCurrentInvest();
        expect(balance).with.lengthOf(1);
    })

    it("Test tow", async function () {
        let ret1 = await hardToken.investProject(1, "20");
        // let ret2 = await hardToken.investProject(1, "20");
        console.log('ret2', ret1);
        // console.log('ret2', ret2);
        // await hardToken.burn(addr2.address, 5);

        const balance = await hardToken.getCurrentInvest();
        expect(balance).with.lengthOf(2);
    })
})