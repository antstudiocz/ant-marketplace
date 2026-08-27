---
name: implementation-orchestrator
description: Use for end-to-end implementation work that classifies execution intent, requires repository discovery and a proportional plan before tracked edits, brainstorms new behavior, delegates implementation, review, verification, an execution retrospective, and optional delivery.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

Use this skill for features, fixes, refactors, migrations, and remediation that should end in a verified implementation. For a new application or major app-like surface, start with `ant:create-application` when available and hand the approved brief here.

## Operating Contract

### Roles and authority

- Root is the only role that talks to the user and adjudicates decisions. It inspects repository instructions and git/delivery context, delegates implementation work, integrates reports, resolves decisions, and keeps the user informed.
- Delegated agents never address the user and never draft user-facing questions. They escalate evidence, options, one recommendation, and the exact paused scope to their parent until the escalation reaches root.
- Root makes no tracked implementation edits while this skill is active. If no writer-capable native delegation is available, stop before tracked edits and report the blocker; root never becomes the fallback writer.

### Intake and authorization

- Classify every request at intake as **analysis-only**, **implementation-authorized**, or **ambiguous**:
  - Explicit execution language — fix, implement, change, test — authorizes implementation after discovery and plan presentation, unless the user also asks to propose a plan or wait for approval.
  - Analysis-only stays read-only.
  - Ambiguous: ask early whether the user wants analysis only or implementation too, before deep analysis.
- Every implementation starts with read-only repository discovery and a proportional plan before tracked writes. Always present the plan. Wait for approval only when execution was not already authorized or a safety gate is reached. Proportionality changes depth, never whether discovery and planning happen.
- For a new feature or materially new behavior, complete user-needs brainstorming and deeper technical analysis before preparing the plan. Read-only scouts may run before the execution gate.
- After initial discovery — including its material quality attributes and constraints — and before the concrete plan, make the proportionate implementation-continuity decision: record an existing user choice, skip the question when the modes do not materially differ, otherwise obtain the user's explicit choice. Record the mode and its implications in the plan, native goal, and writer assignment. The lifecycle defines the modes and safeguards.

### Quality and tests

- During read-only discovery, before the continuity decision or concrete plan, derive only the material quality attributes and constraints — for example correctness, maintainability, reliability, performance, scalability, or operability — from repository and user evidence. Record them, with the lighter/heavier rationale, in the Plan and relevant writer/reviewer assignments.
- Choose the smallest durable solution. Never claim performance or scalability without measurements or verified constraints.
- The writer and the independent reviewer both check for expedient hidden debt and for speculative overengineering, abstractions, or dependencies.
- Design changed async or concurrency-sensitive tests deterministically:
  - synchronize on observable events or state; timeouts only bound failure;
  - isolate uniquely owned state; clean up globals, mocks, timers, processes, browser contexts, and database state;
  - prefer virtual time; exercise relevant CI-like concurrency and environment with repeat, shuffle, or seed where supported.
- Retries only classify or diagnose. Never hide a flake with sleeps, inflated timeouts, skipped assertions, or reduced coverage. Heavy performance or fault scenarios may become benchmark, nightly, or manual recommendations while the MR validates the smallest representative invariant.
- Adjacent findings stay separate from the execution retrospective. Report every verified, material, actionable finding discovered naturally — no count cap; group and prioritize when numerous; give evidence/location, impact, and a concise direction with urgency. Fix, or lower/block readiness for, a finding that is a current correctness, requirement, or verification gap; never silently expand scope. Repeated violations may justify recommending a repository lint/ratchet/enforcement — never adding it automatically.

### Planning and delegation

- Use the host's native Plan, Goal, delegation, messaging, and recovery features. The Plan records phases or waves with one top-level `in_progress` item; concurrency is represented by native agent/thread state, not a custom ledger. Never create a custom orchestration runtime, state schema, event log, lease system, migration layer, or generated evaluator.
- For implementation-authorized or later-approved work, establish the host's native Goal after the objective and native Plan are stable and before dispatching a tracked writer. Never create one for analysis-only or unresolved ambiguous work. The Goal records the outcome, acceptance conditions, constraints, checks, and only delivery already authorized; Plan and Goal complement authorization, never replace it. If the active adapter cannot inspect or establish the Goal, fail closed before tracked edits. Close the Goal only after the scoped implementation, required review, final validation, retrospective, and any included delivery are actually complete.
- Keep execution proportional after the execution gate. A small change normally needs one implementation agent plus the required final independent reviewer; add scouts, slices, or specialist review only when scope or risk justifies them. Apply the lifecycle's [Workstream Boundaries](references/lifecycle.md#workstream-boundaries) guidance when shaping or expanding coverage.
- Parallelize backend, frontend, test, research, and implementation workers only when their write scopes are disjoint and shared contracts are stable. One integration lead owns shared files and contracts; do not manufacture parallelism across overlapping scopes.
- Keep root on the active host's strongest capability with the adapter-defined model and reasoning effort for the entire run. If that control is not exposed, use the strongest available root setting and state the limitation without claiming the adapter-defined route.
- Pin every child's native model and, where supported, reasoning effort explicitly through the active host adapter. No child may exceed `High`; never let the adapter-defined root effort leak through inheritance. Give every child and nested child a concise, self-contained assignment with the task-relevant facts — never rely on inherited conversation history. If the host cannot safely enforce the ceiling or isolation, report the limitation and do not dispatch the child.
- Keep routine operational context local to related agents: raw logs, large diffs, debug history, repeated tool calls, and local test failures stay in the repair loop. Send root compact knowledge deltas: outcome, contract changes, new or invalidated facts, evidence location, residual risk, decision needed, and paused scope. Escalate only architecture, scope, public-contract, security, migration, conflicting-capsule, disputed/repeated-failure, or authority decisions.

### Decisions and approvals

- Investigate the root cause before editing. Root resolves decisions first from repository evidence, the stable authorized plan, and prior user decisions.
- Ask the user only when: genuinely new material behavior, scope, or risk remains; an uncovered destructive, external, or delivery action needs authority; or the host presents a real native user-only approval gate. Batch every known necessary decision into one concrete question. An ordinary `yes` or `continue` answers it; never demand exact wording.
- Quality is a hard invariant when routing approvals or recovering from denials. Never weaken architecture, tests, validation, compatibility, or semantics; never add a legacy fallback or hidden workaround merely to avoid an approval. Mechanical patch splitting is allowed only as coherent steps toward the identical intended final result, never to bypass policy.
- Treat user messages during implementation as live input. Status questions and details within authorized behavior do not stop work. Batch related material changes or corrections from the same active segment into one affected-scope discovery, brainstorming, analysis, delta-plan, and approval cycle at the next safe boundary while unaffected work continues; apply urgent stop or safety corrections immediately.

### Validation and completion

- Validate coherent work units with the smallest relevant checks. After the final tracked mutation and required review, run the repository's full suite once on the final tree — not after every edit or task. When delivery is requested, that run is also the final pre-delivery suite.
- Every tracked implementation's final handoff gives exactly one evidence-based readiness verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**. The verdict is a snapshot, never treats unverified prerequisites as satisfied, and never grants merge, release, or deployment authority. Use the lifecycle's thresholds and output contract.
- After the final suite, root performs a bounded retrospective before completion or delivery: observable evidence already available from the run, correctness plus total token/resource efficiency, at most three findings, no reconstructed hidden reasoning or invented usage figures.
- Upstream feedback: turn only a material, actionable, plausibly generalizable process finding into a sanitized candidate. Search the canonical repository's open and closed issues and PRs first, perform at most one feedback action per run, and require explicit current or clearly applicable standing approval for any issue write. Never auto-create a PR from the retrospective.

### Delivery

- Invoke plugin skills through the identifier visible in the active host: Claude Code `/ant:merge-request` or Codex `$merge-request` for every PR/MR creation or update; Claude Code `/ant:delivery-workflows` or Codex `$delivery-workflows` only for merge-conflict resolution.
- When `merge-request` reports an in-scope MR/PR pipeline regression, root owns the bounded repair loop: delegate tracked remediation, targeted validation, independent review, and the required final-suite refresh, then return delivery to `merge-request` for the update and replacement-pipeline observation. Root does not become a tracked writer, and neither does `merge-request`.
- Preserve unrelated user changes and obey repository-specific package, validation, branch, and delivery rules.

## Proportional Flow

1. Classify intake as analysis-only, implementation-authorized, or ambiguous. Do only the minimal inspection needed to route the request and protect unrelated work; for ambiguous intent, ask before substantive or deep discovery.
2. Analysis-only: perform the appropriate read-only investigation and report. Otherwise: inspect repository instructions, git state, the relevant code path, and available validation commands without tracked edits, and derive and record the material quality attributes and constraints during this discovery, before continuity/planning.
3. For new or materially changed behavior, brainstorm the goal, users, workflows, edge cases, non-goals, options, and tradeoffs. Root resolves discoverable decisions and asks one consolidated question for the remaining material user decisions.
4. After the answers, analyze architecture, contracts, data, dependencies, obsolete behavior, risks, and validation more deeply; then make the proportionate implementation-continuity decision.
5. Present a concrete proportional implementation plan, including the selected continuity mode and its implications. If execution was explicitly authorized and the plan stays within the original scope and risk, treat this as a progress checkpoint and continue; otherwise obtain explicit approval. Never dispatch a tracked writer before presenting the plan.
6. Establish or reuse the host-native Goal after the Plan is stable and before tracked-writer dispatch. Record phases/waves in the native Plan with one top-level item `in_progress`, record the expected execution shape under Workstream Boundaries, then dispatch materially distinct work with the adapter's explicit native model and, where supported, effort. Assignments push meaningful checkpoints instead of inviting status polling.
7. Run targeted checks after coherent phases, complete Strong-at-High final code review plus any risk-based specialist review, and fix the root cause of findings.
8. After the final tracked mutation and required review, run one final full validation on the final tree. For executable, runtime, or user-visible changes: discover available host/repository smoke surfaces, offer every applicable surface with exactly one evidence-based recommendation, and let the user choose (honoring an explicit prior tool choice). Run the selected smoke after the final suite; it never replaces automated validation.
9. Perform the bounded root retrospective, correct any current implementation gap, report all verified adjacent findings, and handle at most one qualified upstream feedback candidate within the user's external-write authority; then perform only the delivery actions the user requested.

Scope boundaries for this flow:

- A tiny mechanical change inside an already approved or otherwise authorized plan may use a compact discovery-and-plan cycle without duplicate approval.
- A concrete user plan or an approved `create-application` brief may satisfy earlier product brainstorming after repository verification, but neither alone grants implementation authorization. An explicit end-to-end execution request can grant it after plan presentation.
- Approval or authorization covers only the stable plan or workstream — not delivery, and not every implementation phase.

### Practical Shapes

- **Simple:** root discovery → proportional native Plan → native Goal → one balanced implementer performs focused investigation, implementation, and targeted tests → independent Strong-at-High review → final validation, retrospective, and authorized delivery.
- **Larger or ambiguous:** root runs parallel Fast/Balanced scouts → stabilizes contracts and a workstream wave → a balanced integration lead coordinates disjoint backend, frontend, test, and research/implementation workers → related agents run peer repair loops and return compact knowledge deltas → independent Strong-at-High review → final suite, retrospective, and authorized delivery.

An implementer normally owns focused local investigation and targeted tests. Use separate scouts for broad, ambiguous, or cross-cutting discovery. Where native delegation allows, an implementer may spawn a disjoint helper or reviewer, but every completed implementation still receives independent Strong-at-High final review, and that reviewer must not be the implementer.

## Reference Loading

Classify intake and complete only the minimal read-only discovery needed to route the request and protect unrelated work before loading orchestrator references. Then load references by actual need, not by the broad analysis-only label:

- Keep both the lifecycle and host adapter unloaded during unresolved ambiguous intake.
- Read `references/lifecycle.md` before any continuity decision or concrete implementation plan, including a plan-only request that defers write authorization. Also read it before delegated analysis, because it owns the shared delegation safeguards.
- For a root-owned analysis, explanation, or report that neither prepares an implementation plan nor delegates, load neither reference.
- Load exactly one active-host adapter — `references/codex.md` in Codex or `references/claude.md` in Claude Code — only immediately before the first host-specific native-goal, delegation, or model/effort decision. Planning alone never requires the adapter.
- Never load the inactive adapter or additional orchestrator role cards, templates, contracts, or evaluators.

## Completion

Finish with a concise summary containing:

- outcome and changed areas;
- material quality attributes and checks run;
- smoke choice and evidence, or the N/A reason;
- all verified adjacent findings and anything not verified;
- retrospective outcome and any material upstream feedback URL, candidate, or blocker;
- delivery state;
- exactly one lifecycle-defined readiness verdict qualifying any completion claim.

Do not claim success from an agent report alone; confirm it against the final repository state and validation evidence.
