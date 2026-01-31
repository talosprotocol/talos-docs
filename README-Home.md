<!-- markdownlint-disable MD060 -->
# Welcome to the Talos Wiki

> **Talos is the secure communication and trust layer for autonomous AI agents.**

**Version 5.5** | **850+ Tests** | **Multi-Repo** | **Contract-Driven** | **Phase 15: Adaptive Budgets Complete**

---

## 🚀 Start Here

| New to Talos? | Start with |
| :--- | :--- |
| **Clone & setup** | [Getting Started](getting-started/getting-started.md) |
| **60-second overview** | [Talos in 60 Seconds](getting-started/talos-60-seconds.md) |
| **Understand the model** | [Mental Model](getting-started/mental-model.md) |
| **Hands-on in 10 min** | [Quickstart](getting-started/quickstart.md) |
| **Learn the terms** | [Glossary](reference/glossary.md) |
| **The Whitepaper** | [Whitepaper](research/whitepaper.md) |

---

## 📂 Repository Structure

Talos uses **git submodules** for a multi-repo architecture:

| Repo | Purpose |
| :--- | :--- |
| `talos-contracts` | Source of truth (schemas, vectors) |
| `talos-core-rs` | Rust performance kernel |
| `talos-sdk-py` | Python SDK |
| `talos-sdk-ts` | TypeScript SDK |
| `talos-sdk-go` | Go SDK |
| `talos-sdk-java` | Java SDK |
| `talos-gateway` | FastAPI Gateway |
| `talos-audit-service` | Audit aggregator |
| `talos-mcp-connector` | MCP bridge |
| `talos-dashboard` | Next.js Console |
| `talos-docs` | Documentation wiki |
| `talos-examples` | Example applications |

**Kernel Artifacts** (from `talos-contracts`):

- `schemas/*.json` – JSON Schema definitions
- `test_vectors/*.json` – Golden test cases
- Helper functions – `deriveCursor`, `base64url`, etc.

---

## Why Talos?

AI agents lack a trustable way to:

- **Identify** themselves cryptographically
- **Communicate** without centralized intermediaries
- **Prove** what they did, to whom, and when
- **Authorize** actions across organizational boundaries

**Talos solves this.** See [Why Talos Wins](business/why-talos-wins.md) and [Alternatives Comparison](reference/alternatives-comparison.md).

---

## Core Features

| Feature                | Description                                  | Page                                     |
| :--- | :--- | :--- |
| 📜 **Contract-Driven** | Single Source of Truth for schemas & vectors | [Architecture](architecture/overview.md)             |
| 🦀 **Rust Kernel**     | High-performance crypto & validation         | [Architecture](architecture/overview.md)             |
| 🔐 **Double Ratchet**  | Per-message forward secrecy                  | [Double Ratchet](features/messaging/double-ratchet.md)         |
| 🔒 **Capabilities**    | Scoped, expiring authorization               | [Agent Capabilities](features/authorization/agent-capabilities.md) |
| 📊 **Audit Dashboard** | Next.js UI for proof visualization           | [Audit Explorer](features/observability/audit-explorer.md)           |
| 🔗 **MCP Connector**   | Zero-code bridge to MCP servers              | [MCP Cookbook](features/integrations/mcp-cookbook.md)                |
| 🆔 **Agent Identity**  | Cryptographic DIDs                           | [DIDs & DHT](features/identity/dids-dht.md)                          |
| 💬 **A2A Messaging**   | Secure agent-to-agent encrypted channels     | [A2A Channels](features/messaging/a2a-channels.md)                   |
| 🌎 **Multi-Region**    | Read/write splitting & circuit breaking      | [Multi-Region](features/operations/multi-region.md)                  |
| 🔑 **Rotation**        | Zero-downtime automated secret rotation      | [Secrets Rotation](features/operations/secrets-rotation.md)          |
| ⚖️ **GSLB**            | Global load balancing & geo-routing          | [Global Load Balancing](features/operations/global-load-balancing.md)|
| 💸 **Budgets**         | Atomic cost enforcement for agents           | [Adaptive Budgets](features/operations/adaptive-budgets.md)          |

---

## Quick Links by Role

### 👨‍💻 Developers

| Goal                 | Page                               |
| :--- | :--- |
| Clone & build        | [Getting Started](getting-started/getting-started.md) |
| Python SDK           | [Python SDK](sdk/python-sdk.md)           |
| TypeScript SDK       | [TypeScript SDK](sdk/typescript-sdk.md)   |
| MCP tools            | [MCP Cookbook](features/integrations/mcp-cookbook.md)       |
| Development workflow | [Development](guides/development.md)         |

### 🔒 Security Reviewers

| Goal         | Page                                       |
| :--- | :--- |
| Threat model | [Threat Model](architecture/threat-model.md)               |
| Guarantees   | [Security Properties](security/cryptography.md) |
| Cryptography | [Cryptography](security/cryptography.md)               |
| Non-goals    | [Non-Goals](reference/non-goals.md)                     |

### 🏢 Operators

| Goal             | Page                               |
| :--- | :--- |
| Production setup | [Hardening Guide](guides/hardening-guide.md) |
| Monitoring       | [Observability](features/observability/observability.md)     |
| Testing          | [Testing](testing/testing.md)                 |
| Performance      | [Benchmarks](testing/benchmarks.md)           |

---

## Contributing

See [Development](guides/development.md) for the development workflow, Makefiles, and testing infrastructure.

```bash
# Quick setup
git clone --recurse-submodules git@github.com:talosprotocol/talos.git
./deploy/scripts/setup.sh
./deploy/scripts/run_all_tests.sh
```

---

## License

Apache 2.0 © 2026 Talos Protocol Contributors
