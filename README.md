# MultiSig Wallet Smart Contract

A decentralized Multi-Signature Wallet built using Solidity.  
This wallet requires multiple owner approvals before executing transactions, improving fund security and decentralized governance.

---

# Features

- Multi-owner wallet management
- Configurable approval threshold
- Submit transactions
- Approve transactions
- Execute transactions after required approvals
- Ether deposit support
- Duplicate approval prevention
- Double execution prevention
- Access control using modifiers

---

# Smart Contract Security Concepts

This project implements several important smart contract security practices:

- Role-Based Access Control (RBAC)
- Multi-Signature Authorization
- Duplicate Approval Prevention
- Double Execution Prevention
- Checks-Effects-Interactions Pattern
- Secure Ether Transfer Handling
- Transaction State Validation

---

# Technologies Used

- Solidity ^0.8.20
- Ethereum
- Remix IDE / Hardhat
- MetaMask

---

# Contract Structure

## State Variables

### Owners
Stores all wallet owners.

```solidity
address[] public owners;
```

### Owner Validation
Checks whether an address is an owner.

```solidity
mapping(address => bool) public isOwner;
```

### Required Approvals
Minimum approvals needed to execute a transaction.

```solidity
uint public required;
```

---

# Transaction Structure

```solidity
struct Transaction {
    address to;
    uint value;
    bool executed;
    uint approvalCount;
}
```

Each transaction contains:
- recipient address
- Ether amount
- execution status
- approval count

---

# Functions

## submit()

Creates a new transaction.

```solidity
function submit(address _to, uint _value)
```

Only wallet owners can call this function.

---

## approve()

Approves a transaction.

```solidity
function approve(uint _txId)
```

Features:
- prevents duplicate approvals
- prevents approval after execution

---

## execute()

Executes a transaction after enough approvals.

```solidity
function execute(uint _txId)
```

Features:
- checks approval threshold
- prevents double execution

---

# Security Analysis

## Access Control

Implemented using custom modifier:

```solidity
modifier onlyOwner()
```

Prevents unauthorized users from interacting with sensitive functions.

---

## Duplicate Approval Prevention

```solidity
require(!approved[_txId][msg.sender], "Already approved");
```

Ensures one owner cannot approve multiple times.

---

## Double Execution Prevention

```solidity
require(!txn.executed, "Executed");
```

Protects against repeated transaction execution.

---

## Checks-Effects-Interactions Pattern

The contract updates state before transferring Ether.

```solidity
txn.executed = true;
payable(txn.to).transfer(txn.value);
```

Helps reduce reentrancy risks.

---

# Example Workflow

1. Deploy contract with owners and required approvals
2. Deposit Ether into contract
3. Submit transaction
4. Owners approve transaction
5. Execute transaction after reaching approval threshold

---

# Possible Improvements

Future enhancements:
- Add revoke approval functionality
- Add transaction events
- Use call() instead of transfer()
- Add transaction ID validation
- Add owner duplication checks
- Add OpenZeppelin ReentrancyGuard
- Build frontend using React + Ethers.js
- Add Hardhat tests and Foundry fuzzing

---

# Learning Outcomes

Through this project, I learned:
- Solidity smart contract development
- Multi-signature wallet architecture
- Smart contract security concepts
- Access control mechanisms
- Ether transfer handling
- State management using mappings and structs
- Decentralized governance logic

---

# License

MIT License
