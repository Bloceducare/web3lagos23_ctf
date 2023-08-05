// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {LibKeys} from "../src/LibKeys.sol";

contract CounterScript is Script, LibKeys {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }

    function getAllPossibleKeys() public view returns (bytes32[] memory t) {
        uint16 magicNo = 2929;
        string memory justAName = "ayodeji";
        string memory secretMissive = "supersimple"; //c3VwZXJzaW1wbGU= in base64
        for (uint i = 0; i < LibKeys.getkeys().length; i++) {
            string memory x = LibKeys.getkeys()[i];
            bytes32 key = sha256(
                abi.encodePacked(magicNo, justAName, secretMissive, x)
            );
            t[i] = key;
        }
    }
}
