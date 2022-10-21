// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract MessageSenderProxy {
    address public messageSender;

    function receiverContract(uint256 chainID)
        public
        view
        virtual
        returns (address);

    function sendMessage(
        uint256 toChainID,
        address toContract,
        bytes memory message
    ) external payable returns (bool succ) {
        require(
            msg.sender == messageSender,
            "MessageSender: message sender is not trusted"
        );
        return _sendMessage(toChainID, toContract, message);
    }

    function _sendMessage(
        uint256 toChainID,
        address toContract,
        bytes memory message
    ) internal virtual returns (bool succ);
}
