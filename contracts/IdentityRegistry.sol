// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

contract IdentityRegistry {
    struct Identity {
        address primaryAccount;          // Seedless smart account
        address[] linkedAddresses;       // Eski cüzdanlar
        uint256 reputation;              // Reputasyon puanı
        uint256 timeLockUntil;           // Migration / transfer için zaman kilidi
        mapping(address => bool) guardians; // Guardian ağı
    }

    mapping(address => Identity) public identities;
    mapping(address => address) public addressToIdentity;

    event AddressLinked(address indexed oldAddress, address indexed newAccount);
    event ReputationMigrated(address indexed oldAddress, address indexed newAccount, uint256 amount);
    event ERC20Migrated(address indexed token, address indexed oldAddress, address indexed newAccount, uint256 amount);
    event ERC721Migrated(address indexed token, address indexed oldAddress, address indexed newAccount, uint256 tokenId);
    event GuardianApproved(address indexed account, address indexed guardian);
    event TimeLockSet(address indexed account, uint256 unlockTime);

    modifier onlyGuardian(address account) {
        require(identities[account].guardians[msg.sender], "Not a guardian");
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

        if(addressToIdentity[oldAddress] == address(0)) {
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

    // Time-lock ayarla (örneğin 24 saat)
    function setTimeLock(uint256 delaySeconds) external {
        identities[msg.sender].timeLockUntil = block.timestamp + delaySeconds;
        emit TimeLockSet(msg.sender, identities[msg.sender].timeLockUntil);
    }

    // Reputasyon migration
    function migrateReputation(address oldAddress) external timeLockPassed(msg.sender) {
        address newAccount = addressToIdentity[oldAddress];
        require(newAccount == msg.sender, "Not authorized");
        uint256 oldReputation = identities[oldAddress].reputation;
        require(oldReputation > 0, "No reputation to migrate");

        identities[oldAddress].reputation = 0;
        identities[newAccount].reputation += oldReputation;

        emit ReputationMigrated(oldAddress, newAccount, oldReputation);
    }

    // ERC20 migration (guardian onaylı)
    function migrateERC20(address token, address oldAddress, uint256 amount) external timeLockPassed(msg.sender) onlyGuardian(msg.sender) {
        address newAccount = addressToIdentity[oldAddress];
        require(newAccount == msg.sender, "Not authorized");

        IERC20(token).transferFrom(oldAddress, newAccount, amount);
        emit ERC20Migrated(token, oldAddress, newAccount, amount);
    }

    // ERC721 migration (guardian onaylı)
    function migrateERC721(address token, address oldAddress, uint256 tokenId) external timeLockPassed(msg.sender) onlyGuardian(msg.sender) {
        address newAccount = addressToIdentity[oldAddress];
        require(newAccount == msg.sender, "Not authorized");

        IERC721(token).safeTransferFrom(oldAddress, newAccount, tokenId);
        emit ERC721Migrated(token, oldAddress, newAccount, tokenId);
    }

    function getLinkedAddresses(address account) external view returns(address[] memory) {
        return identities[account].linkedAddresses;
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
