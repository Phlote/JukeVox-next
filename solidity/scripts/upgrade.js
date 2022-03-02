// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const newPhlote = await ethers.getContractFactory("Phlote");
  const phlote = await upgrades.upgradeProxy(
    "0x7504E80CfEC32fa754FFcf866534Dcb3c7c3aF22",
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
