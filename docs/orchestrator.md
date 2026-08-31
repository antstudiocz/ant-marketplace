# Implementation Orchestrator

This is the detailed user-facing routing and preflight guide for `implementation-orchestrator`. The skill remains instruction-only: no custom runtime, hooks, persisted state, event log, lease protocol, compatibility reader, generated validator, or synthetic evaluator.

## Lifecycle And Authority

1. Classify **analysis-only**, **implementation-authorized**, or **ambiguous** intent.
2. Discover repository instructions, git state, contracts, risks, and checks without edits; establish a concise, proportional native Plan as the single live, user-visible TODO checklist before tracked edits.
3. Choose continuity: in-place evolution, integrated replacement (explicit acceptance and dedicated checkout), or isolated handoff. If requested/required interactive smoke is discovered during discovery or planning, load exactly one active-host adapter early enough to complete its browser/environment preflight before presenting the Plan; otherwise defer adapter loading until the first host-specific Goal, delegation, or routing decision. Do not retain unauthorized fallback paths or shims.
4. For authorized work, establish the host-native Goal where required, dispatch one integration owner, and use disjoint workers only with stable contracts and ownership.
5. Run targeted checks after coherent phases, updating the Plan at phase/wave transitions; after final edits and independent review, freeze one candidate and verify exactly one risk-appropriate broad gate (local broad suite or qualifying exact-candidate CI) with matching Plan evidence. If CI is selected, `merge-request` owns the separately authorized pre-gate candidate publication/update before exact-tested-SHA observation; without that authority or qualifying CI, use the local broad gate.
6. Perform a bounded retrospective and keep delivery separate from implementation readiness.

Root is the sole user-facing and material adjudicator, dispatches and receives the integration owner and independent final reviewer, and directly verifies the candidate-bound broad gate. Routine operational communication, worker/tester coordination, repair, targeted checks, and re-review stay inside the workstream. The integration owner consolidates worker/tester deltas. The reviewer may send actionable findings and fix evidence directly to the integration owner but never writes fixes; disputed or material findings escalate to root. Root remains coordination-only.

Required child and nested-child route/model/profile/effort/fresh-context selection and dispatch are automatic internal execution decisions under established implementation authority, never separate approval or confirmation gates. Root invokes required routes directly and never asks the user to approve, confirm, or type “yes” merely to permit routing. Genuine host-native approval prompts retain their real semantics and are surfaced normally. If a required route or selector is unavailable or unenforceable, the run fails closed and reports the limitation and paused scope; user consent cannot make an unavailable route enforceable.

## Recursive Routing Capsule

Every child assignment must include all of the following, recursively for every permitted nested child:

| Capsule field | Required content |
|---|---|
| Route | Exact active-adapter model/profile and effort selector; Codex also requires `fork_turns="none"`. |
| Context | Fresh isolated task-local context; no conversational-history inheritance. |
| Ownership | Measurable outcome, acceptance behavior, non-goals, exact write ownership, shared-resource boundaries, and targeted checks. |
| Delegation | Explicit yes/no. If yes, permitted nested routes and effort ceiling plus the same complete capsule requirement. If absent/no, return the need to the parent and do not delegate. |
| Reporting | Routine operations and repair/test/re-review loops stay local; settled compact deltas go to the parent/integration owner; material, disputed, authority, public-contract, security, migration, or repeated-failure issues escalate to root. |

Nested children receive the capsule recursively and never inherit history. Every child remains capped at High. Children do not address the user or formulate user-facing questions.

## Host Matrix And Preflight

| Host/role | Exact route | Mandatory preflight |
|---|---|---|
| Claude root | `best` + `max` | Start with `claude --model best --effort max` or select `/model best` and `/effort max`; verify from authoritative host/session/task metadata or explicit current host selection. `opusplan` is not a route. |
| Claude strong/reviewer | `ant:strong-high` → `opus` + `high` | Hard gates: Claude 2.1.219+, verified root `best` + `max`, ordinary root-level `Agent`, `CLAUDE_CODE_SUBAGENT_MODEL` unset or exactly `inherit` (never empty), per-invocation model omitted or exact profile, global `CLAUDE_CODE_EFFORT_LEVEL` entirely unset, and exact profile/allowlist/cap/runtime metadata. |
| Claude integration | `ant:balanced-high` → `sonnet` + `high` | Same exact override, allowlist, cap, fresh-context, and capsule checks. |
| Claude bounded | `ant:balanced-medium` → `sonnet` + `medium`; `ant:controlled-low`/`ant:fast` → `sonnet` + `low` | `CLAUDE_CODE_EFFORT_LEVEL` must be entirely unset; exact Medium/Low comes only from profile frontmatter. `ant:fast` is only for narrow non-judgment-sensitive work. |
| Codex root | Developer-selected; recommended `gpt-5.6-sol` + High | Root model and effort do not gate dispatch; root-route checks are not applicable. |
| Codex strong/reviewer | `gpt-5.6-sol` + High | Explicit model, effort, `fork_turns="none"`, fresh context, and complete capsule. |
| Codex integration | `gpt-5.6-luna` + High | Explicit model, effort, `fork_turns="none"`, fresh context, and complete capsule. |
| Codex narrow | `gpt-5.6-luna` + High/Medium/Low | Proportional explicit effort, never above High. There is no Terra route or fallback. |

For Claude, fail closed when its mandatory root route cannot be enforced. For every adapter, fail closed when any child or nested-child model, effort, availability, fresh context, isolation, or Codex `fork_turns="none"` cannot be enforced. Correct and discard a child result when observable runtime metadata exposes a mismatch before re-dispatching.

For every Claude profile, `CLAUDE_CODE_SUBAGENT_MODEL` has precedence but accepts only unset or exactly `inherit` (route-neutral and continued to invocation/frontmatter); an empty value, `auto`, and every other present value block the complete run. Per-invocation child model is omitted or exactly the selected profile. Keep `CLAUDE_CODE_EFFORT_LEVEL` entirely unset so profile frontmatter controls exact effort. Plain ordinary subagent completion returns go to the caller; optional named `SendMessage` is the explicit peer exception. Planned nesting requires Claude 2.1.219+, sufficient `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`, named `Agent` children, and `SendMessage` support. Preferred topology keeps teams off and uses local named messaging; if teams are enabled or any named/`SendMessage`/nested capability is unavailable, use unnamed ordinary fallback (`subagent_type` selected, runtime `name` omitted), with sequential owner work and fresh unnamed reviewer/owner redispatch. Frontmatter `name` is not runtime `Agent` `name`; auto-added names or teammate metadata invalidate the dispatch. If exact unnamed dispatch cannot be enforced, hard stop.

## Plan And Goal Rules

Use the host-native Plan as the single live, user-visible TODO checklist for an active implementation run. Establish it before tracked edits and keep it concise and proportional: top-level items are lifecycle phases/waves, not individual workers; each has explicit `pending`, `in_progress`, or `completed` state; exactly one top-level item is `in_progress` while work is active; and native agent/thread state remains the concurrency source. Root updates it at phase/wave start and completion, stable in-scope Plan changes, recovery/resume, and applicable review, broad-gate, and delivery transitions, marking completion only when matching evidence exists. Do not mirror it in a custom TODO/PLAN.md file, status ledger, or persisted substitute. Analysis-only may present a requested Plan but remains read-only and does not enter implementation lifecycle state. Codex creates or reuses a matching immutable native Goal after the Plan is stable and before tracked-writer dispatch, and completes it only once its matching objective is genuinely achieved. Claude Goal support is optional, but Claude must not supersede an unrelated optional Goal; use a fresh session/task or explicit user-native replacement.

Never replace, complete, or block an unrelated unfinished Goal. If Codex finds one occupying the slot, pause tracked work. Root asks whether to finish the current Goal and queue a separate follow-on task, or use native user/system controls to end or resolve the current Goal; create a new Goal only after native state reports no unfinished Goal. A material objective/public-contract change that no longer fits the immutable Goal pauses affected writers, checkpoints the actual diff, and uses the same choice; never misuse `complete` or `blocked` to clear a collision or delta. Stable in-objective changes stay in Plan and assignments; unaffected disjoint work may continue only within the unchanged Goal.

Material mid-flight changes pause affected writers, collect checkpoint and actual diff, resolve the delta, update the Plan, and explicitly resume or hand off ownership. Unaffected disjoint work may continue. The same underlying defect/check unresolved after two completed local repair-and-verification cycles escalates to root; distinct or successfully resolved routine failures stay local, while evidence conflict/material scope/authority ambiguity escalates immediately. On interruption/compaction, reconcile the Plan against authoritative Goal, git/worktree/index, native agent/thread, checkpoint, report, reviewer, and actual-diff evidence; correct stale transitions and preserve exactly one active top-level phase/wave before resuming. Reverify ownership and route without status polling.

## Candidate-Bound Review And Validation

After independent review starts, any tracked mutation invalidates affected review evidence and the current candidate's validation evidence. Run targeted checks, obtain affected-area review from the same independent reviewer when available, then freeze and identify one final candidate (the exact tree/SHA to assess). Every tracked implementation receives exactly one broad final gate: the local broad suite or an exact-candidate CI pipeline. Risk determines the breadth and surface of that gate; avoid duplicate equivalent broad runs. The local broad suite is required/default when qualifying CI is unavailable, delivery is not authorized, provider evidence is unavailable, or repository policy specifically requires it. Periodic/default-branch full suites remain a repository responsibility, not an automatic orchestrator runtime requirement.

CI can substitute for the local broad suite only when the final tree is committed and pushed and matches the provider source head; the tested SHA and authoritative current source-to-tested mapping are known (source head or authoritative synthetic test-merge/merged-result SHA); pipeline coverage is known equivalent to or broader than required broad commands; relevant required jobs are present and not merely absent, skipped, or neutral; targeted local and risk-specific tests passed; and the terminal result is successful. Missing, timed-out, mismatched, or incomplete CI is unverified.

Use proportional risk, without numeric scoring: simple risk has narrow blast radius, private/local behavior, strong test-selection confidence, easy reversibility, and environment parity; medium risk touches shared/public contracts or multiple consumers, or has moderate reversibility, confidence, or parity; high risk has broad blast radius, shared/public API impact, data/security/migration consequences, difficult rollback, low test-selection confidence, or material parity gaps. Increase targeted and risk-specific evidence as risk rises.

Existing automated browser/E2E tests are ordinary automated validation. Agent-driven interactive browser smoke runs only when explicitly requested by the user or explicitly required by repository/acceptance criteria. If neither applies, do not preflight or run it. Once requested/required, put each scenario's action and expected postcondition in the Plan; the active-host adapter preflights URL, start command/running health, worktree/port, browser surface, authentication/session, test data, side effects, cleanup, and evidence location as soon as known and rechecks immediately before smoke. Use semantic/web-first verification and visual inspection when visual behavior matters. Screenshots show meaningful resulting states and failures by default and supplement assertions. Do not screenshot every click unless explicitly requested. Required smoke affects readiness if it fails or cannot run; optional smoke may be unverified without blocking unaffected implementation.

After review/freeze and any required pre-gate publication, exact-candidate CI observation and independent browser smoke may run concurrently when they test the same immutable candidate and neither depends on the other. If smoke requires a CI-produced preview/deployment, wait for that dependency. Any later tracked source/config mutation creates a new candidate and invalidates affected review plus all candidate-bound broad-gate and smoke evidence; repeat targeted checks, affected-area re-review, and final candidate gates. A final readiness verdict is exactly one of **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**.

## New-Application Intake

For a new application, capture users, outcomes, primary workflows, data/auth/integrations/operations, acceptance criteria, edge cases, and non-goals before the Plan. Keep the smallest architecture and hand off to the normal orchestrated lifecycle.
