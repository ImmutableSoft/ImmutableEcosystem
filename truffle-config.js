const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const { projectID, mnemonicPhrase } = require('./secrets.json');

var optimism_mnemonic = 'test test test test test test test test test test test junk'
module.exports = {

  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
//  contracts_build_directory: path.join(__dirname, "client/src/contracts"),

  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    optimistic: {
      provider: () => new HDWalletProvider(optimism_mnemonic, "http://127.0.0.1:8545/"),
      network_id: "*"
    },
    optimistic_kovan: {
      provider: () => new HDWalletProvider(
        mnemonicPhrase, 'https://kovan.optimism.io'
      ),
      networkId: '*'
    },
    ropsten: {
      provider: () => new HDWalletProvider(
        mnemonicPhrase, 'https://ropsten.infura.io/v3/' + projectID
      ),
      network_id: '3',
    },
    kovan: {
      provider: () => new HDWalletProvider(
        mnemonicPhrase, 'https://kovan.infura.io/v3/' + projectID
      ),
      network_id: '42',
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
      version: "0.8.9", // change this to download new compiler, cool!
      settings: {
        optimizer: {
          enabled: true,
          runs: 1
        }
      }
    }
  }
};
