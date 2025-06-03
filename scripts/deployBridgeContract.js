const hre = require("hardhat");

async function main() {
    const SepoliaBridge = await hre.ethers.getContractFactory("SepoliaBridge");
    const bridge = await SepoliaBridge.deploy(process.env.OWNER_ADDRESS);

    await bridge.waitForDeployment();
    console.log(`Bridge Contract Deployed at: ${await bridge.getAddress()}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
