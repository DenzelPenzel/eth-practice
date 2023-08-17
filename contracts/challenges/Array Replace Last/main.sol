/*
Another way to remove array element while keeping the array without any gaps 
is to copy the last element into the slot to remove and then remove the last element.

This technique is more gas efficient than shifting array elements. 

Unlike the array shifting technique this does not preserve order of elements.

Task:
    Complete code to remove element at _index. 
    This code should copy last element into the element to remove, and then remove the last element.

    For example
        // Let's remove element at index 2
        [1, 2, 3, 4, 5]

        // Last element is copied over to index 2
        [1, 2, 5, 4, 5]

        // Last element is removed
        [1, 2, 5, 4]
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArrayReplaceLast {
    uint[] public arr = [1, 2, 3, 4];

    function remove(uint _index) external {
        // Write your code here
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    }
}
