import type { HardhatRuntimeEnvironment } from "hardhat/types"
import type { DeployFunction } from "$/hardhat-deploy"

export const ARTIFACT = "PhloteVote"

const deployFunc: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer, tokenOwner } = await hre.getNamedAccounts()
  const deploy = hre.deployments.catchUnknownSigner(
    hre.deployments.deploy(ARTIFACT, {
      log: true,
      from: deployer,
      proxy: {
        proxyContract: "OptimizedTransparentProxy",
        execute: {
          init: {
            methodName: "initialize",
            args: [],
          },
          onUpgrade: {
            methodName: "onUpgrade",
            args: [],
          },
        },
      },
    })
  )

  await deploy

  const PhloteVote = await hre.ethers.getContract(`${ARTIFACT}_Implementation`)
  //const PhloteVote = await hre.ethers.getContract(`${ARTIFACT}`)
  try {
    await PhloteVote.initialize()
  } catch (e) {
    await PhloteVote.onUpgrade()
  }

  console.log(await PhloteVote.owner())
  console.log(deployer, (await PhloteVote.balanceOf(await PhloteVote.owner())).toString())
}

deployFunc.tags = [ARTIFACT]

export default deployFunc
