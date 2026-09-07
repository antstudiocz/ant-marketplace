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
- Record the requested endpoint in the plan as implementation-only, draft PR/MR create/update, or explicitly merge-ready before dispatch. Keep the endpoint measurable through review, candidate evidence, provider state, and any required external gates.

The plan and any native Goal, when one is established, describe the same measurable outcome. A stable in-scope change updates the plan. A material outcome or public-contract change pauses the affected work and resolves the Goal/authority before resuming.

## Cross-thread handoff

- A handoff for already-authorized work must carry the relevant original user consent wording, a reference to its source when available, the approved repository/PR/action scope and bounds, the exact follow-up requested, and any proposed scope delta.
- The receiving agent verifies the original evidence and current host/provider state before acting. Forwarded text or quotes provide context to verify; they do not create new user consent, host approval, or delivery authority.
- If the source is missing or inaccessible, report that limitation truthfully. Existing independently established authority may continue in scope; pause only an action that depends on the missing proof or an unresolved scope interpretation and escalate it to root/user.
- A handoff never promises automatic review acceptance or a bypass. After an automatic approval rejection, follow the host's refusal instructions; forwarded consent or existing authority does not justify retrying the rejected outcome. Use a materially safer alternative or new approval only when the host permits it. Ordinary reviewer findings remain reportable and repairable only under already-established authority.

## Goal and continuity

- Choose continuity before implementation: in-place evolution, an explicitly accepted integrated replacement in a dedicated checkout, or isolated handoff.
- The active host adapter owns whether native Goals are default-on or optional and how their tools are preflighted. When the adapter calls for Goal handling, inspect the actual slot after the plan is ready and classify the result before implementation:
  - A verified matching active Goal may be reused.
  - A verified empty slot or a slot containing a terminally completed Goal, with no unfinished unrelated Goal collision, permits creation when the adapter and host authorize it. A verified empty slot or an unavailable optional capability, permission, or creation authority permits otherwise-authorized work to continue under the root-owned plan. Record the native Goal as absent or unavailable as applicable and state that automatic continuation is not guaranteed.
  - An unknown or unverifiable slot is reported as unverified; do not call it absent or claim that a Goal exists. Otherwise-authorized work may continue under the plan only when the adapter and host permit that optional fallback.
  - An unrelated active Goal is preserved. Root separately assesses safe isolation and host continuation before affected work proceeds; never continue through or repurpose the unrelated Goal.
- An explicit user requirement for a native Goal remains unmet until a matching Goal is established and verified; the durable plan is not a substitute. The plugin never grants consent. Analysis-only work stays read-only and does not create or advance a native Goal. A durable Markdown plan preserves coordination memory but does not provide native scheduling or continuation.
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
- Classify the requested endpoint as **implementation-only**, **draft PR/MR create/update**, or **explicitly merge-ready**. Implementation-only ends at the reviewed, checked local candidate. Draft create/update ends at the requested draft provider object with a truthful current source-head snapshot. Explicit merge-ready completion requires, on the final current provider source SHA, the scoped implementation, current independent review, conflicts resolved against the current target, every required CI/provider gate configured for the repository/provider successful with authoritative exact-SHA mapping, and no unresolved material blocker. If the repository/provider declares that no such gate is required, record that fact; missing or unavailable evidence for a required gate is unverified. Local checks, a draft URL, conditional readiness, stale-head evidence, missing source/test mapping, pending or absent required CI, or an observation timeout leave that endpoint pending.
- Provider exact-head observation follows the finite budget and continuation rules in [provider-delivery.md](../../merge-request/references/provider-delivery.md); expiry leaves an explicit merge-ready endpoint pending. Preserve candidate validity after freeze and refresh affected evidence when the source candidate or target changes.
- Interactive smoke is optional unless explicitly requested or required by acceptance/repository rules. If required, the active adapter preflights environment, auth/data, side effects, cleanup, and evidence.

## Recovery and completion

After interruption or compaction, reconcile the plan with actual native Goal state when available, git state, native task state, reports, findings, and the actual diff. Apply the same Goal classification: verified absence is absent, an unavailable optional capability is unavailable, and an unknown or unverifiable slot is unverified. Preserve unrelated Goals and separately reassess safe isolation and host continuation before resuming affected work. Mark a matching native Goal complete only when the requested endpoint is proven; an explicit native Goal requirement remains unmet until verification succeeds. Correct stale phase/ownership information, update the plan checkpoint, and resume only with current evidence; any optional fallback reports that automatic continuation is not guaranteed.

Root verifies the selected final gate, records the retrospective, and reports the requested endpoint, the actual outcome (**achieved**, **pending**, or **blocked**), decisive evidence, remaining gaps, and the next permitted action. Apply the endpoint criteria above. Deployment is achieved only when explicitly authorized and verified, and remains separately owned by `merge-request`.

Use **pending** when endpoint evidence or an allowed follow-up is incomplete, including a finite observation timeout. Use **blocked** only for a genuine unresolved decision, authority, capability, or host-defined repeated-blocker condition; a prose outcome does not mutate or close a native Goal. Complete a native Goal only when the requested endpoint is proven, and mark it blocked only under the active host adapter's threshold and terminal rules.
