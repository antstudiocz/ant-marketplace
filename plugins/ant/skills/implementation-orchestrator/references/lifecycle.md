# Implementation Lifecycle

This is the orchestrator's shared internal reference. Apply it with repository instructions, and load exactly one active-host adapter only when `SKILL.md` Reference Loading reaches a host-specific native-goal, delegation, or model/effort decision.

## 1. Discover, Classify, Brainstorm, And Plan

Every implementation has a pre-write discovery and planning cycle. Keep it compact for a tiny mechanical change and thorough for new, broad, ambiguous, or risky work; never remove it entirely. Plan presentation is always required before tracked edits. Whether it also pauses execution depends on the user's intent and the resulting scope and risk.

At intake, classify the request before substantive or deep analysis:

- **Analysis-only:** The user asks to inspect, diagnose, explain, review, audit, or propose without asking for execution. Stay read-only and report evidence, options, and any recommended next step.
- **Implementation-authorized:** The user explicitly asks to fix, implement, change, build, test, or otherwise carry work through execution. This is upfront authorization to implement the requested outcome after discovery and plan presentation, not authorization for delivery or external writes.
- **Ambiguous:** When it is genuinely unclear whether the user wants analysis or implementation, ask early whether they want analysis only or implementation too. Minimal repository inspection needed to route the request is allowed, but do not begin deep analysis first.

An explicit request to propose a plan, wait for approval, or otherwise defer execution overrides implementation authorization and requires a pause. Do not infer authorization from a product brief, a concrete plan, or a request that merely names an implementation topic.

Before any tracked edit or tracked-writer dispatch:

1. Read repository instructions and do only the minimal inspection needed to classify intent and protect unrelated work.
2. Classify the intent as analysis-only, implementation-authorized, or ambiguous. For ambiguity, ask the user before substantive or deep analysis.
3. Separate in-scope changes from unrelated dirty files, then inspect the current branch, relevant diff, code path, behavior, contracts, and validation commands or delegate read-only scouts. Do not ask the user for facts that can be discovered safely from the repository or environment.
4. Classify the work as a tiny mechanical change, work already covered by an approved or otherwise authorized plan, or new/materially changed behavior.

For analysis-only work, stop after the appropriate read-only discovery and report. For an ambiguous request, resolve the intended mode before substantive or deep analysis. For a fix, refactor, migration, or remediation that does not introduce materially new behavior, state the verified goal or root cause, acceptance behavior, affected areas, implementation steps, risks, and checks in a proportional plan. Continue into tracked implementation after presenting that plan only when execution was explicitly authorized and it stays within the original scope and risk; otherwise obtain explicit approval.

For a new feature or materially new behavior, continue in this order:

1. Brainstorm with the user about the goal, users, desired workflow, edge cases, non-goals, options, and tradeoffs.
2. Ask every unresolved question whose answer materially changes behavior, scope, architecture, data, safety, validation, or delivery. Group questions clearly, but do not impose an arbitrary count.
3. After receiving the answers, inspect architecture, contracts, data flows, dependencies, obsolete or legacy behavior, risks, and validation paths in greater depth.
4. Present a concrete implementation plan covering acceptance behavior, affected areas, key decisions, implementation sequence, validation, risks, and explicit non-goals.
5. Present the plan before dispatching a tracked writer or making tracked edits. When execution was explicitly authorized and the plan remains within the user's original scope and risk, continue without waiting for another confirmation. Otherwise obtain explicit user approval.

Read-only scouts may run before the execution gate. They return evidence and options, never implementation changes. Approval or implementation authorization applies only to the stable plan or workstream, so do not ask again before every phase. Ask again when a material discovery invalidates the plan or changes behavior, architecture, data, safety/risk, scope, or requires destructive action.

A tiny mechanical change inside an already approved or otherwise authorized plan may use a compact cycle: verify the affected code, state the small delta and checks, then continue without duplicate approval. A concrete plan supplied by the user or an approved `create-application` brief may satisfy earlier product brainstorming once repository facts are verified, but it is not implementation authorization. A separate explicit end-to-end implementation request may provide that authorization after plan presentation.

Implementation authorization does not remove the mandatory plan checkpoint or authorize a materially expanded plan. Approval or authorization covers only the scoped repository edits required by the plan. It does not independently authorize destructive operations, force-pushes, merges, releases, or unrelated cleanup. An explicit create/update PR/MR request carries only the limited scoped commit, push, new-request Draft-by-default creation, ordinary-update readiness preservation, and pipeline-observation chain defined by `merge-request`; respect any narrower repository or host permission boundary.

Implementing and testing code for future production behavior is not the same as actually deploying, publishing, releasing, running a production operation, or causing an external side effect. The former is covered by implementation authorization when it stays inside the stable plan; the latter requires the corresponding delivery or external-action authority.

### Decision And Approval Routing

Root is the only role that communicates with the user, formulates user-facing questions, or adjudicates approval. A delegated scout, writer, slice worker, reviewer, validator, or delivery helper never asks the user directly and never drafts a question for the user to relay. When it cannot safely continue, it returns one escalation packet to its parent containing:

- repository or host evidence and the decision that remains unresolved;
- viable options and tradeoffs;
- its recommendation;
- the exact affected scope paused while unaffected authorized work continues.

Nested parents resolve what they can from their assignment and pass any remainder upward in the same form until it reaches root. Root first checks repository evidence, the stable authorized plan, and prior user decisions. It asks the user only for genuinely new material behavior, scope, or risk; an uncovered destructive, external, or delivery action; or a real native user-only host approval. Consolidate every known necessary user decision into one concrete question. If the user immediately answers that root question with an ordinary `yes`, `continue`, or equivalent unambiguous confirmation, it is sufficient; do not require ritual wording or claim that an exact sentence is needed.

Keep workflow approval distinct from host execution policy. A declined patch, `fileChange`, or policy classification is not by itself a native user-only approval gate and does not justify asking the user to repeat approval. Resolve a safe in-policy execution path that produces the identical planned result, or return the full shared escalation packet—evidence, viable options and tradeoffs, a recommendation, and the exact paused scope—to the parent for escalation through parents to root. Mechanical patch splitting is permitted only when the pieces are coherent implementation steps toward that identical final result; never split work to evade policy classification.

Quality is invariant across every resolution path. Never choose weaker architecture, reduced tests or validation, a legacy fallback, a hidden workaround, or any semantic compromise to avoid an approval. If the correct solution genuinely requires new authority, root asks once rather than degrading the result.

### Implementation Continuity

After initial read-only discovery and before the concrete implementation plan or any tracked write, decide whether the task materially differs under these modes:

- **Incrementally verifiable:** Each coherent checkpoint leaves the affected system runnable or testable to the degree defined by the plan.
- **Integrated replacement:** Optimize the edit sequence for the final architecture. The active checkout may intentionally be unusable between integration boundaries; do not add compatibility shims or transitional paths solely to keep intermediate states green.

First check whether the user already explicitly chose a mode; if so, record it without asking again. Otherwise, treat the modes as materially different whenever preserving intermediate runnability or testability would change sequencing, require compatibility shims or transitional paths, or add meaningful validation or rework. Broad clean replacements and cross-component rewrites should normally be material choices. A feasible incremental path, or unrelated or current dirty changes, does not make the modes equivalent. Only for genuinely equivalent work, normally tiny and local, select Incrementally verifiable without a ceremonial question and state that approach in the plan.

For a material difference, deliver one self-contained, user-visible blocking decision question before continuing. List every viable option with its material implication or tradeoff and give exactly one context-based recommendation. Do not reduce a multi-option choice to yes/no, ask only for confirmation of the recommendation, or hide alternatives in commentary or progress updates; they may collapse. An ordinary `yes`, `continue`, or equivalent selects a mode only when the immediately preceding user-visible question makes that mapping unambiguous. Earlier product or plan approval is not a continuity choice. Prefer the native predefined-choice surface; otherwise provide the same complete numbered or text fallback.

Canonical shape:

```text
Choose implementation continuity:
1. Incrementally verifiable — each coherent checkpoint leaves the affected system runnable or testable to the degree defined by the plan.
2. Integrated replacement — optimize for the final architecture; intermediate states may be unusable and require a dedicated checkout.
Recommendation: [option label] — [task-specific reason].
Reply with 1 or 2.
```

When Integrated replacement is unavailable until checkout protection is resolved, state that constraint in the same question and list each viable path: Incrementally verifiable, dedicate the current checkout for Integrated replacement, or isolate it in a separate checkout for Integrated replacement.

Integrated replacement requires explicit user acceptance and confirmation that the active checkout is exclusively dedicated to this implementation. If it is unavailable because the checkout is not yet exclusively dedicated or unrelated changes or processes need protection, state that constraint and ask whether to dedicate or isolate the checkout or use Incrementally verifiable; do not silently default on the user's behalf. A separate worktree is preferred for isolation but is not required; a root checkout is allowed. Identify and protect unrelated dirty changes, and do not assume that avoiding a push isolates local processes or data.

Continuity changes only intermediate local implementation order and validation boundaries. It never waives destructive-action authorization, useful targeted checks, independent final review, a successful final suite on the exact final tree, MR/pipeline/deployment safety, backwards compatibility, rolling deployment, or deploy-safe data and API migration requirements. Required migration compatibility is final correctness, not disposable scaffolding.

Record the selected mode, its implementation-order and validation implications, and any checkout constraints in the concrete plan, native goal envelope, and writer assignment. Treat a later material mode switch as a material correction under the delta-plan and risk rules before affected writes continue.

### Native Goal Envelope

For implementation-authorized work, or work that later receives the required approval, establish the active host's native goal envelope after the objective, acceptance behavior, constraints, validation, and any authorized delivery are stable, and immediately before tracked-writer dispatch. Do not establish a goal for analysis-only work or while an ambiguous request remains unresolved. The goal is an outcome-oriented complement to the native plan and authorization checkpoint, never a replacement for either.

Use the active-host adapter for the mechanism. The goal condition must be measurable and include the verified outcome, selected continuity mode and its implications, material constraints, required checks, and only delivery actions the user has already authorized. Do not create custom goal state, hooks, runtimes, or compatibility layers. Reuse a semantically matching active native goal when the host supports that; do not overwrite, complete, or block an unrelated active goal.

Close the native goal only when its scoped implementation is complete and the required independent review, final validation, root retrospective, and any delivery explicitly included in the goal have actually finished. Ordinary approval waits, clarification, or a temporary lack of user input are not goal blockers. Host-specific availability, inspection, creation, completion, and repeated-blocker behavior belongs in the adapter.

Do not create orchestration state files, schemas, event logs, approval artifacts, leases, or migration readers. Use the host's built-in plan/task state and concise user-facing checkpoints. After compaction or resume, reconstruct truth from the conversation summary, current git state, child reports, and fresh inspection.

## 2. Choose The Smallest Useful Shape

Use risk and uncertainty, not task size alone:

| Shape | Typical use | Agents |
|---|---|---|
| Simple | Local, reversible, well-understood change | One implementation owner; final independent reviewer |
| Standard | Multi-file or cross-component work with moderate integration risk | One implementation lead; optional scout; final independent reviewer |
| High assurance | Architecture, security, permissions, data, migrations, public contracts, broad refactors, or conflicting evidence | Read-only scouts as needed, one implementation lead, disjoint slice workers, independent reviewer |

Rules:

- Before the applicable execution gate passes, dispatch only read-only discovery or review work. Dispatch tracked implementation owners and slice workers only after presenting the plan and, when required, receiving explicit approval.
- Delegated agents never communicate with the user or formulate user questions. They escalate evidence, options, a recommendation, and paused scope only to their parent; root alone resolves or asks.
- Do not spawn one agent per file, phase-owner agents, or agents whose only job is process bookkeeping.
- One implementation lead owns the final integrated result. A small task may use the same agent as its sole writer.
- Parallelize only independent work with disjoint write scopes and a stable shared contract. Keep a slot available for review or recovery when capacity is tight.
- If nested delegation is unavailable, the root dispatches the same bounded roles directly. Outcome and review quality matter more than matching an agent tree.
- If no writer-capable native delegation is available, stop before any tracked edit and report the blocker. The root remains coordination-only while this skill is active; it never becomes the fallback writer, and it must not pretend independent review occurred.

## 3. Route By Capability And Effort

Shared instructions use three capability tiers:

| Tier | Use for |
|---|---|
| Strong | Architecture, ambiguous root-cause work, security/data/permission decisions, migrations, integration ownership, and independent review |
| Balanced | Normal implementation, integration, and repository investigation with bounded ambiguity |
| Fast | Exact searches, read-heavy discovery, deterministic transformations, and other narrow mechanical work |

Capability tier and reasoning effort are independent controls. A Strong child does not imply effort above `High`, and a narrow Fast task should not inherit root effort. Every dispatch must select the active adapter's real native model and, where the selected model exposes it, explicit supported effort; a capability label in the task prompt is not a selector.

The root orchestrator uses the strongest available capability and the active host's maximum available reasoning effort for the entire run. It owns global context, decisions, integration, final adjudication, and the retrospective. Do not lower root effort for deterministic segments. If the host cannot expose or set the root control, use its strongest available root setting, state the limitation, and never describe it as maximum.

Every child dispatch must pin its native model and, where that model exposes an effort selector, its supported effort explicitly. No child or nested child may use any setting above `High`. Never leave a child unpinned where it could inherit root maximum effort. Each child and nested child must receive fresh, task-local context through a concise self-contained assignment; never rely on inherited conversation history. Where the host exposes a history-propagation choice, select the isolating route. If the host exposes no safe way to prevent above-High inheritance or unwanted history propagation, report the limitation and do not silently dispatch a violating child. A child that believes it needs effort above `High` must narrow or split the work, or return the unresolved judgment to root; it never self-escalates above the ceiling.

| Role | Capability | Default effort | Ceiling | Decision notes |
|---|---|---|---|---|
| Root orchestrator | Strongest available | Max | Max | Uses the host's maximum available setting for the entire run; owns global decisions, integration, final adjudication, and retrospective |
| Implementation lead | Balanced or Strong | High | High | Owns tracked implementation and integration |
| Independent reviewer | Strong | High | High | Final code review always uses this route |
| Architecture or security scout | Balanced or Strong | High | High | Use only when real ambiguity or risk warrants it |
| Normal read-only scout | Fast or Balanced | Medium | High | Raise only for bounded complexity, never above High |
| Slice worker | Fast or Balanced | Medium | High | Keep scope disjoint and contract stable |
| Search or inventory | Fast | Low or Medium | Medium | Exact, narrow, read-only evidence gathering |
| Validation or check | Fast or Balanced | Medium | High | Use High only when failure analysis is genuinely complex |
| Delivery or PR support | Balanced | Medium | High | Delivery authority remains separate from effort |
| Execution retrospective | Root-owned | Max | Max | Runs on root at the host's maximum available setting; never spawn a dedicated retrospective agent |

Apply these dispatch decisions before every new child:

1. If an active agent already covers the same goal, evidence, and output, steer or follow up with it instead of spawning.
2. Spawn only for materially distinct evidence or scope. Overlap is allowed only for intentional independent review with a distinct focus.
3. If two proposed agents would receive the same data, goal, and expected output, merge them into one assignment.
4. Final code review is a Strong child at `High`; root at maximum effort adjudicates its findings and completion.
5. Treat a missing explicit child model or, where supported, effort, any child above `High`, absent context isolation, avoidable expensive routing, redundant work, or overlapping work as an execution-retrospective finding. Root maximum effort is expected and is not an efficiency finding.

## 4. Delegate Clear Work

Every assignment should contain only what the agent needs:

- the active adapter's explicit native model and, when supported, effort, plus the isolation needed to enforce the `High` ceiling and fresh task-local context;
- goal and observable acceptance criteria;
- relevant repository context and constraints;
- allowed write scope and explicit non-goals;
- important decisions already made, including the selected continuity mode and its implications;
- expected targeted checks;
- conditions that require escalation;
- required escalation shape: evidence, options, recommendation, and exact paused scope, returned only to the parent;
- required report: changes, checks, unresolved risks, and unexpected findings.

Preflight is required; post-dispatch visibility is only a secondary guard. If host-visible UI, task metadata, or transcript shows that a child was routed at a different model, effort, or isolation state than approved, immediately stop or cancel that child, discard its result, and report the mismatch. Do not treat a post-dispatch guard as permission to skip a preflight that the active adapter requires.

Role boundaries:

- **Scout:** read-only; returns concise code evidence, likely root cause, options, and unresolved decisions to its parent.
- **Implementation lead:** owns tracked edits, integration, targeted checks, and the final implementation report. It may request slices or review.
- **Slice worker:** owns one disjoint bounded write scope and reports back to the lead; it does not redefine shared contracts.
- **Reviewer:** independent and normally read-only; checks requirement fit, correctness, regressions, architecture, negative cases, and validation gaps.

The approved or otherwise authorized plan is the implementation contract. Include its decisions and acceptance behavior in writer assignments, and escalate rather than silently redefining it.

Pass relevant specialist-skill guidance into assignments when frontend, Laravel, brand, delivery, or another domain requires it. Do not assume a child will discover internal references by itself.

## 5. Execute And Adapt

The implementation owner should:

1. Verify the assigned plan against the real code before writing.
2. Fix the root cause, removing obsolete paths when the approved or otherwise authorized direction is a clean replacement.
3. Keep edits inside the assigned scope and flag unrelated dirty state immediately.
4. Run targeted checks at meaningful boundaries, not after each file save.
5. Report unexpected complexity early to the parent so the assignment can be narrowed or split, or unresolved judgment can reach root through the escalation chain.

### Mid-flight user messages

Root briefly acknowledges new input and classifies it by effect. Delegated agents receive only the resulting assignment update and never reply to the user:

- **Status or question:** answer without stopping the active implementation.
- **Detail within authorized behavior:** incorporate it into the affected current or upcoming work; unaffected work continues and no duplicate approval is needed.
- **Materially new functionality:** pause only affected writes; run affected-scope discovery, user-needs brainstorming, deeper analysis, a concrete delta-plan, and explicit approval before resuming those writes. Unaffected work continues.
- **Correction to authorized behavior:** redirect or pause only the impacted work, reassess affected edits and checks, and when the correction is material obtain explicit approval of a delta-plan before affected writes resume. Independent work continues.
- **Explicit stop, replacement request, or blocking contradiction:** stop the affected work; stop the whole run only when the instruction or safety issue is global.

Batch multiple related material changes or corrections received during the same active segment. At the next safe boundary, handle them through one affected-scope discovery, brainstorming, deeper analysis, consolidated delta-plan, and explicit approval instead of one cycle per message. Keep unaffected work moving. Do not defer an urgent stop, safety correction, or instruction that makes continuing unsafe.

Use the host's available transport. Codex may steer an active agent or queue input; Claude Code may deliver follow-up messages through different controls. Those are implementation details. If an active worker cannot be redirected safely, obtain a checkpoint and apply the change at the next dispatch boundary. Never ignore new user input, but do not turn every message into a global pause.

### Recovery

When an agent becomes silent or interrupted, first request or recover its latest checkpoint and inspect the actual git diff. Reassign overlapping writes only after the prior writer is known to be stopped or its scope is safely handed off. Do not add a lease protocol or assume that elapsed time proves abandonment.

### MR/PR Pipeline Regression Handoff

`merge-request` resolves the exact created or updated MR/PR head, observes its matching pipeline/check set within its bounded registration window, and owns provider evidence. If no matching checks/pipeline registers by that deadline, it reports an unverified external-state outcome rather than green; do not enter the repair loop without failure evidence. If it reports a failed or cancelled pipeline, first use that evidence to distinguish an in-scope MR-diff regression from a flaky/infrastructure, credentials, or external-state issue.

For an in-scope regression, the original explicit create/update intent authorizes a bounded repair only while it remains inside the established MR scope and risk. Treat the diagnostic bundle as a new implementation phase: verify the failure against the diff, state a proportional repair plan, delegate the tracked repair, run targeted validation, require independent review, and refresh the final suite after the final repair mutation. Then invoke `merge-request` to commit/push/update the same MR/PR and monitor its replacement pipeline. Repeat until green or a genuine blocker or material scope/risk change requires the user.

For flaky/infrastructure failures, let `merge-request` retry only when the provider supports a safe retry and repository/user instructions allow it; do not weaken or skip checks. Credentials and external-state blockers, conflicting instructions, and material scope expansion require a concise evidence-backed question. `merge-request` never writes code, and this lifecycle never asks it to orchestrate repairs: it returns evidence to an active orchestrator run, or a standalone delivery request hands off into this lifecycle before resuming the merge-request skill.

## 6. Review And Fix

Every tracked implementation receives final code review from an independent Strong child pinned at `High`; root at maximum effort adjudicates the findings and completion. Risk controls whether additional specialized review is needed, not whether this final review occurs. If the host cannot safely dispatch the required reviewer without above-High inheritance, report the limitation and do not imply that independent review happened.

Findings should name severity, evidence, impact, and the required correction. Send fixes back to an implementation owner, run the affected targeted checks, and re-review the changed area. Do not repeat the entire review process for unrelated settled code unless a fix changes its assumptions.

## 7. Validate Proportionately

During implementation:

- After a coherent task or phase, run only checks relevant to the behavior changed in that unit.
- Group edits before testing when they are part of one behavior change.
- After a review fix, rerun the check affected by that fix.
- Do not run `FullTestSuite`, an equivalent repository-wide suite, or every available validator after each edit, file, worker, or minor task.
- Respect repository restrictions such as forbidden build commands or required package managers.

At the final completion boundary, after the final tracked mutation and required review:

1. Confirm the intended diff and that unrelated files are excluded.
2. Run the repository's full suite once on the exact final tree when such a suite exists.
3. If the repository has no named full suite, use its broadest normal validation command or plugin validation as the final suite.
4. If a relevant mutation happens afterward, rerun the impacted targeted check and refresh the final suite once on the new final tree.

This completion gate applies whether or not delivery was requested. When PR/MR or other delivery is requested, the same successful run is the final pre-delivery suite.

Do not add a new test framework just to test instruction text. Lightweight syntax, link, manifest, discovery, and plugin validation are enough for an instruction-only plugin unless the repository already provides more.

## 8. Retrospect And Improve

After the required review and successful final suite, and before completion or delivery, the root performs a bounded execution retrospective at its maximum available effort. The root owns this step; do not spawn an agent solely to perform it. Keep it proportional and use only observable evidence already available from the native plan, user messages, assignments and reports, git diff, and check results. Do not reread the entire repository or transcript, expose or reconstruct chain-of-thought, or invent token counts. Use exact token or usage figures only when the host exposes them; otherwise use observable proxies.

Assess both correctness and the total resource cost of reaching a reliable result. Look for:

- a current correctness, requirement, review, or verification gap;
- avoidable rework or duplicate and overlapping reads, searches, commands, or context loads;
- redundant or overlapping agents, oversized child context, or repeated polling;
- serial work that could safely have been batched or parallelized;
- repeated checks without a relevant mutation, premature broad-suite runs, or work done before the final tree that could have waited;
- routing or reasoning that was unnecessarily expensive, or too weak and therefore caused rework.

Root maximum effort is required and is never an efficiency finding. Any child above `High`, child dispatch without an explicit model or, where supported, effort, missing required context isolation, avoidable expensive routing, or redundant or overlapping child work is a retrospective finding.

Optimize total cost across agent context, tool work, validation, and latency while preserving implementation and review quality; raw token minimization is not the goal. Surface at most three findings. For each material finding, state the observable evidence, impact, better approach, and whether it is a current correctness gap, task-specific lesson, or plausibly generalizable process improvement.

If a current correctness or verification gap exists, return it to the implementation owner, correct it, run the affected targeted checks and focused review, and refresh the final suite on the later final tree. Then rerun this bounded retrospective against the now-final evidence before completion or upstream feedback handling. Do not declare completion until the gap is closed. Task-specific or immaterial observations stay in the retrospective and do not become upstream feedback.

Only a material, actionable, plausibly generalizable process improvement qualifies for upstream feedback. For the highest-value candidate only:

1. Before any external search, sanitize client and project names, paths, source, prompts, credentials, secrets, and proprietary details from the candidate, then derive generic, non-sensitive search terms from the sanitized improvement.
2. Search open and closed issues and PRs in the canonical upstream repository, `antstudiocz/ant-marketplace`, using only those generic terms and the active host's authenticated GitHub capability or `gh` when available.
3. If network or authentication is unavailable, report the blocker without blocking the original implementation or authorized delivery.
4. Treat a matching issue or PR as a deduplication result and do not prepare a new issue when either already covers the improvement. Comment on a matching issue only when the run adds materially new sanitized evidence. Generally reference or report a matching PR without writing to it through this issue feedback flow. Only when neither exists, prepare a concise English issue covering observed behavior, evidence and impact, proposed improvement, expected efficiency or quality effect, risks and tradeoffs, and a validation scenario.
5. Perform at most one upstream feedback action per run. Creating, commenting on, or updating an issue is an external write and requires explicit current approval or clearly applicable standing approval; implementation or delivery approval does not imply it. Without that authority, show the prepared candidate and ask instead.

Never auto-create a PR from the retrospective. A PR is a separate maintenance implementation with repository discovery, a concrete approved or otherwise authorized plan, delegated tracked writing, review, final validation, and the host-visible `/ant:merge-request` or `$merge-request` skill. The orchestrator never edits itself automatically.

## 9. Deliver

Before delivery, verify branch, target, final diff, validation results, and the exact actions requested by the user. Stage only in-scope files and follow repository commit/push rules.

- For every PR/MR create or update action, invoke the plugin skill through its host-visible identifier: Claude Code `/ant:merge-request` or Codex `$merge-request`. Pass it the verified summary, checks, target, language/readiness choices already supplied by the user, and unresolved risks.
- After every create/update, let `merge-request` resolve the exact MR/PR head and observe its matching pipeline/check set to a terminal state. If its evidence identifies an in-scope regression, re-enter the bounded repair loop above before asking it to update and observe the replacement pipeline.
- For merge-conflict resolution and related recovery, use Claude Code `/ant:delivery-workflows` or Codex `$delivery-workflows` only.
- A request to commit and push does not imply merge, Draft-to-ready conversion, tagging, publishing, or release unless the user says so.

Finish with the delivered commit/PR/MR state, checks run, and anything that remains unverified. Keep the report concise enough to scan once.
