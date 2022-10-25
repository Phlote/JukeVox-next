import { ethers } from "hardhat";
import { expect } from "chai";
import hre from "hardhat";
import { deploy } from "@openzeppelin/hardhat-upgrades/dist/utils";

describe("Contracts: ", function () {
    let deployer: any, user1: any, user2 : any, user3:any, user4:any, user5:any, user6:any, treasury:any;
    let phloteVote: any;
    let curator:any;
    let drop: any;
    let usersArr: Array<any>;
    let phlote_MAX_SUPPLY = 14000000000000000000;

    //change these when changing the contract!!!
    //Contract configs:
    let mintCosts = [50,60,70,80,90]
    let cosignReward = 15;

    //create hotdrop with given input
    async function newHotdrop(curatorContract: any, _user:any, _ipfsURI: string, _isArtist: boolean) {
        let tx
        tx = await curator.connect(_user).submit(_ipfsURI,_isArtist);
        const result = await tx.wait();
        const [submitter,ipfsURI,_isArtistSubmission,hotdrop] = result.events[1].args
        return hotdrop
    }

    //deployer will always be approved, enter the other ids you want to approve
    //if you only want deployer to be approved, send empty array input
    async function approveSignersTokens(ids: Array<number>){
        await phloteVote.approve(curator.address, 1000);
        if(ids.length> usersArr.length){
            return "your array of signers has > length than actual number of users in usersArr";
        }
        for(let i = 0; i<ids.length;i++){
            const userToApprove = usersArr[ids[i]];
            await phloteVote.connect(userToApprove).approve(curator.address, 1000);
        }
    }

    //This will not curate for deployer, you must curate manually
    async function curateSigners(ids: Array<number>,drop:any){
        if(ids.length> usersArr.length){
            return "your array of signers has > length than actual number of users in usersArr";
        }
        for(let i = 0; i<ids.length;i++){
            const userToApprove = usersArr[ids[i]];
            await curator.connect(userToApprove).curate(drop)
        }
    }
    

    before(async function () {
        [deployer, user1, user2, user3, user4, user5,user6, treasury] = await hre.ethers.getSigners();
        usersArr = [user1, user2, user3, user4, user5, user6]
    });

    beforeEach(async function () {
        let amountToMint = 1400000;
        const PhloteVote = await hre.ethers.getContractFactory("PhloteVote");
        phloteVote = await PhloteVote.deploy(amountToMint);
        await phloteVote.deployed();
        //disperse tokens to all 5 users
        for(let i = 0;i<usersArr.length;i++){
            const userToApprove = usersArr[i];
            await phloteVote.transfer(userToApprove.address,1000)
        }

    
        

        const Curator = await hre.ethers.getContractFactory("Curator");
        curator = await Curator.deploy();
        await curator.deployed();
        await curator.initialize(phloteVote.address,treasury.address,deployer.address)

        await phloteVote.transfer(treasury.address,1000)
        await phloteVote.connect(treasury).approve(curator.address, 1000);

        await phloteVote.setAdmin(curator.address);
    });

    it("deploys PhloteVote & Curate",async function(){
        expect(phloteVote.address).to.not.equal('null');
        expect(curator.address).to.not.equal('null');
        expect(await curator.treasury()).to.eq(treasury.address);
        expect(await curator.phloteToken()).to.eq(phloteVote.address)
    })

    describe("Hotdrop.sol",async function(){
        it.only("check artist NFT is minted", async function(){
            let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
            let ArtistSubmission = false
            drop = await newHotdrop(curator, deployer, _ipfsURI,ArtistSubmission)
            const _drop = await ethers.getContractAt("Hotdrop", drop as string)
            expect(await _drop.totalSupply(2)).to.eq(1)
        })

        it("Anyone can submit a hotdrop (artist + curator)", async function(){
            const artistURI= "www.aws.ca/urlOfHotDropArtist"
            const ArtistSubmission = true
            
            curator.on('Submit', (submitted:any, ipfsURI:any, _isArtistSubmission:any,hotdrop:any) => {
                console.log(hotdrop);
            });

            let hotdrop1 = await curator.submit(artistURI,ArtistSubmission);
            
            const result = await hotdrop1.wait();
            const [submitter,ipfsURI,_isArtistSubmission,hotdrop] = result.events[1].args
            expect(submitter).to.eq(deployer.address)
            expect(ipfsURI).to.eq(artistURI)
            expect(_isArtistSubmission).to.eq(ArtistSubmission)
            
            //now test hotdrop was created properly
            var hotdropContract = await ethers.getContractAt("Hotdrop",hotdrop,deployer);
            let [submitterofHotdrop,_isArtistSubmissionofHotdrop,cosignersofHotdrop] = await hotdropContract.submissionDetails();
            expect(submitterofHotdrop).to.eq(submitter);
            expect(_isArtistSubmission).to.eq(ArtistSubmission);
            let allEqual = true;
            cosignersofHotdrop.forEach((element: string) => {
                if(element != '0x0000000000000000000000000000000000000000'){
                    allEqual = false;
                }
            });
            expect(allEqual).to.eq(true);
        })
    })

    describe("Curator.sol", async function(){
        it("check pausability", async function(){
            await curator.pause();
            const artistURI= "www.aws.ca/urlOfHotDropArtist"
            const ArtistSubmission = true
            await expect(curator.submit(artistURI,ArtistSubmission)).to.be.rejectedWith('Pausable: paused');
            await expect(curator.curate("0x0000000000000000000000000000000000000000")).to.be.rejectedWith('Pausable: paused');
            await curator.unpause();
            expect(await curator.submit(artistURI,ArtistSubmission));
        })

        it("should fails if you dont have curatorMinimumToken",async function(){
            let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
            let ArtistSubmission = true
            await curator.setCuratorTokenMinimum(1001);
            drop = await newHotdrop(curator, user1, _ipfsURI,ArtistSubmission)
            await expect(curator.connect(user2).curate(drop)).to.be.revertedWith('Your Phlote balance is too low.')        
        })

        it("should fail if submitter of hotdrop attempts to cosign their own record",async function(){
            let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
            let ArtistSubmission = true
            const hotdrop = await newHotdrop(curator, user1, _ipfsURI,ArtistSubmission)
            const _drop = await ethers.getContractAt("Hotdrop", hotdrop as string)
            const [submitterAddress, submissionIsArtistSubmission,submissionCosigners] = await _drop.submissionDetails()
            await expect(curator.connect(user1).curate(drop)).to.be.revertedWith("You cannot vote for your own track");
        })


        it("should not be able to double cosign a record",async function(){
            let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
            let ArtistSubmission = true
            drop = await newHotdrop(curator, user1, _ipfsURI,ArtistSubmission)
            //increase allowance
            await approveSignersTokens([1])
            await curator.connect(user2).curate(drop);
            await expect(curator.connect(user2).curate(drop)).to.be.revertedWith("You have already cosigned the following record");
        })

        it("should fail if reached maximum record",async function(){
            let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
            let ArtistSubmission = true
            drop = await newHotdrop(curator, user1, _ipfsURI,ArtistSubmission)
            //increase allowance
            await approveSignersTokens([0,1,2,3,4])
            await curator.curate(drop);
            await curateSigners([1,2,3,4],drop)
            await expect(curator.connect(user6).curate(drop)).to.be.revertedWith("Sorry! We have reached the maximum cosigns on this record.");
        })

        it("should emit Cosign event for each cosign",async function(){
            let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
            let ArtistSubmission = true
            let _drop = await newHotdrop(curator, deployer, _ipfsURI,ArtistSubmission)
            await approveSignersTokens([0,1,2,3,4,5])
            for(let i = 0;i<5;i++){
                await expect(curator.connect(usersArr[i]).curate(_drop)).to.emit(curator, "Cosign").withArgs(usersArr[i].address, _drop,i+1);
            }
        })

        it("should allow cosigning of Artist submission:", async function(){
            let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
            let ArtistSubmission = true
            drop = await newHotdrop(curator, deployer, _ipfsURI,ArtistSubmission)
            const _drop = await ethers.getContractAt("Hotdrop", drop as string)
            await approveSignersTokens([0,1,2,3,4,5])
            //submitter of the hotdrop:
            const artistAddress = deployer.address;
            
            // Check each cosign for:
            /*
            1- right amount is deducted from cosigner
            2- right amount is going to the artist
            3- correct amount is minted to treasury from PhloteVote
            4- NFT is minted and cosigner owns it:
                - balance of each address is correct
                - total supply correct
            */
            for(let i = 0;i<5;i++){
                let artistPrevBalance = await phloteVote.balanceOf(artistAddress);
                let treasuryPrevBalance = await phloteVote.balanceOf(treasury.address);
                let PhloteVotePrevSupply = await phloteVote.totalSupply();
                const prevBalance = await phloteVote.balanceOf(usersArr[i].address);
                await curateSigners([i],drop);
                expect(await phloteVote.balanceOf(usersArr[i].address)).to.eq(prevBalance - mintCosts[i]);
                expect(await phloteVote.balanceOf(artistAddress)).to.eq(artistPrevBalance.add(mintCosts[i] - cosignReward));
                expect(await phloteVote.balanceOf(treasury.address)).to.eq(treasuryPrevBalance.add(cosignReward));
                expect(await phloteVote.totalSupply()).to.eq(PhloteVotePrevSupply.add(mintCosts[i]));
                expect(await _drop.balanceOf(usersArr[i].address,0)).to.eq(1);
                expect(await _drop.totalSupply(0)).to.eq(i+1);
            }
            //should fail here, just extra check
            await expect(curator.connect(user6).curate(drop)).to.be.revertedWith("Sorry! We have reached the maximum cosigns on this record.");

        })

        it("should allow cosigning of Curator submission:", async function(){
            let _ipfsURI = "ipfs://QmTz1aAoS6MXfHpGZpJ9YAGH5wrDsAteN8UHmkHMxVoNJk/1337.json"
            let ArtistSubmission = false
            drop = await newHotdrop(curator, deployer, _ipfsURI,ArtistSubmission)
            const _drop = await ethers.getContractAt("Hotdrop", drop as string)
            await approveSignersTokens([0,1,2,3,4,5])
            //submitter of the hotdrop:
            const curatorAddress = deployer.address;
            let cosignersListBalances=[0,0,0,0,0];
            
            // Check each cosign for:
            /*
            1- right amount is transfered to original submitter
            2- right amount is going to the previous cosigners
            3- correct amount is minted to treasury from PhloteVote
            4- NFT is minted and cosigner owns it:
                - balance of each address is correct
                - total supply correct
            */
            for(let i = 0;i<5;i++){
                const [hotdropSubmitter, _isArtistSubmission, cosignersList] = await _drop.submissionDetails()
                let curatorPrevBalance = await phloteVote.balanceOf(curatorAddress);
                let PhloteVotePrevSupply = await phloteVote.totalSupply();
                
                // get balances of each address before each new cosign, so we can compare balances to it after cosign
                for(let numberOfCosigner = 0; numberOfCosigner<=i; numberOfCosigner++){
                    cosignersListBalances[numberOfCosigner] =  (await phloteVote.balanceOf(usersArr[numberOfCosigner].address)).toNumber();
                }
                
                await curateSigners([i],drop);
                
                //insure original submitter of hotdrop is recieving their reward on each cosign
                expect(await phloteVote.balanceOf(curatorAddress)).to.eq(curatorPrevBalance.add(cosignReward));
                //insure correct amount is minted from phloteVote on each cosign (cosignReward * (i + 1))
                // Because on cosign where i = 0: -15 (reward to submitter), i = 1: -15 (reward to submitter) + -15 (reward to previous cosigner) etc... 
                expect(await phloteVote.totalSupply()).to.eq(PhloteVotePrevSupply.add(cosignReward * (i + 1)));
                
                // check tokens were distributed to previous cosigners and NOT current cosigner, check from end to beginning 
                for(let j = i; j<0; j--){
                    const balance = cosignersListBalances[j]
                   expect(await phloteVote.balanceOf(cosignersList[j])).to.eq(balance + (cosignReward * (j + 1)));
                }
                if(i != 0){
                    // check that current cosigner balance was never changed, and hasnt been set in our array (aka unchanged still)
                    expect(await phloteVote.balanceOf(cosignersList[i])).to.eq(0);
                }
               
                //Check cosignerNFT which is ID = 1, exists
                expect(await _drop.balanceOf(usersArr[i].address,1)).to.eq(1);
                expect(await _drop.totalSupply(1)).to.eq(i+1);
            }
            //should fail here, just extra check
            await expect(curator.connect(user6).curate(drop)).to.be.revertedWith("Sorry! We have reached the maximum cosigns on this record.");

        })
    })

    describe("PhloteVote.sol", async function(){
        it("should only allow minting until max supply and fail to mint more", async function(){
            const currSupply = await phloteVote.totalSupply()
            await phloteVote.setMAXSUPPLY(currSupply.add(1000))
            await phloteVote.mint(deployer.address, currSupply.add(1000))
            expect(await phloteVote.MAX_SUPPLY()).to.eq(await phloteVote.totalSupply())
            await expect(phloteVote.mint(deployer.address, currSupply.add(1000))).to.be.revertedWith("You have reached your maximum Supply for mint")
        })

        it("should mint the difference between max supply and mint amount if greater than max_Supply and stop there",async function(){
            const currSupply = await phloteVote.totalSupply()
            await phloteVote.setMAXSUPPLY(currSupply.add(1000))
            await phloteVote.mint(deployer.address, currSupply.add(100000))
            expect(await phloteVote.MAX_SUPPLY()).to.eq(await phloteVote.totalSupply())
            await expect(phloteVote.mint(deployer.address, currSupply.add(1000))).to.be.revertedWith("You have reached your maximum Supply for mint")
        })

    })
})

