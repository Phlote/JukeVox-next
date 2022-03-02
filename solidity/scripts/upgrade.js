// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const newPhlote = await ethers.getContractFactory("Phlote");
  const phlote = await upgrades.upgradeProxy(
    process.env.RINKEBY_CONTRACT_ADDRESS,
    newPhlote
  );
  console.log("Phlote upgraded");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
