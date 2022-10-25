require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    hardhat: {
    },
    fantomtest: {
      url: process.env.Fantom_Testnet_RPC_PROVIDER,
      accounts: [process.env.PRIVATE_KEY]
    },
    goerli: {
      url: process.env.Goerli_RPC_PROVIDER,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: { polygon: process.env.POLYGONSCAN_API_KEY }
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};
