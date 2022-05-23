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

    // types of NFTs in this contract
    /*uint256 public ID_SUBMISSION = 1;*/
    uint256 public ID_PHLOTE     = 0;
    /*uint256 public ID_CURATION   = 1;*/
    /*uint256 public ID_COSIGN     = 2;*/

    address public submitter;

    uint256 public COSIGN_REWARD = 15 wei;
    uint256[5] public COSIGN_COSTS = [
        50 wei,
        60 wei,
        70 wei,
        80 wei,
        90 wei
    ];

    address[5] public cosigners;

    uint256 public NFTS_PER_COSIGN = 5;

    bool public curated = false;

    constructor(
        address _submitter
    )
        ERC1155("https://ipfs.phlote.xyz/hotdrop/{id}.json")
    {
        submitter = _submitter;
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
        require(totalSupply(ID_PHLOTE) < cosigners.length, "can't mint more");
        cosigners[totalSupply(ID_PHLOTE)] = account;
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

    function phlote(address _cosigner) public onlyOwner returns (uint256) {
        curated = true;
        /*uint256 cosignGeneration = cosigns() + 1;*/
        /*bytes memory mintData = abi.encodePacked(cosignGeneration);*/
        /*_mint(msg.sender, cosignGeneration, NFTS_PER_COSIGN, mintData);*/
        bytes memory mintData = abi.encodePacked(totalSupply(ID_PHLOTE)+1);
        mint(_cosigner, ID_PHLOTE, 1, mintData);
        return totalSupply(ID_PHLOTE);
    }

    function cosigns() public view returns (uint256) {
        // INFO: https://docs.openzeppelin.com/contracts/4.x/api/token/erc1155#ERC1155Supply
        /*return totalSupply(ID_PHLOTE) / NFTS_PER_COSIGN;*/
        return totalSupply(ID_PHLOTE);
    }
}
