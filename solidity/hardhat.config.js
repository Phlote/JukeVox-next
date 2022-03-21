require("dotenv").config();
require('@typechain/hardhat')
require('@nomiclabs/hardhat-ethers')
require('@nomiclabs/hardhat-waffle')
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-solhint");
require("hardhat-contract-sizer");

module.exports = {
  solidity: {
    version: '0.8.4',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
    contractSizer: {
      alphaSort: true,
      runOnCompile: true,
      disambiguatePaths: false,
    },
  },
  networks: {
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [`${process.env.RINKEBY_PRIVATE_KEY}`],
    },
  },
  typechain: {
    outDir: 'types',
    target: 'ethers-v5',
    // should overloads with full signatures like deposit(uint256) be generated always, even if there are no overloads?
    alwaysGenerateOverloads: false,
    // optional array of glob patterns with external artifacts to process (for example external libs from node_modules)
    externalArtifacts: ['artifacts/*.json'],
  },
};
