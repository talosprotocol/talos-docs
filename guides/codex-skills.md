# Talos Codex Skills Guide

This guide shows when to invoke the Talos-specific Codex skills in this
repository and gives a short example prompt for each one.

## Workflow Skills

### `$talos-ops-sweep`

Use when a Talos task starts with “analyse”, “find blockers”, or “classify the
real surface” across CI/build, UI parity, and dirty submodules.

Example prompt:

```text
Use $talos-ops-sweep to classify this Talos change across dirty submodules, reduce any CI failure to the first actionable signal, inventory UI parity where relevant, and route the next fix to the right owner.
```

Helper:

```bash
python3 .agent/skills/talos-ops-sweep/scripts/run_ops_sweep.py \
  --repo-path . \
  --submodules \
  --format markdown
```

### `$talos-ci-triage`

Use for GitHub Actions, local CI repros, or pasted build logs when you need
the first actionable failure and the smallest local repro.

Example prompt:

```text
Use $talos-ci-triage to collapse this failing Actions log to the first real error, map it to the owning Talos surface, and tell me the smallest repro command.
```

Helper:

```bash
python3 .agent/skills/talos-ci-triage/scripts/triage_ci_failure.py \
  path/to/ci.log \
  --format markdown
```

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
python3 .agent/skills/talos-parallelize/scripts/parallelize_task.py \
  .agent/skills/talos-parallelize/assets/task-template.json \
  --format markdown
```

Monitoring helper:

```bash
python3 .agent/skills/talos-parallelize/scripts/monitor_parallel_plan.py \
  plan.json \
  .agent/skills/talos-parallelize/assets/status-template.json \
  --format markdown
```

Persistent run helper:

```bash
python3 .agent/skills/talos-parallelize/scripts/orchestrate_parallel_run.py \
  init \
  task.json \
  .agent/parallel-runs/my-task
```

Lane handoff helper:

```bash
python3 .agent/skills/talos-parallelize/scripts/orchestrate_parallel_run.py \
  handoffs \
  .agent/parallel-runs/my-task \
  --format markdown
```

Artifact schemas:

- `.agent/skills/talos-parallelize/assets/schemas/task-manifest.schema.json`
- `.agent/skills/talos-parallelize/assets/schemas/parallel-plan.schema.json`
- `.agent/skills/talos-parallelize/assets/schemas/parallel-status.schema.json`
- `.agent/skills/talos-parallelize/assets/schemas/parallel-decision.schema.json`
- `.agent/skills/talos-parallelize/assets/schemas/parallel-handoffs.schema.json`

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

### `$talos-ui-surface-parity`

Use when dashboard shell pages, the dashboard API Workbench, and the Talos TUI
need a parity pass before fixes or backlog planning.

Example prompt:

```text
Use $talos-ui-surface-parity to compare secrets management across the dashboard shell, API Workbench, and TUI and tell me which owner paths are missing.
```

Helper:

```bash
python3 .agent/skills/talos-ui-surface-parity/scripts/build_surface_inventory.py \
  --format markdown
```

### `$talos-submodule-hygiene`

Use when root `git status` is noisy, dirty submodules hide the real work
surface, or generated artifacts need cleanup or ignore-rule decisions.

Example prompt:

```text
Use $talos-submodule-hygiene to classify the dirty Talos worktree, separate intentional edits from generated clutter, and propose the safest cleanup plan.
```

Helper:

```bash
python3 .agent/skills/talos-submodule-hygiene/scripts/classify_dirty_worktree.py \
  --repo-path . \
  --submodules \
  --format markdown
```

## Specialist Agent Skills

These work best when you want Codex to stay in a specific Talos specialist
mode, or when a task clearly matches a narrow specialist domain.

### `$talos-backend-architect-agent`

```text
Use $talos-backend-architect-agent to design and implement this gateway API change with clear invariants and failure modes.
```

### `$talos-api-tester-agent`

```text
Use $talos-api-tester-agent to add contract and negative-path tests for this MCP proxy endpoint.
```

### `$talos-ops-sweeper-agent`

```text
Use $talos-ops-sweeper-agent to run the combined Talos analysis sweep, merge the findings, and route the next work to the correct workflow skill or specialist agent.
```

### `$talos-ci-failure-manager-agent`

```text
Use $talos-ci-failure-manager-agent to triage this failing Talos CI job, isolate the first actionable signal, and choose the smallest safe local repro.
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

### `$talos-ui-parity-builder-agent`

```text
Use $talos-ui-parity-builder-agent to build a parity matrix across the dashboard shell, API Workbench, and TUI for this operator workflow.
```

### `$talos-artifact-janitor-agent`

```text
Use $talos-artifact-janitor-agent to classify the dirty submodules, identify generated noise, and recommend the narrowest cleanup and ignore actions.
```

### `$talos-parallel-orchestrator-agent`

```text
Use $talos-parallel-orchestrator-agent to run a parallelization pass on this repo-wide task, start the safe lanes, monitor blockers, and merge the results with one final verification pass.
```

### `$talos-deduplication-agent`

```text
Use $talos-deduplication-agent to scan this service and SDK scope for repeated logic, then consolidate only the duplicates that reduce drift without obscuring intent.
```

### `$talos-type-consolidation-agent`

```text
Use $talos-type-consolidation-agent to find duplicated type definitions for this protocol shape and migrate consumers to the correct source of truth.
```

### `$talos-dead-code-removal-agent`

```text
Use $talos-dead-code-removal-agent to identify unused exports and orphaned files in this package, manually verify dynamic references, and remove only confirmed-dead code.
```

### `$talos-circular-dependencies-agent`

```text
Use $talos-circular-dependencies-agent to map dependency cycles in this package and break the cycles that affect startup, tests, or ownership.
```

### `$talos-type-strengthening-agent`

```text
Use $talos-type-strengthening-agent to replace weak any or placeholder unknown types in this SDK code with researched strong types while preserving true boundary unknowns.
```

### `$talos-error-handling-cleanup-agent`

```text
Use $talos-error-handling-cleanup-agent to find swallowed errors and masking fallbacks in this service, then preserve only real recovery, cleanup, logging, audit, or user-facing reporting.
```

### `$talos-deprecated-code-cleanup-agent`

```text
Use $talos-deprecated-code-cleanup-agent to remove obsolete fallback paths, stubs, placeholder logic, and low-value generated-edit comments after checking active compatibility.
```

## Notes

- Prefer the workflow skills when the task type is obvious and you want the
  skill to augment normal Codex behavior.
- Use `$talos-parallelize` first when the task is big enough that concurrency
  itself needs planning, not just execution.
- Prefer the specialist agent skills when you want a narrower role with stronger
  guardrails for that domain.
- Repo-local skills live in `.agent/skills/`. Global mirroring is handled by
  `python3 scripts/sync_codex_skills.py`.
