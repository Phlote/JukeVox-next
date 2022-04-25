// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts/interfaces/IERC1155.sol";

import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "hardhat/console.sol";

import "./PhloteVote.sol";
import "./Hotdrop.sol";

/*import "./lib/IPFSStorage.sol";*/

/// @title A factor and manager for "Hotdrop" NFTs (Phlote user-submitted-content).
/// @author Zachary Fogg <me@zfo.gg>
/// @notice This contract's events should be indexed for use by front-ends.
/// @dev Please check the tests for this contract when making changes!
/// @custom:security-contact nohackplz@phlote.xyz
contract Curator is Initializable, PausableUpgradeable, OwnableUpgradeable, AccessControlEnumerableUpgradeable {
    using SafeMathUpgradeable for uint256;
    using StringsUpgradeable for uint256;
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using SafeERC20Upgradeable for PhloteVote;
    using AddressUpgradeable for address payable;

    PhloteVote public vote;
    uint256 public curatorTokenMinimum;

    bytes32 public constant CURATOR = keccak256("CURATOR");

    event Submit(
        address indexed submitter,
        Hotdrop hotdrop
    );

    event Curate(
        address indexed curator,
        Hotdrop hotdrop
    );

    event Cosign(
        address indexed cosigner,
        Hotdrop hotdrop,
        uint256 generation
    );

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() public initializer { return; }

    /// @dev The constructor function. It also calls the upgrade function.
    /// @param _vote Phlote's ERC20 DAO token.
    function initialize(PhloteVote _vote) public initializer {
        onUpgrade(_vote);

        _grantRole(DEFAULT_ADMIN_ROLE, owner());
        _grantRole(CURATOR, owner());

        __Pausable_init();
        __Ownable_init();
        __AccessControlEnumerable_init();
    }

    /// @dev The upgrade function. To be called by the constructor as well.
    /// @param _vote Phlote's ERC20 DAO token.
    function onUpgrade(PhloteVote _vote) public onlyOwner {
        require(_vote.owner() == address(this), "_vote not owned by Curator");
        vote = _vote;
    }

    /// @dev To allow functionality via contract owner action.
    function pause() public onlyOwner {
        _pause();
    }

    /// @dev To disallow functionality via contract owner action.
    function unpause() public onlyOwner {
        _unpause();
    }

    /// @dev Give an address the `CURATOR` role.
    /// @param _newCurator The address of the curator who has enough PhloteVote tokes to curate for us.
    function grantCuratorRole(address _newCurator) public onlyOwner {
        require(vote.balanceOf(_newCurator) >= curatorTokenMinimum, "too few vote tokens");
        grantRole(CURATOR, _newCurator);
    }

    /// @dev Revoke an address's `CURATOR` role.
    /// @param _oldCurator The address of the curator to disallow from Phlote curation.
    function revokeCuratorRole(address _oldCurator) public onlyOwner {
        revokeRole(CURATOR, _oldCurator);
    }

    /// @dev Create an NFT ("Hotdrop") of your musical internet findings that may be curated in the future.
    /// @param _ipfsURI The ipfs://Qm... URI of the metadata for this submission.
    /// @return The address of the new Hotdrop contract that was deployed from this submission.
    function submit(string memory _ipfsURI) public returns (Hotdrop hotdrop) {
        hotdrop = new Hotdrop();
        hotdrop.initialize(_ipfsURI);
        emit Submit(
            msg.sender,
            hotdrop
        );
        return hotdrop;
    }

    /// @dev Curate a Hotdrop NFT (un-curated) that was submitted to us.
    /// @param _hotdrop The address of the hotdrop to curate.
    function curate(Hotdrop _hotdrop) public onlyRole(CURATOR) {
        _hotdrop.curate();
        _hotdrop.setApprovalForAll(address(this), true);
        _hotdrop.safeTransferFrom(address(this), msg.sender, _hotdrop.ID_CURATION, 1, 0x0);
        emit Curate(
            msg.sender,
            _hotdrop
        );
    }

    /// @dev Cosign a Hotdrop NFT (curated) that was submitted to us and curated by a curator.
    /// @param _hotdrop The address of the hotdrop to curate.
    function cosign(Hotdrop _hotdrop) public onlyRole(CURATOR) {
        uint256 cosigns = _hotdrop.cosign();
        emit Cosign(
            msg.sender,
            _hotdrop,
            cosigns
        );
    }
}
