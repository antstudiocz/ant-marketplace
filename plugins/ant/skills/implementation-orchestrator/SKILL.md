---
user-invocable: true
name: implementation-orchestrator
description: Use for end-to-end implementation work from git/delivery setup and brainstorming through codebase analysis, planning, delegated implementation, review, verification, and optional merge request preparation. Coordinates internal scout, plan-writer, implementation lead, slice worker, and reviewer roles through references instead of exposing them as separate skills.
---

# Implementation Orchestrator

Use this skill when the user wants to turn an idea, feature, fix, refactor, audit, migration, or remediation into a completed and verified implementation.

For greenfield application creation or a new app-like surface inside an existing product, prefer starting from the `create-application` skill when it is available. That skill owns product intake, requester environment checks, TypeScript-only versus Docker/multi-language path comparison, existing-app reuse versus separate-stack decisions, and the approved app brief. This orchestrator then owns the execution lifecycle, including git setup, planning depth, implementation delegation, review, verification, and delivery.

This is the only public orchestration skill. Internal roles live in `references/` and should be loaded only when needed:

- `references/lifecycle.md` - full lifecycle, hierarchy, git/delivery setup, gates, liveness, and completion criteria.
- `references/planner-role.md` - clarification and direction-setting support.
- `references/scout-role.md` - read-only codebase analysis role.
- `references/phase-owner-role.md` - shared phase workspace and close-gate rules.
- `references/plan-writer-role.md` - `.ant/orchestrator/<run>/phases/05-planning/implementation-plan.md` checklist role.
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

The root orchestrator owns the user-facing flow and is coordination-only. It must not inspect application source/test/docs files for implementation facts itself and must not implement app code. It clarifies intent, uses scout reports for codebase evidence, challenges weak ideas, gets approval, delegates implementation, tracks progress, and verifies evidence.

The root orchestrator stays a coordinator after completion. Follow-up debugging, review fixes, polish, tiny edits, post-delivery issues, and "one more thing" requests start or resume orchestration and must be delegated unless the user explicitly leaves orchestration mode.

The implementation lead is a child of the root orchestrator. It owns the implementation phase, may spawn slice workers when useful, integrates all output, runs checks, handles review/fix loops, and reports final evidence.

## Required Flow

1. **Git context and delivery setup** - inspect branch, dirty state, likely target branch, branch/worktree need, and merge request preference before planning implementation work.
2. **Phase workspace setup** - for medium+ work, create a local ignored orchestration run with `index.md`, `state.md`, `decisions.md`, and per-phase folders under `phases/`.
3. **Intake and brainstorming** - ask the fewest high-impact questions needed. Do not invent user intent.
4. **Scout when needed** - delegate read-only codebase analysis to scout agents when architecture, feasibility, debt, or contracts are unknown.
5. **Post-scout clarification** - after scout findings, separate repo facts from user decisions and ask the user before turning unresolved decisions into a recommendation.
6. **Challenge and recommend** - do not blindly agree; present better options with tradeoffs when evidence supports them.
7. **Next-action approval** - every user-facing phase response says what the orchestrator wants to do next and waits when moving to planning or implementation.
8. **Rollout strategy approval** - for medium+ refactors, migrations, data-model, reporting, or cross-stack work, present one-time/phased/minimal strategy options before detailed planning.
9. **Execution mode approval** - before implementation planning for medium+ work, ask whether the user wants autonomous implementation mode or manual decision mode.
10. **Direction approval** - get user approval for the conceptual path before detailed planning.
11. **Plan phase artifact** - create or update `.ant/orchestrator/<run>/phases/05-planning/implementation-plan.md` through the plan writer role, including the full phased roadmap when phased rollout is selected.
12. **Implementation approval** - summarize the full plan, execution mode, decision policy, and current phase detail, then wait for approval.
13. **Implementation lead** - delegate implementation before editing app code.
14. **Multi-phase implementation when useful** - implementation may use `phases/06-implementation/subphases/<NN-name>/...` with roadmap, checkpoints, verification, review, and stop/continue rules.
15. **Slice work when useful** - backend/frontend/data/test slices may run in parallel against explicit contracts.
16. **Phase close and handoff** - before any user-facing transition, pause, stop, handoff, or completion report, update artifacts and close the current phase folder.
17. **Integration, review, verification, delivery** - implementation is done only after integrated checks, review/fix loop, evidence, and any approved merge request handoff.

## Mandatory Gates

- **Assumption gate:** classify uncertainty as blocking, repo-discoverable, or safe.
- **Subagent authorization gate:** follow the standing authorization in `references/lifecycle.md`; do not ask again for permission to use workflow-required subagents unless the action also needs a separate approval gate.
- **Next-action contract gate:** every user-facing response must state the proposed next action, what user reply is needed, and what `pokračuj` would authorize; never treat a vague continue as approval for unstated implementation work.
- **Root coordination-only gate:** the root orchestrator may inspect git/delivery state, orchestration references, `.ant/orchestrator/*`, and child-agent reports, but must not scout source files or implement app code directly.
- **Sticky orchestrator gate:** once this skill is active in a thread, the root remains the orchestrator for every later request in that thread, including after completion, debugging, review fixes, polish, post-delivery issues, and new follow-up tasks. A new user request starts a new orchestration cycle unless the user explicitly says they do not want orchestration and want the root to work directly.
- **No root manual work gate:** while this skill is active, every implementation change, follow-up, debugging fix, review fix, polish change, test, docs edit, formatting/config change, or one-line text edit must be delegated to a child agent. User phrases like "udělej to", "oprav to", "zapracuj připomínku", "je to jen maličkost", or "pokračuj" mean continue orchestration, not root manual edits.
- **Root mutation-tool ban:** while this skill is active, the root orchestrator must not call `apply_patch`, editor/write tools, formatting commands, migration commands, code generators, or shell commands that modify app/source/test/docs/config files. The only root-owned writes are orchestration run/phase artifacts under `.ant/orchestrator/*`, plus explicitly approved branch/worktree/MR actions. Any other mutation must be delegated to a child implementation lead or worker.
- **Delegation-on-implementation gate:** if the user says "rovnou udělej změny", "implementuj", "oprav to", "pokračuj", or otherwise approves implementation while orchestration is active, the root's next action is to delegate an implementation lead with an owned write scope. It is never permission for the root to inspect implementation files or edit them directly.
- **Hard no-edit gate:** for `Medium`, `High`, and `Critical` work, phrases like "rovnou implementuj", "pojďme to udělat", "tohle bych implementoval", or "všechno zní dobře" authorize planning, not editing, unless they explicitly approve a concrete implementation plan that already exists.
- **Pre-edit checklist gate:** before any child agent writes implementation files, it must have an approved plan path or explicit skip decision, exact user implementation approval, assigned write scope, validation expectation, and parent delegation message. For the root orchestrator, this checklist always fails for app/source/test/docs edits while orchestration is active.
- **Phase artifact source-of-truth gate:** phase artifacts are the durable source of truth; chat is only the UI. Before any user-facing phase transition, pause, stop, handoff, or completion report, update the relevant phase artifacts.
- **Phase close / handoff gate:** no phase is complete until its folder records status, inputs, work done, decisions, evidence, open questions, next phase handoff, files to read first, and must-not-assume notes.
- **Context persistence gate:** for medium+ work, keep concise local ignored run and phase files for decisions, findings, current phase, and handoff; never store secrets, raw logs, or noisy transcripts.
- **Post-compact recovery gate:** after compaction, resume, or suspected context loss, rebuild orchestration state from `.ant/orchestrator/*`, git state, and child-agent reports before answering, delegating, editing, or reporting completion. Compaction does not cancel child agents.
- **Orchestration artifact location gate:** all markdown artifacts created by this orchestration flow belong under `.ant/orchestrator/`; never create root-level `implementation-plan.md` or ad hoc planning markdown unless the user explicitly asks for a tracked repository document.
- **Post-scout clarification gate:** codebase facts cannot silently become product decisions; after scouting, ask the user about unresolved behavior, scope, rollout, data, validation, or architecture choices before issuing a final direction.
- **Rollout strategy gate:** for broad or risky work, ask whether to proceed as one-time refactor, phased rollout, or compatibility-first minimal change before writing the final plan.
- **Execution mode gate:** for medium+ work, record whether implementation will run in autonomous implementation mode or manual decision mode before detailed plan writing. Autonomous mode lets agents choose among technical variants using code evidence and the approved decision policy; manual mode requires user choice when valid variants remain.
- **Phased roadmap gate:** when phased rollout is selected, the plan must cover the whole roadmap before phase 1 starts. Later phases may be less detailed, but each phase needs goals, dependencies, acceptance criteria, compatibility/rollback expectations, validation expectations, and stop/continue rules.
- **Multi-phase implementation gate:** implementation may be split under `phases/06-implementation/subphases/<NN-name>/...`; each subphase must have a roadmap checkpoint, verification evidence, review status when applicable, and explicit stop/continue rule before the next subphase starts.
- **Git/delivery gate:** record current branch, dirty state, target branch, branch/worktree decision, unrelated-change decision, and merge request preference; never create/switch branches, worktrees, push, or create MRs without explicit approval.
- **Target branch intake gate:** recommend a target branch when possible, but store the user-confirmed target before planning or delivery; delivery must stop if no confirmed target exists.
- **Unrelated changes gate:** explicitly list dirty files outside scope and ask whether to include, exclude, or leave them aside; broad phrases like "push everything" do not bypass this warning.
- **Legacy/debt gate:** never silently copy bad architecture, legacy flow, duplicate paths, stale abstractions, or half-migrated behavior.
- **Architecture boundary gate:** verify module ownership, layer responsibility, file placement, import boundaries, shared utilities, and test placement.
- **Model routing gate:** the root model is selected by the user/session. When spawning child agents, route by role and risk: `gpt-5.5` / Claude Opus tier for implementation leads, decisions, architecture, review, and high-risk work; `gpt-5.4-mini` / Claude Sonnet tier for bounded small-medium work; `gpt-5.3-codex-spark` / Claude Haiku tier for tiny mechanical tasks. Do not use `gpt-5.4` or `gpt-5.3-codex` for new child-agent routing.
- **Scenario-based definition of done gate:** convert broad goals into concrete acceptance and risk scenarios with validation or explicit residual risk.
- **Contract-first gate:** for cross-stack work, define request/response shape, errors, permissions, cache behavior, time handling, UI states, and fixtures before parallel implementation.
- **Evidence gate:** child-agent reports are claims until backed by tests, independent review, runtime checks, or explicitly accepted residual risk.
- **Review/fix loop gate:** P0/P1/P2 findings block completion until fixed, verified, and re-reviewed or explicitly accepted by the user.
- **Push-first status gate:** child agents push phase checkpoints to their parent; parent polling is a recovery tool, not the default.
- **Mid-flight user input gate:** if the user sends new instructions, questions, corrections, or scope notes while child agents are active, preserve the current run by default, classify the input, answer from known state when possible, update run/phase artifacts, and forward material changes to the relevant child at a safe checkpoint or with an interrupt only when continuing would waste work or violate the user's latest direction.
- **Writer recovery gate:** do not start an overlapping replacement writer until the silent writer is checkpointed or closed, partial work is understood, and the write scope is safe.
- **MR readiness gate:** before push or MR creation, confirm target branch, unrelated-change decision, conscious dirty state, latest relevant checks, review/fix status, and draft/ready intent.

## Loading References

Before delegating or making a lifecycle decision:

- Read `references/lifecycle.md` for the complete protocol.
- Read only the role reference needed for the next delegation.
- Include the relevant role instructions in the subagent prompt. Do not tell subagents to use a separate public skill for planner/scout/reviewer/etc.; those roles are internal references, not invocable skills.
- Never prompt a child with fake skill names such as `ant-implementation-orchestrator:planner`, `ant-implementation-orchestrator:scout`, or `ant-implementation-orchestrator:reviewer`. If the host cannot load references for a child, paste the needed role instructions or a concise role brief into the child prompt.

## Completion Criteria

The work is not complete until:

- user-approved direction and implementation plan exist under `.ant/orchestrator/<run>/phases/05-planning/`, unless the user explicitly requested a tracked repo document;
- run-level `index.md`, `state.md`, and `decisions.md` are current for medium+ work, or persistence was explicitly skipped as unnecessary;
- each completed phase folder has `phase.md`, `decisions.md`, `handoff.md`, and the phase-specific evidence files needed to resume elsewhere;
- execution mode and decision policy are recorded for medium+ work;
- phased rollout work has an approved whole-roadmap plan before any phase implementation starts;
- git/delivery context and branch/worktree/MR decisions are recorded or explicitly declined;
- target branch and unrelated-change decisions are recorded before push/MR delivery;
- implementation was delegated to an implementation lead;
- every implementation or follow-up change was delegated to a child agent unless the user explicitly said they do not want orchestration and want root-direct work;
- no root mutation tool was used for app/source/test/docs/config edits while orchestration was active;
- architecture/debt/contract decisions were handled explicitly;
- slice outputs, if any, were integrated by the implementation lead;
- targeted verification ran or is explicitly blocked;
- independent review passed or residual risks are explicit;
- actionable review findings were fixed or intentionally accepted;
- final evidence maps back to the definition of done.
