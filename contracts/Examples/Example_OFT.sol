// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../FT_Gateway.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Example_Omni_Chain_FT is FT_Gateway, ERC20 {
    constructor() ERC20("Omni chain NFT", "OFT") {}

    function _onSendingToken(address tokenSender, uint256 amount)
        internal
        override
        returns (bool succ)
    {
        _burn(tokenSender, amount);
        return true;
    }

    event Print(uint256 num, address receiver, uint256 amount);

    function _onReceiveToken(address receiver, uint256 amount)
        internal
        override
        returns (bool succ)
    {
        _mint(receiver, amount);
        return true;
    }

    function mint(uint256 amount) external {
        _mint(msg.sender, amount);
    }
}
