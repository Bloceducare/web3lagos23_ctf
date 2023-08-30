// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {W_3_B_C_1} from "../src/Challenge1.sol";
import {LibKeys} from "../src/LibKeys.sol";

import {reenter_x} from "../test/POC/reenter.sol";
import {proxy} from "../test/POC/proxy.sol";

import {proxyD} from "../test/POC/proxyD.sol";

import {W_3_B_C_2} from "../src/Challenge2.sol";

contract DeployChallengeA is Script, LibKeys {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PK");
        vm.startBroadcast(deployerPrivateKey);
        W_3_B_C_1 ctf = new W_3_B_C_1{value: 50 ether}();
        address ctfA = address(ctf);
        W_3_B_C_2 ctf2 = new W_3_B_C_2{value: 50 ether}(ctfA);

        ctf.massH(getAllPossibleKeys());
        ctf.massW(
            toDynamicAddr(vm.addr(deployerPrivateKey)),
            toDynamicString("Hunter-X")
        );
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "fiber");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "merit");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "stand");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "basal");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "movie");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "mirth");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "track");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "bongo");
        ctf.open_entrance_door(2929, "ayodeji", "supersimple", "apron");

        //  ctf.solve_challenge_A{value: 386}(keccak256("s"));
        reenter_x x = new reenter_x(address(ctfA));
        x.__initiate();
        x.__initiate();
        x.__initiate();
        x.__initiate();
        x.__initiate();

        proxy p = new proxy();
        p.interactSuccess(ctfA);
        ctf.get_C_Profit();

        ctf.get_C_Profit();
        ctf.get_C_Profit();
        ctf.get_C_Profit();
        ctf.get_C_Profit();
        ctf.get_C_Profit();

        proxyD pD = new proxyD(ctfA);
        //  ctf.solve_challenge_D(address(pD));
        ctf.solve_challenge_D2();
        ctf.solve_challenge_D2();
        ctf.solve_challenge_D2();
        ctf.solve_challenge_D2();
        ctf.solve_challenge_D2();
        ctf.solve_challenge_D2();
        ctf.solve_challenge_D2();

        //Challenge 2
        ctf2.submitkey(0xf5a3a7443753801bc7cef21b);
        ctf2.submitkey(0xf5a3a7443753811bc7cef22b);
        ctf2.submitkey(0xf5a3a7443753801bc7cef22b);
        ctf2.submitkey(0xf5a3a7443753801bc7cef22b);
        ctf2.submitkey(0xf5a3a7443753801bc7cef22b);
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
