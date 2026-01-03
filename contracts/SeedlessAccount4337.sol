// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SeedlessAccount.sol";

interface IEntryPoint {
    function depositTo(address account) external payable;
}

contract SeedlessAccount4337 is SeedlessAccount {

    IEntryPoint public immutable entryPoint;

    constructor(
        address _entryPoint,
        address _owner,
        address[] memory _guardians,
        uint256 _threshold,
        uint256 _dailyLimit
    )
        SeedlessAccount(_owner, _guardians, _threshold, _dailyLimit)
    {
        entryPoint = IEntryPoint(_entryPoint);
    }

    /* ERC-4337 validation */
    function validateUserOp(
        bytes32 userOpHash,
        bytes calldata signature
    ) external view returns (uint256) {
        require(msg.sender == address(entryPoint), "Only EntryPoint");

        // Simple ECDSA validation for now
        address recovered = recoverSigner(userOpHash, signature);
        require(recovered == owner, "Invalid signature");

        return 0; // valid
    }

    function recoverSigner(bytes32 hash, bytes memory sig) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        return ecrecover(hash, v, r, s);
    }

    /* Allow EntryPoint to execute txs */
    function executeFromEntryPoint(address to, uint256 value, bytes calldata data) external {
        require(msg.sender == address(entryPoint), "Only EntryPoint");
        execute(to, value, data);
    }

    receive() external payable {}
}
