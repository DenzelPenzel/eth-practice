/*
Implement ERC20.

ERC20 is a commonly used token standard with 3 important functions, 
transfer, approve and transferFrom.

transfer - Transfer token from msg.sender to another account
approve - Approve another account to spend your tokens.
transferFrom - Approved account can transfer tokens on your behalf

A common scenario to use approve and transferFrom is the following.

You approve a contract to spend some of your tokens. 
Next the contract calls transferFrom to transfer tokens from you into the contract.

By following the 2 steps above, you avoid the risk of accidentally sending tokens to the wrong address.

Here is the interface for ERC20

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}


Tasks: 
    - Complete function transfer.
        function transfer(address recipient, uint amount)
            external
            override
            returns (bool)
        {
            return true;
        }

        This function will transfer tokens from msg.sender to recipient for the amount amount specified in the input.

        Balance of token is stored in balanceOf. Decrease balances for msg.senderand increase for recipient.
        Emit the event Transfer.
        Return true to follow ERC20 token standards.

    - Complete function approve.
        function approve(address spender, uint amount)
            external
            override
            returns (bool)
        {
            return true;
        }

        This function approves spender to spend amount of tokens owned by msg.sender.

        Mapping allowance[owner][spender] stores the amount of tokens owner has allowed spender to spend.

        Update allowance, here msg.sender is allowing spender to spend amount.
        Emit the event Approval.
        Return true to follow ERC20 token standards.

    - Complete function tranferFrom.
        function transferFrom(
            address sender,
            address recipient,
            uint amount
        ) external override returns (bool) {
            return true;
        }

        This function transfers tokens from sender to recipient. msg.sender is approved to spend at least amount amount of tokens from sender.

        Update allowance and balanceOf appropriately.
        Transfer tokens from sender to recipient.
        Emit the event Transfer.
        Return true to follow ERC20 token standards.

    - Complete function mint.
        function mint(uint amount) external {
            // code
        }

        This function creates an additional amount of token to msg.sender.

        Emit the event Transfer from address(0), to msg.sender for the amount amount.

        This function is not part of ERC20 standard but it is a common function present in many tokens.

        Usually only an authorized account will be able to mint new tokens but for this exercise, we will skip the access control.


    - Complete function burn.
        function burn(uint amount) external {
            // code
        }

        This function deducts amount of token from msg.sender.

        Emit the event Transfer from msg.sender, to address(0) for the amount amount.

        burn is not part of ERC20 standard but it is a common function present in many tokens.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint public totalSupply = 1000;

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    string public name = "TestToken";
    string public symbol = "TEST";
    uint8 public decimals = 18;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external {
        // code
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        // code
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
