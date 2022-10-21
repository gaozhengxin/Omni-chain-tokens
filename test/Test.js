const { expect } = require("chai");

describe("Test omni chain tokens", function () {
    it("Test omni chain FT", async function () {
        const [owner] = await ethers.getSigners();

        // 1. deploy pseudo message proxy
        console.log("\ndeploy pseudo message proxy");
        let PseudoMessageProxy = await ethers.getContractFactory("PseudoMessageProxy");
        let messageProxy = await PseudoMessageProxy.deploy();
        console.log("messageProxy " + messageProxy.address);

        // 2. deploy oft
        console.log("\ndeploy oft");
        let Example_Omni_Chain_FT = await ethers.getContractFactory("Example_Omni_Chain_FT");
        let oft = await Example_Omni_Chain_FT.deploy();
        console.log("oft " + oft.address);

        // 3. config oft, set message proxy
        console.log("\nconfig oft, set message proxy");
        await oft.setMessageProxy(messageProxy.address);

        // 4. config message proxy, set oft as receiver
        console.log("\nconfig message proxy, set oft as receiver");
        await messageProxy.setReceiver(oft.address);

        // 5. config message proxy, set self as trusted
        console.log("\nconfig message proxy, set self as trusted");
        const chainId = hre.network.config.chainId
        await messageProxy.setPeer(chainId, messageProxy.address);
        await messageProxy.setMessageSender(oft.address);
        await messageProxy.setProvider(owner.address);
        expect(await messageProxy.isTrustedSender(chainId, messageProxy.address)).to.equal(true);
        expect(await messageProxy.receiverContract(chainId)).to.equal(messageProxy.address);
        expect(await messageProxy.messageSender()).to.equal(oft.address);

        // 6. mint oft
        console.log("\nmint oft");
        await oft.mint(1000);
        expect(await oft.balanceOf(owner.address)).to.equal(1000);

        // 7. send oft
        console.log("\nsend oft");
        await oft.sendToken(chainId, owner.address, 1000);
        expect(await oft.balanceOf(owner.address)).to.equal(0);

        // 8. receive oft
        console.log("\nreceive oft");
        let message = "0x000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb92266000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb9226600000000000000000000000000000000000000000000000000000000000003e8";
        await messageProxy.pushMessage(chainId, messageProxy.address, message);
        expect(await oft.balanceOf(owner.address)).to.equal(1000);
    });
    it("Test omni chain NFT", async function () {
        const [owner] = await ethers.getSigners();

        // 1. deploy pseudo message proxy
        console.log("\ndeploy pseudo message proxy");
        let PseudoMessageProxy = await ethers.getContractFactory("PseudoMessageProxy");
        let messageProxy = await PseudoMessageProxy.deploy();
        console.log("messageProxy " + messageProxy.address);

        // 2. deploy onft
        console.log("\ndeploy onft");
        let Example_Omni_Chain_NFT = await ethers.getContractFactory("Example_Omni_Chain_NFT");
        let onft = await Example_Omni_Chain_NFT.deploy();
        console.log("onft " + onft.address);

        // 3. config onft, set message proxy
        console.log("\nconfig onft, set message proxy");
        await onft.setMessageProxy(messageProxy.address);

        // 4. config message proxy, set onft as receiver
        console.log("\nconfig message proxy, set onft as receiver");
        await messageProxy.setReceiver(onft.address);

        // 5. config message proxy, set self as trusted
        console.log("\nconfig message proxy, set self as trusted");
        const chainId = hre.network.config.chainId
        await messageProxy.setPeer(chainId, messageProxy.address);
        await messageProxy.setMessageSender(onft.address);
        await messageProxy.setProvider(owner.address);
        expect(await messageProxy.isTrustedSender(chainId, messageProxy.address)).to.equal(true);
        expect(await messageProxy.receiverContract(chainId)).to.equal(messageProxy.address);
        expect(await messageProxy.messageSender()).to.equal(onft.address);

        // 6. mint onft
        console.log("\nmint onft");
        await onft.mint(1000);
        expect(await onft.ownerOf(1000)).to.equal(owner.address);

        // 7. send onft
        console.log("\nsend onft");
        await onft.sendToken(chainId, owner.address, 1000);
        expect(await onft.balanceOf(owner.address)).to.equal(0);

        // 8. receive onft
        console.log("\nreceive onft");
        let message = "0x000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb92266000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb9226600000000000000000000000000000000000000000000000000000000000003e8";
        await messageProxy.pushMessage(chainId, messageProxy.address, message);
        expect(await onft.ownerOf(1000)).to.equal(owner.address);
    });
});