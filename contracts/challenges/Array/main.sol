/*
Arrays can have fixed or dynamic size. Fixed size arrays can be initialized in memory.

Arrays have several functionalities.
    push - Push new element to the end of the array.
    pop - Remove last element from the end of the array, shrink array length by 1.
    length - Current length of array.

Tasks:
    1) Write function get(uint i) that will return the array element of arr at index i.
       This function is external and view.
    
    2) Write external function push, it takes in a single input x of type uint and appends x 
       to the end of the array arr.

    3) Write external function remove(uint i) which will delete element at i from the array arr.

    4) Write function getLength which will return the current length of the array arr.
       This function must be external and view.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArrayBasic {
    // Several ways to initialize an array
    uint[] public arr;
    uint[] public arr2 = [1, 2, 3];
    // Fixed sized array, all elements initialize to 0
    uint[3] public arrFixedSize;

    // Insert, read, update and delete
    function examples() external {
        // Insert - add new element to end of array
        arr.push(1);
        // Read
        uint first = arr[0];
        // Update
        arr[0] = 123;
        // Delete does not change the array length.
        // It resets the value at index to it's default value,
        // in this case 0
        delete arr[0];

        // pop removes last element
        arr.push(1);
        arr.push(2);
        // 2 is removed
        arr.pop();

        // Get length of array
        uint len = arr.length;

        // Fixed size array can be created in memory
        uint[] memory a = new uint[](3);
        // push and pop are not available
        // a.push(1);
        // a.pop(1);
        a[0] = 1;
    }

    function get(uint i) external view returns (uint) {
        return arr[i];
    }

    function push(uint x) external {
        arr.push(x);
    }

    function remove(uint i) external {
        delete arr[i];
    }

    function getLength() external view returns (uint) {
        return arr.length;
    }
}
