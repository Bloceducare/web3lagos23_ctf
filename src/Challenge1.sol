// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {S_M} from "./sec_ret__miss_ive.sol";

contract W_3_B_C_1 is S_M {
    //Levels
    bytes32 constant PASSED_DOOR = bytes32(keccak256("Passed Door"));
    bytes32 constant PASSED_LEVEL_A = bytes32(keccak256("Passed Level A"));
    bytes32 constant PASSED_LEVEL_B = bytes32(keccak256("Passed Level B"));
    bytes32 constant PASSED_LEVEL_C = bytes32(keccak256("Passed Level C"));
    bytes32 constant PASSED_LEVEL_D = bytes32(keccak256("Passed Level D"));

    mapping(address => mapping(bytes32 => bool)) public levels;
    mapping(bytes32 => bool) public unlocked;

    //door
    mapping(bytes32 => bool) private validkey;
    mapping(bytes32 => bool) public usedkey;

    event DoorUnlocked(address opener, string key);

    function open_entrance_door(
        uint24 _magicno,
        string calldata _just_a_name,
        string calldata _secret_missive,
        string calldata _x_
    ) public {
        if (usedkey[sha256(abi.encodePacked(_x_))])
            revert("Idan no dey open different doors with the same key");
        if (
            validkey[
                sha256(
                    abi.encodePacked(
                        _magicno,
                        _just_a_name,
                        _secret_missive,
                        _x_
                    )
                )
            ]
        ) {
            if (!unlocked[PASSED_DOOR]) {
                unlocked[PASSED_DOOR] = true;
                //do transfer
            }
            levels[msg.sender][PASSED_DOOR] = true;
            usedkey[sha256(abi.encodePacked(_x_))] = true;
            emit DoorUnlocked(msg.sender, _x_);
        }
    }
}
