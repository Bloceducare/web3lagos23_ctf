// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {W_3_B_C_1} from "../src/Challenge1.sol";
import {W_3_B_C_2} from "../src/Challenge2.sol";
import {LibKeys} from "../src/LibKeys.sol";
import {reenter_x} from "./POC/reenter.sol";

import {proxy} from "./POC/proxy.sol";
import {proxyD} from "./POC/proxyD.sol";

contract CTFTest is Test, LibKeys {
    //levels
    bytes constant DOOR = (abi.encodePacked("Door"));
    bytes constant LEVEL_A = (abi.encodePacked("Level A"));
    bytes constant LEVEL_B = (abi.encodePacked("Level B"));
    bytes constant LEVEL_C = (abi.encodePacked("Level C"));
    bytes constant LEVEL_D = (abi.encodePacked("Level D"));
    error LevelNotPassed(string);

    W_3_B_C_1 ctf;
    W_3_B_C_2 ctf2;

    struct User {
        address r;
        bytes12 s;
    }

    function setUp() public {
        vm.deal(address(0xdead), 100 ether);
        //fund the contract with 50 ether
        ctf = new W_3_B_C_1{value: 50 ether}();
        ctf2 = new W_3_B_C_2{value: 50 ether}(address(ctf));
    }

    function testLevels() public {
        console.log(tx.origin);
        //cannot participate if not approved
        vm.expectRevert("Not a valid player");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "hello");

        //approve the player
        // ctf.massW(toDynamicAddr(address(this)), toDynamicString("Hunter-X"));
        ctf.massW(toDynamicAddr(tx.origin), toDynamicString("Hunter-Y"));

        //register all possible keys
        ctf.massH(getAllPossibleKeys());

        //open door
        //DOOR
        //won't open with wrong key
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "hello");
        vm.expectRevert(
            abi.encodeWithSelector(LevelNotPassed.selector, "Door")
        );
        bytes32 rand = keccak256("rand");
        ctf.solve_challenge_A(rand);
        assertEq(ctf.levels(tx.origin, DOOR), false);

        //open door
        //should open fine with a valid key
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "smell");
        assertEq(ctf.levels(tx.origin, DOOR), true);

        vm.expectRevert("Idan no dey open different doors with the same key");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "smell");

        //LEVEL A//

        // calculate and send the amount of ether required to solve level A
        uint256 amount = (uint32(uint160(address(this))) & 0xffff) / 100;
        vm.deal(address(this), 1 ether);
        vm.expectRevert("Is it for beans?");
        ctf.solve_challenge_A{value: amount + 1}(rand);
        rand = keccak256(abi.encode("0x44\\0x33\\0x22\\0x11\\0x00", tx.origin));

        ctf.solve_challenge_A{value: amount}(rand);
        assertEq(ctf.levels(tx.origin, LEVEL_A), true);

        //LEVEL B//
        //deploy reenter_x.sol
        reenter_x x = new reenter_x(address(ctf));
        //transfer rights to helper contract
        // ctf.transferRights(address(x), LEVEL_A);
        x.__initiate();
        //assert level is solved
        assertEq(ctf.levels(tx.origin, LEVEL_B), true);

        //LEVEL C//
        //deploy proxy.sol
        proxy p = new proxy();

        //transfer rights to helper contract
        //should fail
        vm.expectRevert("Idan no suppose get code");
        p.interactFail(address(ctf));

        //should pass
        p.interactSuccess(address(ctf));

        //get level C profit
        ctf.get_C_Profit();
        assertEq(ctf.levels(tx.origin, LEVEL_C), true);

        //Deploy Level D
        proxyD pD = new proxyD(address(ctf));

        //get level D profit
        ctf.solve_challenge_D2();

        //should fail
        vm.expectRevert("PROXIES MUST NOT CONTAIN CODE");
        pD.testCodeinAddress(address(ctf));

        //checking challenge 2

        bytes32 toCheck = 0xf5036f45ac04d10524e87447221c14189bc8a2f876b5e8285ac6c245c7536434;
        W_3_B_C_2.User memory u = ctf2.get(toCheck);
        bytes12 key = (bytes12(u.s));
        console.log(tx.origin);
        ctf2.submitkey(key);
    }

    function toDynamicAddr(
        address addr
    ) public pure returns (address[] memory t) {
        t = new address[](1);
        t[0] = addr;
    }

    function toDynamicString(
        string memory _s
    ) public pure returns (string[] memory s) {
        s = new string[](1);
        s[0] = _s;
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
