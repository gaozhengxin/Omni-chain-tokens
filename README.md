## Steps to develop an omni chain fungible or non-fungible token (OFT or ONFT)
1. Write a token contract (ERC20 or ERC721).
2. Write a token gateway contract that implements the interface `FT_Gateway` or `NFT_Gateway`. This can be embedded into the token contract.
3. Select a crosschain messaging service.
4. Write an adaptor contract that implements the interface `MessageProxy`.
5. Deploy the adaptor, token and gateway on each chain.
6. Set the adaptor as trusted in the gateway contract on each chain.
7. Set `messageSender` and `messageReceiver` to the gateway contract in the adaptor on each chain.
8. Set each other adaptor as trusted foriegn message sender.
9. Complete deployment!

## Use the scripts
1. Deploy example OFT and adaptor for AnyCall V7.
```sh
npx hardhat run ./scripts/deployOFT.js --network fantomtest
npx hardhat run ./scripts/deployOFT.js --network goerli
```
2. Modify the addresses in `configOFT.js` and run
```js
const anyCallConfig = {
    "fantomtest": "0x470BFEE42A801Abb9a1492482d609fB84713d60F",
    "goerli": "0x7EA2be2df7BA6E54B1A9C70676f668455E329d29"
}

// anycall adaptor addresses
const peers = {
    "fantomtest": "0x02594328E83682acDBbE06e0bf01C71c43E3f663",
    "goerli": "0x62866B0dc76B683Dd5675c5b1d1344d3f399ebbA"
}
```
```sh
npx hardhat run ./scripts/configOFT.js --network fantomtest
npx hardhat run ./scripts/configOFT.js --network goerli
```
3. Try making a crosschain transfer
```sh
npx hardhat run ./scripts/sendOFT.js --network fantomtest
```