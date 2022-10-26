// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MessageProxy.sol";
import "./IMessageReceiver.sol";

abstract contract NFT_Gateway is IMessageReceiver {
    MessageProxy public messageProxy;

    event Send(
        uint256 toChainID,
        address sender,
        address receiver,
        uint256 tokenId
    );
    event Receive(
        uint256 fromChainID,
        address tokenSender,
        address tokenReceiver,
        uint256 tokenId
    );

    function setMessageProxy(address messageProxy_) external {
        messageProxy = MessageProxy(messageProxy_);
    }

    function sendToken(
        uint256 toChainID,
        address tokenReceiver,
        uint256 tokenId
    ) external payable returns (bool succ) {
        succ = _onSendingToken(msg.sender, tokenId);
        if (succ) {
            emit Send(toChainID, msg.sender, tokenReceiver, tokenId);
        } else {
            return succ;
        }
        bytes memory message = abi.encode(msg.sender, tokenReceiver, tokenId);
        succ = messageProxy.sendMessage(
            toChainID,
            messageProxy.receiverContract(toChainID),
            message
        );
        return succ;
    }

    /// @dev Phase 1 of a xchain transfer
    /// burn or lock up the token
    function _onSendingToken(address tokenSender, uint256 tokenId)
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
        (address tokenSender, address tokenReceiver, uint256 tokenId) = abi
            .decode(data, (address, address, uint256));
        bool succ = _onReceiveToken(tokenReceiver, tokenId);
        if (succ) {
            emit Receive(fromChainID, tokenSender, tokenReceiver, tokenId);
        }
    }

    /// @dev Phase 2 of a xchain transfer
    /// mint or unlock the token
    function _onReceiveToken(address receiver, uint256 tokenId)
        internal
        virtual
        returns (bool succ);
}
