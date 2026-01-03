// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IdentityRegistry {
    struct Identity {
        address primaryAccount;          // Seedless smart account
        address[] linkedAddresses;       // Eski cüzdanlar
    }

    mapping(address => Identity) public identities;
    mapping(address => address) public addressToIdentity;

    event AddressLinked(address indexed oldAddress, address indexed newAccount);

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
