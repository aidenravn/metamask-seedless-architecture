require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle"); // Testler için chai + waffle desteği

module.exports = {
  solidity: "0.8.20",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337, // Hardhat varsayılan lokal chain id
    },
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
    },
    // Testnet eklemek istersen örnek:
    // goerli: {
    //   url: "https://goerli.infura.io/v3/YOUR_INFURA_KEY",
    //   accounts: ["PRIVATE_KEY"]
    // }
  },
  mocha: {
    timeout: 20000, // Testlerin yeterli süre alması için
  },
};
