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
| **CI/CD** | Inconsistent | Inconsistent | Inconsistent | Inconsistent / Missing | Inconsistent / Missing |

**Key Issues:**
1.  **Divergent Versioning**: SDKs are out of sync, making compatibility tracking difficult.
2.  **Loose Quality Gates**: Java and Python lack strict, auto-enforced formatting and static analysis (e.g. `mypy`).
3.  **Inconsistent Manifests**: Metadata (License, Authors, Repository links) varies.

## 2. Target State

### 2.1 Versioning Strategy (Option A)
**Phase 1 (Stabilization)**: Lock-step versioning (e.g., `0.2.0-alpha` through `0.2.x`) for all SDKs and Contracts.
**Phase 2 (Long-term)**: Decoupled Semantic Versioning.
- SDK Version is independent.
- Compatibility governed by `PROTOCOL_RANGE` + `CONTRACT_HASH` (and `SCHEDULE_HASH` for ratchet).
- Conformance tests select vectors by **Release Set**.

### 2.2 Standardized Configuration

#### Python (`pyproject.toml`)
- **Style**: [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html).
- **Linter**: `ruff` (Google rules).
- **Formatter**: `ruff format` (docstring-code-format = true).
- **Types**: `mypy` (Strict for Core Modules; Gradual for others).
    - **Core**: `canonical`, `wallet`, `mcp`, `session`, `crypto`.
- **DTOs**: `Pydantic` mandated.

#### TypeScript (`package.json`)
- **Style**: [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html).
- **Tooling**: **Option A** - `eslint` + `prettier` configured with Google rules (Minimize churn).
- **Types**: `strict: true`.
    - **Core**: `canonical`, `base64url`, `errors`, `mcp`, `session`.

#### Java (`pom.xml`)
- **Style**: [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html).
- **Formatter**: `spotless-maven-plugin` with `googleJavaFormat()`.
- **DI**: Manual wiring or lightweight interfaces for SDK lib (No Spring in Kernel).
    - **Core**: `canonical`, `crypto`, `mcp`, `session` packages.

#### Go
- **Style**: [Google Go Style](https://google.github.io/styleguide/go/).
- **Linter**: `golangci-lint` (Google best practices).
    - **Core**: `pkg/talos/canonical`, `pkg/talos/crypto`, `pkg/talos/mcp`, `pkg/talos/session`.

#### Rust
- **Linter**: `clippy`.
- **Formatter**: `rustfmt`.
- **Safety**: Fuzz harness for decoders.
    - **Core**: `canonical`, `base64url`, `frame codec`, `crypto`.

#### Shell
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

### 2.6 Acceptance Criteria (Per SDK)
- `make typecheck` passes.
- `make lint` passes.
- `make test` passes with **>= 80% coverage** (100% Happy Path).
- `make conformance RELEASE_SET=<...>` passes for required sets.
- Packaging metadata validates against `sdk_manifest.schema.json`.
- Exports: `SDK_VERSION`, `PROTOCOL_RANGE`, `CONTRACT_HASH`, `SCHEDULE_HASH`.
- Repo-Lint: No deep links, canonicalization via contracts only.

## 3. Implementation Roadmap

### Phase 1: Standards and Contracts First (Foundation)
- [ ] **Specs**: Add `sdk/sdk_manifest.schema.json` and `sdk/error_codes.json` validation to `talos-contracts`.
- [ ] **Makefiles**: Add required targets (`typecheck`, `conformance`) across all SDKs.
- [ ] **Lint**: Decide TS lint strategy (eslint/prettier google config).

### Phase 2: Tooling Enforcement (Per Language)
- [ ] **Python**: `ruff format/lint`, `mypy --strict` (Core), Pydantic DTOs.
- [ ] **Java**: `spotless` (Google Java Format), Verify build/tests (No Spring in Core).
- [ ] **TypeScript**: Strict `tsconfig`, fix lint rules.
- [ ] **Go**: `golangci-lint`, `goimports`.
- [ ] **Rust**: `clippy`, `rustfmt`, Fuzz harnesses.
- [ ] **Version Sync**: Implement script to update version and compatible hashes (`PROTOCOL_RANGE`, `CONTRACT_HASH`).

### Phase 3: CI Templates and Consistency Gates
- [ ] **CI Contract**:
    - `make typecheck`
    - `make lint`
    - `make test`
    - `make conformance` (Non-negotiable)
- [ ] **Repo-Lint**: Add CI job for repo boundary enforcement.
- [ ] **Pre-commit**: Optional (must match CI). CI is the source of truth.

### Phase 4: Version Policy & Release
- [ ] **Lock-step**: Sync all SDKs to `0.2.0-alpha`.
- [ ] **Stamping**: Embed `CONTRACT_HASH` and `SCHEDULE_HASH` into builds.
- [ ] **Artifacts**: Publish with SBOM, Changelog, Conformance Report.
