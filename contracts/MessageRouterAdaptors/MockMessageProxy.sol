// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../MessageProxy.sol";
import "../IMessageReceiver.sol";

contract MockMessageProxy is MessageProxy {
    event SendMessage(uint256 toChainID, address toContract, bytes message);

    constructor() {}

    function setReceiver(address receiver_) external {
        receiver = IMessageReceiver(receiver_);
    }

    function setProvider(address provider_) external {
        provider = provider_;
    }

    function setMessageSender(address messageSender_) external {
        messageSender = messageSender_;
    }

    mapping(uint256 => address) public peer;

    function isTrustedSender(uint256 chainID, address sender)
        public
        view
        override
        returns (bool)
    {
        return (peer[chainID] == sender);
    }

    function receiverContract(uint256 chainID)
        public
        view
        override
        returns (address)
    {
        return peer[chainID];
    }

    function setPeer(uint256 chainID, address peer_) external {
        peer[chainID] = peer_;
    }

    function _sendMessage(
        uint256 toChainID,
        address toContract,
        bytes memory message
    ) internal override returns (bool succ) {
        emit SendMessage(toChainID, toContract, message);
    }

    function pushMessage(
        uint256 fromChainID,
        address sender,
        bytes calldata data
    ) external returns (bool success, bytes memory result) {
        onReceiveMessage(fromChainID, sender, data);
        return (true, "");
    }
}
