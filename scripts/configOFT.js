const hre = require("hardhat");

const anyCallConfig = {
    "fantomtest": "0x470BFEE42A801Abb9a1492482d609fB84713d60F",
    "goerli": "0x7EA2be2df7BA6E54B1A9C70676f668455E329d29"
}

// anycall adaptor addresses
const peers = {
    "fantomtest": "0x02594328E83682acDBbE06e0bf01C71c43E3f663",
    "goerli": "0x62866B0dc76B683Dd5675c5b1d1344d3f399ebbA"
}

const chains = {
    "fantomtest": 4002,
    "goerli": 5
}

async function main() {
    let anycallAdaptor = await ethers.getContractAt("AnyCallV7Adaptor", peers[hre.network.name]);

    for (var chainname in chains) {
        if (chainname === hre.network.name) {
            continue;
        }
        let tx = await anycallAdaptor.setPeer(chains[chainname], peers[chainname]);
        let rc = await tx.wait();
        console.log(
            `setPeer for contract ${peers[chainname]} from chain ${chainname} at tx ${rc.transactionHash}`
        );
    }

    let anycallConfig = await ethers.getContractAt("MockAnycallConfig", anyCallConfig[hre.network.name]);
    for (var chainname in peers) {
        if (chainname === hre.network.name) {
            continue;
        }
        let tx = await anycallConfig.deposit(peers[chainname], {
            value: ethers.utils.parseEther("0.1")
        });
        let rc = await tx.wait();
        console.log(
            `deposit for contract ${peers[chainname]} from chain ${chainname} at tx ${rc.transactionHash}`
        );
    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
