// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

const anyCallProxy = {
  "fantomtest": "0xfCea2c562844A7D385a7CB7d5a79cfEE0B673D99",
  "goerli": "0x965f84D915a9eFa2dD81b653e3AE736555d945f4"
}

async function main() {
  console.log("\ndeploy anycall adaptor");
  const AnyCallV7Adaptor = await hre.ethers.getContractFactory("AnyCallV7Adaptor");
  const anycallAdaptor = await AnyCallV7Adaptor.deploy();
  console.log(
    `anycallAdaptor deployed to ${anycallAdaptor.address}`
  );

  console.log("\nsetAnyCallProxy");
  setTimeout(() => { }, 3000);
  let tx = await anycallAdaptor.setAnyCallProxy(anyCallProxy[hre.network.name]);
  let rc = await tx.wait();
  console.log(
    `setAnyCallProxy at tx ${rc.transactionHash}`
  );

  console.log("\ndeploy OFT");
  setTimeout(() => { }, 3000);
  const Example_Omni_Chain_FT = await hre.ethers.getContractFactory("Example_Omni_Chain_FT");
  const oft = await Example_Omni_Chain_FT.deploy();

  await oft.deployed();

  console.log(
    `OFT deployed to ${oft.address}`
  );

  console.log("\nsetMessageSender");
  setTimeout(() => { }, 3000);
  let tx2 = await anycallAdaptor.setMessageSender(oft.address);
  let rc2 = await tx2.wait();
  console.log(
    `setMessageSender at tx ${rc2.transactionHash}`
  );

  console.log("\nsetMessageProxy");
  setTimeout(() => { }, 3000);
  let tx3 = await oft.setMessageProxy(anycallAdaptor.address);
  let rc3 = await tx3.wait();
  console.log(
    `setMessageProxy at tx ${rc3.transactionHash}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
