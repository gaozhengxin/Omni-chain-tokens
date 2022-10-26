// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MessageProxy.sol";
import "./IMessageReceiver.sol";

abstract contract FT_Gateway is IMessageReceiver {
    MessageProxy public messageProxy;

    event Send(
        uint256 toChainID,
        address sender,
        address receiver,
        uint256 amount
    );
    event Receive(
        uint256 fromChainID,
        address tokenSender,
        address tokenReceiver,
        uint256 amount
    );

    function setMessageProxy(address messageProxy_) external {
        messageProxy = MessageProxy(messageProxy_);
    }

    function sendToken(
        uint256 toChainID,
        address tokenReceiver,
        uint256 amount
    ) external payable returns (bool succ) {
        succ = _onSendingToken(msg.sender, amount);
        if (succ) {
            emit Send(toChainID, msg.sender, tokenReceiver, amount);
        } else {
            return succ;
        }
        bytes memory message = abi.encode(msg.sender, tokenReceiver, amount);
        succ = messageProxy.sendMessage(
            toChainID,
            messageProxy.receiverContract(toChainID),
            message
        );
        return succ;
    }

    /// @dev Phase 1 of a xchain transfer
    /// burn or lock up the token
    function _onSendingToken(address tokenSender, uint256 amount)
        internal
        virtual
        returns (bool succ);

    function onReceiveMessage(
        uint256 fromChainID,
        address sender,
        bytes memory data
    ) public override {
        require(
            msg.sender == address(messageProxy),
            "FT_Gateway: msg sender is not trusted"
        );
        (address tokenSender, address tokenReceiver, uint256 amount) = abi
            .decode(data, (address, address, uint256));
        bool succ = _onReceiveToken(tokenReceiver, amount);
        if (succ) {
            emit Receive(fromChainID, tokenSender, tokenReceiver, amount);
        }
    }

    /// @dev Phase 2 of a xchain transfer
    /// mint or unlock the token
    function _onReceiveToken(address receiver, uint256 amount)
        internal
        virtual
        returns (bool succ);
}
