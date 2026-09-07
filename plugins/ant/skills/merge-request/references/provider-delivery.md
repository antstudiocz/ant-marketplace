# Provider delivery and observation

Use this reference for Create/update or Observe/status. Preview and conflict-only modes do not mutate providers or observe pipelines. Limit Create/update mutations to the resolved repository, branch, target, title, body, and explicitly requested readiness. Never add AI attribution or co-author trailers.

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

1. Set one finite total budget for registration and terminal observation. Never reset it after a head change.
2. Resolve the provider source head and actual tested SHA separately.
3. Observe only checks or a pipeline whose tested SHA is authoritatively mapped to that source head. Empty or absent checks are pending/unverified.
4. Re-read the provider head while observing. If it changes, follow the new head only within the remaining budget.
5. On failure or timeout, report the exact head, tested SHA, failing check/job and useful diagnostics. Classify current-diff, infrastructure, credentials, or external-state causes; do not retry.

GitLab normally uses the MR pipeline matching `diff_refs.head_sha` and `merge_request_event`; record its ID and tested SHA. GitHub requires the PR `headRefOid` and each check's actual commit OID to be kept separate, including an authoritative test-merge OID when exposed. Missing source-to-tested mapping, required test-merge data, or provider fields makes CI unverified.

CI can replace a local broad gate only when the final pushed tree matches the provider source head, the tested mapping is authoritative, coverage is equivalent or broader, required jobs are successful, and targeted/risk checks passed. Otherwise retain the local gate. Observe/status never fetches, retries, repairs, or mutates anything.
