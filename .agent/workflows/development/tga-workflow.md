---
project: docs
description: Build and test TGA contracts and capability validator
---

# TGA (Talos Governance Agent) Development Workflow

This workflow guides development and testing of the TGA implementation across talos-contracts and talos-ai-gateway.

## Phase 9.0: TGA Contracts

### 1. Navigate to contracts repo

```bash
cd deploy/repos/talos-contracts
```

### 2. Validate TypeScript schemas

```bash
cd typescript
npm test test/tga.test.ts test/digest_parity.test.ts
```

### 3. Validate Python digest parity

```bash
cd ../python
pytest tests/test_tga_digest.py -v
```

### 4. Generate new test vectors

```bash
python3 scripts/gen-tga-vectors.py > test_vectors/tga/golden_trace_chain.json
```

## Phase 9.1: Capability Validation

### 5. Navigate to Gateway

```bash
cd ../../talos-ai-gateway
```

### 6. Test capability minting and validation

```bash
python3 tests/test_tga_capability.py
```

### 7. Verify module imports

```bash
python3 -c "from app.domain.tga import CapabilityValidator; print('✓ TGA imports OK')"
```

## Configuration

Set the supervisor's public key for production:

```bash
export TGA_SUPERVISOR_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----
...
-----END PUBLIC KEY-----"
```

## Related Documentation

- [TGA Digest Spec](../../../../contracts/docs/tga/digests.md)
- [Implementation Tracker](../../../../implementation.md)
