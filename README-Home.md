# Welcome to the Talos Wiki

> **Talos is the secure communication and trust layer for autonomous AI agents.**

**Version 5.5** | **850+ Tests** | **Multi-Repo** | **Contract-Driven** | **Phase 15: Adaptive Budgets Complete**

---

## 🚀 Start Here

| New to Talos?            | Start with                              |
| ------------------------ | --------------------------------------- |
| **Clone & setup**        | [Getting Started](Getting-Started)      |
| **60-second overview**   | [Talos in 60 Seconds](getting-started/talos-60-seconds.md) |
| **Understand the model** | [Mental Model](getting-started/mental-model.md)      |
| **Hands-on in 10 min**   | [Quickstart](getting-started/quickstart.md)                |
| **Learn the terms**      | [Glossary](reference/glossary.md)        |
| **The Whitepaper**       | [Whitepaper](research/whitepaper.md)    |

---

## 📂 Repository Structure

Talos uses **git submodules** for a multi-repo architecture:

| Repo                  | Purpose                            |
| --------------------- | ---------------------------------- |
| `talos-contracts`     | Source of truth (schemas, vectors) |
| `talos-core-rs`       | Rust performance kernel            |
| `talos-sdk-py`        | Python SDK                         |
| `talos-sdk-ts`        | TypeScript SDK                     |
| `talos-sdk-go`        | Go SDK                             |
| `talos-sdk-java`      | Java SDK                           |
| `talos-gateway`       | FastAPI Gateway                    |
| `talos-audit-service` | Audit aggregator                   |
| `talos-mcp-connector` | MCP bridge                         |
| `talos-dashboard`     | Next.js Console                    |
| `talos-docs`          | Documentation wiki                 |
| `talos-examples`      | Example applications               |

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

**Talos solves this.** See [Why Talos Wins](Why-Talos-Wins) and [Alternatives Comparison](Alternatives-Comparison).

---

## Core Features

| Feature                | Description                                  | Page                                     |
| ---------------------- | -------------------------------------------- | ---------------------------------------- |
| 📜 **Contract-Driven** | Single Source of Truth for schemas & vectors | [Architecture](Architecture)             |
| 🦀 **Rust Kernel**     | High-performance crypto & validation         | [Architecture](Architecture)             |
| 🔐 **Double Ratchet**  | Per-message forward secrecy                  | [Double Ratchet](Double-Ratchet)         |
| 🔒 **Capabilities**    | Scoped, expiring authorization               | [Agent Capabilities](Agent-Capabilities) |
| 📊 **Audit Dashboard** | Next.js UI for proof visualization           | [Audit Explorer](Audit-Explorer)         |
| 🔗 **MCP Connector**   | Zero-code bridge to MCP servers              | [MCP Cookbook](MCP-Cookbook)             |
| 🆔 **Agent Identity**  | Cryptographic DIDs                           | [DIDs & DHT](DIDs-DHT)                   |
| 💬 **A2A Messaging**   | Secure agent-to-agent encrypted channels     | [A2A Channels](A2A-Channels)             |
| 🌎 **Multi-Region**    | Read/write splitting & circuit breaking      | [Multi-Region](Multi-Region)             |
| 🔑 **Rotation**        | Zero-downtime automated secret rotation      | [Secrets Rotation](Secrets-Rotation)     |
| ⚖️ **GSLB**            | Global load balancing & geo-routing          | [Global Load Balancing](Global-Load-Balancing) |
| 💸 **Budgets**         | Atomic cost enforcement for agents           | [Adaptive Budgets](Adaptive-Budgets)     |

---

## Quick Links by Role

### 👨‍💻 Developers

| Goal                 | Page                               |
| -------------------- | ---------------------------------- |
| Clone & build        | [Getting Started](Getting-Started) |
| Python SDK           | [Python SDK](Python-SDK)           |
| TypeScript SDK       | [TypeScript SDK](TypeScript-SDK)   |
| MCP tools            | [MCP Cookbook](MCP-Cookbook)       |
| Development workflow | [Development](Development)         |

### 🔒 Security Reviewers

| Goal         | Page                                       |
| ------------ | ------------------------------------------ |
| Threat model | [Threat Model](Threat-Model)               |
| Guarantees   | [Security Properties](Security-Properties) |
| Cryptography | [Cryptography](Cryptography)               |
| Non-goals    | [Non-Goals](Non-Goals)                     |

### 🏢 Operators

| Goal             | Page                               |
| ---------------- | ---------------------------------- |
| Production setup | [Hardening Guide](Hardening-Guide) |
| Monitoring       | [Observability](Observability)     |
| Testing          | [Testing](Testing)                 |
| Performance      | [Benchmarks](Benchmarks)           |

---

## Contributing

See [Development](Development) for the development workflow, Makefiles, and testing infrastructure.

```bash
# Quick setup
git clone --recurse-submodules git@github.com:talosprotocol/talos.git
./deploy/scripts/setup.sh
./deploy/scripts/run_all_tests.sh
```

---

## License

Apache 2.0 © 2026 Talos Protocol Contributors
