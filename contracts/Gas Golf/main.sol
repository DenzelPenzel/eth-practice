/*


Gas optimize this contract.

Tasks:
    - Gas optimize the function sumIfEvenAndLessThan99 to less than or equal to 48628 gas.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// gas golf
contract GasGolf {
    // start = 50908 gas 
    // use calldata - 49163 gas
    // load state var to memory - 48952 gas
    // short circuit - 48634 gas 
    // loop increments - 48226 gas
    // cache array length - 48191 gas
    // load array elements to memory - 48029 gas

    uint public total;

    function sumIfEvenAndLessThan99(uint[] calldata nums) external {
        uint _total = total;
        uint n = nums.length;
        for (uint i = 0; i < n; ++i) {
            uint x = nums[i];
            if (x % 2 == 0 && x < 99) {
                _total += x;
            }
        }
        total = _total;
    }
}
