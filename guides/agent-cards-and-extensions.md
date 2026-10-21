# A2A Agent Cards & Protocol Extensions Guide

**Status:** Completed & Operational in Production (v1.0)  
**Standard Repositories:**
- **[`talosprotocol/a2a`](https://github.com/talosprotocol/a2a)**: Canonical open-standard A2A v1 core models, registry, and framework adapters.
- **[`talosprotocol/talos-a2a`](https://github.com/talosprotocol/talos-a2a)**: Cryptographic zero-trust security extension (W3C DIDs, Ed25519 card signing, FastAPI route mounters).
- **[`appointment-notifier`](https://github.com/nileshchakraborty/appointment-notifier)**: Live production edge agent node (Raspberry Pi 5) exporting authenticated agent cards.
- **[`talos-dashboard`](https://github.com/talosprotocol/talos-dashboard)**: Operator Dashboard Swarm Directory (`/swarm`).

---

## 1. Overview & Architectural Principles

In multi-agent architectures, agents must discover peer capabilities, negotiate protocols, and establish trust without proprietary silos or single points of failure.

Talos establishes a two-layer discovery paradigm:
1. **Public Discovery Layer:** Standard, unauthenticated Agent Cards served at `/.well-known/agent.json` or `/.well-known/agent-card.json`.
2. **Cryptographic Proof Layer:** Self-sovereign W3C DID documents and `Ed25519Signature2020` cryptographic proofs that bind an Agent Card to a private key, preventing spoofing and unauthorized capability assertions.

```
+------------------------------------------------------------------------------+
|                           A2A Agent Card Standard                            |
|                                                                              |
|  +--------------------+     +---------------------+     +-----------------+  |
|  |  Agent Metadata    |     |  Skills & Actions   |     | Service Routes  |  |
|  |  - name, version   |     |  - read_slots       |     | - rpc           |  |
|  |  - description     |     |  - bulk_cluster     |     | - stream        |  |
|  |  - did:talos:...   |     |  - pipeline:exec    |     | - didDocument   |  |
|  +--------------------+     +---------------------+     +-----------------+  |
|                                                                              |
|  +--------------------+     +---------------------+     +-----------------+  |
|  | Cryptographic Proof|     | Protocol Extensions |     | Adapters        |  |
|  | - Ed25519Signature |     | - security.v1       |     | - LangGraph     |  |
|  | - verificationKey  |     | - capability.v1     |     | - CrewAI        |  |
|  | - assertionMethod  |     | - streaming.v1      |     | - FastAPI       |  |
|  +--------------------+     +---------------------+     +-----------------+  |
+------------------------------------------------------------------------------+
```

---

## 2. A2A Agent Card Schema

An Agent Card defines an agent's identity, endpoint URLs, declared skills, and supported protocol extensions:

```json
{
  "name": "Talos Scout & AI Founders Lounge Agent",
  "description": "Edge scout on Raspberry Pi 5 monitoring appointment slots and clustering updates.",
  "version": "1.0.0",
  "did": "did:talos:agent:scout-v1:8f12d4a",
  "protocol_version": "a2a/v1.0.0",
  "endpoints": {
    "rpc": "http://192.168.1.189:8000/a2a",
    "stream": "http://192.168.1.189:8000/a2a/stream",
    "didDocument": "http://192.168.1.189:8000/.well-known/did.json",
    "extendedAgentCard": "http://192.168.1.189:8000/extendedAgentCard"
  },
  "skills": [
    {
      "id": "scout:read_slots",
      "name": "Read Appointment Slots",
      "description": "Fetch and cluster verified appointment slot availability across consular posts.",
      "tags": ["slots", "appointments", "edge-scout"]
    }
  ],
  "capabilities": {
    "streaming": true,
    "state_recovery": false,
    "temporal_runner": false,
    "extensions": [
      "talos.security.v1",
      "talos.capability.v1",
      "talos.audit.v1",
      "talos.streaming.v1"
    ]
  },
  "proof": {
    "type": "Ed25519Signature2020",
    "created": "2026-10-21T08:00:00Z",
    "verificationMethod": "did:talos:agent:scout-v1:8f12d4a#key-1",
    "proofPurpose": "assertionMethod",
    "proofValue": "3mKx9Z182ba0c812d409bca782103ef1802931a89c0..."
  }
}
```

---

## 3. Cryptographic Verification

To prevent impersonation, Agent Cards are signed using RFC 8032 Ed25519 keypairs:

1. **Canonical Serialization:** The agent card payload without the `proof` key is serialized deterministically (sorted keys, compact delimiters).
2. **Signature Generation:** The private key signs the canonical UTF-8 bytes:
   ```python
   from talos_a2a.identity.card import build_authenticated_agent_card
   from talos_a2a.identity.did import AgentDID

   did = AgentDID.generate("edge-scout")
   card = build_authenticated_agent_card(
       name="Edge Scout",
       description="Pi 5 Slot Scout",
       did=did,
       endpoints={"rpc": "http://192.168.1.189:8000/a2a"},
       skills=[{"id": "scout:read_slots", "name": "Read Slots"}],
       extensions=["talos.security.v1"]
   )
   ```
3. **Verification by Peers:** A consumer verifies the signature against the multibase-encoded public key in the card or W3C DID document:
   ```python
   from talos_a2a.identity.card import verify_agent_card

   is_valid = verify_agent_card(card)
   assert is_valid is True
   ```

---

## 4. Standard A2A Protocol Extensions

Talos defines standardized extension identifiers under `capabilities.extensions`:

| Extension ID | RFC / Specification | Purpose |
| :--- | :--- | :--- |
| `talos.security.v1` | W3C DID + RFC 8032 | Self-sovereign DID resolution and Ed25519 card signature verification. |
| `talos.capability.v1` | W3C ZCAP-LD Inspired | Cryptographic capability tokens for fine-grained action authorization. |
| `talos.audit.v1` | RFC 6962 Merkle Audit | Tamper-evident hash chaining and Merkle root anchoring for compliance. |
| `talos.streaming.v1` | SSE / Chunked Transfer | Real-time token streaming and incremental artifact updates over HTTP. |
| `talos.temporal.v1` | Durable Workflows | Fault-tolerant, replayable long-running multi-agent state machines. |

---

## 5. Framework Adapters

Talos bridges third-party agent orchestration frameworks into standard A2A peers:

### LangGraph Adapter (`LangGraphA2AAdapter`)

Converts a compiled LangGraph `StateGraph` into an A2A-compliant Task runner:

```python
from a2a.adapters.langgraph import LangGraphA2AAdapter
from a2a.models.card import Skill

# Wrap compiled LangGraph runnable
adapter = LangGraphA2AAdapter(
    agent_name="LangGraph Pipeline",
    did="did:talos:agent:pipeline:01",
    graph=compiled_workflow,
    skills=[Skill(id="pipeline:execute", name="Run Enrichment Pipeline")]
)

# Export standard A2A Agent Card
card = adapter.export_agent_card(rpc_endpoint="https://agent.internal/a2a")

# Execute incoming A2A tasks
result_task = await adapter.execute_task(incoming_task)
```

### CrewAI Adapter (`CrewAIA2AAdapter`)

Exposes a multi-agent `Crew` hierarchy as an A2A task endpoint:

```python
from a2a.adapters.crewai import CrewAIA2AAdapter
from a2a.models.card import Skill

adapter = CrewAIA2AAdapter(
    agent_name="CrewAI Research Crew",
    did="did:talos:agent:crew:01",
    crew=research_crew,
    skills=[Skill(id="research:analyze", name="Deep Research Synthesis")]
)

card = adapter.export_agent_card(rpc_endpoint="https://crew.internal/a2a")
result_task = await adapter.execute_task(incoming_task)
```

---

## 6. Swarm Directory UI in Operator Dashboard

The Talos Operator Dashboard includes a real-time **Swarm Directory** at `/swarm`:
- **Live Peer Discovery:** Probes external agents via `/.well-known/agent.json`.
- **Cryptographic Inspector:** Inspects raw W3C DID documents, verification methods, and signatures.
- **One-Click Dispatch:** Directly dispatches A2A tasks to discovered peers via the integrated `/agent` console.
