// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
// NFT contract to inherit from.
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";


contract Phlote is ERC721Upgradeable, OwnableUpgradeable {
    //uint256 public editionSize;
    uint256 public contractPrice;
    struct Edition {
        address curatorWallet;
        address artistWallet;
        string mediaURI;
        string marketplace;
        string[] tags;
        string artistName;
        string mediaType;
        string mediaTitle;
        uint256 numSold;
        string tokenURI; // uses IPFS
        uint submissionTime;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 private nextPostId ;
    Edition[] allCurations;

    /***MAPS***/
    //creates a mapping from editionId to description of the Edition struct
    mapping(uint256 => Edition) public editions;
    //creates a mapping from ownerId to tokenId
    mapping(address => uint256) public nftHolders;
    //creates a mapping of the submitter to their Submissions
    mapping(address => Edition[]) public curatorSubmissions;

    //IMPORTED MAPS
    // The amount of funds that have already been withdrawn for a given edition.
    mapping(uint256 => uint256) public withdrawnForEdition;
    //creates a mapping from tokenId to the EditionId
    mapping(uint256 => uint256) public tokenToSong;
    // creates a mapping of editionIds to cosigners
    mapping(uint256 => address[]) public editionToCosigners;
    /*****EVENTS******/
    event EditionCreated(address sender, uint256 indexed editionId);
    event EditionMinted(
        address indexed buyer,
        uint256 tokenId,
        uint256 numSold
    );


    function initialize() initializer public{
        _tokenIds.increment();
        nextPostId = 1;
        __ERC721_init("Phlote Curation", "PHLOTE");
    }

    

    function mintEdition(uint256 editionId) public payable {
        // require(_tokenIds.current()-1 < editionSize,"Song is sold out!");
        // require(
        //     msg.value == editions[editionId].songPrice,
        //     "please send enough to purchase edition"
        // );
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        console.log(
            "******Minted %s NFT w/ tokenId %s ******",
            editions[editionId].mediaTitle,
            newItemId
        );
        // Keep an easy way to see who owns what NFT.
        nftHolders[msg.sender] = newItemId;

        // Increment the tokenId and numSold for the next person that uses it.
        _tokenIds.increment();
        editions[editionId].numSold++;
        tokenToSong[newItemId] = editionId;
        emit EditionMinted(msg.sender, newItemId, editions[editionId].numSold);
    }

    //creates the edition/Post
      function submitPost(
        address _curatorWallet,
        string memory _mediaURI,
        string memory _marketplace,
        string[] memory _tags,
        string memory _artistName,
        address _artistWallet,
        string memory _mediaType,
        string memory _mediaTitle,
        string memory _tokenURI
    ) public {
        /*
        This is a post of a curator's submissions. 
        This function should 
        - set the curator's submission as an edition
        */

        Edition memory curation = Edition({
            curatorWallet: _curatorWallet,
            mediaURI: _mediaURI,
            marketplace: _marketplace,
            tags: _tags,
            artistName: _artistName,
            artistWallet: _artistWallet,
            mediaType: _mediaType,
            mediaTitle: _mediaTitle,
            numSold: 0,
            tokenURI: _tokenURI,
            submissionTime: block.timestamp
        });
        allCurations.push(curation);
        editions[nextPostId] = curation;
        curatorSubmissions[_curatorWallet].push(curation);
        //add it to their archive of submissions. mapping of address -> submissions[]
        emit EditionCreated(msg.sender, nextPostId);
        mintEdition(nextPostId);
        nextPostId++; 
    }

     function getCuratorSubmissions(address _curatorWallet) public view returns (Edition[] memory)
    {
         return curatorSubmissions[_curatorWallet];
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        Edition memory sAttributes = editions[tokenToSong[_tokenId]];
        return sAttributes.tokenURI;
    }

    
    function getAllCurations() public view returns (Edition[] memory) {
        return allCurations;
    }

    function cosign(address _curatorWallet, uint256 id) public {
        editionToCosigners[id].push(_curatorWallet);
    }

    //-----IMPORTEDFUNCTIONS-----
    // function withdrawFunds(uint256 editionId, address payable person) external {
    //     // Compute the amount available for withdrawing from this edition.
    //     uint256 remainingForEdition = (editions[editionId].songPrice * // Compute total amount of revenue that has been generated for the edition so far.
    //         editions[editionId].numSold) -
    //         // Subtract the amount that has already been withdrawn.
    //         withdrawnForEdition[editionId];

    //     // Update that amount that has already been withdrawn for the edition.
    //     withdrawnForEdition[editionId] += remainingForEdition;
    //     // Send the amount that was remaining for the edition, to the funding recipient.
    //     _sendFunds(person, remainingForEdition);
    // }

    function _sendFunds(address payable recipient, uint256 amount) private {
        require(
            address(this).balance >= amount,
            "Insufficient balance for send"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Unable to send value: recipient may have reverted");
    }

    /* ---New Functions---*/
    
}
