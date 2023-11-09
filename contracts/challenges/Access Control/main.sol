/*
Implement role based access control

Tasks:
    - Define a new role named USER, use the keccak256 hash of the string "USER" as an identifier for this role.
    
    - Define modifier named onlyRole(byte32 _role) that checks msg.sender has _role before executing the rest of the code.
    
    - Complete function _grantRole. This function will set _role for _account to true and then emit the event GrantRole.
    
    - Complete the external function grantRole. This function must restrict access only to msg.sender having the ADMIN role.
    
    - Complete the external function revokeRole that will revoke _role from _account. This function must restrict access only to msg.sender having the ADMIN role.
      Emit the event RevokeRole
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccessControl {
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 public constant ADMIN = keccak256(abi.encodePacked("ADMIN"));

    bytes32 public constant USER = keccak256(abi.encodePacked("USER"));

    constructor() {
        _grantRole(ADMIN, msg.sender);
    }

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "don't have the role");
        _;
    }

    function _grantRole(bytes32 _role, address _account) internal {
        // Write code here
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    function grantRole(
        bytes32 _role,
        address _account
    ) external onlyRole(ADMIN) {
        // Write code here
        _grantRole(_role, _account);
    }

    function revokeRole(
        bytes32 _role,
        address _account
    ) external onlyRole(ADMIN) {
        // Write code here
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }
}
