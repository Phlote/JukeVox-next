const { ethers } = require("hardhat")
import type { HardhatRuntimeEnvironment } from "hardhat/types"
import type { DeployFunction } from "$/hardhat-deploy"

export const ARTIFACT = "PhloteVote"

const deployFunc: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer, tokenOwner } = await hre.getNamedAccounts()
  const deploy = await hre.deployments.deploy(ARTIFACT, {
    log: true,
    from: deployer,
  })

  const PhloteVote = await ethers.getContractAt(ARTIFACT, deploy.address)
  //const PhloteVote = await hre.ethers.getContract(`${ARTIFACT}`)

  console.log("owner", await PhloteVote.owner())
  console.log(
    "deployer", deployer,
    "balanceOf", (await PhloteVote.balanceOf(await PhloteVote.owner())).toString()
  )
}

deployFunc.tags = [ARTIFACT]

export default deployFunc
