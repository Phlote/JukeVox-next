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

    // types of NFTs in this contract
    /*uint256 public ID_SUBMISSION = 1;*/
    uint256 public artistCosignerNFT = 0;
    uint256 public curatorCosignerNFT = 1;
    /*uint256 public ID_CURATION   = 1;*/
    /*uint256 public ID_COSIGN     = 2;*/

    uint256 public COSIGN_REWARD = 15;
    uint256[5] public COSIGN_COSTS = [
        50,
        60,
        70,
        80,
        90
    ];

    struct Submission {
        address submitter;
        bool isArtistSubmission;
        address[5] cosigners;
    }

    Submission public submission;

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
        return;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyOwner {
        if(id == 0){
            require(totalSupply(artistCosignerNFT) < submission.cosigners.length, "can't mint more");
            submission.cosigners[totalSupply(artistCosignerNFT)] = account;
        }
        else{
            require(totalSupply(curatorCosignerNFT) < submission.cosigners.length, "can't mint more");
            submission.cosigners[totalSupply(curatorCosignerNFT)] = account;
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