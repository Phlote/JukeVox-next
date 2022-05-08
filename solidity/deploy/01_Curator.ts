import type { HardhatRuntimeEnvironment } from "hardhat/types"
import type { DeployFunction } from "$/hardhat-deploy"

import { ARTIFACT as PhloteVoteArtifact } from "./00_PhloteVote"

export const ARTIFACT = "Curator"

const deployFunc: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer, tokenOwner, treasury, curatorAdmin } = await hre.getNamedAccounts()

  //const [deployerSigner] = await hre.ethers.getSigners()
  const PhloteVote = await hre.deployments.get(PhloteVoteArtifact, )
  const deployArgs = [PhloteVote.address, treasury, curatorAdmin]
  console.log({ deployArgs })
  let deploy
  const { catchUnknownSigner } = hre.deployments
  deploy = await hre.deployments.deploy(ARTIFACT, {
    log: true,
    from: deployer,
    contract: ARTIFACT,
    proxy: {
      //proxyContract: "OptimizedTransparentProxy",
      //proxyContract: "ERC1967Proxy",
      //proxyArgs: [
        //"{implementation}",
        //"{data}",
        //"test",
      //],
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
      //owner: deployer,
      //proxyArgs: deployArgs,
      //viaAdminContract: "DefaultProxyAdmin",
      //proxyContract: "OpenZeppelinTransparentProxy",
      //methodName: "initialize",
      //viaAdminContract: "DefaultProxyAdmin",
      //execute: {
        //init: {
          //methodName: "initialize",
          //args: deployArgs,
        //},
        //onUpgrade: {
          //methodName: "onUpgrade",
          //args: deployArgs,
        //},
      //},
    },
  })

  console.log(ARTIFACT, "deploy", deploy.address, deploy.transactionHash)

  const curator = await hre.ethers.getContractAt(ARTIFACT, deploy.address)
  const vote = await hre.ethers.getContract(PhloteVoteArtifact, deployer)
  const ownerBalance = await vote.balanceOf(await vote.owner())

  console.log("OLD")
  console.log("vote.owner()", await vote.owner())
  console.log("vote.balanceOf(vote.owner())",
    (await vote.balanceOf(await vote.owner())).toString())
  let transferTx = await vote.transfer(curator.address, ownerBalance)
  await transferTx.wait()
  console.log("NEW")
  console.log("vote.owner()", await vote.owner())
  console.log("vote.balanceOf(vote.owner())",
    (await vote.balanceOf(await vote.owner())).toString())

  //console.log({address, implementation})
}

deployFunc.tags = [ARTIFACT]
deployFunc.dependencies = [PhloteVoteArtifact]

export default deployFunc
