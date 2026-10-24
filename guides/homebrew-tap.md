# Homebrew Tap Guide

The official Homebrew tap for [Talos Protocol](https://talosprotocol.com) provides pre-configured, isolated CLI tools, interactive monitoring dashboards, and autonomous agent services for macOS and Linux.

Repository: [github.com/talosprotocol/homebrew-tap](https://github.com/talosprotocol/homebrew-tap)

---

## 1. Tapping the Repository

Add the official Talos Protocol tap to your local Homebrew installation:

```bash
brew tap talosprotocol/tap
```

You only need to run this command once. After tapping, all Talos Protocol formulae are available directly via `brew install <formula>`.

---

## 2. Available Formulae

| Formula | Description | Binaries Provided | Minimum Python |
| :--- | :--- | :--- | :--- |
| **`talos`** | Core protocol CLI and server daemon | `talos`, `talos-server` | Python 3.11+ |
| **`talos-tui`** | Terminal User Interface monitoring and control dashboard | `talos-tui` | Python 3.11+ |
| **`talos-gateway`** | Unified LLM Inference and MCP Tool Gateway CLI | `talos-gateway` | Python 3.11+ |
| **`talos-ucp`** | Universal Commerce Protocol (UCP) connector MCP server | `talos-ucp` | Python 3.10+ |
| **`talos-sdk`** | Talos SDK CLI & protocol conformance test harness | `talos-sdk` | Python 3.10+ |

---

## 3. Installation Guide

### Core Protocol CLI & Server (`talos`)

The flagship command-line tool for peer-to-peer MCP tunneling, Double Ratchet session establishment, wallet initialization, and local node registry:

```bash
brew install talos
```

Verify installation:
```bash
talos --help
talos-server --help
```

### Terminal Dashboard (`talos-tui`)

An interactive, terminal-based monitoring console built with Textual that tracks service health, Double Ratchet sessions, capability tokens, and audit receipts in real time:

```bash
brew install talos-tui
```

Launch the dashboard:
```bash
# Live mode (connects to local AI Gateway & Audit stack)
TALOS_TUI_ADMIN_SECRET=<your-admin-secret> talos-tui

# Mock/demo mode
TALOS_TUI_MOCK_DATA=1 talos-tui
```

### AI Gateway CLI (`talos-gateway`)

Unified management CLI and server for multi-model LLM routing, upstream credential encryption, and scoped capability enforcement:

```bash
brew install talos-gateway
```

Verify installation:
```bash
talos-gateway --help
```

### Universal Commerce Protocol Connector (`talos-ucp`)

A Model Context Protocol (MCP) server enabling Talos agents to discover merchants and execute signed, policy-guarded checkouts across the Universal Commerce Protocol:

```bash
brew install talos-ucp
```

Test MCP stdio connection:
```bash
talos-ucp
```

### Talos SDK Conformance Suite (`talos-sdk`)

Test harness and verification tool for ensuring agent implementations conform to official `talos-contracts` vector suites:

```bash
brew install talos-sdk
```

Run test vectors:
```bash
talos-sdk --vectors ./path/to/test_vectors.json --report ./junit.xml
```

---

## 4. Single-Command Direct Installs

You can also install any formula directly without explicitly running `brew tap`:

```bash
# Core protocol
brew install talosprotocol/tap/talos

# Terminal Dashboard
brew install talosprotocol/tap/talos-tui

# AI Gateway
brew install talosprotocol/tap/talos-gateway

# UCP Connector
brew install talosprotocol/tap/talos-ucp

# SDK Conformance Harness
brew install talosprotocol/tap/talos-sdk
```

---

## 5. Updates & Maintenance

To check for formula updates across all Talos Protocol tools:

```bash
brew update
brew upgrade talos talos-tui talos-gateway talos-ucp talos-sdk
```

To remove a tool:

```bash
brew uninstall talos
```

To remove the tap completely:

```bash
brew untap talosprotocol/tap
```

---

## 6. Continuous Integration & Quality Assurance

All formulae in `talosprotocol/homebrew-tap` are strictly audited with Homebrew's test bot on every commit and pull request:
- Automated syntax validation (`brew test-bot --only-tap-syntax`)
- Automated strict audit (`brew audit --strict`)
- Multi-platform CI testing across both **macOS (`macos-14`)** and **Linux (`ubuntu-latest`)** runners.

Report issues or formula bug reports to the [talosprotocol/homebrew-tap issue tracker](https://github.com/talosprotocol/homebrew-tap/issues).
