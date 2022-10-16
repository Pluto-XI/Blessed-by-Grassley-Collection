### Blessed by Grassley Collection

This is an NFT collection made in order to learn a bit about the ethereum blockchain.

### Welcome to the Grassley NFT collection source code.
I am an aspiring dev looking to get my foot in the door. Here's what I learned while making this project.

### What the hell is an NFT?
An NFT is a "token" that a person can own that links to some piece of "data" (ex. a link to a piece of digital art, a video, an image, etc). The trick with NFTs is that each "token" has a unique identifier that lets the owner prove that it's one of a kind.


## Setting up my local environment
The NFT collection was developed using Hardhat to run a local blockchain. Ethers and OpenZeppelin libraries.

Hardhat compiles my smart contracts from Solidity to evm bytecode, spun up a local blockchain, and deployed a smart contract to this local instance.

## Writing a test contract
I learned it's good practice to include an SPDX license on the first line, these can be read up on here: https://spdx.org/licenses/
You need to declare the version of the Solidity compiler the contract should use with a pragma. 

The contract keyword looks like a class in other languages.

## ERC 721
ERC 721 is the NFT standard, I used OpenZeppelin to implement the standard and wrote my own logic on top of it. No boiler plate had to be
written due to this. Just like writing an HTTP server from scratch would be crazy, similarly it would be nuts to write an NFT contract from complete scratch.
Here is the standard I imported: <a href="https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol?utm_source=buildspace.so&utm_medium=buildspace_project">ERC 721</a>