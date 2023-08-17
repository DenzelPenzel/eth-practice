/*

Variables are stored in one of three places.
    - storage - variable is a state variable (store on blockchain)
    - memory - variable is in memory and it exists temporary during a function call
    - calldata - special data location that contains function arguments


Difference between memory and calldata 
calldata is like memory but not modifiable. calldata saves gas.

Task:
- Complete the function set(address _addr, string calldata _text).
  This function should set text stored inside MyStruct at _addr to _text.
  Notice that _text is declared as calldata instead of memory, minimizing gas cost.

- Complete get(address _addr) which returns the text of MyStruct stored at _addr.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DataLocations {
    // Data locations of state variables are storage
    uint public x;
    uint public arr;

    struct MyStruct {
        uint foo;
        string text;
    }

    mapping(address => MyStruct) public myStructs;

    // Example of calldata inputs, memory output
    function examples(
        uint[] calldata y,
        string calldata s
    ) external returns (uint[] memory) {
        // Store a new MyStruct into storage
        myStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});

        // Get reference of MyStruct stored in storage.
        MyStruct storage myStruct = myStructs[msg.sender];
        // Edit myStruct
        myStruct.text = "baz";

        // Initialize array of length 3 in memory
        uint[] memory memArr = new uint[](3);
        memArr[1] = 123;
        return memArr;
    }

    function set(address _addr, string calldata _text) external {
        // Write your code here
        myStructs[_addr].text = _text;
    }

    function get(address _addr) external view returns (string memory) {
        // Write your code here
        return myStructs[_addr].text;
    }
}
