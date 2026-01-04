🌱 Seedless Wallet – Human-Friendly Self-Custody for Web3

Experimental project – not production-ready. Do not use with real funds. Always follow security best practices.

⸻

🤝 Contributing

We welcome contributions! Please read our CONTRIBUTING.md￼ for detailed guidelines on how to safely contribute, test, and submit code.

⸻

🔑 What is Seedless Wallet?

Seedless Wallet is a human-first Web3 self-custody solution that eliminates the risks of seed phrases while allowing users to safely migrate assets and reputations from old wallets.

Key Features:
	•	🔒 No seed phrases — single point of failure removed
	•	🛡️ Social recovery with friends, devices, or institutions (guardian network)
	•	🏆 Reputation migration from old wallets (stakes, testnet points, airdrops)
	•	💰 Safe migration of ERC20 tokens, NFTs, and staked assets
	•	⏳ Risk policies including transaction simulation, time-locks, and guardian + MPC approval

⸻

🌐 Architecture Overview

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

📝 Component Breakdown
	1.	User Device (MPC Key)
	•	Device-bound multi-party computation (MPC) key
	•	No seed phrases required
	2.	Seedless Smart Account (ERC-4337)
	•	Account abstraction for programmable security
	•	Supports time-locks, social recovery, and transaction simulation
	3.	Guardian Network
	•	Social recovery and transaction veto via friends, devices, or institutions
	•	MPC device approval adds extra security
	4.	Identity Registry
	•	Links old wallet addresses
	•	Manages migration of reputations and linked assets
	5.	Reputation Contract
	•	Migrates old stake, testnet points, and off-chain/airdrop reputations
	•	Supports Merkle-proof based off-chain claims
	6.	Migration Helper
	•	Safely transfers ERC20 tokens, NFTs, and staked assets
	•	Guardian + MPC + Time-lock protection
	7.	Recovery + Risk Policies
	•	Protects against lost devices, phishing, and malware
	•	Time-locks, guardian veto, MPC approval, and transaction simulation
	8.	Outcome
	•	Seedless, recovery-ready, reputation-aware wallet
	•	Assets and reputation are securely migrated

⸻

💡 Why Seedless Wallet?
	•	✅ Eliminates single point of failure (seed phrases)
	•	✅ Safely migrates old wallet’s reputation, stakes, and assets
	•	✅ Combines social recovery + MPC + risk simulation for user-friendly security
	•	✅ Designed for human-first Web3 adoption

⸻

🚀 Getting Started

# Clone the repo
git clone https://github.com/aidenravn/seedless-wallet.git

# Install dependencies
cd seedless-wallet
npm install

# Start the dev server
npm run dev

⚠️ Use only testnets or local networks for now. This project is experimental and not meant for real funds.

⸻

📄 License

MIT License © 2026 aidenravn
