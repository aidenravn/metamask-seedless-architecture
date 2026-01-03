// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function balanceOf(address owner) external view returns(uint256);
    function transfer(address to, uint256 amount) external returns(bool);
}

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns(address);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

interface IStakeContract {
    function withdraw(address user) external returns(uint256);
    function stake(address user, uint256 amount) external;
}

contract MigrationHelper {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // ERC20 token taşı
    function migrateERC20(IERC20 token, address from, address to) external {
        uint256 balance = token.balanceOf(from);
        require(balance > 0, "No balance to migrate");
        require(token.transfer(to, balance), "Transfer failed");
    }

    // ERC721 NFT taşı
    function migrateERC721(IERC721 nft, uint256[] calldata tokenIds, address from, address to) external {
        for(uint i=0; i<tokenIds.length; i++){
            require(nft.ownerOf(tokenIds[i]) == from, "Not owner");
            nft.safeTransferFrom(from, to, tokenIds[i]);
        }
    }

    // Stake pozisyonunu taşı
    function migrateStake(IStakeContract stakeContract, address from, address to) external {
        uint256 withdrawn = stakeContract.withdraw(from);
        stakeContract.stake(to, withdrawn);
    }
}
