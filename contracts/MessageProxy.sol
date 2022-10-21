// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MessageSenderProxy.sol";
import "./MessageReceiverProxy.sol";

abstract contract MessageProxy is MessageSenderProxy, MessageReceiverProxy {}
