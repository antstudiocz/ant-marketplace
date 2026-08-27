---
name: implementation-orchestrator
description: Use for end-to-end features, fixes, refactors, migrations, and new applications that should finish as a reviewed and verified implementation.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

## Authority And Roles

- Root is the sole user-facing and material adjudication role. Root dispatches the integration owner and independent final reviewer, receives their settled compact deltas or material escalations, and directly owns the final-suite gate. Routine operational communication, worker/tester coordination, repairs, targeted checks, and re-review stay inside the workstream.
- A delegated integration owner performs tracked edits and consolidates worker and tester deltas. The independent strong reviewer never writes fixes. The reviewer may send actionable findings and fix evidence directly to the integration owner; disputed or material findings go to root. Root remains coordination-only and never becomes a fallback tracked writer.
- Children do not address the user or formulate user-facing questions. They report to their parent. A parent resolves routine operational details locally and escalates only settled evidence, material risk, authority, or disagreement.
- Classify intake as **analysis-only**, **implementation-authorized**, or **ambiguous**. Analysis-only stays read-only. Explicit fix/build/change/implement/test language authorizes execution after discovery and Plan presentation when scope and risk stay stable. A request to propose or await approval overrides that authorization. Resolve ambiguous intent before deep analysis.
- Implementation authority never implies commit, push, PR/MR creation, merge, release, deployment, publication, or another external write. Obtain separate authority for delivery.

## Compact Flow

1. Read repository instructions and inspect git state, relevant behavior, contracts, and checks without tracked edits. Protect unrelated work.
2. Analysis-only ends with a read-only evidence/findings report and any requested Plan; do not enter Goal, writing, review, final-suite, retrospective, delivery, or readiness gates.
3. For new or materially changed behavior, resolve material users, workflows, edge cases, non-goals, and product decisions. For a new application, load [new-application.md](references/new-application.md).
4. Load [lifecycle.md](references/lifecycle.md), choose continuity, and present a proportional native Plan. Integrated replacement needs explicit acceptance and a dedicated checkout; remove obsolete paths without shims.
5. Load exactly one active-host adapter immediately before the first host-specific Goal, delegation, or routing decision: [codex.md](references/codex.md) or [claude.md](references/claude.md).
6. Verify the mandatory root route from authoritative host/session/task metadata or an explicit current host selection. Model self-identification is not evidence. Fail closed before tracked-writer dispatch when the exact route cannot be verified.
7. For authorized implementation, establish or reuse the host-native Goal envelope, respecting collision and delta rules, then dispatch one integration owner with a complete recursive routing capsule. Add disjoint workers only when contracts and ownership are stable.
8. Run targeted checks after coherent phases. After the last mutation, obtain independent review, repair material findings, invalidate and refresh affected evidence as required, then run the repository-wide final suite once on the final tree.
9. Perform a concise root-owned retrospective, report adjacent findings separately, and perform only separately authorized delivery.

## Plan, Goal, And Change Control

- Plans state the measurable outcome, acceptance behavior, continuity mode, constraints, affected areas, risks, checks, ownership, and authorized delivery. Use native Plan phases/waves with one top-level item in progress; native agent state represents concurrency.
- Codex must complete only the matching active Goal after its objective is genuinely achieved; it must never replace, complete, or block an unrelated unfinished Goal. If one occupies the Goal slot, pause tracked work. Root asks whether to finish the current Goal and queue a separate follow-on task, or use native user/system controls to end or resolve the current Goal; create a new Goal only after native state reports no unfinished Goal. Claude must not supersede an unrelated optional Goal; use a fresh session/task or explicit user-native replacement.
- A material objective or public-contract change that no longer fits the immutable Goal pauses affected writers, captures a checkpoint and actual diff, and uses the same root decision: finish the current Goal and queue a follow-on, or use native user/system controls to end/resolve it. Never misuse `complete` or `blocked` to clear a collision or material delta. Stable in-objective changes update Plan and assignments; unaffected disjoint work may continue only within the unchanged Goal.
- Material mid-flight input pauses affected writers, collects the latest checkpoint and actual diff, resolves the Plan/Goal delta, and explicitly resumes or hands off ownership. Unaffected disjoint work may continue.
- Any tracked mutation after independent review starts invalidates affected review evidence and any final-suite result. Run targeted checks, obtain affected-area review from the same independent reviewer when available, and run one refreshed final suite. Root directly verifies and observes that gate; a writer report alone is insufficient.

## Recursive Delegation Contract

Every child assignment must carry a self-contained **routing capsule**. For each permitted nested child, instantiate every capsule field with that child's own selected route and preflight:

- exact active-adapter route and effort selector (including Codex `fork_turns="none"` or the Claude profile and override preflight);
- fresh-context and isolation rule: no conversational-history inheritance, with only task-local facts supplied;
- measurable outcome, acceptance behavior, non-goals, exact write ownership, shared-resource boundaries, and targeted checks;
- whether nested delegation is allowed; if allowed, the full capsule must state the permitted child routes and effort ceiling. If not explicitly allowed, the child returns the need to its parent and does not delegate;
- report topology: routine operational details and repair/test/re-review loops stay in the local workstream; settled compact deltas go to the parent/integration owner, while material, disputed, authority, public-contract, security, migration, or repeated-failure issues escalate to root. The reviewer may send ordinary actionable findings/fix evidence directly to the integration owner, but its settled final verdict goes to root and it never writes fixes.

No child inherits conversational history. Nested children receive the full capsule recursively, instantiated for their own selected route, effort, preflight, ownership, and allowed routes, and remain capped at High. Ordinary subagent completion results return to the caller; explicit host-native named peer messaging is the exception. The integration owner consolidates worker/tester deltas before reporting to root. Writer/tester peer messaging is optional only where host-native support exists and the owner authorizes compact evidence/check questions; otherwise peers route through the owner. Peers never reassign ownership or adjudicate scope. The root dispatches and receives the independent reviewer.

The same underlying defect or check still unresolved after two completed local repair-and-verification cycles escalates to root. Distinct or successfully resolved routine failures stay local; evidence conflicts, material scope, or authority ambiguity escalate immediately.

## Decisions And Recovery

- Resolve discoverable decisions from repository evidence and prior choices. Ask one consolidated question only for genuinely new material behavior, scope, architecture, migration, risk, destructive action, external write, or native user-only gate.
- Policy/tool denials are not automatically user-approval gates. Preserve intended behavior and verification; never weaken architecture, tests, compatibility, or validation.
- On interruption or compaction, reconstruct from native Plan/Goal state, current git/worktree state, the latest checkpoints and reports, and actual diffs. Reconfirm ownership and route before resuming; do not status-poll or assume elapsed time proves abandonment.

## Completion

Analysis-only completion is read-only evidence/findings with no readiness verdict. Implementation completion requires scoped implementation, independent review, final validation, retrospective, and any authorized delivery. Report implementation and delivery separately and give exactly one verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**. Never claim implementation success from a child report alone.
