// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

interface IStaking {
    function unstake(uint256 tokenId, address to) external;
}

contract IdentityRegistry {
    struct Identity {
        address primaryAccount;
        address[] linkedAddresses;
        uint256 reputation;
        uint256 timeLockUntil;
        mapping(address => bool) guardians;
        mapping(address => bool) mpcDevices;
    }

    mapping(address => Identity) private identities;
    mapping(address => address) public addressToIdentity;

    // Off-chain reputasyon için Merkle root
    bytes32 public merkleRoot;

    // Events
    event AddressLinked(address indexed oldAddress, address indexed newAccount);
    event ReputationMigrated(address indexed oldAddress, address indexed newAccount, uint256 amount);
    event ERC20Migrated(address indexed token, address indexed oldAddress, address indexed newAccount, uint256 amount);
    event ERC721Migrated(address indexed token, address indexed oldAddress, address indexed newAccount, uint256 tokenId);
    event StakedTokenMigrated(address indexed stakingContract, address indexed oldAddress, address indexed newAccount, uint256 tokenId);
    event ReputationClaimed(address indexed account, uint256 amount);
    event GuardianApproved(address indexed account, address indexed guardian);
    event MPCApproved(address indexed account, address indexed device);
    event TimeLockSet(address indexed account, uint256 unlockTime);
    event MerkleRootSet(bytes32 root);

    // Modifiers
    modifier onlyGuardian(address account) {
        require(identities[account].guardians[msg.sender], "Not a guardian");
        _;
    }

    modifier onlyMPC(address account) {
        require(identities[account].mpcDevices[msg.sender], "MPC approval missing");
        _;
    }

    modifier timeLockPassed(address account) {
        require(block.timestamp >= identities[account].timeLockUntil, "Time-lock active");
        _;
    }

    // Link eski cüzdan ile yeni smart account
    function linkOldAddress(address oldAddress, bytes calldata signature) external {
        bytes32 message = keccak256(abi.encodePacked("Link to ", msg.sender));
        require(recoverSigner(message, signature) == oldAddress, "Invalid signature");

        if (addressToIdentity[oldAddress] == address(0)) {
            identities[msg.sender].primaryAccount = msg.sender;
            identities[msg.sender].linkedAddresses.push(oldAddress);
            addressToIdentity[oldAddress] = msg.sender;

            emit AddressLinked(oldAddress, msg.sender);
        }
    }

    // Guardian ekleme
    function addGuardian(address guardian) external {
        identities[msg.sender].guardians[guardian] = true;
        emit GuardianApproved(msg.sender, guardian);
    }

    // MPC cihaz ekleme
    function addMPCDevice(address device) external {
        identities[msg.sender].mpcDevices[device] = true;
        emit MPCApproved(msg.sender, device);
    }

    // Time-lock ayarlama
    function setTimeLock(uint256 delaySeconds) external {
        identities[msg.sender].timeLockUntil = block.timestamp + delaySeconds;
        emit TimeLockSet(msg.sender, identities[msg.sender].timeLockUntil);
    }

    // Merkle root ayarlama
    function setMerkleRoot(bytes32 root) external {
        merkleRoot = root;
        emit MerkleRootSet(root);
    }

    // Reputasyon migration
    function migrateReputation(address oldAddress)
        external
        timeLockPassed(msg.sender)
        onlyMPC(msg.sender)
    {
        address newAccount = addressToIdentity[oldAddress];
        require(newAccount == msg.sender, "Not authorized");

        uint256 oldReputation = identities[oldAddress].reputation;
        require(oldReputation > 0, "No reputation to migrate");

        identities[oldAddress].reputation = 0;
        identities[newAccount].reputation += oldReputation;

        emit ReputationMigrated(oldAddress, newAccount, oldReputation);
    }

    // Off-chain airdrop/testnet reputasyon claim
    function claimReputation(uint256 amount, bytes32[] calldata proof)
        external
        timeLockPassed(msg.sender)
        onlyMPC(msg.sender)
    {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
        require(verifyMerkleProof(proof, leaf), "Invalid proof");

        identities[msg.sender].reputation += amount;
        emit ReputationClaimed(msg.sender, amount);
    }

    // ERC20 migration
    function migrateERC20(address token, address oldAddress, uint256 amount)
        external
        timeLockPassed(msg.sender)
        onlyGuardian(msg.sender)
        onlyMPC(msg.sender)
    {
        address newAccount = addressToIdentity[oldAddress];
        require(newAccount == msg.sender, "Not authorized");

        IERC20(token).transferFrom(oldAddress, newAccount, amount);
        emit ERC20Migrated(token, oldAddress, newAccount, amount);
    }

    // ERC721 migration
    function migrateERC721(address token, address oldAddress, uint256 tokenId)
        external
        timeLockPassed(msg.sender)
        onlyGuardian(msg.sender)
        onlyMPC(msg.sender)
    {
        address newAccount = addressToIdentity[oldAddress];
        require(newAccount == msg.sender, "Not authorized");

        IERC721(token).safeTransferFrom(oldAddress, newAccount, tokenId);
        emit ERC721Migrated(token, oldAddress, newAccount, tokenId);
    }

    // Stake token migration
    function migrateStakedToken(address stakingContract, uint256 tokenId)
        external
        timeLockPassed(msg.sender)
        onlyGuardian(msg.sender)
        onlyMPC(msg.sender)
    {
        IStaking(stakingContract).unstake(tokenId, msg.sender);
        emit StakedTokenMigrated(stakingContract, msg.sender, msg.sender, tokenId);
    }

    // Get linked addresses
    function getLinkedAddresses(address account) external view returns(address[] memory) {
        return identities[account].linkedAddresses;
    }

    // Merkle proof doğrulama
    function verifyMerkleProof(bytes32[] calldata proof, bytes32 leaf) internal view returns(bool) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }
        return computedHash == merkleRoot;
    }

    // Basit ECDSA recovery
    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
        bytes32 ethSignedMessageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", message));
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(sig);
        return ecrecover(ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig) internal pure returns(bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "Invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
