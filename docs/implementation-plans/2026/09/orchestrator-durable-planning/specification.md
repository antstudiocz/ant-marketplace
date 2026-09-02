# Specification

## Durable plan contract

- Default stable location: `docs/implementation-plans/YYYY/MM/<slug>/README.md`.
- README is the sole stable entrypoint. Substantial work may include `specification.md`, `decisions.md`, `implementation.md`, and `progress.md`; small work may collapse proportionally without removing README.
- The bundle must state objective, users/workflows where relevant, acceptance, scope and non-goals, continuity, material decisions/open questions, ownership, risks, checks, current phase, and candidate/freeze rules.
- Root owns all plan/progress/checkpoint writes. Children read plan docs and return evidence/proposed deltas only. The current redesign's first bundle is a bootstrap exception under the old contract; no compatibility shim follows.

## Lifecycle gate

Discovery comes first. Root asks every material non-repo-discoverable question, presents a concise chat plan, then records the detailed durable plan before dispatch. An unresolved material decision blocks affected work. Plan updates happen at decision resolution, phase start/completion, stable in-objective delta, recovery, review readiness, and immediately before freeze.

Native host Plan/update_plan has zero mandatory dependency. If a host mirrors the durable plan in native UI, that view is optional and non-authoritative. Codex still requires a matching native Goal after plan verification; Claude Goal is optional.

## Goal contract

Codex Goal objective must be stable, measurable, and reference this plan README. Current Codex tools expose Goal create/read and terminal `complete`/`blocked` closure, not step mutation. `update_goal` cannot represent progress, clear a collision, or replace plan updates. Unrelated unfinished Goals remain untouched; material objective/public-contract drift pauses work for root/user resolution.

## Authority and capsule

Root is user-facing adjudicator and owns decisions, Goal lifecycle, phase status, recovery, freeze, final gate verification, retrospective, and readiness. Root may write only planning docs as a tracked coordination exception. The integration owner owns source/config/test/general-document edits and consolidation. Independent strong review is separate and never writes fixes.

Every recursive child capsule states exact route/effort, fresh isolation, outcome/acceptance/non-goals, exact write ownership, checks, explicit nested delegation and routes/ceiling, report/escalation topology, and plan directory root-write/child-read-only boundary. Child checkpoint reports contain phase/status, files/areas, validation, discoveries/decisions, proposed plan delta, and risks/blockers.

## Freeze and evidence

Before freeze, root writes the final plan checkpoint and identifies the exact tree/SHA. No tracked plan edit is made after freeze merely to log final CI or gate results. Any later plan/source/config edit creates a new candidate and invalidates affected review, broad-gate, and smoke evidence. One risk-appropriate broad gate is required; separately authorized delivery remains owned by `merge-request`.
