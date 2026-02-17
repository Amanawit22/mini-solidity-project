// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentSavingsWallet {

    // Mapping to store balances
    mapping(address => uint256) private balances;

    // Struct to store transaction history
    struct Transaction {
        address user;
        uint256 amount;
        string txType;
        uint256 timestamp;
    }

    // Array to store all transactions
    Transaction[] private transactions;

    // Events (Bonus Feature)
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
}