// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// @custom:security-contact nohackplz@phlote.xyz
contract Hotdrop is
    Initializable,
    ERC1155Upgradeable,
    OwnableUpgradeable,
    PausableUpgradeable,
    ERC1155BurnableUpgradeable,
    ERC1155SupplyUpgradeable
{
    using SafeMathUpgradeable for uint256;
    using StringsUpgradeable for uint256;
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using SafeERC20Upgradeable for IERC20Upgradeable;
    /*using SafeERC20Upgradeable for PhloteVote;*/
    using AddressUpgradeable for address payable;

    // types of NFTs in this contract
    /*uint256 public ID_SUBMISSION = 1;*/
    uint256 public ID_PHLOTE     = 0;
    /*uint256 public ID_CURATION   = 1;*/
    /*uint256 public ID_COSIGN     = 2;*/

    address public submitter;

    uint256 public COSIGN_REWARD = 15 ether;
    uint256[5] public COSIGN_COSTS = [
        50 ether,
        60 ether,
        70 ether,
        80 ether,
        90 ether
    ];

    address[5] public cosigners;

    uint256 public NFTS_PER_COSIGN = 5;

    bool public curated = false;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() public initializer { return; }

    function initialize(string memory _uri) public initializer {
        __ERC1155_init(_uri);
        __Ownable_init();
        __Pausable_init();
        __ERC1155Burnable_init();
        __ERC1155Supply_init();

        submitter = msg.sender;

        /*bytes memory mintData = abi.encodePacked(msg.sender);*/
        /*_mint(owner(), ID_PHLOTE, 1, mintData);*/
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function onUpgrade() public onlyOwner {
        return;
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
    override(ERC1155Upgradeable, ERC1155SupplyUpgradeable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function phlote() public onlyOwner returns (uint256) {
        curated = true;
        /*uint256 cosignGeneration = cosigns() + 1;*/
        /*bytes memory mintData = abi.encodePacked(cosignGeneration);*/
        /*_mint(msg.sender, cosignGeneration, NFTS_PER_COSIGN, mintData);*/
        bytes memory mintData = abi.encodePacked(totalSupply(ID_PHLOTE)+1);
        _mint(msg.sender, ID_PHLOTE, 1, mintData);
        return totalSupply(ID_PHLOTE);
    }

    function cosigns() public view returns (uint256) {
        // INFO: https://docs.openzeppelin.com/contracts/4.x/api/token/erc1155#ERC1155Supply
        /*return totalSupply(ID_PHLOTE) / NFTS_PER_COSIGN;*/
        return totalSupply(ID_PHLOTE);
    }
}
