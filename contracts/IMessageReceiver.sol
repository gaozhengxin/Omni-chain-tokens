// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IMessageReceiver {
    function onReceiveMessage(
        uint256 fromChainID,
        address sender,
        bytes memory data
    ) external virtual;
}
