const hre = require("hardhat");

const oftaddrs = {
    "fantomtest": "0x62866B0dc76B683Dd5675c5b1d1344d3f399ebbA",
    "goerli": "0x0A69B1D1Fb0D306C29f2e96e85E9069C9593C414"
}

const chains = {
    "fantomtest": 4002,
    "goerli": 5
}

async function main() {
    const [owner] = await ethers.getSigners();


    let oft = await ethers.getContractAt("Example_Omni_Chain_FT", oftaddrs[hre.network.name]);
    let tx = await oft.mint(1234000000000000);
    let rc = await tx.wait();
    console.log(
        `mint OFT at tx ${rc.transactionHash}`
    );

    var toChainID;
    // select a chain
    for (var chainname in chains) {
        if (chainname !== hre.network.name) {
            toChainID = chains[chainname];
            break;
        }
    }
    console.log(`toChainID is ${toChainID}`);
    let tx2 = await oft.sendToken(toChainID, owner.address, 234000000000000);
    let rc2 = await tx2.wait();
    console.log(
        `initiate send OFT request to chain ${toChainID} at tx ${rc2.transactionHash}`
    );
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
