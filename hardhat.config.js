require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
        url: process.env.RPC_URL,
        accounts: [process.env.PRIVATE_KEY],
    },
}
};
