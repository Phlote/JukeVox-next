import { HardhatUserConfig } from "hardhat/config";
import '@nomicfoundation/hardhat-toolbox';
import "@nomiclabs/hardhat-ethers";
import "chai"
import '@nomiclabs/hardhat-etherscan'
import '@typechain/hardhat'
require("dotenv").config();
import '@openzeppelin/hardhat-upgrades';


let DEPLOYER_KEY: string
if (process.env.DEPLOYER_KEY) {
  DEPLOYER_KEY = process.env.DEPLOYER_KEY
} else {
  throw new Error("DEPLOYER_KEY environment variable is not set")
}


const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.9",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  gasReporter: {
    enabled: true,
    coinmarketcap: "2bd639b0-ef37-4768-8aa5-b1f6dd6ed437",
    currency: "USD",
  },
  networks: {
      goerli: {
        url: `https://eth-goerli.g.alchemy.com/v2/${process.env.ALCHEMY_GOERLI_APIKEY}`,
        accounts: [DEPLOYER_KEY],
      },
      mumbai: {
        url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.ALCHEMY_APIKEY}`,
        accounts: [DEPLOYER_KEY],
      },
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY,
  },

};

export default config;


