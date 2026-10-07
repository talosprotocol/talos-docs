---
status: Implemented
audience: Security, Developer
---

# Protocol Guarantees

> **Problem**: Non-cryptographers need to understand Talos security.
> **Purpose**: Map intended security properties to implementation mechanisms and identify their verification limits.
> **Non-goal**: Full cryptographic proofs. See [Security Proof](../security/mathematical-proof.md).

---

## Guarantee Summary

| Guarantee | How Talos Provides It | Status |
|-----------|----------------------|--------|
| **Confidentiality** | Ratchet and authenticated encryption components | Implemented in selected SDK paths; deployment-wide property requires interop and operational verification |
| **Authenticity** | Ed25519 identity signatures and signed prekeys | Implemented; cross-SDK and route-level coverage is required for each supported path |
| **Forward Secrecy** | Ephemeral key ratcheting | Implementation present; full protocol guarantee not independently verified here |
| **Post-Compromise Security** | DH ratchet recovery | Implementation present; full protocol guarantee not independently verified here |
| **Non-Repudiation** | Audit events and Merkle proofs | Partial; external blockchain anchoring is not established by the default deployment |
| **Integrity** | Authenticated encryption and audit-chain hashing | Implemented in component paths; deployment-wide coverage is not independently verified here |
| **Replay Resistance** | Nonces, expiry, and ratchet state | Implementation present; verify every protected operation and transport |
| **Capability Control** | Scoped, expiring authorization | Implementation present; verify each gateway route and policy configuration |
| **Verifiability** | Merkle proof support | Partial; external anchoring and light-client verification are not part of the default deployment |
| **Censorship Resistance** | Registry-based discovery and routing | Planned/partial; direct P2P and NAT traversal are not established |
| **Metadata Protection** | Content E2EE, routing visible | ⚠️ Partial |

---

## Detailed Guarantees

### Confidentiality

**Property**: Only intended recipients can read message contents.

**Mechanism**:
- ChaCha20-Poly1305 authenticated encryption
- Per-message keys from Double Ratchet
- No plaintext touches the wire or storage

**What it means**: Even network observers, registry servers, or compromised peers cannot read your messages.

---

### Authenticity

**Property**: Messages provably came from claimed sender.

**Mechanism**:
- Ed25519 digital signatures on every message
- Signatures cover: sender, recipient, timestamp, content hash
- Identity keys are long-lived and verifiable

**What it means**: You can cryptographically verify who sent a message. Spoofing is computationally infeasible.

---

### Forward Secrecy

**Property**: Compromise of current keys does not reveal past messages.

**Mechanism**:
- Double Ratchet advances key on every message
- Symmetric ratchet: HKDF key derivation
- DH ratchet: new ephemeral keys periodically
- Old keys are deleted after use

**What it means**: If an attacker steals your keys today, they cannot decrypt messages from yesterday.

---

### Post-Compromise Security

**Property**: Session recovers security after temporary compromise.

**Mechanism**:
- DH ratchet introduces new randomness
- After sufficient message exchange, attacker loses access
- Even if attacker saw all state at time T, they cannot read messages after re-keying

**What it means**: A breach is not permanent. Security self-heals over time.

---

### Non-Repudiation

**Property**: Audit records can make unauthorized changes detectable and support review of recorded actions.

**Mechanism**:
- Configured gateway events are sent to an audit sink
- The audit service supports hash-chain and Merkle verification
- External blockchain anchoring must be separately configured and verified; it is not enabled by the default Compose profile

**Limit**: Audit evidence covers events that were emitted and retained. This document does not claim legal non-repudiation or complete event capture without deployment-specific evidence.

---

### Integrity

**Property**: Authenticated encryption can detect modification on the tested protocol paths.

**Mechanism**:
- Poly1305 MAC authenticated encryption
- Block hash chaining in audit log
- Validation engine rejects invalid data

**Limit**: Component support does not prove that every SDK and transport path applies the same checks.

---

### Replay Resistance

**Property**: Old messages cannot be re-sent to cause duplicate actions.

**Mechanism**:
- Unique message IDs with nonce
- Timestamp validation windows
- Ratchet state prevents key reuse within a session

**Limit**: Replay protection depends on the tested protocol and operation path; this summary does not establish a deployment-wide guarantee.

---

### Capability Control

**Property**: Actions are authorized by explicit, verifiable grants.

**Mechanism**:
- Capabilities specify scope, constraints, expiry
- Capability and policy data are evaluated by configured gateway components
- Gateway components evaluate configured policy before protected operations
- Revocation behavior depends on the configured policy and route

**Limit**: This repository-level summary does not establish complete route coverage or end-to-end enforcement for every tool.

---

### Verifiability

**Property**: Claims about the system can be cryptographically verified.

**Mechanism**:
- Merkle proofs for audit log inclusion
- Signature verification for all artifacts
- External anchors and independent verification require separately configured integrations; they are not a default system property

**Limit**: Merkle proofs establish inclusion relative to the supplied tree state. They do not independently prove that every relevant event was captured or anchored.

---

### Censorship Resistance

**Property**: Reduce reliance on a single peer-discovery or routing path (planned).

**Mechanism**:
- Current deployments use configured gateway and registry services
- DHT/NAT traversal and direct peer-to-peer fallback are planned and not established here

**Limit**: The current architecture does not guarantee communication when the configured gateway or registry is unavailable.

---

### Metadata Protection (Partial)

**Property**: Minimize information leakage about who communicates.

**Current state**:
- ✅ Content is encrypted
- Gateway and registry routing can expose peer and connection metadata
- ⚠️ Peer IDs visible at transport layer
- ⚠️ Message timing can be correlated
- ⚠️ Message sizes can be inferred

**Planned**:
- Onion routing
- Traffic padding
- Cover traffic

**What it means**: Content is private, but network-level observers can learn communication patterns.

---

## Security vs. Convenience Tradeoffs

| Tradeoff | Talos Choice | Rationale |
|----------|--------------|-----------|
| Forward secrecy vs. key stability | Forward secrecy | Security over convenience |
| Audit immutability vs. deletion | Immutability | Proof over forgetting |
| Decentralization vs. consistency | Decentralization | Availability over strong consistency |
| Per-message encryption vs. session | Per-message | Granular forward secrecy |

---

## What Guarantees Require

| Guarantee | Requires |
|-----------|----------|
| Confidentiality | Recipient online to exchange keys |
| Forward secrecy | Both parties delete old keys |
| Non-repudiation | Audit log not corrupted locally |
| Post-compromise | DH exchange after compromise |
| Censorship resistance | At least one network path |

---

**See also**: [Threat Model](threat-model.md) | [Cryptography](../security/cryptography.md) | [Security Proof](../security/mathematical-proof.md)
