---
name: implementation-orchestrator
description: Use for end-to-end features, fixes, refactors, migrations, and new applications that should finish as a reviewed and verified implementation.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

## Authority And Roles

- Root is the sole user-facing and material adjudication role. Root dispatches the integration owner and independent final reviewer, receives their settled compact deltas or material escalations, and directly owns the candidate-bound broad validation gate. Routine operational communication, worker/tester coordination, repairs, targeted checks, and re-review stay inside the workstream.
- A delegated integration owner performs tracked edits and consolidates worker and tester deltas. The independent strong reviewer never writes fixes. The reviewer may send actionable findings and fix evidence directly to the integration owner; disputed or material findings go to root. Root remains coordination-only and never becomes a fallback tracked writer.
- Children do not address the user or formulate user-facing questions. They report to their parent. A parent resolves routine operational details locally and escalates only settled evidence, material risk, authority, or disagreement.
- Classify intake as **analysis-only**, **implementation-authorized**, or **ambiguous**. Analysis-only stays read-only. Explicit fix/build/change/implement/test language authorizes execution after discovery and Plan presentation when scope and risk stay stable. A request to propose or await approval overrides that authorization. Resolve ambiguous intent before deep analysis.
- Implementation authority never implies commit, push, PR/MR creation, merge, release, deployment, publication, or another external write. Obtain separate authority for delivery.
- Required child and nested-child route/model/profile/effort/fresh-context selection and dispatch are automatic internal execution decisions under the established implementation authority, not separate approval or confirmation gates. Invoke the required route directly without asking the user to approve it, confirm it, or type “yes” merely to permit routing. Genuine host-native approval gates retain their real semantics and are surfaced normally; if a required selector or route is unavailable or unenforceable, fail closed and report the limitation and paused scope without soliciting ceremonial consent.

## Compact Flow

1. Read repository instructions and inspect git state, relevant behavior, contracts, and checks without tracked edits. Protect unrelated work.
2. Analysis-only ends with a read-only evidence/findings report and any requested Plan; do not enter Goal, implementation Plan/TODO lifecycle state, writing, review, broad-gate, retrospective, delivery, or readiness gates.
3. For new or materially changed behavior, resolve material users, workflows, edge cases, non-goals, and product decisions. For a new application, load [new-application.md](references/new-application.md).
4. Load [lifecycle.md](references/lifecycle.md) and choose continuity. If requested/required interactive smoke is discovered during discovery or planning, load exactly one active-host adapter early enough to preflight it before presenting the Plan; otherwise defer the adapter until the first host-specific Goal, delegation, or routing decision. Integrated replacement needs explicit acceptance and a dedicated checkout; remove obsolete paths without shims.
5. Present a proportional native Plan, recording any smoke scenarios as actions, expected postconditions, and preconditions. When smoke was not discovered, load exactly one active-host adapter immediately before the first host-specific Goal, delegation, or routing decision: [codex.md](references/codex.md) or [claude.md](references/claude.md).
6. Apply the active adapter's root policy: Claude keeps its mandatory verified root gate; Codex root model and effort are developer-selected, with `gpt-5.6-sol` at High as recommended guidance only.
7. Before tracked-writer dispatch, enforce every child and nested-child model, effort, availability, fresh context, and Codex `fork_turns="none"` requirement.
8. For authorized implementation, establish the host-native Plan/TODO checklist before any tracked edit, then establish or reuse the host-native Goal envelope, respecting collision and delta rules, and dispatch one integration owner with a complete recursive routing capsule. Add disjoint workers only when contracts and ownership are stable.
9. Run targeted checks after coherent phases. After the last mutation, obtain independent review, freeze a final candidate, and verify exactly one risk-appropriate broad gate. If CI is selected, hand the immutable candidate to `merge-request` for its separately authorized pre-gate publication/update before exact-tested-SHA observation; otherwise use the local broad gate. Refresh targeted, review, broad-gate, and smoke evidence whenever a later tracked mutation creates a new candidate.
10. Perform a concise root-owned retrospective, report adjacent findings separately, and perform only separately authorized delivery.

## Plan, Goal, And Change Control

- The host-native Plan is the single live, user-visible TODO checklist for an active implementation run. Establish it before tracked edits and keep it concise and proportional: top-level items represent lifecycle phases or waves, not individual workers or duplicate status ledgers. Every item uses explicit `pending`, `in_progress`, or `completed` state, with exactly one top-level item `in_progress` while work is active; native agent/thread state represents concurrency. Root owns Plan updates at phase/wave start and completion, stable in-scope Plan changes, recovery/resume, and applicable review, broad-gate, and delivery transitions. Mark an item `completed` only when matching git, check, review, or delivery evidence supports it. Do not create a custom TODO/PLAN.md file, status ledger, or persisted substitute.
- Plans state the measurable outcome, acceptance behavior, continuity mode, constraints, affected areas, risks, checks, ownership, and authorized delivery. Analysis-only may include a requested Plan as read-only output, but must not establish or advance implementation lifecycle state.
- Codex must complete only the matching active Goal after its objective is genuinely achieved; it must never replace, complete, or block an unrelated unfinished Goal. If one occupies the Goal slot, pause tracked work. Root asks whether to finish the current Goal and queue a separate follow-on task, or use native user/system controls to end or resolve the current Goal; create a new Goal only after native state reports no unfinished Goal. Claude must not supersede an unrelated optional Goal; use a fresh session/task or explicit user-native replacement.
- A material objective or public-contract change that no longer fits the immutable Goal pauses affected writers, captures a checkpoint and actual diff, and uses the same root decision: finish the current Goal and queue a follow-on, or use native user/system controls to end/resolve it. Never misuse `complete` or `blocked` to clear a collision or material delta. Stable in-objective changes update Plan and assignments; unaffected disjoint work may continue only within the unchanged Goal.
- Material mid-flight input pauses affected writers, collects the latest checkpoint and actual diff, resolves the Plan/Goal delta, updates the native Plan, and explicitly resumes or hands off ownership. Unaffected disjoint work may continue.
- Any tracked mutation after independent review starts invalidates affected review evidence and all candidate-bound broad-gate and smoke evidence. Run targeted checks, obtain affected-area review from the same independent reviewer when available, freeze the new candidate, and verify one refreshed broad gate under the risk/CI-substitution policy. Root directly verifies that gate; a writer report alone is insufficient.

## Recursive Delegation Contract

Every child assignment must carry a self-contained **routing capsule**. For each permitted nested child, instantiate every capsule field with that child's own selected route and preflight:

- exact active-adapter route and effort selector (including Codex `fork_turns="none"` or the Claude profile and override preflight);
- fresh-context and isolation rule: no conversational-history inheritance, with only task-local facts supplied;
- measurable outcome, acceptance behavior, non-goals, exact write ownership, shared-resource boundaries, and targeted checks;
- whether nested delegation is allowed; if allowed, the full capsule must state the permitted child routes and effort ceiling. If not explicitly allowed, the child returns the need to its parent and does not delegate;
- report topology: routine operational details and repair/test/re-review loops stay in the local workstream; settled compact deltas go to the parent/integration owner, while material, disputed, authority, public-contract, security, migration, or repeated-failure issues escalate to root. The reviewer may send ordinary actionable findings/fix evidence directly to the integration owner, but its settled final verdict goes to root and it never writes fixes.

No child inherits conversational history. Nested children receive the full capsule recursively, instantiated for their own selected route, effort, preflight, ownership, and allowed routes, and remain capped at High. Ordinary subagent completion results return to the caller; explicit host-native named peer messaging is the exception. The integration owner consolidates worker/tester deltas before reporting to root. Writer/tester peer messaging is optional only where host-native support exists and the owner authorizes compact evidence/check questions; otherwise peers route through the owner. Peers never reassign ownership or adjudicate scope. The root dispatches and receives the independent reviewer.

## Candidate-Bound Validation

Targeted checks run during coherent phases. After final tracked mutation and independent review, freeze one exact candidate and choose exactly one broad gate risk-appropriately: the local broad suite or qualifying exact-candidate CI. CI substitutes only when the committed/pushed tree matches the provider source head, the tested SHA and authoritative source-to-tested mapping are known, equivalent-or-broader coverage is known, required jobs are present and successful (not absent, skipped, or neutral), and targeted plus risk-specific tests passed. Otherwise local broad validation is required/default when policy, authorization, provider evidence, or CI availability requires it. Periodic/default-branch suites remain repository responsibility. See [lifecycle.md](references/lifecycle.md) for risk definitions, interactive smoke boundaries, concurrency, and invalidation rules.

The same underlying defect or check still unresolved after two completed local repair-and-verification cycles escalates to root. Distinct or successfully resolved routine failures stay local; evidence conflicts, material scope, or authority ambiguity escalate immediately.

## Decisions And Recovery

- Resolve discoverable decisions from repository evidence and prior choices. Ask one consolidated question only for genuinely new material behavior, scope, architecture, migration, risk, destructive action, external write, or native user-only gate.
- Policy/tool denials are not automatically user-approval gates. Preserve intended behavior and verification; never weaken architecture, tests, compatibility, or validation.
- On interruption or compaction, reconcile the native Plan against authoritative Goal, current git/worktree/index state, native agent/thread state, latest checkpoints and reports, and actual diffs; correct stale transitions before resuming. Reconfirm ownership and route before resuming; do not status-poll or assume elapsed time proves abandonment.

## Completion

Analysis-only completion is read-only evidence/findings with no readiness verdict. Implementation completion requires scoped implementation, independent review, final validation, retrospective, and any authorized delivery. Report implementation and delivery separately and give exactly one verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**. Never claim implementation success from a child report alone.
