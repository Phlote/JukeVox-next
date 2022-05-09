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
}

deployFunc.tags = [ARTIFACT]

export default deployFunc
