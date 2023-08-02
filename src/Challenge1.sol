// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {S_M} from "./sec_ret__miss_ive.sol";

contract W_3_B_C_1 is S_M {
    //Levels
    bytes constant PASSED_DOOR = (abi.encode(" Door"));
    bytes constant PASSED_LEVEL_A = (abi.encode("Level A"));
    bytes constant PASSED_LEVEL_B = (abi.encode(" Level B"));
    bytes constant PASSED_LEVEL_C = (abi.encode(" Level C"));
    bytes constant PASSED_LEVEL_D = (abi.encode(" Level D"));

    mapping(address => mapping(bytes => bool)) public levels;
    mapping(bytes => bool) public unlocked;

    error LevelNotPassed(string);

    //door
    mapping(bytes32 => bool) private validkey;
    mapping(bytes32 => bool) public usedkey;

    event DoorUnlocked(address opener, string key);
    event LevelUnlocked(address opener, bytes level);

    function open_entrance_door(
        uint16 _magicno,
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

    function solve_challenge_A() public payable {
        __hasSolved__(PASSED_DOOR);
        require(
            msg.value == (uint32(uint160(msg.sender)) & 0xffff) / 100,
            "Is it for beans?"
        );
        if (!unlocked[PASSED_LEVEL_A]) {
            unlocked[PASSED_LEVEL_A] = true;
            //do transfer
        }
        levels[msg.sender][PASSED_LEVEL_A] = true;
        emit LevelUnlocked(msg.sender, PASSED_LEVEL_A);
    }

    function solve_challenge_B() public {}

    //checks
    function __hasSolved__(bytes memory _level) public view {
        if (!levels[msg.sender][_level]) revert LevelNotPassed(string(_level));
    }
}
