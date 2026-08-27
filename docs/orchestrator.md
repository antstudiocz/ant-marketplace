# Orchestrator Setup

Use `implementation-orchestrator` when a task should be taken from repository discovery through verified implementation and optional delivery.

## First Use

1. Install the plugin from [the installation guide](install.md).
2. Start a new Claude Code or Codex session.
3. Set up the active host, then invoke the skill:
   - Claude Code: establish `best` + `max` for the session with `claude --model best --effort max`, or `/model best` and `/effort max`; then invoke `/ant:implementation-orchestrator`
   - Codex: select or verify the root for the task/session, then invoke `$implementation-orchestrator`; its adapter pins child spawns and requires native Goal tools before tracked-writer dispatch
4. Provide the goal, repository or path, relevant constraints, and any delivery request.

The orchestrator classifies execution intent, discovers repository facts before asking questions, presents a concrete plan before tracked edits, establishes a native goal for implementation work, keeps review proportional to risk, and reflects on the verified execution before completion or delivery.

## Planning And Approval

At intake, the orchestrator classifies the request as analysis-only, implementation-authorized, or ambiguous. “Analyze only” stays read-only. Explicit action language such as “fix it and test it end-to-end” authorizes implementation after discovery and plan presentation when the plan remains within the requested scope and risk. If intent is genuinely ambiguous, it asks early whether the user wants analysis only or implementation too.

Every implementation starts with read-only repository discovery and a proportional plan before tracked edits. A tiny mechanical change may need only a compact code check, stated delta, and validation plan; planning is still present unless the change is already covered by an approved or otherwise authorized plan.

For a new feature or materially new behavior, the sequence is:

1. inspect the repository and relevant code paths;
2. brainstorm the goal, users, workflow, edge cases, non-goals, options, and tradeoffs with the user;
3. ask all material questions that cannot be answered from the repository, without an arbitrary question limit;
4. after the answers, analyze architecture, contracts, data, dependencies, obsolete behavior, risks, and validation more deeply;
5. present a concrete implementation plan;
6. dispatch tracked implementation work when explicit execution intent covers the unchanged scope and risk, or otherwise wait for explicit approval.

Read-only scouts may help before execution is authorized. Fixes and refactors without new behavior use a shorter root-cause, impact, steps, risks, and checks plan. A user-provided concrete plan or approved `create-application` brief can satisfy earlier product brainstorming after repository verification, but neither grants write authorization by itself. The orchestrator still prepares and presents an implementation plan. It pauses when the user requested a plan or approval gate, or when discovery materially changes behavior, scope, architecture, data, safety/risk, or requires destructive action. Authorization covers the stable workstream, not every phase or delivery action. Implementing and testing behavior intended for production does not itself authorize deploying, publishing, releasing, running a production operation, or causing an external side effect.

Root is the sole user-facing adjudicator. Delegated agents never communicate with the user or formulate questions for the user; they send evidence, options, a recommendation, and the affected paused scope only to their parent until root can resolve the decision. Root checks repository evidence, the stable authorized plan, and prior user choices first, then batches all genuinely new material behavior/scope/risk decisions, uncovered destructive/external/delivery actions, or real native user-only host approvals into one concrete question. An immediate ordinary “yes” or “continue” is sufficient—there is no required magic sentence.

A declined patch, `fileChange`, or policy classification is not itself a native user-only approval gate. The orchestrator keeps the intended architecture, behavior, tests, validation, and compatibility unchanged, using only coherent in-policy mechanical steps or reporting a blocker; it never adds a fallback, workaround, weaker semantics, or patch split to bypass policy. If the correct solution genuinely needs new authority, root asks once.

### Implementation Continuity

After initial read-only discovery and before the concrete plan, it first honors any already explicit continuity choice. Otherwise, it decides whether continuity materially changes the local implementation sequence. If not, it records incrementally verifiable checkpoints without a ceremonial question; if it does, it asks once between incrementally verifiable checkpoints and integrated replacement, with a context-based recommendation. Integrated replacement optimizes for the final architecture and can leave the checkout intentionally unusable between integration boundaries; it needs explicit acceptance and a checkout dedicated to that implementation. A separate worktree is preferred but not required; a root checkout is allowed, and unrelated dirty changes remain protected.

This choice controls only intermediate local edit order and validation boundaries. It never removes targeted checks, independent review, the final suite on the exact final tree, delivery safety, backwards compatibility, rolling deployment, or deploy-safe data/API migrations. The selected mode and implications are included in the plan, native goal, and writer assignment. A material later change follows the normal delta-plan and risk gate.

After discovery and before tracked-writer dispatch, implementation work uses the host's native Plan and Goal. The Plan records phases or waves, dependencies, continuity mode, acceptance behavior, checks, and authorized delivery, with one top-level item `in_progress`; concurrent workers are represented by native agent/thread state. The Goal captures the measurable outcome, acceptance conditions, material constraints, required checks, and only delivery already authorized. These native controls complement planning and authorization; they do not replace them. Analysis-only and unresolved ambiguous requests never create a Goal. Codex requires native Goal tools, inspects and reuses a matching active Goal or creates one, and fails closed before tracked edits when those tools are unavailable; an unrelated Goal pauses tracked work for user resolution. Claude Code likewise requires an observable native Goal and Plan and never substitutes slash commands or pseudo-state. Stable in-scope follow-ups amend the active Plan and Goal; material scope, contract, behavior, or risk changes require a delta decision and authorization. In either host, the Goal closes only after the scoped implementation, required review, final validation, retrospective, and any included delivery are complete.

## Quality and deterministic tests

During read-only discovery, before the continuity decision or concrete plan, derive only the material quality attributes and constraints evidenced by the repository and request. Record them with the lighter/heavier rationale in the Plan and relevant writer/reviewer assignments. Select the smallest durable solution, state why a lighter option would be unsafe or a heavier option unnecessary, and do not claim performance or scalability without measurements or verified constraints. Both the implementation lead and independent reviewer look for expedient shortcuts/hidden debt and speculative overengineering, unneeded abstractions, or dependencies.

For authored or changed async/concurrency-sensitive tests, synchronize on observable state/events; use timeouts only as failure bounds; isolate uniquely owned data/state; clean up config, globals, mocks, timers, processes, browser contexts, and DB state; prefer virtual time; and exercise relevant CI-like concurrency/environment with repeat, shuffle, or seed where applicable. Retries are diagnostic/classification only. Never fix flakes with sleeps, timeout inflation, skipped/weakened assertions, reduced meaningful coverage, or hidden failures. Recommend heavy performance/fault scenarios for benchmark/nightly/manual use when appropriate while MR validation covers the smallest representative invariant. Repeated evidenced violations may be reported as a repository lint/ratchet/enforcement recommendation, never added automatically.

## Runtime smoke and adjacent findings

For executable, runtime, or user-visible changes, the Plan names the smallest realistic smoke scenarios: environment and preconditions, exact flow, expected observables, side effects/auth/data constraints, cleanup, and evidence. After the final suite and before readiness, discover actual host/repository capabilities and offer every applicable available surface with its concise implication, exactly one evidence-based recommendation, and the user's choice. Honor an explicit prior tool choice; do not list unavailable or inapplicable options. If only one surface exists, offer it transparently; if none exists or smoke is not meaningful, say N/A and why.

The offer states exactly which flows will be tested and what evidence will be captured. Smoke supplements automated validation. After selection, report the tested environment/head, expected versus observed outcomes, gaps, side effects, and screenshots for meaningful checkpoints/failures when supported, protecting secrets and private data. A required failed, unavailable, or declined smoke is an unverified prerequisite and prevents a ready/deployed-and-verified verdict; optional smoke declined after being offered is unverified without inventing a blocker. A smoke-discovered gap returns to implementation, and any later mutation requires targeted checks, focused review, a refreshed final suite, and repeat of affected smoke.

Keep all verified, material, actionable adjacent codebase findings separate from the root execution retrospective. Report all findings discovered naturally (no arbitrary count cap), grouped/prioritized when numerous, each with evidence/location, impact, direction, and urgency. Exclude speculation, duplicates, and cosmetic nits. Fix or lower/block readiness for a finding that is a current correctness, requirement, or verification gap; never silently expand scope. The retrospective retains its existing at-most-three process findings.

## Execution Shape

The workflow deliberately stays small:

| Work | Default shape |
|---|---|
| Local and well understood | One implementation owner, then final independent review |
| Multi-file or moderately uncertain | One implementation lead, optional scout, then final independent review |
| Architecture, security, data, migrations, or broad contracts | Scouts as needed, one lead, disjoint slices, independent reviewer |

Claude Code and Codex may use different delegation trees. If nested agents are unavailable, the root dispatches the same bounded work directly. If no writer-capable native delegation is available at all, the root remains coordination-only and stops before tracked edits with a blocker. The acceptance criteria and review bar stay the same.

Parallel backend, frontend, test, research, and implementation workers are supported when their write scopes are disjoint and shared contracts are stable. One integration lead owns shared files and contracts. Related agents keep raw logs, large diffs, debug history, repeated tool calls, and local failures in their own repair loops, returning root only compact knowledge deltas: outcome, contract changes, new facts or invalidated assumptions, evidence location, residual risk, decision needed, and paused scope. Root reopens coherent artifacts only for adjudication or final verification.

Codex examples: simple work follows root discovery → proportional native Plan → native Goal → one Luna implementer performs focused verification, implementation, and targeted tests → independent Sol High review → final validation, retrospective, and authorized delivery. Larger or ambiguous work follows parallel Luna scouts → stable contracts and a workstream wave → a Luna High integration lead owning stable shared files/contracts plus disjoint Luna backend/frontend/test workers → peer repair loops and knowledge-delta summaries → independent Sol High review → final suite, retrospective, and authorized delivery. Only high-risk or cross-contract integration judgment escalates to Sol High. An implementer may spawn a disjoint helper or reviewer where native delegation allows, but the final reviewer must be independent.

For Codex, nested lead/worker delegation can use:

```toml
[agents]
max_depth = 2
```

This is optional. Restart Codex or open a new session after changing its configuration.

## Capability Routing

Shared instructions route by capability rather than fixed model identifiers:

- **Strong:** architecture, difficult root-cause analysis, security/data decisions, migrations, high-risk or cross-contract integration judgment/adjudication, and independent review.
- **Balanced:** normal implementation, integration, and repository investigation.
- **Fast:** exact searches, read-heavy discovery, and deterministic mechanical work.

The shared skill stays semantic and loads exactly one host adapter before any routing decision. Concrete Codex model names belong to the active Codex policy; Claude uses stable aliases. The shared lifecycle remains host-neutral.

### Codex

Select or verify Codex root at task/session level: the active policy is `gpt-5.6-sol` at High. Native spawn selectors cannot change an already-running root; they pin Strong children to Sol at High and every other child to `gpt-5.6-luna` at proportional High, Medium, or Low. There is no Terra route or fallback. Every child and nested child remains at High or below and never inherits root High. Every Codex dispatch, including nested dispatch, sets `fork_turns="none"`; omitted, `all`, and positive bounded-history values are not allowed. Give the child a concise, self-contained assignment with every task-relevant fact. If a history-free child meets a genuine host provenance gate it cannot satisfy, it reports one blocker to root; the workflow does not retry with inherited history, let root edit, or treat relayed approval as native provenance. If root control is unavailable, report that the Sol High route is unverified; if Sol, Luna, the requested child effort, or `fork_turns="none"` cannot be enforced, do not dispatch.

### Claude Code

Set `best` + `max` before invocation and keep it for the entire multi-turn workflow; skill or command frontmatter cannot guarantee the root selection. `best` resolves to Fable when available, otherwise the latest Opus. Do not use `opusplan` for root because it switches to Sonnet during execution.

Bounded children use the plugin-scoped profiles in `plugins/ant/agents/`: `ant:strong-high` (`opus` + high), `ant:balanced-high`, `ant:balanced-medium`, and `ant:controlled-low` (Sonnet at the named effort), and `ant:fast` (Haiku). Haiku has no effort selector, so use it only for narrow, non-judgment-sensitive work; use `ant:controlled-low` when explicit effort control is required.

Before dispatch, complete an observable, fail-closed preflight. Choose the exact plugin profile and pass no conflicting per-invocation model (it is absent or exactly the profile alias/model). Inspect `CLAUDE_CODE_SUBAGENT_MODEL`: accept only unset or the exact profile alias/model. `inherit` is a blocking override because it selects the parent model; any other value also blocks. For fixed-effort profiles, inspect `CLAUDE_CODE_EFFORT_LEVEL` and accept only unset or the exact intended `low`, `medium`, or `high`; `auto` blocks. For `ant:fast` (Haiku, with no effort support), require no fixed effort override; unset or `auto` is acceptable. When host-visible organization `availableModels` or effort caps are surfaced, verify they allow the exact model and intended effort. If the state required to prove the route cannot be observed, block and report rather than claim enforcement. A clamp, replacement, allowlist fallback, or environment override blocks dispatch even when it stays at or below High. If UI, task metadata, or transcript later exposes a model or effort mismatch, immediately stop or cancel the child, discard its result, and report it; this is secondary to, never a substitute for, the preflight.

## Reasoning And Dispatch

Capability tier and reasoning effort are separate selections. Root uses the strongest capability and the model/effort defined by the active host adapter for the entire orchestrated run. If the host cannot expose or set that adapter-defined control, root uses the strongest available root setting and reports the limitation without claiming adapter enforcement.

Every child dispatch pins a native model and, where that model exposes an effort selector, a supported effort explicitly. Children may use Low, Medium, or High effort, but never a host-specific level above High. A Strong child therefore does not imply above-High effort. Every assignment is concise and self-contained with the task-relevant facts; do not depend on inherited conversation history. Codex always dispatches with `fork_turns="none"`, including from nested children. If the host cannot prevent above-High inheritance or required context isolation safely, the child is not dispatched and the limitation is reported.

Typical assignments are High for implementation leads, independent review, and warranted architecture or security work; Medium for normal scouts, slices, checks, and delivery support; and Low or Medium for search and inventory. A child that cannot resolve work within High narrows or splits the assignment or returns the judgment to root. Final code review is Strong at High, while the execution retrospective remains root-owned at the adapter-defined route.

Before spawning, the orchestrator checks whether an active agent already covers the same goal, evidence, and output. It steers that agent instead. New agents require materially distinct scope or evidence; overlap is reserved for intentional independent review with a distinct focus.

## Messages During Implementation

You can continue messaging the orchestrator while it works. Status questions and details within authorized behavior do not stop work. Related material changes or corrections received during the same active segment are batched into one discovery, brainstorming, deeper-analysis, consolidated delta-plan, and approval cycle for the affected scope at the next safe boundary; only affected writes pause while independent work continues. An urgent stop or safety correction applies immediately. The entire run stops only for an explicit global stop/replacement or a genuinely blocking contradiction or safety issue.

Codex steering/queue controls and Claude Code message delivery are host-specific transport details; both follow the same behavior above.

## Validation

During implementation, the orchestrator runs checks targeted to each coherent phase. It does not run `FullTestSuite` or every repository check after each edit or small task.

After the final tracked mutation and required review, it runs the repository's full suite once on the exact final tree before declaring the implementation complete, whether or not delivery was requested. When delivery is requested, the same run is the final pre-delivery suite. A later relevant edit invalidates it: the orchestrator reruns the impacted check and refreshes the final suite once. For this marketplace, the two Claude plugin validations are the final broad suite.

## Execution Retrospective

After the final suite and before completion or delivery, root performs a bounded retrospective using evidence already present in the plan, messages, assignments and reports, final diff, and check results. It checks for a current correctness or verification gap and for avoidable total cost: duplicate reads or commands, overlapping agents or context, repeated polling or checks, work that could safely have been batched or deferred, premature broad validation, and reasoning or routing that was either needlessly expensive or too weak and caused rework. It preserves quality, reports at most three findings, does not reconstruct hidden reasoning, and does not invent token figures.

A current implementation gap returns to the implementation owner and invalidates the final suite until the correction, targeted checks, focused review, and refreshed suite pass. Only a material, actionable, plausibly generalizable process improvement can become upstream feedback. Before any external search, root removes client, project, and proprietary details from the candidate and derives generic, non-sensitive search terms. It then uses only those terms to search open and closed issues and PRs in `antstudiocz/ant-marketplace` and proposes at most one highest-value issue action. Creating or commenting on an issue requires explicit current or clearly applicable standing approval; implementation or delivery approval is not enough. Missing network or authentication does not block the original result.

The retrospective never creates a PR automatically. A PR is a separately authorized maintenance implementation and uses the host-visible merge-request skill after its own discovery, implementation, review, and validation.

## Delivery

The orchestrator performs only the delivery actions the user requested. For PR/MR creation and updates it invokes the host-visible skill identifier: Claude Code `/ant:merge-request` or Codex `$merge-request`. An explicit create/update request lets that skill make the safe scoped commit/push/new-MR-or-PR-Draft-by-default chain, preserve readiness on ordinary updates, and watch the matching pipeline/check set for the resolved head within a repository-appropriate bounded registration window; preparation intent returns only a preview. If no matching check/pipeline registers, it reports an unverified external-state outcome rather than green. If the pipeline evidence shows an in-scope MR-diff regression, the orchestrator delegates the bounded repair, validation, independent review, and final-suite refresh before returning delivery to `merge-request` for the update and replacement-pipeline observation. For merge conflicts it uses Claude Code `/ant:delivery-workflows` or Codex `$delivery-workflows` only. Merge, Draft-to-ready conversion unless explicitly ready, tag, publish, release, rebase, force-push, and history rewrite are never implied by PR/MR creation.

The final report includes the changed areas, checks run, unverified items, retrospective outcome, any material upstream issue URL or candidate, and current commit/PR/MR state.
