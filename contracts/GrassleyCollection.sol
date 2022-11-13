// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

//We're going to import OpenZeppelin contracts
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import "hardhat/console.sol";

//Inherit the contract that was imported so we have access to its methods.
contract GrassleyCollection is ERC721 {
    //OpenZeppelin let's us keep track of tokenIds with counters.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    //We need to pass the name of our NFT's token and its symbol
    constructor() ERC721 ("Grassley", "BLESSED") {
        console.log('This is the nft contract constructor, Line 17');
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

        //Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }

        //Set the NFT metadata. This sets the NFTs unique identifier along with the data associated with said identifier. This is us setting the actual
        //data. This is where our picture is going to go! Usually links to a JSON file called the metadata. Looks like this
        /*
            {
                "name": "Spongebob Cowboy Pants",
                "description": "A silent hero. A watchful protector.",
                "image": "https://i.imgur.com/v7U019j.png"
            }
        */
       //You can either link to an offchain source such as ->
        // _setTokenURI(newItemId, 'ipfs://bafkreidpvcnexxrxjzmnemlhfiijqz3cz7utnwrv372snksjonsulfhcra');
        //or use an encoded string

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
      require(_exists(_tokenId));
      console.log("An NFT w/ ID %s has been minted to %s", _tokenId, msg.sender);
      return string(
            abi.encodePacked(
                "data:application/json;base64,",
                "ewogICAgICAgICAgICAgICAgIm5hbWUiOiAiU3BvbmdlYm9iIENvd2JveSBQYW50cyIsCiAgICAgICAgICAgICAgICAiZGVzY3JpcHRpb24iOiAiQSBzaWxlbnQgaGVyby4gQSB3YXRjaGZ1bCBwcm90ZWN0b3IuIiwKICAgICAgICAgICAgICAgICJpbWFnZSI6ICJodHRwczovL2kuaW1ndXIuY29tL3Y3VTAxOWoucG5nIgp9"
            )
        );
    }
}