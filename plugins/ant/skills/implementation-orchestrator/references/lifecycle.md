# Implementation lifecycle

This reference owns shared orchestration policy. Apply repository instructions first and scale the process to risk. The durable plan is human-readable Markdown tracked in Git; it is coordination evidence, not a runtime or machine state store.

## Plan and authority

- Inspect repository instructions, worktree/index state, contracts, risks, and affected checks before tracked edits. Preserve unrelated changes.
- Classify intent as analysis-only, implementation-authorized, or ambiguous. Analysis-only work stays read-only. Separate implementation authority from delivery authority.
- For new or materially changed behavior, resolve material decisions that the repository and environment cannot answer. Ask only those questions; an unresolved decision blocks its affected scope.
- Root may ask material questions asynchronously during planning or implementation. An unresolved decision pauses only its affected scope; independent authorized work may continue. Questioning never expands host mode or permission bounds.
- During implementation-authorized work with an existing plan, record each pending decision, its optional-preference or required-decision/approval status, and affected scope in the plan and assignments. After a reasonable opportunity to answer, an optional preference may use a stated reasonable assumption; silence or a default option never supplies required consent. Required scope stays pending until the answer or approval arrives.
- During implementation-authorized work with an existing plan, reconcile answers before affected work continues, including late replies: update the plan, affected assignments, and evidence, then re-check any decision-bound work.
- Root creates and owns one plan bundle at `docs/implementation-plans/YYYY/MM/<slug>/README.md` before tracked implementation. It records scope, acceptance, non-goals, continuity, findings, decisions, ownership, risks, checks, phase/status, and the next action. Supporting files are optional and complementary.
- Root alone writes the plan bundle and its progress/checkpoint files. The plan is the lifecycle record; prose status or assignments are not substitutes.

The plan and any required native Goal must describe the same measurable outcome. A stable in-scope change updates the plan. A material outcome or public-contract change pauses the affected work and resolves the Goal/authority before resuming.

## Goal and continuity

- Choose continuity before implementation: in-place evolution, an explicitly accepted integrated replacement in a dedicated checkout, or isolated handoff.
- For every Codex implementation, inspect the native Goal after the plan is ready. Reuse a matching active Goal; if none exists, create one automatically under established user/host authorization for automatic Goal creation, without asking again, then reinspect it.
- Never replace, complete, or block an unrelated active Goal. If the host cannot create or verify the required Goal, report the concrete blocker and stop tracked dispatch; host permissions and controls take precedence over skill instructions.
- Codex Goal closure is terminal (`complete` or `blocked`). Do not use it to simulate phase progress; the plan remains authoritative. Optional native Goal behavior on other hosts applies only when that host confirms it is in use.

## Dispatch capsule

Every child assignment, including a permitted nested child, must state:

- exact active-adapter model/profile and effort, with Codex `fork_turns="none"`;
- fresh isolated context with no history inheritance;
- measurable outcome, acceptance, non-goals, exact write ownership, shared-resource boundaries, and targeted checks;
- plan directory is root-write/child-read-only;
- nested delegation yes/no; if yes, allowed routes and ceiling plus the same capsule; if no, return the need to the parent and do not delegate;
- report path: phase/status, files or areas, checks and results, discoveries/decisions, proposed plan delta, and risks/blockers.

Every child is capped at High. If route, effort, availability, freshness, isolation, or required metadata cannot be enforced, stop before tracked work. Routine repair, testing, and re-review stay with the current owner; material, disputed, authority, security, migration, public-contract, or repeated-failure issues go to root.

Escalate the same underlying defect or check after two completed local repair-and-verification cycles. Evidence conflicts and authority ambiguity escalate immediately.

## Implementation, review, and candidate

- Dispatch one integration owner. Add workers only for disjoint ownership. The owner writes and consolidates scoped source, configuration, tests, and general documentation; root coordinates and adjudicates.
- Run checks affected by each coherent change. Do not repeat equivalent checks without a new change, failed evidence, or a risk reason.
- An independent strong reviewer reads the candidate and never writes fixes. A tracked mutation after review invalidates affected review and candidate-bound evidence; repair, rerun targeted checks, and obtain affected-area re-review.
- Before freeze, root records the final plan checkpoint and identifies one immutable candidate (tree/SHA). Select one broad final gate using blast radius, reversibility, test confidence, and environment parity. Use qualifying exact-candidate CI only when its tested SHA mapping, coverage, required jobs, and terminal success are authoritative; otherwise run the appropriate local broad gate. Missing or mismatched CI is unverified.
- Do not edit the plan or implementation after freeze without creating a new candidate and refreshing affected evidence.
- Interactive smoke is optional unless explicitly requested or required by acceptance/repository rules. If required, the active adapter preflights environment, auth/data, side effects, cleanup, and evidence.

## Recovery and completion

After interruption or compaction, reconcile the plan with Goal state, git state, native task state, reports, findings, and the actual diff. Correct stale phase/ownership information, update the plan checkpoint, and resume only with current evidence.

Root verifies the selected final gate, records the retrospective, and gives exactly one verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**. Delivery, merge, release, and deployment remain separately authorized and belong to `merge-request`.
