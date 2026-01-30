# Talos Protocol Documentation

Welcome to the Talos Protocol documentation! This documentation is organized into logical categories for easy navigation.

## Quick Links

- 🚀 [Getting Started](#getting-started) - New to Talos? Start here!
- 📖 [Guides](#guides) - Step-by-step how-to guides
- 🏗️ [Architecture](#architecture) - System design and structure
- ⭐ [Features](#features) - Core capabilities
- 💻 [SDK](#sdk) - Client libraries and integration
- 🔌 [API](#api) - API reference
- 🔒 [Security](#security) - Security documentation
- 🧪 [Testing](#testing) - Testing guides
- 📚 [Reference](#reference) - Glossary and comparisons
- 🔬 [Research](#research) - Whitepaper, roadmap, future work
- 💼 [Business](#business) - Go-to-market and enterprise
- 🌐 [Network Protocols](#network-protocols) - Communication protocols
- ⚙️ [Configuration Reference](#configuration-reference) - Configuration schemas

---

## Getting Started

New to Talos? Start with these guides:

- **[Talos in 60 Seconds](getting-started/talos-60-seconds.md)** - Ultra-quick overview
- **[Mental Model](getting-started/mental-model.md)** - Understand the core concepts
- **[Quickstart Guide](getting-started/quickstart.md)** - Get up and running
- **[Simple Guide](getting-started/simple-guide.md)** - Step-by-step tutorial
- **[One-Command Demo](getting-started/one-command-demo.md)** - Try it now

## Guides

Practical how-to guides for common tasks:

- **[Deployment](guides/deployment.md)** - Production deployment guide
- **[Development](guides/development.md)** - Local development setup
- **[Production Hardening](guides/production-hardening.md)** - Production best practices
- **[Hardening Guide](guides/hardening-guide.md)** - Security hardening
- **[Runbook (Non-Technical)](guides/runbook-non-technical.md)** - Operations guide
- **[Error Troubleshooting](guides/error-troubleshooting.md)** - Common issues

## Architecture

System design and technical architecture:

- **[Overview](architecture/overview.md)** - High-level architecture
- **[Simplified View](architecture/simplified.md)** - Architecture for beginners
- **[Infrastructure](architecture/infrastructure.md)** - Infrastructure design
- **[Wire Format](architecture/wire-format.md)** - Protocol wire format
- **[Protocol Guarantees](architecture/protocol-guarantees.md)** - What Talos guarantees
- **[Threat Model](architecture/threat-model.md)** - Security threat model

## Features

Core features and capabilities:

### Identity & Authentication

- [Agent Identity](features/identity/agent-identity.md)
- [DIDs with DHT](features/identity/dids-dht.md)
- [Key Management](features/identity/key-management.md)

### Authorization

- [Access Control](features/authorization/access-control.md)
- [Capability Authorization](features/authorization/capability-authorization.md)
- [Agent Capabilities](features/authorization/agent-capabilities.md)

### Messaging

- [A2A Channels](features/messaging/a2a-channels.md)
- [Double Ratchet](features/messaging/double-ratchet.md)
- [Group Messaging](features/messaging/group-messaging.md)
- [File Transfer](features/messaging/file-transfer.md)

### Observability

- [Audit Scope](features/observability/audit-scope.md)
- [Audit Use Cases](features/observability/audit-use-cases.md)
- [Audit Explorer](features/observability/audit-explorer.md)
- [Observability](features/observability/observability.md)

### Operations

- [Adaptive Budgets](features/operations/adaptive-budgets.md)
- [Secrets Rotation](features/operations/secrets-rotation.md)
- [Multi-Region](features/operations/multi-region.md)
- [Global Load Balancing](features/operations/global-load-balancing.md)

### Integrations

- [MCP Integration](features/integrations/mcp-integration.md)
- [MCP Cookbook](features/integrations/mcp-cookbook.md)
- [MCP Proof Flow](features/integrations/mcp-proof-flow.md)
- [Framework Integrations](features/integrations/framework-integrations.md)

## SDK

Client libraries and integration guides:

- **[Python SDK](sdk/python-sdk.md)** - Python client library
- **[TypeScript SDK](sdk/typescript-sdk.md)** - TypeScript/JavaScript library
- **[A2A SDK Guide](sdk/a2a-sdk-guide.md)** - Agent-to-Agent messaging guide
- **[SDK Integration](sdk/sdk-integration.md)** - Integration guide
- **[SDK Ergonomics](sdk/sdk-ergonomics.md)** - SDK design principles
- **[Usage Examples](sdk/usage-examples.md)** - Code examples
- **[Examples](sdk/examples.md)** - More examples

## API

API documentation and reference:

- **[API Reference](api/api-reference.md)** - Complete API reference
- **[Schemas](api/schemas.md)** - JSON schema documentation

## Security

Security documentation and best practices:

- **[Cryptography](security/cryptography.md)** - Cryptographic primitives
- **[Security Properties](security/security-properties.md)** - Security guarantees
- **[Mathematical Proof](security/mathematical-proof.md)** - Formal security proof
- **[Validation Engine](security/validation-engine.md)** - Input validation
- **[Security Dashboard](security/security-dashboard.md)** - Security monitoring

## Testing

Testing guides and documentation:

- **[Testing Guide](testing/testing.md)** - How to test Talos
- **[Benchmarks](testing/benchmarks.md)** - Performance benchmarks
- **[Test Manifests](testing/test-manifests.md)** - Test manifest format
- **[Compatibility Matrix](testing/compatibility-matrix.md)** - Platform compatibility

## Network Protocols

- [Talos Overlays](file:///Users/nileshchakraborty/workspace/talos/docs/protocols/overlays.md): Secure mesh networking protocol.

## Configuration Reference

- [Core Schemas](file:///Users/nileshchakraborty/workspace/talos/contracts/schemas/config/v1): JSON schemas for all configuration objects.

## Reference

Reference material and comparisons:

- **[Glossary](reference/glossary.md)** - Terms and definitions
- **[Alternatives Comparison](reference/alternatives-comparison.md)** - How Talos compares
- **[Failure Modes](reference/failure-modes.md)** - Known failure modes
- **[Non-Goals](reference/non-goals.md)** - What Talos doesn't do
- **[Decision Log](reference/decision-log.md)** - Design decisions

## Research

Research papers, roadmap, and future work:

- **[Whitepaper](research/whitepaper.md)** - Technical whitepaper
- **[Roadmap](research/roadmap.md)** - Product roadmap
- **[Future Improvements](research/future-improvements.md)** - Planned features
- **[Agents Research](research/agents.md)** - Agent research
- **[MVP Design](research/mvp-design.md)** - MVP design document
- **[Blockchain](research/blockchain.md)** - Blockchain integration research  
- **[ICP](research/icp.md)** - Internet Computer Protocol
- **[Light Client](research/light-client.md)** - Light client design

## Business

Go-to-market and enterprise documentation:

- **[GTM Plan](business/gtm-plan.md)** - Go-to-market strategy
- **[Why Talos Wins](business/why-talos-wins.md)** - Competitive advantages
- **[Enterprise Performance](business/enterprise-performance.md)** - Enterprise capabilities
- **[Agent Lifecycle](business/agent-lifecycle.md)** - Agent management

---

## Templates

Documentation templates for contributors:

- [API Template](templates/api-template.md)
- [Contributing Template](templates/contributing-template.md)
- [README Template](templates/readme-template.md)
- [README Checklist](templates/readme-checklist.md)

---

## Contributing

See our [contributing guidelines](templates/contributing-template.md) for how to contribute to this documentation.

## License

This documentation is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.
