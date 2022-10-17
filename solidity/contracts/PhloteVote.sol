// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/// @custom:security-contact nohackplz@phlote.xyz
contract PhloteVote is ERC20, ERC20Burnable, Pausable, ERC20Permit {
    using SafeMath for uint256;
    using Strings for uint256;
    using Counters for Counters.Counter;
    using SafeERC20 for IERC20;
    using SafeERC20 for PhloteVote;
    using Address for address payable;

    //currently not being used. Do we need to cap it?
    uint256 public MAX_SUPPLY = 14 * 10 ** decimals();
    address public owner;
    address public admin;

    event MaxSupplyChange(
        uint256 newTotalSupply
    );

    modifier onlyOwner() {
        require(msg.sender == admin || msg.sender == owner, "You do not have access to this function.");
        _;
    }

    constructor(uint256 _amountToMint) ERC20("Phlote Vote", "PV1") ERC20Permit("Phlote Vote") {
        owner = msg.sender;
        _mint(msg.sender, _amountToMint);
    }

    function setAdmin(address _admin) public onlyOwner {
        admin = _admin;
    }

    function setMAXSUPPLY(uint256 _maxSupply) public onlyOwner {
        MAX_SUPPLY = _maxSupply;
        emit MaxSupplyChange(MAX_SUPPLY);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(this.totalSupply() != MAX_SUPPLY, "You have reached your maximum Supply for mint");
        if(MAX_SUPPLY - this.totalSupply() < amount){
            _mint(to, MAX_SUPPLY - this.totalSupply() );
        }

        else{
            _mint(to, amount);

        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}