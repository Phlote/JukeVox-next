const { expect } = require("chai");
const { ethers } = require("hardhat");

// describe("Greeter", function () {
//   it("Should return the new greeting once it's changed", async function () {

//     await phlote.deployed();

//     expect(await phlote.greet()).to.equal("gm!");
//   });
// });

async function main() {
  const [deployer] = await ethers.getSigners(); //get the account to deploy the contract
  console.log("Deploying contracts with the account:", deployer.address);
  const PhloteContractFactory = await ethers.getContractFactory("Phlote");
  const deployedContract = await PhloteContractFactory.deploy();

  await deployedContract.deployed(); // waiting for the contract to be deployed

  console.log("FactoryNFT deployed to:", factoryNFT.address); // Returning the contract address on the rinkeby
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
