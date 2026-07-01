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
- `references/task-scoped-execution.md` - optional implementation-phase task brief, report, review package, and task ledger discipline.
- `references/slice-worker-role.md` - bounded backend/frontend/data/test slice worker role.
- `references/reviewer-role.md` - plan and integrated implementation reviewer role.

## Core Model

```text
Root Orchestrator
├── Scout role(s), read-only
├── Plan Writer role
├── Plan Reviewer role, high-risk only
└── Implementation Lead role
    ├── Task-scoped worker/reviewer loop, optional
    ├── Slice Worker role(s), optional
    └── Implementation Reviewer role
```

The root orchestrator owns the user-facing flow and is coordination-only. It must not inspect application source/test/docs files for implementation facts itself and must not implement app code. It clarifies intent, uses scout reports for codebase evidence, challenges weak ideas, gets approval, delegates implementation, tracks progress, and verifies evidence.

The root orchestrator stays a coordinator after completion. Follow-up debugging, review fixes, polish, tiny edits, post-delivery issues, and "one more thing" requests start or resume orchestration and must be delegated unless the user explicitly leaves orchestration mode.

The implementation lead is a child of the root orchestrator. It owns the implementation phase, may spawn slice workers when useful, integrates all output, runs checks, handles review/fix loops, and reports final evidence.

## Intended User Flow

The default experience should not require the user to hand-hold phase transitions. The root orchestrator should drive this loop:

1. Gather git/delivery context and repo facts through scouts when needed.
2. Ask all blocking user questions, grouped clearly with recommended answers and tradeoffs.
3. Repeat clarification only while answers expose new blocking decisions.
4. When direction is clear, finalize the implementation plan artifact under `.ant/orchestrator/<run>/phases/05-planning/implementation-plan.md`.
5. Present a concise plan summary and approval envelope, including browser validation policy for user-facing UI changes, then ask whether to start implementation.
6. After approval, delegate implementation and continue through review, verification, approved commits, MR/PR preparation, and pipeline policy until a recorded stop condition is hit.

The approval envelope is what prevents repeated "should I continue?" prompts. If the user approves an envelope such as autonomous implementation through MR and pipeline check, later agents should continue within that envelope without asking again after every phase. They must stop only for recorded stop conditions, unapproved scope/risk changes, failed verification that cannot be fixed in scope, delivery boundary changes, or product decisions outside the decision policy.

This liveness rule does not weaken delegation safety. The root orchestrator still never implements app/source/test/docs/config changes. All implementation, review fixes, debugging, polish, and tiny edits are delegated to no-history child agents with explicit assignment briefs.

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

1. **Git context and delivery setup** - inspect branch, dirty state, likely target branch, branch/worktree need, commit strategy, merge request preference, and pipeline/watch preference before planning implementation work.
2. **Persistence bootstrap gate** - if orchestration is active and the work will use subagents, delivery actions, verification, or more than one response, `.ant/orchestrator/<run>/state.json` and `events.jsonl` must exist before the first delegated, delivery, or verification action. If they do not exist, creating or reopening them is the next action.
3. **Risk classification and cycle setup** - classify the current request or follow-up as `Low`, `Medium`, `High`, or `Critical`; create or reopen the structured run state and record `activeRiskTier`, `flowMode`, `cycle`, and `rootMode: dispatch-only` in `state.json.metadata`.
4. **Run startup contract** - before detailed planning, ask and record all blocking planning, cadence, phase approval, commit, delivery, MR, pipeline, and browser validation preferences that change scope, risk, autonomy, or validation. Do not cap the number of required questions; group them clearly when there are many.
5. **Structured run bootstrap and phase workspace setup** - for every orchestrated run, create or reopen `.ant/orchestrator/<run>/state.json` and `events.jsonl` before the first child delegation; for medium+ work, also keep concise markdown state, decisions, handoff, and only the phase folders needed for the selected tier.
6. **Intake and brainstorming** - ask every material blocking question needed for a high-quality plan. Do not invent user intent, and do not ask the user for facts that should be discovered from the repo.
7. **Scout when needed** - delegate read-only codebase analysis to scout agents when architecture, feasibility, debt, contracts, or direction are unknown.
8. **Post-scout clarification** - after scout findings, separate repo facts from user decisions and ask the user before turning unresolved decisions into a recommendation.
9. **Challenge and recommend** - do not blindly agree; present better options with tradeoffs when evidence supports them.
10. **Next-action approval** - every user-facing phase response says what the orchestrator wants to do next and waits when moving to planning or implementation unless a prior approval envelope explicitly authorizes the next workstream step.
11. **Rollout strategy approval** - for medium+ refactors, migrations, data-model, reporting, or cross-stack work, present one-time/phased/minimal strategy options before detailed planning.
12. **Execution mode approval** - before implementation planning for medium+ work, ask whether the user wants autonomous implementation mode or manual decision mode.
13. **Direction approval** - get user approval for the conceptual path before detailed planning when the selected tier requires it.
14. **Plan phase artifact** - create or update `.ant/orchestrator/<run>/phases/05-planning/implementation-plan.md` through the plan writer role for medium+ work when a concrete plan adds value or is required by risk.
15. **Implementation approval** - summarize the plan or low-risk dispatch packet, execution mode, phase approval policy, commit strategy, delivery/MR/pipeline policy, decision policy, and current phase detail, then wait for approval when the gate requires it.
16. **Delegated implementation** - delegate implementation before editing app code. `Low` uses one bounded implementation worker; higher tiers use an implementation lead.
17. **Task-scoped execution when useful** - implementation may split approved work into reviewable tasks with file-based briefs, worker reports, review packages, task verdicts, and progress recorded in orchestrator state.
18. **Multi-phase implementation when useful** - implementation may use `phases/06-implementation/subphases/<NN-name>/...` with roadmap, checkpoints, verification, review, milestone commits when approved, and stop/continue rules.
19. **Slice work when useful** - backend/frontend/data/test slices may run in parallel against explicit contracts.
20. **Phase close and handoff** - before any user-facing transition, pause, stop, handoff, milestone commit, or completion report, update structured state and concise human artifacts.
21. **Integration, review, verification, delivery handoff** - implementation is done only after tier-appropriate checks, review/fix loop when required, evidence, and a concrete delivery handoff that says whether staging, commit, push, merge request creation, and pipeline watching are recommended, blocked, or explicitly declined.

## Mandatory Gates

- **Assumption gate:** classify uncertainty as blocking, repo-discoverable, or safe.
- **Risk-tier gate:** every initial request, review fix, missed requirement, bug report, polish task, and post-completion follow-up must receive a fresh `Low` / `Medium` / `High` / `Critical` classification before dispatch. Follow-ups inherit context and constraints, not the previous risk tier.
- **Run startup contract gate:** before detailed planning or implementation dispatch, record the user's planning cadence, phase approval policy, commit strategy, post-implementation delivery actions, MR intent, pipeline/watch policy, browser validation policy, and decision mode when those choices affect scope, risk, validation, delivery, or autonomy. Ask every material blocking question; do not impose an arbitrary question count limit.
- **Persistence bootstrap gate:** if orchestration is active and the next work will use subagents, delivery actions, verification, or survive beyond the current response, an active `.ant/orchestrator/<run>/state.json` and `events.jsonl` must exist first. The root must not spawn, message, wait for, or replace child agents; run verification; push; create/update an MR/PR; recover a pipeline; or report long-running status until structured persistence is created or reopened. The only exceptions are a pure answer with no implementation/delegation/delivery, explicit user refusal of filesystem persistence, or an unwritable filesystem; record and report the reason when persistence is skipped.
- **Subagent authorization gate:** follow the standing authorization in `references/lifecycle.md`; do not ask again for permission to use workflow-required subagents unless the action also needs a separate approval gate.
- **No conversation-history fork gate:** when spawning or messaging any child agent, the parent must use a fresh-task / no-history / no-fork mode. Never use any tool option, thread fork, conversation clone, or steered-conversation mode that gives the child the current chat transcript, hidden prior messages, or inherited conversation state. If the host only supports child agents by forking the current conversation history, do not spawn the child; report that delegation is blocked and recommend a clean no-history implementation task/thread, environment fix, or paused run.
- **Precise delegation prompt gate:** every spawned child must receive a fresh, explicit assignment brief, not a forked or steered copy of the current conversation. The parent must summarize only the context required for that role: goal, role, scope, non-goals, allowed tools/mutations, owned files/subsystems, constraints, required inputs to inspect, validation expectations, escalation conditions, and exact output format.
- **Next-action contract gate:** every user-facing response must state the proposed next action, what user reply is needed, and what `pokračuj` would authorize; never treat a vague continue as approval for unstated implementation work. When a recorded approval envelope exists, `pokračuj` should mean "continue the approved workstream until the next stop condition", not "ask again after one micro-step".
- **Approval envelope gate:** the user may approve a multi-step workstream only when the assistant states the full authorized envelope, including phases, stop conditions, verification requirements, milestone commit policy, delivery boundaries, MR/PR intent, pipeline policy, and escalation rules. Inside that envelope, agents continue automatically after verified checkpoints when the recorded phase approval policy allows it.
- **Root coordination-only gate:** the root orchestrator may inspect git/delivery state, orchestration references, `.ant/orchestrator/*`, and child-agent reports, but must not scout source files or implement app code directly.
- **Sticky orchestrator gate:** once this skill is active in a thread, the root remains the orchestrator for every later request in that thread, including after completion, debugging, review fixes, polish, post-delivery issues, and new follow-up tasks. A new user request starts a new orchestration cycle unless the user explicitly ends this lifecycle; ending the lifecycle is not a completion path for the active orchestrated run.
- **No root manual work gate:** while this skill is active, every implementation change, follow-up, debugging fix, review fix, polish change, test, docs edit, formatting/config change, or one-line text edit must be delegated to a child agent. User phrases like "udělej to", "oprav to", "zapracuj připomínku", "je to jen maličkost", or "pokračuj" mean continue orchestration, not root manual edits.
- **Root mutation-tool ban:** while this skill is active, the root orchestrator must not call `apply_patch`, editor/write tools, formatting commands, migration commands, code generators, or shell commands that modify app/source/test/docs/config files. The only root-owned writes are orchestration run/phase artifacts under `.ant/orchestrator/*`, plus explicitly approved branch/worktree/commit/push/MR/pipeline actions. Any other mutation must be delegated to a child implementation lead or worker.
- **Delegation-on-implementation gate:** if the user says "rovnou udělej změny", "implementuj", "oprav to", "pokračuj", or otherwise approves implementation while orchestration is active, the root's next action is to delegate an implementation lead with an owned write scope. It is never permission for the root to inspect implementation files or edit them directly.
- **Hard no-edit gate:** for `Medium`, `High`, and `Critical` work, phrases like "rovnou implementuj", "pojďme to udělat", "tohle bych implementoval", or "všechno zní dobře" authorize planning, not editing, unless they explicitly approve a concrete implementation plan that already exists.
- **Pre-edit checklist gate:** before any child agent writes implementation files, it must have an approved plan path or explicit skip decision, exact user implementation approval, assigned write scope, validation expectation, and parent delegation message. For the root orchestrator, this checklist always fails for app/source/test/docs edits while orchestration is active.
- **Structured source-of-truth gate:** `state.json` is the current snapshot and `events.jsonl` is the append-only event log. Markdown is a human resume/evidence layer and must not be the only place where current status, phase, agent relationships, blockers, decisions, or verification state exists.
- **Curated markdown gate:** default user-facing markdown should stay concise and operational. Keep the primary surface to run `state.md`, `decisions.md`, `rationale.md`, `handoff.md`, the current/last `phase.md`, `review.md`, `verification.md`, the approved plan, and explicit agent outputs. Older phase/subphase files are audit archive and should be marked or organized as such.
- **Decision rationale gate:** no material planning, architecture, debt, rollout, validation, review-fix, or delivery decision may exist only in chat. Before moving phases, handing off, starting implementation, requesting review, reporting completion, or compacting context, record durable rationale checkpoints in the current phase artifacts: decision made, options considered, selected path, rejected alternatives, evidence, tradeoffs, accepted/deferred risk, and reviewer focus. Store conclusions and rationale summaries, not raw chain-of-thought or every speculative idea.
- **Phase close / handoff gate:** no phase is complete until `state.json` and `events.jsonl` are updated; when markdown persistence is active, the phase folder must also have a concise human resume with status, owner, work done, evidence, decisions, rationale for material choices, open questions, next handoff, files to read, and must-not-assume notes. Do not leave old `active`, `pending`, or `waiting` text in closed phase summaries unless it is explicitly labeled as historical.
- **Markdown metadata gate:** new markdown artifacts should begin with a small YAML front matter block when practical: `type`, `phaseId`, `agentId`, `status`, `createdAt`, `updatedAt`, `canonical`, and optional `supersededBy`. Store timestamps in UTC/Zulu. UIs may use this metadata to separate current evidence from archive.
- **Context persistence gate:** for every orchestrated run, keep a local ignored structured run under `.ant/orchestrator/<run>/` with current `state.json` and append-only `events.jsonl`; for medium+ work, also keep concise markdown run and phase files for decisions, rationale, findings, current phase, and handoff. Skip structured persistence only when the user explicitly declines filesystem persistence or the host cannot write files; report that as a blocker or residual risk. Never store secrets, raw logs, noisy transcripts, or repeated low-value boilerplate.
- **Decision timestamp gate:** every new user decision recorded in run-level or phase `decisions.md` must include the full UTC/Zulu timestamp, for example `2026-05-26T14:03:12Z`, not date-only text. Store UTC in artifacts and let UIs render local time.
- **Post-compact recovery gate:** after compaction, resume, or suspected context loss, rebuild orchestration state from `.ant/orchestrator/*`, git state, and child-agent reports before answering, delegating, editing, or reporting completion. If no active structured run can be found, create a recovery run under `.ant/orchestrator/<YYYY-MM-DD-recovery>/` and record the reconstruction source before continuing. Compaction does not cancel child agents.
- **Orchestration artifact location gate:** all markdown artifacts created by this orchestration flow belong under `.ant/orchestrator/`; never create root-level `implementation-plan.md` or ad hoc planning markdown unless the user explicitly asks for a tracked repository document.
- **Post-scout clarification gate:** codebase facts cannot silently become product decisions; after scouting, ask the user about unresolved behavior, scope, rollout, data, validation, or architecture choices before issuing a final direction.
- **Rollout strategy gate:** for broad or risky work, ask whether to proceed as one-time refactor, phased rollout, or compatibility-first minimal change before writing the final plan.
- **Execution mode gate:** for medium+ work, record whether implementation will run in autonomous implementation mode or manual decision mode before detailed plan writing. Autonomous mode lets agents choose among technical variants using code evidence and the approved decision policy; manual mode requires user choice when valid variants remain.
- **Phased roadmap gate:** when phased rollout is selected, the plan must cover the whole roadmap before phase 1 starts. Later phases may be less detailed, but each phase needs goals, dependencies, acceptance criteria, compatibility/rollback expectations, validation expectations, and stop/continue rules.
- **Multi-phase implementation gate:** implementation may be split under `phases/06-implementation/subphases/<NN-name>/...`; each subphase must have a roadmap checkpoint, verification evidence, review status when applicable, and explicit stop/continue rule before the next subphase starts.
- **Task-scoped execution gate:** when an approved plan has separable reviewable tasks, the implementation lead should consider `references/task-scoped-execution.md`. Use file-based task briefs, worker reports, review packages, separate spec-compliance and engineering-quality verdicts, and task progress recorded in `.ant/orchestrator/<run>/state.json` metadata or linked artifacts. Do not use this gate for tiny edits where it adds coordination cost without evidence value.
- **Milestone commit gate:** if the user approves commits after phases or major milestones, commit only after the phase/milestone is closed, targeted checks passed or residual risk is explicitly recorded, dirty state is understood, and unrelated changes are excluded. Never create unverified WIP commits unless the user explicitly approved checkpoint commits with residual risk.
- **Git/delivery gate:** record current branch, dirty state, target branch, branch/worktree decision, unrelated-change decision, commit strategy, merge request preference, and pipeline/watch preference; never create/switch branches, worktrees, commit, push, create MRs, or watch/recover pipelines without explicit approval or a recorded approval envelope.
- **Target branch intake gate:** recommend a target branch when possible, but store the user-confirmed target before planning or delivery; delivery must stop if no confirmed target exists.
- **Unrelated changes gate:** explicitly list dirty files outside scope and ask whether to include, exclude, or leave them aside; broad phrases like "push everything" do not bypass this warning.
- **Legacy/debt gate:** never silently copy bad architecture, legacy flow, duplicate paths, stale abstractions, or half-migrated behavior.
- **Architecture boundary gate:** verify module ownership, layer responsibility, file placement, import boundaries, shared utilities, and test placement.
- **Model routing gate:** the root model is selected by the user/session. When spawning child agents, route by role and risk: `gpt-5.5` / Claude Opus tier for implementation leads, decisions, architecture, review, and high-risk work; `gpt-5.4-mini` / Claude Sonnet tier for bounded small-medium work; `gpt-5.3-codex-spark` / Claude Haiku tier for tiny mechanical tasks. Do not use `gpt-5.4` or `gpt-5.3-codex` for new child-agent routing.
- **Scenario-based definition of done gate:** convert broad goals into concrete acceptance and risk scenarios with validation or explicit residual risk.
- **Contract-first gate:** for cross-stack work, define request/response shape, errors, permissions, cache behavior, time handling, UI states, and fixtures before parallel implementation.
- **Machine-readable state gate:** every orchestrated run should maintain `.ant/orchestrator/<run>/state.json` and `.ant/orchestrator/<run>/events.jsonl` according to `plugins/ant/contracts/orchestrator-state/`, including `Low` and minimal delegated runs; markdown remains the human resume layer and may be minimal for low-risk work.
- **Preferred language gate:** when a run has `preferredLanguage`, future user-facing phase titles, agent summaries, agent graph labels, agent assignment fields, notes, checkpoints, markdown headings, event messages, and handoffs should use that language; supported values are `cs-CZ` and `en`. If no preference exists, infer it from the initial user request and fall back to `en`. Never rewrite historical orchestration text to match a changed preference.
- **Evidence gate:** child-agent reports are claims until backed by tests, independent review, runtime checks, or explicitly accepted residual risk.
- **Review context bundle gate:** plan review and implementation/code review must start from the orchestration context bundle, not from a diff alone. The reviewer must read or be given `state.json`, `events.jsonl`, run `index.md`, `state.md`, `decisions.md`, `rationale.md` when present, `handoff.md`, the current phase `phase.md` / `decisions.md` / `rationale.md` / `handoff.md`, the approved plan, scout findings, verification evidence, and implementation/slice reports relevant to the review. Missing required context is itself a review finding or blocker.
- **Review/fix loop gate:** P0/P1/P2 findings block completion until fixed, verified, and re-reviewed or explicitly accepted by the user.
- **Post-completion reopen gate:** if the run is `completed` and the user asks for any follow-up change, bug fix, correction, missed requirement, polish, or review note, reopen the persisted run before delegating work: change `state.json.status` away from `completed` to the appropriate active status, update `currentPhaseId`, append a `run.status_changed` event, and refresh the relevant markdown state/handoff files.
- **Flow metadata compatibility gate:** do not add new structured enum values just to represent risk-tier dispatch. Store `originalRiskTier`, `activeRiskTier`, `flowMode`, `cycle`, `followUpOf`, and `rootMode` in `state.json.metadata`; child-specific details such as `workerKind: bounded-low-worker` belong in the child agent's `metadata`.
- **Push-first status gate:** child agents push phase checkpoints to their parent; parent polling is a recovery tool, not the default.
- **Mid-flight user input gate:** if the user sends new instructions, questions, corrections, or scope notes while child agents are active, preserve the current run by default, classify the input, answer from known state when possible, update run/phase artifacts, and forward material changes to the relevant child at a safe checkpoint or with an interrupt only when continuing would waste work or violate the user's latest direction.
- **Writer recovery gate:** do not start an overlapping replacement writer until the silent writer is checkpointed or closed, partial work is understood, and the write scope is safe.
- **Post-verification delivery handoff gate:** after implementation review and targeted verification pass, every user-facing completion or pause report must include `Done`, `Not done`, `Recommended next action`, and `What "pokračuj" authorizes`. If delivery is not yet performed, recommend the next delivery step explicitly, such as sanity-check dirty state, stage intended files, commit, push, and create or update an MR/PR. Do not wait for the user to ask "what next?".
- **MR/pipeline readiness gate:** before push, MR creation, or pipeline watching/recovery, confirm target branch, unrelated-change decision, conscious dirty state, latest relevant checks, review/fix status, draft/ready intent, and pipeline policy.

## Loading References

Before delegating or making a lifecycle decision:

- Read `references/lifecycle.md` for the complete protocol.
- Read only the role reference needed for the next delegation.
- Read `references/task-scoped-execution.md` before task-scoped implementation, task-level review, or task ledger decisions.
- Include the relevant role instructions in the subagent prompt. Do not tell subagents to use a separate public skill for planner/scout/reviewer/etc.; those roles are internal references, not invocable skills.
- Prompt subagents with a precise assignment packet only. Use a fresh-task / no-history / no-fork tool mode. Do not fork, steer, paste, expose, or rely on the full conversation transcript as the child context.
- Never prompt a child with fake skill names such as `ant-implementation-orchestrator:planner`, `ant-implementation-orchestrator:scout`, or `ant-implementation-orchestrator:reviewer`. If the host cannot load references for a child, paste the needed role instructions or a concise role brief into the child prompt.

## Completion Criteria

The work is not complete until:

- user-approved direction and implementation plan exist under `.ant/orchestrator/<run>/phases/05-planning/`, unless the selected flow is a low-risk dispatch packet or the user explicitly requested a tracked repo document;
- current `state.json` records the selected risk tier and flow mode for the active cycle, and `events.jsonl` includes durable lifecycle events;
- run startup contract records planning cadence, phase approval policy, commit strategy, delivery/MR/pipeline preference, and decision mode when applicable;
- run-level `index.md`, `state.md`, `decisions.md`, and `rationale.md` are current for medium+ work, or markdown was intentionally omitted while structured state remains current;
- each completed markdown phase folder has `phase.md`, `decisions.md`, `handoff.md`, `rationale.md` when material choices occurred, and the phase-specific evidence files needed to resume elsewhere;
- execution mode and decision policy are recorded for medium+ work;
- phased rollout work has an approved whole-roadmap plan before any phase implementation starts;
- git/delivery context and branch/worktree/MR decisions are recorded or explicitly declined;
- commit strategy is recorded, and any milestone commits were made only after verified phase/milestone close or explicit residual-risk approval;
- target branch and unrelated-change decisions are recorded before push/MR delivery;
- implementation was delegated to an implementation lead;
- every implementation or follow-up change inside the orchestrated run was delegated to a child agent; root-direct work is not a completion path for an active orchestrated run;
- no root mutation tool was used for app/source/test/docs/config edits while orchestration was active;
- architecture/debt/contract decisions were handled explicitly;
- slice outputs, if any, were integrated by the implementation lead;
- targeted verification ran or is explicitly blocked;
- independent review passed or residual risks are explicit;
- actionable review findings were fixed or intentionally accepted;
- post-verification delivery handoff states what remains for staging, commit, push, MR/PR creation, pipeline checking/recovery, merge, or release, and what exact user reply would authorize;
- final evidence maps back to the definition of done.
