// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
 SeedlessAccount v2
 - Owner = MPC / device key
 - Guardians = social recovery
 - Threshold based recovery
 - Time-locked recovery
 - Daily spend limit
*/

contract SeedlessAccount {
    /* ───────────── Core Keys ───────────── */

    address public owner;                     // MPC / device-bound key
    mapping(address => bool) public guardians;
    uint256 public guardianCount;
    uint256 public guardianThreshold;

    /* ───────────── Recovery ───────────── */

    uint256 public constant RECOVERY_DELAY = 2 days;
    address public pendingOwner;
    uint256 public recoveryStartedAt;
    mapping(address => bool) public recoveryApprovals;
    uint256 public recoveryApprovalCount;

    /* ───────────── Spend limits ───────────── */

    uint256 public dailyLimit;
    uint256 public spentToday;
    uint256 public lastReset;

    /* ───────────── Modifiers ───────────── */

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyGuardian() {
        require(guardians[msg.sender], "Not guardian");
        _;
    }

    /* ───────────── Constructor ───────────── */

    constructor(
        address _owner,
        address[] memory _guardians,
        uint256 _threshold,
        uint256 _dailyLimit
    ) {
        require(_threshold > 0 && _threshold <= _guardians.length, "Invalid threshold");

        owner = _owner;
        dailyLimit = _dailyLimit;
        lastReset = block.timestamp;

        for (uint256 i = 0; i < _guardians.length; i++) {
            guardians[_guardians[i]] = true;
        }

        guardianCount = _guardians.length;
        guardianThreshold = _threshold;
    }

    /* ───────────── Spend control ───────────── */

    function _resetIfNeeded() internal {
        if (block.timestamp > lastReset + 1 days) {
            spentToday = 0;
            lastReset = block.timestamp;
        }
    }

    function execute(address to, uint256 value, bytes calldata data) external onlyOwner {
        _resetIfNeeded();
        require(spentToday + value <= dailyLimit, "Daily limit exceeded");

        spentToday += value;
        (bool success,) = to.call{value: value}(data);
        require(success, "Tx failed");
    }

    /* ───────────── Recovery flow ───────────── */

    function approveRecovery(address newOwner) external onlyGuardian {
        if (pendingOwner != newOwner) {
            pendingOwner = newOwner;
            recoveryStartedAt = block.timestamp;
            recoveryApprovalCount = 0;
        }

        require(!recoveryApprovals[msg.sender], "Already approved");
        recoveryApprovals[msg.sender] = true;
        recoveryApprovalCount++;
    }

    function cancelRecovery() external onlyOwner {
        pendingOwner = address(0);
        recoveryStartedAt = 0;
        recoveryApprovalCount = 0;
    }

    function finalizeRecovery() external {
        require(pendingOwner != address(0), "No recovery");
        require(block.timestamp >= recoveryStartedAt + RECOVERY_DELAY, "Delay not passed");
        require(recoveryApprovalCount >= guardianThreshold, "Not enough guardian approvals");

        owner = pendingOwner;
        pendingOwner = address(0);
        recoveryStartedAt = 0;
        recoveryApprovalCount = 0;
    }

    /* ───────────── ETH receive ───────────── */

    receive() external payable {}
}
