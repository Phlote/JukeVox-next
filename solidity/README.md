# Phlote Protocol Contracts 

## Set up:

1. `npm i`
2. Set up .env with: 
    - `API KEY` for etherscan/Polyscan 
    - `Deployer Key` private key of wallet
    - `API KEY` for infura/alchemy

## To run test suite:

```
npx hardhat test
```

## To deploy curator.sol for the FIRST TIME:

- Before Deploying, please make sure constructor arguments are correct. Arguments `[Phlote Token Address, Treasury Address, Curator Admin Address]` are inside of `Curator_Initial_Deploy.ts`.

```
npx hardhat run scripts/Curator_Deploy.ts --network <Name as written in hardhat.config file>
```
> - Default network is mumbai. If no --network flag is provided, it will use 'mumbai'
> - It will console log the address it was deployed to on completion.


This will deploy an `Implimentation` contract AND `Proxy` contract. The Proxy will be verified by default, however in order to use this proxy we must do 2 things:

1.  Verify `Implementation` contract address. First you will need to get the address from `.openzeppelin/polygon-mumbai.json` under implementation address field. Then run the verify contract command (below) using that address.
2. Once you have verified your implementation address you must go on *Polyscan* and click `is this a proxy?` on the proxy and go through the process in order to verify that its a proxy. Once that is successful, you can see that the proxy holds all the data for the implementation contract. You can use `Read as Proxy` and `Write as Proxy`.

## To verify contract:

```
npx hardhat verify  --network <network name> <contract Address>
```
> - Default network is mumbai. If no --network flag is provided, it will use 'mumbai'


## To upgrade contract:

1. Write new contract, by following upgradable standards. Once complete, name it `CuratorV(current Version++)` ex.`CuratorV2`
2. When contract is ready for upgrade, update `Curator_Upgrade_Script.ts` with the correct curator contract name ex.`CuratorV2`
3. When ready run upgrade script using:
    - `npx hardhat run scripts/Curator_Upgrade_Script.ts --network <Name as written in hardhat.config file>`
4. Now your Proxy should be updated with the new implementation address. However, you must also verify implementation address now after the new deploy by running:
    - `npx hardhat verify  --network <network name> <new implementation contract Address>`
5. You will now be able to see the proxy displaying the info of the new contract.

> Keep in mind... Currently the Openzepplin hardhat plugin seems to be broken for initializing again after upgrade. So you cannot run initializer again after deploy. Instead you will need a function to modify the new updates you'd like to do (in case the values are modified in initializer). Waiting on this fix.