// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Extra.sol";

contract ExtraTest is Test {
    Extra extra;
    address user = mkAddr("user");

    function setUp() public {
        vm.deal(address(0xdead), 100 ether);
        extra = new Extra("marshal");
    }

    function testExtra() public {
        bytes23 key = bytes23(keccak256("Web3Lagos2023"));
        bytes32 marshalValue = keccak256("ctf");
        bytes32 magicKey = keccak256(abi.encodePacked(key, marshalValue));
        vm.prank(user);
        extra.solve(magicKey);
    }

    function mkAddr(string memory a) internal pure returns (address addr) {
        addr = address(uint160(uint256(keccak256(abi.encodePacked(a)))));
    }
}
