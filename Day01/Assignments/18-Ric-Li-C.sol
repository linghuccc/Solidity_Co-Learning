// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleCounter {
    // State variable to store the counter value
    uint private count;

    // Event to log when someone clicks
    event Clicked(address indexed user, uint newCount);

    // Constructor to initialize the counter (optional - starts at 0 by default)
    constructor() {
        count = 0;
    }

    // Function to increment the counter by 1
    function click() public {
        count += 1;
        emit Clicked(msg.sender, count);
    }

    // Function to decrement the counter by 1
    function decrement() public {
        require(count > 0, "Counter cannot go below zero");
        count -= 1;
        emit Clicked(msg.sender, count);
    }

    // Function to get the current count (view function - doesn't modify state)
    function getCount() public view returns (uint) {
        return count;
    }

    // Function to reset the counter to zero
    function reset() public {
        count = 0;
        emit Clicked(msg.sender, count);
    }
}
