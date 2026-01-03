// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SeedlessAccount {
    address public owner;              // MPC / device key
    mapping(address => bool) public guardians;
    uint256 public guardianCount;

    uint256 public constant RECOVERY_DELAY = 2 days;
    address public pendingOwner;
    uint256 public recoveryStartedAt;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier onlyGuardian() {
        require(guardians[msg.sender], "Not guardian");
        _;
    }

    constructor(address _owner, address[] memory _guardians) {
        owner = _owner;

        for (uint i = 0; i < _guardians.length; i++) {
            guardians[_guardians[i]] = true;
        }

        guardianCount = _guardians.length;
    }

    // Normal transaction execution
    function execute(address to, uint256 value, bytes calldata data) external onlyOwner {
        (bool success,) = to.call{value:value}(data);
        require(success, "Tx failed");
    }

    // Guardians start recovery
    function startRecovery(address newOwner) external onlyGuardian {
        pendingOwner = newOwner;
        recoveryStartedAt = block.timestamp;
    }

    // Owner can cancel if hacked
    function cancelRecovery() external onlyOwner {
        pendingOwner = address(0);
        recoveryStartedAt = 0;
    }

    // After delay, finalize
    function finalizeRecovery() external {
        require(pendingOwner != address(0), "No recovery");
        require(block.timestamp >= recoveryStartedAt + RECOVERY_DELAY, "Too early");

        owner = pendingOwner;
        pendingOwner = address(0);
        recoveryStartedAt = 0;
    }

    receive() external payable {}
}
