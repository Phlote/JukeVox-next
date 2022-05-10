import "@nomiclabs/hardhat-ethers"
import "@nomiclabs/hardhat-etherscan"
import "@nomiclabs/hardhat-solhint"
import "@nomiclabs/hardhat-waffle"
import "@typechain/ethers-v5"
import "@typechain/hardhat"
import "dotenv/config"
//import "@openzeppelin/hardhat-upgrades"
//import "hardhat-deploy-ethers"
import "hardhat-contract-sizer"
import "hardhat-deploy"
import "hardhat-gas-reporter"
import { task } from "hardhat/config"
import type { NetworkUserConfig } from "hardhat/types"
import type { HardhatPhloteConfig } from "./src"






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
  const url: string = `https://${network === "mumbai" && "polygon-"}${network}.infura.io/v3/${INFURA_API_KEY}`;
  return {
    accounts: {
      count: 10,
      initialIndex: 0,
      mnemonic: MNEMONIC,
      path: "m/44'/60'/0'/0",
    },
    chainId: chainIds[network] || -1,
    url,
  };
}


// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
const config: HardhatPhloteConfig = {
//const config: HardhatUserConfig = {
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
    mumbai: createTestnetConfig("mumbai")

  },

  namedAccounts: {
    deployer: {
      default: 0,
    },
    tokenOwner: {
      default: 0,
    },
    treasury: {
      default: 2,
    },
    curatorAdmin: {
      default: 3,
    },
    someCurator: {
      default: 4,
    },
    nonCurator: {
      default: 5,
    },
  },

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
    coinmarketcap: process.env.COINMARKET_API_KEY,
    showTimeSpent: true,
    onlyCalledMethods: true,
    excludeContracts: [
      "ERC20Upgradeable",
    ],
    //gasPrice: 100,
    //enabled: process.env.REPORT_GAS ? true : false,
  },

  typechain: {
    outDir: 'typechain',
    target: 'ethers-v5',
    // should overloads with full signatures like deposit(uint256) be generated always, even if there are no overloads?
    alwaysGenerateOverloads: false,
    // optional array of glob patterns with external artifacts to process (for example external libs from node_modules)
    externalArtifacts: ['artifacts/*.json'],
  },
}

export default config
