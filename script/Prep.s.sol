// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {W_3_B_C_1} from "../src/Challenge1.sol";
import {LibKeys} from "../src/LibKeys.sol";

contract CounterScript is Script, LibKeys {
    function setUp() public {}

    function run() public {
        W_3_B_C_1 ctf = W_3_B_C_1(
            payable(0x95bD8D42f30351685e96C62EDdc0d0613bf9a87A)
        );
        uint256 deployerPrivateKey = vm.envUint("PK");
        vm.startBroadcast(deployerPrivateKey);
        // W_3_B_C_1 ctf = new W_3_B_C_1();
        // ctf.massH(getAllPossibleKeys());
        // ctf.massW(
        //     toDynamicAddr(vm.addr(deployerPrivateKey)),
        //     toDynamicString("Hunter-X")
        // );
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "drunk");
    }

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

function toDynamicAddr(address addr) pure returns (address[] memory t) {
    t = new address[](1);
    t[0] = addr;
}

function toDynamicString(string memory _s) pure returns (string[] memory s) {
    s = new string[](1);
    s[0] = _s;
}
