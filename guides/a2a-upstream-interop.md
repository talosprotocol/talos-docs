# A2A Upstream Interop

This guide tracks the concrete upstream validation target for Talos' standards-first A2A adapter.

## Current target

Primary target: `official-python-helloworld`

Why this target:

- It is the lowest-friction official upstream server path exposed by the current A2A project materials.
- It is easier to boot and inspect than the broader TCK path, so it is the right first live validation gate.
- It gave Talos the first clean official server path before widening to the official JavaScript SDK, the official Java server, and the TCK.

Pinned upstream metadata checked on `2026-03-14`:

- Official Python SDK repo: `a2aproject/a2a-python`
  - latest release: `v0.3.25`
  - release date: `2026-03-10`
  - stated protocol compatibility: `A2A Protocol Specification v0.3.0`
- Official JavaScript SDK repo: `a2aproject/a2a-js`
  - latest release: `v0.3.12`
  - release date: `2026-03-10`
  - stated protocol compatibility: `A2A Protocol Specification v0.3.0`
- Official Java SDK repo: `a2aproject/a2a-java`
  - latest release: `v0.3.2.Final`
  - release date: `2025-11-05`
- Official compatibility suite: `a2aproject/a2a-tck`
  - stated protocol coverage: `A2A Protocol v0.3.0`

## Important note

The official upstream repositories currently advertise `v0.3.0` protocol compatibility, while Talos' current rollout docs and gateway adapter are framed as `A2A v1`.

That means the live interop run must capture:

- the exact upstream repo and release or commit used
- the exact server/sample path used
- whether discovery, unary RPC, SSE streaming, and task subscription all work unchanged
- any payload-shape, auth, or discovery deltas that appear to come from the upstream version line

## First live findings

The first real third-party run was executed on `2026-03-14` against the pinned `official-python-helloworld` target from `a2aproject/a2a-samples`.

Observed deltas from the current Talos canonical A2A v1 assumptions:

- Agent Card shape is still `v0.3.0` style:
  - `protocolVersion: "0.3.0"`
  - `preferredTransport: "JSONRPC"`
  - root `url` points at the JSON-RPC endpoint
  - `supportsAuthenticatedExtendedCard` is advertised in-card
- The sample does **not** expose `GET /extendedAgentCard`
- The sample does **not** expose a Talos-style `/rpc` endpoint
- Authenticated extended discovery works through JSON-RPC at the root URL using `agent/getAuthenticatedExtendedCard`
- Unary send works through JSON-RPC at the root URL using `message/send`
- Streaming works through JSON-RPC at the root URL using `message/stream`

That means the current Talos standards-first A2A clients are behaving correctly for the contract they implement, but they are not wire-compatible with this upstream `v0.3.0` sample without a compatibility shim or a dedicated legacy probe layer.

## Current repo status

Talos now ships that compatibility shim as an explicit opt-in SDK profile:

- Python: `A2AJsonRpcClient(..., interop_profile="upstream_v0_3")`
- TypeScript: `new A2AJsonRpcClient(..., { interopProfile: "upstream_v0_3" })`

A second live run on `2026-03-14` used that profile through the upstream runner and passed for both the Python and TypeScript smokes against the official Python Hello World sample.

What passed:

- public discovery via `GET /.well-known/agent-card.json`
- authenticated extended discovery via root-path JSON-RPC `agent/getAuthenticatedExtendedCard`
- unary send via root-path JSON-RPC `message/send`
- streaming send via root-path JSON-RPC `message/stream`

What is still treated as optional for this upstream `v0.3.0` sample:

- `tasks/list`
- `tasks/get`
- `tasks/resubscribe`

Those remain optional in the smoke because the sample does not return task ids from `message/send` and does not guarantee the broader task-management method set.

## Official JavaScript SDK sample

A third live run on `2026-03-14` validated the pinned `official-js-sdk` target against the concrete upstream sample agent at `src/samples/agents/sample-agent`.

Observed behavior:

- The sample agent is reachable at `http://127.0.0.1:41241`
- The Agent Card still advertises `protocolVersion: "0.3.0"` and a root JSON-RPC `url`
- The Agent Card explicitly sets `supportsAuthenticatedExtendedCard: false`
- Python and TypeScript both passed:
  - public discovery
  - unary send via `message/send`
  - task retrieval via `tasks/get`
  - streaming send via `message/stream`
  - task resubscribe via `tasks/resubscribe`
- Extended discovery is intentionally skipped for this target because the sample advertises that it does not support authenticated extended cards
- `tasks/list` remains outside the validated surface for this target

That makes the official JavaScript sample the first upstream target in this repo to validate both send/get/resubscribe and streaming behavior through the Talos compatibility profile.

## Official Java Hello World server

A fourth live run on `2026-03-14` validated the pinned `official-java-helloworld-server` target against the concrete upstream sample at `examples/helloworld/server`.

Observed behavior:

- The sample needs a reactor install from the repo root before `mvn quarkus:dev` will work from a fresh clone:
  - `mvn -pl examples/helloworld/server -am -DskipTests install`
- The public Agent Card is not Talos-style `/rpc` discovery. It advertises:
  - `supportedInterfaces[0].url = "http://localhost:9999"`
  - `capabilities.extendedAgentCard = false`
- The sample does **not** expose Talos-style `/rpc`
- The sample does **not** behave like the Python/JavaScript `upstream_v0_3` targets either:
  - legacy root JSON-RPC `message/send` is rejected
  - the live route table exposes both root-path canonical JSON-RPC and REST-style endpoints such as `message:send` and `message:stream`
- Talos therefore uses a second explicit compatibility profile for this target:
  - Python: `A2AJsonRpcClient(..., interop_profile="upstream_java_hybrid")`
  - TypeScript: `new A2AJsonRpcClient(..., { interopProfile: "upstream_java_hybrid" })`

What passed through that profile:

- public discovery
- unary send via root-path canonical JSON-RPC `SendMessage`
- streaming send via root-path canonical JSON-RPC `SendStreamingMessage`

What is intentionally skipped for this target:

- extended discovery, because the card advertises `extendedAgentCard: false`
- `tasks/list`, because the official sample exposes a mixed task surface
- `get task` and `subscribe`, because the example returns message-shaped send results with agent-side `taskId` fields inside the returned message rather than a top-level task result

## Repo workflow

The repo now ships a pinned target manifest and a helper runner:

- target manifest: [a2a_upstream_targets.json](/Users/nileshchakraborty/workspace/talos/scripts/python/a2a_upstream_targets.json)
- runner: [run_a2a_upstream_interop.py](/Users/nileshchakraborty/workspace/talos/scripts/python/run_a2a_upstream_interop.py)

List known targets:

```bash
python3 scripts/python/run_a2a_upstream_interop.py --list
```

Show the current primary plan with the Talos smoke commands that should be run against a started upstream server:

```bash
python3 scripts/python/run_a2a_upstream_interop.py \
  --target official-python-helloworld \
  --gateway-url http://127.0.0.1:9999 \
  --api-token sdk-token \
  --exercise-streams
```

Run the Talos Python and TypeScript live smokes against an already-running upstream server and emit a JSON report:

```bash
python3 scripts/python/run_a2a_upstream_interop.py \
  --target official-python-helloworld \
  --gateway-url http://127.0.0.1:9999 \
  --api-token sdk-token \
  --exercise-streams \
  --run \
  --json \
  --report-file /tmp/a2a-upstream-interop-report.json
```

The report now includes:

- `results`: the canonical Talos Python and TypeScript live-smoke outcomes
- `upstream_probe`: a raw `v0.3.0` compatibility probe for upstream targets that still expose root-path JSON-RPC methods such as `message/send`

For targets marked with `talos_smoke_profile` in the manifest, the runner automatically appends the matching SDK compat flag to the Python and TypeScript smoke commands. The current official upstream targets therefore run with either `upstream_v0_3` or `upstream_java_hybrid`, depending on the server line being validated.

For targets that explicitly advertise `supportsAuthenticatedExtendedCard: false` or `capabilities.extendedAgentCard: false`, the live smoke scripts now skip extended discovery rather than treating that advertised capability boundary as an interoperability failure.

The runner now also knows how to plan or execute the official TCK path. When the selected target is `official-a2a-tck`, the plan emits a local `run_tck.py` command instead of Talos SDK smoke commands. You can also append that TCK step to any sample-target plan with `--include-tck`.

Plan the official TCK run against a local Talos gateway:

```bash
python3 scripts/python/run_a2a_upstream_interop.py \
  --target official-a2a-tck \
  --gateway-url http://127.0.0.1:8000 \
  --tck-dir /path/to/a2a-tck \
  --json
```

Execute the TCK and capture its compliance report:

```bash
python3 scripts/python/run_a2a_upstream_interop.py \
  --target official-a2a-tck \
  --gateway-url http://127.0.0.1:8000 \
  --api-token sk-test-key \
  --tck-dir /path/to/a2a-tck \
  --tck-category mandatory \
  --tck-compliance-report reports/talos-mandatory.json \
  --run \
  --json
```

For a deterministic local Talos run, start the gateway in explicit mock mode first so `SendMessage` and task creation do not depend on a live paid upstream:

```bash
TALOS_ENV=development MODE=dev DEV_MODE=true USE_JSON_STORES=true \
RATE_LIMIT_ENABLED=false A2A_MOCK_LLM_RESPONSES=true \
uvicorn app.main:app --port 8001 --host 127.0.0.1
```

The first live official TCK run against a local Talos gateway was executed on `2026-03-14`. After fixing public Agent Card visibility, passing bearer auth through the runner, and adding a `dual`-mode root JSON-RPC alias for `v0.3.0`-era tooling, the mock-backed mandatory run reached:

- `61 passed`
- `26 failed`
- `29 skipped`

The remaining failures are concentrated in three compatibility buckets:

- the TCK's `v0.3.0` `securitySchemes` wrapper expectation versus Talos' standards-first OpenAPI-style `securitySchemes`
- the TCK's localhost sensitivity check against `127.0.0.1` in the public Agent Card during local runs
- task lifecycle/list semantics where the current mock-backed Talos run completes tasks immediately, so `tasks/cancel`, `tasks/list`, and history-length assertions that expect a longer working state still fail

Append the TCK after a normal sample-target smoke plan:

```bash
python3 scripts/python/run_a2a_upstream_interop.py \
  --target official-python-helloworld \
  --gateway-url http://127.0.0.1:9999 \
  --api-token sdk-token \
  --exercise-streams \
  --include-tck \
  --tck-dir /path/to/a2a-tck
```

## Suggested validation order

1. Start the official Python Hello World sample server from `a2aproject/a2a-samples`.
2. Run the Talos Python and TypeScript live smokes through the runner above.
3. Capture any discovery or RPC deltas in the report.
4. After the Python, JavaScript, and Java samples are clean, run `official-a2a-tck` through the same runner against the Talos gateway itself.
