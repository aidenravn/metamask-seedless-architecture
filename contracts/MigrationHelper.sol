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

interface IGuardianRegistry {
    function isGuardian(address wallet, address guardian) external view returns(bool);
    function getActiveGuardians(address wallet) external view returns(uint256);
}

interface IMPCApproval {
    function isApproved(address wallet, address device) external view returns(bool);
}

contract MigrationHelper {
    address public owner;
    IGuardianRegistry public guardianRegistry;
    IMPCApproval public mpcApproval;

    // Events
    event ERC20Migrated(address indexed token, address indexed from, address indexed to, uint256 amount);
    event ERC721Migrated(address indexed nft, address indexed from, address indexed to, uint256 tokenId);
    event StakeMigrated(address indexed stakeContract, address indexed from, address indexed to, uint256 amount);

    constructor(address _guardianRegistry, address _mpcApproval) {
        owner = msg.sender;
        guardianRegistry = IGuardianRegistry(_guardianRegistry);
        mpcApproval = IMPCApproval(_mpcApproval);
    }

    modifier onlyApproved(address wallet) {
        require(mpcApproval.isApproved(wallet, msg.sender), "MPC approval missing");
        _;
    }

    modifier guardianThresholdMet(address wallet) {
        // Placeholder: threshold kontrolü burada yapılabilir
        require(guardianRegistry.getActiveGuardians(wallet) > 0, "No active guardians"); 
        _;
    }

    // ERC20 token migrate
    function migrateERC20(IERC20 token, address from, address to)
        external
        onlyApproved(from)
        guardianThresholdMet(from)
    {
        uint256 balance = token.balanceOf(from);
        require(balance > 0, "No balance to migrate");
        require(token.transfer(to, balance), "Transfer failed");

        emit ERC20Migrated(address(token), from, to, balance);
    }

    // ERC721 NFT migrate
    function migrateERC721(IERC721 nft, uint256[] calldata tokenIds, address from, address to)
        external
        onlyApproved(from)
        guardianThresholdMet(from)
    {
        for(uint i=0; i<tokenIds.length; i++){
            require(nft.ownerOf(tokenIds[i]) == from, "Not owner");
            nft.safeTransferFrom(from, to, tokenIds[i]);
            emit ERC721Migrated(address(nft), from, to, tokenIds[i]);
        }
    }

    // Stake pozisyon migrate
    function migrateStake(IStakeContract stakeContract, address from, address to)
        external
        onlyApproved(from)
        guardianThresholdMet(from)
    {
        uint256 withdrawn = stakeContract.withdraw(from);
        stakeContract.stake(to, withdrawn);
        emit StakeMigrated(address(stakeContract), from, to, withdrawn);
    }

    // Placeholder: Cross-chain migration ve dry-run / rollback mekanizması eklenecek
    function crossChainDryRun(address asset, uint256 amount) external view returns(bool) {
        // simulate cross-chain transfer
        return true;
    }
}
