import {ethers, upgrades} from "hardhat"
import '@openzeppelin/hardhat-upgrades';

async function main() {
  const CuratorV2 = await ethers.getContractFactory("CuratorV2");
  console.log("upgrading...")
  const curatorV2 = await upgrades.upgradeProxy("0xE17d0bB623F16EE9424B5Be5b649Af2E155A27d9", CuratorV2);
  console.log(`curator has been upgraded!`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  