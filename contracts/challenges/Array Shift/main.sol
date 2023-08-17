/*
When an array element is removed using delete, it does not shrink the array length.

This leaves a gap in the array. Here we introduce an technique to shrink the array after removing an element.

Task: 
    Remove the element at index _index and then shrink the array by 1.

    This can be done by shifting array elements one by one to the left starting at _index + 1 and then removing the last element by calling pop.

    For example

    // we will remove the element at index 2
    [1, 2, 3, 4, 5]

    // shift all elements to the left starting at index 3
    [1, 2, 4, 5, 5]

    // pop(), removed last element
    [1, 2, 4, 5]
*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArrayShift {
    uint[] public arr = [1, 2, 3];

    function remove(uint _index) external {
        // Write your code here
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    }
}
