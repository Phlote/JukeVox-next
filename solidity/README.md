# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```bash
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

## How to upload the source and verify on etherscan.io
```bash
npm run deploy-notupgradeable:rinkeby
# copy the deployed contract address from the terminal to your clipboard with your mouse
export DEPLOYED_CONTRACT_ADDRESS=$(pbpaste) # <-- stick it in a variable
# change ./deploy/Phlote.sol.constructor-args.js to match the deploy
vim ./deploy/Phlote.sol.constructor-args.js
# prove to etherscan that we know EXACTLY how this contract got deployed
npm run verify:rinkeby ./deploy/Phlote.sol.constructor-args.js "$DEPLOYED_CONTRACT_ADDRESS"
```

# Phlote Smart Contract Development

We are currently using the [hardhat](https://hardhat.org/) to deploy our solidity code. You will need the Alchemy API key (ping @Andrewjeska if you need Alchemy access) and you need your wallet's private key. Deployments cost gas, so you will need to get some rinkeby ETH, which can be obtained [here](https://faucets.chain.link/rinkeby). We advise making a seperate wallet apart from your personal wallet

`npm run deploy:rinkeby` will deploy an upgradable contract. You should make one for each PR you're writing, so you don't override the production contract. The deploy script will run and give you a live contract address on the rinkeby network. Copy that, then in your `/solidity/.env` set the `RINKEBY_CONTRACT_ADDRESS` variable to that new contract address. Afterwards, `npm run upgrade:rinkeby` should upgrade that contract so you don't have to redeploy for every small change.
