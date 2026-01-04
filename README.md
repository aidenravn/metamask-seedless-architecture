
# 🌱 Seedless Wallet – Human-Friendly Self-Custody for Web3

> Experimental project – not production-ready. Do not use with real funds. Always follow security best practices.

---

## 🔑 Architecture & Security Flow

```text
      ┌─────────────────────┐
      │  User Device (MPC)  │
      │ - Device-bound key  │
      │ - No seed phrase    │
      └─────────┬──────────┘
                │
                ▼
   ┌─────────────────────────────┐
   │ Seedless Smart Account       │
   │ (ERC-4337 Account Abstraction) │
   │ - Programmable security      │
   │ - Transaction simulation     │
   └─────────┬───────────────────┘
             │
             ▼
      ┌──────────────┐
      │ Guardian /   │
      │ MPC Network  │
      │ - Social recovery          │
      │ - Guardian veto            │
      │ - MPC approval             │
      └───────┬────────┘
              │
   ┌──────────▼──────────┐
   │ Identity Registry    │
   │ - Link old wallets   │
   │ - Track reputations  │
   │ - Time-lock control  │
   └──────────┬──────────┘
              │
              ▼
      ┌───────────────┐
      │ Migration     │
      │ Helper        │
      │ - ERC20/721   │
      │ - Staked      │
      │   Assets      │
      └───────┬────────┘
              │
   ┌──────────▼───────────┐
   │ Reputation Contract  │
   │ - Stake & Testnet    │
   │ - Off-chain Airdrops │
   │ - Merkle-proof claims│
   └──────────┬───────────┘
              ▼
      ┌───────────────┐
      │ Safe Wallet   │
      │ - Seedless    │
      │ - Recovery-ready │
      │ - Reputation-aware│
      └───────────────┘


⸻

🛡️ Security Layers

Layer	Purpose
MPC / Multi-Device	Transaction requires device approval; prevents single device compromise
Guardian Network	Social recovery, veto capability, extra trust layer
Time-lock	Delays high-risk operations to prevent immediate attacks
Transaction Simulation	Test operations before committing on-chain
Event Logging	Auditability of every migration or claim


⸻

🔑 Features Recap
	•	Seedless self-custody: no seed phrases
	•	Human-first UX: easy recovery and migration
	•	Reputation migration: old wallet stakes, testnet points, airdrops
	•	Safe asset migration: ERC20, ERC721, staked assets
	•	Off-chain proofs: Merkle tree verification for reputations

⸻

🚀 Getting Started

git clone https://github.com/aidenravn/seedless-wallet.git
cd seedless-wallet
npm install
npm run dev

⚠️ Testnets only! Experimental project.

⸻

📄 License

MIT License © 2026 aidenravn

---
