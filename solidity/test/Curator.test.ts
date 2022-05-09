import { ethers, deployments, getChainId, getNamedAccounts } from "hardhat"
import { use, expect } from "chai"
import { solidity, deployContract, createFixtureLoader } from "ethereum-waffle"

import { Wallet, Contract } from "ethers"
import type { ContractReceipt } from "ethers"

import { PhloteVote, Curator, Hotdrop } from "../typechain"

import { ARTIFACT as PhloteVoteArtifact } from "../deploy/00_PhloteVote"
import { ARTIFACT as CuratorArtifact } from "../deploy/01_Curator"
import { beforeEach } from "mocha"

use(solidity)

const { BigNumber } = ethers


// TODO: we need this:
// https://ethereum-waffle.readthedocs.io/en/latest/fixtures.html?highlight=wallet#fixtures

describe("Phlote.xyz: Curator.sol", async () => {
  let curator: Curator
  let curatorAsAdmin: Curator
  let curatorAsCurator: Curator
  let curatorAsNonCurator: Curator
  let vote: PhloteVote
  let chainId: string
  let deployer: string, curatorAdmin: string, someCurator: string, nonCurator: string
  let drop: Hotdrop

  type EventArg = string | undefined

  // quick fix to let gas reporter fetch data from gas station & coinmarketcap
  //before((done) => {
    //setTimeout(done, 2000);
  //});

  async function newHotdrop(curatorContract: Curator, _ipfsURI: string) {
    let tx
    tx = await curatorContract.submit(_ipfsURI)
    tx = await tx.wait() as ContractReceipt
    if (tx.events === undefined || tx.events.length < 2) { throw new Error("no events") }
    let eventArgs = tx.events[1].args as [EventArg, EventArg, EventArg]
    const [_1, _2, hotdrop] = eventArgs
    const _drop = await ethers.getContractAt("Hotdrop", hotdrop as string)
    return _drop as Hotdrop
  }

  before(async () => {
    await deployments.fixture([PhloteVoteArtifact, CuratorArtifact])
    ;({ deployer, curatorAdmin, someCurator, nonCurator } = await getNamedAccounts())
    chainId = await getChainId()
    curator             = await ethers.getContract(CuratorArtifact, deployer)
    curatorAsAdmin      = await ethers.getContract(CuratorArtifact, curatorAdmin)
    curatorAsCurator    = await ethers.getContract(CuratorArtifact, someCurator)
    curatorAsNonCurator = await ethers.getContract(CuratorArtifact, nonCurator)
    vote = await ethers.getContract(PhloteVoteArtifact, deployer)
  })

  beforeEach(async () => {
    let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
    const _nonCurator = (await getNamedAccounts()).nonCurator
    const curatorAsNormie = await ethers.getContract(CuratorArtifact, _nonCurator)
    drop = await newHotdrop(curatorAsNormie as Curator, _ipfsURI)
    expect(drop).to.not.be.null
    expect(drop).to.not.be.undefined
    expect(drop.address).to.be.properAddress
  })

  it("Should deploy Curator.sol", async () => {
    expect(curator.address).to.be.properAddress
    expect(await curator.admin()).to.be.properAddress
    expect(await curator.admin()).to.equal(deployer)
  })

  it("Should have transferred balanceOf(MAX_SUPPLY) Phlote Vote tokens from deployer to Curator", async () => {
    const deployerBalance = await vote.balanceOf(deployer)
    expect(deployerBalance).to.equal(0)
    const curatorBalance = await vote.balanceOf(curator.address)
    expect(await vote.MAX_SUPPLY()).to.equal(curatorBalance)
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
    if (tx.events === undefined || tx.events.length < 2) {
      throw new Error("no event")
    }
    let eventArgs = tx.events[1].args as [EventArg, EventArg, EventArg]
    const [submitter, ipfsURI, hotdrop] = eventArgs
    expect(hotdrop).to.be.properAddress
    drop = await ethers.getContractAt("Hotdrop", hotdrop as string)
    expect(submitter).to.be.properAddress
    expect(submitter).to.equal(deployer)
    expect(ipfsURI).to.equal(_ipfsURI)
  })

  it("Should allow curatorAdmins to assign new curators", async () => {
    // TODO
    let tx
    const _curator = curatorAsAdmin
    await expect(tx = _curator.grantCuratorRole(someCurator))
      .to
      .emit(_curator, 'RoleGranted')
      .withArgs(await _curator.CURATOR(), someCurator, curatorAdmin)
    tx = (await (await tx).wait()) as ContractReceipt
    expect(tx.confirmations).to.be.gte(1)
  })

  it("Should allow curators to cosign submissions", async () => {
    // TODO
    const _curator = curatorAsCurator
    const cosigns = await drop.cosigns()

    let tx
    await expect(tx = _curator.curate(drop.address))
      .to
      .emit(curator, 'Phlote')
      .withArgs(someCurator, drop.address, cosigns.add(1))
    tx = (await (await tx).wait()) as ContractReceipt
    expect(tx.confirmations).to.be.gte(1)
  })

  it("Should DISallow NON-curators to cosign submissions", async () => {
    const _curator = curatorAsNonCurator
    let tx
    await expect(tx = _curator.curate(drop.address))
      .to.be.reverted
  })

  it("Should pay the submitter Phlote Vote tokens on 'submission cosigned'", async () => {
    const _curator = curatorAsCurator
    const submitter = await drop.submitter()
    expect(submitter).to.be.properAddress
    expect(submitter).to.equal(nonCurator)

    const reward = await drop.COSIGN_REWARD()
    const oldBalance = await vote.balanceOf(nonCurator)

    let tx
    await expect(tx = _curator.curate(drop.address))
      .to
      .emit(_curator, 'Phlote')
    tx = (await (await tx).wait()) as ContractReceipt
    expect(tx.confirmations).to.be.gte(1)

    const newBalance = await vote.balanceOf(nonCurator)
    expect(newBalance).to.equal(oldBalance.add(reward))
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
