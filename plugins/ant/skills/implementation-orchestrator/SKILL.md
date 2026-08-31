---
name: implementation-orchestrator
description: Use for end-to-end features, fixes, refactors, migrations, and new applications that should finish as a reviewed and verified implementation.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

## Authority And Roles

- Root is the sole user-facing adjudicator and directly verifies final validation; the integration owner writes and consolidates, and the independent reviewer never writes fixes.
- Children report to their parent and do not address the user. Use the ownership and escalation rules in [lifecycle.md](references/lifecycle.md).
- Classify intake as **analysis-only**, **implementation-authorized**, or **ambiguous**. Keep delivery authority separate from implementation authority.
- Apply required child routing as defined by the active adapter. Preserve native approval semantics and fail closed when required selectors or state cannot be enforced.

## Compact Flow

1. Read repository instructions and inspect git state, contracts, risks, and checks without edits. Protect unrelated work.
2. End analysis-only requests with read-only evidence; do not enter the implementation lifecycle.
3. For new or materially changed behavior, resolve users, workflows, acceptance, edge cases, non-goals, and continuity. For a new application, load [new-application.md](references/new-application.md).
4. Load [lifecycle.md](references/lifecycle.md). If interactive smoke is requested or required, load one active-host adapter early enough for its preflight; otherwise load the adapter before the first host-specific decision.
5. Present the proportional native Plan, then pass the host-native Plan/Goal gates before tracked-writer dispatch. Follow the active adapter ([codex.md](references/codex.md) or [claude.md](references/claude.md)) for host-specific proof and fail-closed behavior.
6. Enforce every child route, effort, availability, fresh context, isolation, and Codex `fork_turns="none"` requirement. Dispatch one integration owner with a complete recursive capsule; add disjoint workers only when ownership is stable.
7. Run targeted checks after coherent phases. After final mutation, obtain independent review, freeze one candidate, and verify the single broad gate required by [lifecycle.md](references/lifecycle.md). Refresh candidate-bound evidence after later mutations.
8. Perform the root-owned retrospective and only separately authorized delivery.

## Plan, Goal, And Change Control

The host-native Plan and Goal gates, collision rules, change control, recovery, and recursive routing capsule are defined in [lifecycle.md](references/lifecycle.md). Codex proof and native operations are defined in [codex.md](references/codex.md); Claude proof and routing are defined in [claude.md](references/claude.md). Do not treat prose status or a child report as lifecycle evidence.

## Candidate-Bound Validation

Use the single candidate-bound broad gate and failure handling defined in [lifecycle.md](references/lifecycle.md). The root verifies the gate directly.

## Decisions And Recovery

Follow the decision, failure, and recovery rules in [lifecycle.md](references/lifecycle.md) and the active adapter. Preserve native approval semantics; unavailable or unverifiable required state fails closed.

## Completion

Analysis-only completion is read-only evidence/findings with no readiness verdict. Implementation completion requires scoped implementation, independent review, final validation, retrospective, and any authorized delivery. Report implementation and delivery separately and give exactly one verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**. Never claim implementation success from a child report alone.
