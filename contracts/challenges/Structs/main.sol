/*
Structs allow data to be grouped together.

Tasks: 
- Complete function get(uint _index). 
  This function retrieves the Car struct stored at index _index 
  from the array cars and then return the values stored in the struct.

- Complete function transfer(uint _index, address _owner). 
  This function transfers the owner of the car stored at _index in the cars array, 
  to the new owner _owner.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StructExamples {
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car[] public cars;

    function examples() external {
        // 3 ways to initialize a struct
        Car memory toyota = Car("Toyota", 1980, msg.sender);
        Car memory lambo = Car({
            model: "Lamborghini",
            year: 1999,
            owner: msg.sender
        });
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2020;
        tesla.owner = msg.sender;

        // Push to array
        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);
        // Initialize and push in single line of code
        cars.push(Car("Ferrari", 2000, msg.sender));

        // Get reference to Car struct stored in the array cars at index 0
        Car storage car = cars[0];
        // Update
        car.year = 1988;
    }

    function register(string memory _model, uint _year) external {
        cars.push(Car({model: _model, year: _year, owner: msg.sender}));
    }

    function get(
        uint _index
    ) external view returns (string memory model, uint year, address owner) {
        // Write your code here
        Car storage car = cars[_index];
        return (car.model, car.year, car.owner);
    }

    function transfer(uint _index, address _owner) external {
        // Write your code here
        cars[_index].owner = _owner;
    }
}
