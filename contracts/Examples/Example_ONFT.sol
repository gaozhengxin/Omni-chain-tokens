// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../NFT_Gateway.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Example_Omni_Chain_NFT is NFT_Gateway, ERC721Enumerable {
    constructor() ERC721("Omni chain NFT", "ONFT") {}

    function _onSendingToken(address tokenSender, uint256 tokenId)
        internal
        override
        returns (bool succ)
    {
        _burn(tokenId);
        return true;
    }

    function _onReceiveToken(address receiver, uint256 tokenId)
        internal
        override
        returns (bool succ)
    {
        _mint(receiver, tokenId);
        return true;
    }

    function mint(uint256 tokenId) external {
        _mint(msg.sender, tokenId);
    }
}
