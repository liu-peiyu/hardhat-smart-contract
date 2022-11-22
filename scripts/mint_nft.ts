require('dotenv').config();

import { ethers } from 'ethers'

// Get Alchemy API Key
const API_KEY = process.env.API_KEY;
const NETWORK = process.env.NETWORK;

// Define an Alchemy Provider
const provider = new ethers.providers.AlchemyProvider(NETWORK, API_KEY);

// Get contract ABI file
const contract = require("../artifacts/contracts/MyNFT.sol/MyNFT.json");

// Create a signer
const privateKey = process.env.PRIVATE_KEY
const signer = new ethers.Wallet(privateKey, provider)

// Get contract ABI and address
const abi = contract.abi
const contractAddress = '0xA4766Ceb9E84a71D282A4CED9fB8Fe93C49b2Ff7'

// Create a contract instance
const myNftContract = new ethers.Contract(contractAddress, abi, signer)

// Get the NFT Metadata IPFS URL
const tokenUri = "https://gateway.pinata.cloud/ipfs/QmWbXSzsRsvDp6zMJ3EaB79deK2tQ4sySpuHsEd8o1XFRW"

// Call mintNFT function
const mintNFT = async () => {
    let nftTxn = await myNftContract.mintNFT(signer.address, tokenUri)
    await nftTxn.wait()
    console.log(`NFT Minted! Check it out at: https://goerli.etherscan.io/tx/${nftTxn.hash}`)
}

mintNFT()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

