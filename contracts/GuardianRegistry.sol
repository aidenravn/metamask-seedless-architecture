// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GuardianRegistry {
    mapping(address => mapping(address => bool)) public guardians;

    function addGuardian(address wallet, address guardian) external {
        require(msg.sender == wallet, "Only wallet");
        guardians[wallet][guardian] = true;
    }

    function isGuardian(address wallet, address guardian) external view returns (bool) {
        return guardians[wallet][guardian];
    }
}
