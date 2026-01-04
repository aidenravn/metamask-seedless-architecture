# Seedless Wallet – Core Dev Review 

This document provides a comprehensive Core Developer review of the Seedless Wallet project, with technical details, risk analysis, UX improvements, and a roadmap for mainnet deployment.

---

## 1. Deepen Technical Details

### MPC and Guardian Edge-Case Testing
- Conduct comprehensive tests simulating offline/missing guardian scenarios.
- Clarify how transaction flows continue if one or two guardians are malicious or offline.
- Document threshold parameters (e.g., 2/3, 3/5) and fallback mechanisms.

### Transaction Simulation
- Perform dry-run tests for all transaction scenarios using ERC-4337 Account Abstraction.
- Pre-simulate and test Migration Helper and Reputation Module on testnets.

### Off-chain Data Security
- Clearly specify the use of Merkle proofs and oracle logic.
- Implement nonce and timestamp mechanisms to prevent replay attacks and stale data risks.

---

## 2. Risk Management and Audit

### Smart Contract Audit
- Audit all AA accounts, Migration Helper, and Reputation Contracts separately.

### Off-chain and MPC/Guardian Audit
- Independently test MPC device software, Guardian logic, and social recovery mechanisms.

### User Onboarding & Recovery Testing
- Test step-by-step walkthroughs, recovery simulations, and error scenarios for new users.

---

## 3. User Experience (UX) Improvements

### Recovery Simulation
- Users should be able to test the recovery flow even if they lose their wallet.

### Visual Guardian Setup
- Visualize the process of adding, removing, and approving guardians.

### Transaction Feedback
- Clearly show off-chain simulations and time-locks to users to avoid confusion.

---

## 4. Roadmap for Mainnet Preparation

1. **Testnet – Functional Validation**
   - Test MPC/Guardian, Migration, Reputation, and Simulation modules individually.

2. **Testnet – Stress and Edge-Case Testing**
   - Simulate offline or malicious guardians and Merkle/Oracle errors.

3. **Audit and Security Approval**
   - Conduct independent audits for smart contracts, off-chain systems, and MPC/guardian logic.

4. **Pilot User Group**
   - Run real-world UX and recovery tests with a limited group of users.

5. **Mainnet Deployment**
   - Gradual rollout, with extra control for critical transactions via time-locks + guardians.

---

## 5. Summary
- Technical details should be clarified and simulations increased.
- Risk management and audit coverage should be expanded.
- User experience and recovery flows should be visualized and tested.
- Pilot testing and independent audits are required before mainnet deployment.
