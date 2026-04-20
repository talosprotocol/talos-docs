# Full-Scale Development Plan

This plan is derived from the current checked-out source tree, the generated
[Talos Context Graph](context_graph.md), the existing `parallel_execution_plan.md`,
and the verification commands run during this pass.

## Current Status

Completed in the current context-graph MVP lane:

- Source-derived graph generator: `scripts/python/generate_context_graph.py`
- Machine-readable graph: `docs/architecture/context_graph.json`
- Human-readable graph: `docs/architecture/context_graph.md`
- Graph verification target: `make context-graph-check`
- Graph and drift-gate tests:
  - `tests/test_context_graph_generator.py`
  - `tests/test_contract_drift_gate.py`
- Documentation entry points from `docs/README.md` and
  `docs/architecture/overview.md`

Verified passing checks:

- `python3 scripts/verify_agent_layout.py`
- `python3 scripts/python/generate_context_graph.py --check`
- `make context-graph-check`
- `pytest -q tests/test_context_graph_generator.py tests/test_contract_drift_gate.py`
- `python3 scripts/python/check_contract_drift.py`
- `pytest -q tests/test_audit_plane.py tests/test_contract_drift_gate.py`
- `PYTHONPATH=services/ucp-connector/src:contracts/python python3 -m pytest -q services/ucp-connector/tests/test_signing.py`
- `PYTHONPATH=. pytest -q tests/unit/test_kek_provider.py tests/unit/test_multi_provider.py tests/test_a2a_integration.py` from `services/ai-gateway`
- `PYTHONPATH=src:../../contracts/python pytest -q tests/test_client.py` from `sdks/python`
- `npm run test --workspace @talosprotocol/sdk` from `sdks/typescript`

## P0 Completed: Contract Drift Cleanup

The contract drift gate now ignores dependency and local virtualenv code, and
the source-level findings from this sweep have been migrated to canonical
`talos-contracts` helpers or removed where unused.

| Task | Files updated | Verification |
| --- | --- | --- |
| Cursor encoding parity | `src/api/server.py`, `talos/api/server.py`, `src/core/id.py`, `src/core/audit_plane.py` | Drift gate plus audit-plane tests |
| A2A frame base64url parity | `services/ai-gateway/app/domain/a2a/frame_store.py` | AI Gateway A2A and secrets tests |
| Secret envelope base64url parity | `services/ai-gateway/app/domain/secrets/kek_provider.py`, `services/ai-gateway/app/adapters/secrets/multi_provider.py`, `services/ai-gateway/app/adapters/postgres/secret_store.py` | AI Gateway A2A and secrets tests |
| UCP security encoding parity | `services/ucp-connector/src/talos_ucp_connector/adapters/infrastructure/security.py`, `examples/ucp-merchant/app/main.py` | UCP connector signing tests |
| SDK canonical helper parity | `sdks/python/src/talos_sdk/wallet.py`, removed unused `sdks/typescript/packages/sdk/src/core/canonical.ts` | Python SDK client tests, TypeScript SDK tests, drift gate |

Definition of done: `python3 scripts/python/check_contract_drift.py` reports
`SUCCESS: No contract drift detected.`

## P0 Pending: Runtime Regression Guardrails

These items were high-severity regressions in recent local review findings and
should stay pinned until the changed-suite is green:

| Task | Boundary | Verification |
| --- | --- | --- |
| A2A route contract compatibility | `services/ai-gateway` public A2A surface | Agent card tests, RPC auth tests, and `POST /a2a/v1/rpc` smoke |
| Audit hash canonicalization | `services/audit` event ingestion | audit integrity unit tests |
| RPC method-level RBAC | AI Gateway public auth middleware | negative/positive method-scope tests |
| Async key-store callers | AI Gateway key store and tests | key-store unit tests |
| Audit sink non-blocking behavior | AI Gateway audit emission | sink unit tests with slow downstream |
| Debug auth logging removal | AI Gateway auth/key store | log redaction assertions or source scan |

Definition of done: `bash deploy/scripts/run_all_tests.sh --ci --changed`
passes after these surfaces are touched.

## P1 Pending: Product Surface Parity

The existing `parallel_execution_plan.md` remains the broad backlog. The first
safe lanes from that plan are:

| Lane | Scope | Notes |
| --- | --- | --- |
| A2A interop validation | Gateway API and upstream targets | Serial prerequisite for many gateway tasks |
| TypeScript transport completion | `sdks/typescript` | Can run independently once contract boundary is fixed |
| UCP error taxonomy | `services/ucp-connector` | Can run independently from dashboard work |
| External audit anchoring | `services/audit` | Blocks audit explorer and hardening follow-ups |
| MCP secure tunnel | `services/mcp-connector` | Connector-owned runtime lane |
| Dashboard auth parity | `site/dashboard` | Blocks dashboard namespace and shell ownership tasks |
| Demo/examples parity | `examples`, `api-testing`, docs | Documentation and example correctness lane |
| Marketing catalog content | `site/marketing` | Independent frontend content lane |
| Docs home status metrics | `docs` | Must reflect source-derived graph and verified claims |

## Execution Order

1. Keep the context graph current with every topology change.
2. Re-run the changed-suite to prove the recent auth, A2A, audit, and dashboard
   changes are stable.
3. Start the remaining P0 runtime regression fixes one at a time, with focused
   tests for each security-sensitive surface.
4. Start the P1 lanes that have disjoint write surfaces.
5. Collapse back to one integration pass for docs, graph regeneration, and
   changed-suite verification.

## Parallelization Rules

- Contract and schema boundary changes stay serial until the boundary is fixed.
- Dashboard, marketing, SDK, connector, and docs lanes can run in parallel only
  when their write paths do not overlap.
- Runtime checks sharing one local service stack run serially unless each lane
  has isolated ports and stores.
- Every lane must end by regenerating or checking the context graph when it
  changes routes, services, SDKs, docs, or submodule topology.
