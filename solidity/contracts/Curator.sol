// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

import "@openzeppelin/contracts/interfaces/IERC1155.sol";

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

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
contract Curator is Initializable, PausableUpgradeable, AccessControlEnumerableUpgradeable {
    using SafeMathUpgradeable for uint256;
    using StringsUpgradeable for uint256;
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using SafeERC20 for IERC20;
    using SafeERC20 for PhloteVote;
    using AddressUpgradeable for address payable;

    address public admin;

    PhloteVote public vote;
    address public treasury;
    uint256 public curatorTokenMinimum;

    address public curatorAdmin;

    bytes32 public constant CURATOR       = keccak256("CURATOR");
    bytes32 public constant CURATOR_ADMIN = keccak256("CURATOR_ADMIN");

    event Submit(
        address indexed submitter,
        string ipfsURI,
        Hotdrop hotdrop
    );

    event Phlote(
        address indexed cosigner,
        Hotdrop hotdrop,
        uint256 generation
    );

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() { return; }

    /// @dev The constructor function. It also calls the upgrade function.
    /// @param _vote Phlote's ERC20 DAO token.
    function initialize(PhloteVote _vote, address _treasury, address _curatorAdmin) public initializer {
        __Pausable_init();
        __AccessControlEnumerable_init();

        admin = msg.sender;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(CURATOR_ADMIN, msg.sender);
        _setRoleAdmin(CURATOR, CURATOR_ADMIN);
        _grantRole(CURATOR, msg.sender);
        // hi

        _onUpgrade(_vote, _treasury, _curatorAdmin);
        /*if (vote.allowance(address(this)) < vote.MAX_SUPPLY()) {*/
            /*vote.approve(address(this), vote.MAX_SUPPLY());*/
        /*}*/
    }

    /// @dev The upgrade function. To be called by the constructor as well.
    /// @param _vote Phlote's ERC20 DAO token.
    function onUpgrade(PhloteVote _vote, address _treasury, address _curatorAdmin) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _onUpgrade(_vote, _treasury, _curatorAdmin);
    }

    /// @dev The upgrade function. To be called by the constructor as well.
    /// @param _vote Phlote's ERC20 DAO token.
    function _onUpgrade(PhloteVote _vote, address _treasury, address _curatorAdmin) private {
        /*require(_vote.owner() == address(this), "_vote not owned by Curator");*/
        vote = _vote;
        treasury = _treasury;

        // revoke the old curator admin and grant the new one (if changed).
        revokeRole(CURATOR_ADMIN, curatorAdmin);
        curatorAdmin = _curatorAdmin;
        grantRole(CURATOR_ADMIN, curatorAdmin);
    }

    /// @dev To allow functionality via contract owner action.
    function pause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    /// @dev To disallow functionality via contract owner action.
    function unpause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    /// @dev Give an address the `CURATOR` role.
    /// @param _newCurator The address of the curator who has enough PhloteVote tokes to curate for us.
    function grantCuratorRole(address _newCurator) public onlyRole(CURATOR_ADMIN) {
        require(vote.balanceOf(_newCurator) >= curatorTokenMinimum, "too few vote tokens");
        grantRole(CURATOR, _newCurator);
    }

    /// @dev Revoke an address's `CURATOR` role.
    /// @param _oldCurator The address of the curator to disallow from Phlote curation.
    function revokeCuratorRole(address _oldCurator) public onlyRole(CURATOR_ADMIN) {
        revokeRole(CURATOR, _oldCurator);
    }

    /// @dev Create an NFT ("Hotdrop") of your musical internet findings that may be curated in the future.
    /// @param _ipfsURI The ipfs://Qm... URI of the metadata for this submission.
    /// @return hotdrop The address of the new Hotdrop contract that was deployed from this submission.
    function submit(string memory _ipfsURI) public returns (Hotdrop hotdrop) {
        // there should be enough PhloteVote tokens in this contract to support
        // five cosigns for each submission.
        hotdrop = new Hotdrop(msg.sender);
        hotdrop.setURI(_ipfsURI);
        emit Submit(
            msg.sender,
            _ipfsURI,
            hotdrop
        );
        return hotdrop;
    }

    /// @dev Curate a Hotdrop NFT (un-curated) that was submitted to us.
    /// @param _hotdrop The address of the hotdrop to curate.
    function curate(Hotdrop _hotdrop) public onlyRole(CURATOR) {
        uint256 cosigns = _hotdrop.phlote(msg.sender);
        console.log("cosigns", cosigns);
        // send the community reward to the treasury
        uint256 communityReward = _hotdrop.COSIGN_COSTS(cosigns-1) - ((cosigns)*_hotdrop.COSIGN_REWARD());
        vote.transfer(treasury, communityReward);
        // send the cosign reward to the original submitter
        vote.transfer(_hotdrop.submitter(), _hotdrop.COSIGN_REWARD());
        // send cosign rewards to previous cosigners
        for (uint256 i = 0; i < cosigns - 1; i++) {
            console.log("transfer to", i, _hotdrop.cosigners(i), _hotdrop.COSIGN_REWARD());
            vote.transfer(_hotdrop.cosigners(i), _hotdrop.COSIGN_REWARD());
        }
        emit Phlote(
            msg.sender,
            _hotdrop,
            cosigns
        );
    }

    // admin withdraw {{{
    /// @dev The owner may withdraw all of the native funds.
    function withdraw() external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(address(this).balance > 0, "need funds to withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }

    /// @dev The owner may withdraw some of the native funds.
    /// @param _amount The balance of native currency to withdraw.
    function withdraw(uint _amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(address(this).balance > 0, "need funds to withdraw");
        require(_amount <= address(this).balance, "don't have that much");
        payable(msg.sender).transfer(_amount);
    }

    /// @dev The owner may withdraw any ERC20 token.
    /// @param _token An ERC20 token of which we have a balance.
    /// @param _amount The balance of native currency to withdraw.
    function withdraw(IERC20 _token, uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        uint256 tokenBalance = _token.balanceOf(address(this));
        require(tokenBalance > 0, "need balance to withdraw");
        require(_amount <= tokenBalance, "don't have that much");
        _token.transfer(msg.sender, tokenBalance);
    }
    // admin withdraw }}}
}

// vim: set fdm=marker:
