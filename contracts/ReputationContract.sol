// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IIdentityRegistry {
    function getLinkedAddresses(address account) external view returns(address[] memory);
}

contract ReputationContract {
    IIdentityRegistry public registry;
    mapping(address => uint256) public reputation;

    constructor(address registryAddress) {
        registry = IIdentityRegistry(registryAddress);
    }

    // Reputation ekle
    function addReputation(address user, uint256 amount) external {
        reputation[user] += amount;
    }

    // Identity üzerinden miras al
    function getReputation(address user) external view returns(uint256) {
        uint256 total = reputation[user];
        address[] memory linked = registry.getLinkedAddresses(user);
        for(uint i=0; i<linked.length; i++){
            total += reputation[linked[i]];
        }
        return total;
    }
}
