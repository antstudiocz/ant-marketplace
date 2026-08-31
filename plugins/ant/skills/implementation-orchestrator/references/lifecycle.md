# Implementation Lifecycle

This reference owns the shared implementation lifecycle. Apply repository instructions first and keep depth proportional to risk and novelty.

## 1. Discovery And Planning

Before tracked edits, read repository instructions, inspect branch/worktree state, separate unrelated changes, trace contracts and checks, diagnose the actual cause, and establish a concise, proportional native Plan as the single live, user-visible TODO checklist. Top-level items represent phases or waves, use explicit `pending`, `in_progress`, and `completed` transitions, and have exactly one top-level item `in_progress` while implementation work is active. Do not mirror it in a custom TODO/PLAN.md file, status ledger, or persisted substitute. New behavior also needs users, workflows, edge cases, acceptance criteria, and non-goals. A user plan is product input, not automatic write authority; explicit implementation intent authorizes execution after the Plan checkpoint when scope and risk remain stable. Analysis-only may present a requested Plan as read-only output but does not establish or advance implementation lifecycle state.

## 2. Implementation Continuity

Choose after discovery and before the concrete Plan:

- **In-place evolution:** preserve compatible paths and migrate incrementally when shared state or rollout requires it.
- **Integrated replacement:** cleanly replace obsolete behavior in a dedicated checkout after explicit acceptance; remove old paths without fallback shims.
- **Isolated handoff:** prepare an artifact or separate workspace when direct integration is out of scope.

Record the mode and implications in the native Plan, Goal envelope, and integration-owner assignment. Do not ask ceremonially when modes have no material difference.

## 3. Goal Envelope And Ownership

The active host adapter owns native Goal creation/reuse, availability behavior, mutability, and closure. Create or reuse a matching Goal only after objective and Plan are stable and before tracked-writer dispatch when the adapter requires or supports it. The envelope records measurable outcome, acceptance, constraints, checks, continuity, ownership, and delivery already authorized.

Codex never replaces, completes, or blocks an unrelated unfinished Goal. If one occupies the slot, pause tracked work. Root must ask whether to finish the current Goal and queue a separate follow-on task, or use native user/system controls to end or resolve the current Goal; create a new Goal only after native state reports no unfinished Goal. Claude never supersedes an unrelated optional Goal; use a fresh session/task or explicit user-native replacement. A material objective/public-contract change that no longer fits the immutable Goal pauses affected writers, checkpoints the actual diff, and requires the same root decision: finish and queue a follow-on, or use native controls to end/resolve the current Goal. Never misuse `complete` or `blocked`. Stable in-objective changes update Plan and assignments.

Exactly one integration owner owns shared contracts and shared files. Root adjudicates and verifies but never becomes the fallback writer. The integration owner consolidates worker/tester deltas and keeps routine operations local.

## 4. Recursive Delegation And Communication

Every child assignment carries a complete recursive **routing capsule**:

1. exact active-adapter route and effort selector;
2. fresh-context/isolation rule: no conversational-history inheritance;
3. outcome, acceptance behavior, non-goals, exact write ownership, shared boundaries, and checks;
4. whether nested delegation is allowed; if allowed, permitted nested routes, effort ceiling, and a full capsule instantiated with each nested child's own selected route and preflight;
5. report/escalation topology: routine communication and repair/test/re-review loops stay in the local workstream, settled compact deltas go to the parent/integration owner, and material/disputed/authority/public-contract/security/migration/repeated-failure issues go to root.

Children that lack explicit nested-delegation permission return the need to their parent and do not delegate. Nested children receive the full capsule recursively, instantiated with their own route, effort, ownership, and preflight; they remain capped at High and never inherit conversational history. Root dispatches and receives the independent final reviewer. That reviewer may send ordinary actionable findings and fix evidence directly to the integration owner, but the settled final reviewer verdict goes to root; disputed or material findings escalate to root. Children never address the user.

Ordinary subagent completion results return to the caller; explicit host-native named peer messaging is the exception. Writer/tester peer messaging is optional only where the host natively supports it and the integration owner authorizes compact evidence or check questions. Otherwise peers route through the owner. Peers never reassign ownership or adjudicate scope. If a host cannot verify the planned nested-child capability, the integration owner handles its scope sequentially and raw reports are not flattened through root.

## 5. Execution And Mid-flight Changes

The integration owner verifies the native Plan against the real tree, preserves unrelated work, and reports settled phase/wave evidence and any stable Plan delta to root. Root keeps the Plan as the live checklist and updates it at phase/wave start and completion, stable in-scope Plan changes, recovery/resume, and applicable review, final-suite, and delivery transitions. Top-level Plan items never duplicate individual worker status; native agent/thread state remains the concurrency source. A material mid-flight change pauses affected writers, collects a checkpoint and actual diff, resolves the Plan/Goal delta, updates the Plan, then explicitly resumes or hands off ownership. Unaffected disjoint work may continue. Status questions and stable details do not pause work; urgent stop or safety corrections apply immediately.

If a writer is silent or interrupted, recover the latest checkpoint, inspect actual git/worktree state and diff, and reassign overlap only after the writer is known stopped or ownership is explicitly handed off. Elapsed time never proves abandonment. The same underlying defect or check still unresolved after two completed local repair-and-verification cycles escalates to root; distinct or successfully resolved routine failures stay local. Evidence conflicts, material scope, or authority ambiguity escalate immediately.

## 6. Review Invalidation And Validation

After independent review starts, any tracked mutation invalidates affected review evidence and any final-suite result. Repair material findings with targeted checks, obtain affected-area review from the same independent reviewer when available, and run one refreshed final suite. The independent reviewer is strong at High, separate from all writers, and never repairs code. Root owns and directly verifies/observes the final-suite gate; writer reports are evidence but not proof.

Classify failed checks as current-change, pre-existing, flaky/infrastructure, credentials, or external state. Retries diagnose only. Smoke is proportional and supplements automated checks.

## 7. Interruption And Compaction Recovery

Root reconciles the native Plan before resuming: compare its transitions and next phase against authoritative Goal state, git/worktree/index state, native agent/thread state, integration-owner checkpoints, worker/tester reports, reviewer findings, and actual diffs. Correct stale or unsupported Plan states, preserve exactly one active top-level phase/wave, and only mark a phase/wave completed when matching evidence exists. Reconfirm route, Goal ownership, write ownership, review validity, and the next Plan phase before resuming. Do not poll status repeatedly or treat stale reports as current state.

## 8. Completion

After final edits and required re-review, run the repository-wide suite once on the final tree. Root performs a bounded evidence-based retrospective, reports adjacent findings separately, and gives exactly one verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**. Implementation and delivery remain separate; passing checks never implies commit, push, merge, release, or deployment.

## 9. Optional Delivery

Delivery is separately authorized and belongs to `merge-request`, which owns PR/MR preview/create/update, Observe/status, conflict resolution, scoped commit/push, and exact-head observation. Do not infer merge, release, deployment, tag, publication, rebase, force-push, reset, or history-rewrite authority.
