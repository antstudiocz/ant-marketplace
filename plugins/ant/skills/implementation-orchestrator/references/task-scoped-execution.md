# Task-Scoped Execution

This file is the normative owner for task-level implementation, handoff, and review discipline inside an approved implementation phase.

## Use When

Use tasks when two or more units have coherent, independently reviewable implementation, validation, and ownership boundaries, or when file handoffs materially improve long-run recovery. Do not use tasks for artificial micro-edits or tightly coupled work that needs one reasoning thread.

Before dispatch, scan the complete approved plan for contradictory tasks/contracts, unsafe order, unapproved temporary breakage, overlap, missing shared contracts, weak-test instructions, duplicate behavior, TODO debt, or avoidable legacy preservation. Stop and escalate material conflicts.

## Artifacts

```text
.ant/orchestrator/<run>/phases/06-implementation/tasks/<NN-name>/
  brief.md
  report.md
  review-package.diff   # optional focused evidence
  review.md
```

The brief is the worker's requirement source and contains goal, plan/task id, approved decisions, owned/forbidden paths, contracts, non-goals, validation/evidence, escalation, and report path. Create the packet from `templates/task-packet.md`; never pass raw chat history.

The report records `DONE`, `DONE_WITH_CONCERNS`, `BLOCKED`, or `NEEDS_CONTEXT`, changed paths, root cause/contract, implementation, checks/evidence, self-review, residual risk, and integration needs. Chat response stays short.

## Review

Provide the manifest from `policies/review-manifest.md` and a task-specific base/head range or focused path diff. Name when a focused diff cannot prove wider integration.

Task review returns both `Spec compliance` and `Engineering quality`. Either `Needs fixes` blocks task completion. Behavior/contract/data/permission/architecture or P0/P1/P2 fixes require targeted validation and re-review unless risk is accepted through the approval policy.

## Tracking

Record task id/title, status, owner, artifact paths, diff range, verdicts, checks, residual risks, and next action in `state.json.metadata.taskScopedExecution` or linked artifacts. Append existing schema-valid artifact/checkpoint/validation/finding events for durable changes. Do not add contract enums.

One task has one writer. A replacement starts only after prior ownership is safely closed and partial work is understood.
