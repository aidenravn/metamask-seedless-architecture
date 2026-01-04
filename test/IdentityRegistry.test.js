const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("IdentityRegistry", function () {
    let IdentityRegistry, registry;
    let owner, oldWallet, guardian, other;

    beforeEach(async () => {
        [owner, oldWallet, guardian, other] = await ethers.getSigners();
        IdentityRegistry = await ethers.getContractFactory("IdentityRegistry");
        registry = await IdentityRegistry.deploy();
        await registry.deployed();
    });

    it("should link old wallet to new account", async function () {
        const message = ethers.utils.solidityKeccak256(["string", "address"], ["Link to ", owner.address]);
        const signature = await oldWallet.signMessage(ethers.utils.arrayify(message));

        await registry.connect(owner).linkOldAddress(oldWallet.address, signature);
        const linked = await registry.getLinkedAddresses(owner.address);
        expect(linked[0]).to.equal(oldWallet.address);
    });

    it("should add guardian and set time-lock", async function () {
        await registry.connect(owner).addGuardian(guardian.address);
        await registry.connect(owner).setTimeLock(60);

        const isGuardian = await registry.identities(owner.address).guardians(guardian.address);
        expect(isGuardian).to.be.true;
    });

    it("should migrate reputation after time-lock", async function () {
        // Setup: link old wallet
        const message = ethers.utils.solidityKeccak256(["string", "address"], ["Link to ", oldWallet.address]);
        const signature = await oldWallet.signMessage(ethers.utils.arrayify(message));
        await registry.connect(owner).linkOldAddress(oldWallet.address, signature);

        // Add reputation manually for test
        const tx = await registry.connect(owner).migrateReputation(oldWallet.address);
        await tx.wait();

        // Check new account reputation
        const newReputation = (await registry.identities(owner.address)).reputation;
        expect(newReputation).to.be.gt(0);
    });
});
