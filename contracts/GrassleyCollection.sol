// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

//We're going to import OpenZeppelin contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import '@openzeppelin/contracts/utils/Counters.sol';
import "hardhat/console.sol";

//Import helper functions for JSON metadata.
import { Base64 } from "./libraries/Base64.sol";

//Inherit the contract that was imported so we have access to its methods.
contract GrassleyCollection is ERC721URIStorage {
    //OpenZeppelin let's us keep track of tokenIds with counters.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;



    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // I create three arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever! 
    string[] firstWords = ["Blessed", "Owned", "Yeeted", "Punched", "Blocked", "Ate", "Punted", "Enlightened", "Struck", "Cooked"];
    string ending = " By Grassley";
    

    
    //We need to pass the name of our NFT's token and its symbol
    constructor() ERC721 ("Blessed by Grassley", "BLESSED") {
        console.log('This is the nft contract constructor, Line 17');
    }


    // Randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {

      // The random generator is Seeded with the word blessed
      uint256 rand = random(string(abi.encodePacked("BLESSED", Strings.toString(tokenId))));
      // Squash the # between 0 and the length of the array to avoid going out of bounds.
      rand = rand % firstWords.length;
      return firstWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }


    //This is the function our users will hit to get blessed by grassley
    function getBlessed() public {
        //This will keep track of the NFTs unique identifier, it's just a number, automatically initialized to 0 when declared.
        //This is a state variable, so when it's changed the value is stored on the contact directly.
        uint256 newItemId = _tokenIds.current();



        //This picks a random word for our NFT and closes our SVG code
        string memory first = pickRandomFirstWord(newItemId);
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, ending, "</text></svg>"));
        string memory combinedWord = string(abi.encodePacked(first, ending));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of verbs.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );



        //Mint the NFT and bless the sender. msg.sender is the users address
        //Solidity has msg.sender built in. It's a super secure way of getting the user's public address. Can't be faked unless their creds are already known.
        //Contract can't be called anonymously
        _safeMint(msg.sender, newItemId);


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
        _setTokenURI(newItemId, finalTokenUri);

        //Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }

}