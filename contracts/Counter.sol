//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Counter {
    uint counter;

    event CounterInc(uint counter);

    function count() public {
        /**
            we change the state of the neetwork by adding 1 to the member of contract
            this is transaction 
            this is not a call to the network
        */
        counter++;
        console.log("Counter is now", counter);
        emit CounterInc(counter);
    }

    function getCounter() public view returns (uint) {
        return uint(counter);
    }
}



