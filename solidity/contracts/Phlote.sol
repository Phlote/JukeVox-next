// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//@buildspace Helper we wrote to encode in Base64 -
import "./libraries/Base64.sol";
// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract Phlote is ERC721 {
    string[] songNames = ["no visuals", "song with visual"];
    string[] songImageURIs = [
        "ipfs://QmWnZjo2NmPJ3kRbs5DfcwC6sLGD47zrbEoArYj4LB7jK1",
        "ipfs://QmUAfBs2cVBEbnaajyZ3E1Uj2cbH9MkWb4cNa7aB6SCShR"
    ];
    string[] artistName = ["artist1", "artist2"];

    //uint256 public editionSize;
    uint256 public contractPrice;
    struct SongNFT {
        string songName;
        string songURI;
        string artistName;
        //number of this song sold
        uint256 numSold;
        //price of the song
        uint256 songPrice;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 private nextSongId = 1;
    SongNFT[] songs;

    /***MAPS***/
    //creates a mapping from editionId to description of the Song struct
    mapping(uint256 => SongNFT) public editions;

    //creates a mapping from ownerId to tokenId
    mapping(address => uint256) public nftHolders;
    //creates a mapping of the requestID to the address that requested randomness
    mapping(bytes32 => address) private shufflers;
    //creates a mapping of the address to the result of the randomresult that was requested
    mapping(address => uint256) private randomResults;
    //creates a mapping of the address to the last time they shuffled
    mapping(address => uint256) public lastShuffleTime;
    //IMPORTED MAPS
    // The amount of funds that have already been withdrawn for a given edition.
    mapping(uint256 => uint256) public withdrawnForEdition;
    //creates a mapping from tokenId to the songNFTId
    mapping(uint256 => uint256) public tokenToSong;
    /*****EVENTS******/
    event SongNFTCreated(uint256 price, uint256 indexed editionId);
    event SongNFTMinted(
        address indexed buyer,
        uint256 tokenId,
        uint256 numSold
    );

    constructor() ERC721("Songs", "SONG") {
        for (uint256 i = 0; i < songNames.length; i += 1) {
            songs.push(
                SongNFT({
                    songPrice: 0,
                    songName: songNames[i],
                    songURI: songImageURIs[i],
                    artistName: artistName[i],
                    numSold: 0
                })
            );

            SongNFT memory s = songs[i];
            console.log(
                "Done initializing %s this is the URI: %s, THIS IS THE ARTIST NAME %s",
                s.songName,
                s.songURI,
                s.artistName
            );
        }
        _tokenIds.increment();
    }

    function setSong(
        string memory _songName,
        string memory _artistName,
        string memory _songURI,
        uint256 _songPrice
    ) external {
        editions[nextSongId] = SongNFT({
            songName: _songName,
            songURI: _songURI,
            artistName: _artistName,
            songPrice: _songPrice,
            numSold: 0
        });
        emit SongNFTCreated(_songPrice, nextSongId);
        nextSongId++;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        SongNFT memory sAttributes = editions[tokenToSong[_tokenId]];
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        sAttributes.songName,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "description": "A starter song used to play in the PHLOTE Jukebox!", "media": "',
                        sAttributes.songURI,
                        '", "attributes": [ { "trait_type": "Artist Name", "value": "',
                        sAttributes.artistName,
                        "} ]}"
                    )
                )
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    function mintsongNFT(uint256 editionId) external payable {
        // require(_tokenIds.current()-1 < editionSize,"Song is sold out!");
        require(
            msg.value == editions[editionId].songPrice,
            "please send enough to purchase edition"
        );
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        console.log(
            "******Minted %s NFT w/ tokenId %s ******",
            editions[editionId].songName,
            newItemId
        );
        // Keep an easy way to see who owns what NFT.
        nftHolders[msg.sender] = newItemId;

        // Increment the tokenId and numSold for the next person that uses it.
        _tokenIds.increment();
        editions[editionId].numSold++;
        tokenToSong[newItemId] = editionId;
        emit SongNFTMinted(msg.sender, newItemId, editions[editionId].numSold);
    }

    function getAllsongs() public view returns (SongNFT[] memory) {
        return songs;
    }

    //-----IMPORTEDFUNCTIONS-----
    function withdrawFunds(uint256 editionId, address payable person) external {
        // Compute the amount available for withdrawing from this edition.
        uint256 remainingForEdition = (editions[editionId].songPrice * // Compute total amount of revenue that has been generated for the edition so far.
            editions[editionId].numSold) -
            // Subtract the amount that has already been withdrawn.
            withdrawnForEdition[editionId];

        // Update that amount that has already been withdrawn for the edition.
        withdrawnForEdition[editionId] += remainingForEdition;
        // Send the amount that was remaining for the edition, to the funding recipient.
        _sendFunds(person, remainingForEdition);
    }

    function _sendFunds(address payable recipient, uint256 amount) private {
        require(
            address(this).balance >= amount,
            "Insufficient balance for send"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Unable to send value: recipient may have reverted");
    }

    /* ---New Functions---*/
    function submitMetadata(
        address artist,
        string memory mediaURI,
        string memory marketplace,
        string memory tag,
        string memory _artistName,
        string memory mediatype,
        string memory mediaTitle
    ) public {
        /*This is an open Edition of a curator's submissions. 
        This function should 
        - mint the curator's submission 
        - add it to their archive of submissions.
        - HOW does this get indexed? it's just a mapping from address to submissions[]
        */
    }
}
