---
status: Draft
audience: Enterprise Decision Makers, Legal/Compliance Teams
---

# The Liability Shield: AI Governance That Protects Your Organization

> **Problem**: AI agents create unprecedented liability exposure.  
> **Solution**: Talos provides cryptographic proof of authorization and intent.  
> **Result**: Transform AI liability from "unpredictable risk" to "auditable operations."

---

## The Liability Gap

When an AI agent causes damage, organizations face a critical question:

> **"Can you prove what the AI was authorized to do?"**

| Current State | The Problem |
|---------------|-------------|
| Agent deletes database | "Human error" or "System failure" |
| Agent sends unauthorized email | No proof of who/what approved it |
| Agent accesses sensitive data | Logs show access, not authorization |
| Regulatory audit occurs | Reconstruct intent from chat logs? |

**The gap**: Traditional logging captures *what happened*, but not *who authorized it* or *why*.

---

## The Two-Person Rule for AI

In financial systems, high-value transactions require dual authorization. Talos applies this principle to AI:

```
┌─────────────────────────────────────────────────────────────────┐
│ Traditional AI                                                   │
│                                                                  │
│   Agent ──────────────────────────────────────► Execute          │
│          (No separation of intent from execution)               │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ Talos-Protected AI                                               │
│                                                                  │
│   Agent ───► Supervisor ───► Capability Token ───► Execute      │
│              (Policy check)  (Signed, scoped,     (Validated)   │
│                              time-limited)                       │
└─────────────────────────────────────────────────────────────────┘
```

**The Separation**:
- **The Agent** (wants to act) — submits an ActionRequest with intent
- **The Supervisor** (enforces policy) — evaluates, approves/denies, mints capabilities
- **The Audit Log** (proves everything) — immutable hash chain with blockchain anchoring

---

## Hypervisor vs Supervisor

| Component | Mode | Function |
|-----------|------|----------|
| **Hypervisor** | Passive | Continuously monitors agent intent. "Why is the agent accessing `/etc/shadow`?" |
| **Supervisor** | Active | Holds signing keys. The *only* entity that can mint capability tokens for high-risk actions. |

Together, they create defense in depth:
1. Hypervisor detects anomalies and escalates
2. Supervisor requires explicit approval for high-risk operations
3. Audit log captures both the decision *and* the reasoning

---

## Forensic Reconstruction: The Google Antigravity Scenario

Consider an AI coding assistant with access to a developer's terminal. A prompt injection causes it to execute:

```bash
rm -rf /critical-data
```

### Without Talos

| What Happened | What You Can Prove |
|--------------|-------------------|
| Files deleted | Timestamp, user session |
| Command executed | Terminal history (if enabled) |
| Agent was involved | Maybe, if you logged the session |
| Authorization existed | **Nothing** |

**Result**: "The AI did it" is not a defensible position in court or compliance audits.

### With Talos

The agent's request flow:

```
1. ActionRequest submitted:
   - intent: "Delete directory for cleanup"
   - risk_level: HIGH_RISK
   - resources: [{ path: "/critical-data" }]
   - digest: "abc123..." (tamper-evident)

2. Supervisor evaluates:
   - Policy check: Agent has scope "fs:/projects/*:write"
   - /critical-data is NOT under /projects
   - Decision: DENY
   - rationale: "Path outside authorized scope"

3. Audit entry:
   - prev_entry_digest → entry_digest (hash chain)
   - Anchored to blockchain checkpoint
```

**Result**: Cryptographic proof that:
- The agent *attempted* the deletion
- The supervisor *denied* it based on policy
- The denial reason is recorded and tamper-evident

Even if the agent found a bypass, the audit log would show the unauthorized execution, creating clear evidence of the breach.

---

## The Capability Token Model

Talos capabilities are not just permissions—they're **signed attestations**:

```json
{
  "v": "1",
  "iss": "did:key:z6MkSupervisor...",
  "sub": "did:key:z6MkAgent...",
  "scope": "fs:/projects/demo:write",
  "constraints": {
    "max_depth": 3,
    "exclude_patterns": ["*.key", "*.pem"]
  },
  "iat": 1707400000,
  "exp": 1707403600,
  "delegatable": false,
  "sig": "base64url..."
}
```

**Properties**:
- **Scoped**: Can only affect `/projects/demo`
- **Time-limited**: Expires in 1 hour
- **Constrained**: Cannot touch key files
- **Signed**: Cryptographically bound to supervisor identity
- **Non-delegatable**: Agent cannot pass this to other agents

---

## Compliance Alignment

| Regulation | Talos Capability |
|------------|------------------|
| **SOC 2** Type II | Immutable audit log, access controls, monitoring |
| **SOX** Section 404 | Separation of duties (Agent vs Supervisor), audit trail |
| **GDPR** Article 30 | Records of processing activities with cryptographic proof |
| **NIST AI RMF** | Governance, accountability, transparency, auditability |
| **ISO 27001** | Access control (A.9), logging (A.12.4), audit (A.18.2) |

---

## The Business Case

### Risk Reduction

| Scenario | Without Talos | With Talos |
|----------|---------------|------------|
| AI causes data breach | Full liability exposure | Proof of policy enforcement |
| Regulatory audit | Reconstruct from fragments | Immutable audit export |
| Legal discovery | "We don't know" | Cryptographic evidence chain |
| Insurance claim | Disputed coverage | Clear causation trail |

### Operational Benefits

1. **Faster Incident Response**: Hash chain identifies exactly when/where policy was violated
2. **Reduced Audit Costs**: Export blockchain-anchored proofs instead of manual log review
3. **Insurance Premium Reduction**: Demonstrate proactive AI governance controls
4. **Competitive Differentiation**: "Our AI operations are cryptographically audited"

---

## Implementation Path

```
Phase 1: Observe               Phase 2: Enforce              Phase 3: Prove
─────────────────────         ─────────────────────         ─────────────────────
Deploy Hypervisor             Activate Supervisor           Enable blockchain
(passive monitoring)          (capability minting)          anchoring

• See all agent               • Require tokens for          • Export compliance
  actions                       high-risk ops                 evidence
• Identify risk               • Policy-based                • Third-party
  patterns                      authorization                 verification
• Zero execution              • Gradual rollout             • Legal-grade
  impact                        by risk level                 audit trail
```

---

## Summary

> **Talos transforms AI liability from "unpredictable risk" to "auditable operations."**

The Liability Shield is not about preventing AI from acting—it's about ensuring every action has:

1. **Documented Intent**: What did the agent want to do?
2. **Explicit Authorization**: Who/what approved it?
3. **Cryptographic Proof**: Can you prove it in court?

**The question is no longer "What did the AI do?"**  
**The question becomes "Was the AI authorized to do it?"**

And with Talos, you can always answer that question with cryptographic certainty.

---

**Next Steps**: [Quickstart Guide](../getting-started/quickstart.md) | [Governance Agent](../../governance-agent/README.md) | [Why Talos Wins](./why-talos-wins.md)
