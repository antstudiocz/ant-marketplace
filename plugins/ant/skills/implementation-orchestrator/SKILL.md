---
user-invocable: true
name: implementation-orchestrator
description: Use for end-to-end implementation work from git/delivery setup and brainstorming through codebase analysis, planning, delegated implementation, review, verification, and optional merge request preparation. Coordinates internal scout, plan-writer, implementation lead, slice worker, and reviewer roles through references instead of exposing them as separate skills.
---

# Implementation Orchestrator

Use this skill when the user wants to turn an idea, feature, fix, refactor, audit, migration, or remediation into a completed and verified implementation.

This is the only public orchestration skill. Internal roles live in `references/` and should be loaded only when needed:

- `references/lifecycle.md` - full lifecycle, hierarchy, git/delivery setup, gates, liveness, and completion criteria.
- `references/planner-role.md` - clarification and direction-setting support.
- `references/scout-role.md` - read-only codebase analysis role.
- `references/plan-writer-role.md` - `implementation-plan.md` checklist role.
- `references/implementation-lead-role.md` - implementation sub-orchestrator role.
- `references/slice-worker-role.md` - bounded backend/frontend/data/test slice worker role.
- `references/reviewer-role.md` - plan and integrated implementation reviewer role.

## Core Model

```text
Root Orchestrator
├── Scout role(s), read-only
├── Plan Writer role
├── Plan Reviewer role, high-risk only
└── Implementation Lead role
    ├── Slice Worker role(s), optional
    └── Implementation Reviewer role
```

The root orchestrator owns the user-facing flow and does not implement app code by default. It clarifies intent, challenges weak ideas with codebase evidence, gets approval, delegates implementation, tracks progress, and verifies evidence.

The implementation lead is a child of the root orchestrator. It owns the implementation phase, may spawn slice workers when useful, integrates all output, runs checks, handles review/fix loops, and reports final evidence.

## Required Flow

1. **Git context and delivery setup** - inspect branch, dirty state, likely target branch, branch/worktree need, and merge request preference before planning implementation work.
2. **Intake and brainstorming** - ask the fewest high-impact questions needed. Do not invent user intent.
3. **Scout when needed** - use read-only codebase analysis when architecture, feasibility, debt, or contracts are unknown.
4. **Challenge and recommend** - do not blindly agree; present better options with tradeoffs when evidence supports them.
5. **Direction approval** - get user approval for the conceptual path before detailed planning.
6. **Plan artifact** - create or update `implementation-plan.md` through the plan writer role.
7. **Implementation approval** - summarize the plan conceptually and wait for approval.
8. **Implementation lead** - delegate implementation before editing app code.
9. **Slice work when useful** - backend/frontend/data/test slices may run in parallel against explicit contracts.
10. **Integration, review, verification, delivery** - implementation is done only after integrated checks, review/fix loop, evidence, and any approved merge request handoff.

## Mandatory Gates

- **Assumption gate:** classify uncertainty as blocking, repo-discoverable, or safe.
- **Git/delivery gate:** record current branch, dirty state, target branch, branch/worktree decision, and merge request preference; never create/switch branches, worktrees, or MRs without explicit approval.
- **Legacy/debt gate:** never silently copy bad architecture, legacy flow, duplicate paths, stale abstractions, or half-migrated behavior.
- **Architecture boundary gate:** verify module ownership, layer responsibility, file placement, import boundaries, shared utilities, and test placement.
- **Definition of done gate:** define observable behavior, acceptance criteria, contracts, edge cases, security/permission boundaries, non-goals, validation, and evidence.
- **Contract-first gate:** for cross-stack work, define request/response shape, errors, permissions, cache behavior, time handling, UI states, and fixtures before parallel implementation.
- **Push-first status gate:** child agents push phase checkpoints to their parent; parent polling is a recovery tool, not the default.

## Loading References

Before delegating or making a lifecycle decision:

- Read `references/lifecycle.md` for the complete protocol.
- Read only the role reference needed for the next delegation.
- Include the relevant role instructions in the subagent prompt. Do not tell subagents to use a separate public skill for scout/reviewer/etc.; those roles are internal references.

## Completion Criteria

The work is not complete until:

- user-approved direction and implementation plan exist;
- git/delivery context and branch/worktree/MR decisions are recorded or explicitly declined;
- implementation was delegated to an implementation lead;
- architecture/debt/contract decisions were handled explicitly;
- slice outputs, if any, were integrated by the implementation lead;
- targeted verification ran or is explicitly blocked;
- independent review passed or residual risks are explicit;
- actionable review findings were fixed or intentionally accepted;
- final evidence maps back to the definition of done.
