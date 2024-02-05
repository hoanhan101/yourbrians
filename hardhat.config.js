/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  mocha: {
    timeout: 100000000,
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1337,
      },
      evmVersion: "paris",
      viaIR: true,
    },
  },
  networks: {
    hardhat: {},
    "base-sepolia": {
      url: process.env.SEPOLIA_PROVIDER,
      accounts: [process.env.SEPOLIA_PRIVATE_KEY],
      gasPrice: 1000000000,
    },
    "base-mainnet": {
      url: process.env.MAINNET_PROVIDER,
      accounts: [process.env.MAINNET_PRIVATE_KEY],
      gasPrice: 1000000000,
    },
  },
  etherscan: {
    apiKey: {
      "base-sepolia": process.env.BASESCAN_APIKEY,
      "base-mainnet": process.env.BASESCAN_APIKEY,
    },
    customChains: [
      {
        network: "base-sepolia",
        chainId: 84532,
        urls: {
          apiURL: "https://api-sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org",
        },
      },
      {
        network: "base-mainnet",
        chainId: 8453,
        urls: {
          apiURL: "https://api.basescan.org/api",
          browserURL: "https://basescan.org",
        },
      },
    ],
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    gasPrice: 21,
    url: "http://localhost:8545",
  },
};
