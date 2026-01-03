## 🤝 Contributing

We welcome contributions from the community!  

Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on how to safely contribute, test, and submit code.  

**⚠️ Reminder:** This project is experimental, not production-ready, and not to be used with real funds. Always follow security best practices when contributing.

🌐 Seedless Wallet + Reputation + Migration – Flow Diagram (English)

[User Device (MPC Key)]
        │
        ▼
[Seedless Smart Account (ERC-4337)]
        │
        ▼
[Guardian Network] ──────┐
        │                 │
        ▼                 ▼
[Identity Registry]   [Migration Helper]
        │                 │
        ▼                 ▼
[Reputation Contract]   [ERC20 / NFT / Staked Assets]
        │                 │
        ▼                 ▼
   Reputation Mirroring   Assets Safely Migrated
        │                 │
        └─────────────┬───┘
                      ▼
             [Recovery + Risk Policies]
                      │
                      ▼
        Safe, Human-Friendly Self-Custody Wallet


⸻

Diagram Explanation (English)
	1.	User Device (MPC Key)
	•	Device-bound multi-party computation (MPC) key
	•	No seed phrases are used
	2.	Seedless Smart Account (ERC-4337)
	•	The user’s new smart account
	•	Account abstraction via ERC-4337 standard
	3.	Guardian Network
	•	Friends, devices, institutions
	•	Social recovery and transaction veto
	4.	Identity Registry
	•	Links old wallet addresses
	•	Provides reputation inheritance
	5.	Reputation Contract
	•	Migrates old stake, testnet points, and airdrop reputation to the new account
	6.	Migration Helper
	•	Safely transfers ERC20 tokens, NFTs, and staked assets
	7.	Recovery + Risk Policies
	•	Protects against lost phone, phishing, or malware
	•	Time-locks, guardian veto, and transaction simulation
	8.	Outcome
	•	A Seedless, human-friendly, recovery-ready, reputation-aware wallet
	•	Seed-based risks are removed, assets and reputation are safe

⸻

💡 Key Takeaways (English)
	•	Single point of failure (seed) eliminated
	•	Old wallet’s reputation and staked assets migrate safely
	•	Social recovery + MPC + risk simulation = safe & user-friendly
	•	Web3 adoption becomes human-first, not tech-first

⸻
