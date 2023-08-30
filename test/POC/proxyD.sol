// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ILevelD {
    function solve_challenge_D(address _proxy) external;

    struct MSS_SS_SSM {
        uint8 offset__0;
        uint8 offset__1;
        uint8 offset__2;
        uint8 offset__3;
        uint8 offset__4;
        uint8 offset__5;
        uint8 offset__6;
        uint8 offset__7;
        uint64 offset2_8;
        uint64 offset2_9;
        uint16 __boom__;
        uint48 offset2_10;
    }
}

contract proxyD {
    constructor(address target) {
        ILevelD(target).solve_challenge_D(address(this));
    }

    function testCodeinAddress(address target) external {
        ILevelD(target).solve_challenge_D(address(this));
    }

    function __expected__() external view returns (ILevelD.MSS_SS_SSM memory) {
        uint16 toReturn = uint16(
            bytes2(bytes16(keccak256(abi.encode(address(this)))))
        );

        return ILevelD.MSS_SS_SSM(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, toReturn, 0);
    }
}
