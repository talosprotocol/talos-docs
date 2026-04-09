# Development

This guide covers the development workflow for the Talos workspace. Talos still tracks component ownership in [deploy/submodules.json](../../deploy/submodules.json), but day-to-day development happens from this monorepo root.

## Repository Structure

Talos tracks component ownership through the submodule manifest in [deploy/submodules.json](../../deploy/submodules.json). The current workspace includes a mix of contracts, SDKs, services, sites, and tools:

| Repo | Type | Tech |
| :--- | :--- | :--- |
| `talos-contracts` | Library | TypeScript + Python |
| `talos-core-rs` | Library | Rust + PyO3 |
| `talos-sdk-py` | Library | Python |
| `talos-sdk-ts` | Library | TypeScript |
| `talos-sdk-go` | Library | Go |
| `talos-sdk-java` | Library | Java |
| `talos-sdk-rust` | Library | Rust |
| `talos-gateway` | Service | FastAPI + Rust |
| `talos-ai-gateway` | Service | FastAPI |
| `talos-audit-service` | Service | FastAPI |
| `talos-configuration-service` | Service | FastAPI |
| `talos-mcp-connector` | Service | Python |
| `talos-ucp-connector` | Service | Java/Spring |
| `talos-dashboard` | Service | Next.js |
| `talos-aiops` | Service | Python/Go |
| `talos-governance-agent` | Service | Python |

## Root Makefile and Component Commands

The root `Makefile` is the supported entrypoint for common workspace tasks:

```bash
make build
make test
make test TEST_ARGS="--only talos-contracts"
make test TEST_ARGS="--only category:sdk --changed"
make test-all
```

Many major components still ship their own `Makefile` or `scripts/test.sh`, but that interface is not uniform across every repo in `services/`, `site/`, or `tools/`. When a component does not have a `Makefile`, use its owned test/start entrypoint directly.

## Master Scripts

### `setup.sh` – Initialize Submodules

```bash
./deploy/scripts/setup.sh
```

| Variable                     | Default   | Description                     |
| :--------------------------- | :-------- | :------------------------------ |
| `TALOS_SETUP_MODE`           | `lenient` | `strict` fails on missing repos |
| `TALOS_USE_GLOBAL_INSTEADOF` | `0`       | Set `1` for global HTTPS config |

### `start_all.sh` – Start All Services

Validates services, rebuilds if unhealthy, restarts:

```bash
./deploy/scripts/start_all.sh
```

Services started:

| Service              | Port | Description         |
| :------------------- | :--- | :------------------ |
| talos-gateway        | 8000 | Security Kernel     |
| talos-ai-gateway     | 8001 | AI Safety Perimeter |
| talos-audit-service  | 8002 | Merkle Audit        |
| talos-config-service | 8003 | Adaptive Budgets    |
| talos-dashboard      | 3000 | Admin UI            |

### `cleanup_all.sh` – Full Clean

Stops all services and removes dependencies:

```bash
./deploy/scripts/cleanup_all.sh
```

Leaves only source code, ready for fresh `setup.sh`.

### `run_all_tests.sh` – Master Test Runner

```bash
# Show supported flags
./deploy/scripts/run_all_tests.sh --help

# Required component set with manifest-backed CI defaults when available
./deploy/scripts/run_all_tests.sh --ci

# Wider/full run across selected components
./deploy/scripts/run_all_tests.sh --full

# Narrow to dirty SDK repos only
./deploy/scripts/run_all_tests.sh --changed --only category:sdk

# Single component without build-heavy steps
./deploy/scripts/run_all_tests.sh --only talos-contracts --skip-build
```

Runner behavior:

- Prefers `.agent/test_manifest.yml` when a component ships one.
- Otherwise falls back to the nearest owned test entrypoint such as `scripts/test.sh`, `make test`, or `npm test`.
- `--only` accepts a repo name, repo path, basename, or `category:<name>`.
- `--with-live` is supported as an alias for a wider integration-oriented run and sets `TALOS_WITH_LIVE=true`.

## Environment Variables

| Variable               | Default      | Description                      |
| :--------------------- | :----------- | :------------------------------- |
| `TALOS_ENV`            | `production` | Set to `test` during tests       |
| `TALOS_RUN_ID`         | `default`    | Unique test run ID for isolation |
| `TALOS_GATEWAY_PORT`   | `8000`       | Gateway port                     |
| `TALOS_AI_GATEWAY_PORT`| `8001`       | AI Gateway port                  |
| `TALOS_DASHBOARD_PORT` | `3000`       | Dashboard port                   |

## Boundary Rules

**Contract-First Architecture:**

```text
talos-contracts (source of truth)
        ↓
    Publishes:
    - @talosprotocol/contracts (npm)
    - talos-contracts (PyPI)
        ↓
    Consumed by:
    - talos-sdk-*
    - talos-gateway
    - talos-dashboard
```

**Rules:**

1. ❌ No reimplementing `deriveCursor`, `base64url`, etc.
2. ❌ No `btoa`/`atob` in browser code
3. ❌ No deep cross-repo imports
4. ✅ Use published packages only

## Workflow: Adding a Feature

1. **Contracts first**: Start with schema/vector changes in `talos-contracts`
2. **SDK updates**: Propagate to `talos-sdk-py` / `talos-sdk-ts`
3. **Service updates**: Update Gateway, Audit, MCP if needed
4. **Dashboard**: Update UI if user-facing

## Workflow: Running CI Locally

Mirror CI behavior:

```bash
# Strict submodule check
TALOS_SETUP_MODE=strict ./deploy/scripts/setup.sh

# Full CI pipeline
./deploy/scripts/check_boundaries.sh
./deploy/scripts/ci_verify_vectors.sh
./deploy/scripts/run_all_tests.sh --ci
```

## Logs and Reports

| Path                   | Description       |
| :--------------------- | :---------------- |
| `/tmp/talos-*.log`     | Service logs      |
| `/tmp/talos-*.pid`     | Service PIDs      |
| `deploy/reports/logs/` | Test runner logs  |

## Git Submodule Workflow

### Update submodule to latest

```bash
cd contracts
git pull origin main
cd ../..
git add contracts
git commit -m "chore: update talos-contracts submodule"
```

### Check submodule status

```bash
git submodule status
```

### Reinitialize all

```bash
git submodule update --init --recursive
```
