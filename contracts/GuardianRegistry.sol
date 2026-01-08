// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GuardianRegistry {
    struct GuardianInfo {
        bool isGuardian;
        bool active; // offline fallback
    }

    // wallet => guardian => info
    mapping(address => mapping(address => GuardianInfo)) private guardians;
    // wallet => total active guardians
    mapping(address => uint256) public activeGuardianCount;
    // wallet => required threshold (e.g., 2/3)
    mapping(address => uint256) public approvalThreshold;

    // Events
    event GuardianAdded(address indexed wallet, address indexed guardian);
    event GuardianRemoved(address indexed wallet, address indexed guardian);
    event ThresholdUpdated(address indexed wallet, uint256 newThreshold);

    modifier onlyWallet(address wallet) {
        require(msg.sender == wallet, "Only wallet owner can call");
        _;
    }

    // Add a new guardian
    function addGuardian(address wallet, address guardian) external onlyWallet(wallet) {
        require(!guardians[wallet][guardian].isGuardian, "Already a guardian");
        guardians[wallet][guardian] = GuardianInfo(true, true);
        activeGuardianCount[wallet] += 1;

        // Set default threshold if not set
        if (approvalThreshold[wallet] == 0) {
            approvalThreshold[wallet] = activeGuardianCount[wallet]; // full approval by default
        }

        emit GuardianAdded(wallet, guardian);
    }

    // Remove a guardian (soft delete)
    function removeGuardian(address wallet, address guardian) external onlyWallet(wallet) {
        require(guardians[wallet][guardian].isGuardian, "Not a guardian");
        guardians[wallet][guardian].active = false;
        activeGuardianCount[wallet] -= 1;

        emit GuardianRemoved(wallet, guardian);
    }

    // Check if an address is an active guardian
    function isGuardian(address wallet, address guardian) external view returns (bool) {
        return guardians[wallet][guardian].isGuardian && guardians[wallet][guardian].active;
    }

    // Update approval threshold
    function setThreshold(address wallet, uint256 newThreshold) external onlyWallet(wallet) {
        require(newThreshold > 0, "Threshold must be > 0");
        require(newThreshold <= activeGuardianCount[wallet], "Threshold > active guardians");
        approvalThreshold[wallet] = newThreshold;

        emit ThresholdUpdated(wallet, newThreshold);
    }

    // Get current guardian list for a wallet
    function getGuardians(address wallet) external view returns (address[] memory) {
        uint256 count = activeGuardianCount[wallet];
        address[] memory list = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < 2**160; i++) { // placeholder, in practice track guardian array
            // This loop is conceptual, actual implementation requires guardian array tracking
        }
        return list;
    }

    // Placeholder for future zk-proof / AI risk hook
    function validateGuardianAction(address wallet, address guardian) external view returns (bool) {
        // Implement zk-proof or AI risk check here
        return guardians[wallet][guardian].active;
    }
}
