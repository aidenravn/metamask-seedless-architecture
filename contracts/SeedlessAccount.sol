// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns(bool);
}

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

interface IMPCApproval {
    function isApproved(address wallet, address device) external view returns(bool);
}

interface IGuardianRegistry {
    function getActiveGuardians(address wallet) external view returns(uint256);
}

contract SeedlessAccount {
    /* ───────────── Core Keys ───────────── */
    address public owner;                     
    mapping(address => bool) public guardians;
    uint256 public guardianCount;
    uint256 public guardianThreshold;
    IMPCApproval public mpcApproval;
    IGuardianRegistry public guardianRegistry;

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

    /* ───────────── Events ───────────── */
    event Executed(address indexed to, uint256 value, bytes data);
    event RecoveryApproved(address indexed guardian, address indexed newOwner);
    event RecoveryFinalized(address indexed newOwner);
    event DailyLimitReset(uint256 timestamp);

    /* ───────────── Modifiers ───────────── */
    modifier onlyOwnerOrMPC() {
        require(msg.sender == owner || mpcApproval.isApproved(owner, msg.sender), "Not owner/MPC");
        _;
    }

    modifier guardianThresholdMet() {
        require(guardianRegistry.getActiveGuardians(address(this)) >= guardianThreshold, "Guardian threshold not met");
        _;
    }

    /* ───────────── Constructor ───────────── */
    constructor(
        address _owner,
        address[] memory _guardians,
        uint256 _threshold,
        uint256 _dailyLimit,
        address _mpcApproval,
        address _guardianRegistry
    ) {
        require(_threshold > 0 && _threshold <= _guardians.length, "Invalid threshold");

        owner = _owner;
        dailyLimit = _dailyLimit;
        lastReset = block.timestamp;
        guardianThreshold = _threshold;
        mpcApproval = IMPCApproval(_mpcApproval);
        guardianRegistry = IGuardianRegistry(_guardianRegistry);

        for (uint256 i = 0; i < _guardians.length; i++) {
            guardians[_guardians[i]] = true;
        }
        guardianCount = _guardians.length;
    }

    /* ───────────── Spend control ───────────── */
    function _resetIfNeeded() internal {
        if (block.timestamp > lastReset + 1 days) {
            spentToday = 0;
            lastReset = block.timestamp;
            emit DailyLimitReset(lastReset);
        }
    }

    function executeETH(address to, uint256 value, bytes calldata data) external onlyOwnerOrMPC {
        _resetIfNeeded();
        require(spentToday + value <= dailyLimit, "Daily limit exceeded");

        spentToday += value;
        (bool success,) = to.call{value: value}(data);
        require(success, "Tx failed");

        emit Executed(to, value, data);
    }

    function executeERC20(IERC20 token, address to, uint256 amount) external onlyOwnerOrMPC {
        _resetIfNeeded();
        require(amount <= dailyLimit - spentToday, "Daily limit exceeded");
        spentToday += amount;
        require(token.transfer(to, amount), "ERC20 transfer failed");
        emit Executed(to, amount, "");
    }

    function executeERC721(IERC721 token, uint256 tokenId, address to) external onlyOwnerOrMPC {
        _resetIfNeeded();
        token.safeTransferFrom(address(this), to, tokenId);
        emit Executed(to, 0, abi.encode(tokenId));
    }

    /* ───────────── Recovery flow ───────────── */
    function approveRecovery(address newOwner) external {
        require(guardians[msg.sender], "Not guardian");
        if (pendingOwner != newOwner) {
            pendingOwner = newOwner;
            recoveryStartedAt = block.timestamp;
            recoveryApprovalCount = 0;
        }
        require(!recoveryApprovals[msg.sender], "Already approved");
        recoveryApprovals[msg.sender] = true;
        recoveryApprovalCount++;

        emit RecoveryApproved(msg.sender, newOwner);
    }

    function cancelRecovery() external onlyOwnerOrMPC {
        pendingOwner = address(0);
        recoveryStartedAt = 0;
        recoveryApprovalCount = 0;
    }

    function finalizeRecovery() external guardianThresholdMet {
        require(pendingOwner != address(0), "No recovery");
        require(block.timestamp >= recoveryStartedAt + RECOVERY_DELAY, "Recovery delay not passed");
        require(recoveryApprovalCount >= guardianThreshold, "Not enough guardian approvals");

        owner = pendingOwner;
        pendingOwner = address(0);
        recoveryStartedAt = 0;
        recoveryApprovalCount = 0;

        emit RecoveryFinalized(owner);
    }

    /* ───────────── ETH receive ───────────── */
    receive() external payable {}
}
