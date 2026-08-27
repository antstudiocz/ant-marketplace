# Implementation Lifecycle

This is the orchestrator's shared internal reference. Apply it with repository instructions, and load exactly one active-host adapter only when `SKILL.md` Reference Loading reaches a host-specific native-goal, delegation, or model/effort decision.

## 1. Discover, Classify, Brainstorm, And Plan

Every implementation has a pre-write discovery and planning cycle. Keep it compact for a tiny mechanical change and thorough for new, broad, ambiguous, or risky work; never remove it entirely. Plan presentation always precedes tracked edits. Whether it also pauses execution depends on the user's intent and the resulting scope and risk.

Classify the request at intake, before substantive or deep analysis:

- **Analysis-only:** the user asks to inspect, diagnose, explain, review, audit, or propose without asking for execution. Stay read-only; report evidence, options, and any recommended next step.
- **Implementation-authorized:** the user explicitly asks to fix, implement, change, build, test, or otherwise carry work through execution. This authorizes implementation after discovery and plan presentation — not delivery or external writes.
- **Ambiguous:** it is genuinely unclear which of the two the user wants. Ask early. Minimal repository inspection needed to route the request is allowed; deep analysis is not.

Overrides:

- An explicit request to propose a plan, wait for approval, or otherwise defer execution overrides implementation authorization and requires a pause.
- Never infer authorization from a product brief, a concrete plan, or a request that merely names an implementation topic.

Before any tracked edit or tracked-writer dispatch:

1. Read repository instructions; do only the minimal inspection needed to classify intent and protect unrelated work.
2. Classify the intent (analysis-only / implementation-authorized / ambiguous). For ambiguity, ask the user before substantive analysis.
3. Separate in-scope changes from unrelated dirty files. Inspect the current branch, relevant diff, code path, behavior, contracts, and validation commands — directly or via read-only scouts. Do not ask the user for facts discoverable safely from the repository or environment.
4. Classify the work: tiny mechanical change, work covered by an already approved or authorized plan, or new/materially changed behavior.

Then follow the matching path:

- **Analysis-only:** stop after the appropriate read-only discovery and report.
- **Ambiguous:** resolve the intended mode before substantive analysis.
- **Fix, refactor, migration, or remediation without materially new behavior:** state the verified goal or root cause, acceptance behavior, affected areas, implementation steps, risks, checks, and expected execution shape in a proportional plan. Continue into tracked implementation after presenting it only when execution was explicitly authorized and it stays within the original scope and risk; otherwise obtain explicit approval.
- **New feature or materially new behavior:** continue in this order:
  1. Brainstorm with the user: goal, users, desired workflow, edge cases, non-goals, options, tradeoffs.
  2. Ask every unresolved question whose answer materially changes behavior, scope, architecture, data, safety, validation, or delivery. Group questions clearly; do not impose an arbitrary count.
  3. After the answers, inspect architecture, contracts, data flows, dependencies, obsolete or legacy behavior, risks, and validation paths in greater depth.
  4. Present a concrete plan: acceptance behavior, affected areas, key decisions, implementation sequence, validation, risks, explicit non-goals, and the expected execution shape.
  5. Present the plan before dispatching a tracked writer or making tracked edits. When execution was explicitly authorized and the plan stays within the user's original scope and risk, continue without another confirmation; otherwise obtain explicit approval.

Read-only scouts may run before the execution gate. They return evidence and options, never implementation changes. Approval or authorization applies to the stable plan or workstream, so do not re-ask before every phase. Re-ask only when a material discovery invalidates the plan or changes behavior, architecture, data, safety/risk, or scope, or when a destructive action is required.

### Proportional engineering quality

During read-only discovery, before the continuity decision or concrete plan:

1. Derive the material quality attributes and constraints from repository and user evidence — not from a fixed checklist. Consider correctness, maintainability, reliability, performance, scalability, operability, security, accessibility, or compatibility only when the task makes them relevant.
2. Record the resulting attributes and the rationale for a lighter or heavier option in the Plan and relevant writer/reviewer assignments.
3. Select the smallest durable solution that fits the verified constraints.
4. Never claim performance or scalability improvements without measurements or verified workload, latency, volume, or availability constraints.

The implementation owner and independent reviewer both look for expedient shortcuts and hidden debt as well as speculative overengineering, unneeded abstractions, and unnecessary dependencies.

### Deterministic test design

For authored or changed tests involving asynchronous work or concurrency, the plan and test review require:

- synchronization on observable events or state, with timeouts used only as failure bounds;
- uniquely owned test data/state, and cleanup of configuration, globals, mocks, timers, processes, browser contexts, and database state;
- virtual time where the behavior permits it, and CI-like concurrency/environment coverage when those conditions matter;
- repeat, shuffle, or seed controls where the test runner supports them; retries only diagnose or classify a failure, never serve as acceptance evidence.

Never repair a flake with sleeps, inflated timeouts, skipped or weakened assertions, reduced meaningful coverage, or suppressed failures. A heavy performance or fault scenario may be recommended for benchmark, nightly, or manual execution while the merge request validates the smallest representative invariant. If repeated violations are evidenced, report a repository-level lint, ratchet, or enforcement recommendation as an adjacent improvement; never add enforcement automatically or expand the workstream without authority.

Scope boundaries:

- A tiny mechanical change inside an already approved or authorized plan may use a compact cycle: verify the affected code, state the small delta and checks, continue without duplicate approval.
- A concrete plan supplied by the user, or an approved `create-application` brief, may satisfy earlier product brainstorming once repository facts are verified — it is not implementation authorization. A separate explicit end-to-end implementation request can provide that authorization after plan presentation.
- Implementation authorization does not remove the mandatory plan checkpoint or authorize a materially expanded plan.
- Approval covers only the scoped repository edits required by the plan. It does not independently authorize destructive operations, force-pushes, merges, releases, or unrelated cleanup.
- An explicit create/update PR/MR request carries only the limited chain defined by `merge-request`: scoped commit, push, new-request Draft-by-default creation, ordinary-update readiness preservation, and pipeline observation. Respect any narrower repository or host permission boundary.

### Workstream Boundaries

- Record each workstream's expected execution shape and proportional delegation budget in the native Plan: roles, boundaries, and likely concurrent coverage needed for its acceptance criteria.
- The Plan expresses phases or waves and keeps one top-level item `in_progress`. Actual concurrency is represented by native agent/thread state, not extra plan items or custom state.
- Before adding coverage: first reuse an active agent whose assignment still fits, or retire coverage that no longer does. Add a distinct role only when its evidence, write scope, or review focus is materially different, and record that reason in the native Plan. This adjustment needs no user approval unless it materially changes the workstream's scope or risk.

For a materially separate follow-up, distinguish an additive workstream from a replacement or reset:

- **Additive:** preserves unaffected active agents and their goal envelopes.
- **Replacement or reset:** allowed only at a terminal boundary of the prior workstream and native goal. At that boundary: stop or recover only agents assigned to the replaced workstream, inspect their checkpoints and actual diffs, verify correct task and worktree ownership before reassignment, then run fresh proportional discovery and planning and establish or reuse a matching native goal only through the active-host adapter.
- **In-flight materially separate replacement:** follow Mid-flight User Messages — stop or recover only affected work, preserve unaffected agents, inspect the checkpoint and diff, and defer a fresh tracked workstream when the adapter exposes no legitimate cancel, replace, or terminal transition.
- Do not force a separate host-level conversation or invent persisted orchestration state merely to mark the boundary.

Implementing and testing code for future production behavior is not deploying, publishing, releasing, running a production operation, or causing an external side effect. The former is covered by implementation authorization inside the stable plan; the latter requires the corresponding delivery or external-action authority.

### Decision And Approval Routing

Root is the only role that communicates with the user, formulates user-facing questions, or adjudicates approval. A delegated scout, writer, slice worker, reviewer, validator, or delivery helper never asks the user directly and never drafts a question for the user to relay. When it cannot safely continue, it returns one escalation packet to its parent containing:

- repository or host evidence and the unresolved decision;
- viable options and tradeoffs;
- its recommendation;
- the exact affected scope paused while unaffected authorized work continues.

Nested parents resolve what they can from their assignment and pass the remainder upward in the same form until it reaches root.

Root resolves in this order:

1. Repository evidence, the stable authorized plan, and prior user decisions.
2. Ask the user only for: genuinely new material behavior, scope, or risk; an uncovered destructive, external, or delivery action; or a real native user-only host approval.
3. Consolidate every known necessary user decision into one concrete question. An immediate ordinary `yes`, `continue`, or equivalent unambiguous confirmation is sufficient; never require ritual wording.

Keep workflow approval distinct from host execution policy:

- A declined patch, `fileChange`, or policy classification is not by itself a native user-only approval gate and does not justify asking the user to repeat approval.
- Resolve a safe in-policy execution path that produces the identical planned result, or return the full escalation packet to the parent for escalation to root.
- Mechanical patch splitting is permitted only when the pieces are coherent implementation steps toward that identical final result; never split work to evade policy classification.

Quality is invariant across every resolution path. Never choose weaker architecture, reduced tests or validation, a legacy fallback, a hidden workaround, or any semantic compromise to avoid an approval. If the correct solution genuinely requires new authority, root asks once rather than degrading the result.

### Implementation Continuity

After initial read-only discovery and before the concrete plan or any tracked write, decide whether the task materially differs under these modes:

- **Incrementally verifiable:** each coherent checkpoint leaves the affected system runnable or testable to the degree defined by the plan.
- **Integrated replacement:** optimize the edit sequence for the final architecture. The active checkout may intentionally be unusable between integration boundaries; do not add compatibility shims or transitional paths solely to keep intermediate states green.

Decision procedure:

1. If the user already explicitly chose a mode, record it without asking again.
2. Treat the modes as materially different whenever preserving intermediate runnability or testability would change sequencing, require compatibility shims or transitional paths, or add meaningful validation or rework. Broad clean replacements and cross-component rewrites are normally material choices. A feasible incremental path, or unrelated/current dirty changes, does not make the modes equivalent.
3. Only for genuinely equivalent work — normally tiny and local — select Incrementally verifiable without a ceremonial question and state that approach in the plan.
4. For a material difference, deliver one self-contained, user-visible blocking question before continuing. List every viable option with its material implication and give exactly one context-based recommendation. Do not reduce a multi-option choice to yes/no, ask only for confirmation of the recommendation, or hide alternatives in commentary or progress updates.
5. An ordinary `yes` or `continue` selects a mode only when the immediately preceding user-visible question makes that mapping unambiguous. Earlier product or plan approval is not a continuity choice. Prefer the native predefined-choice surface; otherwise provide the same complete numbered or text fallback.

Canonical shape:

```text
Choose implementation continuity:
1. Incrementally verifiable — each coherent checkpoint leaves the affected system runnable or testable to the degree defined by the plan.
2. Integrated replacement — optimize for the final architecture; intermediate states may be unusable and require a dedicated checkout.
Recommendation: [option label] — [task-specific reason].
Reply with 1 or 2.
```

Integrated replacement constraints:

- It requires explicit user acceptance and confirmation that the active checkout is exclusively dedicated to this implementation.
- If the checkout is not yet dedicated, or unrelated changes or processes need protection, state that constraint in the same question and list each viable path: Incrementally verifiable, dedicate the current checkout, or isolate in a separate checkout. Never silently default on the user's behalf.
- A separate worktree is preferred for isolation but not required; a root checkout is allowed. Identify and protect unrelated dirty changes; do not assume that avoiding a push isolates local processes or data.

Continuity changes only intermediate local implementation order and validation boundaries. It never waives destructive-action authorization, useful targeted checks, independent final review, a successful final suite on the exact final tree, MR/pipeline/deployment safety, backwards compatibility, rolling deployment, or deploy-safe data and API migration requirements. Required migration compatibility is final correctness, not disposable scaffolding.

Record the selected mode, its implementation-order and validation implications, and any checkout constraints in the concrete plan, native goal envelope, and writer assignment. Treat a later material mode switch as a material correction under the delta-plan and risk rules before affected writes continue.

### Native Plan And Goal

- Use the host's native Plan to record proportional phases or waves, dependencies, acceptance behavior, continuity choice, checks, and delivery boundary. Keep exactly one top-level Plan item `in_progress`; subordinate agent/thread work may be concurrent and is represented by native execution state.
- Do not treat slash commands, pseudo-plan files, or manual checklists as the workflow contract.
- For implementation-authorized work, or work that later receives the required approval, establish the native Goal after the Plan is stable and immediately before tracked-writer dispatch. Never establish a Goal for analysis-only work or while an ambiguous request remains unresolved. The Goal is an outcome-oriented complement to the native Plan and authorization checkpoint, never a replacement.
- The Goal condition must be measurable and include the verified outcome, selected continuity mode and its implications, material constraints, required checks, and only delivery actions the user has already authorized.
- Use the active-host adapter for the mechanism. Reuse a semantically matching active native Goal. If the adapter cannot inspect or establish the Goal, fail closed before tracked edits rather than continuing with Plan alone. Do not create custom Goal state, hooks, runtimes, or compatibility layers.
- Close the native Goal only when its scoped implementation is complete and the required independent review, final validation, root retrospective, and any delivery explicitly included in the Goal have actually finished.
- Stable in-scope follow-ups amend the active Plan and Goal. Material scope, contract, behavior, or risk changes require a delta decision and authorization before affected writes resume. Ordinary approval waits, clarification, or a temporary lack of user input are not Goal blockers. Host-specific availability, inspection, creation, completion, and repeated-blocker behavior belongs in the adapter.
- Do not create orchestration state files, schemas, event logs, approval artifacts, leases, or migration readers. Use the host's built-in plan/task state and concise user-facing checkpoints. After compaction or resume, reconstruct truth from the conversation summary, current git state, child reports, and fresh inspection.

## 2. Choose The Smallest Useful Shape

Use risk and uncertainty, not task size alone:

| Shape | Typical use | Agents |
|---|---|---|
| Simple | Local, reversible, well-understood change | One implementation owner; final independent reviewer |
| Standard | Multi-file or cross-component work with moderate integration risk | One implementation lead; optional scout; final independent reviewer |
| High assurance | Architecture, security, permissions, data, migrations, public contracts, broad refactors, or conflicting evidence | Read-only scouts as needed, one implementation lead, disjoint slice workers, independent reviewer |

Rules:

- Before the execution gate passes, dispatch only read-only discovery or review work. Dispatch tracked implementation owners and slice workers only after presenting the plan and, when required, receiving explicit approval.
- Delegated agents never communicate with the user or formulate user questions. They escalate evidence, options, a recommendation, and paused scope only to their parent; root alone resolves or asks.
- Do not spawn one agent per file, phase-owner agents, or agents whose only job is process bookkeeping.
- One implementation lead owns the final integrated result. A small task may use the same agent as its sole writer.
- Apply Workstream Boundaries when selecting or expanding the shape.
- Parallelize several backend, frontend, test, research, or implementation workers only when their write scopes are disjoint and the shared contracts are stable. One integration lead owns shared files and contracts. Keep a slot available for independent review or recovery when capacity is tight; overlapping assignments are fake parallelism.
- If nested delegation is unavailable, root dispatches the same bounded roles directly. Outcome and review quality matter more than matching an agent tree.
- If no writer-capable native delegation is available, stop before any tracked edit and report the blocker. Root remains coordination-only while this skill is active; it never becomes the fallback writer, and it must not pretend independent review occurred.

## 3. Route By Capability And Effort

Shared instructions use three capability tiers:

| Tier | Use for |
|---|---|
| Strong | Architecture, ambiguous root-cause work, security/data/permission decisions, migrations, high-risk or cross-contract integration judgment/adjudication, and independent review |
| Balanced | Normal implementation, integration, and repository investigation with bounded ambiguity |
| Fast | Exact searches, read-heavy discovery, deterministic transformations, and other narrow mechanical work |

Capability tier and reasoning effort are independent controls:

- A Strong child does not imply effort above `High`; a narrow Fast task must not inherit root effort.
- Every dispatch selects the active adapter's real native model and, where the model exposes it, an explicit supported effort. A capability label in the task prompt is not a selector.
- Root uses the strongest available capability and the adapter-defined model and effort for the entire run. It owns global context, decisions, integration, final adjudication, and the retrospective. Do not lower root effort for deterministic segments. If the host cannot expose or set the adapter-defined root control, use its strongest available root setting, state the limitation, and never claim the adapter route is enforced.
- Host adapters define concrete model/effort selectors; the shared lifecycle does not.

Child dispatch rules:

- Pin every child's native model and, where supported, effort explicitly. No child or nested child may exceed `High`. Never leave a child unpinned where it could inherit the adapter-defined root effort.
- Give each child and nested child fresh, task-local context through a concise self-contained assignment; never rely on inherited conversation history. Where the host exposes a history-propagation choice, select the isolating route.
- If the host exposes no safe way to prevent above-High inheritance or unwanted history propagation, report the limitation and do not silently dispatch a violating child.
- A child that believes it needs effort above `High` must narrow or split the work, or return the unresolved judgment to root; it never self-escalates above the ceiling.

| Role | Capability | Default effort | Ceiling | Decision notes |
|---|---|---|---|---|
| Root orchestrator | Strongest available | Adapter-defined | Adapter-defined | Uses the active host adapter's defined route for the entire run; owns global decisions, integration, final adjudication, and retrospective |
| Implementation lead | Balanced normally; Strong only for ambiguous/high-risk cross-contract judgment | High | High | Owns tracked implementation, shared files, and integration |
| Independent reviewer | Strong | High | High | Final code review always uses this route |
| Architecture or security scout | Balanced or Strong | High | High | Use only when real ambiguity or risk warrants it |
| Normal read-only scout | Fast or Balanced | Medium | High | Raise only for bounded complexity, never above High |
| Slice worker | Fast or Balanced | Medium | High | Keep scope disjoint and contract stable |
| Search or inventory | Fast | Low or Medium | Medium | Exact, narrow, read-only evidence gathering |
| Validation or check | Fast or Balanced | Medium | High | Use High only when failure analysis is genuinely complex |
| Delivery or PR support | Balanced | Medium | High | Delivery authority remains separate from effort |
| Execution retrospective | Root-owned | Adapter-defined | Adapter-defined | Runs on root at the adapter-defined route; never spawn a dedicated retrospective agent |

Before every new child:

1. If an active agent already covers the same goal, evidence, and output, steer or follow up with it instead of spawning.
2. Spawn only for materially distinct evidence or scope. Overlap is allowed only for intentional independent review with a distinct focus.
3. If two proposed agents would receive the same data, goal, and expected output, merge them into one assignment.
4. Final code review is a Strong child at `High`; the adapter-defined root route adjudicates its findings and completion.
5. Treat any of the following as an execution-retrospective finding: a missing explicit child model or (where supported) effort, any child above `High`, absent context isolation, avoidable expensive routing, redundant work, or overlapping work. The adapter-defined root route is expected and is not an efficiency finding.

## 4. Delegate Clear Work

Every assignment contains only what the agent needs:

- the active adapter's explicit native model and, when supported, effort, plus the isolation needed to enforce the `High` ceiling and fresh task-local context;
- goal and observable acceptance criteria;
- relevant repository context and constraints;
- allowed write scope and explicit non-goals;
- important decisions already made, including the selected continuity mode and its implications;
- expected targeted checks;
- meaningful checkpoints the child will push after a coherent phase, targeted check, blocker, or handoff;
- conditions that require escalation;
- required escalation shape: evidence, options, recommendation, and exact paused scope, returned only to the parent;
- required report: changes, checks, unresolved risks, and unexpected findings.

Preflight is required; post-dispatch visibility is only a secondary guard. If host-visible UI, task metadata, or transcript shows a child routed at a different model, effort, or isolation state than approved: immediately stop or cancel it, discard its result, and report the mismatch. A post-dispatch guard is never permission to skip a preflight the active adapter requires.

Use checkpoints push-first: root observes pushed completion, check, blocker, and handoff updates, and does not steer or poll an active agent merely for status. Request a checkpoint only for recovery, a safe redirection boundary, a material decision, or evidence that the assignment may no longer be covered.

Role boundaries:

- **Scout:** read-only; returns concise code evidence, likely root cause, options, and unresolved decisions to its parent.
- **Implementation lead:** owns tracked edits, integration, targeted checks, and the final implementation report. It may request slices or review.
- **Slice worker:** owns one disjoint bounded write scope and reports back to the lead; it does not redefine shared contracts.
- **Reviewer:** independent and normally read-only; checks requirement fit, correctness, regressions, architecture, negative cases, and validation gaps.

### Local Context And Knowledge Deltas

- Related agents own routine operational context and repair loops among themselves. Raw logs, large diffs, debug history, repeated tool calls, and local test failures stay with the agent that can act on them.
- A completion or handoff report to root is a compact knowledge delta, not a transcript: outcome, contract changes, new facts or invalidated assumptions, verification/evidence location, residual risk, decision needed, and exact paused scope.
- The integration lead consolidates worker deltas for shared contracts.
- Escalate to root only for architecture, scope, public contracts, security, migration, conflicting capsules, disputed or repeated failure, or user authority. Root need not reopen coherent artifacts except for adjudication or final verification.

An implementer normally performs focused local investigation and targeted tests. Use separate scouts for broad, ambiguous, or cross-cutting discovery. An implementer may spawn a disjoint helper or reviewer where native delegation allows, but the final review must be an independent Strong child at High and must not be the implementer.

The approved or otherwise authorized plan is the implementation contract. Include its decisions and acceptance behavior in writer assignments; escalate rather than silently redefining it.

Pass relevant specialist-skill guidance into assignments when frontend, Laravel, brand, delivery, or another domain requires it. Do not assume a child will discover internal references by itself.

## 5. Execute And Adapt

The implementation owner:

1. Verifies the assigned plan against the real code before writing.
2. Fixes the root cause, removing obsolete paths when the authorized direction is a clean replacement.
3. Keeps edits inside the assigned scope and flags unrelated dirty state immediately.
4. Runs targeted checks at meaningful boundaries, not after each file save.
5. Reports unexpected complexity early to the parent so the assignment can be narrowed or split, or unresolved judgment can reach root through the escalation chain.

### Bounded Experiments

For open-ended experiment work, define success metrics, a small limited set of concurrent hypotheses, and the evidence or time boundary for choosing, reverting, or discarding each hypothesis. Keep reversible experiment changes isolated where practical. Stop and re-evaluate the plan when the metric does not discriminate, the hypothesis budget is exhausted, or the next experiment would materially expand scope or risk; do not turn exploratory work into unbounded retries.

### Mid-flight user messages

Root briefly acknowledges new input and classifies it by effect. Delegated agents receive only the resulting assignment update and never reply to the user:

- **Status or question:** answer without stopping the active implementation.
- **Detail within authorized behavior:** incorporate it into the affected current or upcoming work; unaffected work continues and no duplicate approval is needed.
- **Materially new functionality:** pause only affected writes; run affected-scope discovery, user-needs brainstorming, deeper analysis, a concrete delta-plan, and explicit approval before resuming those writes. Unaffected work continues.
- **Correction to authorized behavior:** redirect or pause only the impacted work, reassess affected edits and checks, and — when material — obtain explicit approval of a delta-plan before affected writes resume. Independent work continues.
- **Explicit stop, replacement request, or blocking contradiction:** stop the affected work; stop the whole run only when the instruction or safety issue is global.

Batch multiple related material changes or corrections received during the same active segment: handle them at the next safe boundary through one affected-scope discovery, brainstorming, deeper analysis, consolidated delta-plan, and explicit approval instead of one cycle per message. Keep unaffected work moving. Never defer an urgent stop, safety correction, or instruction that makes continuing unsafe.

Use the host's available transport. Codex may steer an active agent or queue input; Claude Code may deliver follow-up messages through different controls. Those are implementation details. If an active worker cannot be redirected safely, obtain a checkpoint and apply the change at the next dispatch boundary. Never ignore new user input, but do not turn every message into a global pause.

### Recovery

When an agent becomes silent or interrupted: first request or recover its latest checkpoint and inspect the actual git diff. Reassign overlapping writes only after the prior writer is known to be stopped or its scope is safely handed off. Do not add a lease protocol or assume that elapsed time proves abandonment.

### MR/PR Pipeline Regression Handoff

`merge-request` resolves the exact created or updated MR/PR head, observes its matching pipeline/check set within its bounded registration window, and owns provider evidence. If no matching checks/pipeline registers by that deadline, it reports an unverified external-state outcome rather than green; do not enter the repair loop without failure evidence. If it reports a failed or cancelled pipeline, first use that evidence to distinguish an in-scope MR-diff regression from a flaky/infrastructure, credentials, or external-state issue.

For an in-scope regression:

1. The original explicit create/update intent authorizes a bounded repair only while it stays inside the established MR scope and risk.
2. Treat the diagnostic bundle as a new implementation phase: verify the failure against the diff, state a proportional repair plan, delegate the tracked repair, run targeted validation, require independent review, and refresh the final suite after the final repair mutation.
3. Invoke `merge-request` to commit/push/update the same MR/PR and monitor its replacement pipeline.
4. Repeat until green, or until a genuine blocker or material scope/risk change requires the user.

For flaky/infrastructure failures, let `merge-request` retry only when the provider supports a safe retry and repository/user instructions allow it; do not weaken or skip checks. Credentials and external-state blockers, conflicting instructions, and material scope expansion require a concise evidence-backed question. `merge-request` never writes code, and this lifecycle never asks it to orchestrate repairs: it returns evidence to an active orchestrator run, or a standalone delivery request hands off into this lifecycle before resuming the merge-request skill.

## 6. Review And Fix

- Every tracked implementation receives final code review from an independent Strong child pinned at `High`; the adapter-defined root route adjudicates the findings and completion.
- Risk controls whether additional specialized review is needed, not whether this final review occurs.
- If the host cannot safely dispatch the required reviewer without above-High inheritance, report the limitation and do not imply that independent review happened.
- Findings name severity, evidence, impact, and the required correction.
- Send fixes back to an implementation owner, run the affected targeted checks, and by default return the changed area to the same independent reviewer for each correction cycle. Add a new reviewer only when the risk is distinct, a fresh final review is needed, or that reviewer is unavailable.
- Do not repeat the entire review for unrelated settled code unless a fix changes its assumptions.

## 7. Validate Proportionately

### Adjacent findings

During scoped discovery, implementation, review, and validation, capture every verified, material, actionable adjacent codebase finding discovered naturally:

- Keep these findings separate from the root execution retrospective. The retrospective keeps its at-most-three process findings; adjacent findings have no count cap. Group and prioritize them when numerous.
- Each report names evidence and location, impact, and a concise recommended direction and urgency. Exclude speculation, duplicates, and cosmetic nits.
- A finding that is actually a current correctness, requirement, or verification gap is fixed in scope or lowers/blocks the readiness verdict; it is never silently deferred as adjacent work.
- Reporting a finding does not authorize expanding the implementation scope. Repeated violations may produce a repository lint/ratchet/enforcement recommendation, but the orchestrator never adds that enforcement automatically.

### Runtime smoke before readiness

For executable, runtime, or user-visible changes:

1. The Plan defines the smallest realistic smoke scenarios before implementation: environment and host, preconditions, exact flow, expected observable results, side effects/authentication/data constraints, cleanup, and evidence to capture.
2. After the final suite and before readiness/completion, discover the actual host and repository capabilities.
3. Offer the user every applicable available testing surface, with a concise difference and implication for each and exactly one evidence-based recommendation. Do not dump unavailable or inapplicable options. Honor an explicit prior tool choice without asking again. If only one surface is available, offer it transparently; if none is available or smoke is not meaningful, state N/A and why.
4. The offer describes exactly which flows will run and what evidence will be captured. The smoke never replaces automated validation.
5. After selection, run the Plan's scenarios and report environment/head, expected versus observed outcomes, side effects, gaps, and screenshots for meaningful checkpoints and failures when the selected surface supports them. Protect secrets and private data.
6. A required smoke that fails, is unavailable, or is declined affects readiness. An optional smoke that was offered but declined is reported as unverified without inventing a blocker.
7. A smoke-discovered gap returns to implementation; any later mutation requires targeted checks, focused re-review, a refreshed final suite, and repeat of the affected smoke.

Host adapters map available smoke surfaces to their native capabilities; the semantic lifecycle remains host-neutral and never invents selectors or assumes an unavailable surface.

### During implementation

- After a coherent task or phase, run only checks relevant to the behavior changed in that unit.
- Group edits before testing when they are part of one behavior change.
- After a review fix, rerun the check affected by that fix.
- Do not run `FullTestSuite`, an equivalent repository-wide suite, or every available validator after each edit, file, worker, or minor task.
- Respect repository restrictions such as forbidden build commands or required package managers.

### Final completion gate

At the final completion boundary, after the final tracked mutation and required review:

1. Confirm the intended diff and that unrelated files are excluded.
2. Run the repository's full suite once on the exact final tree when such a suite exists.
3. If the repository has no named full suite, use its broadest normal validation command or plugin validation as the final suite.
4. For executable, runtime, or user-visible changes, discover and offer applicable smoke surfaces after the final suite, let the user choose one (unless an explicit prior choice applies), and run the selected Plan scenarios. Capture the chosen surface, flows, environment/head, screenshots where supported, expected versus observed results, side effects, and gaps.
5. If a relevant mutation happens afterward, rerun the impacted targeted check, refresh the final suite once on the new final tree, and repeat the affected smoke.

This completion gate applies whether or not delivery was requested. When PR/MR or other delivery is requested, the same successful run is the final pre-delivery suite.

Do not add a new test framework just to test instruction text. Lightweight syntax, link, manifest, discovery, and plugin validation are enough for an instruction-only plugin unless the repository already provides more.

### Final Readiness Verdict

Every tracked implementation's final user-facing handoff contains exactly one explicit, evidence-based verdict. Evaluate these conditions in order and use the first verdict that matches; the branches are exclusive:

1. **NOT READY** — any of:
   - required scoped implementation, independent review, or final validation is incomplete, failed, or unverified;
   - a known technical blocker remains;
   - deployment was observed while proportional production verification, or a known required production/pre-deployment prerequisite, was incomplete, failed, or unverified.
2. **DEPLOYED & VERIFIED** — all of:
   - scoped implementation, independent review, and final validation are complete and verified;
   - no known technical blocker remains;
   - all known required production/pre-deployment prerequisites were verified;
   - deployment was observed, and proportional production verification was observed.
3. **CONDITIONALLY READY** — deployment was not observed; implementation, review, and validation are complete and verified; no known technical blocker remains; but a named external, delivery, or pre-deployment prerequisite remains incomplete or unverified — for example PR review or merge, organizational approval, release, configuration or migration action, or environment verification.
4. **READY TO DEPLOY** — deployment was not observed; implementation, review, and validation are complete and verified; no known technical blocker remains; and all known required production/pre-deployment prerequisites within observable scope are verified.

Verdict rules:

- Unverified prerequisites are never satisfied by inference, intent, an agent report, or a completion claim. A statement such as "done" or "complete" must be qualified by the verdict rather than implying merge, release, deployment, or production verification.
- For a runtime smoke required by the Plan or repository/user acceptance criteria: a failed, unavailable, or declined smoke is an unverified required prerequisite and prevents `READY TO DEPLOY` or `DEPLOYED & VERIFIED` until resolved. An optional smoke that was offered and declined is reported as unverified but does not by itself invent a blocker.
- The verdict is a point-in-time snapshot. Recompute it whenever an authorized delivery action changes observed state.
- The assistant's current authority to merge, release, or deploy does not itself change the verdict: a required organizational approval remains a prerequisite and the state is **CONDITIONALLY READY** until verified.
- The verdict never grants authority for merge, release, deployment, configuration, migration, or any other external action, and it does not change Draft PR/MR semantics or readiness state.

The handoff separately states:

- implementation state;
- review and validation state;
- delivery state;
- production state;
- concrete remaining required steps, or explicitly `None`;
- one next action.

## 8. Retrospect And Improve

After the required review and successful final suite, and before completion or delivery, root performs a bounded execution retrospective at the adapter-defined root effort. Root owns this step; never spawn an agent solely to perform it.

Rules:

- Keep it proportional. Use only observable evidence already available from the native plan, user messages, assignments and reports, git diff, and check results.
- Do not reread the entire repository or transcript, expose or reconstruct chain-of-thought, or invent token counts. Use exact token or usage figures only when the host exposes them; otherwise use observable proxies.
- Surface at most three findings. For each material finding, state the observable evidence, impact, better approach, and whether it is a current correctness gap, task-specific lesson, or plausibly generalizable process improvement.
- Optimize total cost across agent context, tool work, validation, and latency while preserving implementation and review quality; raw token minimization is not the goal.

Assess both correctness and the total resource cost of reaching a reliable result. Look for:

- a current correctness, requirement, review, or verification gap;
- avoidable rework or duplicate and overlapping reads, searches, commands, or context loads;
- redundant or overlapping agents, oversized child context, or repeated polling;
- serial work that could safely have been batched or parallelized;
- repeated checks without a relevant mutation, premature broad-suite runs, or work done before the final tree that could have waited;
- routing or reasoning that was unnecessarily expensive, or too weak and therefore caused rework.

The adapter-defined root effort is required and is never an efficiency finding. Any child above `High`, child dispatch without an explicit model or (where supported) effort, missing required context isolation, avoidable expensive routing, or redundant or overlapping child work is a retrospective finding.

If a current correctness or verification gap exists: return it to the implementation owner, correct it, run the affected targeted checks and focused review, and refresh the final suite on the later final tree. Then rerun this bounded retrospective against the now-final evidence before completion or upstream feedback handling. Do not declare completion until the gap is closed. Task-specific or immaterial observations stay in the retrospective and do not become upstream feedback.

Only a material, actionable, plausibly generalizable process improvement qualifies for upstream feedback. For the highest-value candidate only:

1. Before any external search, sanitize client and project names, paths, source, prompts, credentials, secrets, and proprietary details from the candidate, then derive generic, non-sensitive search terms from the sanitized improvement.
2. Search open and closed issues and PRs in the canonical upstream repository, `antstudiocz/ant-marketplace`, using only those generic terms and the active host's authenticated GitHub capability or `gh` when available.
3. If network or authentication is unavailable, report the blocker without blocking the original implementation or authorized delivery.
4. Treat a matching issue or PR as a deduplication result and do not prepare a new issue when either already covers the improvement. Comment on a matching issue only when the run adds materially new sanitized evidence. Reference or report a matching PR without writing to it through this flow. Only when neither exists, prepare a concise English issue covering observed behavior, evidence and impact, proposed improvement, expected efficiency or quality effect, risks and tradeoffs, and a validation scenario.
5. Perform at most one upstream feedback action per run. Creating, commenting on, or updating an issue is an external write and requires explicit current approval or clearly applicable standing approval; implementation or delivery approval does not imply it. Without that authority, show the prepared candidate and ask instead.

Never auto-create a PR from the retrospective. A PR is a separate maintenance implementation with repository discovery, a concrete approved or otherwise authorized plan, delegated tracked writing, review, final validation, and the host-visible `/ant:merge-request` or `$merge-request` skill. The orchestrator never edits itself automatically.

## 9. Deliver

Before delivery, verify branch, target, final diff, validation results, and the exact actions requested by the user. Stage only in-scope files and follow repository commit/push rules.

- For every PR/MR create or update action, invoke the plugin skill through its host-visible identifier: Claude Code `/ant:merge-request` or Codex `$merge-request`. Pass it the verified summary, checks, target, language/readiness choices already supplied by the user, and unresolved risks.
- After every create/update, let `merge-request` resolve the exact MR/PR head and observe its matching pipeline/check set to a terminal state. If its evidence identifies an in-scope regression, re-enter the bounded repair loop above before asking it to update and observe the replacement pipeline.
- For merge-conflict resolution and related recovery, use Claude Code `/ant:delivery-workflows` or Codex `$delivery-workflows` only.
- A request to commit and push does not imply merge, Draft-to-ready conversion, tagging, publishing, or release unless the user says so.

Finish with the delivered commit/PR/MR state, material quality attributes, checks run, smoke choice and evidence (or N/A reason), all verified adjacent findings, and anything that remains unverified. Keep the report concise enough to scan once and include exactly one readiness verdict.
