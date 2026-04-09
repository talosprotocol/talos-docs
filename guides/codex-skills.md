# Talos Codex Skills Guide

This guide shows when to invoke the Talos-specific Codex skills in this
repository and gives a short example prompt for each one.

## Workflow Skills

### `$talos-contract-first`

Use for schema, API, vector, or boundary-sensitive changes.

Example prompt:

```text
Use $talos-contract-first to add a new field to the capability schema and update every affected consumer safely.
```

### `$talos-capability-audit`

Use for capability issuance, authz enforcement, revocation, session validation,
or audit logging changes.

Example prompt:

```text
Use $talos-capability-audit to review and harden this gateway capability validation change, including negative tests.
```

### `$talos-local-stack`

Use when you need the smallest correct Talos build, test, or runtime command.

Example prompt:

```text
Use $talos-local-stack to pick the right validation commands for a change limited to services/ai-gateway and tests/.
```

### `$talos-parallelize`

Use when the task should be split into safe parallel lanes before any code
changes begin.

Example prompt:

```text
Use $talos-parallelize to break this multi-SDK A2A rollout into safe parallel lanes, assign the right Talos skills to each lane, and keep any shared contract work serialized.
```

Helper:

```bash
python3 .agents/skills/talos-parallelize/scripts/parallelize_task.py \
  .agents/skills/talos-parallelize/assets/task-template.json \
  --format markdown
```

Monitoring helper:

```bash
python3 .agents/skills/talos-parallelize/scripts/monitor_parallel_plan.py \
  plan.json \
  .agents/skills/talos-parallelize/assets/status-template.json \
  --format markdown
```

Persistent run helper:

```bash
python3 .agents/skills/talos-parallelize/scripts/orchestrate_parallel_run.py \
  init \
  task.json \
  .agent/parallel-runs/my-task
```

Lane handoff helper:

```bash
python3 .agents/skills/talos-parallelize/scripts/orchestrate_parallel_run.py \
  handoffs \
  .agent/parallel-runs/my-task \
  --format markdown
```

Artifact schemas:

- `.agents/skills/talos-parallelize/assets/schemas/task-manifest.schema.json`
- `.agents/skills/talos-parallelize/assets/schemas/parallel-plan.schema.json`
- `.agents/skills/talos-parallelize/assets/schemas/parallel-status.schema.json`
- `.agents/skills/talos-parallelize/assets/schemas/parallel-decision.schema.json`
- `.agents/skills/talos-parallelize/assets/schemas/parallel-handoffs.schema.json`

### `$talos-sdk-parity`

Use when a contract or protocol change must propagate across SDKs.

Example prompt:

```text
Use $talos-sdk-parity to carry this A2A frame change through the Python and TypeScript SDKs and tell me what other SDKs need follow-up.
```

### `$talos-docs-parity`

Use when implementation changes require docs, examples, or product claims to
stay truthful.

Example prompt:

```text
Use $talos-docs-parity to update the docs and examples for the new audit stream behavior without overstating what is shipped.
```

### `$talos-governance-agent`

Use for TGA, supervisor approval, minted capabilities, or audited tool-call
flows.

Example prompt:

```text
Use $talos-governance-agent to implement a supervisor-gated write flow for the governance agent and preserve the audit chain.
```

### `$talos-drift-sweep`

Use to find stale generated content, duplicated protocol logic, or cross-repo
boundary drift.

Example prompt:

```text
Use $talos-drift-sweep to check whether cursor logic or test-runner docs have drifted across submodules.
```

## Specialist Agent Skills

These are explicit-only and work best when you want Codex to stay in a specific
Talos specialist mode.

### `$talos-backend-architect-agent`

```text
Use $talos-backend-architect-agent to design and implement this gateway API change with clear invariants and failure modes.
```

### `$talos-api-tester-agent`

```text
Use $talos-api-tester-agent to add contract and negative-path tests for this MCP proxy endpoint.
```

### `$talos-infra-maintainer-agent`

```text
Use $talos-infra-maintainer-agent to update this Helm deployment safely and include rollback steps.
```

### `$talos-frontend-developer-agent`

```text
Use $talos-frontend-developer-agent to implement this dashboard change while keeping browser calls behind /api/*.
```

### `$talos-ai-engineer-agent`

```text
Use $talos-ai-engineer-agent to add schema-validated tool outputs and eval coverage for this model-driven gateway feature.
```

### `$talos-parallel-orchestrator-agent`

```text
Use $talos-parallel-orchestrator-agent to run a parallelization pass on this repo-wide task, start the safe lanes, monitor blockers, and merge the results with one final verification pass.
```

## Notes

- Prefer the workflow skills when the task type is obvious and you want the
  skill to augment normal Codex behavior.
- Use `$talos-parallelize` first when the task is big enough that concurrency
  itself needs planning, not just execution.
- Prefer the specialist agent skills when you want a narrower role with stronger
  guardrails for that domain.
- Repo-local skills live in `.agents/skills/`. Global mirroring is handled by
  `python3 scripts/sync_codex_skills.py`.
