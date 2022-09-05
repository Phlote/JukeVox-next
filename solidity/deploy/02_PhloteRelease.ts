import { ethers } from "hardhat";


//These are test inputs, will need to allow this script to take arguments in order to autoamte the deployment process
async function main() {
  let cosignersList = ["0x883A368A32e8763427Aa86FFa85ED9f24d654085","0xA67d77830A1274948e38e0c9a646D96F16bF492D","0x71947E53F4d4d4F1eeF64Dd360EF60A725E5373C","0x941c72afb4B02C2efCB6DDaEdC032Ec15F6ec5f7","0xbc74E5a0d8b06184Faa100bC4a30568d72615890"]
  const artistAddress = "0xc68FDD7fEdF3e45Efbc97096BDBaEEA92540B3A4";

  const PhloteRelease = await ethers.getContractFactory("PhloteRelease");
  const phloteRelease = await PhloteRelease.deploy(artistAddress, cosignersList);
  await phloteRelease.deployed();

  console.log("Transaction successful!");
  console.log("PhloteRelease deployed to:", phloteRelease.address);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });