# Task-Scoped Execution

Use this reference when an approved implementation plan contains separable tasks that should be implemented, reviewed, and resumed independently. This is not a replacement for the orchestrator lifecycle. It is an implementation-phase discipline used by the implementation lead when task-level handoffs reduce context noise, review risk, or post-compact recovery cost.

## When To Use

Use task-scoped execution when:

- the approved plan has two or more implementation tasks with clear boundaries;
- a task can be implemented, verified, and reviewed independently;
- review quality matters enough to separate requirement fit from engineering quality;
- the run may survive compaction, long execution, or multiple follow-up turns;
- worker context would become noisy if each child received the full plan or chat history.

Do not use it when:

- the change is a tiny low-risk single edit where one bounded worker checkpoint is enough;
- the work is tightly coupled and one implementation lead needs one continuous reasoning thread;
- task boundaries would be artificial and add more coordination cost than evidence value.

## Task Right-Sizing

A task is the smallest useful unit that has its own implementation, verification, and review boundary. It should produce a coherent, testable result and be specific enough for one worker or the implementation lead to complete without reading the entire conversation.

Good task boundaries:

- one backend contract plus tests;
- one frontend state/view slice against an already defined contract;
- one migration/backfill step with verification;
- one cleanup/removal step after replacement behavior is verified;
- one focused review-fix pass.

Bad task boundaries:

- "update files";
- "implement frontend" when it spans unrelated screens;
- setup-only tasks that cannot be validated on their own;
- microtasks that would be faster and safer as one integrated change.

## Pre-Flight Plan Scan

Before dispatching the first task, scan the approved plan once for:

- contradictions between tasks, contracts, non-goals, and validation;
- task order that would force temporary broken behavior outside an approved compatibility window;
- plan instructions that conflict with reviewer rules, such as weak tests, duplicated logic, TODO debt, suppressed errors, or preserving avoidable legacy behavior without approval;
- missing shared contracts for parallel backend/frontend or producer/consumer work;
- tasks too broad or too small to review meaningfully.

If the scan finds a material issue, stop before implementation and return the conflict to the root orchestrator with the exact plan text, the risk, and a recommended correction. Do not let a worker discover a plan contradiction mid-task when it is visible upfront.

## File-Based Handoffs

Prefer file handoffs over long prompt dumps. Store task artifacts under the current run, for example:

```text
.ant/orchestrator/<run>/phases/06-implementation/tasks/<NN-task-name>/
  brief.md
  report.md
  review-package.diff
  review.md
```

The task brief is the worker's source of requirements. It should include:

- original goal and where this task fits;
- approved plan path and task id;
- task scope, owned files/subsystems, and forbidden areas;
- required contracts and exact interface decisions;
- non-goals and safe assumptions;
- validation expectations;
- escalation conditions;
- report file path and output contract.

The worker report is detailed evidence for the implementation lead and reviewer. It should include:

- status: `DONE`, `DONE_WITH_CONCERNS`, `BLOCKED`, or `NEEDS_CONTEXT`;
- implementation summary;
- changed paths;
- tests/checks run and results;
- root cause or contract identified when this was a fix;
- scenario evidence and residual risk;
- self-review notes and concerns;
- follow-up or integration needs.

The worker's chat response should stay short: status, changed paths, one-line checks summary, concerns, and report path.

## Review Package

For task review, provide the reviewer with a compact review package instead of making it reconstruct the branch from memory. The package should include:

- base and head commit or diff range when available;
- commit list for the task range;
- changed-file stat;
- full diff with enough context to inspect changed behavior.

When no task-specific commit exists, use a focused diff package for the task-owned paths and name the limitation. Do not pretend a path-filtered diff proves unrelated integration behavior.

## Task Review

Task review returns two separate verdicts:

```text
Spec compliance: Approved | Needs fixes | Cannot verify
Engineering quality: Approved | Needs fixes | Cannot verify
```

Spec compliance asks whether the task implemented exactly the approved task requirements, including non-goals and contracts.

Engineering quality asks whether the implementation is maintainable, tested, correctly placed, and free from avoidable debt, duplicate paths, TODOs, suppressed errors, or weak validation.

`Needs fixes` on either verdict blocks task completion unless the user explicitly accepts residual risk. Fixes must be verified and re-reviewed when they affect behavior, contracts, permissions, data, migrations, external writes, architecture boundaries, or a prior P0/P1/P2 finding.

## Progress Tracking

Track task progress in the orchestrator state, not in a separate tool-specific ledger. For each task, record enough information to resume without repeating completed work:

- task id and title;
- status;
- owner agent id;
- brief path;
- report path;
- review package path;
- review status and verdicts;
- base/head commit or diff range when available;
- checks summary;
- residual risks;
- next action.

Use `state.json.metadata.taskScopedExecution` or linked artifacts rather than adding new schema enum values. `events.jsonl` should still receive durable `artifact.created`, `artifact.updated`, `checkpoint.created`, `review.finding_opened`, `review.finding_resolved`, and `validation.*` events when task state changes.

## Debugging And Review Discipline

For bug-fix tasks, do not start with a patch. First identify the root cause, reproduce or explain the failure path, compare against working patterns when useful, form one hypothesis, and verify the fix against the original symptom.

If multiple fix attempts fail, stop and escalate. Do not keep layering patches. Repeated failed fixes are a signal that the task boundary, architecture, or root-cause understanding is wrong.

For review feedback, verify the feedback against the codebase and approved plan before changing code. External or child review is technical input, not an order. Push back with evidence when feedback conflicts with the approved scope, local architecture, or YAGNI.

Before reporting a task or run complete, require fresh evidence in the current task report or final evidence report. If verification is blocked, state the blocker and residual risk instead of implying success.
