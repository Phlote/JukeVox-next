const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const PhloteContractFactory = await ethers.getContractFactory("Phlote");
  const contract = await PhloteContractFactory.deploy();
  console.log("Token address:", contract.address);

  await contract.deployed();

  console.log("Successfully deployed");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
