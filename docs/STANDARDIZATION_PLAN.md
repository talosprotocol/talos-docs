# Talos SDK Standardization Plan

## Executive Summary
This document outlines the roadmap to unify packaging, code style, and coding standards across all Talos SDKs (`py`, `ts`, `go`, `java`, `rs`). The goal is to provide a consistent "Developer Experience" (DevEx) and strictly enforce quality gates.

## 1. Identified Gaps

| Feature | Python | TypeScript | Java | Go | Rust |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Versioning** | `0.1.19` | `0.1.18` | `0.1.0` | `v0.x` | `0.1.0` |
| **Linting** | Minimal `ruff` | `eslint` | None | None | `clippy` |
| **Formatting** | Manual | `prettier` | Manual | `gofmt` | `rustfmt` |
| **Type Safety** | Loose | Strict | Static | Static | Static |
| **Build** | `setup.py`/toml | `npm` | `maven` | `go build` | `cargo` |
| **CI/CD** | Inconsistent | Inconsistent | Inconsistent | - | - |

**Key Issues:**
1.  **Divergent Versioning**: SDKs are out of sync, making compatibility tracking difficult.
2.  **Loose Quality Gates**: Java and Python lack strict, auto-enforced formatting and static analysis (e.g. `mypy`).
3.  **Inconsistent Manifests**: Metadata (License, Authors, Repository links) varies.

## 2. Target State

### 2.1 Versioning Strategy (Option A)
**Phase 1 (Stabilization)**: Lock-step versioning (e.g., `0.2.0-alpha` through `0.2.x`) for all SDKs and Contracts.
**Phase 2 (Long-term)**: Decoupled Semantic Versioning.
- SDK Version is independent.
- Compatibility governed by `PROTOCOL_RANGE` + `CONTRACT_HASH`.
- Conformance tests select vectors by **Release Set**.

### 2.2 Standardized Configuration

#### Python (`pyproject.toml`)
- **Style**: [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html).
- **Linter**: `ruff` (Google rules).
- **Formatter**: `ruff format` (docstring-code-format = true).
- **Types**: `mypy` (Strict for Core Modules: `canonical`, `wallet`, `mcp`, `session`; Gradual for others).
- **DTOs**: `Pydantic` mandated.

#### TypeScript (`package.json`)
- **Style**: [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html).
- **Tooling**: **Option A** - `eslint` + `prettier` configured with Google rules (Minimize churn).
- **Types**: `strict: true`.

#### Java (`pom.xml`)
- **Style**: [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html).
- **Formatter**: `spotless-maven-plugin` with `googleJavaFormat()`.
- **DI**: Manual wiring or lightweight interfaces for SDK lib (Avoid heavy Spring in Kernel).

#### Go
- **Style**: [Google Go Style](https://google.github.io/styleguide/go/).
- **Linter**: `golangci-lint` (Google best practices).

#### Rust
- **Linter**: `clippy`.
- **Safety**: Fuzz harness for decoders.
- **Style**: [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html).
- **Linter**: `shellcheck` (enforced in CI).

### 2.3 Architecture Standards

#### SDK Libraries (Kernel + Adapters)
SDKs are libraries, not services. They must use a **Kernel + Adapters** model.
1.  **Kernel**: Pure logic, Schema-bound types, Deterministic Framing, Crypto Interfaces.
    - **NO** heavy framework dependencies (e.g. No Spring in core SDK).
2.  **Adapters**: Implementations for Crypto Provider, Transport, Filesystem.
3.  **Dependency Injection**:
    - **Libraries**: Manual Constructor/Interface injection. Keep it lean.
    - **Apps**: Framework DI (Spring, FastAPI) is acceptable.

#### Backend Apps (Hexagonal)
- Follow Ports and Adapters. Domain decoupled from Infrastructure.

#### Frontend Apps (Clean)
- Separate UI from Logic and Data Adapters.

### 2.4 Testing & Manifest Standards
- **Coverage**: >= 80% Overall.
- **Happy Path**: 100% Coverage for required methods and release-set vectors.
- **Conformance**: Vectors are **required gates**.
- **Manifests**: All SDK manifests (`pyproject.toml`, etc.) MUST validate against `talos-contracts/sdk/sdk_manifest.schema.json`.

### 2.5 Universal Makefile Interface
Every repository MUST implement these targets:
```makefile
all: install lint test build conformance
install:     # Install deps
typecheck:   # Language specific type check
lint:        # Style + Types
format:      # Auto-fix style
test:        # Unit tests
conformance: # Run vectors (Release Sets)
build:       # Compile artifacts
clean:       # Remove artifacts
```

## 3. Implementation Roadmap

### Phase 1: Configuration & Architecture Hardening (Immediate)
- [ ] **Python**: Enforce `mypy`, strict `ruff`, refactor to `Pydantic` models if missing.
- [ ] **Java**: Add `spotless` plugin, verify Spring context.
- [ ] **TypeScript**: Audit `tsconfig` strictness, verify DI pattern.

install: # Install deps
lint:    # Check style & types (fail on error)
format:  # Auto-fix style
test:    # Run unit tests (Must include happy paths)
build:   # Compile artifacts
clean:   # Remove artifacts
```

### Phase 2: Version Synchronization
- [ ] Create `scripts/sync_versions.py`.
- [ ] Bump all SDKs to `0.2.0`.

### Phase 3: CI/CD Enforcement
- [ ] Create `.github/workflows/ci-{lang}.yml` templates.
- [ ] Enforce `make lint` and `make test` in CI.

## 4. Maintenance
- **Dependabot**: Enable for all repos to keep dependencies fresh.
- **pre-commit**: Add `.pre-commit-config.yaml` to enforce standards locally before push.
