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
        console.log('This is the nft contract constructor. Line 17');
    }

    //This is the function our users will hit to get blessed by grassley
    function getBlessed() public {
        //This will keep track of the NFTs unique identifier, it's just a number, automatically initialized to 0 when declared.
        //This is a state variable, so when it's changed the value is stored on the contact directly.
        uint256 newItemId = _tokenIds.current();

        //Mint the NFT and bless the sender. msg.sender is the users address
        //Solidity has msg.sender built in. It's a super secure way of getting the user's public address. Can't be faked unless their creds are already known.
        //Contract can't be called anonymously
        _safeMint(msg.sender, newItemId);

        //Set the NFT data. This sets the NFTs unique identifier along with the data associated with said identifier. This is us setting the actual
        //data. This is where our picture is going to go! Usually links to a JSON file called the metadata. Looks like this
        /*
            {
                "name": "Spongebob Cowboy Pants",
                "description": "A silent hero. A watchful protector.",
                "image": "https://i.imgur.com/v7U019j.png"
            }
        */
        _setTokenURI(newItemId, 'https://bafkreidpvcnexxrxjzmnemlhfiijqz3cz7utnwrv372snksjonsulfhcra.ipfs.nftstorage.link/');
        console.log('A new NFT with id %s has been minted to %s', newItemId, msg.sender);

        //Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }
}