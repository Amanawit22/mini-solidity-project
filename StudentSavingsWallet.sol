// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract StudentSavingsWallet {

    // 1. Mapping to store balances (Requirement)
    mapping(address => uint256) private balances;

    // 2. Struct for transaction history (Requirement)
    struct Transaction {
        address user;
        uint256 amount;
        string txType;
        uint256 timestamp;
    }

    // 3. Array to store all transactions (Requirement)
    Transaction[] private transactions;

    // Events (Bonus Feature - Already implemented!)
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    // Deposit ETH into wallet
    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");

        balances[msg.sender] += msg.value;

        transactions.push(Transaction(
            msg.sender,
            msg.value,
            "Deposit",
            block.timestamp
        ));

        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw ETH
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // Important: Update balance BEFORE the transfer to prevent re-entrancy attacks
        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        transactions.push(Transaction(
            msg.sender,
            amount,
            "Withdraw",
            block.timestamp
        ));

        emit Withdrawal(msg.sender, amount);
    }

    // --- NEW REQUIRED VIEW FUNCTIONS ---

    // Requirement: Provide view function to check balance
    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // Requirement: Provide view function to check transaction history
    // This returns the entire array of transactions
    function getTransactionHistory() public view returns (Transaction[] memory) {
        return transactions;
    }

    // Get the total number of transactions
    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }
}
