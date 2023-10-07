/*

Implement a multi sig wallet.

Tasks:

    - Enable this contract to receive Ether. Emit Deposit.

    - Write a function to submit a transaction to be approved by other owners.
        Function submit(address _to, uint _value, bytes calldata _data) external stores the inputs into the array transactions
        Emits Submit with txId equal to the index where the transaction is stored in the array transactions
        Only the owners can call this function

    - Write function to approve a pending transaction.
        approve(uint _txId) approves the pending transaction with the id _txId.
        this function is external
        only owners can call this function
        transaction having _txId must exist
        transaction must not be executed yet
        transaction must not be approved by msg.sender
        emit Approve

    - Write function to execute a pending transaction where number of approvals is greater than or equal to required.
        execute(uint _txId) executes transaction at transcations[_txId]
        this function is external
        only owners can call
        transcaction must exist
        transaction must not be executed yet
        number of approvals for this transaction must be greater than or equal to required
        emit Execute

    - Write function to cancel approval.
        revoke(uint _txId) cancels approval of transaction _txId approved by msg.sender
        this function is external
        only owners can call
        transaction must exist
        transaction must not be executed yet
        check that transaction is approved by msg.sender
        emit Revoke

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;

    Transaction[] public transactions;

    // mapping from tx id => owner => bool
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint _txId) {
        require(_txId < transactions.length, "tx does not exist");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owners required");
        require(
            _required > 0 && _required <= _owners.length,
            "invalid required number of owners"
        );

        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(
        address _to,
        uint _value,
        bytes calldata _data
    ) external onlyOwner {
        Transaction memory transaction = Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        });
        transactions.push(transaction);
        uint _txId = transactions.length - 1;
        emit Submit(_txId);
    }

    function approve(
        uint _txId
    ) external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getApprovalCount(uint _txId) private view returns (uint count) {
        for (uint i = 0; i < owners.length; i++) {
            address owner = owners[i];
            if (approved[_txId][owner]) {
                count += 1;
            }
        }
        return count;
    }

    function execute(
        uint _txId
    ) external onlyOwner txExists(_txId) notExecuted(_txId) {
        require(_getApprovalCount(_txId) >= required, "approvals < required");
        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "tx failed");

        emit Execute(_txId);
    }

    function revoke(
        uint _txId
    ) external onlyOwner txExists(_txId) notExecuted(_txId) {
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}