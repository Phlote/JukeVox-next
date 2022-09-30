// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

import "@openzeppelin/contracts/interfaces/IERC1155.sol";

import "@openzeppelin/contracts/interfaces/IERC20.sol";

import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "./PhloteVote.sol";
import "./Hotdrop.sol";


/// @title A factor and manager for "Hotdrop" NFTs (Phlote user-submitted-content).
/// @author Zachary Fogg <me@zfo.gg>
/// @notice This contract's events should be indexed for use by front-ends.
/// @dev Please check the tests for this contract when making changes!
/// @custom:security-contact nohackplz@phlote.xyz
contract Curator is Initializable, PausableUpgradeable, AccessControlEnumerableUpgradeable {
    using SafeMathUpgradeable for uint256;
    using StringsUpgradeable for uint256;
    using CountersUpgradeable for CountersUpgradeable.Counter;

    using AddressUpgradeable for address payable;

    address public admin;

    PhloteVote public phloteToken;
    address public treasury;
    uint256 public curatorTokenMinimum;

    address public curatorAdmin;

    bytes32 public constant CURATOR       = keccak256("CURATOR");
    bytes32 public constant CURATOR_ADMIN = keccak256("CURATOR_ADMIN");

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

    /// @dev The constructor function. It also calls the upgrade function.
    /// @param _phloteToken Phlote's ERC20 DAO token.
    function initialize(PhloteVote _phloteToken, address _treasury, address _curatorAdmin) public initializer {
        __Pausable_init();
        __AccessControlEnumerable_init();

        admin = msg.sender;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(CURATOR_ADMIN, msg.sender);
        _setRoleAdmin(CURATOR, CURATOR_ADMIN);
        _grantRole(CURATOR, msg.sender);
        curatorTokenMinimum = 50;

        _onUpgrade(_phloteToken, _treasury, _curatorAdmin);
        /*if (vote.allowance(address(this)) < vote.MAX_SUPPLY()) {*/
            /*vote.approve(address(this), vote.MAX_SUPPLY());*/
        /*}*/
    }

    /// @dev The upgrade function. To be called by the constructor as well.
    /// @param _phloteToken's ERC20 DAO token.
    function onUpgrade(PhloteVote _phloteToken, address _treasury, address _curatorAdmin) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _onUpgrade(_phloteToken, _treasury, _curatorAdmin);
    }

    /// @dev The upgrade function. To be called by the constructor as well.
    /// @param _phloteToken Phlote's ERC20 DAO token.
    function _onUpgrade(PhloteVote _phloteToken, address _treasury, address _curatorAdmin) private {
        /*require(_vote.owner() == address(this), "_vote not owned by Curator");*/
        phloteToken = _phloteToken;
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

    /*////////////////////////////////
                Owner Only
    ///////////////////////////////*/

    function setCuratorTokenMinimum(uint256 _curatorTokenMinimum) public onlyOwner {
        curatorTokenMinimum = _curatorTokenMinimum;
    }

    function setAddresses(address _treasury, address _curatorAdmin) public onlyOwner {
        treasury = _treasury;
        curatorAdmin = _curatorAdmin;
    }


    /// @dev Give an address the `CURATOR` role.
    /// @param _newCurator The address of the curator who has enough PhloteVote tokes to curate for us.
    function grantCuratorRole(address _newCurator) public onlyRole(CURATOR_ADMIN) {
        require(phloteToken.balanceOf(_newCurator) >= curatorTokenMinimum, "too few Phlote tokens");
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

            _hotdrop.cosign(msg.sender);
            // send the reward to the artist
            
           require(phloteToken.transferFrom(msg.sender, address(this),mintPrice));
            uint256 artistReward = mintPrice - _hotdrop.COSIGN_REWARD();
            phloteToken.transfer(hotdropSubmitter, artistReward);

            // send the remaining amount to treasury
            phloteToken.transfer(treasury, mintPrice - artistReward);

        }

        else{
            require(_hotdrop.totalSupply(_hotdrop.curatorCosignerNFT()) < 5, "Sorry! We have reached the maximum cosigns on this record.");
            _hotdrop.cosign(msg.sender);

            // send the reward to the original submitter
            phloteToken.transferFrom(treasury, hotdropSubmitter, _hotdrop.COSIGN_REWARD());

            //send cosign rewards to previous cosigners, to reward early cosigners
            for (uint256 i = 0; i < cosignNumber; i++) {
            
                phloteToken.transferFrom(treasury, cosigners[i], _hotdrop.COSIGN_REWARD());
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

