const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const { projectID, mnemonic } = require('./secrets.json');

module.exports = {

  plugins: ["truffle-security"],

  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
//  contracts_build_directory: path.join(__dirname, "client/src/contracts"),

  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
//      gas: 7000000,
//      gasPrice: 20000000000
    },

    ropsten: {
      provider: () => new HDWalletProvider(
        mnemonic, 'https://ropsten.infura.io/v3/' + projectID
      ),
      networkId: 3,
    },

    mainnet: {
      provider: () => new HDWalletProvider(
        mnemonic, 'https://mainnet.infura.io/v3/' + projectID
      ),
      networkId: 1,
    }
  },
  compilers: {
    solc: {
      version: "0.8.4", // change this to download new compiler, cool!
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
};
