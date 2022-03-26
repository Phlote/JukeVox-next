import { task } from "hardhat/config"

import { config as dotenvConfig } from "dotenv"
import { resolve } from "path"
dotenvConfig({ path: resolve(__dirname, "./.env") })

import { NetworkUserConfig } from "hardhat/types"
import { HardhatPhloteConfig } from "./src"

import "@typechain/hardhat"
import "@nomiclabs/hardhat-ethers"
import "@nomiclabs/hardhat-waffle"
import "@openzeppelin/hardhat-upgrades"
import "@nomiclabs/hardhat-solhint"
import "@nomiclabs/hardhat-etherscan"
import "hardhat-contract-sizer"
import "hardhat-gas-reporter"


const chainIds = {
  ganache: 1337,
  goerli:  5,
  hardhat: 31337,
  kovan:   42,
  mainnet: 1,
  rinkeby: 4,
  ropsten: 3,
  matic:   137,
  mumbai:  80001,
}

const MNEMONIC          = process.env.MNEMONIC          || "";
const DEFAULT_NETWORK   = process.env.NETWORK_NAME      || "hardhat";
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "";
const INFURA_API_KEY    = process.env.INFURA_API_KEY    || "";


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (_, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(await account.getAddress());
  }
});

function createTestnetConfig(network: keyof typeof chainIds): NetworkUserConfig {
  const url: string = `https://${network}.infura.io/v3/${INFURA_API_KEY}`;
  return {
    accounts: {
      count: 10,
      initialIndex: 0,
      mnemonic: MNEMONIC,
      path: "m/44'/60'/0'/0",
    },
    chainId: chainIds[network],
    url,
  };
}


// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
const config: HardhatPhloteConfig = {
  defaultNetwork: DEFAULT_NETWORK,

  networks: {
    hardhat: {
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: chainIds.hardhat,
    },
    mainnet: createTestnetConfig("mainnet"),
    goerli:  createTestnetConfig("goerli"),
    kovan:   createTestnetConfig("kovan"),
    rinkeby: createTestnetConfig("rinkeby"),
    ropsten: createTestnetConfig("ropsten"),
  },

  solidity: {
    compilers: [
      {
        version: "0.8.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: '0.8.2',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },

  contractSizer: {
    alphaSort: true,
    runOnCompile: false,
    disambiguatePaths: false,
    strict: true,
  },

  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },

  gasReporter: {
    // INFO: https://www.npmjs.com/package/hardhat-gas-reporter
    currency: "USD",
    gasPrice: 100,
    // enabled: process.env.REPORT_GAS ? true : false,
  },

  typechain: {
    outDir: 'types',
    target: 'ethers-v5',
    // should overloads with full signatures like deposit(uint256) be generated always, even if there are no overloads?
    alwaysGenerateOverloads: false,
    // optional array of glob patterns with external artifacts to process (for example external libs from node_modules)
    externalArtifacts: ['artifacts/*.json'],
  },
}

export default config
