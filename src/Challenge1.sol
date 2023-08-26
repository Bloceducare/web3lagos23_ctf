// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {S_M} from "./sec_ret__miss_ive.sol";

contract W_3_B_C_1 is S_M {
    //Levels
    bytes constant DOOR = (abi.encodePacked("Door"));
    bytes constant LEVEL_A = (abi.encodePacked("Level A"));
    bytes constant LEVEL_B = (abi.encodePacked("Level B"));
    bytes constant LEVEL_C = (abi.encodePacked("Level C"));
    bytes constant LEVEL_D = (abi.encodePacked("Level D"));

    mapping(address => mapping(bytes => bool)) public levels;
    mapping(bytes => bool) public unlocked;

    //this should be removed once we verify specific amounts for each level
    uint256 constant sampleAmount = 8.88e18;

    error LevelNotPassed(string);

    //master and auth
    mapping(address => bool) public validPlayer;
    //nick and address
    mapping(address => string) nicks;
    //door
    mapping(bytes32 => bool) private validkey;
    mapping(bytes32 => bool) public usedkey;

    //level B
    mapping(address => uint) public trustCount;

    //level D
    mapping(address => address) public registeredProxies;

    event DoorUnlocked(string opener, string key, uint256 timeFired);
    event LevelUnlocked(string opener, string level, uint256 timeFired);
    event MasterLevelUnlocked(string opener, string level, uint256 timeFired);
    event PrincipalChanged(
        string culprit,
        address newPrincipal,
        uint256 timeFired
    );
    event ProxyRegistered(string registrar, address proxy, uint256 timeFired);

    event FirstSolver(string solver, string level);

    address public owner;

    constructor() payable {
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
                //   __out__(sampleAmount);
                emit FirstSolver(toNick(msg.sender), string(DOOR));
            }
            levels[tx.origin][DOOR] = true;
            usedkey[sha256(abi.encodePacked(_x_))] = true;
            //we use msg.sender here explicitly
            emit DoorUnlocked(toNick(tx.origin), _x_, block.timestamp);
        }
    }

    function solve_challenge_A() public payable {
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
            emit FirstSolver(toNick(tx.origin), string(LEVEL_A));
        }
        levels[tx.origin][LEVEL_A] = true;
        emit LevelUnlocked(toNick(tx.origin), string(LEVEL_A), block.timestamp);
    }

    event DiSCoNnEcTeD();

    function solve_challenge_B() public {
        __isValidPlayer__();
        __hasSolved__(LEVEL_A);

        if (trustCount[msg.sender] != 0) {
            //short-circuit and revert slot
            trustCount[msg.sender] = 0;
            emit DiSCoNnEcTeD();
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
                    emit FirstSolver(toNick(tx.origin), string(LEVEL_B));
                }
                levels[tx.origin][LEVEL_B] = true;
                emit MasterLevelUnlocked(
                    toNick(tx.origin),
                    string(LEVEL_B),
                    block.timestamp
                );
            }
        }
    }

    address currentPrincipal;

    function solve_challenge_C(address _newPrincipal) public {
        __isValidPlayer__();
        if (tx.origin != msg.sender) {
            if (_newPrincipal.code.length > 0)
                revert("Idan no suppose get code");
            currentPrincipal = _newPrincipal;
            emit PrincipalChanged(
                toNick(tx.origin),
                _newPrincipal,
                block.timestamp
            );
        }
    }

    function get_C_Profit() public {
        __isValidPlayer__();
        __hasSolved__(DOOR);
        if (tx.origin != currentPrincipal) revert("Not Principal");
        if (!unlocked[LEVEL_C]) {
            unlocked[LEVEL_C] = true;
            __out__(sampleAmount);
            emit FirstSolver(toNick(msg.sender), string(LEVEL_C));
        }

        levels[tx.origin][LEVEL_C] = true;
        emit LevelUnlocked(
            toNick(msg.sender),
            string(LEVEL_C),
            block.timestamp
        );
    }

    function solve_challenge_D(address _proxy) public {
        __isValidPlayer__();
        __hasSolved__(LEVEL_C);
        if (_proxy.code.length > 0) revert("PROXIES MUST NOT CONTAIN CODE");
        //register proxy for user
        registeredProxies[tx.origin] = _proxy;
        emit ProxyRegistered(toNick(tx.origin), _proxy, block.timestamp);
    }

    function solve_challenge_D2() public {
        if (registeredProxies[tx.origin].code.length == 0)
            revert("PROXIES SHOULD CONTAIN CODE");
        if (!unlocked[LEVEL_D]) {
            unlocked[LEVEL_D] = true;
            __out__(sampleAmount);
            emit FirstSolver(toNick(msg.sender), string(LEVEL_D));
        }

        levels[tx.origin][LEVEL_D] = true;
        emit LevelUnlocked(
            toNick(msg.sender),
            string(LEVEL_D),
            block.timestamp
        );
    }

    //checks
    function __hasSolved__(bytes memory _level) public view {
        string memory level = string(_level);
        if (!levels[tx.origin][_level]) revert LevelNotPassed(level);
    }

    function __isOwner__() public view {
        if (msg.sender != owner) revert("Not owner");
    }

    function __isValidPlayer__() public view {
        if (!validPlayer[tx.origin] && !validPlayer[msg.sender])
            revert("Not a valid player");
    }

    //out
    function __out__(uint256 _amount) private {
        payable(tx.origin).transfer(_amount);
    }

    receive() external payable {}

    ///ADMIN
    //register players
    function massW(
        address[] calldata hackers,
        string[] calldata _hackers
    ) public {
        __isOwner__();
        for (uint i = 0; i < hackers.length; i++) {
            validPlayer[hackers[i]] = true;
            nicks[hackers[i]] = _hackers[i];
        }
    }

    function toNick(address _addr) public view returns (string memory) {
        return nicks[_addr];
    }

    //DANGER
    // function transferRights(address to, bytes memory right) public {
    //     //get right's value
    //     bool value = levels[msg.sender][right];
    //     //transfer right
    //     levels[to][right] = value;
    //     //reset on sender
    //     levels[msg.sender][right] = false;
    // }

    //register keys
    function massH(bytes32[] calldata keys) public {
        __isOwner__();
        for (uint i = 0; i < keys.length; i++) {
            validkey[keys[i]] = true;
        }
    }
}
