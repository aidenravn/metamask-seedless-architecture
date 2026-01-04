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
    }

    mapping(address => Identity) public identities;
    mapping(address => address) public addressToIdentity;

    event AddressLinked(address indexed oldAddress, address indexed newAccount);
    event ReputationMigrated(address indexed oldAddress, address indexed newAccount, uint256 amount);
    event ERC20Migrated(address indexed token, address indexed oldAddress, address indexed newAccount, uint256 amount);
    event ERC721Migrated(address indexed token, address indexed oldAddress, address indexed newAccount, uint256 tokenId);

    // Link eski cüzdan ile yeni smart account
    function linkOldAddress(address oldAddress, bytes calldata signature) external {
        // Eski cüzdan imzasını doğrula
        bytes32 message = keccak256(abi.encodePacked("Link to ", msg.sender));
        require(recoverSigner(message, signature) == oldAddress, "Invalid signature");

        // Identity kaydı
        if(addressToIdentity[oldAddress] == address(0)) {
            identities[msg.sender].primaryAccount = msg.sender;
            identities[msg.sender].linkedAddresses.push(oldAddress);
            addressToIdentity[oldAddress] = msg.sender;

            emit AddressLinked(oldAddress, msg.sender);
        }
    }

    // Reputasyon taşımak için
    function migrateReputation(address oldAddress) external {
        address newAccount = addressToIdentity[oldAddress];
        require(newAccount == msg.sender, "Not authorized");
        uint256 oldReputation = identities[oldAddress].reputation;
        require(oldReputation > 0, "No reputation to migrate");

        identities[oldAddress].reputation = 0;
        identities[newAccount].reputation += oldReputation;

        emit ReputationMigrated(oldAddress, newAccount, oldReputation);
    }

    // ERC20 token migration
    function migrateERC20(address token, address oldAddress, uint256 amount) external {
        address newAccount = addressToIdentity[oldAddress];
        require(newAccount == msg.sender, "Not authorized");

        IERC20(token).transferFrom(oldAddress, newAccount, amount);
        emit ERC20Migrated(token, oldAddress, newAccount, amount);
    }

    // ERC721 / NFT migration
    function migrateERC721(address token, address oldAddress, uint256 tokenId) external {
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
