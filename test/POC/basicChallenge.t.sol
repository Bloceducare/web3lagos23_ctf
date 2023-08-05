// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/BasicChallenge.sol";
import "./solver.sol";

contract CounterTest is Test {
    BasicChalenge basicChalenge;
    Solver solver;

    function setUp() public {
        basicChalenge = new BasicChalenge();
        solver = new Solver();
    }

    function testCTF() public {
        address validPlayer = makeAddr("validPlayer");
        vm.prank(validPlayer);
        basicChalenge.trySolve(address(solver));
    }
}
