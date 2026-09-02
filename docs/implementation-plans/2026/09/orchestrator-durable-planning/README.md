# Durable Planning For `implementation-orchestrator`

Status: `in_progress` (content frozen; exact candidate SHA pending)

Plan owner: root

Integration owner: delegated implementation owner

Continuity: integrated replacement on dedicated branch `feat/orchestrator-durable-planning`

Plan path: `docs/implementation-plans/2026/09/orchestrator-durable-planning/`

## Objective

Replace the mandatory host-native Plan/update_plan orchestration gate with a host-independent, human-readable Git-tracked planning bundle while preserving native Codex Goal safety, recursive routing, independent review, candidate-bound validation, delivery separation, and exactly three public skills.

The stable measurable outcome is: a fresh Codex session without `update_plan` can complete the documented orchestration gates through the durable plan plus required matching Goal; a Claude session without native Plan can proceed through the same durable-plan gate; unresolved material decisions block affected work; child agents cannot edit plan files after bootstrap; recovery, freeze, and analysis-only behavior remain explicit and verifiable.

## Scope And Acceptance

In scope: maintainer contract, orchestrator skill, lifecycle and Codex/Claude adapters, new-application intake, user documentation, first durable-plan bundle, manifests, README version pointer, and release notes. Out of scope: runtime/hooks/machine state, product code, new public skills or aliases, provider delivery, merge/release, and changes to historical release notes.

Acceptance scenarios:

1. Codex without `update_plan` proceeds after durable-plan verification and matching Goal inspection/creation; `update_goal` remains terminal-only.
2. Claude without native Plan proceeds after durable-plan verification; optional native UI mirroring cannot block.
3. An unresolved material decision blocks affected implementation until root/user resolves it.
4. After this bootstrap, children can read but not edit the plan directory, and their checkpoint reports use the documented shape.
5. Compaction/interruption recovery reconciles plan, Goal, Git, task state, reports, findings, and actual diff before resuming.
6. No plan mutation occurs after candidate freeze merely to log final CI/gate evidence; a later plan edit creates a new candidate and invalidates evidence.
7. Analysis-only requests remain read-only and establish no lifecycle state.
8. The plugin continues to expose exactly three public skills.

## Checkpoints And Evidence

Root records decisions, phase starts/completions, stable deltas, recovery, review readiness, and the pre-freeze checkpoint in [`progress.md`](progress.md). The detailed contract is in [`specification.md`](specification.md), settled design decisions in [`decisions.md`](decisions.md), and scoped implementation/evidence in [`implementation.md`](implementation.md). Native Goal state remains authoritative for its own collision and terminal lifecycle; this bundle is authoritative for durable planning.

## Current Phase

Phase 5 — exact-candidate validation and authorized Draft PR delivery: **in progress**.

Next: create one content-preserving commit from the frozen content to assign the exact candidate SHA, run the single local broad gate against that commit, perform the root retrospective, then push, create the Draft PR, and observe its exact head. Draft PR delivery is authorized separately by the user's request; merge and release are not.

## Resume from here

Exact next action: stage the exact scoped inventory in [`implementation.md`](implementation.md), including this five-file plan bundle and `docs/releases/13.0.0.md`, and create one content-preserving local commit. That commit SHA becomes the authoritative frozen-candidate identity and must be reported in terminal evidence without editing the plan. Independent review and affected-area re-review are complete with no remaining findings. After the commit, run the repository's single local broad gate. Any content change after this checkpoint invalidates the candidate and requires affected review and validation again.
