# Provider delivery and observation

Read only the sections relevant to the requested mode. The [skill entrypoint](../SKILL.md) owns mode and authority boundaries.

## Description

Use Conventional Commit titles and concise English by default, subject to the resolved repository/user language. Build the description from the complete final target merge-base-to-`HEAD` diff and refresh it when that snapshot changes. Never add AI attribution or co-author trailers.

Every PR/MR body covers four substantive parts; localized headings or repository-template equivalents are fine:

- **Summary:** the problem and resulting behavior.
- **Rationale:** why the change is needed.
- **Impact/risk:** material compatibility, rollout or dependency risks, or no material risk identified.
- **Verification:** actual checks and results, pending gates and unavailable evidence.

Keep failures and material gaps visible; empty headings or a generic all-green claim do not satisfy this contract.

## Create/update

Stage only scoped paths/hunks. If mixed or pre-staged work cannot be safely isolated, pause the affected write. Validate the candidate or reuse fresh candidate-bound evidence under the [lifecycle](../../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate).

Use structured arguments or a temporary UTF-8 file for multiline bodies so shell interpolation cannot alter their content. Keep temporary files outside the worktree. Metadata-only updates need no source commit or push.

## Exact-head observation

- Set one finite registration-and-observation budget per attempt. Source or target changes consume the remaining budget; re-read provider state and refresh affected evidence rather than resetting the timer.
- Record provider source SHA and actual tested SHA separately, with authoritative mapping between them. GitHub exposes the PR `headRefOid` and check commit, possibly a test-merge commit; GitLab may test the MR head or a merged result. A pipeline's name, branch or success alone does not establish that mapping.
- Missing mapping or required test-merge evidence, absent/pending checks, and skipped, neutral, timed-out or mismatched results are unverified. Claims that no checks are required, or that CI replaces a local gate, must meet the [lifecycle's candidate criteria](../../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate).
- Report source/tested SHA, target, pipeline/check identity, status and useful failure diagnostics. Classify failures as current-diff, infrastructure, credentials or external state; observation itself never retries or repairs.
- Observe/status failures are report-only and need a separate fix request. During Create/update, hand an in-scope regression to the orchestrator only under existing implementation/repair authority; otherwise leave repair pending. Its lifecycle owns repair, review and escalation. Retry permission and scope expansion remain separate decisions.
- Budget expiry leaves the broader endpoint pending. Return to the owning workflow for host-permitted continuation, or report that continuation is unavailable; do not invent automation or poll indefinitely.

## Release notes

For an authorized release, link the relevant merged PRs/MRs included in the released commit. Verify both merged state and inclusion. When several contributed, also link a comparison of the verified previous and current release tags. With no previous release, omit that comparison. Keep the notes concise; links provide the detail.
