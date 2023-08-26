// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract W_3_B_C_2 {
    error ERROR();
    event winner(address a);
    uint256[1000] gapped;
    // uint256 tt;
    // address owner;
    //0x93e8bea8ae4fa5526e26b3bca5890fa205dd13de4806fcc591ca58fae6ff5c03
    bytes32 pos = keccak256("WEB3LAGOS_2023-IS_NEAT");
    bytes12 keys = bytes12(keccak256("SECRET_MISSIVE_5565"));

    function getPos(bytes32 off) internal pure returns (User storage us) {
        bytes32 p = off;
        assembly {
            us.slot := p
        }
    }

    struct User {
        address r;
        bytes12 s;
    }
    address owner;

    constructor(bytes12 b) payable {
        User storage us = getPos(pos);
        us.r = msg.sender;
        us.s = b;
        owner = msg.sender;
    }

    function get(bytes32 _POSITION) public pure returns (User memory ur) {
        User memory u = getPos(_POSITION);
        ur.r = u.r;
        ur.s = u.s;
    }

    function submitkey(bytes12 key) public {
        if (key == keys) {
            payable(msg.sender).transfer(address(this).balance);
        } else {
            revert ERROR();
        }
    }

    function transferOut() public {
        assert(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
    }
}

interface Bonus {
    struct User {
        address r;
        bytes12 s;
    }

    function get(bytes32 _POSITION) external view returns (User memory ur);

    function submitkey(bytes12 key) external;
}
