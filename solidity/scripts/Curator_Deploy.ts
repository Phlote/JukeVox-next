import {ethers, upgrades} from "hardhat";
import '@openzeppelin/hardhat-upgrades';

let phloteTokenAddress: any, treasuryAddress: any, curatorAdminAddress:any, curator:any;

//Ensure you have the correct addresses
phloteTokenAddress = "0x50281Df3EADA2bC85E72A488CFbbC8e38fef8aC7"
treasuryAddress = "0x941c72afb4B02C2efCB6DDaEdC032Ec15F6ec5f7"
curatorAdminAddress = "0xb60D2E146903852A94271B9A71CF45aa94277eB5"

async function main() {
  const Curator = await ethers.getContractFactory("Curator");
  console.log("deploying Curator...");
  const curator = await Curator.deploy(phloteTokenAddress,treasuryAddress, curatorAdminAddress);

  await curator.deployed();

  console.log(`curator was deployed to ${curator.address}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
