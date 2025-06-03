const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
    // Get the contract factory
    const MyToken = await hre.ethers.getContractFactory("MyToken");

    // Use ethers.parseUnits instead of hre.ethers.utils.parseUnits
    const initialSupply = hre.ethers.parseUnits("1000000", 18); 

    // Deploy contract
    const myToken = await MyToken.deploy(initialSupply);
    await myToken.waitForDeployment(); // Replace deployed() with waitForDeployment()

    console.log("MyToken deployed to:", await myToken.getAddress()); // Updated way to get address
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
