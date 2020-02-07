const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");

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
//      gas: 700000,
//      gasPrice: 20000000000
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/<INFURA_PROJECT_ID>")
      },
      network_id: 3
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
