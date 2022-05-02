import type { HardhatRuntimeEnvironment } from "hardhat/types"
import type { DeployFunction } from "$/hardhat-deploy"

import { ARTIFACT as PhloteVoteArtifact } from "./00_PhloteVote"

export const ARTIFACT = "Curator"

const deployFunc: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer, tokenOwner, treasury, curatorAdmin } = await hre.getNamedAccounts()

  //const [deployerSigner] = await hre.ethers.getSigners()
  const PhloteVote = await hre.deployments.get(PhloteVoteArtifact)
  const deployArgs = [PhloteVote.address, treasury, curatorAdmin]
  const deploy = await hre.deployments.deploy(ARTIFACT, {
    log: true,
    from: deployer,
    proxy: {
      proxyContract: "OptimizedTransparentProxy",
      execute: {
        init: {
          methodName: "initialize",
          args: deployArgs,
        },
        onUpgrade: {
          methodName: "onUpgrade",
          args: deployArgs,
        },
      },
    },
  })

  // FIXME: see the next FIXME...
  const Curator = await hre.ethers.getContract(`${ARTIFACT}`)
  //const Curator = await hre.ethers.getContract(`${ARTIFACT}_Implementation`)
  try {
    await Curator.initialize.apply(null, deployArgs)
  } catch (e) {
    await Curator.onUpgrade.apply(null, deployArgs)
  }

  // FIXME: why is it _Implementation here?
  const PhloteVoteContract = await hre.ethers.getContract(`${PhloteVoteArtifact}_Implementation`)
  await PhloteVoteContract.transfer(deploy.address, (await PhloteVoteContract.balanceOf(deployer)))

  //console.log({address, implementation})
}

deployFunc.tags = [ARTIFACT]
deployFunc.dependencies = [PhloteVoteArtifact]

export default deployFunc

