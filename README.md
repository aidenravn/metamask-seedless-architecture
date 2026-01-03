# 🌱 Seedless Wallet – Human-Friendly Self-Custody for Web3

> **Experimental project** – not production-ready. Do **not** use with real funds. Always follow security best practices.

---

## 🤝 Contributing

We welcome contributions! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on how to safely contribute, test, and submit code.

---

## 🔑 What is Seedless Wallet?

Seedless Wallet is a **human-first Web3 self-custody solution** that eliminates the risks of seed phrases while allowing users to safely migrate their assets and reputation.  

**Key Features:**
- 🔒 No seed phrases — single point of failure removed  
- 🛡️ Social recovery with friends, devices, or institutions  
- 🏆 Reputation migration from old wallets (stakes, testnet points, airdrops)  
- 💰 Safe migration of ERC20 tokens, NFTs, and staked assets  
- ⏳ Risk policies including transaction simulation, time-locks, and guardian veto  

---

## 🌐 Architecture Overview

```text
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
	•	No seed phrases used
	2.	Seedless Smart Account (ERC-4337)
	•	Account abstraction via ERC-4337 standard
	3.	Guardian Network
	•	Social recovery and transaction veto via friends, devices, or institutions
	4.	Identity Registry
	•	Links old wallet addresses
	•	Provides reputation inheritance
	5.	Reputation Contract
	•	Migrates old stake, testnet points, and airdrop reputation
	6.	Migration Helper
	•	Safely transfers ERC20 tokens, NFTs, and staked assets
	7.	Recovery + Risk Policies
	•	Protects against lost phones, phishing, malware
	•	Includes time-locks, guardian veto, and transaction simulation
	8.	Outcome
	•	Seedless, recovery-ready, reputation-aware wallet
	•	Assets and reputation are safe

⸻

💡 Why Seedless Wallet?
	•	✅ Removes single point of failure (seed phrases)
	•	✅ Migrates old wallet’s reputation and staked assets safely
	•	✅ Social recovery + MPC + risk simulation = user-friendly security
	•	✅ Human-first approach to Web3 adoption

⸻

🚀 Getting Started

# Clone the repo
git clone https://github.com/yourusername/seedless-wallet.git

# Install dependencies
cd seedless-wallet
npm install

# Start the dev server
npm run dev


⸻

⚠️ Disclaimer

This project is experimental and not intended for real funds. Always follow security best practices and use testnets for experimentation.

⸻

📄 License

MIT License © 2026 aidenravn

---
