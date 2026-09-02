---
name: implementation-orchestrator
description: Use for end-to-end features, fixes, refactors, migrations, and new applications that should finish as a reviewed and verified implementation.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

## Authority And Roles

- Root is the sole user-facing adjudicator. Root writes the durable planning bundle, owns decisions, Goal lifecycle, phase status, recovery, freeze, final gate verification, retrospective, and readiness; root does not write source, tests, configuration, or general documentation.
- The integration owner writes and consolidates the implementation. Children read the plan directory and return evidence/proposed deltas; they never edit plan files. The independent strong reviewer never writes fixes.
- Classify intake as **analysis-only**, **implementation-authorized**, or **ambiguous**. Keep delivery authority separate from implementation authority.
- Apply required child routing from the active adapter. Preserve native approval semantics and fail closed when required selectors or state cannot be enforced.

## Compact Flow

1. Read repository instructions and inspect git state, contracts, risks, and checks without edits; protect unrelated work.
2. For new or materially changed behavior, discover facts first and ask root/user every material non-repo-discoverable question in digestible rounds until all material decisions are resolved. Record repository findings, analysis, decisions, and rationale before tracked implementation.
3. Establish the stable durable plan bundle at `docs/implementation-plans/YYYY/MM/<slug>/README.md`, with supporting documents proportionate to the work. Present a concise chat plan, then record the detailed checkpoint.
4. Load [lifecycle.md](references/lifecycle.md) and the active host adapter. Codex must pass its required native Goal gate; Claude Goal is optional. Host-provided planning UI is never a dependency.
5. Enforce every child route, effort, availability, fresh context, isolation, and Codex `fork_turns="none"` requirement. Dispatch one integration owner with a complete recursive capsule; add disjoint workers only when ownership is stable.
6. Root updates the durable plan at decision resolution, phase transitions, stable deltas, recovery, review readiness, and immediately before candidate freeze. Children report only through their parent.
7. After independent review and final mutation, freeze one candidate and verify the single broad gate required by [lifecycle.md](references/lifecycle.md). Any later plan edit creates a new candidate and invalidates candidate-bound evidence.
8. Perform the root-owned retrospective and only separately authorized delivery.

## Durable Plan, Goal, And Change Control

The durable-plan contract, Goal collision rules, change control, recovery, recursive routing capsule, and candidate-bound validation are defined in [lifecycle.md](references/lifecycle.md). Codex operations are in [codex.md](references/codex.md); Claude behavior is in [claude.md](references/claude.md). Host-provided planning UI mirroring, if used, is optional and non-authoritative; omission is preferred. Do not treat prose status or a child report as lifecycle evidence.

## Completion

Analysis-only completion is read-only evidence/findings with no readiness verdict. Implementation completion requires scoped implementation, independent review, final validation, retrospective, and any authorized delivery. Report implementation and delivery separately and give exactly one verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**. Never claim implementation success from a child report alone.
