# Provider delivery and observation

Read only the sections relevant to the requested mode. The [skill entrypoint](../SKILL.md) owns mode and authority boundaries.

## Description

Use Conventional Commit titles and concise English by default, subject to the resolved repository/user language. Build the description from the complete final target merge-base-to-`HEAD` diff and refresh it when that snapshot changes. Never add AI attribution or co-author trailers.

Every PR/MR body has visible `Summary`, `Rationale`, and `Impact/risk` sections in that order. Put the exact `## Release notes` section immediately after the visible impact/risk section. Keep material risks, failed checks, pending gates, and unavailable evidence visible in `Impact/risk`; detailed implementation context and verification evidence follow in collapsed HTML details blocks. Localized headings are fine for the visible human-facing sections, but the release-note headings below remain exact English for deterministic extraction.

- **Summary:** the problem and resulting behavior.
- **Rationale:** why the change is needed and the relevant decision or tradeoff.
- **Impact/risk:** practical user and technical impact, compatibility or rollout risk, safeguards, and any material verification gap.

### Release notes section

Write release notes from the final target merge-base-to-`HEAD` snapshot. Refresh them when the scope changes; do not append an implementation diary or preserve notes for removed work. The section has this shape:

```markdown
## Release notes

### New features
- User-facing entry ready to publish.

### Improvements
- User-facing entry ready to publish.

### Fixes
- User-facing entry ready to publish.

### Internal changes
- Entry for a material internal change that belongs in release communication.
```

Use only the category headings that have entries. Keep each bullet ready to publish and include availability, an off-by-default feature flag, or required user action in that bullet when applicable. Keep entry prose in the selected description language while preserving the exact English headings. When the final snapshot has no release impact, use exactly `No release impact.` under `## Release notes` and omit all category headings. Never infer no impact from a missing, malformed, or ambiguous section; require manual review instead.

Do not put JSON, a custom schema, duplicated machine payload, a level-2 heading, or a details block inside the release-note content. The consumer ends the section at the next level-2 heading or the first HTML `<details>` block, so place implementation context and detailed verification after the release notes in collapsed blocks such as:

```html
<details>
<summary>Implementation details</summary>

...technical context...
</details>

<details>
<summary>Verification — passed, failed, or incomplete</summary>

...commands, results, and remaining evidence...
</details>
```

Detailed verification may be collapsed, but its status and every material gap must remain visible in `Impact/risk`. Do not use an empty heading or a generic all-green claim in place of evidence.

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

## Release publication

For an authorized release, link the relevant merged PRs/MRs included in the released commit. Verify both merged state and inclusion. When several contributed, also link a comparison of the verified previous and current release tags. With no previous release, omit that comparison. Keep the notes concise; links provide the detail.
