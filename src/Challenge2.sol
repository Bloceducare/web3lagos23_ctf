// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract W_3_B_C_2 {
    event Overlord(string overlord, uint256 timeFired);
    event Failed(string culprit, uint256 timeFired);
    event Passed(string winner, uint256 timeFired);

    uint256[1000] gapped;
    string fArAwAy = "0x44\\0x33\\0x22\\0x11\\0x00";

    bytes32[] secrets = new bytes32[](32);

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

    address challenge1;
    bool Cracked;

    constructor(address _challenge1) payable {
        secrets[4] = keccak256("WEB3LAGOS_2023_IS_NEAT");
        uint256[1000] memory gapped2;
        User storage us = getPos(secrets[4]);
        us.r = address(0xdeaDDeADDEaDdeaDdEAddEADDEAdDeadDEADDEaD);

        owner = msg.sender;
        challenge1 = _challenge1;
        us.s = bytes12(keccak256("SECRET_MISSIVE_5565"));
        uint256[1000] memory gapped3;
        secrets[16] = us.s;
    }

    function get(bytes32 _POSITION) public pure returns (User memory ur) {
        User memory u = getPos(_POSITION);
        ur.r = u.r;
        ur.s = u.s;
    }

    function submitkey(bytes12 key) public {
        IC1 i = IC1(challenge1);
        i.__checkPausedState();
        i.__isValidPlayer__();
        if (key == secrets[16]) {
            if (!Cracked) {
                Cracked = true;
                payable(tx.origin).transfer(address(this).balance);
                emit Overlord(i.toNick(tx.origin), block.timestamp);
            }
            emit Passed(i.toNick(tx.origin), block.timestamp);
        } else {
            emit Failed(i.toNick(tx.origin), block.timestamp);
        }
    }

    function __out__x() public {
        assert(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
    }
}

interface I_W_3_B_C_2 {
    struct User {
        address r;
        bytes12 s;
    }

    function get(bytes32 _POSITION) external view returns (User memory ur);

    function submitkey(bytes12 key) external;
}

interface IC1 {
    function __isValidPlayer__() external view;

    function toNick(address _addr) external view returns (string memory);

    function __checkPausedState() external view;
}
