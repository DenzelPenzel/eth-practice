pragma solidity ^0.8.0;

import "./hero.sol";

contract TestHero is Hero {
    uint256 random;

    // fake random. override function
    function generateRandom() public view override returns (uint256) {
        return random;
    }

    function setRandom(uint256 r) public {
        random = r;
    }
}
