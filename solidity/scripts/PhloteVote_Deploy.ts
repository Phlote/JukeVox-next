import { ethers } from "hardhat";

async function main() {

  const PhloteVote = await ethers.getContractFactory("PhloteVote");
  const phloteVote = await PhloteVote.deploy(1500000000000n);

  await phloteVote.deployed();

  console.log(`PhloteVote was deployed to ${phloteVote.address}`);
}

/*
* Next please make sure to PhloteVote.setAdmin(curator Address)
*/


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});