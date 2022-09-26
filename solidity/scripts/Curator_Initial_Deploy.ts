




import {ethers, upgrades} from "hardhat"
import '@openzeppelin/hardhat-upgrades';

let phloteTokenAddress: any, treasuryAddress: any, curatorAdminAddress:any;

//Ensure you have the correct addresses
phloteTokenAddress = "0xb60D2E146903852A94271B9A71CF45aa94277eB5"
treasuryAddress = "0x56ceF7b74CC7121bb88C6D9b469819B5D32c9B22"
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
