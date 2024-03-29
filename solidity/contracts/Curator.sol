// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/security/Pausable.sol";

import "@openzeppelin/contracts/interfaces/IERC1155.sol";

import "@openzeppelin/contracts/interfaces/IERC20.sol";


import "./PhloteVote.sol";
import "./Hotdrop.sol";

import "hardhat/console.sol";

/// @title A factor and manager for "Hotdrop" NFTs (Phlote user-submitted-content).
/// @author Zachary Fogg <me@zfo.gg>
/// @notice This contract's events should be indexed for use by front-ends.
/// @dev Please check the tests for this contract when making changes!
/// @custom:security-contact nohackplz@phlote.xyz
contract Curator is Pausable {

    address public admin;

    PhloteVote public phloteToken;
    address public treasury;
    uint256 public curatorTokenMinimum;

    address public curatorAdmin;

    event Submit(
        address indexed submitter,
        string ipfsURI,
        bool _isArtistSubmission,
        Hotdrop hotdrop
    );

    event Cosign(
        address indexed cosigner,
        Hotdrop hotdrop,
        uint256 cosignEdition
    );


    modifier onlyOwner() {
        require(msg.sender == admin, "You do not have access to this function.");
        _;
    }

    /// @dev The constructor function.
    /// @param _phloteToken Phlote's ERC20 DAO token.
    constructor(PhloteVote _phloteToken, address _treasury, address _curatorAdmin) public {
        admin = msg.sender;
        curatorTokenMinimum = 50000000000000000000;
        
        phloteToken = _phloteToken;
        treasury = _treasury;
        curatorAdmin = _curatorAdmin;
    }


    /// @dev To allow functionality via contract owner action.
    function pause() public onlyOwner {
        _pause();
    }

    /// @dev To disallow functionality via contract owner action.
    function unpause() public onlyOwner {
        _unpause();
    }

    /*////////////////////////////////
                Owner Only
    ///////////////////////////////*/

    function setCuratorTokenMinimum(uint256 _curatorTokenMinimum) public onlyOwner {
        curatorTokenMinimum = _curatorTokenMinimum;
    }

    function setAddresses(address _treasury, address _curatorAdmin, PhloteVote _phloteToken) public onlyOwner {
        treasury = _treasury;
        curatorAdmin = _curatorAdmin;
        phloteToken = _phloteToken;
    }

    function setHotDropSaleState(Hotdrop _hotdrop, uint256 _state) public onlyOwner {
        _hotdrop.setSaleState(_state);
    }

    function setHotDropTotalSupplyLeft(Hotdrop _hotdrop, uint256 _amount) public onlyOwner {
        _hotdrop.setTotalSupplyLeft(_amount);
    }

    function setHotDropSplits(Hotdrop _hotdrop,uint256 _artist, uint256 _phlote) public onlyOwner{
        _hotdrop.setSplits(_artist, _phlote);
    }

    function setHotdropURI(Hotdrop _hotdrop, string memory _newuri) public onlyOwner {
        _hotdrop.setURI(_newuri);
    }

    function setHotdropPrice(Hotdrop _hotdrop, uint256 _price) public onlyOwner {
        _hotdrop.setPrice(_price);
    }

    /// @dev Create an NFT ("Hotdrop") of your musical internet findings that may be curated in the future.
    /// @param _ipfsURI The ipfs://Qm... URI of the metadata for this submission.
    /// @return hotdrop The address of the new Hotdrop contract that was deployed from this submission.
    function submit(string memory _ipfsURI, bool _isArtistSubmission) public whenNotPaused returns (Hotdrop hotdrop) {
        // there should be enough PhloteVote tokens in this contract to support
        // five cosigns for each submission.
        hotdrop = new Hotdrop(msg.sender,_isArtistSubmission);
        hotdrop.setURI(_ipfsURI);
        emit Submit(
            msg.sender,
            _ipfsURI,
            _isArtistSubmission,
            hotdrop
        );
        bytes memory mintData = abi.encodePacked(hotdrop.totalSupply(hotdrop.submitterEditionNFT())+1);
        hotdrop.mint(msg.sender,hotdrop.submitterEditionNFT(),1,mintData);
        return hotdrop;
    }


    /// @dev Curate a Hotdrop NFT that was submitted to us. This function is for curating ARTIST HOTDROPS ONLY. NOT CURATOR HOTDROP SUBMISSIONS.
    /// @param _hotdrop The address of the hotdrop to curate.
    function curate(Hotdrop _hotdrop) public whenNotPaused {
        require(phloteToken.balanceOf(msg.sender) >= curatorTokenMinimum, "Your Phlote balance is too low.");
        (address hotdropSubmitter, bool isArtistSubmission) = _hotdrop.submission();
        (uint256 cosignNumber, address[5] memory cosigners) = _hotdrop.cosigns();
        if(isArtistSubmission == true){
            require(_hotdrop.totalSupply(_hotdrop.artistCosignerNFT()) < 5, "Sorry! We have reached the maximum cosigns on this record.");
            uint256 mintPrice = _hotdrop.COSIGN_COSTS(cosignNumber);
            require(phloteToken.balanceOf(msg.sender)>= mintPrice, "You do not have enough Phlote Tokens in your balance for this transaction");
            _hotdrop.cosign(msg.sender);
            

            // send the reward to the artist
            require(phloteToken.transferFrom(msg.sender, address(this), mintPrice));
 
            uint256 artistReward = mintPrice - _hotdrop.COSIGN_REWARD();
            phloteToken.mint(hotdropSubmitter, artistReward);

            // send the remaining amount to treasury
            phloteToken.mint(treasury, mintPrice - artistReward);

            // if this is the 5th cosign, enable sale
            if(_hotdrop.totalSupply(_hotdrop.artistCosignerNFT()) == 5){
                _hotdrop.setSaleState(1);
            }

        }

        else{
            require(_hotdrop.totalSupply(_hotdrop.curatorCosignerNFT()) < 5, "Sorry! We have reached the maximum cosigns on this record.");
            _hotdrop.cosign(msg.sender);

            // send the reward to the original submitter  
            phloteToken.mint(hotdropSubmitter, _hotdrop.COSIGN_REWARD());

            //send cosign rewards to previous cosigners, to reward early cosigners
            for (uint256 i = 0; i < cosignNumber; i++) {
            
                phloteToken.mint(cosigners[i], _hotdrop.COSIGN_REWARD());
            }
        }
        emit Cosign(
            msg.sender,
            _hotdrop,
            (cosignNumber + 1)
        );
    }

    // admin withdraw {{{
    /// @dev The owner may withdraw all of the native funds.
    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "need funds to withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }

    /// @dev The owner may withdraw some of the native funds.
    /// @param _amount The balance of native currency to withdraw.
    function withdraw(uint _amount) external onlyOwner {
        require(address(this).balance > 0, "need funds to withdraw");
        require(_amount <= address(this).balance, "don't have that much");
        payable(msg.sender).transfer(_amount);
    }

    /// @dev The owner may withdraw any ERC20 token.
    /// @param _token An ERC20 token of which we have a balance.
    /// @param _amount The balance of native currency to withdraw.
    function withdraw(IERC20 _token, uint256 _amount) public onlyOwner {
        uint256 tokenBalance = _token.balanceOf(address(this));
        require(tokenBalance > 0, "need balance to withdraw");
        require(_amount <= tokenBalance, "don't have that much");
        _token.transfer(msg.sender, tokenBalance);
    }
    // admin withdraw }}}
}

// vim: set fdm=marker:

