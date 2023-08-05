// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ILevelD {
    function solve_challenge_D(address _proxy) external;
}

contract proxyD {
    constructor(address target) {
        ILevelD(target).solve_challenge_D(address(this));
    }

    function testCodeinAddress(address target) external {
        ILevelD(target).solve_challenge_D(address(this));
    }
}
