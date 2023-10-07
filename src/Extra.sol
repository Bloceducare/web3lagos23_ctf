pragma solidity ^0.8.13;

contract Extra {
    error NotPassed();

    event Passed(address player);

    address public owner;
    bytes32 pos = keccak256("boxstorage");

    bytes23 key = bytes23(keccak256("Web3Lagos2023"));

    mapping(address => bytes32) marshalKey;

    struct Box {
        address district;
        bytes marshal;
    }

    function getPos(bytes32 off) internal pure returns (Box storage us) {
        bytes32 p = off;
        assembly {
            us.slot := p
        }
    }

    constructor(bytes memory m) payable {
        owner = msg.sender;
        Box storage box = getPos(pos);
        box.district = msg.sender;
        box.marshal = m;
        marshalKey[owner] = keccak256("ctf");
    }

    function moveFunds() public {
        if (msg.sender == owner) {
            payable(msg.sender).transfer(address(this).balance);
        } else {
            revert("You are not the owner");
        }
    }

    function solve(bytes32 magicKey) public {
        if (magicKey == keccak256(abi.encodePacked(key, marshalKey[owner]))) {
            payable(msg.sender).transfer(address(this).balance);
            emit Passed(msg.sender);
        } else {
            revert NotPassed();
        }
    }
}
