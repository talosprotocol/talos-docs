# Performance Benchmarks

This document details the performance characteristics of the Talos Protocol, specifically focusing on cryptographic primitives, message throughput, and MCP tunneling latency.

> **Hardware Context**: Tests performed on a MacBook Pro (M4 Max, 36GB RAM).

## 1. Cryptographic Primitives

Talos uses `cryptography.hazmat` (OpenSSL backend) for high-performance primitives.

| Operation         | Algorithm          | Avg Time (ms) | Throughput (ops/sec) |
| ----------------- | ------------------ | ------------- | -------------------- |
| **Signing**       | Ed25519            | 0.1281 ms     | 7,807                |
| **Verification**  | Ed25519            | 0.1424 ms     | 7,023                |
| **Batch Verify**  | Ed25519 (Parallel) | 0.1578 ms     | 6,337                |
| **Encryption**    | ChaCha20-Poly1305  | 0.0034 ms     | 290,234              |
| **Block Hashing** | SHA-256            | 0.0030 ms     | ~380,000             |

_Table 1: Microbenchmarks of core security functions._

## 2. Message Throughput (Chain Processing)

The internal lightweight blockchain processes blocks sequentially, but validation is parallelized.

- **Block Validation (Standard)**: 0.2412 ms per block
- **Block Validation (Parallel)**: 0.2967 ms per block
- **Hash Calculation (SHA-256)**: < 0.01ms per message
- **End-to-End Latency** (Localhost): ~4-6ms

## 3. MCP Tunneling Performance

This section measures the overhead added by Talos when tunneling JSON-RPC traffic compared to a raw stdio pipe.

### Test Setup

- **Agent**: Mock MCP Client sending `ping` requests.
- **Tool**: Mock MCP Server echoing responses.
- **Transport**: Talos P2P Loopback (Client Proxy -> Server Proxy).

### Results

| Metric                    | Raw Stdio | Talos Tunnel | Overhead |
| ------------------------- | --------- | ------------ | -------- |
| **Round Trip Time (RTT)** | 0.2 ms    | 12.5 ms      | +12.3 ms |
| **Max Requests/Sec**      | ~5000     | ~80          | High     |

**Analysis**:
The overhead comes from:

1.  **Encryption/Signing**: Every JSON-RPC frame is encrypted and signed.
2.  **Network Framing**: `aiohttp`/WebSocket framing.
3.  **Process Context Switching**: Agent -> ClientProxy -> Network -> ServerProxy -> Tool.

> **Note**: For MCP workloads (e.g., FileSystem reads, Database queries), a 12ms latency add-on is negligible compared to the tool's execution time (often 100ms+), making Talos highly viable for real-world agentic workflows.

## 4. File Transfer (Binaries)

| File Size | Transfer Time | Speed     |
| --------- | ------------- | --------- |
| 10 MB     | 0.8s          | 12.5 MB/s |
| 100 MB    | 9.2s          | 10.8 MB/s |
| 1 GB      | 110s          | 9.1 MB/s  |

_Benchmarks ran over local loopback._

## 5. Storage Performance (LMDB)

Talos uses LMDB (Lightning Memory-Mapped Database) for high-performance storage.

| Operation         | Latency (ms) | Throughput (ops/sec) |
| ----------------- | ------------ | -------------------- |
| **Write (Batch)** | 0.0005 ms    | 2,016,214            |
| **Read (Random)** | 0.0003 ms    | 3,922,530            |

_Table 2: Storage Backend Benchmarks_

## 6. Serialization Performance

All data models are Pydantic v2 `BaseModel`, optimized for speed.

| Operation              | Latency (ms) | Throughput (ops/sec) |
| ---------------------- | ------------ | -------------------- |
| **Serialize (JSON)**   | 0.0007 ms    | 1,333,370            |
| **Deserialize (JSON)** | 0.0008 ms    | 1,177,152            |

## 7. Python SDK Benchmarks (talos-sdk-py)

> **Environment**: Python 3.13, Apple Silicon (M4 Max)

### Wallet Operations

| Operation          | Avg Time (ms) | Throughput (ops/sec) |
| ------------------ | ------------- | -------------------- |
| Wallet.generate()  | 0.095 ms      | 10,563               |
| Wallet.from_seed() | 0.066 ms      | 15,089               |
| Wallet.sign(64B)   | 0.065 ms      | 15,442               |
| Wallet.sign(10KB)  | 0.076 ms      | 13,216               |
| Wallet.verify()    | 0.145 ms      | 6,877                |
| Wallet.to_did()    | 0.004 ms      | 269,101              |

### Double Ratchet (A2A Encryption)

| Operation                    | Avg Time (ms) | Throughput (ops/sec) |
| ---------------------------- | ------------- | -------------------- |
| Session create pair (X3DH)   | 1.494 ms      | 669                  |
| Session.encrypt(35B)         | 0.020 ms      | **50,729**           |
| Session.encrypt(10KB)        | 0.057 ms      | 17,456               |
| Session roundtrip(35B)       | 1.496 ms      | 669                  |
| RatchetFrameCrypto.encrypt() | 0.027 ms      | 36,619               |
| RatchetFrameCrypto roundtrip | 1.517 ms      | 659                  |

### Canonical JSON & Digests

| Operation              | Avg Time (ms) | Throughput (ops/sec) |
| ---------------------- | ------------- | -------------------- |
| canonical_json_bytes() | 0.003 ms      | 296,864              |
| SHA256 digest          | 0.000 ms      | **2,616,860**        |

### Session Serialization

| Operation           | Avg Time (ms) | Throughput (ops/sec) |
| ------------------- | ------------- | -------------------- |
| Session.to_dict()   | 0.003 ms      | 391,526              |
| json.dumps(session) | 0.006 ms      | 172,637              |
| json.loads(session) | 0.002 ms      | 410,385              |
| Session.from_dict() | 0.003 ms      | 301,073              |

### Summary by Category

| Category           | Avg ops/sec |
| ------------------ | ----------- |
| Wallet             | 55,048      |
| Double Ratchet     | 17,381      |
| RatchetFrameCrypto | 18,639      |
| Canonical JSON     | 1,456,862   |
| Serialization      | 318,905     |

> **Run benchmarks**: `cd talos-sdk-py && PYTHONPATH=src python benchmarks/bench_crypto.py`
