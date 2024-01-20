// Middleware library for generatic version of universal web3
// interface (ie. MetaMask and Infura).
// Copyright 2020-2023 ImmutableSoft Inc. All rights reserved.
import Web3 from "web3";

var getWeb3 = async () => {
//const getWeb3 = () =>
//  new Promise((resolve, reject) => {
    // Wait for loading completion to avoid race conditions with web3 injection timing.
//    window.addEventListener("load", async () => {
      // Modern dapp browsers...
      if (window.ethereum != null) {
//        alert("Modern");
        const web3 = new Web3(window.ethereum);
        try {
          // Request account access if needed
//          await window.ethereum.enable();
          const subdomainName = window.location.hostname.split(".")[0];
          var chainId;
  
          if ((subdomainName === "127") || (subdomainName === "192") ||
              (subdomainName.toLowerCase() === "mediachain") ||
              (subdomainName.toLowerCase() === "titlechain"))
          {
            chainId = 80001; // Polygon Mumbai Testnet
          } else {
            chainId = 137;// Mainnet
          }
          window.ethereum.accounts = await window.ethereum.request({
                method: "eth_requestAccounts",
            });

          if (window.ethereum.networkVersion !== chainId) {
            try {
              await window.ethereum.request({
                method: 'wallet_switchEthereumChain',
                params: [{ chainId: web3.utils.toHex(chainId) }]
              });
            } catch (err) {
                // This error code indicates that the chain has not been added to MetaMask
              if (err.code === 4902) {

                if ((subdomainName === "127") || (subdomainName === "192") ||
                    (subdomainName.toLowerCase() === "mediachain") ||
                    (subdomainName.toLowerCase() === "titlechain"))
                {
                  await window.ethereum.request({
                    method: 'wallet_addEthereumChain',
                    params: [
                      {
                        chainName: 'Polygon Mumbai Testnet',
                        chainId: web3.utils.toHex(chainId),
                        nativeCurrency: { name: 'MATIC', decimals: 18, symbol: 'MATIC' },
                        rpcUrls: ['https://rpc-mumbai.maticvigil.com']
                      }
                    ]
                  });
                }
                else
                {
                  await window.ethereum.request({
                    method: 'wallet_addEthereumChain',
                    params: [
                      {
                        chainName: 'Polygon Mainnet',
                        chainId: web3.utils.toHex(chainId),
                        nativeCurrency: { name: 'MATIC', decimals: 18, symbol: 'MATIC' },
                        rpcUrls: ['https://polygon-mainnet.chainstacklabs.com']
                      }
                    ]
                  });
                }
              }
            }
          }
    
          // Acccounts now exposed
          return web3;//resolve(web3);
        } catch (error) {
          throw error;//reject(error);
        }
      }
      // Legacy dapp browsers...
      else if (window.web3 != null) {
//        alert("Legacy");
        // Use Mist/MetaMask's provider.
        const web3 = window.web3;
        console.log("Injected web3 detected.");
        return web3;//resolve(web3);
      }
      // Fallback to Infura on Polygon
      else
      {
//        alert("Infura");
          const provider = new Web3.providers.HttpProvider(
   //               "http://127.0.0.1:7545"
             "https://polygon-mainnet.infura.io/v3/6233914717a744d19a2931dfbdd3dddc"
          );
          const web3 = new Web3(provider);
          console.log("No web3 instance injected.");
          return web3;//resolve(web3);
//          reject(error);
      }
//    });
//  });
}
export default getWeb3;
