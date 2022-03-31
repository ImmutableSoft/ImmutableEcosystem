const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const { projectID, mnemonicPhrase } = require('./secrets.json');

var optimism_mnemonic = 'test test test test test test test test test test test junk'
module.exports = {

  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),

  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
      gasPrice: 30000000000  // 50gwei Estimate real world ETH costs
    },
    optimistic: {
      provider: () => new HDWalletProvider(optimism_mnemonic, "http://127.0.0.1:8545/"),
      network_id: "420",
      gasPrice: 120000000000  // 120gwei Estimate real world L2 costs
    },
    optimistic_kovan: {
      provider: () => new HDWalletProvider(
        mnemonicPhrase, "https://kovan.optimism.io"
      ),
      network_id: '69'
    },
    optimistic_mainnet: {
      provider: () => new HDWalletProvider(
        optimism_mnemonic/*mnemonicPhrase*/, "https://mainnet.optimism.io"
      ),
      network_id: '10'
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
        mnemonicPhrase, 'https://mainnet.infura.io/v3/' + projectID
      ),
      networkId: 1,
    },
    //polygon Infura mainnet
    polygon_infura_mainnet: {
      provider: () => new HDWalletProvider(
        mnemonicPhrase, 'https://polygon-mainnet.infura.io/v3/' + projectID
      ),
      network_id: 137,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      chainId: 137
    },
    polygon_alchemy_mainnet: {
      provider: () => new HDWalletProvider(
        mnemonicPhrase, 'https://polygon-mainnet.g.alchemy.com/v2/' + projectID
      ),
      network_id: 137,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      chainId: 137
    },
    polygon_mainnet: {
      provider: () => new HDWalletProvider(
        mnemonicPhrase, 'https://polygon-rpc.com/'
      ),
      network_id: 137,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      chainId: 137,
      gasPrice: 40000000000  // 32gwei Estimate real world ETH costs
    },
    //polygon Testnet
    polygon_testnet: {
      provider: () => new HDWalletProvider(
        mnemonicPhrase, "https://matic-mumbai.chainstacklabs.com"
      ),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      chainId: 80001
    },
    //polygon Infura testnet
    polygon_infura_testnet: {
      provider: () => new HDWalletProvider(
        mnemonicPhrase, "https://polygon-mumbai.infura.io/v3/" + projectID
      ),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      chainId: 80001
    }
  },

  compilers: {
    solc: {
      version: "0.8.11", // change this to download new compiler, cool!
      settings: {
        optimizer: {
          enabled: true,
          runs: 2000,
          details: {
            // Removes duplicate code blocks
            deduplicate: true,

            // Common subexpression elimination, this is the most complicated step but
            // can also provide the largest gain.
            cse: true,

            // Optimize representation of literal numbers and strings in code.
            constantOptimizer: true,

            // The new Yul optimizer. Mostly operates on the code of ABI coder v2
            // and inline assembly.
            // It is activated together with the global optimizer setting
            // and can be deactivated here.
            // Before Solidity 0.6.0 it had to be activated through this switch.
            "yul": true,

            // Tuning options for the Yul optimizer.
            "yulDetails": {
              // Improve allocation of stack slots for variables, can free up stack slots early.
              // Activated by default if the Yul optimizer is activated.
              "stackAllocation": true
              // Select optimization steps to be applied.
              // Optional, the optimizer will use the default sequence if omitted.
//              "optimizerSteps": "dhfoDgvulfnTUtnIf..."
            }
          }
        },
        // Version of the EVM to compile for.
        // Affects type checking and code generation. Can be homestead,
        // tangerineWhistle, spuriousDragon, byzantium, constantinople, petersburg, istanbul or berlin
        evmVersion: "london",

        // Optional: Change compilation pipeline to go through the Yul intermediate representation.
        // This is a highly EXPERIMENTAL feature, not to be used for production. This is false by default.
//        "viaIR": true,

        debug: {
          // How to treat revert (and require) reason strings. Settings are
          // "default", "strip", "debug" and "verboseDebug".
          // "default" does not inject compiler-generated revert strings and keeps user-supplied ones.
          // "strip" removes all revert strings (if possible, i.e. if literals are used) keeping side-effects
          // "debug" injects strings for compiler-generated internal reverts, implemented for ABI encoders V1 and V2 for now.
          // "verboseDebug" even appends further information to user-supplied revert strings (not yet implemented)
          revertStrings: "default",
          // Optional: How much extra debug information to include in comments in the produced EVM
          // assembly and Yul code. Available components are:
          // - `location`: Annotations of the form `@src <index>:<start>:<end>` indicating the
          //    location of the corresponding element in the original Solidity file, where:
          //     - `<index>` is the file index matching the `@use-src` annotation,
          //     - `<start>` is the index of the first byte at that location,
          //     - `<end>` is the index of the first byte after that location.
          // - `snippet`: A single-line code snippet from the location indicated by `@src`.
          //     The snippet is quoted and follows the corresponding `@src` annotation.
          // - `*`: Wildcard value that can be used to request everything.
          debugInfo: ["location", "snippet"]
        },
      }
    }
  },
  
  plugins: [
    'truffle-contract-size'
  ]
};
