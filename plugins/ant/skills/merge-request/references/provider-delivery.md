# Provider Delivery And Observation

Use this reference for create/update or Observe/status. Preview and conflict-only modes do not use provider mutation or pipeline observation. Observe/status is purely diagnostic: dirty unrelated work is non-blocking, and it must not fetch, retry, invoke repair, or mutate anything. Keep create/update provider mutations limited to the resolved repository, source branch, target, title, body, and explicitly requested readiness.

## Description Files

When a provider CLI benefits from a file, create a task-specific temporary directory with `mktemp -d` and a descriptive filename, for example `description_path="$(mktemp -d)/<task-slug>-description.md"`. Do not use a fixed shared temporary description path. Remove the temporary artifact when safe; it is never part of the worktree.

## GitLab

Inspect an existing MR before updating it. For create/update, use current `glab` capabilities and verify uncertain flags with local help. Read the task-specific file into a variable when `glab` needs description text:

```bash
mr_description="$(< "$description_path")"
glab mr create --title "type(scope): summary" --description "$mr_description" --target-branch <target> --draft --yes
glab mr update <id-or-branch> --title "type(scope): summary" --description "$mr_description" --yes
```

Omit `--draft` only for explicitly ready creation. Change existing readiness only on explicit request. Metadata-only updates need no source commit or push.

## GitHub

```bash
gh pr create --title "type(scope): summary" --body-file "$description_path" --base <target> --draft
gh pr edit <id-or-url-or-branch> --title "type(scope): summary" --body-file "$description_path"
```

Omit `--draft` only for explicitly ready creation. Use readiness commands only for an explicit readiness change. Metadata-only updates need no source commit or push.

## Exact-Head Observation (Create/update Or Observe/status)

1. Establish one finite overall deadline or budget from repository guidance, or use a conservative bounded default. This single budget covers registration and terminal observation; never reset or extend it after a head change.
2. Resolve the provider object's current head SHA.
3. Until the deadline, wait for matching checks/pipeline to register, then observe only that exact head. Empty rollups or missing pipelines are pending/unverified, never success.
4. Bound every poll/watch command by the remaining budget; never use an indefinite watch.
5. Re-read the provider head while observing. If it changes, switch to the new head only within remaining time and report the final observed head truthfully.
6. On terminal failure/cancellation, capture failing check/job identity and useful diagnostics. Classify current-diff regression, flaky/infrastructure, credentials, or external state. Neither create/update nor Observe/status authorizes retry. Observe/status may only describe/recommend a future repair handoff and requires a separate user fix request before invoking `implementation-orchestrator`; an authorized create/update regression may return to that workflow for repair.

For GitHub, resolve `headRefOid` and poll checks for that OID. For GitLab, resolve `diff_refs.head_sha`, select a matching MR pipeline (normally `merge_request_event`), capture its exact pipeline ID, and poll that ID. Observe/status never stages, commits, pushes, creates, updates, fetches, changes readiness, retries, invokes repair, or mutates the worktree/provider.

If registration or terminal observation exceeds the budget, report the exact head and last known state as unverified external state, specifically `no pipeline/checks registered` when none appeared. Never report green from absence or from a different head.
