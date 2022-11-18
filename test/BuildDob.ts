import { expect } from "chai";
import { ethers } from "hardhat";

let Token:any;
let owner:any;
let addr1:any, addr2:any;

let hardToken:any;

beforeEach(async function () {
    Token = await ethers.getContractFactory("BuildDog");
    [owner, addr1, addr2] = await ethers.getSigners();
    console.log(owner.address);
    console.log(addr1.address);
    console.log(addr2.address);
    hardToken = await Token.deploy();
    console.log("Token address:", hardToken.address);
    
  });

describe("Token contract", function(){
    it("Test one", async function () {
        await hardToken.mint(addr1.address, 5);
        // await hardToken.burn(addr2.address, 5);

        const totalBalance = await hardToken.totalSupply();
        const ownerBalance = await hardToken.balanceOf(owner.address);
        console.log(totalBalance, ownerBalance);
        expect(await hardToken.owner()).to.equal(owner.address);
    })

    // it("Test two", async function () {
    //     const ownerBalance = owner.balane;
    //     await hardToken.withdraw();
    //     expect(owner.balance).to.equal(ownerBalance+100);
    // })
})