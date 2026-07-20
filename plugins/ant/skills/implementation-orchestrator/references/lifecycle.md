# Implementation Lifecycle

This file is the normative owner for lifecycle ordering, gates, phase transitions, liveness, recovery, and completion. Shared terminology, authorization, evidence, review inputs, routing, host mechanics, and prompt shapes are owned by their linked references and are not redefined here.

## Required Owners

- vocabulary: `policies/vocabulary.md`
- authorization: `policies/approval-policy.md`
- evidence: `policies/evidence-policy.md`
- adaptive reasoning: `policies/reasoning-policy.md`
- review input: `policies/review-manifest.md`
- capability preflight/routing: `runtime/capability-routing.md`
- host mechanics: `runtime/hosts/codex.md` or `runtime/hosts/claude-code.md`
- responsibilities: matching `*-role.md`
- task discipline: `task-scoped-execution.md`
- output shapes: `templates/*.md`
- machine contract: `plugins/ant/contracts/orchestrator-state/`

## Role And Ownership Invariants

Root owns user communication, run-level orchestration artifacts, phase transitions, approval resolution, and dispatch. Root may read repository instructions, git/delivery state, `.ant/orchestrator/*`, and child reports. Root must not inspect application implementation files for implementation facts or edit source, tests, docs, configuration, or generated files while this lifecycle is active.

Implementation workers own bounded write scopes. One path/subsystem has one active writer. Scouts and reviewers are read-only unless a separate implementation assignment explicitly grants writes. Children report to their parent; only root addresses the user.

Using this skill authorizes workflow-required delegation through a verified fresh-context mechanism; do not ask again merely to use a scout, planner, lead, worker, or reviewer. Classify each bounded packet and request its reasoning tier through `policies/reasoning-policy.md`. This does not authorize edits, delivery, destructive actions, permission escalation, or another action governed by the approval policy.

Orchestration remains active for follow-ups after completion. A follow-up creates or reopens a cycle and is delegated. Root-direct work is allowed only after the user explicitly ends orchestration and the active run is durably paused, blocked, cancelled, or closed.

## Phase Order

Use only the phases needed by the risk tier, but preserve this order:

1. intake and recovery;
2. repository/runtime discovery;
3. clarification and direction;
4. planning and plan review when required;
5. approval resolution;
6. delegated implementation and integration;
7. validation, review, fix, and re-review;
8. phase close and delivery handoff.

Low-risk work may compress phases into a bounded worker packet. It does not skip structured persistence, capability preflight, authorization, delegation, or evidence.

## 1. Intake, Persistence, And Recovery

Before delegation, verification, delivery, or work expected to span responses:

- identify or create `.ant/orchestrator/<run-id>/state.json` and `events.jsonl`;
- validate them against contract `1.0.0` when they already exist;
- record current cycle, risk hint, `rootMode: dispatch-only`, phase, branch/target, and known ownership using existing fields/metadata;
- create concise markdown only when it improves human resume value;
- append durable events with UTC/Zulu timestamps.

Valid persistence exceptions are a pure answer, explicit user refusal, or an unwritable filesystem. Report the exception and do not pretend durable recovery exists.

After resume, compaction, host change, or suspected context loss, reconstruct from structured state, events, current git state, linked artifacts, and child checkpoints before answering or acting. Treat possibly active writers as active until verified closed or safely checkpointed. Never start an overlapping replacement writer.

If no trustworthy run can be recovered, create a recovery run and record its evidence sources before delegation or delivery.

## 2. Repository, Git, And Runtime Discovery

Discover facts before asking the user:

- repository instructions, current branch/worktree, dirty paths, remote/default target candidates, provider policy, and available validation commands;
- in-scope, unrelated, and unknown dirty changes;
- runtime capability snapshot from `runtime/capability-routing.md` and exactly one detected host adapter;
- implementation facts through a read-only scout when root cannot safely determine them from delivery metadata.

Runtime preflight occurs before the first child. It is non-mutating and records unknown instead of assumptions. Persist the artifact pointer and display summary in compatible metadata.

The first delegation is gated on the complete audit trail owned by `runtime/capability-routing.md`: capability artifact, `metadata.runtime` pointer/summary, and a routing-decision record with requested, actual/unknown, fallbacks, `evidenceSource`, and observation time. If any required surface is missing, stop before child dispatch instead of reconstructing route truth from a prompt or checkpoint.

Record startup discovery as evidence records from `policies/evidence-policy.md`; later plans, reviews, and final handoffs reference the same ids instead of restating stronger claims.

Repository discovery does not choose product behavior, target branch, unrelated-change handling, commit strategy, MR intent, pipeline recovery, browser side effects, or delivery authorization for the user.

## 3. Cycle Risk And Startup Questions

Classify every initial request and follow-up independently:

- `Low`: narrow local behavior, no shared contract or material risk;
- `Medium`: bounded feature/fix with behavior, test, or contract judgment;
- `High`: cross-stack, public contract, cache, migration, provider, broad refactor, or multiple writers;
- `Critical`: security, auth, billing, tenancy, destructive data, irreversible migration, compliance, or production-customer risk.

Escalate immediately when discovered scope exceeds the tier. Risk is a routing input, not authorization.

After repo/runtime discovery, ask only unresolved user-owned blockers. Ask every blocker needed; do not cap question count. Group questions into the fewest practical rounds and ask another round only when an answer or new evidence creates a new blocker. Never repeat an already explicit decision.

User-owned blockers may include:

- intended behavior, success, non-goals, compatibility, rollout, data preservation, permissions, and acceptance risk;
- planning cadence and one-time/phased/minimal strategy;
- autonomous or manual decision mode;
- phase continuation policy and stop conditions;
- confirmed target branch and unrelated-change handling;
- commit, delivery, MR language/intent, pipeline check/recovery, and browser validation policy.

Use `templates/startup-contract.md` for the display summary. Its metadata copy is not authorization.

## 4. Direction And Planning

Use scouts when architecture, current behavior, contracts, debt, or feasibility are repo-discoverable. After scouting, separate:

- repo facts;
- safe reversible assumptions;
- user-owned decisions;
- tentative recommendation.

Do not turn current code structure into desired product intent. Challenge a requested path when evidence shows a cleaner or safer long-term path; present scope, tradeoffs, and recommendation.

For medium+ migration, data-model, public-contract, provider, reporting, or broad-refactor work, obtain an explicit rollout choice: one-time clean refactor, phased rollout, or compatibility-first minimal change. A phased plan covers the full roadmap before phase 1 implementation.

Use a plan writer for medium+ work or whenever contracts, phases, acceptance scenarios, risk scenarios, or concurrency need durable detail. Plan review is required for high/critical work and when scope/authorization/data safety is uncertain.

The plan must name:

- goal, non-goals, approved decisions, architecture/contract boundaries, and debt disposition;
- startup contract and decision authority;
- full roadmap and stop/continue rules when phased;
- task/write ownership and concurrency boundaries;
- definition-of-done and applicable risk scenarios;
- validation, evidence, review, rollback, and delivery boundaries.

If a material blocker remains, return to clarification. Do not hide it as an assumption.

## 5. Approval Resolution

Before the first implementation edit and before each delivery action, resolve authorization through `policies/approval-policy.md`.

Implementation may start only when the child has:

- approved plan path or explicit low-risk plan-skip decision;
- authoritative approval covering `edit`, scope, cycle/phase boundary, and stop conditions;
- parent delegation packet and exact write ownership;
- validation/evidence expectations.

For medium/high/critical work, broad enthusiasm before a concrete plan is approval to continue planning, not to edit. An approval envelope may cover multiple verified phases, but only its named actions and boundaries.

The resolver runs again after resume/compaction/cross-host handoff and before commit, push, MR, pipeline recovery, merge, or release. Metadata never substitutes for it.

## 6. Capability-Based Delegation

Route every child through `runtime/capability-routing.md` and the active host adapter. Use role/risk capability needs, never a hardcoded model name.

Required delegation properties:

- verified fresh/no-history context;
- a curated packet from `templates/task-packet.md`;
- one owner and explicit allowed/forbidden paths;
- required capabilities and safe fallback policy;
- requested versus actual route evidence;
- a persisted capability-artifact ref and routing-decision `evidenceSource`;
- checkpoint, validation, escalation, and output contract.

If history isolation is unsupported or unknown, do not spawn that child. If nesting is insufficient, flatten under root. On flat hosts, an implementation lead requests slices/review and root dispatches them while the lead keeps integration ownership.

Use the smallest sufficient workflow:

- Low: one bounded implementation worker represented by an implementation-lead role;
- Medium: one implementation lead; scout/reviewer only when evidence or risk requires;
- High: scout/plan writer as needed, implementation lead, bounded slices, independent reviewer;
- Critical: explicit plan review, strong implementation lead, bounded ownership, strong validation, independent review and re-review.

Do not create artificial microtasks. Parallel work requires disjoint write scopes and a stable shared contract.

## 7. Implementation, Tasks, And Checkpoints

Implementation lead confirms the plan against real code before writing, owns integration, and escalates material divergence. It may use task-scoped execution only when tasks have meaningful independent implementation/validation/review boundaries.

For task-scoped work, follow `task-scoped-execution.md`. For each task, use a brief, report, optional focused diff/range, and two-verdict review. Track task progress in compatible metadata or linked artifacts without new contract enums.

Status is push-first. Use `templates/checkpoint.md` after discovery, before broad/risky changes, on blockers or contract divergence, after task/slice completion, before review, after fixes, and after validation. Parent polling is recovery, not normal flow.

Before replacing a silent writer:

1. request a checkpoint;
2. attempt safe interrupt only when the host supports it and continuing is unsafe;
3. verify the writer is closed or obtain its partial-work report;
4. audit the partial diff and reassign ownership explicitly.

No timeout alone proves a worker is stuck.

## 8. Validation, Review, And Fix Loop

Use evidence records from `policies/evidence-policy.md`. Map every applicable acceptance/risk scenario to evidence or a named residual risk. Worker reports remain claims until supported.

Before review, assemble `policies/review-manifest.md`; use `templates/review-handoff.md` only for formatting. Missing required context produces `Cannot verify` or a finding, never silent approval.

The reviewer is independent and normally read-only. It checks requirement fit, authorization boundaries, architecture/contracts, behavior, negative cases, tests, evidence freshness, obsolete paths, and avoidable debt.

P0/P1/P2 or either task verdict `Needs fixes` blocks completion. Assign fixes to an implementation writer, run targeted validation, and re-review material findings. Finding-specific residual-risk acceptance must satisfy the approval policy.

For user-facing browser behavior, validate named scenarios on an available preflighted surface. If unavailable, record blocked evidence and residual risk.

## 9. Phase Close And Handoff

Before a transition, pause, compaction, replacement, milestone commit, completion report, or delivery:

- update `state.json` and append schema-valid events;
- update concise phase/run markdown when active;
- record status, inputs, work, decisions/rationale refs, evidence, findings, blockers, active ownership, next action, files to read first, and must-not-assume notes;
- use `templates/phase-close.md` for the shape.

A phase cannot close with stale structured state, missing required evidence, overlapping/unknown writer ownership, unresolved blocking findings, or a stop condition requiring user input.

Within a valid approval envelope, auto-continue after a verified phase when its continuation policy allows. Do not ask for generic re-approval after each micro-step.

## 10. Delivery Readiness

Delivery is not implicit in implementation completion. Resolve authorization for each approved action and follow repository tooling/policy. MR creation content/provider flow is owned by `ant:merge-request`.

Before staging/commit/push/MR/pipeline work, verify:

- current branch/worktree and confirmed target;
- intended paths and unrelated-change decision;
- latest relevant evidence and review status;
- commit strategy and phase/milestone close;
- exact authorized delivery actions and stop conditions;
- MR draft/ready/language intent and pipeline policy.

Use `templates/delivery-handoff.md`. Always distinguish done from not done, recommend one next action, and state exactly what `pokračuj` would authorize after it is durably recorded. Merge and release require explicit authorization and never follow from generic delivery approval.

## Mid-Flight User Input

Treat new user input as authoritative without assuming the run is cancelled.

- status question: answer from durable checkpoints;
- clarification/addendum inside scope: record and forward safely;
- material scope/behavior/contract/risk change: pause affected work, checkpoint writers, revise plan/approval;
- urgent correction: interrupt only when the host supports safe interruption;
- unrelated task: queue a new cycle unless the user asks to switch;
- cancel/pause: stop new dispatch, checkpoint active writers, preserve partial work.

Do not let a child continue into newly unapproved scope.

## User-Facing Next Action

Every non-final root response names:

```text
Proposed next action:
User input needed:
What `pokračuj` would authorize after recording approval:
```

State one bounded next action or the exact approved envelope. Never imply that `pokračuj` authorizes unstated edits or delivery.

## Completion Criteria

The run is complete only when:

- structured state/events are current and schema-compatible;
- startup decisions and authoritative approval evidence are resolvable;
- implementation was delegated through verified fresh context with route evidence;
- write ownership is closed and unrelated changes preserved;
- approved plan/low-risk packet and architecture/contracts were followed or deviations approved;
- definition-of-done and applicable risk scenarios map to sufficient evidence;
- required review manifest was available and review passed;
- blocking findings were fixed, validated, and re-reviewed or validly accepted;
- residual risks and blocked checks are explicit;
- final handoff distinguishes implementation from delivery and names the next authorized action.
