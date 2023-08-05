// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBasicChallenge {
    function getUserAccess(address EOA) external;
}

contract Solver {
    function executeOperation(address from, address user) external {
        IBasicChallenge(from).getUserAccess(user);
    }
}
