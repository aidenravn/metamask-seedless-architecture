
Contributing to Seedless Wallet Repository

Thank you for your interest in contributing to this project! 🚀

This repository contains experimental smart contracts, MPC prototypes, and Web3 security research. Your contributions are welcome, but please read the guidelines carefully to ensure safety, consistency, and responsible development.

⸻

⚠️ Important Warnings
	•	Experimental Code: All smart contracts, scripts, and examples are for research, demonstration, and educational purposes only.
	•	Not Production Ready: Do not use these contracts with real funds.
	•	No Custody / No Control: Contributors and maintainers do not control user funds. Users are fully responsible for their own wallets and assets.
	•	Security First: Any submitted code must follow secure development practices. Vulnerabilities may exist; do not deploy to mainnet without proper auditing.

By contributing, you acknowledge that you assume responsibility for your code and its use.

⸻

📝 How to Contribute

1. Fork & Clone

git clone https://github.com/your-username/seedless-wallet.git
cd seedless-wallet

	•	Make sure you are working on the latest branch.
	•	Contributions should be made via feature branches.

⸻

2. Code Guidelines
	•	Write clear, readable, and well-documented code.
	•	Follow Solidity best practices:
	•	Use pragma solidity ^0.8.20
	•	Include access control modifiers (onlyOwner, onlyGuardian)
	•	Emit events for critical state changes
	•	Avoid re-entrancy and integer overflow issues
	•	For TypeScript / JS: follow ESLint / Prettier rules

⸻

3. Testing
	•	All smart contracts must have unit tests.
	•	Test coverage should include:
	•	Daily limits & spend control
	•	Guardian recovery & approval flows
	•	Migration & reputation inheritance
	•	Transaction simulation & risk scoring
	•	Use Hardhat or Foundry for testing.

⸻

4. Pull Requests
	•	Create a clear pull request title and description.
	•	Reference any related issues.
	•	Include test results and, if applicable, simulation outputs.
	•	Maintain backward compatibility where possible.

⸻

5. Reporting Issues

If you discover a bug or security vulnerability:
	•	Do not open a public issue if it’s a security concern.
	•	Send a private email to: security@seedless-web3.org
	•	Include:
	•	Steps to reproduce
	•	Expected vs. actual behavior
	•	Potential impact

⸻

6. Code of Conduct
	•	Be respectful and collaborative.
	•	Focus on constructive feedback and learning.
	•	Do not attempt to exploit any testnet or experimental assets.

⸻

Thank you for contributing!
Together, we can make Web3 self-custody more human-friendly and secure. 🌐

