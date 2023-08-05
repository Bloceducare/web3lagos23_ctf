// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IReceiver {
    function executeOperation(address from, address user) external;
}

contract BasicChalenge {
    mapping(address => bool) public hasSolvedchallenge2;
    mapping(address => bool) public hasAccess;

    event gateOpened(string indexed);

    function trySolve(address receiver) public payable {
        hasAccess[receiver] = true;
        IReceiver(receiver).executeOperation(address(this), msg.sender);
        if (hasSolvedchallenge2[msg.sender] == true) {
            emit gateOpened("Thank you!");
        } else {
            revert();
        }
    }

    function getUserAccess(address EOA) external {
        require(hasAccess[msg.sender] == true, " just Dey Play");
        hasSolvedchallenge2[EOA] = true;
    }
}
