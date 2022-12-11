import { ethers } from "hardhat";

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const weiAmount = (await deployer.getBalance()).toString();

    console.log("Account balance:", (await ethers.utils.formatEther(weiAmount)));

   // make sure to replace the "Buildoooor" reference 
   //with your own ERC-20 name
    const Token = await ethers.getContractFactory("BuildDog");
    const hardhatToken = await Token.deploy();
    await hardhatToken.deployed();

  // log the address of the Contract in our console
    console.log("Token address:", hardhatToken.address);
  }

// run main, catch error, if any, and log in console
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
  });