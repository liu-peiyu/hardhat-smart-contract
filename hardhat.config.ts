import { HardhatUserConfig } from "hardhat/config";
// 此句不能删除，会影响部署文件的ethers
require("@nomiclabs/hardhat-waffle");

require('dotenv').config()

const { API, PRIVATE_KEY, NETWORK } = process.env

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const config: HardhatUserConfig = {
  solidity: "0.8.17",
  defaultNetwork: "localhost",
  paths: {
    sources: "contracts"
  },
  networks: {
    localhost:{
      url: "http://127.0.0.1:8545",
      accounts: [`0x${PRIVATE_KEY}`]
    },
    goerli: {
      url: API,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  }
};

export default config;
