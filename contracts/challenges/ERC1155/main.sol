/*
ERC1155 is a contract that manages many tokens, both fungible and non-fungible, in a single contract.

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    interface IERC1155 {
        function safeTransferFrom(
            address from,
            address to,
            uint id,
            uint value,
            bytes calldata data
        ) external;

        function safeBatchTransferFrom(
            address from,
            address to,
            uint[] calldata ids,
            uint[] calldata values,
            bytes calldata data
        ) external;

        function balanceOf(address owner, uint id) external view returns (uint);

        function balanceOfBatch(
            address[] calldata owners,
            uint[] calldata ids
        ) external view returns (uint[] memory);

        function setApprovalForAll(address operator, bool approved) external;

        function isApprovedForAll(
            address owner,
            address operator
        ) external view returns (bool);

        event TransferSingle(
            address indexed operator,
            address indexed from,
            address indexed to,
            uint id,
            uint value
        );
        event TransferBatch(
            address indexed operator,
            address indexed from,
            address indexed to,
            uint[] ids,
            uint[] values
        );
        event ApprovalForAll(
            address indexed owner,
            address indexed operator,
            bool approved
        );
    }

    interface IERC1155TokenReceiver {
        function onERC1155Received(
            address operator,
            address from,
            uint id,
            uint value,
            bytes calldata data
        ) external returns (bytes4);

        function onERC1155BatchReceived(
            address operator,
            address from,
            uint[] calldata ids,
            uint[] calldata values,
            bytes calldata data
        ) external returns (bytes4);
    }

Video: https://www.youtube.com/watch?v=Ai7A-_umm08

Tasks:

    - Complete the internal function
            function _mint(address to, uint id, uint value, bytes memory data) internal {}

        This function will increase the balance of to for the token id id by the amount value.
            - Revert if to is the zero address
            - Increase the balance of to for token id id by value
            - Emit the event TransferSingle where operator is msg.sender and from is address(0).
                event TransferSingle(
                    address indexed operator,
                    address indexed from,
                    address indexed to,
                    uint id,
                    uint value
                );

            - Check if to is a contract by checking the length of its' code
                to.code.length > 0

            - If to is a contract, call the function IERC1155TokenReceiver(to).onERC1155Received.
                function onERC1155Received(
                    address operator,
                    address from,
                    uint id,
                    uint value,
                    bytes calldata data
                ) external returns (bytes4);

            Input	    Value to pass
            operator	msg.sender
            from	    address(0)
            id	        id
            value	    value
            data	    data

            - Revert if call to onERC1155Received does not return IERC1155TokenReceiver.onERC1155Received.selector

            - Inside MyMultiToken complete the function mint
                function mint(uint id, uint value, bytes memory data) external {}

            - Call the internal function _mint, mint tokens to msg.sender.


    - Complete the internal function
        function _batchMint(
            address to,
            uint[] calldata ids,
            uint[] calldata values,
            bytes calldata data
        ) internal {}

        This function batch mints multiple tokens to a single address.

            - Require to is not the zero address
            - Revert if length of arrays ids and values are not the same
            - Run a loop and increase the balances of to for each ids[i] by values[i]
            - Emit the event TransferBatch where operator is msg.sender and from is address(0).
            
            event TransferBatch(
                address indexed operator,
                address indexed from,
                address indexed to,
                uint[] ids,
                uint[] values
            );

            - If to is a contract, call IERC1155TokenReceiver(to).onERC1155BatchReceived.
                function onERC1155BatchReceived(
                    address operator,
                    address from,
                    uint[] calldata ids,
                    uint[] calldata values,
                    bytes calldata data
                ) external returns (bytes4);

            - Revert if call to onERC1155BatchReceived does not return IERC1155TokenReceiver.onERC1155BatchReceived.selector

            - Inside MyMultiToken complete the function batchMint
                function batchMint(
                    uint[] calldata ids,
                    uint[] calldata values,
                    bytes calldata data
                ) external {
                    _batchMint(msg.sender, ids, values, data);
                }

            - Call the internal function _batchMint, mint tokens to msg.sender.
    

    - Complete the internal function _burn
        function _burn(address from, uint id, uint value) internal {}

            - Require from is not the zero address
            - Decrease the balance of from for token id id by the amount value
            - Emit the event TransferSingle
            
            event TransferSingle(
                address indexed operator,
                address indexed from,
                address indexed to,
                uint id,
                uint value
            );

            Input	    Value to pass
            operator	msg.sender
            from	    from
            to	        address(0)
            id	        id
            value	    value

            - Inside the contract MyMultiToken, complete the function burn
                function burn(uint id, uint value) external {}

            - Burn from msg.sender


    - Complete the internal function _batchBurn
        function _batchBurn(
            address from,
            uint[] calldata ids,
            uint[] calldata values
        ) internal {}

        This function will burn multiple tokens from a single address.
            - Require from is not the zero address
            - Revert if length of arrays ids and values are not the same
            - Run a loop and decrease the balances of from for each ids[i] by values[i]
            - Emit the event TransferBatch
            event TransferBatch(
                address indexed operator,
                address indexed from,
                address indexed to,
                uint[] ids,
                uint[] values
            );

            Input	    Value to pass
            operator	msg.sender
            from	    from
            to	        address(0)
            ids	        ids
            values	    values
            
            - Complete the function batchBurn inside the contract MyMultiToken
                function batchBurn(uint[] calldata ids, uint[] calldata values) external {}

            - Call the internal function _batchBurn and burn from msg.sender

    - Complete the function
        function balanceOfBatch(
            address[] calldata owners,
            uint[] calldata ids
        ) external view returns (uint[] memory balances) {}

        This function will return the balances of owners for token ids ids.
            - Revert if length of arrays owners and ids are not the same
            - Initialize balances to have the same length as owners.
            - For each owner in the owners array, get the balance of owners[i] for token ids[i] and store the result into balances[i]

    - Complete the function
        function setApprovalForAll(address operator, bool approved) external {}

        This function will approve or disapprove operator to spend tokens owned by msg.sender.

            - Emit the event ApprovalForAll
            event ApprovalForAll(
                address indexed owner,
                address indexed operator,
                bool approved
            );

    - Complete the function
        function safeTransferFrom(
            address from,
            address to,
            uint id,
            uint value,
            bytes calldata data
        ) external {}

        - Check authorization. Either from is msg.sender or msg.sender is approved to spend on behalf of from.
        - Require to is not the zero address
        - Update the balances of from and to
        - Emit the event TransferSingle, where operator is msg.sender
        
        event TransferSingle(
            address indexed operator,
            address indexed from,
            address indexed to,
            uint id,
            uint value
        );

        If to is a contract, call IERC1155TokenReceiver(to).onERC1155Received.
            - Require that the call above returns the correct value IERC1155TokenReceiver.onERC1155Received.selector


    - Complete the function
        function safeBatchTransferFrom(
            address from,
            address to,
            uint[] calldata ids,
            uint[] calldata values,
            bytes calldata data
        ) external {}

            - Require msg.sender is equal to from or from has approved msg.sender to spend
            - Require to is not the zero address
            - Require that the lengths of arrays ids and values are the same
            - Run a loop and update the balances of from and to for each token ids[i] by values[i]
            - Emit the event TransferBatch
        
            event TransferBatch(
                address indexed operator,
                address indexed from,
                address indexed to,
                uint[] ids,
                uint[] values
            );

            - If to is a contract, call the function IERC1155TokenReceiver(to).onERC1155BatchReceived
                function onERC1155BatchReceived(
                    address operator,
                    address from,
                    uint[] calldata ids,
                    uint[] calldata values,
                    bytes calldata data
                ) external returns (bytes4);

            - Require the function call above returns IERC1155TokenReceiver.onERC1155BatchReceived.selector
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC1155, IERC1155TokenReceiver} from "./IERC1155.sol";

contract ERC1155 is IERC1155 {
    event URI(string value, uint indexed id);

    // owner => id => balance
    mapping(address => mapping(uint => uint)) public balanceOf;
    // owner => operator => approved
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function balanceOfBatch(
        address[] calldata owners,
        uint[] calldata ids
    ) external view returns (uint[] memory balances) {
        // Code
    }

    function setApprovalForAll(address operator, bool approved) external {
        // Code
    }

    function safeTransferFrom(
        address from,
        address to,
        uint id,
        uint value,
        bytes calldata data
    ) external {
        // Code
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint[] calldata ids,
        uint[] calldata values,
        bytes calldata data
    ) external {
        // Code
    }

    // ERC165
    function supportsInterface(
        bytes4 interfaceId
    ) external view returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
            interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
    }

    // ERC1155 Metadata URI
    function uri(uint id) public view virtual returns (string memory) {}

    // Internal functions
    function _mint(
        address to,
        uint id,
        uint value,
        bytes memory data
    ) internal {
        // Code
    }

    function _batchMint(
        address to,
        uint[] calldata ids,
        uint[] calldata values,
        bytes calldata data
    ) internal {
        // Code
    }

    function _burn(address from, uint id, uint value) internal {
        // Code
    }

    function _batchBurn(
        address from,
        uint[] calldata ids,
        uint[] calldata values
    ) internal {
        // Code
    }
}

contract MyMultiToken is ERC1155 {
    function mint(uint id, uint value, bytes memory data) external {
        // Code
    }

    function batchMint(
        uint[] calldata ids,
        uint[] calldata values,
        bytes calldata data
    ) external {
        // Code
    }

    function burn(uint id, uint value) external {
        // Code
    }

    function batchBurn(uint[] calldata ids, uint[] calldata values) external {
        // Code
    }
}
