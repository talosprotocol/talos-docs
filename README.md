# Talos Protocol Documentation

**Repo Role**: Central documentation hub, architectural definitions, and mathematical security proofs for the Talos Protocol ecosystem.

## Abstract
Talos is a secure, high-performance messaging layer designed for autonomous AI agents. By integrating the Double Ratchet Algorithm with the Model Context Protocol (MCP), Talos provides confidentiality, integrity, authentication, and forward secrecy for agent-to-agent communication. This repository serves as the canonical source for system architecture, security proofs, and integration guides.

## Introduction
Autonomous agents require a communication substrate that guarantees security without human intervention. Standard transport layers (HTTP/WebSockets) lack intrinsic identity binding and message-level encryption suitable for autonomous negotiation. Talos Protocol solves this by implementing a Double Ratchet session over an immutable ledger for initial key exchange, establishing a secure tunnel for MCP JSON-RPC messages.

## System Architecture

```mermaid
graph TD
    subgraph "Agent Ecosystem"
        A[Python Agent] <-->|MCP| TP[Talos SDK (Py)]
        B[TS Agent] <-->|MCP| TS[Talos SDK (TS)]
        C[Java Agent] <-->|MCP| TJ[Talos SDK (Java)]
        D[Go Agent] <-->|MCP| TG[Talos SDK (Go)]
    end

    subgraph "Infrastructure"
        GW[Talos Gateway]
        AS[Audit Service]
        CN[MCP Connector]
    end

    TP <--> GW
    TS <--> GW
    TJ <--> GW
    TG <--> GW

    GW <--> AS
    GW <--> CN
```

This repository (`talos-docs`) defines the topology above, serving as the architectural anchor for the 12-repository ecosystem.

## Technical Design
### Modules
- **Mathematical Proofs**: Formal verification of security properties.
- **Roadmap**: Strategic development plan (v2+).
- **Design Docs**: ADRs and architectural decisions.
- **Wiki**: Detailed guides and references.

### Data Formats
- **Contracts**: References `talos-contracts` for JSON schemas.
- **Proofs**: Markdown with LaTeX math mode.

## Evaluation
Evaluation: N/A for this repo (See: `talos-contracts` for vector pass rates, or individual SDKs for performance benchmarks).

## Usage
### Quickstart
read the security proof:
```bash
cat Mathematical_Security_Proof.md
```

### Common Workflows
1.  **Architecture Review**: Start with the Wiki or Mermaid diagrams.
2.  **Security Audit**: Verify claims in `Mathematical_Security_Proof.md`.

## Operational Interface
*   `make test`: N/A (Documentation only)
*   `scripts/test.sh`: Validates documentation formatting (planned).

## Security Considerations
*   **Threat Model**: Assumes a hostile network where all transport traffic is observable.
*   **Guarantees**:
    *   **Confidentiality**: Only intended recipient can read messages.
    *   **Integrity**: Messages cannot be modified without detection.
    *   **Authenticity**: Sender identity is cryptographically bound.
    *   **Forward Secrecy**: Compromise of past keys does not compromise future messages.

## References
1.  [Mathematical Security Proof](./Mathematical_Security_Proof.md)
2.  [Talos Contracts](../talos-contracts/README.md)
3.  [Double Ratchet Algorithm](https://signal.org/docs/specifications/doubleratchet/)
4.  [Model Context Protocol](https://github.com/modelcontextprotocol)
