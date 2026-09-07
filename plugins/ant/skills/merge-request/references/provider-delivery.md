# Provider delivery and observation

Use this reference for Create/update or Observe/status. Preview and conflict-only modes do not mutate providers or observe pipelines. Limit Create/update mutations to the resolved repository, branch, target, title, body, and explicitly requested readiness. Never add AI attribution or co-author trailers.

## Description

Every PR/MR body has four substantive sections, in any repository-local equivalent language or template:

- **Summary** states the problem and resulting behavior, with a concrete before/after where useful.
- **Rationale** explains why the change is needed and groups relevant changes by purpose.
- **Impact/risk** states material compatibility, rollout, dependency, and provider risks, or explicitly says that no material risk was identified.
- **Verification** records the checks actually run and their status, plus meaningful gaps, pending gates, or unavailable evidence.

Keep the body human-first and proportionate. Do not add empty headings, unnecessary detail, or a generic all-green claim. Material failures and gaps stay visible. Rebuild the body from the complete final merge-base-to-HEAD snapshot after any source change.

## Snapshot and description

Build the title and body from the complete final target merge-base-to-`HEAD` snapshot. If a CLI needs a file, use a task-specific directory from `mktemp -d`; the temporary file is never part of the worktree.

For Create/update, isolate scoped work before staging. Stage only the requested paths or hunks; if unrelated pre-staged or mixed work cannot be isolated, stop and report it. Run feasible targeted validation, or reuse fresh candidate-bound evidence when the operation made no content change.

For GitLab, inspect the existing MR before updating it. Use current `glab` help for uncertain flags:

```bash
mr_description="$(< "$description_path")"
glab mr create --title "type(scope): summary" --description "$mr_description" --target-branch <target> --draft --yes
glab mr update <id-or-branch> --title "type(scope): summary" --description "$mr_description" --yes
```

For GitHub:

```bash
gh pr create --title "type(scope): summary" --body-file "$description_path" --base <target> --draft
gh pr edit <id-or-url-or-branch> --title "type(scope): summary" --body-file "$description_path"
```

Omit `--draft` only when explicitly authorized to create ready. Metadata-only updates need no source commit or push.

## Exact-head observation

1. Set one finite total budget for registration and terminal observation for each attempt. Never reset it after a head or target change; a new head consumes the remaining budget.
2. Resolve the provider source head and actual tested SHA separately.
3. Observe only checks or a pipeline whose tested SHA is authoritatively mapped to that source head. Empty or absent checks are pending/unverified.
4. Re-read the provider head while observing. If it changes, follow the new head only within the remaining budget.
5. On failure or timeout, report the exact head, tested SHA, failing check/job and useful diagnostics. Classify current-diff, infrastructure, credentials, or external-state causes; do not retry.

GitLab normally uses the MR pipeline matching `diff_refs.head_sha` and `merge_request_event`; record its ID and tested SHA. GitHub requires the PR `headRefOid` and each check's actual commit OID to be kept separate, including an authoritative test-merge OID when exposed. Missing source-to-tested mapping, required test-merge data, or provider fields makes CI unverified.

CI can replace a local broad gate only when the final pushed tree matches the provider source head, the tested mapping is authoritative, coverage is equivalent or broader, required jobs are successful, and targeted/risk checks passed. Otherwise retain the local gate. Observe/status never fetches, retries, repairs, or mutates anything. During an already-authorized Create/update flow, an exact-head failure is diagnostic and returns to the integration owner for bounded repair under existing action-specific authority; Observe/status remains report-only. If an observation budget expires, hand the pending result back to the broader workflow and report when no permitted host continuation is available; never poll indefinitely or invent automation.
