/*
TimeLock is a contract where transactions must be queued for some minimum time before it can be executed.

It's usually used in DAO to increase transparency. Call to critical functions are restricted to time lock.

This give users time to take action before the transaction is executed by the time lock.

For example, TimeLock can be used to increase users' trust that the DAO will not rug pull.

Here is the contract that will be used to test TimeLock

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestTimeLock {
    address public timeLock;
    bool public canExecute;
    bool public executed;

    constructor(address _timeLock) {
        timeLock = _timeLock;
    }

    fallback() external {}

    function func() external payable {
        require(msg.sender == timeLock, "not time lock");
        require(canExecute, "cannot execute this function");
        executed = true;
    }

    function setCanExecute(bool _canExecute) external {
        canExecute = _canExecute;
    }
}

error AlreadyQueuedError(bytes32);
error TimestampNotInRangeError(uint, uint);
error NotQueuedError(bytes32);
error TimestampNotPassedError(uint, uint);
error TimestampExpiredError(uint, uint);

contract TimeLock {
    event Queue(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );
    event Execute(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );
    event Cancel(bytes32 indexed txId);

    uint public constant MIN_DELAY = 10; // seconds
    uint public constant MAX_DELAY = 1000; // seconds
    uint public constant GRACE_PERIOD = 1000; // seconds

    address public owner;
    // tx id => queued
    mapping(bytes32 => bool) public queued;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function getTxId(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) public pure returns (bytes32) {
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    /**
     * @param _target Address of contract or account to call
     * @param _value Amount of ETH to send
     * @param _func Function signature, for example "foo(address,uint256)"
     * @param _data ABI encoded data send.
     * @param _timestamp Timestamp after which the transaction can be executed.
     */
    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external returns (bytes32 txId) {
        // code
        require(owner == msg.sender);
        bytes32 _idx = getTxId(_target, _value, _func, _data, _timestamp);

        if (queued[_idx]) {
            revert AlreadyQueuedError(_idx);
        }

        if (
            _timestamp < MIN_DELAY + block.timestamp ||
            _timestamp > MAX_DELAY + block.timestamp
        ) {
            revert TimestampNotInRangeError(block.timestamp, _timestamp);
        }

        queued[_idx] = true;

        emit Queue(_idx, _target, _value, _func, _data, _timestamp);

        return _idx;
    }

    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external payable returns (bytes memory) {
        // code
        require(owner == msg.sender);
        bytes32 _idx = getTxId(_target, _value, _func, _data, _timestamp);

        if (!queued[_idx]) {
            revert NotQueuedError(_idx);
        }

        // timestamp    timestamp + grace period
        if (_timestamp > block.timestamp) {
            revert TimestampNotPassedError(block.timestamp, _timestamp);
        }

        if (block.timestamp > _timestamp + GRACE_PERIOD) {
            revert TimestampExpiredError(
                block.timestamp,
                _timestamp + GRACE_PERIOD
            );
        }

        queued[_idx] = false;

        bytes memory data;

        if (bytes(_func).length > 0) {
            // data = func selector + _data
            bytes4 sig = bytes4(keccak256(bytes(_func)));
            data = abi.encodePacked(sig, _data);
        } else {
            data = _data;
        }

        (bool success, bytes memory res) = _target.call{value: _value}(data);
        require(success, "tx failed");

        emit Execute(_idx, _target, _value, _func, _data, _timestamp);

        return res;
    }

    function cancel(bytes32 _txId) external {
        // code
        require(owner == msg.sender);
        if (!queued[_txId]) {
            revert NotQueuedError(_txId);
        }

        queued[_txId] = false;
        emit Cancel(_txId);
    }
}
