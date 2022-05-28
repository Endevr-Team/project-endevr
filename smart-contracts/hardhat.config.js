require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  defaultNetwork: "rinkeby",
  solidity: "0.8.7",
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_URL,
      accounts: [process.env.RINKEBY_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_APIKEY,
  }
};


//npx hardhat run scripts/deploy.js --network rinkeby

//npx hardhat verify --network rinkeby 0x045a16Fd97726017118819F3ae70AE2FC3B16C63 "0xd35FB17D2fF9725594C632D00b41F2C4D5B524A6"