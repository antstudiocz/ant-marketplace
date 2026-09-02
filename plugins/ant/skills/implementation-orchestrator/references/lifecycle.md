# Implementation Lifecycle

This reference owns the shared implementation lifecycle. Apply repository instructions first and keep depth proportional to risk and novelty. The durable plan is human-readable Markdown tracked in Git; it is coordination evidence, not a runtime, ledger, event log, or machine state store.

## 1. Discovery And Durable Planning

- Before tracked edits, read repository instructions and inspect branch/worktree/index state, contracts, risks, and checks without editing. Separate unrelated changes.
- For new or materially changed behavior, discover repository facts first. Root asks the user every material question that cannot be answered from the repository or environment, grouping questions into digestible rounds and continuing until every material non-repo-discoverable decision is resolved; never silently choose a product, architecture, compatibility, security, migration, or delivery decision.
- Classify intent as analysis-only, implementation-authorized, or ambiguous. Analysis-only work remains read-only and does not establish or advance implementation lifecycle state.
- Resolve the material decisions needed to proceed, then present a concise chat plan and create one stable durable plan bundle at `docs/implementation-plans/YYYY/MM/<slug>/README.md`. The README is the sole entrypoint. For substantial work, add `specification.md`, `decisions.md`, `implementation.md`, and `progress.md`; collapse proportionally for small work but keep the README.
- The bundle records scope, users/workflows where applicable, acceptance, non-goals, continuity mode, repository findings/analysis, material decisions and rationale/open questions, ownership, risks, checks, candidate/freeze rules, current phase, stable status, and a `Resume from here` exact next action. Use proportionate statuses: `specifying`, `ready`, `in_progress`, `blocked`, `completed`, or `superseded`. Supporting documents are complementary and must not compete with the README.
- Root exclusively writes plan files, progress/checkpoints, and stable plan deltas. This plan-file authority is limited to the planning bundle and never authorizes product implementation or delivery. Child writers may read the plan directory but cannot edit it.
- A plan must exist and be complete for the current material decisions before dispatch. A missing, stale, conflicting, or unresolved material decision blocks affected tracked work and is escalated to root/user. Analysis-only work remains read-only and does not create or update a plan.
- Root updates the bundle at decision resolution, phase start, phase completion, stable in-objective delta, recovery/resume, review readiness, and immediately before candidate freeze. Do not edit the tracked plan after freeze merely to log CI or final-gate results; report terminal evidence in chat and close the Codex Goal or optional native Goal confirmed in use, when applicable.

## 2. Continuity And Replacement

Choose after discovery and before implementation:

- **In-place evolution:** preserve compatible paths and migrate incrementally when shared state or rollout requires it.
- **Integrated replacement:** cleanly replace obsolete behavior in a dedicated checkout after explicit acceptance; remove superseded paths and documentation without a compatibility shim.
- **Isolated handoff:** prepare an artifact or separate workspace when direct integration is out of scope.

Record the mode and implications in the durable plan, in the Goal objective when Codex or an opted-in native Goal is in use, and in the integration-owner capsule. Integrated replacement requires explicit acceptance and a dedicated checkout.

## 3. Goal Envelope And Ownership

- Codex requires a native Goal as the second lifecycle gate after durable-plan verification. The Goal has a stable measurable objective and includes the repo-relative plan README path. Codex tools currently expose Goal creation/reading and terminal `complete`/`blocked` closure, not explicit step mutation; never simulate progress with terminal closure.
- The active adapter owns Goal inspection, reuse/creation, reinspection, evidence, collision handling, and closure when a Goal is required or explicitly in use. Claude Goal support remains optional and never blocks work when absent.
- For Codex, reuse a matching active Goal or create and reinspect one when the slot is empty. For Claude, apply these continuity rules only when the adapter has inspected and confirmed that its optional native Goal is in use. Missing, mismatched, unavailable, or unverifiable required Goal state fails closed.
- Never replace, complete, or block an unrelated unfinished Goal when a Goal is required or in use. Pause and ask root/user whether to finish it and queue a follow-on, or use native controls to end or resolve it. A material objective/public-contract delta uses the same choice.
- Stable in-objective deltas update the durable plan and assignments while preserving the matching Goal objective when one is in use. The Goal objective and plan must not drift: if the outcome or public contract changes materially, pause affected work and resolve the Goal before resuming.
- An adapter may support nonterminal Goal checkpoint synchronization only after inspecting and confirming a dedicated step/checkpoint mutation. When confirmed, root mirrors phase checkpoints there; absent or unsupported mutation never blocks work because the durable plan remains authoritative. Codex `complete`/`blocked` are terminal only; `blocked` obeys host repeated-blocker semantics. Never simulate progress or clear collisions with terminal closure.
- Exactly one integration owner owns shared implementation contracts and scoped source/config/test/general-document edits. Root adjudicates and verifies but does not become a fallback implementation writer.

## 4. Recursive Routing Capsule

Every child assignment, including every permitted nested child, carries:

1. the exact active-adapter model/profile and effort selector, with Codex `fork_turns="none"`;
2. fresh isolated task-local context with no conversational-history inheritance;
3. measurable outcome, acceptance behavior, non-goals, exact write ownership, shared-resource boundaries, and targeted checks;
4. explicit nested-delegation permission. If yes, list allowed routes and effort ceiling and require the same complete capsule recursively; if no or absent, the child must return the need to its parent and not delegate;
5. reporting topology: routine operations and repair/test/re-review stay local, settled compact deltas return to the parent/integration owner, and material/disputed/authority/public-contract/security/migration/repeated-failure issues escalate to root.

The capsule must explicitly mark the plan directory as root-only for writes and read-only for children. Children never address the user or formulate user-facing questions. Every child remains capped at High and the active adapter must fail closed if route, effort, availability, isolation, or fresh context cannot be enforced.

## 5. Execution And Checkpoints

- After the durable-plan gate and, for Codex or an opted-in native Goal, its matching Goal gate pass, dispatch the integration owner and any disjoint workers. Required route selection is an internal execution decision, not a user confirmation gate; genuine host-native approvals retain their semantics.
- Native agent/thread state is concurrency truth. The durable plan records phase-level status and decisions, not individual worker status. Root keeps one current phase and updates the bundle at the checkpoints in Section 1.
- Children read the current plan before work and return a checkpoint report with: phase/status; files or areas inspected/changed; validation run and result; discoveries/decisions; proposed plan delta; and risks/blockers. The report is evidence for the parent, not a plan edit or readiness verdict.
- If a writer is silent or interrupted, root/integration owner recovers the latest report, inspects actual worktree/index/diff, and reassigns overlap only after the writer is known stopped or ownership is explicitly handed off. Elapsed time does not prove abandonment.
- The same underlying defect or check unresolved after two completed local repair-and-verification cycles escalates to root. Evidence conflicts, material scope, authority, or security ambiguity escalates immediately.

## 6. Review, Freeze, And Candidate-Bound Validation

- Root records review readiness in the durable plan before independent review. The reviewer is strong at High, separate from all writers, and never repairs code. Actionable findings go to the integration owner; the settled verdict goes to root.
- After review starts, any tracked mutation invalidates affected review and candidate-bound validation evidence. Repair findings, rerun targeted checks, obtain affected-area re-review, update the plan checkpoint, and proceed toward a new freeze.
- Immediately before freeze, root writes the final plan checkpoint and identifies one immutable candidate (exact tree/SHA). Freeze means no later plan edit or implementation mutation for that candidate. A later tracked plan/source/config edit creates a new candidate and invalidates affected evidence.
- Select the single broad final gate by assessing blast radius, reversibility, test-selection confidence, and environment parity. Narrow blast radius, easy rollback, high confidence, and strong parity may use the smallest qualifying gate; shared/public impact, difficult rollback, low confidence, or parity gaps require broader or risk-specific evidence. Use the local broad suite when qualifying CI is unavailable or publication authority is absent; otherwise choose either local broad suite or qualifying exact-candidate CI, never duplicate equivalent gates.
- CI may substitute only when the committed/pushed candidate matches the provider head, tested SHA and source-to-tested mapping are authoritative, coverage is equivalent or broader, required jobs are present and successful, and targeted/risk-specific checks passed. Missing, skipped, neutral, timed-out, mismatched, or incomplete CI is unverified.
- CI publication, commit, push, and provider updates remain separately authorized and belong to `merge-request`; implementation readiness never implies delivery. A final-gate result is terminal evidence, not a reason to mutate the frozen plan.
- Existing automated browser/E2E tests are ordinary risk-based validation. Any side-effecting or agent-driven interactive smoke runs only when explicitly requested or required by repository/acceptance criteria; if so, the active adapter preflights environment, browser, auth, data, side effects, cleanup, and evidence and records scenarios with expected postconditions. Required smoke affects readiness; optional smoke does not block unaffected work.

## 7. Interruption And Compaction Recovery

Root reconciles the durable plan against Codex Goal state, or optional native Goal state when the active adapter confirms it is in use, plus git/worktree/index state, native agent/thread state, child checkpoints, reviewer findings, and actual diffs. Correct stale phase status or unsupported assumptions, preserve one active phase, confirm plan-directory write ownership, route, Goal ownership when applicable, review validity, and next action, then update `progress.md` before resuming. Do not treat stale reports as current truth or poll unchanged status repeatedly.

## 8. Completion

Root verifies the selected broad gate and applicable smoke evidence directly, records the retrospective and adjacent findings, and closes the Codex Goal, or optional native Goal when in use, only with its terminal semantics. Give exactly one verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**. Implementation and delivery remain separate.

## 9. Optional Delivery

Delivery is separately authorized and belongs to `merge-request`, which owns PR/MR preview/create/update, Observe/status, conflict resolution, scoped commit/push, and exact-head observation. Never infer merge, release, deployment, tag, publication, rebase, force-push, reset, or history-rewrite authority.
