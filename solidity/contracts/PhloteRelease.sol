pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


/*
- pricing scheme of first 5 NFTs

things to always set:
- Phlote Treasury address
- Phlote token address
*/

contract PhloteRelease is ERC721A, Ownable {
    enum SaleState {
        Disabled,
        PublicSale
    }

    SaleState public saleState = SaleState.Disabled;
    //wont need this most likely can hardcode in function
    uint256[] public cosignerPrice = [90,80,70,60,50];
    uint256 public price;
    uint256 public artistSplit = 90;
    uint256 public phloteSplit = 10;
    uint256 public totalSupplyLeft;
    string public baseURI;
    string public baseExtension = ".json";
    address payable artist;
    //***** SET TREASURY WITH REAL ADDRESS BEFORE LAUNCH ****
    address payable phloteTreasury = payable(0x14dC79964da2C08b23698B3D3cc7Ca32193d9955);
    address[] public cosigners;
    IERC20 public phloteToken;

    event SaleStateChanged(uint256 prevState,uint256 nextState, uint256 timeStamp);
    event Mint(address minter, uint256 amount);
    event CosignerMint(address minter);

    constructor(address payable _artistAddress, address[] memory _cosigners) ERC721A("PhloteRelease", "PHLOTE") {
        //Defaults
        totalSupplyLeft = 20; //the public supply
        price = 10000000000000000;
        artist = _artistAddress;
        /***** SET PROPER PHLOTE MAINNET ADDRESS ****/
        phloteToken = IERC20(0x8eF43798e0f8Bb4C7531e1e12D02894ac34F3A61);
        cosigners = _cosigners;
    }

    modifier whenSaleIsActive() {
        require(saleState != SaleState.Disabled, "Sale is not active");
        _;
    }

    function mint(uint256 amount) external payable whenSaleIsActive {
        require(amount <= totalSupplyLeft, "Minting would exceed cap");
        require(price * amount == msg.value, "Value sent is not correct");
        totalSupplyLeft -= amount;
        if(totalSupplyLeft == 0){
            uint256 balance = address(this).balance;
            //send 90% of sale proceedings to phlote
            artist.transfer(balance * artistSplit /100);
            //send 10% of sale proceedings to phlote
            phloteTreasury.transfer(balance * phloteSplit /100);
        }
        _safeMint(msg.sender, amount);
        emit Mint(msg.sender, amount);
    }

    function cosignerMint() external payable whenSaleIsActive {
        require(_isCosigner(msg.sender), "You are not a Co-Signer or you have already reached the limit");
        //might not be neede to check allowance
        uint256 mintPrice = cosignerPrice[cosignerPrice.length-1];
        require(
                phloteToken.allowance(msg.sender, address(this)) >= mintPrice,
                "Phlote token allowance is too low"
            );
        require(phloteToken.transferFrom(msg.sender, address(this), mintPrice));

        if(cosigners.length == 0){
            uint256 phloteBalance = phloteToken.balanceOf(address(this));
            //send 90% of sale proceedings to phlote
            phloteToken.transfer(artist, phloteBalance * artistSplit /100);
            //send 10% of sale proceedings to phlote
            phloteToken.transfer(phloteTreasury, phloteBalance * phloteSplit /100);
        }
        cosignerPrice.pop();
        _safeMint(msg.sender,1);
        emit CosignerMint(msg.sender);
    }

    /*////////////////////////////////
                Owner Only
    ///////////////////////////////*/

    function setTotalSupplyLeft(uint256 _amount) external onlyOwner{
        totalSupplyLeft = _amount;
    }

    function setPhloteToken(address _phloteVote) external onlyOwner{
        require(_phloteVote != address(0), "PhloteVote cannot be address 0X");
        phloteToken = IERC20(_phloteVote);
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

    function setSaleState(uint256 _state) external onlyOwner {
        uint256 prevState = uint256(saleState);
        saleState = SaleState(_state);
        emit SaleStateChanged(prevState, _state, block.timestamp);
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }
    
    function setCosignerPrice(uint256[] memory _prices) external onlyOwner {
        require(_prices.length == cosignerPrice.length, "number of prices needs to equal number of cosigner NFTs left");
        cosignerPrice = _prices;
    }

    function emergencyWithdraw(address payable _to, uint256 _amount) external onlyOwner {
        require(_to != address(0), "Cannot recover ETH to the 0 address");
        _to.transfer(_amount);
    }


    /*////////////////////////////////
                Internal
    ///////////////////////////////*/

    function _isCosigner(address _cosigner) internal returns (bool) {
        for (uint i = 0; i < cosigners.length; i++) {
            if (cosigners[i] == _cosigner) {
                //deletes cosigners from list
                cosigners[i] = cosigners[cosigners.length-1];
                cosigners.pop();
                return true;
            }
        }

        return false;
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
