/*

New contracts can be created from a contract using the keyword new.

This is the contract that is deployed using new for this challenge.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Account {
    address public bank;
    address public owner;
    uint public withdrawLimit;

    constructor(address _owner, uint _withdrawLimit) payable {
        bank = msg.sender;
        owner = _owner;
        withdrawLimit = _withdrawLimit;
    }
}

Tasks: 
    - Complete createSavingsAccount.   
      This function will create a new Account contract with withdrawLimit of 1000.
      Store the newly created contract into the accounts array.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Account.sol";

contract Bank {
    Account[] public accounts;

    function createAccount(address _owner) external {
        Account account = new Account(_owner, 0);
        accounts.push(account);
    }

    function createAccountAndSendEther(address _owner) external payable {
        Account account = (new Account){value: msg.value}(_owner, 0);
        accounts.push(account);
    }

    function createSavingsAccount(address _owner) external {
        // Write your code here
        Account account = new Account(_owner, 1000);
        accounts.push(account);
    }
}
