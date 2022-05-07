import { ethers, deployments, getChainId, getNamedAccounts } from "hardhat"
import { use, expect } from "chai"
import { solidity } from "ethereum-waffle"

import type { ContractReceipt } from "ethers"

import type { Curator } from "../typechain/Curator"
import type { PhloteVote } from "../typechain/PhloteVote"

import { ARTIFACT as PhloteVoteArtifact } from "../deploy/00_PhloteVote"
import { ARTIFACT as CuratorArtifact } from "../deploy/01_Curator"

use(solidity)

const { BigNumber } = ethers

describe("Phlote.xyz: Curator.sol", async () => {
  let curator: Curator
  let curatorAsAdmin: Curator
  let curatorAsCurator: Curator
  let curatorAsNonCurator: Curator
  let vote: PhloteVote
  let chainId: string
  let deployer: string, curatorAdmin: string, someCurator: string, nonCurator: string

  // quick fix to let gas reporter fetch data from gas station & coinmarketcap
  //before((done) => {
    //setTimeout(done, 2000);
  //});

  it("Should deploy Curator.sol", async () => {
    await deployments.fixture([PhloteVoteArtifact, CuratorArtifact])
    ;({ deployer, curatorAdmin, someCurator, nonCurator } = await getNamedAccounts())
    chainId = await getChainId()
    curator = await ethers.getContract(CuratorArtifact, deployer)
    curatorAsAdmin = await ethers.getContract(CuratorArtifact, deployer)
    curator = await ethers.getContract(CuratorArtifact, deployer)
    vote = await ethers.getContract(PhloteVoteArtifact, deployer)
  })

  it("Should transfer balanceOf(MAX_SUPPLY) Phlote Vote tokens from deployer to Curator", async () => {
    const maxSupply = await vote.MAX_SUPPLY()
    const deployerBalance = await vote.balanceOf(deployer)
    expect(maxSupply).to.equal(deployerBalance)

    let tx = await vote.transfer(curator.address, await vote.balanceOf(deployer))
    await tx.wait()
    const curatorBalance = await vote.balanceOf(curator.address)
    expect(maxSupply).to.equal(curatorBalance)
  })

  it("Should allow anyone to submit for curation", async () => {
    // TODO
    let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
    let tx
    await expect(tx = curator.submit(_ipfsURI))
      .to
      .emit(curator, 'Submit')
    tx = (await (await tx).wait()) as ContractReceipt
    expect(tx.confirmations).to.be.gte(1)
    type EventArg = string | undefined
    let eventArgs: EventArg[3] = tx.events[1].args
    const [submitter, ipfsURI, hotdrop] = eventArgs
    expect(hotdrop).to.be.properAddress
    expect(submitter).to.be.properAddress
    expect(submitter).to.equal(deployer)
    expect(ipfsURI).to.equal(_ipfsURI)
  })

  it("Should allow curators to cosign submissions", async () => {
    // TODO
    expect(undefined).to.equal(null)
  })

  it("Should DISallow NON-curators to cosign submissions", async () => {
    // TODO
    expect(undefined).to.equal(null)
  })

  it("Should pay the submitter Phlote Vote tokens on 'submission cosigned'", async () => {
    // TODO
    expect(undefined).to.equal(null)
  })

  it("Should pay any previous cosigners Phlote Vote tokens on 'submission cosigned'", async () => {
    // TODO
    expect(undefined).to.equal(null)
  })

  it("Should pay the community treasury Phlote Vote tokens on 'submission cosigned'", async () => {
    // TODO
    expect(undefined).to.equal(null)
  })
})
