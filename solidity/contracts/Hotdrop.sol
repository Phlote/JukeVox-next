// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "hardhat/console.sol";

/// @custom:security-contact nohackplz@phlote.xyz
contract Hotdrop is
    ERC1155,
    Ownable,
    Pausable,
    ERC1155Burnable,
    ERC1155Supply
{
    using SafeMath for uint256;
    using Strings for uint256;
    using Counters for Counters.Counter;
    using SafeERC20 for IERC20;
    /*using SafeERC20 for PhloteVote;*/
    using Address for address payable;

    IERC20 public phloteToken;

    enum SaleState {
        Disabled,
        PublicSale
    }

    SaleState public saleState = SaleState.Disabled;

    // types of NFTs in this contract
    uint256 public artistCosignerNFT = 0;
    uint256 public curatorCosignerNFT = 1;
    uint256 public submitterEditionNFT = 2;
    uint256 public regularEditionNFT = 3;  

    //Sale Variables
    uint256 public publicPrice;
    uint256 public artistSplit = 90;
    uint256 public phloteSplit = 10;
    uint256 public totalSupplyLeft;


    uint256 public COSIGN_REWARD = 15000000000000000000;
    uint256[5] public COSIGN_COSTS = [
        50000000000000000000,
        60000000000000000000,
        70000000000000000000,
        80000000000000000000,
        90000000000000000000
    ];

    address payable artist;
    address payable phloteTreasury = payable(0x14dC79964da2C08b23698B3D3cc7Ca32193d9955);

    event SaleStateChanged(uint256 prevState,uint256 nextState, uint256 timeStamp);
    event Mint(address minter, uint256 amount);

    struct Submission {
        address submitter;
        bool isArtistSubmission;
        address[5] cosigners;
    }

    Submission public submission;

    modifier whenSaleIsActive() {
        require(saleState != SaleState.Disabled, "Sale is not active");
        _;
    }

    modifier cosignerExists(address _cosigner) {
        bool allowed = true;
        for (uint i; i< submission.cosigners.length;i++){
          if (submission.cosigners[i]== _cosigner){
            allowed = false;
          }
      }
      if(allowed == false){
        require(allowed, "You have already cosigned the following record");
        _;
      }
      else{
        require(_cosigner != submission.submitter, "You cannot vote for your own track");
        _;
      }
    }

    constructor(
        address _submitter, bool _isArtistSubmission
    )
        ERC1155("https://ipfs.phlote.xyz/hotdrop/{id}.json")
    {
        address[5] memory cosigners;
        submission = Submission(_submitter,_isArtistSubmission, cosigners);
        phloteToken = IERC20(0x8eF43798e0f8Bb4C7531e1e12D02894ac34F3A61);
        totalSupplyLeft = 20; //the public supply
        publicPrice = 10000000000000000;
        artist = payable(_submitter);
        return;
    }

    
    /*////////////////////////////////
                Owner Only
    ///////////////////////////////*/

    function setURI(string memory _newuri) public onlyOwner {
        _setURI(_newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function setTotalSupplyLeft(uint256 _amount) external onlyOwner{
        totalSupplyLeft = _amount;
    }

    function setPrice(uint256 _price) external onlyOwner{
        publicPrice = _price;
    }

    function setSplits (uint256 _artist, uint256 _phlote) external onlyOwner {
        require(_artist + _phlote == 100, "The 2 splits must total 100");
        artistSplit = _artist;
        phloteSplit = _phlote;
    }

    function setWallets(address payable _artist, address payable _phlote) external onlyOwner {
        artist = _artist;
        phloteTreasury = _phlote;
    }

    function setSaleState(uint256 _state) public onlyOwner {
        uint256 prevState = uint256(saleState);
        saleState = SaleState(_state);
        emit SaleStateChanged(prevState, _state, block.timestamp);
    }

    function emergencyWithdraw(address payable _to, uint256 _amount) external onlyOwner {
        require(_to != address(0), "Cannot recover ETH to the 0 address");
        _to.transfer(_amount);
    }

    /*////////////////////////////////
                Minting
    ///////////////////////////////*/

    function saleMint(uint256 amount) external payable whenSaleIsActive {
        require(amount <= totalSupplyLeft, "Minting would exceed cap");
        require(publicPrice * amount == msg.value, "Value sent is not correct");
        totalSupplyLeft -= amount;
        if(totalSupplyLeft == 0){
            uint256 balance = address(this).balance;
            //send 90% of sale proceedings to phlote
            artist.transfer(balance * artistSplit /100);
            //send 10% of sale proceedings to phlote
            phloteTreasury.transfer(balance * phloteSplit /100);
        }
        bytes memory mintData = abi.encodePacked(totalSupply(regularEditionNFT)+1);
        _mint(msg.sender, regularEditionNFT, amount, mintData);
        emit Mint(msg.sender, amount);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyOwner {
        if(id == 0){
            require(totalSupply(artistCosignerNFT) < submission.cosigners.length, "You cannot mint more");
            submission.cosigners[totalSupply(artistCosignerNFT)] = account;
        }
        else if(id == 1){
            require(totalSupply(curatorCosignerNFT) < submission.cosigners.length, "You cannot mint more");
            submission.cosigners[totalSupply(curatorCosignerNFT)] = account;
        }
        else if(id == 2){
            require(totalSupply(submitterEditionNFT) <= 1, "You cannot mint more");
        }
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public onlyOwner {
        require(false, "disabled for now. use _mint(..)");
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data)
    internal whenNotPaused
    override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    
    /*////////////////////////////////
                Cosigns
    ///////////////////////////////*/

    function cosign(address _cosigner) public cosignerExists(_cosigner) onlyOwner returns (uint256) {
        uint256 cosignType;
        if(submission.isArtistSubmission == true){
            cosignType = artistCosignerNFT;
        }
        else{
            cosignType = curatorCosignerNFT;
        }
        bytes memory mintData = abi.encodePacked(totalSupply(cosignType)+1);
        
        mint(_cosigner, cosignType, 1, mintData);

        return totalSupply(cosignType);
    }

    function cosigns() public view returns (uint256, address[5] memory) {
        // INFO: https://docs.openzeppelin.com/contracts/4.x/api/token/erc1155#ERC1155Supply
        /*return totalSupply(CosignerNFT) / NFTS_PER_COSIGN;*/
        address[5] memory _cosignersList = submission.cosigners;
        if(submission.isArtistSubmission == true){
            return (totalSupply(artistCosignerNFT),_cosignersList);
        }
        else{
            return (totalSupply(curatorCosignerNFT),_cosignersList);
        }
    }

    function submissionDetails() view public returns(address,bool,address[5] memory){
        return(submission.submitter,submission.isArtistSubmission,submission.cosigners);
    }
}