# Talos Protocol Benchmarks
Date: 2026-04-12 23:54:35

## Cryptography
| Operation                 | Latency   | Throughput (ops/s) |
|---------------------------|-----------|----------------------|
| Sign (Ed25519)            | 0.1239ms | 8,073 |
| Verify (Ed25519)          | 0.1379ms | 7,252 |
| Batch Verify (Parallel)   | 0.1563ms | 6,399 |
| Encrypt (ChaCha20)        | 0.0034ms | 292,412 |

## Validation
| Operation                 | Latency   | Throughput (ops/s) |
|---------------------------|-----------|----------------------|
| Standard Validation       | 0.2385ms | 4,193 |
| Parallel Validation       | 0.2849ms | 3,510 |

## Serialization
| Operation                 | Latency   | Throughput (ops/s) |
|---------------------------|-----------|----------------------|
| Serialize (JSON)          | 0.0010ms | 965,119 |
| Deserialize (JSON)        | 0.0008ms | 1,190,878 |

## Storage (LMDB)
| Operation                 | Latency   | Throughput (ops/s) |
|---------------------------|-----------|----------------------|
| Write (Batch)             | 0.0004ms | 2,754,916 |
| Read (Random)             | 0.0003ms | 3,921,569 |
