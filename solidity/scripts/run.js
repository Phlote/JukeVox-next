const hre = require('hardhat');
async function main() {
  const Greeter = await hre.ethers.getContractFactory('Phlote');
  const phlote = await Greeter.deploy();

  await phlote.deployed();

  let txn = await phlote.getAllsongs();
  console.log('it is successful,', txn);

  console.log('Contract deployed to:', phlote.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
