### Blessed by Grassley Collection

This is an NFT collection made in order to learn a bit about the Ethereum blockchain.
This project can be viewed here: <a href="https://warm-bavarois-e3d195.netlify.app/">The Grassley Collection</a>.

### Welcome to the Grassley NFT collection source code.
I am an aspiring dev looking to get my foot in the door. Here's what I learned while making this project.
Thank you to the <a href="https://www.buildspace.so/">Buildspace</a> community!

### What the hell is an NFT?
An NFT is a "token" that a person can own that links to some piece of "data" (ex. a link to a piece of digital art, a video, an image, etc). The trick with NFTs is that each "token" has a unique identifier that lets the owner prove that it's one of a kind.


## Setting up my local environment
The NFT collection was developed using Hardhat to run a local blockchain. Ethers and OpenZeppelin libraries.
React was used to build the front-end.

Hardhat compiles my smart contracts from Solidity to evm bytecode, spun up a local blockchain, and deployed a smart contract to this local instance.

## Writing a test contract
I learned it's good practice to include an SPDX license on the first line, these can be read up on here: https://spdx.org/licenses/
You need to declare the version of the Solidity compiler the contract should use with a pragma. 

The contract keyword looks like a class in other languages.

## ERC 721
ERC 721 is the NFT standard, I used OpenZeppelin to implement the standard and wrote my own logic on top of it. No boiler plate had to be
written due to this. Just like writing an HTTP server from scratch would be crazy, similarly it would be nuts to write an NFT contract from complete scratch.
Here is the standard I imported: <a href="https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol">ERC 721</a>

So, when we want to perform an action that changes the blockchain we call it a transaction. For example, sending someone ETH is a transaction because we're changing account balances. Doing something that updates a variable in our contract is also considered a transaction because we're changing data. Minting an NFT is a transaction because we're saving data on the contract.


## Deploying to Goerli with offchain image hosting
This was fun! I used Quicknode to deploy my contract to the Ethereum Goerli testnet. Goerli is new at the time of writing, RIP Rinkeby.
The smart contract has a URI that was set to a url that returns metadata. The data structure looks like this
```
{
    name: Blessed by Grassley,
    description: Today, we are truly blessed.
    image: imgur link
} 
```

I ran into some issues here where OpenSea would not provide a preview of my
linked image. OpenSea could not fetch my json from my endpoint, after multiple different urls I ended up hosting the metadata on IPFS and
used the ipfs endpoint in order for my metadata to be fetched. At the time of writing OpenSea did not provide previews due to a null uri_token.
Rarible on the otherhand had no issues and previewed my image perfectly.


My first ever contract was deployed on Goerli to 0x7FB383937344C03cb1Cf456795446C786209eBC5
This version has off-chain data hosted on IPFS: 0x3c82b9345f3E216AdF0B6a0Dec7Ee682850C80d1


## Minting NFTs with static SVGs & On-chain hosting.
This was kinda wild learning that SVGs can be encoded/decoded by a browser. I learned I could encode an SVG using <a href="https://www.utilities-online.info/base64?utm_source=buildspace.so&utm_medium=buildspace_project">Base64</a> and paste it into my browser to see it.

```
data:image/svg+xml;base64,INSERT_YOUR_BASE64_ENCODED_SVG_HERE
```

This allows us to ditch the URI in the JSON metadata and use the encoded string instead. We just point to the string instead.
BUT WAIT, if the site we used to host our json metadata goes down, we'll lose Troy forever. <b>So let's encode the whole JSON file</b>.
Our browser can parse this as well,

```
data:application/json;base64,INSERT_YOUR_BASE64_ENCODED_JSON_HERE
```

Now we have a way to keep our JSON permanent until the heatdeath of the universe. Maybe even a little bit after that... is what I would say if the Ethereum blockchain had not introduced a size limit of 24576 bytes with the arrival of our friend <a href="https://ethereum.org/en/developers/tutorials/downsizing-contracts-to-fight-the-contract-size-limit/"><b>Spurious Dragon</b></a>. So while we may have an exact encoding of our savior Troy Grassley, it is too mighty for the blockchain to hold.

### The Front End
This part was cool, we created a React app and used Ethers along with the metamask ethereum object to interact with our smart contract from the browser. My front end is currently hosted on Netlify <a href="https://warm-bavarois-e3d195.netlify.app/">here</a>. This was a wild experience as I hadn't used React much. Learning about state hooks and how to work with this library was awesome.