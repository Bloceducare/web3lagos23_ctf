// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {W_3_B_C_1} from "../src/Challenge1.sol";
import {LibKeys} from "../src/LibKeys.sol";
import {reenter_x} from "./POC/reenter.sol";

contract CTFTest is Test, LibKeys {
    //levels
    bytes constant DOOR = (abi.encodePacked("Door"));
    bytes constant LEVEL_A = (abi.encodePacked("Level A"));
    bytes constant LEVEL_B = (abi.encodePacked("Level B"));
    bytes constant LEVEL_C = (abi.encodePacked("Level C"));
    bytes constant LEVEL_D = (abi.encodePacked("Level D"));
    error LevelNotPassed(string);

    W_3_B_C_1 ctf;

    function setUp() public {
        vm.deal(address(0xdead), 100 ether);
        //fund the contract with 50 ether
        ctf = new W_3_B_C_1{value: 50 ether}();
    }

    function testLevels() public {
        //cannot participate if not approved
        vm.expectRevert("Not a valid player");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "hello");

        //approve the player
        ctf.massW(toDynamicAddr(address(this)));
        ctf.massW(toDynamicAddr(tx.origin));

        //register all possible keys
        ctf.massH(getAllPossibleKeys());

        //open door
        //DOOR
        //won't open with wrong key
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "hello");
        vm.expectRevert(
            abi.encodeWithSelector(LevelNotPassed.selector, "Door")
        );
        ctf.solve_challenge_A();
        assertEq(ctf.levels(tx.origin, DOOR), false);

        //open door
        //should open fine with a valid key
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "smell");
        assertEq(ctf.levels(tx.origin, DOOR), true);

        //LEVEL A//

        // calculate and send the amount of ether required to solve level A
        uint256 amount = (uint32(uint160(address(this))) & 0xffff) / 100;
        vm.deal(address(this), 1 ether);

        ctf.solve_challenge_A{value: amount}();
        assertEq(ctf.levels(tx.origin, LEVEL_A), true);

        //LEVEL B//
        //deploy reenter_x.sol
        reenter_x x = new reenter_x(address(ctf));
        //transfer rights to helper contract
        ctf.transferRights(address(x), LEVEL_A);
        x.__initiate();
        //assert level is solved
        assertEq(ctf.levels(tx.origin, LEVEL_B), true);
    }

    function toDynamicAddr(
        address addr
    ) public pure returns (address[] memory t) {
        t = new address[](1);
        t[0] = addr;
    }

    ///Helpers
    function getAllPossibleKeys() internal view returns (bytes32[] memory t) {
        uint16 magicNo = 2929;
        string memory justAName = "ayodeji";
        string memory secretMissive = "supersimple"; //c3VwZXJzaW1wbGU= in base64
        string[] memory secrets = LibKeys.getkeys();

        t = new bytes32[](secrets.length);
        for (uint i = 0; i < secrets.length; i++) {
            string memory x = secrets[i];
            bytes32 key = sha256(
                abi.encodePacked(magicNo, justAName, secretMissive, x)
            );
            t[i] = key;
        }
    }
}
