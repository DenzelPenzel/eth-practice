/*
Using create2, contract address can be computed before it is deployed.

Below is the contract to be deployed using create2.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DeployWithCreate2 {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }
}

Here is the code to compute the address of the contract to be deployed with create2.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./DeployWithCreate2.sol";

contract ComputeCreate2Address {
    function getContractAddress(
        address _factory,
        address _owner,
        uint _salt
    ) external pure returns (address) {
        bytes memory bytecode = abi.encodePacked(
            type(DeployWithCreate2).creationCode,
            abi.encode(_owner)
        );

        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), _factory, _salt, keccak256(bytecode))
        );

        return address(uint160(uint(hash)));
    }
}

Task:
    - Complete the function deploy.

        function deploy(uint _salt) external {
           // Write your code here
        }   


        - Use create2 to deploy the contract DeployWithCreate2.
        - Emit the event Deploy logging the address of the deployed contract.


        - Here is an example of how you would deploy a contract with create2.
            // salt is a random 32 bytes that is used with create2
            bytes32 salt = bytes32(123);

            // param1, param2 are constructor arguments to MyContract
            new MyContract{salt: salt}(param1, param2)

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./DeployWithCreate2.sol";

contract ComputeCreate2Address {
    function getContractAddress(
        address _factory,
        address _owner,
        uint _salt
    ) external pure returns (address) {
        bytes memory bytecode = abi.encodePacked(
            type(DeployWithCreate2).creationCode,
            abi.encode(_owner)
        );

        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), _factory, _salt, keccak256(bytecode))
        );

        return address(uint160(uint(hash)));
    }
}

contract Create2Factory {
    event Deploy(address addr);

    function deploy(uint _salt) external {
        // Write your code here

        DeployWithCreate2 _contract = new DeployWithCreate2{
            salt: bytes32(_salt)
        }(msg.sender);

        emit Deploy(address(_contract));
    }
}
