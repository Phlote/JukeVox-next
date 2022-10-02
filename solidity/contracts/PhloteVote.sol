// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";


/// @custom:security-contact nohackplz@phlote.xyz
contract PhloteVote is ERC20, ERC20Burnable, Pausable, Ownable, ERC20Permit {
    using SafeMath for uint256;
    using Strings for uint256;
    using Counters for Counters.Counter;
    using SafeERC20 for IERC20;
    using SafeERC20 for PhloteVote;
    using Address for address payable;

    uint256 public MAX_SUPPLY = 140000 * 10 ** decimals();

    constructor() ERC20("Phlote Vote", "PV1") ERC20Permit("Phlote Vote") {
        _mint(msg.sender, MAX_SUPPLY);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}