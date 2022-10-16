// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

//We're going to import OpenZeppelin contracts
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import "hardhat/console.sol";

//Inherit the contract that was imported so we have access to its methods.
contract GrassleyCollection is ERC721URIStorage {
    //OpenZeppelin let's us keep track of tokenIds with counters.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    //We need to pass the name of our NFT's token and its symbol
    constructor() ERC721 ("Blessed by Grassley", "BLESSED") {
        console.log('This is the nft contract. Line 17');
    }

    //This is the function our users will hit to get blessed by grassley
    function getBlessed() public {
        uint256 newItemId = _tokenIds.current();

        //Mint the NFT and bless the sender. msg.sender is the users address
        _safeMint(msg.sender, newItemId);

        //Set the NFT data
        _setTokenURI(newItemId, 'Blessed by Grassley');

        //Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }
}