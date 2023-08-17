/*
Events allow smart contracts to log data to the blockchain without using state variables.

Events are commonly used for debugging, monitoring and a cheap alternative to state variables for storing data.

Task:
    - Declare an event named Message with 3 parameters.
        address named _from with index
        address named _to with index
        string named _message

    - Create function
        sendMessage(address _addr, string calldata _message) external`

        This function logs Message from msg.sender to the _addr, with the message _message.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Event {
    event Log(string message, uint val);
    // Up to 3 parameters can be indexed
    event IndexedLog(address indexed sender, uint val);

    event Message(address indexed _from, address indexed _to, string _message);

    function examples() external {
        emit Log("Foo", 123);
        emit IndexedLog(msg.sender, 123);
    }

    function sendMessage(address _addr, string calldata _message) external {
        emit Message(msg.sender, _addr, _message);
    }
}



