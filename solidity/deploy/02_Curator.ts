import type { HardhatRuntimeEnvironment } from "hardhat/types"
import type { DeployFunction } from "$/hardhat-deploy"

const ARTIFACT = "Curator"

const deployFunc: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer, tokenOwner } = await hre.getNamedAccounts()
  const deploy = hre.deployments.catchUnknownSigner(
    hre.deployments.deploy(ARTIFACT, {
      log: true,
      from: deployer,
      proxy: {
        owner: tokenOwner,
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

  //const { address, implementation } = deploy
  //console.log({address, implementation})
}

deployFunc.tags = [ARTIFACT]

export default deployFunc

