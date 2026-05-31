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

## Risk-Tier Dispatch Model

The root orchestrator never does implementation work. Speed comes from choosing the smallest sufficient delegated workflow, not from letting the root inspect source files or edit code.

Every user request and every follow-up is a new orchestration cycle inside the active run unless it is clearly unrelated and should start a new run. Each cycle gets a fresh risk classification. The cycle inherits orchestration context, artifacts, constraints, and delivery state, but it does not inherit the previous cycle's risk tier automatically.

Use this dispatch matrix before selecting gates and roles:

```text
Low      -> one bounded implementation worker; no plan writer or reviewer by default.
Medium   -> one implementation lead; scout/reviewer only when direction, contract, behavior, or evidence risk requires it.
High     -> scout + plan writer + implementation lead + reviewer, with slice workers only when boundaries are clear.
Critical -> full lifecycle with explicit decisions, plan review when useful, strong validation, review/fix/re-review discipline.
```

For structured runs, record the active cycle in `state.json.metadata` without adding new enum values:

```json
{
  "originalRiskTier": "critical",
  "activeRiskTier": "low",
  "flowMode": "single-delegated-worker",
  "cycle": "follow-up-003",
  "followUpOf": "initial-implementation",
  "rootMode": "dispatch-only"
}
```

UIs should treat these metadata fields as display hints. Existing `status`, `phase`, `agent`, and `event` enums remain canonical.

## Required Flow

1. **Git context and delivery setup** - inspect branch, dirty state, likely target branch, branch/worktree need, and merge request preference before planning implementation work.
2. **Risk classification and cycle setup** - classify the current request or follow-up as `Low`, `Medium`, `High`, or `Critical`; record `activeRiskTier`, `flowMode`, `cycle`, and `rootMode: dispatch-only` in structured metadata when persistence is active.
3. **Phase workspace setup** - for medium+ work, create or reopen a local ignored orchestration run with concise state, decisions, handoff, and only the phase folders needed for the selected tier.
4. **Intake and brainstorming** - ask the fewest high-impact questions needed. Do not invent user intent.
5. **Scout when needed** - delegate read-only codebase analysis to scout agents when architecture, feasibility, debt, contracts, or direction are unknown.
6. **Post-scout clarification** - after scout findings, separate repo facts from user decisions and ask the user before turning unresolved decisions into a recommendation.
7. **Challenge and recommend** - do not blindly agree; present better options with tradeoffs when evidence supports them.
8. **Next-action approval** - every user-facing phase response says what the orchestrator wants to do next and waits when moving to planning or implementation.
9. **Rollout strategy approval** - for medium+ refactors, migrations, data-model, reporting, or cross-stack work, present one-time/phased/minimal strategy options before detailed planning.
10. **Execution mode approval** - before implementation planning for medium+ work, ask whether the user wants autonomous implementation mode or manual decision mode.
11. **Direction approval** - get user approval for the conceptual path before detailed planning when the selected tier requires it.
12. **Plan phase artifact** - create or update `.ant/orchestrator/<run>/phases/05-planning/implementation-plan.md` through the plan writer role for medium+ work when a concrete plan adds value or is required by risk.
13. **Implementation approval** - summarize the plan or low-risk dispatch packet, execution mode when applicable, decision policy, and current phase detail, then wait for approval when the gate requires it.
14. **Delegated implementation** - delegate implementation before editing app code. `Low` uses one bounded implementation worker; higher tiers use an implementation lead.
15. **Multi-phase implementation when useful** - implementation may use `phases/06-implementation/subphases/<NN-name>/...` with roadmap, checkpoints, verification, review, and stop/continue rules.
16. **Slice work when useful** - backend/frontend/data/test slices may run in parallel against explicit contracts.
17. **Phase close and handoff** - before any user-facing transition, pause, stop, handoff, or completion report, update structured state and concise human artifacts.
18. **Integration, review, verification, delivery** - implementation is done only after tier-appropriate checks, review/fix loop when required, evidence, and any approved merge request handoff.

## Mandatory Gates

- **Assumption gate:** classify uncertainty as blocking, repo-discoverable, or safe.
- **Risk-tier gate:** every initial request, review fix, missed requirement, bug report, polish task, and post-completion follow-up must receive a fresh `Low` / `Medium` / `High` / `Critical` classification before dispatch. Follow-ups inherit context and constraints, not the previous risk tier.
- **Subagent authorization gate:** follow the standing authorization in `references/lifecycle.md`; do not ask again for permission to use workflow-required subagents unless the action also needs a separate approval gate.
- **Next-action contract gate:** every user-facing response must state the proposed next action, what user reply is needed, and what `pokračuj` would authorize; never treat a vague continue as approval for unstated implementation work.
- **Root coordination-only gate:** the root orchestrator may inspect git/delivery state, orchestration references, `.ant/orchestrator/*`, and child-agent reports, but must not scout source files or implement app code directly.
- **Sticky orchestrator gate:** once this skill is active in a thread, the root remains the orchestrator for every later request in that thread, including after completion, debugging, review fixes, polish, post-delivery issues, and new follow-up tasks. A new user request starts a new orchestration cycle unless the user explicitly says they do not want orchestration and want the root to work directly.
- **No root manual work gate:** while this skill is active, every implementation change, follow-up, debugging fix, review fix, polish change, test, docs edit, formatting/config change, or one-line text edit must be delegated to a child agent. User phrases like "udělej to", "oprav to", "zapracuj připomínku", "je to jen maličkost", or "pokračuj" mean continue orchestration, not root manual edits.
- **Root mutation-tool ban:** while this skill is active, the root orchestrator must not call `apply_patch`, editor/write tools, formatting commands, migration commands, code generators, or shell commands that modify app/source/test/docs/config files. The only root-owned writes are orchestration run/phase artifacts under `.ant/orchestrator/*`, plus explicitly approved branch/worktree/MR actions. Any other mutation must be delegated to a child implementation lead or worker.
- **Delegation-on-implementation gate:** if the user says "rovnou udělej změny", "implementuj", "oprav to", "pokračuj", or otherwise approves implementation while orchestration is active, the root's next action is to delegate an implementation lead with an owned write scope. It is never permission for the root to inspect implementation files or edit them directly.
- **Hard no-edit gate:** for `Medium`, `High`, and `Critical` work, phrases like "rovnou implementuj", "pojďme to udělat", "tohle bych implementoval", or "všechno zní dobře" authorize planning, not editing, unless they explicitly approve a concrete implementation plan that already exists.
- **Pre-edit checklist gate:** before any child agent writes implementation files, it must have an approved plan path or explicit skip decision, exact user implementation approval, assigned write scope, validation expectation, and parent delegation message. For the root orchestrator, this checklist always fails for app/source/test/docs edits while orchestration is active.
- **Structured source-of-truth gate:** `state.json` is the current snapshot and `events.jsonl` is the append-only event log. Markdown is a human resume/evidence layer and must not be the only place where current status, phase, agent relationships, blockers, decisions, or verification state exists.
- **Curated markdown gate:** default user-facing markdown should stay concise and operational. Keep the primary surface to run `state.md`, `decisions.md`, `handoff.md`, the current/last `phase.md`, `review.md`, `verification.md`, the approved plan, and explicit agent outputs. Older phase/subphase files are audit archive and should be marked or organized as such.
- **Phase close / handoff gate:** no phase is complete until `state.json` and `events.jsonl` are updated and the phase folder has a concise human resume with status, owner, work done, evidence, decisions, open questions, next handoff, files to read, and must-not-assume notes. Do not leave old `active`, `pending`, or `waiting` text in closed phase summaries unless it is explicitly labeled as historical.
- **Markdown metadata gate:** new markdown artifacts should begin with a small YAML front matter block when practical: `type`, `phaseId`, `agentId`, `status`, `createdAt`, `updatedAt`, `canonical`, and optional `supersededBy`. Store timestamps in UTC/Zulu. UIs may use this metadata to separate current evidence from archive.
- **Context persistence gate:** for medium+ work, keep concise local ignored run and phase files for decisions, findings, current phase, and handoff; never store secrets, raw logs, noisy transcripts, or repeated low-value boilerplate.
- **Decision timestamp gate:** every new user decision recorded in run-level or phase `decisions.md` must include the full UTC/Zulu timestamp, for example `2026-05-26T14:03:12Z`, not date-only text. Store UTC in artifacts and let UIs render local time.
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
- **Machine-readable state gate:** new persisted orchestration runs should maintain `.ant/orchestrator/<run>/state.json` and `.ant/orchestrator/<run>/events.jsonl` according to `plugins/ant/contracts/orchestrator-state/`; markdown remains the human resume layer.
- **Preferred language gate:** when a run has `preferredLanguage`, future user-facing phase titles, agent summaries, agent assignment fields, notes, checkpoints, markdown headings, event messages, and handoffs should use that language; supported values are `cs-CZ` and `en`. If no preference exists, infer it from the initial user request and fall back to `en`. Never rewrite historical orchestration text to match a changed preference.
- **Evidence gate:** child-agent reports are claims until backed by tests, independent review, runtime checks, or explicitly accepted residual risk.
- **Review/fix loop gate:** P0/P1/P2 findings block completion until fixed, verified, and re-reviewed or explicitly accepted by the user.
- **Post-completion reopen gate:** if the run is `completed` and the user asks for any follow-up change, bug fix, correction, missed requirement, polish, or review note, reopen the persisted run before delegating work: change `state.json.status` away from `completed` to the appropriate active status, update `currentPhaseId`, append a `run.status_changed` event, and refresh the relevant markdown state/handoff files.
- **Flow metadata compatibility gate:** do not add new structured enum values just to represent risk-tier dispatch. Store `originalRiskTier`, `activeRiskTier`, `flowMode`, `cycle`, `followUpOf`, and `rootMode` in `state.json.metadata`; child-specific details such as `workerKind: bounded-low-worker` belong in the child agent's `metadata`.
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
- current cycle metadata records the selected risk tier and flow mode when structured persistence is active;
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
