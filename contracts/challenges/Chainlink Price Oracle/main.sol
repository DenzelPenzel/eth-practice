/*
Real-world data, such as price of gold, foreign exchange rate and weather data are not accessible to smart contracts.

Unless we use an oracle. Oracles provide real-world data to smart contracts.

In this challenge use Chainlink oracle to get the price of BTC.

Here is the interface for the Chainlink oracle

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    interface AggregatorV3Interface {
        function decimals() external view returns (uint8);

        function latestRoundData()
            external
            view
            returns (
                // Round id the answer was created in
                uint80 roundId,
                // Answer - the price
                int256 answer,
                // Timestamp when the round started
                uint256 startedAt,
                // Timestamp when the round was updated
                uint256 updatedAt,
                // Legacy round id - no longer needed
                uint80 answeredInRound
            );
    }

Tasks:
    - Store the interface of Chainlink price oracle, AggregatorV3Interface as a constant
      0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c is the address of the oracle.

    - Get the latest price of BTC in USD. Write your code inside the function below.
      
      function getPrice() public view returns (int) {}
        - Get the price of BTC by calling latestRoundData() on AggregatorV3Interface. 
          The price is stored in the second output int answer.
        
        - Require that the price was updated within the last 3 hours
        
        - Return the price with 18 decimals. BTC / USD price oracle has 8 decimals.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AggregatorV3Interface.sol";

contract PriceOracle {
    function getPrice() public view returns (int) {
        // Code
    }
}
