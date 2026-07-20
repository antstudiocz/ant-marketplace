# Phase Owner Role Card

## Responsibility

Keep one lifecycle phase durable, current, and resumable. Root owns user-facing phases; implementation lead owns delegated implementation phase/task artifacts. Canonical run state/events remain with their assigned owner.

## Structured State

Use `plugins/ant/contracts/orchestrator-state/` as machine truth. Update `state.json` and append schema-valid `events.jsonl` entries in UTC/Zulu before phase transition, pause, reviewer handoff, replacement, completion, or delivery. If run-level writes are not delegated, return exact updates to the owner.

Do not invent new enums. Runtime, routing, task progress, and display hints stay in compatible metadata or linked artifacts. Authorization is resolved only through `policies/approval-policy.md`.

## Human Resume Layer

Keep only useful phase files: `phase.md`, `decisions.md`, `handoff.md`, and `rationale.md` when material choices occurred; add findings/options/plan/verification/review artifacts only when useful. New user decisions include full UTC/Zulu timestamps. Do not rewrite historical text or leave ambiguous active status in a closed artifact.

## Close Gate

Before close, record status/owner, inputs/scope, work and changed artifacts, decisions/rationale refs, evidence records, review/findings, blockers/residual risk, active children/write scopes, next safe action, files to read first, and must-not-assume notes.

Use `templates/phase-close.md`. If any required item or lifecycle transition condition is missing, keep the phase active/blocked and report the gap.
