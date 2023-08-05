// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {S_M} from "./sec_ret__miss_ive.sol";

contract W_3_B_C_1 is S_M {
    //Levels
    bytes constant DOOR = (abi.encode("Door"));
    bytes constant LEVEL_A = (abi.encode("Level A"));
    bytes constant LEVEL_B = (abi.encode("Level B"));
    bytes constant LEVEL_C = (abi.encode("Level C"));
    bytes constant LEVEL_D = (abi.encode("Level D"));

    mapping(address => mapping(bytes => bool)) public levels;
    mapping(bytes => bool) public unlocked;

    //this should be removed once we verify specific amounts for each level
    uint256 constant sampleAmount = 10e18;

    error LevelNotPassed(string);

    //master and auth
    mapping(address => bool) public validPlayer;
    //door
    mapping(bytes32 => bool) private validkey;
    mapping(bytes32 => bool) public usedkey;

    //level B
    mapping(address => uint) public trustCount;

    event DoorUnlocked(address opener, string key);
    event LevelUnlocked(address opener, bytes level);
    event MasterLevelUnlocked(address opener, bytes level);

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function open_entrance_door(
        uint16 _magicno,
        string calldata _just_a_name,
        string calldata _secret_missive,
        string calldata _x_
    ) public {
        __isValidPlayer__();
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
            if (!unlocked[DOOR]) {
                unlocked[DOOR] = true;
                //do transfer
                __out__(sampleAmount);
            }
            levels[msg.sender][DOOR] = true;
            usedkey[sha256(abi.encodePacked(_x_))] = true;
            emit DoorUnlocked(msg.sender, _x_);
        }
    }

    function solve_challenge_A() public payable {
        //do player check agains tx.origin
        __isValidPlayer__();
        __hasSolved__(DOOR);
        address $t$;
        assembly {
            $t$ := caller()
        }
        require(
            msg.value == (uint32(uint160($t$)) & 0xffff) / 100,
            "Is it for beans?"
        );
        if (!unlocked[LEVEL_A]) {
            unlocked[LEVEL_A] = true;
            //do transfer
            __out__(sampleAmount);
        }
        levels[msg.sender][LEVEL_A] = true;
        emit LevelUnlocked(msg.sender, LEVEL_A);
    }

    function solve_challenge_B() public {
        __isValidPlayer__();
        __hasSolved__(LEVEL_A);

        if (trustCount[msg.sender] != 0) {
            //short-circuit and revert slot
            trustCount[msg.sender] = 0;
        }
        (bool result, ) = msg.sender.call("");
        if (result) {
            trustCount[msg.sender]++;
            if (
                trustCount[msg.sender] ==
                uint8(uint256(keccak256("solved"))) % 15
            ) {
                if (!unlocked[LEVEL_B]) {
                    unlocked[LEVEL_B] = true;
                    //do transfer
                    __out__(sampleAmount);
                }
                levels[msg.sender][LEVEL_B] = true;
                emit MasterLevelUnlocked(msg.sender, LEVEL_B);
            }
        }
    }

    //checks
    function __hasSolved__(bytes memory _level) public view {
        if (!levels[msg.sender][_level]) revert LevelNotPassed(string(_level));
    }

    function __isOwner__() public view {
        if (msg.sender != owner) revert("Not owner");
    }

    function __isValidPlayer__() public view {
        if (!validPlayer[tx.origin]) revert("Not a valid player");
    }

    //out

    function __out__(uint256 _amount) public {
        payable(tx.origin).transfer(_amount);
    }

    receive() external payable {}

    ///ADMIN
    function massW(address[] calldata hackers) public {
        __isOwner__();
        for (uint i = 0; i < hackers.length; i++) {
            validPlayer[hackers[i]] = true;
        }
    }
}
