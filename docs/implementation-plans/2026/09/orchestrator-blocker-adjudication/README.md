# Orchestrator blocker adjudication

## Scope and endpoint

Implement the user's agreed clarification of reviewer disagreement, child uncertainty,
capability failures, and explicit tool/host denials, then deliver a draft GitHub PR
against `master`. Existing scoped implementation and PR delivery authority apply.
No release, version bump, merge, deployment, or permission configuration change.

## Acceptance and evidence

- Root adjudicates ordinary findings with evidence without waiving unmet outcomes.
- Existing consent is preserved; an explicit host denial is not overridden by root.
- Materially safer alternatives address the stated risk; unrelated authorized work
  continues, and changing tools or agents does not bypass a denial.
- Assignments cover coherent dependencies; children escalate scope deltas internally.
- Codex children use native parent messaging, with verified thread IDs only for
  actual independent task handoffs.
- Shared policy remains in lifecycle.md; Codex tooling stays in codex.md. Public
  documentation links to those owners. Three public skills and versions stay intact.

Use an incremental, single coherent instruction edit followed by independent Sol
High review. Review representative cases: disputed finding, missing child context,
tool timeout, explicit denied action, materially safer alternative, and newly found
cross-file dependency. Validate both plugin manifests and JSON as the final gate;
also run the existing skill frontmatter validator and diff whitespace checks.
No synthetic test framework or runtime is needed.

## Ownership and progress

Root owns this plan, Git delivery, verification and readiness. Fresh Luna High owner
writes only scoped lifecycle/adapter/public documentation; independent fresh Sol
High reviewer is read-only. Children cannot edit this plan or delegate further.

Baseline: clean checkout, branch `fix/orchestrator-blocker-adjudication` from fetched
`origin/master` (`7685bbc`); provider confirms `master` as default.
Native Goal was not requested and is not used. PR observation budget: three minutes
after creation, without retries or a readiness change.

## Final implementation checkpoint

The owner completed lifecycle classification/adjudication, actual-effect authority,
coherent dependency boundaries, Codex parent communication, and linked public
summaries in four files. README and installation guidance remain aligned without
edits. No manifests, versions, public skills, runtime or host settings changed.

Independent Sol High review passed with no blocking findings across all six
representative cases above. This was static instruction/scenario review, not an
end-to-end execution of future agent behavior. The final policy preserves
independent candidate review and all host refusal boundaries.

Validation passed: `claude plugin validate .`, `claude plugin validate ./plugins/ant`,
`jq empty` for all four repository manifests, skill-creator `quick_validate.py` for
implementation-orchestrator, and `git diff --check`. No runtime tests are applicable
to this instruction-only change. The final plan checkpoint is included in the
candidate; commit/push/draft creation and finite provider observation follow.

Retrospective: classification belongs in shared lifecycle, native messaging in the
adapter. Replacing the earlier rejection paragraph and linking summaries avoided
duplicating a second approval workflow. Draft delivery remains distinct from merge
readiness and does not authorize release or merge.
