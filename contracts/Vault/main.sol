/*

Vault is a contract where users deposit token to earn yield.

Deposit token to mint shares. Burn shares to withdraw token.

This challenge will focus on the math for minting and burning shares.


Tasks:
    - Declare state variables.
        Total amount of shares.

        uint public totalSupply

        A mapping from user's address to amount of shares they have.

        mapping(address => uint) public balanceOf


    - Complete the function
        function _mint(address _to, uint _shares) private {}

        This is a private function to mint _shares amount of shares to _to address. Update the state variables balanceOf and totalSupply.


    - Complete the function
        function _burn(address _from, uint _shares) private {

        This is a private function to burn _shares amount of shares from _from address. Update the state variables balanceOf and totalSupply.


    - Complete the function
        function deposit(uint _amount) external {}

        This function transfers _amount amount of token from msg.sender, and mints the approriate amount of shares.

        If total shares (totalSupply) is 0, then the amount of shares to mint equals the amount deposited.

        Otherwise the amount of shares to mint should be proportional to the percent increase of total tokens held in this contract.


    - Complete the function

        function withdraw(uint _shares) external {}

        This function burns _shares amount of token from msg.sender, and transfers the appropriate amount of tokens.

        The amount of tokens to receive must be proportional to the amount of shares gettings burnt.

*/




// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract Vault {
    IERC20 public immutable token;

    uint public totalSupply; // 0 (meaning no shares have been minted yet)
    mapping(address => uint) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint _shares) private {
        // code here
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint _shares) private {
        // code here
        balanceOf[_from] -= _shares;
        totalSupply -= _shares;
    }

    function deposit(uint _amount) external {
        // code here
        /*
            a = amount
            B = balance of token before deposit
            T = total supply
            s = shares to mint

            (T + s) / T = (a + B) / B 

            s = aT / B
        */
        uint shares;
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            uint totalTokens = token.balanceOf(address(this))
            shares = (_amount * totalSupply) / totalTokens;
        }
        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);    
    }

    function withdraw(uint _shares) external {
        // code here
        uint amount = (_shares * token.balanceOf(address(this))) / totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }
}
