// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiSigWallet {

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;

    struct Transaction {
        address to;
        uint value;
        bool executed;
        uint approvalCount;
    }

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    receive() external payable {}

    function submit(address _to, uint _value) external onlyOwner {
        transactions.push(Transaction(_to, _value, false, 0));
    }

    function approve(uint _txId) external onlyOwner {
        Transaction storage txn = transactions[_txId];

        require(!txn.executed, "Already executed");
        require(!approved[_txId][msg.sender], "Already approved");

        approved[_txId][msg.sender] = true;
        txn.approvalCount++;
    }

    function execute(uint _txId) external onlyOwner {
        Transaction storage txn = transactions[_txId];

        require(!txn.executed, "Executed");
        require(txn.approvalCount >= required, "Not enough approvals");

        txn.executed = true;
        payable(txn.to).transfer(txn.value);
    }
}