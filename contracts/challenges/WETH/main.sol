/*
Wrapped Ether (WETH) is an ERC20 token that is fully backed by ETH.

Deposit ETH to mint WETH, burn WETH to withdraw ETH.

Here is the ERC20 contract that will be used for this challenge

Tasks:
    - Declare ERC20 as the parent contract of WETH.
        Next, initialize the constructor of ERC20 with the following inputs.

        Name: Wrapped Ether
        Symbol: WETH
        Decimals: 18
        Here is the constructor of ERC20

        constructor(string memory _name, string memory _symbol, uint8 _decimals) {
            name = _name;
            symbol = _symbol;
            decimals = _decimals;

            // ... more code ....
        }

    - Complete the function

        function deposit() public payable {}

        This function will mint WETH to msg.sender for the amount of ETH that was sent.

        Use the internal function _mint inherited from ERC20 to mint WETH.

        function _mint(address to, uint amount) internal virtual {
            totalSupply += amount;

            unchecked {
                balanceOf[to] += amount;
            }

            emit Transfer(address(0), to, amount);
        }

        Lastly, emit the event Deposit.


    - Directly sending ETH to this contract should trigger the deposit function.

    - Complete the function
        function withdraw(uint _amount) external {}

        This function will burn amount of WETH from msg.sender and send the same amount of ETH to the caller.

        Use the internal function _burn inherited from ERC20 to burn WETH.

        function _burn(address from, uint amount) internal virtual {
            balanceOf[from] -= amount;

            unchecked {
                totalSupply -= amount;
            }

            emit Transfer(from, address(0), amount);
        }

        Lastly, emit the event Withdraw.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract ERC20 {
    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);

    string public name;
    string public symbol;
    uint8 public immutable decimals;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function approve(
        address spender,
        uint amount
    ) public virtual returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address to, uint amount) public virtual returns (bool) {
        balanceOf[msg.sender] -= amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint amount
    ) public virtual returns (bool) {
        uint allowed = allowance[from][msg.sender];

        if (allowed != type(uint).max)
            allowance[from][msg.sender] = allowed - amount;

        balanceOf[from] -= amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    function _mint(address to, uint amount) internal virtual {
        totalSupply += amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint amount) internal virtual {
        balanceOf[from] -= amount;

        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}

contract WETH is ERC20 {
    event Deposit(address indexed account, uint amount);
    event Withdraw(address indexed account, uint amount);

    constructor() ERC20("Wrapped Ether", "WETH", 18) {}

    // Directly sending ETH to this contract should trigger the `deposit` func
    fallback() external payable {
        deposit();
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) external {
         _burn(msg.sender, _amount);
         payable(msg.sender).transfer(_amount);
         emit Withdraw(msg.sender, _amount);
    }
}
