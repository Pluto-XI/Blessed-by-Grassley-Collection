import React, { useEffect, useState } from 'react';
import './styles/App.css';
import buildSpaceLogo from './assets/buildspace.png';
import { ethers } from 'ethers';
import getBlessed from './utils/getBlessed.json';
import HashLoader from 'react-spinners/HashLoader';

// Constants
const OPENSEA_LINK = 'https://testnets.opensea.io/collection/blessed-by-grassley-cs80iaqlei';
const CONTRACT_ADDRESS = "0xb13D67DcDB198e5396748d2346194aA25543b455";

// let shouldBeginInterval = true;


const App = () => {
  const [mintCount, setMintCount] = useState("");
  const [currentAccount, setCurrentAccount] = useState("");
  const [miningAnimation, setMiningAnimation] = useState(false);
  
  
  const checkIfWalletIsConnected = async () => {
    const { ethereum } = window;

    if (!ethereum) {
      console.log("Make sure you have metamask!");
    } else {
      console.log("We have the object!");
    }

  const accounts = await ethereum.request({ method: 'eth_accounts' });


  if (accounts.length !== 0) {
    const account = accounts[0];
    console.log("Found an authorized account ", account);
    setCurrentAccount(account);

    setUpEventListener();
  } else {
    console.log("No account found");
  }

  };

const connectWallet = async () => {
  try {
    const { ethereum } = window;

    if (!ethereum) {
      alert("Get metamask");
      return;
    }

    const accounts = await ethereum.request({ method: "eth_requestAccounts" });

    console.log("Connected", accounts[0]);
    setCurrentAccount(accounts[0]);
    setUpEventListener();

    // if (accounts[0]) {
    //   updateCurrentCount();
    // }
  } catch(error) {
    console.log(error);
  }
};


  const setUpEventListener = async () => {
    // Most of this looks the same as our function askContractToMintNft
    try {
      const { ethereum } = window;

      if (ethereum) {
        // Same stuff again
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, getBlessed.abi, signer);
        updateCurrentCount()

        // THIS IS THE MAGIC SAUCE.
        // This will essentially "capture" our event when our contract throws it.
        // If you're familiar with webhooks, it's very similar to that!
        connectedContract.on("NewIndividualBlessed", (from, tokenId) => {
          console.log(from, tokenId.toNumber())
          alert(`Hey there! We've minted your NFT and sent it to your wallet. It may be blank right now. It can take a max of 10 min to show up on OpenSea. Here's the link: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}`)
        });

        console.log("Setup event listener!")

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

  

const askContractToMintNft = async () => {
    try {
      if (ethereum) {

        let chainId = await ethereum.request({ method: 'eth_chainId' });
        console.log("Connected to chain " + chainId);
        
        // String, hex code of the chainId of the Rinkebey test network
        const goerliChainId = "0x5"; 
        if (chainId !== goerliChainId) {
        	alert("You are not connected to the Goerli Test Network!, please make sure to connect or else you'll lose your ETH!");
        } else {
        
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, getBlessed.abi, signer);

        console.log("Pop that wallet and pay gas");
        let nftTxn = await connectedContract.getBlessed();

        //Start animation
        setMiningAnimation(true);
    

        console.log("Please wait... mining");
        await nftTxn.wait();

        //End animation
        setMiningAnimation(false);

        //Set element on view to show the NFT url

        console.log(`Mined, see transaction: https://goerli.etherscan.io/tx/${nftTxn.hash}`);
        } 
      } else {
        console.log("Ethereum Object doesn't exist");
      }
    } catch(error) {
      console.log(error);
    }
};


  //Set a while loop to show the current count of listed nfts.
const updateCurrentCount = async () => {
  console.log("HIT");
  try {
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, getBlessed.abi, signer);

        // if (shouldBeginInterval) {
          // shouldBeginInterval = false;
          setInterval(() => {
          connectedContract.getCurrentTokens()
            .then((txn) => {
              setMintCount(txn);
              console.log("tick");
            });
          }, 3500)
        // }
      }
  } catch(error) {
    console.log(error);
  }
};
  
  
  // Render Methods
  const renderNotConnectedContainer = () => (
    <button onClick={connectWallet} className="cta-button connect-wallet-button">
      Connect to Wallet
    </button>
  );



  useEffect(() => {
    checkIfWalletIsConnected();
  }, []);


return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">The Blessed by Grassley Collection</p>
          <p className="sub-text">
            Each unique. Each beautiful. Today we are truly blessed.
          </p>
          <div className={miningAnimation ? "spinner-container" : ""}>{miningAnimation ? <HashLoader color="#efa530" /> : ""}</div>
          {currentAccount === "" 
              ? renderNotConnectedContainer()
              : (
                /** Add askContractToMintNft Action for the onClick event **/
                <div>    
                <h2 className={mintCount ? "animate-in height-animation":"no-height height-animation"}>{mintCount} Individuals Blessed 🙏</h2>
                <button onClick={askContractToMintNft} className="cta-button connect-wallet-button">
                  Get Blessed
                </button>
                </div>
              )
            }
          <a className="cta-button opensea-button" target="_blank" href={OPENSEA_LINK}>
           🌊 View Collection On OpenSea
          </a>
        </div>
        <div className="container body-text">
          <p>Welcome to the Troy Grassley NFT Collection! This was a project to learn more about the Ethereum blockchain. If you're interested in seeing the source code and how this was built, please take a look at the <a target="_blank" href="https://github.com/Pluto-XI/Blessed-by-Grassley-Collection">github repo.</a></p>
          <a target="_blank" href="https://goerlifaucet.com">Need some ETH?</a>
        </div>
        <div className="footer-container">
          <img alt="Buildspace Logo" className="twitter-logo" src={buildSpaceLogo} />
          <a
            className="footer-text"
            href="https://buildspace.so/"
            target="_blank"
            rel="noreferrer"
          >{`Thank you to the buildspace community!`}</a>
        </div>
      </div>
    </div>
  );
};

export default App;