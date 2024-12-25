import { ethers } from "hardhat";

async function main() {

    let wallet = (await ethers.getSigners())[0];
    // Contract details
    const name = "ManagedToken";
    const symbol = "MTK";
    const initialSupply = 1000 
    const initialWhitelist = [
        await wallet.getAddress(),
        "0x9D8f437EEEDCC61d1fa8F363dCE54DAfC1047e7c",
        "0x8675cF0A11b556b20De75E85EFA2AFb8cFED0793",
        "0x98959C1A81e2aB56633860571403fD60f421c31C",
        "0x937ABdc45eF6BA7aBe8E9f30871dE8A18EAADfda",
    ]; // Replace with actual wallet addresses

    // Get the contract factory
    const ManagedToken = await ethers.getContractFactory("ManagedToken", wallet);

    // Deploy the contract
    console.log("Deploying ManagedToken contract...");
    const managedToken = await ManagedToken.deploy(
        name,
        symbol,
        initialSupply,
        initialWhitelist
    );

    // Wait for deployment to complete
    await managedToken.waitForDeployment();

    console.log(`ManagedToken deployed to: ${await managedToken.getAddress()}`);
}

// Catch errors and exit process
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});