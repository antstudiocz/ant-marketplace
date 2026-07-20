# Implementation Lifecycle

This is the orchestrator's only internal reference. Apply it with the repository instructions and the capabilities actually available in the current Claude Code or Codex session.

## 1. Discover, Brainstorm, And Approve

Every implementation has a pre-write discovery and planning cycle. Keep it compact for a tiny mechanical change and thorough for new, broad, ambiguous, or risky work; never remove it entirely.

Before any tracked edit or tracked-writer dispatch:

1. Read repository instructions and inspect the current branch, worktree, relevant diff, code path, and validation commands.
2. Separate in-scope changes from unrelated or ambiguous dirty files. Preserve anything the user did not place in scope.
3. Inspect the relevant behavior and contracts or delegate read-only scouts. Do not ask the user for facts that can be discovered safely from the repository or environment.
4. Classify the request as a tiny mechanical change, work already covered by an approved plan, or new/materially changed behavior.

For a fix, refactor, migration, or remediation that does not introduce materially new behavior, state the verified goal or root cause, acceptance behavior, affected areas, implementation steps, risks, and checks in a proportional plan, then obtain explicit user approval.

For a new feature or materially new behavior, continue in this order:

1. Brainstorm with the user about the goal, users, desired workflow, edge cases, non-goals, options, and tradeoffs.
2. Ask every unresolved question whose answer materially changes behavior, scope, architecture, data, safety, validation, or delivery. Group questions clearly, but do not impose an arbitrary count.
3. After receiving the answers, inspect architecture, contracts, data flows, dependencies, obsolete or legacy behavior, risks, and validation paths in greater depth.
4. Present a concrete implementation plan covering acceptance behavior, affected areas, key decisions, implementation sequence, validation, risks, and explicit non-goals.
5. Obtain explicit user approval of that plan before dispatching a tracked writer or making tracked edits.

Read-only scouts may run before approval. They return evidence and options, never implementation changes. The approval applies to the stable plan or workstream, so do not ask again before every phase. Ask again only when a material discovery invalidates the plan or changes its behavior, architecture, risk, or scope.

A tiny mechanical change inside an already approved plan may use a compact cycle: verify the affected code, state the small delta and checks, then continue without duplicate approval. A concrete plan supplied by the user or an approved `create-application` brief may satisfy earlier product brainstorming once repository facts are verified, but the orchestrator must still prepare an implementation plan and obtain approval before tracked writes.

An implementation request by itself is not approval of a plan that has not yet been presented. Plan approval authorizes only the scoped repository edits required by that plan. It does not authorize destructive operations, force-pushes, merges, releases, or unrelated cleanup. Respect any narrower repository or host permission boundary.

Do not create orchestration state files, schemas, event logs, approval artifacts, leases, or migration readers. Use the host's built-in plan/task state and concise user-facing checkpoints. After compaction or resume, reconstruct truth from the conversation summary, current git state, child reports, and fresh inspection.

## 2. Choose The Smallest Useful Shape

Use risk and uncertainty, not task size alone:

| Shape | Typical use | Agents |
|---|---|---|
| Simple | Local, reversible, well-understood change | One implementation owner |
| Standard | Multi-file or cross-component work with moderate integration risk | One implementation lead; optional scout or reviewer |
| High assurance | Architecture, security, permissions, data, migrations, public contracts, broad refactors, or conflicting evidence | Read-only scouts as needed, one implementation lead, disjoint slice workers, independent reviewer |

Rules:

- Before approval, dispatch only read-only discovery or review work. Dispatch tracked implementation owners and slice workers only after the planning gate passes.
- Do not spawn one agent per file, phase-owner agents, or agents whose only job is process bookkeeping.
- One implementation lead owns the final integrated result. A small task may use the same agent as its sole writer.
- Parallelize only independent work with disjoint write scopes and a stable shared contract. Keep a slot available for review or recovery when capacity is tight.
- If nested delegation is unavailable, the root dispatches the same bounded roles directly. Outcome and review quality matter more than matching an agent tree.
- If no writer-capable native delegation is available, stop before any tracked edit and report the blocker. The root remains coordination-only while this skill is active; it never becomes the fallback writer, and it must not pretend independent review occurred.

## 3. Route By Capability

Shared instructions use three capability tiers:

| Tier | Use for |
|---|---|
| Strong | Architecture, ambiguous root-cause work, security/data/permission decisions, migrations, integration ownership, and independent review |
| Balanced | Normal implementation, integration, and repository investigation with bounded ambiguity |
| Fast | Exact searches, read-heavy discovery, deterministic transformations, and other narrow mechanical work |

Choose from models and controls the active host actually exposes. Never make a shared workflow depend on a fixed model identifier. If the preferred tier is unavailable, use the strongest safe available route and state the limitation when it affects confidence. Never silently downgrade judgment-critical work merely to save cost or latency.

Model tier and reasoning effort are related but separate. Select an initial reasoning level that fits the bounded assignment, then reassess it during execution:

Escalate when:

- evidence conflicts or the root cause remains unclear;
- scope crosses an unexpected contract or subsystem boundary;
- validation fails in a new way or repeated attempts do not converge;
- security, permissions, data integrity, concurrency, migration, or external side effects appear;
- the agent must choose between materially different architectures or adjudicate review findings.

De-escalate when:

- the decision is settled and the remaining segment is narrow and deterministic;
- work is a mechanical application of an already verified pattern;
- the next check has a precise expected result and small regression surface.

Do not switch tiers for every small fluctuation. Require a material change in task character, keep the stronger setting through the uncertain segment, and reconsider at the next safe boundary. If the host cannot change a running agent's model or reasoning in place, steer the active agent when possible or apply the new tier to the next bounded dispatch. Codex and Claude Code may expose different controls; preserve these semantics rather than forcing identical mechanics.

## 4. Delegate Clear Work

Every assignment should contain only what the agent needs:

- goal and observable acceptance criteria;
- relevant repository context and constraints;
- allowed write scope and explicit non-goals;
- important decisions already made;
- expected targeted checks;
- conditions that require escalation;
- required report: changes, checks, unresolved risks, and unexpected findings.

Role boundaries:

- **Scout:** read-only; returns concise code evidence, likely root cause, options, and open questions.
- **Implementation lead:** owns tracked edits, integration, targeted checks, and the final implementation report. It may request slices or review.
- **Slice worker:** owns one disjoint bounded write scope and reports back to the lead; it does not redefine shared contracts.
- **Reviewer:** independent and normally read-only; checks requirement fit, correctness, regressions, architecture, negative cases, and validation gaps.

The approved plan is the implementation contract. Include its decisions and acceptance behavior in writer assignments, and escalate rather than silently redefining it.

Pass relevant specialist-skill guidance into assignments when frontend, Laravel, brand, delivery, or another domain requires it. Do not assume a child will discover internal references by itself.

## 5. Execute And Adapt

The implementation owner should:

1. Verify the assigned plan against the real code before writing.
2. Fix the root cause, removing obsolete paths when the approved direction is a clean replacement.
3. Keep edits inside the assigned scope and flag unrelated dirty state immediately.
4. Run targeted checks at meaningful boundaries, not after each file save.
5. Report unexpected complexity early so routing, reasoning, scope, or the plan can be adjusted.

### Mid-flight user messages

Briefly acknowledge new input and classify it by effect:

- **Status or question:** answer without stopping the active implementation.
- **Detail within approved behavior:** incorporate it into the affected current or upcoming work; unaffected work continues and no duplicate approval is needed.
- **Materially new functionality:** pause only affected writes; run affected-scope discovery, user-needs brainstorming, deeper analysis, a concrete delta-plan, and explicit approval before resuming those writes. Unaffected work continues.
- **Correction to approved behavior:** redirect or pause only the impacted work, reassess affected edits and checks, and when the correction is material obtain explicit approval of a delta-plan before affected writes resume. Independent work continues.
- **Explicit stop, replacement request, or blocking contradiction:** stop the affected work; stop the whole run only when the instruction or safety issue is global.

Batch multiple related material changes or corrections received during the same active segment. At the next safe boundary, handle them through one affected-scope discovery, brainstorming, deeper analysis, consolidated delta-plan, and explicit approval instead of one cycle per message. Keep unaffected work moving. Do not defer an urgent stop, safety correction, or instruction that makes continuing unsafe.

Use the host's available transport. Codex may steer an active agent or queue input; Claude Code may deliver follow-up messages through different controls. Those are implementation details. If an active worker cannot be redirected safely, obtain a checkpoint and apply the change at the next dispatch boundary. Never ignore new user input, but do not turn every message into a global pause.

### Recovery

When an agent becomes silent or interrupted, first request or recover its latest checkpoint and inspect the actual git diff. Reassign overlapping writes only after the prior writer is known to be stopped or its scope is safely handed off. Do not add a lease protocol or assume that elapsed time proves abandonment.

## 6. Review And Fix

Review depth follows risk:

- Simple work: the implementation owner performs a focused self-review against acceptance criteria and the diff.
- Standard work: add an independent reviewer when integration, regressions, or uncertainty justify it.
- High-assurance work: independent review is required before final validation.

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

## 8. Deliver

Before delivery, verify branch, target, final diff, validation results, and the exact actions requested by the user. Stage only in-scope files and follow repository commit/push rules.

- For every PR/MR create or update action, invoke the plugin skill through its host-visible identifier: Claude Code `/ant:merge-request` or Codex `$merge-request`. Pass it the verified summary, checks, target, language/readiness choices already supplied by the user, and unresolved risks.
- For merge-conflict resolution and related recovery, use Claude Code `/ant:delivery-workflows` or Codex `$delivery-workflows` only.
- A request to commit and push does not imply merge, Draft-to-ready conversion, tagging, publishing, or release unless the user says so.

Finish with the delivered commit/PR/MR state, checks run, and anything that remains unverified. Keep the report concise enough to scan once.
