// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../MessageProxy.sol";
import "../IMessageReceiver.sol";

interface IAnycallProxy {
    function anyCall(
        address _to,
        bytes calldata _data,
        uint256 _toChainID,
        uint256 _flags,
        bytes calldata _extdata
    ) external payable;

    function executor() external view returns (address);

    function deposit(address _account) external payable;

    function withdraw(uint256 _amount) external;
}

interface IExecutor {
    function context()
        external
        view
        returns (
            address from,
            uint256 fromChainID,
            uint256 nonce
        );
}

contract AnyCallV7Adaptor is MessageProxy {
    IAnycallProxy public anyCallProxy;

    constructor() {}

    function setAnyCallProxy(address anyCallProxy_) external {
        anyCallProxy = IAnycallProxy(anyCallProxy_);
        provider = anyCallProxy.executor();
    }

    function setReceiver(address receiver_) external {
        receiver = IMessageReceiver(receiver_);
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
        anyCallProxy.anyCall(toContract, message, toChainID, 0, "");
        return true;
    }

    function anyExecute(bytes calldata data)
        external
        returns (bool success, bytes memory result)
    {
        (address sender, uint256 fromChainID, ) = IExecutor(
            anyCallProxy.executor()
        ).context();
        onReceiveMessage(fromChainID, sender, data);
        return (true, "");
    }
}
