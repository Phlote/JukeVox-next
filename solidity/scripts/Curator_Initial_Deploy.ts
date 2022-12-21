import {ethers, upgrades} from "hardhat";
import '@openzeppelin/hardhat-upgrades';

let phloteTokenAddress: any, treasuryAddress: any, curatorAdminAddress:any;

//Ensure you have the correct addresses
phloteTokenAddress = "0x52D2a6Ba271D97fEBC5fd49f5D3a624Fb17F4BF2"
treasuryAddress = "0x941c72afb4B02C2efCB6DDaEdC032Ec15F6ec5f7"
curatorAdminAddress = "0xb60D2E146903852A94271B9A71CF45aa94277eB5"

async function main() {
  const Curator = await ethers.getContractFactory("Curator");
  console.log("deploying Curator proxy...");
  const proxy = await upgrades.deployProxy(Curator,[phloteTokenAddress,treasuryAddress, curatorAdminAddress]);
  await proxy.deployed();

  console.log(`Proxy was deployed to ${proxy.address}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
