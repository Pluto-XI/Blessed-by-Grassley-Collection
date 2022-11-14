/* This file does a couple things
1. Compiles our Solidity code with hardhat
2. Deploys it to our local instance of the blockchain
3. Our contract runs after being deployed.
*/

const main = async () => {
    //This line will actually compile the contract using ethers and put the files in the artifacts dir.
    //Note HRE isn't imported anywhere, isn't that weird? This is the hardhat runtime environment.
    //When npx hardhat is ran it will build the HRE object on the fly. https://hardhat.org/hardhat-runner/docs/advanced/hardhat-runtime-environment
    const nftContractFactory = await hre.ethers.getContractFactory('GrassleyCollection');
    //Hardhat is creating the network here just for the one contract, once the scripts done the network is getting destroyed.
    const nftContract = await nftContractFactory.deploy();
    //This line waits for the contract to be mined and our consturctor runs when the contract is fully deployed.
    await nftContract.deployed();

    console.log('Contract deployed to:', nftContract.address);

    //Call the NFT contract
    let txn = await nftContract.getBlessed();
    await txn.wait();
    console.log("NFT minted 1");

    txn = await nftContract.getCurrentTokens();
    console.log(txn);

    //Mint another one just cuz
    txn = await nftContract.getBlessed();
    await txn.wait();
    console.log("NFT 2 minted");

    txn = await nftContract.getCurrentTokens();
    console.log(txn);
};


//This function just runs our main function
const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();