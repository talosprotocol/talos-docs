# A2A v1 Rollout Plan

Verified against the public A2A documentation on March 13, 2026.

Relevant sources:

- [A2A latest docs](https://a2a-protocol.org/latest/)
- [What is new in A2A v1](https://a2a-protocol.org/latest/whats-new-v1/)
- [A2A project repository](https://github.com/a2aproject/A2A)

## Why this plan exists

Talos already exposes two different A2A concepts:

- A standards-style JSON-RPC task surface in [services/ai-gateway/app/domain/a2a/dispatcher.py](../../services/ai-gateway/app/domain/a2a/dispatcher.py)
- A Talos-native secure channel API in [services/ai-gateway/app/api/a2a/routes.py](../../services/ai-gateway/app/api/a2a/routes.py)

Those should not continue to evolve as if they are the same protocol. The public A2A standard should be the external contract. Talos secure channels should remain a Talos extension.

## Current repo state

### What exists today

- Legacy discovery and compat JSON-RPC in [services/ai-gateway/app/api/a2a/agent_card.py](../../services/ai-gateway/app/api/a2a/agent_card.py)
- JSON-RPC task dispatch in [services/ai-gateway/app/domain/a2a/dispatcher.py](../../services/ai-gateway/app/domain/a2a/dispatcher.py)
- Session, frame, and group endpoints in [services/ai-gateway/app/api/a2a/routes.py](../../services/ai-gateway/app/api/a2a/routes.py)
- Legacy compat contracts in [contracts/schemas/a2a](../../contracts/schemas/a2a)
- Versioned A2A v1 contracts in [contracts/schemas/a2a/v1](../../contracts/schemas/a2a/v1) with matching vectors in [contracts/test_vectors/a2a/v1](../../contracts/test_vectors/a2a/v1)
- SDK support for Talos secure-channel transport in [sdks/python/src/talos_sdk/a2a](../../sdks/python/src/talos_sdk/a2a)

### Main gaps versus current A2A v1

- The repo now carries side-by-side A2A v1 contract schemas and vectors, and strict `v1` now rejects legacy JSON-RPC aliases, but the runtime migration still keeps those aliases available in `dual` mode for compat callers.
- The repo now defaults to `dual`, so the public Agent Card is standards-first by default while authenticated extended discovery can still advertise compat during migration.
- Compat JSON-RPC still leans on coarse `a2a.invoke` and `a2a.stream` scopes, while the A2A v1 RPC adapter now requires operation-level permissions in strict `v1` and keeps the coarse fallback only in `dual` mode during migration.

## Target architecture

Talos should expose:

- A canonical A2A v1 surface from `services/ai-gateway`
- A versioned discovery document that advertises current A2A interfaces first
- Talos secure channels and attestation as documented extensions
- Existing compat paths during migration, but not as the long-term default

## Workstreams

### WS1 Contracts

Owner: `contracts`

Files:

- [contracts/schemas/a2a](../../contracts/schemas/a2a)
- [contracts/test_vectors/a2a](../../contracts/test_vectors/a2a)

Deliverables:

- Add versioned A2A v1 schemas
- Keep current Talos compat schemas side-by-side
- Add vectors for discovery, send, streaming, task retrieval, task list, cancel, subscribe, and push notification configuration

Current implementation note:

- Versioned A2A v1 schemas now live in [contracts/schemas/a2a/v1](../../contracts/schemas/a2a/v1), with mirrored vectors in [contracts/test_vectors/a2a/v1](../../contracts/test_vectors/a2a/v1) and synced Python package assets.

### WS2 Gateway Protocol Adapter

Owner: `services/ai-gateway`

Files:

- [services/ai-gateway/app/main.py](../../services/ai-gateway/app/main.py)
- [services/ai-gateway/app/api/a2a](../../services/ai-gateway/app/api/a2a)
- [services/ai-gateway/app/domain/a2a](../../services/ai-gateway/app/domain/a2a)

Deliverables:

- Introduce a versioned `a2a_v1` adapter over the existing task store and routing layers
- Support `compat`, `dual`, and `v1` protocol modes
- Keep compat behavior stable until interop is validated

### WS3 RBAC and Auth

Owner: `services/ai-gateway` and `contracts`

Files:

- [services/ai-gateway/app/config/surface_registry.json](../../services/ai-gateway/app/config/surface_registry.json)
- [contracts/inventory/gateway_surface.json](../../contracts/inventory/gateway_surface.json)

Deliverables:

- Move from coarse `a2a.invoke` to operation-level permissions
- Add explicit permissions for discovery, send, get, list, cancel, subscribe, and push notification management
- Keep current scope mappings during migration

Current implementation note:

- The A2A v1 RPC adapter now recognizes `a2a.discovery.read`, `a2a.send`, `a2a.get`, `a2a.list`, `a2a.cancel`, `a2a.subscribe`, and `a2a.push_config.{read,write}`. Strict `v1` requires those method-level scopes, while `dual` still honors legacy `a2a.invoke` and `a2a.stream` during migration.
- The gateway auth path now resolves `/rpc` permissions from the contract inventory by JSON-RPC method name and alias before request dispatch, instead of treating `/rpc` as one coarse route grant.

### WS4 Talos Secure-Channel Extension

Owner: `services/ai-gateway` and `sdks/python`

Files:

- [services/ai-gateway/app/api/a2a/routes.py](../../services/ai-gateway/app/api/a2a/routes.py)
- [sdks/python/src/talos_sdk/a2a](../../sdks/python/src/talos_sdk/a2a)

Deliverables:

- Reframe Double Ratchet sessions and frames as Talos extensions
- Document how those extensions layer on top of standard A2A
- Preserve replay protection, auditability, and attestation

### WS5 SDKs and Interop

Owner: `sdks/python` and `sdks/typescript`

Files:

- [sdks/python/tests/test_a2a.py](../../sdks/python/tests/test_a2a.py)
- [sdks/typescript/packages](../../sdks/typescript/packages)

Deliverables:

- Add standards-first A2A v1 client helpers
- Add live interop tests against at least one external A2A implementation
- Keep Talos secure-channel SDK support as an additional layer

Current implementation note:

- The Python and TypeScript SDKs now ship standards-first A2A v1 JSON-RPC clients with Agent Card discovery, `/rpc` helpers, and Talos extension introspection.
- Those SDK helpers now emit canonical A2A v1 operations such as `GetExtendedAgentCard`, `SendMessage`, `ListTasks`, and `SubscribeToTask` by default instead of Talos migration aliases.
- Python and TypeScript now also expose opt-in upstream interop profiles: `upstream_v0_3` for root-path `v0.3.0` JSON-RPC (`agent/getAuthenticatedExtendedCard`, `message/send`, `message/stream`) and `upstream_java_hybrid` for the official Java sample's root-path canonical JSON-RPC plus mixed discovery/task surface.
- The Go, Rust, and Java SDKs now ship a smaller standards-first A2A v1 surface with Agent Card discovery, canonical `/rpc` helpers, Talos extension introspection, collect-style streaming helpers, callback-style per-event handling, and native stream-return APIs for `SendStreamingMessage` and `SubscribeToTask`.
- The repo now includes a local reference-style fixture at [sdks/python/examples/a2a_v1_reference_server.py](../../sdks/python/examples/a2a_v1_reference_server.py), plus live smoke examples in [sdks/python/examples/a2a_v1_live_interop.py](../../sdks/python/examples/a2a_v1_live_interop.py) and [sdks/typescript/examples/a2a_v1_live_interop.mjs](../../sdks/typescript/examples/a2a_v1_live_interop.mjs) that exercise canonical unary and streaming methods over real HTTP.
- The repo now also pins official upstream validation targets in [scripts/python/a2a_upstream_targets.json](../../scripts/python/a2a_upstream_targets.json) and exposes a planner/runner in [scripts/python/run_a2a_upstream_interop.py](../../scripts/python/run_a2a_upstream_interop.py), including an opt-in official TCK command path once a local `a2a-tck` checkout is available. The current target choice and TCK workflow are documented in [A2A Upstream Interop](a2a-upstream-interop.md).
- The first live third-party run against the pinned official Python Hello World sample now passes through that runner when the manifest-selected `upstream_v0_3` profile is used: Python and TypeScript both completed discovery, authenticated extended discovery, `message/send`, and `message/stream` against the official sample on `2026-03-14`.
- A second live third-party run now also passes against the official JavaScript SDK sample agent on `2026-03-14`: Python and TypeScript completed discovery, `message/send`, `tasks/get`, `message/stream`, and `tasks/resubscribe`, while extended discovery is skipped because that upstream sample explicitly advertises `supportsAuthenticatedExtendedCard=false`.
- A third live third-party run now also passes against the official Java Hello World server on `2026-03-14`: Python and TypeScript completed discovery, root-path canonical `SendMessage`, and root-path canonical `SendStreamingMessage` through the `upstream_java_hybrid` profile, while extended discovery is skipped because that upstream sample advertises `capabilities.extendedAgentCard=false`.
- Go, Rust, and Java now expose native language-idiomatic stream returns too: channels in Go, `Stream<Item = Result<...>>` in Rust, and `Iterable` in Java.
- In `dual` mode, the public `/.well-known/agent-card.json` stays standards-first; compat is only advertised through authenticated extended discovery.
- The official TCK has now been run against a live local Talos gateway on `2026-03-14`. After fixing public discovery defaults, bearer-auth injection, and a `dual`-mode root JSON-RPC compatibility alias, then running the gateway in an explicit mock-backed local mode for deterministic task execution, the mandatory suite improved to `61 passed, 26 failed, 29 skipped`.
- The remaining TCK failures are now concentrated in `v0.3.0`-specific compatibility buckets rather than basic bootstrapping: `securitySchemes` shape expectations, local-hostname sensitivity checks against `127.0.0.1`, and task lifecycle/list semantics that assume a longer-lived working/cancelable state than the current mock-backed Talos run exposes.

### WS6 Docs and Positioning

Owner: `docs` and root repo

Files:

- [README.md](../../README.md)
- [docs/features/messaging/a2a-channels.md](../features/messaging/a2a-channels.md)
- [docs/sdk/a2a-sdk-guide.md](../sdk/a2a-sdk-guide.md)

Deliverables:

- Separate “Talos secure channels” from “A2A protocol support”
- Publish compatibility and migration guidance
- Add examples for both standards mode and Talos extension mode

## PR sequence

### PR1

Title: `feat(a2a): add v1 contracts and gateway discovery scaffold`

Scope:

- Add a protocol mode flag in `ai-gateway`
- Add a versioned `a2a_v1` scaffold package
- Serve a v1-style Agent Card in `dual` and `v1` modes
- Add a placeholder `/rpc` endpoint that is inert in `compat` mode
- Add tests for protocol gating and discovery shape
- Do not change the existing compat task execution path yet

Acceptance:

- Existing compat tests still pass
- The v1 discovery route is available in `dual` and `v1`
- The RPC stub is hidden in `compat`
- The repo makes no claim of full A2A v1 compliance yet

### PR2

- Add A2A v1 send and get task mapping over the current task store

### PR3

- Add streaming, subscribe, and push notification configuration support

### PR4

- Split RBAC permissions and update gateway surface inventory

### PR5

- Reframe Talos secure channels as explicit protocol extensions

### PR6

- Add SDK clients, docs, and live interop validation

Status:

- SDK clients and docs are now present across Python, TypeScript, Go, Rust, and Java, with discovery, canonical RPC, streaming/subscription, and native language-idiomatic streaming ergonomics.
- The repo has a local reference-style live smoke harness with Python and TypeScript HTTP smokes that cover unary and streaming operations.
- The repo now has a pinned official upstream target set and a repeatable runner that automatically selects the matching compat profile (`upstream_v0_3` or `upstream_java_hybrid`) for the current official `v0.3.0` server lines.
- The official Python and JavaScript upstream sample targets are now validated; the broader third-party matrix is still open.
- The official TCK is now also wired into a repeatable live local run, but the remaining compatibility deltas above still keep the broader matrix open.

## Open questions

- Which external A2A SDK or reference server should be the primary interop target?
- Should Talos publish secure-channel support in the primary Agent Card, or only in an authenticated extended card?
