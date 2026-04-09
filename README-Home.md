# Welcome to the Talos Wiki

> **Talos v5.15** | **Phase 15: Adaptive Budgets** | **850+ Verified Tests** | **Multi-Repo Architecture**

---

## 🛡️ The Secure Layer for AI Agents

Talos Protocol is the **definitive security and trust layer** for autonomous AI agents. It provides a cryptographically verifiable, decentralized infrastructure for agent identification, communication, and authorization.

---

## 🚀 Quick Navigation

| 🆕 New to Talos? | 🛠️ Development | 🔒 Security & Policy |
| :--- | :--- | :--- |
| [Quickstart](getting-started/quickstart.md) | [Python SDK](sdk/python-sdk.md) | [Threat Model](architecture/threat-model.md) |
| [Mental Model](getting-started/mental-model.md) | [TypeScript SDK](sdk/typescript-sdk.md) | [Capability System](features/authorization/agent-capabilities.md) |
| [Talos in 60s](getting-started/talos-60-seconds.md) | [Rust Kernel](architecture/overview.md) | [Audit Logging](features/observability/audit-explorer.md) |
| [Architecture](architecture/overview.md) | [Go/Java SDKs](getting-started/getting-started.md) | [Security Proofs](security/mathematical-proof.md) |

---

## 📂 Core Components

Talos is built on a **Contract-Driven Kernel** architecture, ensuring consistency across all implementations.

### 🏛️ The Kernel Layer
- **[Contracts](../contracts/)**: The single source of truth for all schemas and test vectors.
- **[Core-RS](architecture/overview.md)**: High-performance Rust implementation for cryptographic primitives.

### 🔌 Connectivity
- **[AI Gateway](features/integrations/mcp-integration.md)**: Unified entrance for LLM and MCP interactions.
- **[Audit Service](features/observability/observability.md)**: Tamper-evident event logging and verification.
- **[MCP Connector](features/integrations/mcp-cookbook.md)**: Secure tool-use bridge.

### 🛠️ Polyglot SDKs
Talos provides native SDKs for the most popular AI development environments:
- [Python SDK](sdk/python-sdk.md) | [TypeScript SDK](sdk/typescript-sdk.md) | [Rust SDK](sdk/rust-sdk.md) | [Go SDK](getting-started/getting-started.md) | [Java SDK](getting-started/getting-started.md)

---

## 🔥 Current Milestone: Phase 15 (Adaptive Budgets)

This release focuses on **economic security** for autonomous agents:
- **Real-time Quota Enforcement**: Atomic credit tracking for tool calls.
- **Multi-Region Recovery**: Zero-downtime budget synchronization.
- **Deterministic Billing**: Cryptographic proof of usage and cost.

---

## 📊 Project Health

- **Total Tests**: `1,000+` across polyglot SDKs and services
- **Latency (p95)**: `< 5ms` for Authz and Audit ingest
- **Throughput**: `12,000 req/sec` per gateway node
- **Coverage**: `92%` average across services
- **Status**: [Production Ready]

---

> [!TIP]
> **New?** Start with the [Quickstart](getting-started/quickstart.md) to get a local cluster running in 5 minutes.

---

© 2026 Talos Protocol Contributors | [Apache 2.0 License](LICENSE)
