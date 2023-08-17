/*
Write a contract to store an array of tasks.

Tasks:
- Declare a public state variable named todos which will store an array of Todo structs.

- Write a function which will create a new Todo with text set from input and 
  then stores the new Todo into the array todos.

  Here is the function declaration.
    function create(string calldata _text) externa 

- Write a function named updateText(uint _index, string calldata _text) 
  which will update the text of Todo stored at _index to the new value _text.


- Write a function to toggle completed of a Todo stored in todos at a given index.
  The function toggleCompleted(uint _index) will toggle completed of Todo stored in todos at _index.
  For example, if completed is true, this function should flip it to false.
  Likewise if false, set it to true.


- Write function get(uint _index) which will return the Todo stored at _index.
  This function should return two outputs, text and completed.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }
    
    Todo[] public todos;
    
    function create(string calldata _text) external {
        Todo memory todo = Todo({
            text: _text,
            completed: false
        });
        
        todos.push(todo);
    }
    
    function updateText(uint _index, string calldata _text) external {
        todos[_index].text = _text;
    }
    
    function toggleCompleted(uint _index) external {
        bool completed = todos[_index].completed;
        todos[_index].completed = !completed;
    }
    
    function get(uint _index) external view returns(string memory text, bool completed) {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }
}
