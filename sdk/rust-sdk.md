# Rust SDK

> **Official Talos Protocol Rust Client**

## Overview

The Rust SDK provides Talos protocol primitives and client helpers for high-performance, strongly typed integrations. It is the primary native Rust surface for canonical JSON, signing, capability verification, and A2A v1 interoperability.

## Current Scope

- Contract-pinned conformance against the shared Talos SDK release set
- Canonical JSON and signing helpers
- Capability verification primitives
- A2A v1 Agent Card discovery and JSON-RPC helpers
- SSE-based A2A streaming with native `Stream<Item = Result<...>>` returns

## Quick Links

- [Rust SDK Repository Notes](../../sdks/rust/README.md)
- [A2A SDK Guide](a2a-sdk-guide.md)
- [SDK Integration](sdk-integration.md)
- [Usage Examples](usage-examples.md)

## Status

The Rust SDK is actively maintained in this workspace under [sdks/rust](../../sdks/rust). For the most current implementation details and conformance notes, see the package README there.
