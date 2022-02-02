const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Greeter', function () {
  it("Should return the new greeting once it's changed", async function () {
    const PhloteContractFactory = await ethers.getContractFactory('Greeter');
    const phlote = await PhloteContractFactory.deploy('Hello, world!');
    await phlote.deployed();

    expect(await phlote.greet()).to.equal('gm!');
  });
});
