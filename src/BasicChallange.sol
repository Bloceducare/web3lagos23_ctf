// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicChalenge {
    mapping(address => bool) public hasSolvedchallenge2;
    mapping(address => uint) gatefee;

    event paid(string indexed);

    function payGateFee() public payable {
        require(msg.value > 0, "payup");
        gatefee[msg.sender] += msg.value;
        emit paid("Thank you!");
    }

    receive() external payable {
        require(msg.value < 0.001 ether, "we do not want");
        hasSolvedchallenge2[msg.sender] = true;
    }
}
