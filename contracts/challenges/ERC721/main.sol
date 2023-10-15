/*

Implement ERC721

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address owner) external view returns (uint balance);

    function ownerOf(uint tokenId) external view returns (address owner);

    function safeTransferFrom(address from, address to, uint tokenId) external;

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    function transferFrom(address from, address to, uint tokenId) external;

    function approve(address to, uint tokenId) external;

    function getApproved(uint tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

Task:
    - Complete the function ownerOf

        function ownerOf(uint id) external view returns (address) {}

        Return the owner of id stored in _ownerOf
        Fail if token does not exist (_ownerOf[id] is zero address)


    - Complete the function balanceOf

        function balanceOf(address owner) external view returns (uint) {}

        Return the balance of owner stored in _balanceOf
        Fail if owner is zero address


    - Complete the function mint

        This function is not part of ERC721 but it will be used for later tests.

        function mint(address to, uint id) external {
            // code
        }

        Create new token having token id equal to id, owner set to to
        to cannot be zero address
        token must not exist yet
        Emit Transfer from zero address, to to with token id id


    - Complete the function setApprovalForAll

        function setApprovalForAll(address operator, bool approved) external {
            // code
        }

        This function enable or disable approval for a third party ("operator") to manage all of msg.sender's tokens

        set isApprovalForAll from msg.sender to operator to approved
        Emit ApprovalForAll


    - Complete the function getApproved

        function getApproved(uint id) external view returns (address) {}

        Returns the address allowed to transfer id
        Fails if token does not exist
        

    - Complete the function approve

        function approve(address to, uint id) external {
            // code
        }

        This function approves to to transfer token id on behalf of the owner

        Set _approvals for id to to
        Emit Approval
        Fail if msg.sender is not owner or if owner has not approved msg.sender as an operator


    - Complete the function transferFrom

        function transferFrom(
            address from,
            address to,
            uint id
        ) public {
            // code
        }

        Transfer id from from to to
        Reset _approvals for id
        Emit Transfer
        Fail if token does not exist
        Fail if from is not owner of id
        Fail if to is zero address
        Fail if msg.sender is not owner or if owner has not approved msg.sender

    
    - Complete the function safeTransferFrom

        function safeTransferFrom(
            address from,
            address to,
            uint id,
        ) external  {
            // code
        }

        This function is same as transferFrom except it will call the function onERC721Received if to is a contract

        Here is the interface for IERC721Receiver

        interface IERC721Receiver {
            function onERC721Received(
                address operator,
                address from,
                uint id,
                bytes calldata data
            ) external returns (bytes4);
        }

        Transfers id from from to to
        Reset _approvals for id
        Emit Transfer
        If to is a contract call onERC721REceived, passing empty bytes ("") for data
        If to is a contract check that onERC721Received returns IERC721Receiver.onERC721Received.selector
        Fail if token does not exist
        Fail if from is not owner of id
        Fail if to is zero address
        Fail if msg.sender is not owner or if owner has not approved msg.sender


    - How to check if address is a contract?
        Check code.length is greater than 0.

        function isContract(address to) public view returns (bool) {
            return to.code.length > 0;
        }


    - Complete the function safeTransferFrom

        function safeTransferFrom(
            address from,
            address to,
            uint id,
            bytes calldata data
        ) external {
            // code
        }

        This function is same as safeTransferFrom(address from, address to, uint id) except it will call the function onERC721Received with data.

        This function should

        Transfers id from from to to
        Reset _approvals for id
        Emit Transfer
        If to is a contract call onERC721REceived with data
        If to is a contract check that onERC721Received returns IERC721Receiver.onERC721Received.selector
        Fail if token does not exist
        Fail if from is not owner of id
        Fail if to is zero address
        Fail if msg.sender is not owner or if owner has not approved msg.sender


    - Complete the function burn
        function burn(uint id) external {
            // code
        }

        This function is not part of ERC721.

        Delete token with id
        Clear all approvals
        Emit Transfer to zero address
        Fail if token does not exist
        Fail if msg.sender is not the owner of id
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC721.sol";

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address owner) external view returns (uint balance);

    function ownerOf(uint tokenId) external view returns (address owner);

    function safeTransferFrom(address from, address to, uint tokenId) external;

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    function transferFrom(address from, address to, uint tokenId) external;

    function approve(address to, uint tokenId) external;

    function getApproved(uint tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint indexed id
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // Mapping from token ID to owner address
    mapping(uint => address) internal _ownerOf;

    // Mapping owner address to token count
    mapping(address => uint) internal _balanceOf;

    // Mapping from token ID to approved address
    mapping(uint => address) internal _approvals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function supportsInterface(
        bytes4 interfaceId
    ) external pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    function ownerOf(uint id) external view returns (address) {
        require(_ownerOf[id] != address(0), "token doesn't exist");
        return _ownerOf[id];
    }

    function balanceOf(address owner) external view returns (uint) {
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }

    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint id) external view returns (address) {
        require(_ownerOf[id] != address(0), "token doesn't exist");
        return _approvals[id];
    }

    function approve(address spender, uint id) external {
        address owner = _ownerOf[id];

        require(
            owner == msg.sender || isApprovedForAll[owner][msg.sender],
            "not authorized"
        );

        _approvals[id] = spender;

        emit Approval(owner, spender, id);
    }
    
    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint id
    ) internal view returns (bool) {
        return (spender == owner ||
            isApprovedForAll[owner][spender] ||
            spender == _approvals[id]);
    }

    function transferFrom(address from, address to, uint id) public {
        require(from == _ownerOf[id], "from != owner");
        require(to != address(0), "transfer to zero address");
        require(_isApprovedOrOwner(from, msg.sender, id), "not authorized");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[id] = to;

        delete _approvals[id];
        emit Transfer(from, to, id);
    }

    // function isContract(address to) public view returns (bool) {
    //   return to.code.length > 0;
    // }
    
    function safeTransferFrom(address from, address to, uint id) external {
    transferFrom(from, to, id);

    require(
        to.code.length == 0 ||
            IERC721Receiver(to).onERC721Received(msg.sender, from, id, "") ==
            IERC721Receiver.onERC721Received.selector,
        "unsafe recipient"
    );
}

    function safeTransferFrom(
    address from,
    address to,
    uint id,
    bytes calldata data
    ) external {
    transferFrom(from, to, id);

    require(
        to.code.length == 0 ||
            IERC721Receiver(to).onERC721Received(msg.sender, from, id, data) ==
            IERC721Receiver.onERC721Received.selector,
        "unsafe recipient"
    );
}


    function mint(address to, uint id) external {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[id] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    function burn(uint id) external {
        require(_ownerOf[id] != address(0), "token doesn't exist");
        
        address owner = _ownerOf[id];
        require(owner == msg.sender);
        
        _balanceOf[msg.sender] -= 1;

        delete _ownerOf[id];
        delete _approvals[id];
        
        emit Transfer(msg.sender, address(0), id);
    }
}
