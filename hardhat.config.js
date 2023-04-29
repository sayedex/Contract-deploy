/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-etherscan");
require('hardhat-deploy');
require("@uniswap/hardhat-v3-deploy");


const ALCHEMY_API_KEY = "Tv277_RjwkXDuii_WGiG_X8RL-T56yyG";
const ROPSTEN_PRIVATE_KEY ="your metamask private key..";
module.exports = {
  solidity: {
    version: "0.8.16",
    settings: {
      optimizer: {
        enabled: true,
        runs: 5000,
        details: { yul: false },

      },
    },
  },
  //999999
  networks: {
    eth: {
      url: `https://eth-mainnet.gateway.pokt.network/v1/5f3453978e354ab992c4da79`,
      accounts: [`0x${ROPSTEN_PRIVATE_KEY}`],
      timeout: 10000000,
    }


  },
  etherscan: {
      apiKey:'J54EJGCX1WZHIQIG83UMFYVCZF83TR97ZI' //eth
    },
};


//npx hardhat run  scripts/deploy.js --network bsctest
