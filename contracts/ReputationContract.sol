// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IIdentityRegistry {
    function getLinkedAddresses(address account) external view returns(address[] memory);
}

interface IMPCApproval {
    function isApproved(address wallet, address device) external view returns(bool);
}

interface IGuardianRegistry {
    function getActiveGuardians(address wallet) external view returns(uint256);
}

contract ReputationContract {
    IIdentityRegistry public registry;
    IMPCApproval public mpcApproval;
    IGuardianRegistry public guardianRegistry;

    mapping(address => uint256) public reputation;
    mapping(address => uint256) public stakedReputation;

    // Events
    event ReputationAdded(address indexed user, uint256 amount);
    event ReputationStaked(address indexed user, uint256 amount);
    event ReputationClaimed(address indexed user, uint256 amount);

    constructor(address registryAddress, address mpcAddress, address guardianAddress) {
        registry = IIdentityRegistry(registryAddress);
        mpcApproval = IMPCApproval(mpcAddress);
        guardianRegistry = IGuardianRegistry(guardianAddress);
    }

    modifier onlyApproved(address user) {
        require(mpcApproval.isApproved(user, msg.sender), "MPC approval missing");
        _;
    }

    modifier guardianThresholdMet(address user) {
        require(guardianRegistry.getActiveGuardians(user) > 0, "No active guardians");
        _;
    }

    // Reputation ekleme
    function addReputation(address user, uint256 amount)
        external
        onlyApproved(user)
        guardianThresholdMet(user)
    {
        reputation[user] += amount;
        emit ReputationAdded(user, amount);
    }

    // Reputation stake etme
    function stakeReputation(uint256 amount) external {
        require(reputation[msg.sender] >= amount, "Not enough reputation");
        reputation[msg.sender] -= amount;
        stakedReputation[msg.sender] += amount;
        emit ReputationStaked(msg.sender, amount);
    }

    // Reputation miras alma (linked addresses)
    function getTotalReputation(address user) external view returns(uint256 total) {
        total = reputation[user] + stakedReputation[user];
        address[] memory linked = registry.getLinkedAddresses(user);
        for(uint i=0; i<linked.length; i++){
            total += reputation[linked[i]] + stakedReputation[linked[i]];
        }
    }

    // Off-chain / cross-chain claim (Merkle proof)
    function claimReputation(uint256 amount, bytes32[] calldata proof, bytes32 merkleRoot) external {
        // Placeholder: Merkle proof doğrulaması burada yapılacak
        reputation[msg.sender] += amount;
        emit ReputationClaimed(msg.sender, amount);
    }
}
