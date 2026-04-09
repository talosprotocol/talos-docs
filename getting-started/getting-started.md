# Getting Started

This guide walks you through setting up the Talos development environment.

## Prerequisites

| Tool | Version | Check |
| :--- | :--- | :--- |
| Python | 3.11+ | `python3 --version` |
| Node.js | 20+ | `node --version` |
| Rust | stable | `cargo --version` |
| Git | 2.x | `git --version` |

## Step 1: Clone with Submodules

```bash
# SSH (recommended if you have keys configured)
git clone --recurse-submodules git@github.com:talosprotocol/talos.git

# HTTPS (alternative)
git clone --recurse-submodules https://github.com/talosprotocol/talos.git

cd talos
```

> **Already cloned without submodules?**
>
> ```bash
> git submodule update --init --recursive
> ```

## Step 2: Run Setup

The setup script initializes all submodules and configures SSH/HTTPS fallback:

```bash
./deploy/scripts/setup.sh
```

**Environment Variables:**

| Variable | Default | Description |
| :--- | :--- | :--- |
| `TALOS_SETUP_MODE` | `lenient` | `lenient` = warn on missing repos, `strict` = fail |
| `TALOS_USE_GLOBAL_INSTEADOF` | `0` | Set to `1` to configure HTTPS fallback globally |

## Step 3: Validate Toolchain

```bash
# Check all prerequisites
./deploy/scripts/run_all_tests.sh --help
```

The test runner checks for:

- supported CLI flags and target selection
- required local toolchain for the selected component entrypoints
- owned test entrypoints such as `.agent/test_manifest.yml`, `scripts/test.sh`, `make test`, or `npm test`

## Step 4: Run Tests

```bash
# Run the required component set with manifest-backed CI defaults
./deploy/scripts/run_all_tests.sh --ci

# Run a wider/integration-oriented slice
./deploy/scripts/run_all_tests.sh --full

# Test only one component
./deploy/scripts/run_all_tests.sh --only talos-contracts

# Test only changed SDK repos
./deploy/scripts/run_all_tests.sh --changed --only category:sdk
```

## Step 5: Start Services

```bash
# Start all services (validates, rebuilds if needed)
./deploy/scripts/start_all.sh

# Verify services are running
curl http://localhost:8000/api/gateway/status  # Gateway
curl http://localhost:3000                      # Dashboard
```

## Per-Component Development

The root workspace `Makefile` is the supported default:

```bash
make test
make test TEST_ARGS="--only talos-dashboard --skip-build"
make dev
```

Many components also have their own `Makefile` or `scripts/test.sh`, but that is not universal across every repo. For example:

```bash
cd services/ai-gateway
make test

cd site/dashboard
bash scripts/test.sh
```

## Directory Structure

```text
talos/
├── contracts/               # talos-contracts (Schemas & Vectors)
├── core/                    # talos-core-rs (Rust Performance Kernel)
├── sdks/                    # Polyglot SDKs
│   ├── python/              # talos-sdk-py
│   ├── typescript/          # talos-sdk-ts
│   ├── go/                  # talos-sdk-go
│   ├── java/                # talos-sdk-java
│   └── rust/                # talos-sdk-rust
├── services/                # Backend Services
│   ├── ai-gateway/          # LLM & MCP Unified Access
│   ├── audit/               # Tamper-Evident Audit Log
│   ├── mcp-connector/       # Secure Tool Sandbox
│   └── configuration/       # Adaptive Budgets & Policy
├── site/                    # Web Components
│   ├── dashboard/           # Security Console (Next.js)
│   └── marketing/           # Landing Page
├── deploy/                  # Infrastructure & Scripts
│   ├── k8s/                 # Kubernetes Manifests
│   ├── helm/                # Helm Charts
│   └── scripts/             # Setup & Orchestration Scripts
├── docs/                    # Documentation (talos-docs)
├── scripts/                 # Auxiliary Python/Bash Scripts
└── tools/                   # talos-tui & Setup Helpers
```

## Troubleshooting

### SSH fails, stuck on "Permission denied"

```bash
# Use HTTPS fallback
TALOS_USE_GLOBAL_INSTEADOF=1 ./deploy/scripts/setup.sh
```

### Submodule shows "(deleted)" or path missing

```bash
git submodule update --init --recursive
```

### Clean slate (remove all dependencies)

```bash
./deploy/scripts/cleanup_all.sh
./deploy/scripts/setup.sh
```

## Next Steps

- [Development Workflow](../guides/development.md) – Makefiles, testing, scripts
- [Architecture](../architecture/overview.md) – System design
- [Testing](../testing/testing.md) – Test suite details
- [Python SDK](../sdk/python-sdk.md) – Use the Python client
- [TypeScript SDK](../sdk/typescript-sdk.md) – Use the TypeScript client
