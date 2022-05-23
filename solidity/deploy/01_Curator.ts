import type { DeployFunction } from "$/hardhat-deploy"
import type { HardhatRuntimeEnvironment } from "hardhat/types"
import { ARTIFACT as PhloteVoteArtifact } from "./00_PhloteVote"


export const ARTIFACT = "Curator"

const deployFunc: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer, tokenOwner, treasury, curatorAdmin } = await hre.getNamedAccounts()

  //const [deployerSigner] = await hre.ethers.getSigners()
  const PhloteVote = await hre.deployments.get(PhloteVoteArtifact)
  const deployArgs = [PhloteVote.address, treasury, curatorAdmin]
  console.log(deployArgs)
  let deploy
  const { catchUnknownSigner } = hre.deployments
  deploy = await hre.deployments.deploy(ARTIFACT, {
    log: true,
    from: deployer,
    contract: ARTIFACT,
    proxy: {
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

  const curator = await hre.ethers.getContractAt(ARTIFACT, deploy.address)
  const vote = await hre.ethers.getContract(PhloteVoteArtifact, deployer)
  const ownerBalance = await vote.balanceOf(deployer)
  console.log(ownerBalance);
  console.log(await vote.MAX_SUPPLY())
  let transferTx = await vote.transfer(ARTIFACT, await vote.MAX_SUPPLY())
  await transferTx.wait()
}

deployFunc.tags = [ARTIFACT]
deployFunc.dependencies = [PhloteVoteArtifact]

export default deployFunc
