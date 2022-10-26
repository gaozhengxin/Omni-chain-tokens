// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IMessageReceiver.sol";

abstract contract MessageReceiverProxy {
    address public provider;
    IMessageReceiver public messageReceiver;

    function isTrustedSender(uint256 chainID, address sender)
        public
        view
        virtual
        returns (bool);

    function onReceiveMessage(
        uint256 fromChainID,
        address sender,
        bytes memory data
    ) public {
        require(
            msg.sender == provider,
            "MessageReceiver: provider is not trusted"
        );
        require(
            isTrustedSender(fromChainID, sender),
            "MessageReceiver: message sender is not trusted"
        );
        messageReceiver.onReceiveMessage(fromChainID, sender, data);
    }
}
