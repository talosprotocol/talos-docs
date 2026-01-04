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

### 2.1 Unified Versioning
All SDKs will follow a **Lock-Step Versioning** model initially, synchronizing with the `talos-contracts` version (currently moving to `v0.2.0`).
- **Action**: Bump all SDKs to `0.2.0-alpha`.
- **Tooling**: Implement a root-level `version-sync` script that updates `pyproject.toml`, `package.json`, `pom.xml`, etc.

### 2.2 Standardized Configuration

#### Python (`pyproject.toml`)
- **Linter**: `ruff` (Select: E, F, I, B, SIM, TID, UP).
- **Formatter**: `ruff format` (Line length: 100).
- **Types**: `mypy` (strict = true).
- **Dependencies**: Pinned ranges (`^X.Y.Z`).

#### TypeScript (`package.json`, `tsconfig.json`)
- **Linter**: `eslint-config-love` (Strict TypeScript).
- **Formatter**: `prettier` (Single quotes, trailing comma).
- **Types**: `strict: true`, `noImplicitAny: true`.

#### Java (`pom.xml`)
- **Formatter**: `spotless-maven-plugin` (Google Java Format).
- **Linter**: `maven-checkstyle-plugin`.

#### Go (`.golangci.yml`)
- **Linter**: `golangci-lint` (enable: `gofmt`, `govet`, `staticcheck`).

#### Rust (`clippy.toml`)
- **Linter**: `clippy::pedantic` (warn), `clippy::nursery` (allow).

### 2.3 Architecture Standards
- **Dependency Injection (DI)**: All applications/SDKs MUST use dependency injection principles.
    - **Java**: Spring Boot (Autowired).
    - **Python**: Constructor injection or `dependencies` (FastAPI style) / `pydantic-settings`.
    - **Typescript**: Constructor injection (e.g. `InversifyJS` or manual pattern).
    - **Go**: Interface injection.
- **Data Modeling**:
    - **Python**: **MUST** use `Pydantic` for all data transfer objects and configuration.

### 2.4 Testing Standards
- **Happy Path Guarantee**: Every feature MUST have at least one explicit "Happy Path" unit test demonstrating success under normal conditions.
- **Coverage**: 80% Minimum line coverage.

## 3. Implementation Roadmap

### Phase 1: Configuration & Architecture Hardening (Immediate)
- [ ] **Python**: Enforce `mypy`, strict `ruff`, refactor to `Pydantic` models if missing.
- [ ] **Java**: Add `spotless` plugin, verify Spring context.
- [ ] **TypeScript**: Audit `tsconfig` strictness, verify DI pattern.

### 2.5 Universal Makefile Interface
Every repository MUST implement these targets:
```makefile
all: install lint test build
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
