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

### 2.2 Standardized Configuration (Google Style)

All projects MUST follow [Google Style Guides](https://google.github.io/styleguide/).

#### Python (`pyproject.toml`)
- **Style**: [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html).
- **Linter**: `ruff` (Select rules matching Google style).
- **Formatter**: `ruff format` (docstring-code-format = true).
- **Docstrings**: Google Style (`"""Args: ... Returns: ..."""`).
- **Types**: `mypy` (strict = true).

#### TypeScript (`package.json`)
- **Style**: [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html).
- **Tooling**: `gts` (Google TypeScript Style) instead of standard eslint/prettier.
- **Types**: `strict: true`.

#### Java (`pom.xml`)
- **Style**: [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html).
- **Formatter**: `spotless-maven-plugin` with `googleJavaFormat()`.

#### Go
- **Style**: [Google Go Style](https://google.github.io/styleguide/go/).
- **Linter**: `golangci-lint` configured for Google best practices.

#### Shell
- **Style**: [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html).
- **Linter**: `shellcheck` (enforced in CI).

### 2.3 Architecture Standards (Hexagonal / Ports & Adapters)

All applications MUST follow **Hexagonal Architecture** (Ports and Adapters) to ensure extensibility and separation of concerns.

#### Backend (Hexagonal)
1.  **Domain Layer (Core)**:
    - Pure business logic.
    - **NO dependencies** on frameworks, databases, or external SDKs.
    - Defines **Ports** (Interfaces) for all external interactions (e.g., `RepositoryPort`, `CryptoProviderPort`).
2.  **Infrastructure Layer (Adapters)**:
    - Implements Ports.
    - **Database**: PostgreSQL adapter, In-Memory adapter.
    - **Talos SDK**: The SDK itself is an *Infrastructure Adapter*. **DO NOT** import `talos_sdk` directly in the Domain Layer. Wrap it in a Port (e.g., `TalosServicePort`).
3.  **Application Layer**:
    - Orchestrates Use Cases / Services.
    - Wires Adapters to Ports via Dependency Injection.

#### Frontend (Clean Architecture)
Frontend apps must separate **UI Components** from **Business Logic** and **Data Access**.
1.  **UI/View**: React Components / Tailwind. Dumb rendering.
2.  **Logic/State**: Hooks / Context / Stores.
3.  **Infrastructure**: API Clients / SDK Wrappers.
    - The API Client is an adapter.
    - UI Components should ask for data via a hooked interface (Port), not call `fetch` directly.

#### Extensibility First
- **Database Agnostic**: All apps must support swapping the database (e.g. Postgres <-> SQLite) by implementing the Repository Port.
- **SDK Agnostic**: The system must allow swapping the underlying Talos SDK implementation (e.g. Python SDK <-> Remote GRPC Service) without changing business logic.

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
