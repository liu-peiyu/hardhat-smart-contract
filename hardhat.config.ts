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
      url: "http://127.0.0.1:7545",
      accounts: [
        '0xe8d69ddac1fd89af712ee2df89cdb431985e01182fafcf8964e3ae229638827f', 
        '0x870ae39708a61126178f0bbc9c1ac3c36738285d7df0e657c3315d4e5ca2d19c',
        '0xf6c38467cfd021cf72146afb6b664e902d22bf11678d852d6ab2c677e615eb22']
    },
    goerli: {
      url: API,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  }
};

export default config;
