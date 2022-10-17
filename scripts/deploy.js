const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('GrassleyCollection');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log('Contract deployed to: ', nftContract.address);

    //call the function.
    let txn = await nftContract.getBlessed();
    //wait for it to be mined
    await txn.wait();
    console.log('NFT minted #1');

    txn = await nftContract.getBlessed();
    await txn.wait();
    console.log('NFT 2 minted');
};

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